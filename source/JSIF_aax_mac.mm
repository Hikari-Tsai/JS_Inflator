#include "JSIF_aax_mac.h"
#include "vstgui/lib/platform/mac/cocoa/nsviewframe.h"
#import <QuartzCore/QuartzCore.h>

namespace JSIF {
void synchronizeAAXDrawingLayer(VSTGUI::IPlatformFrame* frame)
{
    auto* cocoaFrame = dynamic_cast<VSTGUI::NSViewFrame*>(frame);
    if (!cocoaFrame) return;
    CALayer* drawingLayer = cocoaFrame->getCALayer();
    NSView* view = cocoaFrame->getNSView();
    if (!drawingLayer || !view.layer) return;
    const CGRect bounds = view.layer.bounds;
    if (CGRectEqualToRect(drawingLayer.frame, bounds)) return;

    // Pro Tools autoresizes the NSView before VSTGUI receives setSize().
    // VSTGUI then returns early, leaving its separate drawing layer at the
    // old size. Synchronize only on a mismatch; normal dirty drawing remains.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    drawingLayer.frame = bounds;
    [drawingLayer setNeedsDisplay];
    [CATransaction commit];
}
}
