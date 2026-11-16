local Constants = require(script.Parent.Parent.Constants)

local function computeFocusAngleAboveCenterRad(data)
	local cameraFieldOfViewDeg = math.rad(data.cameraFieldOfViewDeg or Constants.CameraFieldOfViewDeg)
	local v = data.viewportHeightPix / 2 / math.tan(cameraFieldOfViewDeg / 2)
	return (math.atan2(data.viewportHeightPix / 2 - (data.cutoutTopOffsetPix + data.cutoutDiameterPix / 2), v))
end

return computeFocusAngleAboveCenterRad
