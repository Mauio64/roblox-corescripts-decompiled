local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local AvatarViewport = require(parent.AvatarViewport)

local CameraMath = AvatarViewport.CameraMath

local yRotDegFromSliderValue = CameraMath.getYRotDegFromSliderValue(1)

local function useRotatableAvatarPreviewViewModel(data)
	local v = Responsive.useLastInput()

	return {
		showCameraControlBar = not data.isDisabled and v ~= Responsive.Input.Touch,
		onZoomIn = React.useCallback(function()
			data.onDistanceScaleChanged(CameraMath.adjustDistanceScaleBySliderStep(data.distanceScale, 1))
		end, { data.distanceScale, data.onDistanceScaleChanged }),
		onZoomOut = React.useCallback(function()
			data.onDistanceScaleChanged(CameraMath.adjustDistanceScaleBySliderStep(data.distanceScale, -1))
		end, { data.distanceScale, data.onDistanceScaleChanged }),
		onRotateLeft = React.useCallback(function()
			data.onYRotDegChanged(CameraMath.clampYRotDeg(data.committedYRotDeg + yRotDegFromSliderValue))
		end, { data.committedYRotDeg, data.onYRotDegChanged }),
		onRotateRight = React.useCallback(function()
			data.onYRotDegChanged(CameraMath.clampYRotDeg(data.committedYRotDeg - yRotDegFromSliderValue))
		end, { data.committedYRotDeg, data.onYRotDegChanged })
	}
end

return useRotatableAvatarPreviewViewModel
