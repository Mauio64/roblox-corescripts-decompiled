local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")

local function computeFocusAngleAboveCenterRad(data)
	local cameraFieldOfViewDeg = math.rad(data.cameraFieldOfViewDeg or Constants.CameraFieldOfViewDeg)
	local v5 = data.viewportHeightPix / 2 / math.tan(cameraFieldOfViewDeg / 2)
	return (math.atan2(
		data.viewportHeightPix / 2 - (data.cutoutTopOffsetPix + data.cutoutDiameterPix / 2),
		v5
	))
end

return computeFocusAngleAboveCenterRad
