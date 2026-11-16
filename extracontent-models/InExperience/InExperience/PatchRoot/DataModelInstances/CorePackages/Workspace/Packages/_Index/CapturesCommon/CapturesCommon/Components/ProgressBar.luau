local parent = script.Parent.Parent.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ButtonSize = Foundation.Enums.ButtonSize
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local function formatTime(p: number) -- 2 equivalent calls inferred from this helper
	local v = math.floor(p / 60)
	local v2 = math.floor(p % 60)
	return string.format("%02d:%02d", v, v2)
end

local function ProgressBar(props)
	local v = props.timePosition / props.timeLength
	local v2 = formatTime(props.timePosition) -- inferred equivalent call
	local v3 = formatTime(props.timeLength) -- inferred equivalent call
	local ref = React.useRef(nil)
	local state, setState = React.useState(0)

	React.useEffect(function()
		if ref and ref.current then
			local inputBeganConnection = ref.current.InputBegan:Connect(function(input)
				setState(input.Position.X)
			end)

			return function()
				inputBeganConnection:Disconnect()
			end
		end
	end, {})

	local onActivated = React.useCallback(function()
		if not (ref and ref.current) then
			return
		end

		local x = ref.current.AbsolutePosition.X
		local x2 = ref.current.AbsoluteSize.X

		props.onProgressBarActivated((state - x) / x2)
	end, { state, props.onProgressBarActivated })

	local createElement = React.createElement
	local v4 = {
		tag = {
			["align-x-center align-y-center col size-full-1400"] = true,
			["padding-medium"] = props.isFullScreen,
			["padding-x-medium"] = not props.isFullScreen
		}
	}

	local v5 = {
		ProgressBarContainer = React.createElement(
			View,
			{
				LayoutOrder = 1,
				onActivated = onActivated,
				ref = ref,
				tag = "radius-small bg-over-media-0 size-full-200"
			},
			{
				Progress = React.createElement(View, {
					Size = UDim2.fromScale(v, 1),
					tag = "radius-small bg-system-neutral"
				})
			}
		),
		CTAContainer = 0
	}

	local createElement2 = React.createElement

	local v6 = {
		PlayButton = React.createElement(IconButton, {
			icon = props.isPlaying and "icons/controls/media-pause-medium" or "icons/controls/media-play-medium",
			isDisabled = false,
			LayoutOrder = 1,
			onActivated = props.onPlayButtonActivated,
			size = ButtonSize.Medium
		}),
		TimeText = 0,
		MuteButton = 0
	}
	local timeText

	if not props.isTimeHidden then
		timeText = React.createElement(Text, {
			LayoutOrder = 2,
			Text = string.format("%s / %s", v2, v3),
			tag = "auto-xy text-body-large"
		})
	end

	v6.TimeText = timeText

	v6.MuteButton = React.createElement(IconButton, {
		icon = props.isMuted and "icons/controls/speakerMute" or "icons/controls/speaker",
		isDisabled = false,
		LayoutOrder = 3,
		onActivated = props.onMuteButtonActivated,
		size = ButtonSize.Medium
	})
	v5.CTAContainer = createElement2(
		View,
		{
			LayoutOrder = 2,
			isDisabled = true,
			tag = "row flex-between align-x-center align-y-center size-full-1000"
		},
		v6
	)
	return createElement(View, v4, v5)
end

return ProgressBar
