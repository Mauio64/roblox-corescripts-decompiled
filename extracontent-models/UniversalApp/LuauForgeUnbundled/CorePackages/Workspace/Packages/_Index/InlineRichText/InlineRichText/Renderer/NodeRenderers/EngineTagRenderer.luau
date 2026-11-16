local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

return function(p2, p3)
	local v5 = { name = p2.name, attributes = p2.attributes }

	local v6 = p3.processChildren(p2, p3)

	return Cryo.List.map(v6, function(p4)
		return {
			text = p4.text,
			engineTags = Cryo.List.join(p4.engineTags, { v5 })
		}
	end)
end
