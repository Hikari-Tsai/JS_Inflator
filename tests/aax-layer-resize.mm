#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#include "vstgui/lib/cframe.h"
#include "vstgui/lib/vstguiinit.h"
#include "vstgui/lib/platform/mac/cocoa/nsviewframe.h"
#include <cstdio>
#ifdef JSIF_TEST_LAYER_FIX
#include "JSIF_aax_mac.h"
#endif

// Reproduce the host resizing the NSView before VSTGUI's setSize callback.
int main() {
    @autoreleasepool {
        [NSApplication sharedApplication];
        VSTGUI::init(CFBundleGetMainBundle());
        NSView* parent = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1000, 1000)];
        auto* frame = new VSTGUI::CFrame(VSTGUI::CRect(0, 0, 240, 400), nullptr);
        if (!frame->open(parent)) return 2;
        auto* platform = dynamic_cast<VSTGUI::NSViewFrame*>(frame->getPlatformFrame());
        if (!platform || !platform->getCALayer()) return 3;
        int failed = 0;
        for (NSSize size : {NSMakeSize(650,650), NSMakeSize(975,975), NSMakeSize(240,400)}) {
            [platform->getNSView() setFrameSize:size];
            frame->setSize(size.width, size.height);
#ifdef JSIF_TEST_LAYER_FIX
            JSIF::synchronizeAAXDrawingLayer(frame->getPlatformFrame());
#endif
            auto actual = platform->getCALayer().frame.size;
            bool pass = NSEqualSizes(actual,size);
            std::printf("%s requested %.0fx%.0f, drawing layer %.0fx%.0f\n", pass ? "PASS" : "FAIL",size.width,size.height,actual.width,actual.height);
            failed += !pass;
        }
        frame->close();
        frame->forget();
        [parent release];
        VSTGUI::exit();
        return failed ? 1 : 0;
    }
}
