local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local v3 = require(InlineRichText.Logger):new(script.Name)

require(InlineRichText.Types)

local Cryo = require(InlineRichTextParent.Cryo)

return function(p1, p2) -- line: 9
	-- upvalues: v3 (copy), Cryo (copy)
	local v7 = p2.inlineCustomRenderers[p1.name]

	if not v7 or typeof(v7) ~= "function" then
		v3:warning(`Node { p1.name }: No custom renderer found. For custom tags, you must provide a renderer function in the renderers prop`)

		return {}
	end

	return v7(p1, Cryo.Dictionary.join(p2, {
		nodeProps = p2.nodeProps[p1.name] or {}
	}))
end
