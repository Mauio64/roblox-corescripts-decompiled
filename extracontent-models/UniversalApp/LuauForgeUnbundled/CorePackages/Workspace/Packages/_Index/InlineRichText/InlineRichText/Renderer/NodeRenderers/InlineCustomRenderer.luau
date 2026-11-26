local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("InlineCustomRenderer")
require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")

return function(p2, p3)
	local inlineCustomRenderer = p3.inlineCustomRenderers[p2.name]

	if inlineCustomRenderer and typeof(inlineCustomRenderer) == "function" then
		return inlineCustomRenderer(p2, Cryo.Dictionary.join(p3, {
			nodeProps = p3.nodeProps[p2.name] or {}
		}))
	end

	v5:warning(`Node {p2.name}: No custom renderer found. For custom tags, you must provide a renderer function in the renderers prop`)

	return {}
end
