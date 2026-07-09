local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local Cryo = require(InlineRichTextParent.Cryo)

require(InlineRichText.Types)

return function(p1, p2) -- line: 7
	-- upvalues: Cryo (copy)
	local t1 = {
		name = p1.name,
		attributes = p1.attributes
	}
	local v7 = p2.processChildren(p1, p2)

	return Cryo.List.map(v7, function(p3) -- line: 14
		-- upvalues: Cryo (copy), t1 (copy)
		return {
			text = p3.text,
			engineTags = Cryo.List.join(p3.engineTags, { t1 })
		}
	end)
end
