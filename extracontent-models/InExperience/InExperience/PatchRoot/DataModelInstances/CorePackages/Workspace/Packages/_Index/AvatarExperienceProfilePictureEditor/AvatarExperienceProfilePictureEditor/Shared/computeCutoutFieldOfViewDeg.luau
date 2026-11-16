local Constants = require(script.Parent.Parent.Constants)

local function computeCutoutFieldOfViewDeg(data)
	local cameraFieldOfViewDeg = data.cameraFieldOfViewDeg or Constants.CameraFieldOfViewDeg
	local viewportHeightPix = data.viewportHeightPix
	local cutoutTopOffsetPix = data.cutoutTopOffsetPix
	local cutoutDiameterPix = data.cutoutDiameterPix

	local v = math.rad(cameraFieldOfViewDeg)
	local v2 = viewportHeightPix / 2 / math.tan(v / 2)
	local v3 = viewportHeightPix / 2 - cutoutTopOffsetPix
	local v4 = v3 - cutoutDiameterPix
	return (math.deg(math.atan2(v3, v2) - math.atan2(v4, v2)))
end

return computeCutoutFieldOfViewDeg
