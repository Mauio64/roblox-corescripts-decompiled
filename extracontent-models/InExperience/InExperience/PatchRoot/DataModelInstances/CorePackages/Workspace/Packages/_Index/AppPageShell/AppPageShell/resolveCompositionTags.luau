local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local AppComposition = require(parent.AppComposition)

require(AppPageShell.PageTypes)

local CompositionTags = AppComposition.CompositionTags

local frozen = table.freeze({})

local function resolveCompositionTags(p)
	if p and p.enabled == false then
		return frozen
	end

	local layout = p and p.layout or CompositionTags.Layout.Discovery

	return {
		root = `{CompositionTags.ContentRegion.Root} {layout}`,
		body = CompositionTags.ContentRegion.Body,
		header = CompositionTags.ContentRegion.Header
	}
end

return resolveCompositionTags
