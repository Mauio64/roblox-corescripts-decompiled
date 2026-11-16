local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")

local v5 = {}

function v5.clampYRotDeg(value)
	return (math.clamp(value, -Constants.YRotMaxDeg, Constants.YRotMaxDeg))
end

function v5.clampDistanceScale(value)
	return (math.clamp(value, Constants.ZoomMinScale, Constants.ZoomMaxScale))
end

function v5.getSliderValueFromYRotDeg(p2)
	return (math.clamp(p2 * Constants.SliderMax / Constants.YRotMaxDeg, -Constants.SliderMax, Constants.SliderMax))
end

function v5.getYRotDegFromSliderValue(p2)
	return (math.clamp(p2 * Constants.YRotMaxDeg / Constants.SliderMax, -Constants.YRotMaxDeg, Constants.YRotMaxDeg))
end

function v5.getCameraDistanceScaleFromSliderValue(p2)
	local v6 = -p2 / Constants.SliderMax + 1
	return (1 - Constants.ZoomMinScale) * v6 * v6 + Constants.ZoomMinScale
end

function v5.getSliderValueFromCameraDistanceScale(p2)
	return (math.clamp(
		(math.sqrt((math.max(0, (p2 - Constants.ZoomMinScale) / (1 - Constants.ZoomMinScale)))) - 1) * -Constants.SliderMax,
		-Constants.SliderMax,
		Constants.SliderMax
	))
end

function v5.adjustDistanceScaleByZoomGesture(p2, p3)
	local v6 = math.clamp(
		v5.getSliderValueFromCameraDistanceScale(p2) + p3 * 2,
		-Constants.SliderMax,
		Constants.SliderMax
	)
	return v5.clampDistanceScale(v5.getCameraDistanceScaleFromSliderValue(v6))
end

function v5.adjustDistanceScaleBySliderStep(p2, p3)
	local v6 = math.clamp(
		v5.getSliderValueFromCameraDistanceScale(p2) + p3,
		-Constants.SliderMax,
		Constants.SliderMax
	)
	return v5.clampDistanceScale(v5.getCameraDistanceScaleFromSliderValue(v6))
end

v5.PINCH_DELTA_TO_ZOOM_DELTA = 0.05

return v5
