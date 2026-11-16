local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarViewport = require(parent.AvatarViewport)
local applyCloseupPreviewPose = require(AvatarExperienceProfilePictureEditor.Shared.applyCloseupPreviewPose)
local frameCloseupPreviewCamera = require(AvatarExperienceProfilePictureEditor.Shared.frameCloseupPreviewCamera)
local PreviewCutoutOverlay = require(script.Parent.PreviewCutoutOverlay)
local ProfilePictureCameraControlBar = require(script.Parent.ProfilePictureCameraControlBar)
local useRotatableAvatarPreviewViewModel = require(script.Parent.useRotatableAvatarPreviewViewModel)
local FFlagEditProfileImageCameraControlBar = require(AvatarExperienceProfilePictureEditor.Flags.FFlagEditProfileImageCameraControlBar)
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileImageRigTypeOverride = SharedFlags.FFlagEditProfileImageRigTypeOverride
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local CameraMath = AvatarViewport.CameraMath
local useRotatableOrbitViewport = AvatarViewport.useRotatableOrbitViewport
local AvatarViewportScene = AvatarViewport.AvatarViewportScene
local ViewportInteractionOverlay = AvatarViewport.ViewportInteractionOverlay

local function stopAnimatorTracks(object) -- 1 equivalent call inferred from this helper
	if not object then
		return
	end

	for _, v in object:GetPlayingAnimationTracks() do
		v:Stop(0)
	end
end

local function RotatableAvatarPreview(props)
	local v = useTokens()
	local cutoutSize = props.cutoutSize
	local width = props.width
	local height = props.height
	local cutoutTopOffset = props.cutoutTopOffset
	local clampDistanceScale = CameraMath.clampDistanceScale(props.distanceScale)
	local v2

	if FFlagEditProfileImageCameraControlBar then
		v2 = useRotatableAvatarPreviewViewModel({
			isDisabled = props.isCameraControlBarDisabled,
			distanceScale = clampDistanceScale,
			committedYRotDeg = props.committedYRotDeg,
			onDistanceScaleChanged = props.onDistanceScaleChanged,
			onYRotDegChanged = props.onYRotDegChanged
		})
	end

	local layout = React.useMemo(function()
		return {
			viewportHeight = height,
			cutoutTopOffset = cutoutTopOffset,
			cutoutDiameter = cutoutSize
		}
	end, { height, cutoutTopOffset, cutoutSize })

	local frameCloseupPreviewCamera2 = React.useMemo(function()
		return function(data)
			return frameCloseupPreviewCamera({
				character = data.character,
				yRotDeg = data.yRotDeg,
				distanceScale = data.distanceScale,
				layout = layout,
				fieldOfViewDeg = data.config.fieldOfViewDeg,
				fieldOfViewForDistanceScaleDeg = data.config.fieldOfViewForDistanceScaleDeg
			})
		end
	end, { layout })

	local ref = React.useRef(0)

	local useMemo = React.useMemo
	local function fn()
		if FFlagEditProfileImageRigTypeOverride and props.rigTypeOverride then
			return AvatarViewport.ModelSources.fromUserIdWithRigType(props.userId, props.rigTypeOverride)
		end

		return AvatarViewport.ModelSources.fromUserId(props.userId)
	end

	local userId = props.userId
	local v3

	if FFlagEditProfileImageRigTypeOverride then
		v3 = props.rigTypeOverride or false
	end

	local v4 = useRotatableOrbitViewport({
		modelSource = useMemo(fn, { userId, v3 }),
		distanceScale = clampDistanceScale,
		fieldOfViewDeg = props.fieldOfViewDeg,
		fieldOfViewForDistanceScaleDeg = props.fieldOfViewForDistanceScaleDeg,
		committedYRotDeg = props.committedYRotDeg,
		onYRotDegChanged = props.onYRotDegChanged,
		onDistanceScaleChanged = props.onDistanceScaleChanged,
		gamepadActionName = "EditProfileRotatableAvatarPreviewOrbit",
		layout = layout,
		frameCloseupPreviewCamera = frameCloseupPreviewCamera2
	})

	React.useEffect(function()
		if not (v4.modelLoader.isReady and v4.modelLoader.model) then
			return
		end

		ref.current += 1
		local current = ref.current
		local model = v4.modelLoader.model
		local emoteAssetId = props.emoteAssetId

		task.spawn(function()
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			local v5

			if humanoid then
				v5 = humanoid:FindFirstChildOfClass("Animator")
			end

			stopAnimatorTracks(v5) -- inferred equivalent call
			applyCloseupPreviewPose(model, emoteAssetId)

			if ref.current ~= current then
				return
			end

			v4.frameCamera({ tween = true })
		end)

		return function()
			ref.current += 1
		end
	end, { props.emoteAssetId, v4.modelLoader.isReady, v4.modelLoader.model, v4.frameCamera })

	local surface_300 = v.Color.Surface.Surface_300
	local color3 = surface_300.Color3
	local transparency = surface_300.Transparency or 0
	local v5 = math.max(0, (math.floor((width - cutoutSize) / 2 + 0.5)))

	local createElement = React.createElement
	local size

	if props.fillContainer then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.fromOffset(width, height)
	end

	local v6 = {
		Viewport = React.createElement(AvatarViewportScene, {
			size = UDim2.fromScale(1, 1),
			backgroundColor3 = color3,
			backgroundTransparency = transparency,
			refs = v4.refs
		}),
		CutoutOverlay = React.createElement(PreviewCutoutOverlay, {
			width = width,
			height = height,
			cutoutSize = cutoutSize,
			cutoutTopOffset = cutoutTopOffset,
			frameImage = props.frameImage
		}),
		LoadingSpinner = 0,
		CameraControlBar = 0,
		InteractionOverlay = 0
	}
	local loadingSpinner

	if v4.modelLoader.isLoading then
		loadingSpinner = React.createElement(View, {
			tag = "align-x-center align-y-center size-full",
			ZIndex = 5
		}, {
			Spinner = React.createElement(Loading, { size = IconSize.Large })
		})
	end

	v6.LoadingSpinner = loadingSpinner
	local cameraControlBar

	if v2 and v2.showCameraControlBar then
		cameraControlBar = React.createElement(ProfilePictureCameraControlBar, {
			topOffset = cutoutTopOffset,
			zIndex = 6,
			onZoomIn = v2.onZoomIn,
			onZoomOut = v2.onZoomOut,
			onRotateLeft = v2.onRotateLeft,
			onRotateRight = v2.onRotateRight
		})
	end

	v6.CameraControlBar = cameraControlBar

	v6.InteractionOverlay = React.createElement(ViewportInteractionOverlay, {
		name = "InteractionOverlay",
		size = UDim2.fromOffset(cutoutSize, cutoutSize),
		position = UDim2.fromOffset(v5, cutoutTopOffset),
		zIndex = 5,
		inputHandlers = v4.inputHandlers
	})
	return createElement(View, { Size = size, backgroundStyle = surface_300 }, v6)
end

return RotatableAvatarPreview
