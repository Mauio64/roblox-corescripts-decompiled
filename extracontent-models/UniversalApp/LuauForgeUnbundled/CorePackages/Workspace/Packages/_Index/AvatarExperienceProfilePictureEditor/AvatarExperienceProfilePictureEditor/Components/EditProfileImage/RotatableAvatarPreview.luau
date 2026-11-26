local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local AvatarViewport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarViewport")
local applyCloseupPreviewPose = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/applyCloseupPreviewPose")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/frameCloseupPreviewCamera")
local PreviewCutoutOverlay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/PreviewCutoutOverlay")
local ProfilePictureCameraControlBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/ProfilePictureCameraControlBar")
local useRotatableAvatarPreviewViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/useRotatableAvatarPreviewViewModel")
local FFlagEditProfileImageCameraControlBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Flags/FFlagEditProfileImageCameraControlBar")
local fFlagEditProfileImageRigTypeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileImageRigTypeOverride
local view = Foundation.View
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local cameraMath = AvatarViewport.CameraMath
local useRotatableOrbitViewport = AvatarViewport.useRotatableOrbitViewport
local avatarViewportScene = AvatarViewport.AvatarViewportScene
local viewportInteractionOverlay = AvatarViewport.ViewportInteractionOverlay

local function stopAnimatorTracks(object)
	if not object then
		return
	end

	for k, v5 in object:GetPlayingAnimationTracks() do
		v5:Stop(0)
	end
end

local function RotatableAvatarPreview(props)
	local v5 = useTokens()
	local cutoutSize = props.cutoutSize
	local width = props.width
	local height = props.height
	local cutoutTopOffset = props.cutoutTopOffset
	local clampDistanceScale = cameraMath.clampDistanceScale(props.distanceScale)
	local v6

	if FFlagEditProfileImageCameraControlBar then
		v6 = useRotatableAvatarPreviewViewModel({
			isDisabled = props.isCameraControlBarDisabled,
			distanceScale = clampDistanceScale,
			committedYRotDeg = props.committedYRotDeg,
			onDistanceScaleChanged = props.onDistanceScaleChanged,
			onYRotDegChanged = props.onYRotDegChanged
		})
	end

	local v7 = React.useMemo(function()
		return {
			viewportHeight = height,
			cutoutTopOffset = cutoutTopOffset,
			cutoutDiameter = cutoutSize
		}
	end, { height, cutoutTopOffset, cutoutSize })

	local v8 = React.useMemo(function()
		return function(data)
			return module5({
				character = data.character,
				yRotDeg = data.yRotDeg,
				distanceScale = data.distanceScale,
				layout = v7,
				fieldOfViewDeg = data.config.fieldOfViewDeg,
				fieldOfViewForDistanceScaleDeg = data.config.fieldOfViewForDistanceScaleDeg
			})
		end
	end, { v7 })

	local ref = React.useRef(0)

	local useMemo = React.useMemo
	local function fn()
		if fFlagEditProfileImageRigTypeOverride and props.rigTypeOverride then
			return AvatarViewport.ModelSources.fromUserIdWithRigType(props.userId, props.rigTypeOverride)
		end

		return AvatarViewport.ModelSources.fromUserId(props.userId)
	end

	local userId = props.userId
	local v10 = if fFlagEditProfileImageRigTypeOverride then props.rigTypeOverride or false else nil
	local v12 = useRotatableOrbitViewport({
		modelSource = useMemo(fn, { userId, v10 }),
		distanceScale = clampDistanceScale,
		fieldOfViewDeg = props.fieldOfViewDeg,
		fieldOfViewForDistanceScaleDeg = props.fieldOfViewForDistanceScaleDeg,
		committedYRotDeg = props.committedYRotDeg,
		onYRotDegChanged = props.onYRotDegChanged,
		onDistanceScaleChanged = props.onDistanceScaleChanged,
		gamepadActionName = "EditProfileRotatableAvatarPreviewOrbit",
		layout = v7,
		frameCloseupPreviewCamera = v8
	})

	React.useEffect(function()
		if not (v12.modelLoader.isReady and v12.modelLoader.model) then
			return
		end

		ref.current += 1
		local current = ref.current
		local model = v12.modelLoader.model
		local emoteAssetId = props.emoteAssetId

		task.spawn(function()
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			local animator = if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil

			if animator then
				for k, v14 in animator:GetPlayingAnimationTracks() do
					v14:Stop(0)
				end
			end

			applyCloseupPreviewPose(model, emoteAssetId)

			if ref.current ~= current then
				return
			end

			v12.frameCamera({ tween = true })
		end)

		return function()
			ref.current += 1
		end
	end, {
		props.emoteAssetId,
		v12.modelLoader.isReady,
		v12.modelLoader.model,
		v12.frameCamera
	})

	local surface_300 = v5.Color.Surface.Surface_300
	local color3 = surface_300.Color3
	local transparency = surface_300.Transparency or 0
	local v13 = math.max(0, (math.floor((width - cutoutSize) / 2 + 0.5)))

	local createElement = React.createElement
	local v16 = if props.fillContainer then UDim2.fromScale(1, 1) else UDim2.fromOffset(width, height)

	local v17 = {
		Viewport = React.createElement(avatarViewportScene, {
			size = UDim2.fromScale(1, 1),
			backgroundColor3 = color3,
			backgroundTransparency = transparency,
			refs = v12.refs
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

	local v18 = if v12.modelLoader.isLoading then React.createElement(
		view,
		{ tag = "align-x-center align-y-center size-full", ZIndex = 5 },
		{
			Spinner = React.createElement(loading, { size = iconSize.Large })
		}
	) else nil
	v17.LoadingSpinner = v18

	local v19 = if v6 and v6.showCameraControlBar then React.createElement(ProfilePictureCameraControlBar, {
		topOffset = cutoutTopOffset,
		zIndex = 6,
		onZoomIn = v6.onZoomIn,
		onZoomOut = v6.onZoomOut,
		onRotateLeft = v6.onRotateLeft,
		onRotateRight = v6.onRotateRight
	}) else nil
	v17.CameraControlBar = v19

	v17.InteractionOverlay = React.createElement(viewportInteractionOverlay, {
		name = "InteractionOverlay",
		size = UDim2.fromOffset(cutoutSize, cutoutSize),
		position = UDim2.fromOffset(v13, cutoutTopOffset),
		zIndex = 5,
		inputHandlers = v12.inputHandlers
	})
	return createElement(view, { Size = v16, backgroundStyle = surface_300 }, v17)
end

return RotatableAvatarPreview
