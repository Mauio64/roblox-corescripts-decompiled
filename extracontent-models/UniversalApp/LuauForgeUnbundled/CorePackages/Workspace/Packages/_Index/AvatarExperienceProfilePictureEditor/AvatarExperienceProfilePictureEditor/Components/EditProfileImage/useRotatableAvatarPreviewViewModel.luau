local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Responsive")
local cameraMath = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarViewport").CameraMath

local yRotDegFromSliderValue = cameraMath.getYRotDegFromSliderValue(1)

local function useRotatableAvatarPreviewViewModel(data)
	local v5 = Responsive.useLastInput()

	return {
		showCameraControlBar = not data.isDisabled and v5 ~= Responsive.Input.Touch,
		onZoomIn = React.useCallback(function()
			data.onDistanceScaleChanged(cameraMath.adjustDistanceScaleBySliderStep(data.distanceScale, 1))
		end, { data.distanceScale, data.onDistanceScaleChanged }),
		onZoomOut = React.useCallback(function()
			data.onDistanceScaleChanged(cameraMath.adjustDistanceScaleBySliderStep(data.distanceScale, -1))
		end, { data.distanceScale, data.onDistanceScaleChanged }),
		onRotateLeft = React.useCallback(function()
			data.onYRotDegChanged(cameraMath.clampYRotDeg(data.committedYRotDeg + yRotDegFromSliderValue))
		end, { data.committedYRotDeg, data.onYRotDegChanged }),
		onRotateRight = React.useCallback(function()
			data.onYRotDegChanged(cameraMath.clampYRotDeg(data.committedYRotDeg - yRotDegFromSliderValue))
		end, { data.committedYRotDeg, data.onYRotDegChanged })
	}
end

return useRotatableAvatarPreviewViewModel
