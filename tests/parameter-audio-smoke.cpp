#include "JSIF_processor.h"
#include "JSIF_cids.h"

#include "public.sdk/source/vst/hosting/hostclasses.h"
#include "public.sdk/source/vst/hosting/parameterchanges.h"
#include <iostream>
#include <map>
#include <vector>
#include <cmath>
using namespace Steinberg; using namespace Steinberg::Vst; using namespace yg331;
struct Result { std::vector<float> audio; uint32 latency; bool finite = true; };
Result render(int channels, double rate, std::map<ParamID,double> params, double amplitude = .7) {
    HostApplication host; auto p = owned(new JSIF_Processor); p->initialize(&host);
    SpeakerArrangement arr = channels == 1 ? SpeakerArr::kMono : SpeakerArr::kStereo;
    p->setBusArrangements(&arr,1,&arr,1); ProcessSetup setup{kRealtime,kSample32,256,rate};
    p->setupProcessing(setup); p->setActive(true); p->setProcessing(true);
    float in[2][256],out[2][256]; float* ins[]{in[0],in[1]};float* outs[]{out[0],out[1]};
    AudioBusBuffers input{},output{};input.numChannels=output.numChannels=channels;
    input.channelBuffers32=ins;output.channelBuffers32=outs;
    ParameterChanges changes; int32 idx,point;
    for(auto [id,value]:params) changes.addParameterData(id,idx)->addPoint(0,value,point);
    ProcessData d{};d.symbolicSampleSize=kSample32;d.numInputs=d.numOutputs=1;d.numSamples=256;
    d.inputs=&input;d.outputs=&output;d.inputParameterChanges=&changes;
    Result result;
    for(int b=0;b<32;++b){
      for(int c=0;c<channels;++c)for(int i=0;i<256;++i){double t=(b*256+i)/rate;in[c][i]=amplitude*(.7*std::sin(2*M_PI*997*t+c*.3)+.3*std::sin(2*M_PI*7501*t));}
      p->process(d); d.inputParameterChanges=nullptr;
      for(int c=0;c<channels;++c)for(float v:out[c]){result.finite &= std::isfinite(v); if(b>15)result.audio.push_back(v);}
    }
    result.latency=p->getLatencySamples();p->setProcessing(false);p->setActive(false);p->terminate();return result;
}
double delta(const Result&a,const Result&b){double s=0;for(size_t i=0;i<a.audio.size();++i)s+=std::abs(a.audio[i]-b.audio[i]);return s/a.audio.size();}
int main(){int failures=0;
 for(double rate:{44100.,48000.,96000.})for(int ch:{1,2}){
  auto check=[&](const char*name,std::map<ParamID,double>a,std::map<ParamID,double>b,double amp=.7,bool difference=true){
   auto x=render(ch,rate,a,amp),y=render(ch,rate,b,amp);double d=delta(x,y);
   bool ok=x.finite&&y.finite&&(difference?d>1e-5:d<1e-7);failures+=!ok;
   std::cout<<rate<<"Hz "<<ch<<"ch "<<name<<" delta="<<d<<" latency="<<x.latency<<","<<y.latency<<(ok?" PASS\n":" FAIL\n");};
  check("Input",{{kParamInput,0}},{{kParamInput,.5}});
  check("Output",{{kParamOutput,0}},{{kParamOutput,1}});
  check("Effect",{{kParamEffect,0}},{{kParamEffect,1}});
  check("Curve",{{kParamEffect,1},{kParamCurve,0}},{{kParamEffect,1},{kParamCurve,1}});
  check("Clip",{{kParamClip,0}},{{kParamClip,1}},1.8);
  check("Split",{{kParamEffect,1},{kParamSplit,0}},{{kParamEffect,1},{kParamSplit,1}});
  check("In",{{kParamEffect,1},{kParamIn,0}},{{kParamEffect,1},{kParamIn,1}});
  check("Bypass",{{kParamEffect,1},{kParamOutput,.5},{kParamBypass,0}},{{kParamEffect,1},{kParamOutput,.5},{kParamBypass,1}});
  for(int n=1;n<=3;++n){std::string label="OS x"+std::to_string(1<<n);check(label.c_str(),{{kParamEffect,1},{kParamOS,0}},{{kParamEffect,1},{kParamOS,n/3.}});}
  for(int n=1;n<=3;++n){std::string label="Phase at x"+std::to_string(1<<n);check(label.c_str(),{{kParamEffect,1},{kParamOS,n/3.},{kParamPhase,0}},{{kParamEffect,1},{kParamOS,n/3.},{kParamPhase,1}});}
  check("Curve with Effect=0 (expected no change)",{{kParamEffect,0},{kParamCurve,0}},{{kParamEffect,0},{kParamCurve,1}},.7,false);
  check("Phase at x1 (expected no change)",{{kParamOS,0},{kParamPhase,0}},{{kParamOS,0},{kParamPhase,1}},.7,false);
 }
 std::cout<<"Failures: "<<failures<<"\n";return failures?1:0;
}
