// Exercises the same UI-thread-only ConnectionProxy used by Steinberg's AAX wrapper.
#include "JSIF_processor.h"
#include "public.sdk/source/vst/hosting/hostclasses.h"
#include "public.sdk/source/vst/hosting/connectionproxy.h"
#include <CoreFoundation/CoreFoundation.h>
#include <thread>
#include <iostream>
#include <cstring>
using namespace Steinberg;
using namespace Steinberg::Vst;
struct MeterReceiver : ComponentBase {
    int updates = 0;
    double input = 0, output = 0;
    tresult PLUGIN_API notify(IMessage* message) override {
        if (std::strcmp(message->getMessageID(), "VUmeter") == 0) {
            message->getAttributes()->getFloat("vuInL", input);
            message->getAttributes()->getFloat("vuOutL", output);
            int64 update = 0;
            if (message->getAttributes()->getInt("update", update) == kResultOk) ++updates;
        }
        return kResultOk;
    }
};
int main() {
    bool passed = true;
    for (int channels : {1, 2}) {
        HostApplication host;
        auto processor = owned(new yg331::JSIF_Processor);
        auto receiver = owned(new MeterReceiver);
        processor->initialize(&host);
        auto proxy = owned(new ConnectionProxy(processor));
        proxy->connect(receiver);
        SpeakerArrangement arrangement = channels == 1 ? SpeakerArr::kMono : SpeakerArr::kStereo;
        processor->setBusArrangements(&arrangement, 1, &arrangement, 1);
        ProcessSetup setup {kRealtime, kSample32, 256, 48000};
        processor->setupProcessing(setup);
        processor->setActive(true);
        processor->setProcessing(true);
        float in[2][256], out[2][256] {};
        for (auto& channel : in) for (int i = 0; i < 256; ++i) channel[i] = 0.2f * std::sin(i * 0.1f);
        float* inputs[] = {in[0], in[1]};
        float* outputs[] = {out[0], out[1]};
        AudioBusBuffers input {}, output {};
        input.numChannels = output.numChannels = channels;
        input.channelBuffers32 = inputs; output.channelBuffers32 = outputs;
        ProcessData data {};
        data.processMode = kRealtime; data.symbolicSampleSize = kSample32;
        data.numSamples = 256; data.numInputs = data.numOutputs = 1;
        data.inputs = &input; data.outputs = &output;
        std::thread audio([&] { for (int i = 0; i < 100; ++i) processor->process(data); });
        audio.join();
        bool noAudioThreadUI = receiver->updates == 0;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.15, false);
        double peak = 0;
        for (int c = 0; c < channels; ++c) for (float sample : out[c]) peak = std::max(peak, std::abs(double(sample)));
        bool ok = noAudioThreadUI && peak > 0.01 && receiver->updates > 0 && receiver->input > 0 && receiver->output > 0;
        std::cout << channels << "ch: output peak=" << peak << " meter updates=" << receiver->updates
                  << " input meter=" << receiver->input << " output meter=" << receiver->output
                  << (ok ? " PASS\n" : " FAIL\n");
        passed &= ok;
        processor->setProcessing(false); processor->setActive(false);
        proxy->disconnect(); processor->terminate();
    }
    return passed ? 0 : 1;
}
