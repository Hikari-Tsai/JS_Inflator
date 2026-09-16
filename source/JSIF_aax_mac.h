#pragma once

namespace VSTGUI { class IPlatformFrame; }
namespace JSIF {
// Repair VSTGUI's drawing layer after a host-driven NSView resize.
void synchronizeAAXDrawingLayer(VSTGUI::IPlatformFrame* frame);
}
