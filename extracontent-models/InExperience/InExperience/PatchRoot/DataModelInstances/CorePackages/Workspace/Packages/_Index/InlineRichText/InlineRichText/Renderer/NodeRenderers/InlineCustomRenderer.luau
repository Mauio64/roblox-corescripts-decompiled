local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)
require(InlineRichText.Types)

local Cryo = require(parent.Cryo)

return function(p, p2)
	local inlineCustomRenderer = p2.inlineCustomRenderers[p.name]

	if inlineCustomRenderer and typeof(inlineCustomRenderer) == "function" then
		return inlineCustomRenderer(p, Cryo.Dictionary.join(p2, {
			nodeProps = p2.nodeProps[p.name] or {}
		}))
	end

	v:warning(`Node {p.name}: No custom renderer found. For custom tags, you must provide a renderer function in the renderers prop`)

	return {}
end
