local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Cryo = require(AvatarExperienceRoduxParent.Cryo)
local Rodux = require(AvatarExperienceRoduxParent.Rodux)

require(AvatarExperienceRodux.Types.RoduxTypes)

local SetCameraButtonStatus = require(AvatarExperienceRodux.Actions.SetCameraButtonStatus)
local SetCameraButtonErrorOccurred = require(AvatarExperienceRodux.Actions.SetCameraButtonErrorOccurred)
local t1 = {
	enabled = false,
	errorOccurred = false
}

return (Rodux.createReducer(t1, {
	[SetCameraButtonStatus.name] = function(p1, p2) -- line: 25
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(p1, {
			enabled = p2.status
		}))
	end,
	[SetCameraButtonErrorOccurred.name] = function(p3, p4) -- line: 32
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(p3, {
			errorOccurred = p4.errorOccurred
		}))
	end
}))
