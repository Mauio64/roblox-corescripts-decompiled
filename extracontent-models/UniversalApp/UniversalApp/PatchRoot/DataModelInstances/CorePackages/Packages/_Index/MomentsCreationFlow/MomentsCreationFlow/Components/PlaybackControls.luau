local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local Slider = Foundation.Slider
local Text = Foundation.Text
local View = Foundation.View

local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local TwoArrowsFromCenter = BuilderIcons.Icon.TwoArrowsFromCenter
local TwoArrowsToCenter = BuilderIcons.Icon.TwoArrowsToCenter

local GradientBackdrop = MomentsCommon.GradientBackdrop

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local getFormatTime = MomentsCommon.Utils.getFormatTime

local function PlaybackControls(props)
	local v = useDeviceInsets()
	local v2 = useTokens()

	local size, v3 = React.useBinding(UDim2.fromScale(1, 0))
	local ref = React.useRef(false)

	local onDragStarted = React.useCallback(function()
		if props.playbackController.playback.isPlaying then
			ref.current = true
		end

		props.playbackController.playback.pause()
	end, { props.playbackController.playback.isPlaying })

	local onDragEnded = React.useCallback(function()
		if ref.current then
			props.playbackController.playback.play()
		end

		ref.current = false
	end, {})

	local onValueChanged = React.useCallback(function(p: number)
		props.playbackController.timeline.seek(p * props.playbackController.timeline.duration)
	end, { props.playbackController.timeline.duration, props.playbackController.timeline.seek })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3(UDim2.new(0, p.AbsoluteSize.X, 1, 0))
	end, {})

	local onActivated = useCallback(function()
		props.playbackController.playback.toggle()
	end, { props.playbackController })

	local onActivated2 = useCallback(function()
		props.playbackController.volume.toggle()
	end, { props.playbackController })

	local createElement = React.createElement
	local v4 = { LayoutOrder = props.layoutOrder, tag = "auto-y size-full-0" }

	local v5 = {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			color3 = v2.Color.Common.Scrim.Color3,
			rotation = 270,
			size = size
		}),
		Controls = 0
	}

	local createElement2 = React.createElement

	local v6 = {
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v2.Padding.Medium),
			PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.Large))),
			PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.Large)))
		}),
		Slider = React.createElement(Slider, {
			value = props.playbackController.timeline.elapsed / props.playbackController.timeline.duration,
			size = Foundation.Enums.InputSize.XSmall,
			knobVisibility = Foundation.Enums.Visibility.None,
			variant = Foundation.Enums.SliderVariant.Standard,
			onValueChanged = onValueChanged,
			onDragStarted = onDragStarted,
			onDragEnded = onDragEnded,
			LayoutOrder = 1
		}),
		ControlBar = 0
	}

	local createElement3 = React.createElement

	local v7 = {
		LeftControlButtons = React.createElement(
			View,
			{ tag = "auto-xy row gap-xsmall anchor-top-left position-top-left", LayoutOrder = 1 },
			{
				PlaybackToggle = React.createElement(IconButton, {
					icon = props.playbackController.playback.isPlaying and PauseLarge or PlayLarge,
					onActivated = onActivated,
					size = Foundation.Enums.InputSize.Small,
					LayoutOrder = 1
				}),
				MuteToggle = React.createElement(IconButton, {
					icon = props.playbackController.volume.isMuted and SpeakerSlash or Speaker,
					onActivated = onActivated2,
					size = Foundation.Enums.InputSize.Small,
					LayoutOrder = 2
				})
			}
		),
		DurationDisplay = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-xy anchor-center-center position-center-center text-body-medium content-emphasis",
			Text = `{getFormatTime(props.playbackController.timeline.elapsed)} / {getFormatTime(props.playbackController.timeline.duration)}`
		}),
		RightControlButtons = 0
	}

	local createElement4 = React.createElement

	local createElement5 = React.createElement
	local icon

	if props.isFitMode then
		icon = TwoArrowsFromCenter
	else
		icon = TwoArrowsToCenter
	end

	v7.RightControlButtons = createElement4(
		View,
		{ tag = "auto-xy row gap-xsmall anchor-top-right position-top-right", LayoutOrder = 3 },
		{
			FitModeToggle = createElement5(IconButton, {
				icon = icon,
				onActivated = props.toggleFitMode,
				size = Foundation.Enums.InputSize.Small,
				LayoutOrder = 1
			})
		}
	)
	v6.ControlBar = createElement3(View, { tag = "auto-y size-full-0", LayoutOrder = 2 }, v7)
	v5.Controls = createElement2(
		View,
		{
			LayoutOrder = 1,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			tag = "auto-y col gap-xxsmall size-full-0"
		},
		v6
	)
	return createElement(View, v4, v5)
end

return PlaybackControls
