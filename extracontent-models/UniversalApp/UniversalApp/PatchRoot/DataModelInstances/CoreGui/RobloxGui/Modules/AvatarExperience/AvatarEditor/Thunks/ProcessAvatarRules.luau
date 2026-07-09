local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetAvatarSettings = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarSettings)
local SetDefaultBodyColorRanges = require(Modules.AvatarExperience.AvatarEditor.Actions.SetDefaultBodyColorRanges)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)

return function(p1) -- line: 7
	-- upvalues: SetAvatarSettings (copy), SetDefaultBodyColorRanges (copy), Constants (copy)
	return function(p2) -- line: 8
		-- upvalues: p1 (copy), SetAvatarSettings (copy), SetDefaultBodyColorRanges (copy), Constants (copy)
		local minimumDeltaEBodyColorDifference = p1.minimumDeltaEBodyColorDifference
		local scales = p1.scales
		local accessoryRefinementTypes = p1.accessoryRefinementTypes
		local accessoryRefinementLowerBounds = p1.accessoryRefinementLowerBounds
		local accessoryRefinementUpperBounds = p1.accessoryRefinementUpperBounds

		p2:dispatch(SetAvatarSettings(minimumDeltaEBodyColorDifference, scales, accessoryRefinementTypes, accessoryRefinementLowerBounds, accessoryRefinementUpperBounds))
		p2:dispatch(SetDefaultBodyColorRanges(Constants.DefaultBodyColorRanges))
	end
end
