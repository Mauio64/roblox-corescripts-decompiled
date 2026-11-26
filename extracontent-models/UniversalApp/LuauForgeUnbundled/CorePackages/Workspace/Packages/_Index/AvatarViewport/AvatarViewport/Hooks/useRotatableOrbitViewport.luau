local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")
local useAvatarViewportScene = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useAvatarViewportScene")
local useViewportModelLoader = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportModelLoader")
local useViewportOrbitInteractions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportOrbitInteractions")
local useViewportGamepadOrbit = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportGamepadOrbit")
local useOrbitHeadCamera = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useOrbitHeadCamera")

local function useRotatableOrbitViewport(data)
	local ref = React.useRef(function(p2) end)

	local v5 = useAvatarViewportScene()

	local v6 = useViewportOrbitInteractions({
		initialYRotDeg = data.committedYRotDeg or data.initialYRotDeg,
		distanceScale = data.distanceScale,
		onYRotDegChanged = data.onYRotDegChanged,
		onDistanceScaleChanged = data.onDistanceScaleChanged,
		onCameraUpdateRequested = function()
			ref.current()
		end
	})

	useViewportGamepadOrbit({
		applyYawDelta = v6.applyYawDelta,
		applyZoomGesture = v6.applyZoomGesture,
		onOrbitEnded = v6.commitYaw,
		actionName = data.gamepadActionName
	})

	local v7 = useViewportModelLoader({
		modelSource = data.modelSource,
		worldModelRef = v5.worldModel,
		onModelReady = function(p2)
			v6.resetYaw(data.committedYRotDeg or data.initialYRotDeg)

			if data.onModelReady then
				data.onModelReady(p2)
			end
		end
	})

	local v8 = React.useMemo(function()
		return {
			baseDistance = data.baseDistance or Constants.DefaultOrbitBaseDistance,
			fieldOfViewDeg = data.fieldOfViewDeg or Constants.DefaultOrbitFieldOfViewDeg,
			fieldOfViewForDistanceScaleDeg = data.fieldOfViewForDistanceScaleDeg,
			focusPartName = data.focusPartName or Constants.DefaultFocusPartName,
			layout = data.layout
		}
	end, {
		data.baseDistance,
		data.fieldOfViewDeg,
		data.fieldOfViewForDistanceScaleDeg,
		data.focusPartName,
		data.layout,
		data.layout.viewportHeight,
		data.layout.cutoutTopOffset,
		data.layout.cutoutDiameter
	})

	local v9 = useOrbitHeadCamera({
		cameraRef = v5.camera,
		model = v7.model,
		yRotDeg = v6.yRotDeg,
		yRotDegRef = v6.yRotDegRef,
		distanceScale = data.distanceScale,
		distanceScaleRef = v6.distanceScaleRef,
		config = v8,
		frameCloseupPreviewCamera = data.frameCloseupPreviewCamera
	})

	ref.current = v9.frameCamera

	React.useEffect(function()
		if data.committedYRotDeg ~= nil then
			v6.resetYaw(data.committedYRotDeg)
		end
	end, { data.committedYRotDeg, v6.resetYaw })

	return {
		refs = v5,
		inputHandlers = v6.inputHandlers,
		modelLoader = {
			isLoading = v7.isLoading,
			isReady = v7.isReady,
			model = v7.model
		},
		frameCamera = v9.frameCamera,
		resetYaw = v6.resetYaw
	}
end

return useRotatableOrbitViewport
