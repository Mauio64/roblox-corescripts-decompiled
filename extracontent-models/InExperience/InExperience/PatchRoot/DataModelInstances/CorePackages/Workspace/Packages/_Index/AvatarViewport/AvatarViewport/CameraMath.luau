local Constants = require(script.Parent.Constants)

local CameraMath = {}

function CameraMath.clampYRotDeg(value: number)
	return (math.clamp(value, -Constants.YRotMaxDeg, Constants.YRotMaxDeg))
end

function CameraMath.clampDistanceScale(value: number)
	return (math.clamp(value, Constants.ZoomMinScale, Constants.ZoomMaxScale))
end

function CameraMath.getSliderValueFromYRotDeg(p: number)
	return (math.clamp(p * Constants.SliderMax / Constants.YRotMaxDeg, -Constants.SliderMax, Constants.SliderMax))
end

function CameraMath.getYRotDegFromSliderValue(p: number)
	return (math.clamp(p * Constants.YRotMaxDeg / Constants.SliderMax, -Constants.YRotMaxDeg, Constants.YRotMaxDeg))
end

function CameraMath.getCameraDistanceScaleFromSliderValue(p: number)
	local v = -p / Constants.SliderMax + 1
	return (1 - Constants.ZoomMinScale) * v * v + Constants.ZoomMinScale
end

function CameraMath.getSliderValueFromCameraDistanceScale(p: number)
	return (math.clamp(
		(math.sqrt((math.max(0, (p - Constants.ZoomMinScale) / (1 - Constants.ZoomMinScale)))) - 1) * -Constants.SliderMax,
		-Constants.SliderMax,
		Constants.SliderMax
	))
end

function CameraMath.adjustDistanceScaleByZoomGesture(p: number, p2: number)
	local v = math.clamp(
		CameraMath.getSliderValueFromCameraDistanceScale(p) + p2 * 2,
		-Constants.SliderMax,
		Constants.SliderMax
	)
	return CameraMath.clampDistanceScale(CameraMath.getCameraDistanceScaleFromSliderValue(v))
end

function CameraMath.adjustDistanceScaleBySliderStep(p: number, p2: number)
	local v = math.clamp(
		CameraMath.getSliderValueFromCameraDistanceScale(p) + p2,
		-Constants.SliderMax,
		Constants.SliderMax
	)
	return CameraMath.clampDistanceScale(CameraMath.getCameraDistanceScaleFromSliderValue(v))
end

CameraMath.PINCH_DELTA_TO_ZOOM_DELTA = 0.05

return CameraMath
