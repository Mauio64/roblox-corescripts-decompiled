local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local iconButton = Foundation.IconButton
local slider = Foundation.Slider
local text = Foundation.Text
local view = Foundation.View

local playLarge = BuilderIcons.Icon.PlayLarge
local pauseLarge = BuilderIcons.Icon.PauseLarge
local speaker = BuilderIcons.Icon.Speaker
local speakerSlash = BuilderIcons.Icon.SpeakerSlash
local twoArrowsFromCenter = BuilderIcons.Icon.TwoArrowsFromCenter
local twoArrowsToCenter = BuilderIcons.Icon.TwoArrowsToCenter

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local getFormatTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/getFormatTime")

local function PlaybackControls(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local playback = props.preview.playback

	local v7, v8 = React.useBinding(UDim2.fromScale(1, 0))
	local ref = React.useRef(false)

	local v10 = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p2)
			local duration = playback.getDuration(p2)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p2) / duration, 0, 1))
		end)
	end, { playback })))

	local v12 = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p2)
			return `{module7(playback.getPosition(p2))} / {module7(playback.getDuration(p2))}`
		end)
	end, { playback })))

	local v13 = useSignalState(playback.getIsPlaying)
	local v14 = useSignalState(playback.getIsMuted)

	local v15 = React.useCallback(function()
		if playback.getIsPlaying(false) then
			ref.current = true
			playback.toggle()
		end
	end, { playback })

	local v16 = React.useCallback(function()
		if ref.current and not playback.getIsPlaying(false) then
			playback.toggle()
		end

		ref.current = false
	end, { playback })

	local onSeek = props.onSeek
	local v17 = React.useCallback(function(p2)
		local v18 = p2 * playback.getDuration(false)
		playback.seek(v18)

		if onSeek then
			onSeek(v18)
		end
	end, { playback, onSeek })

	local v18 = React.useCallback(function(p2)
		v8(UDim2.new(0, p2.AbsoluteSize.X, 1, 0))
	end, {})

	local v19 = React.useCallback(function()
		playback.toggle()
	end, { playback })

	local v20 = React.useCallback(function()
		playback.toggleMute()
	end, { playback })

	local createElement = React.createElement
	local v22 = { LayoutOrder = props.layoutOrder, tag = "size-full-0 auto-y" }

	local v23 = {
		GradientBackdrop = React.createElement(gradientBackdrop, {
			color3 = v6.Color.Common.Scrim.Color3,
			rotation = 270,
			size = v7
		}),
		Controls = 0
	}

	local createElement2 = React.createElement
	local v25 = {
		LayoutOrder = 1,
		onAbsoluteSizeChanged = v18,
		tag = "col gap-xxsmall size-full-0 auto-y",
		padding = {
			bottom = UDim.new(0, v6.Padding.Medium),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.Large))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.Large)))
		}
	}

	local v26 = {
		Slider = React.createElement(slider, {
			value = v10,
			size = Foundation.Enums.InputSize.XSmall,
			knobVisibility = Foundation.Enums.Visibility.None,
			variant = Foundation.Enums.SliderVariant.Standard,
			onValueChanged = v17,
			onDragStarted = v15,
			onDragEnded = v16,
			LayoutOrder = 1
		}),
		ControlBar = 0
	}

	local createElement3 = React.createElement

	local children = {
		LeftControlButtons = React.createElement(
			view,
			{
				tag = "row gap-xsmall position-top-left anchor-top-left auto-xy",
				LayoutOrder = 1
			},
			{
				PlaybackToggle = React.createElement(iconButton, {
					icon = if v13 then pauseLarge else playLarge,
					onActivated = v19,
					size = Foundation.Enums.InputSize.Small,
					LayoutOrder = 1
				}),
				MuteToggle = React.createElement(iconButton, {
					icon = if v14 then speakerSlash else speaker,
					onActivated = v20,
					size = Foundation.Enums.InputSize.Small,
					LayoutOrder = 2
				})
			}
		),
		DurationDisplay = React.createElement(text, {
			LayoutOrder = 2,
			tag = "position-center-center anchor-center-center auto-xy text-body-medium content-emphasis",
			Text = v12
		}),
		RightControlButtons = 0
	}

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v42 = if props.isFitMode then twoArrowsFromCenter else twoArrowsToCenter
	children.RightControlButtons = createElement7(
		view,
		{
			tag = "row gap-xsmall position-top-right anchor-top-right auto-xy",
			LayoutOrder = 3
		},
		{
			FitModeToggle = createElement8(iconButton, {
				icon = v42,
				onActivated = props.toggleFitMode,
				size = Foundation.Enums.InputSize.Small,
				LayoutOrder = 1
			})
		}
	)
	v26.ControlBar = createElement3(view, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 2
	}, children)
	v23.Controls = createElement2(view, v25, v26)
	return createElement(view, v22, v23)
end

return PlaybackControls
