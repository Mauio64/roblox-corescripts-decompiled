local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local Cryo = require(parent.Cryo)
require(InlineRichText.Types)

return function(p, p2)
	local v = { name = p.name, attributes = p.attributes }

	local v2 = p2.processChildren(p, p2)

	return Cryo.List.map(v2, function(p3)
		return {
			text = p3.text,
			engineTags = Cryo.List.join(p3.engineTags, { v })
		}
	end)
end
