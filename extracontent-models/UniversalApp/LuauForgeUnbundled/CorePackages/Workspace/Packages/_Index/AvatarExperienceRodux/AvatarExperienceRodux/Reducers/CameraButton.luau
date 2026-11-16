local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/RoduxTypes")
local SetCameraButtonStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCameraButtonStatus")
local SetCameraButtonErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCameraButtonErrorOccurred")

return (Rodux.createReducer({ enabled = false, errorOccurred = false }, {
	[SetCameraButtonStatus.name] = function(p2, p3)
		return (Cryo.Dictionary.join(p2, { enabled = p3.status }))
	end,
	[SetCameraButtonErrorOccurred.name] = function(p2, p3)
		return (Cryo.Dictionary.join(p2, { errorOccurred = p3.errorOccurred }))
	end
}))
