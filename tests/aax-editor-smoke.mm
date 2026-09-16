#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#include "JSIF_controller.h"
#include "JSIF_cids.h"
#include "public.sdk/source/vst/hosting/hostclasses.h"
#include "vstgui/lib/vstguiinit.h"
#include "vstgui/lib/platform/mac/cocoa/nsviewframe.h"
#include <cstdio>
using namespace Steinberg;
void* moduleHandle = nullptr;
struct ResizeHost : IPlugFrame {
    tresult PLUGIN_API queryInterface(const TUID, void** out) override { *out=nullptr; return kNoInterface; }
    uint32 PLUGIN_API addRef() override { return 1; }
    uint32 PLUGIN_API release() override { return 1; }
    tresult PLUGIN_API resizeView(IPlugView* view, ViewRect* rect) override {
        auto* editor=dynamic_cast<VSTGUI::GUIEditor*>(view);
        if(editor && editor->getFrame()) {
            auto* native=dynamic_cast<VSTGUI::NSViewFrame*>(editor->getFrame()->getPlatformFrame());
            if(native) [native->getNSView() setFrameSize:NSMakeSize(rect->getWidth(),rect->getHeight())];
        }
        return view->onSize(rect);
    }
};
static void pump() { CFRunLoopRunInMode(kCFRunLoopDefaultMode,0.2,false); }
int main(int argc,char**argv) {
    if(argc!=2)return 2;
    @autoreleasepool {
        [NSApplication sharedApplication];
        NSURL* url=[NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
        CFBundleRef bundle=CFBundleCreate(nullptr,(CFURLRef)url);
        VSTGUI::init(bundle);
        Vst::HostApplication host;
        auto controller=Steinberg::owned(new yg331::JSIF_Controller);
        if(controller->initialize(&host)!=kResultOk)return 3;
        NSView* parent=[[NSView alloc] initWithFrame:NSMakeRect(0,0,1200,1200)];
        ResizeHost resizeHost;
        int failures=0;
        auto check=[&](VSTGUI::GUIEditor* editor,const char* label) {
            pump();
            auto* native=dynamic_cast<VSTGUI::NSViewFrame*>(editor->getFrame()->getPlatformFrame());
            NSSize viewSize=native->getNSView().bounds.size;
            NSSize layerSize=native->getCALayer().frame.size;
            bool ok=NSEqualSizes(viewSize,layerSize);
            printf("%s %s view %.0fx%.0f layer %.0fx%.0f zoom %.2f parameter %.3f\n",ok?"PASS":"FAIL",label,viewSize.width,viewSize.height,layerSize.width,layerSize.height,editor->getZoomFactor(),controller->getParamNormalized(yg331::kParamZoom));
            failures+=!ok;
        };
        auto view=Steinberg::owned(controller->createView(Vst::ViewType::kEditor));
        auto* editor=dynamic_cast<VSTGUI::GUIEditor*>(view.get());
        view->setFrame(&resizeHost);
        if(view->attached(parent,kPlatformTypeNSView)!=kResultOk)return 4;
        check(editor,"Original");
        controller->setParamNormalized(yg331::kGuiSwitch,1);
        check(editor,"Twarch");
        editor->setZoomFactor(0.75);
        check(editor,"Twarch 75%");
        failures+=std::abs(controller->getParamNormalized(yg331::kParamZoom)-1.0/6.0)>1e-6;
        controller->setParamNormalized(yg331::kGuiSwitch,0);
        check(editor,"Original return");
        view->removed(); view->setFrame(nullptr); view=nullptr;
        view=Steinberg::owned(controller->createView(Vst::ViewType::kEditor));
        editor=dynamic_cast<VSTGUI::GUIEditor*>(view.get());
        view->setFrame(&resizeHost);
        if(view->attached(parent,kPlatformTypeNSView)!=kResultOk)return 5;
        check(editor,"Reopened 75%");
        failures+=std::abs(editor->getZoomFactor()-0.75)>1e-6;
        view->removed(); view->setFrame(nullptr); view=nullptr;
        controller->terminate(); controller=nullptr;
        [parent release]; VSTGUI::exit(); CFRelease(bundle);
        printf("Failures: %d\n",failures);
        return failures?1:0;
    }
}
