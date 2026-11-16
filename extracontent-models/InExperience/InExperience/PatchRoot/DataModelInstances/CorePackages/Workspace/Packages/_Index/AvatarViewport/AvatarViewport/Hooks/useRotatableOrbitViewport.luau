local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

local Constants = require(AvatarViewport.Constants)
require(AvatarViewport.Types)
local useAvatarViewportScene = require(AvatarViewport.Hooks.useAvatarViewportScene)
local useViewportModelLoader = require(AvatarViewport.Hooks.useViewportModelLoader)
local useViewportOrbitInteractions = require(AvatarViewport.Hooks.useViewportOrbitInteractions)
local useViewportGamepadOrbit = require(AvatarViewport.Hooks.useViewportGamepadOrbit)
local useOrbitHeadCamera = require(AvatarViewport.Hooks.useOrbitHeadCamera)

local function useRotatableOrbitViewport(data)
	local ref = React.useRef(function(_) end)

	local refs = useAvatarViewportScene()

	local v = useViewportOrbitInteractions({
		initialYRotDeg = data.committedYRotDeg or data.initialYRotDeg,
		distanceScale = data.distanceScale,
		onYRotDegChanged = data.onYRotDegChanged,
		onDistanceScaleChanged = data.onDistanceScaleChanged,
		onCameraUpdateRequested = function()
			ref.current()
		end
	})

	useViewportGamepadOrbit({
		applyYawDelta = v.applyYawDelta,
		applyZoomGesture = v.applyZoomGesture,
		onOrbitEnded = v.commitYaw,
		actionName = data.gamepadActionName
	})

	local v2 = useViewportModelLoader({
		modelSource = data.modelSource,
		worldModelRef = refs.worldModel,
		onModelReady = function(p)
			v.resetYaw(data.committedYRotDeg or data.initialYRotDeg)

			if data.onModelReady then
				data.onModelReady(p)
			end
		end
	})

	local config = React.useMemo(function()
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

	local v3 = useOrbitHeadCamera({
		cameraRef = refs.camera,
		model = v2.model,
		yRotDeg = v.yRotDeg,
		yRotDegRef = v.yRotDegRef,
		distanceScale = data.distanceScale,
		distanceScaleRef = v.distanceScaleRef,
		config = config,
		frameCloseupPreviewCamera = data.frameCloseupPreviewCamera
	})

	ref.current = v3.frameCamera

	React.useEffect(function()
		if data.committedYRotDeg ~= nil then
			v.resetYaw(data.committedYRotDeg)
		end
	end, { data.committedYRotDeg, v.resetYaw })

	return {
		refs = refs,
		inputHandlers = v.inputHandlers,
		modelLoader = { isLoading = v2.isLoading, isReady = v2.isReady, model = v2.model },
		frameCamera = v3.frameCamera,
		resetYaw = v.resetYaw
	}
end

return useRotatableOrbitViewport
