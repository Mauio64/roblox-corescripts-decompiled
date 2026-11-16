local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		type = script.Name,
		isUndo = data.isUndo,
		equipped = data.equipped,
		tryOn = data.tryOn
	}
end)
