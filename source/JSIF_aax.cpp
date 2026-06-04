//------------------------------------------------------------------------
// AAX description for the Steinberg VST3-to-AAX wrapper.
//------------------------------------------------------------------------

#include "JSIF_cids.h"
#include "pluginterfaces/base/futils.h"
#include "public.sdk/source/vst/aaxwrapper/aaxwrapper_description.h"

using namespace yg331;

namespace {

constexpr Steinberg::uint32 kInitialLatency = 0;

AAX_Plugin_Desc pluginDescriptions[] = {
	{
		"io.github.yg331.JSInflator.mono",
		"JS Inflator",
		CCONST ('J', 'I', 'N', '1'),
		CCONST ('J', 'I', 'A', '1'),
		1,
		1,
		0,
		nullptr,
		nullptr,
		nullptr,
		kInitialLatency,
	},
	{
		"io.github.yg331.JSInflator.stereo",
		"JS Inflator",
		CCONST ('J', 'I', 'N', '2'),
		CCONST ('J', 'I', 'A', '2'),
		2,
		2,
		0,
		nullptr,
		nullptr,
		nullptr,
		kInitialLatency,
	},
	{nullptr, nullptr, 0, 0, 0, 0, 0, nullptr, nullptr, nullptr, 0},
};

AAX_Effect_Desc effectDescription = {
	"yg331",
	"JS Inflator",
	CCONST ('Y', 'G', '3', '1'),
	CCONST ('J', 'S', 'I', 'F'),
	JSIF_VST3Category,
	{0},
	0x02000302,
	nullptr,
	pluginDescriptions,
};

} // namespace

// Force the Steinberg AAX wrapper into the final plug-in binary.
int* forceLinkAAXWrapper = &AAXWrapper_linkAnchor;

AAX_Effect_Desc* AAXWrapper_GetDescription ()
{
	kJSIF_ProcessorUID.toTUID (effectDescription.mVST3PluginID);
	return &effectDescription;
}
