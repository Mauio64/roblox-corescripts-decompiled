local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

require(AvatarExperienceRodux.Types.RoduxTypes)
local SetCameraButtonStatus = require(AvatarExperienceRodux.Actions.SetCameraButtonStatus)
local SetCameraButtonErrorOccurred = require(AvatarExperienceRodux.Actions.SetCameraButtonErrorOccurred)

return (Rodux.createReducer({ enabled = false, errorOccurred = false }, {
	[SetCameraButtonStatus.name] = function(p, p2)
		return (Cryo.Dictionary.join(p, { enabled = p2.status }))
	end,
	[SetCameraButtonErrorOccurred.name] = function(p, p2)
		return (Cryo.Dictionary.join(p, { errorOccurred = p2.errorOccurred }))
	end
}))
