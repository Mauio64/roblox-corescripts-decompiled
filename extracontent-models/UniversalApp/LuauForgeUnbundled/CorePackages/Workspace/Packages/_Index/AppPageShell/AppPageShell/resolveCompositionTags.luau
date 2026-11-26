local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/AppComposition")

require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageTypes")

local compositionTags = AppComposition.CompositionTags

local frozen = table.freeze({})

local function resolveCompositionTags(p2)
	if p2 and p2.enabled == false then
		return frozen
	end

	local layout = p2 and p2.layout or compositionTags.Layout.Discovery

	return {
		root = `{compositionTags.ContentRegion.Root} {layout}`,
		body = compositionTags.ContentRegion.Body,
		header = compositionTags.ContentRegion.Header
	}
end

return resolveCompositionTags
