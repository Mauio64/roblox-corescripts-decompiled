local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Loading = Foundation.Loading
local View = Foundation.View

local GradientBackdrop = MomentsCommon.GradientBackdrop
local MusicPreviewItem = require(MomentsCreationFlow.Components.MusicPreviewItem)
local Waveform = require(MomentsCreationFlow.Components.Waveform)

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useMusicEditorController = require(MomentsCreationFlow.Hooks.useMusicEditorController)
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth

local udim = UDim2.new(0, 48, 1, 0)

local function MusicEditor(props)
	local v = useTokens()
	local v2 = useDeviceInsets()
	local v3 = React.useContext(CreationFlowContext)

	local v4 = useToggleState(false)
	local v5 = useToggleState(false)

	local v6 = useCallback(function()
		props.playbackController.volume.mute()
		props.playbackController.timeline.seek(0)
		props.playbackController.playback.pause()
		v5.enable()
	end, { props.playbackController.timeline.seek })

	local v7 = useCallback(function()
		props.playbackController.volume.unmute()
		props.playbackController.playback.play()
		v5.disable()
	end, {})

	local onWaveformReady = useCallback(function()
		props.playbackController.volume.unmute()
		props.playbackController.playback.play()
		v4.enable()
	end, {})

	React.useEffect(function()
		v4.disable()
	end, { props.musicEdit.assetId })

	local v8 = useMusicEditorController(
		v4.enabled,
		v7,
		v6,
		props.onStartTimeChanged,
		props.musicEdit,
		props.playbackController.audio.timeLength
	)

	local waveformRef = v8.waveformRef
	local waveformPosition = v8.waveformPosition
	local waveformDisplayRef = v8.waveformDisplayRef

	local createElement = React.createElement

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.Small),
			PaddingBottom = UDim.new(0, (math.max(v2.bottom, v.Padding.Small))),
			PaddingLeft = UDim.new(0, (math.max(v2.left, v.Padding.Large))),
			PaddingRight = UDim.new(0, (math.max(v2.right, v.Padding.Large)))
		}),
		Nav = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
			},
			{
				BackButton = React.createElement(Button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v3.getLocalization(CreationFlowLocalization.GeneralCtaBack),
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = props.onBack,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(Button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v3.getLocalization(CreationFlowLocalization.GeneralCtaDone),
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = props.onDone,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		),
		SegmentSelector = 0,
		MusicPreviewItemWrapper = 0
	}

	local createElement2 = React.createElement

	local v9 = {
		Timeline = React.createElement(View, { tag = "clip size-full-full", ZIndex = 1 }, {
			DragDetector = React.createElement("UIDragDetector", {
				DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
				ref = waveformRef,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
			}),
			LeftGradientBackdrop = React.createElement(GradientBackdrop, {
				color3 = v.Color.Surface.Surface_100.Color3,
				rotation = 0,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			RightGradientBackdrop = React.createElement(GradientBackdrop, {
				anchorPoint = Vector2.new(1, 0),
				color3 = v.Color.Surface.Surface_100.Color3,
				position = UDim2.fromScale(1, 0),
				rotation = 180,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			WaveformContainer = React.createElement(
				View,
				{
					tag = "anchor-center-center position-center-center radius-medium",
					Size = UDim2.new(0, SegmentSelectorWidth, 1, 0)
				},
				{
					WaveformDisplay = React.createElement(Waveform, {
						audioAssetId = props.musicEdit.assetId,
						position = waveformPosition:map(function(p)
							return UDim2.fromScale(p, 0.5)
						end),
						onWaveformReady = onWaveformReady,
						ref = waveformDisplayRef,
						videoDuration = props.playbackController.timeline.duration,
						zIndex = 1
					})
				}
			)
		}),
		SegmentOutline = 0
	}

	local createElement3 = React.createElement
	local v10 = {
		tag = "anchor-center-center position-center-center radius-medium",
		Size = UDim2.new(0, SegmentSelectorWidth, 1, -v.Size.Size_100),
		ZIndex = 2
	}
	local scrubber

	if v4.enabled and not v5.enabled then
		scrubber = React.createElement(View, {
			tag = "anchor-center-center bg-system-contrast size-100-1900 radius-circle",
			Position = UDim2.fromScale(
				props.playbackController.timeline.elapsed / props.playbackController.timeline.duration,
				0.5
			)
		})
	end

	local loadingIndicator

	if not v4.enabled then
		loadingIndicator = React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = Foundation.Enums.IconSize.Medium
		})
	end

	v9.SegmentOutline = createElement3(View, v10, {
		Scrubber = scrubber,
		LoadingIndicator = loadingIndicator,
		OutlineStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v.Color.System.Contrast.Color3,
			Transparency = v.Color.System.Contrast.Transparency,
			Thickness = v.Stroke.Thick
		})
	})
	children.SegmentSelector = createElement2(View, { LayoutOrder = 2, tag = "size-full-1600" }, v9)

	children.MusicPreviewItemWrapper = React.createElement(View, {
		tag = "auto-y size-full-0",
		LayoutOrder = 3
	}, {
		MusicPreviewItem = React.createElement(MusicPreviewItem, {
			musicAssetId = props.musicEdit.assetId
		})
	})
	return createElement(
		View,
		{
			tag = "auto-y align-x-center align-y-top anchor-bottom-center bg-surface-100 col gap-large position-bottom-center radius-medium size-full-0",
			ZIndex = 5
		},
		children
	)
end

return MusicEditor
