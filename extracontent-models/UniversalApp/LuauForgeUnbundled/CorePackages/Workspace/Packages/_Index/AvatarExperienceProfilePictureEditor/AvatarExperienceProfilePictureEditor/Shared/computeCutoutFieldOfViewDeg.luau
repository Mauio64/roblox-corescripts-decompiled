local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")

local function computeCutoutFieldOfViewDeg(data)
	local cameraFieldOfViewDeg = data.cameraFieldOfViewDeg or Constants.CameraFieldOfViewDeg
	local viewportHeightPix = data.viewportHeightPix
	local cutoutTopOffsetPix = data.cutoutTopOffsetPix
	local cutoutDiameterPix = data.cutoutDiameterPix

	local v5 = math.rad(cameraFieldOfViewDeg)
	local v6 = viewportHeightPix / 2 / math.tan(v5 / 2)
	local v7 = viewportHeightPix / 2 - cutoutTopOffsetPix
	local v8 = v7 - cutoutDiameterPix
	return (math.deg(math.atan2(v7, v6) - math.atan2(v8, v6)))
end

return computeCutoutFieldOfViewDeg
