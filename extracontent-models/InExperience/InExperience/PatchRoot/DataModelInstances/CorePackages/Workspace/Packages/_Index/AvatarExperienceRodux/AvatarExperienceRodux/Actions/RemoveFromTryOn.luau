local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

if require(Parent.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping then
	return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 14
		return {
			itemId = p1,
			itemType = p2
		}
	end)
end

return Rodux.makeActionCreator(script.Name, function(p3) -- line: 22
	return {
		itemId = p3
	}
end)
