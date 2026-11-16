local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

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

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local getFormatTime = require(MomentsCreation.Utils.getFormatTime)

local function PlaybackControls(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local playback = props.preview.playback

	local size, v3 = React.useBinding(UDim2.fromScale(1, 0))
	local ref = React.useRef(false)

	local v4 = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p)
			local duration = playback.getDuration(p)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p) / duration, 0, 1))
		end)
	end, { playback })))

	local text = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p)
			return `{getFormatTime(playback.getPosition(p))} / {getFormatTime(playback.getDuration(p))}`
		end)
	end, { playback })))

	local v5 = useSignalState(playback.getIsPlaying)
	local v6 = useSignalState(playback.getIsMuted)

	local onDragStarted = React.useCallback(function()
		if playback.getIsPlaying(false) then
			ref.current = true
			playback.toggle()
		end
	end, { playback })

	local onDragEnded = React.useCallback(function()
		if ref.current and not playback.getIsPlaying(false) then
			playback.toggle()
		end

		ref.current = false
	end, { playback })

	local onSeek = props.onSeek
	local onValueChanged = React.useCallback(function(p: number)
		local v7 = p * playback.getDuration(false)
		playback.seek(v7)

		if onSeek then
			onSeek(v7)
		end
	end, { playback, onSeek })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3(UDim2.new(0, p.AbsoluteSize.X, 1, 0))
	end, {})

	local onActivated = React.useCallback(function()
		playback.toggle()
	end, { playback })

	local onActivated2 = React.useCallback(function()
		playback.toggleMute()
	end, { playback })

	local createElement = React.createElement
	local v7 = { LayoutOrder = props.layoutOrder, tag = "size-full-0 auto-y" }

	local v8 = {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			color3 = v2.Color.Common.Scrim.Color3,
			rotation = 270,
			size = size
		}),
		Controls = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = "col gap-xxsmall size-full-0 auto-y",
		padding = {
			bottom = UDim.new(0, v2.Padding.Medium),
			left = UDim.new(0, (math.max(v.left, v2.Padding.Large))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.Large)))
		}
	}

	local v10 = {
		Slider = React.createElement(Slider, {
			value = v4,
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

	local createElement4 = React.createElement

	local createElement5 = React.createElement
	local icon = if v5 then PauseLarge else PlayLarge
	local children2 = {
		PlaybackToggle = createElement5(IconButton, {
			icon = icon,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Small,
			LayoutOrder = 1
		}),
		MuteToggle = 0
	}

	local createElement6 = React.createElement
	local icon2 = if v6 then SpeakerSlash else Speaker
	children2.MuteToggle = createElement6(IconButton, {
		icon = icon2,
		onActivated = onActivated2,
		size = Foundation.Enums.InputSize.Small,
		LayoutOrder = 2
	})
	local children = {
		LeftControlButtons = createElement4(
			View,
			{ tag = "row gap-xsmall position-top-left anchor-top-left auto-xy", LayoutOrder = 1 },
			children2
		),
		DurationDisplay = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "position-center-center anchor-center-center auto-xy text-body-medium content-emphasis",
			Text = text
		}),
		RightControlButtons = 0
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local icon3

	if props.isFitMode then
		icon3 = TwoArrowsFromCenter
	else
		icon3 = TwoArrowsToCenter
	end

	children.RightControlButtons = createElement7(
		View,
		{ tag = "row gap-xsmall position-top-right anchor-top-right auto-xy", LayoutOrder = 3 },
		{
			FitModeToggle = createElement8(IconButton, {
				icon = icon3,
				onActivated = props.toggleFitMode,
				size = Foundation.Enums.InputSize.Small,
				LayoutOrder = 1
			})
		}
	)
	v10.ControlBar = createElement3(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, children)
	v8.Controls = createElement2(View, v9, v10)
	return createElement(View, v7, v8)
end

return PlaybackControls
