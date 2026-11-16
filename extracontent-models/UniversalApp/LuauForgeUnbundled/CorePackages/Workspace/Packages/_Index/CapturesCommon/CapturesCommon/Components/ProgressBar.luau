local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local buttonSize = Foundation.Enums.ButtonSize
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View

local function formatTime(p2)
	local v5 = math.floor(p2 / 60)
	local v6 = math.floor(p2 % 60)
	return string.format("%02d:%02d", v5, v6)
end

local function ProgressBar(props)
	local v5 = props.timePosition / props.timeLength
	local timePosition = props.timePosition
	local v6 = math.floor(timePosition / 60)
	local v7 = math.floor(timePosition % 60)
	local v8 = string.format("%02d:%02d", v6, v7)

	local timeLength = props.timeLength
	local v9 = math.floor(timeLength / 60)
	local v10 = math.floor(timeLength % 60)
	local v11 = string.format("%02d:%02d", v9, v10)

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

	local v12 = React.useCallback(function()
		if not (ref and ref.current) then
			return
		end

		local x = ref.current.AbsolutePosition.X
		local x2 = ref.current.AbsoluteSize.X

		props.onProgressBarActivated((state - x) / x2)
	end, { state, props.onProgressBarActivated })

	local createElement = React.createElement
	local v14 = {
		tag = {
			["align-x-center align-y-center col size-full-1400"] = true,
			["padding-medium"] = props.isFullScreen,
			["padding-x-medium"] = not props.isFullScreen
		}
	}

	local v15 = {
		ProgressBarContainer = React.createElement(
			view,
			{
				LayoutOrder = 1,
				onActivated = v12,
				ref = ref,
				tag = "radius-small bg-over-media-0 size-full-200"
			},
			{
				Progress = React.createElement(view, {
					Size = UDim2.fromScale(v5, 1),
					tag = "radius-small bg-system-neutral"
				})
			}
		),
		CTAContainer = 0
	}

	local createElement2 = React.createElement

	local v18 = {
		PlayButton = React.createElement(iconButton, {
			icon = props.isPlaying and "icons/controls/media-pause-medium" or "icons/controls/media-play-medium",
			isDisabled = false,
			LayoutOrder = 1,
			onActivated = props.onPlayButtonActivated,
			size = buttonSize.Medium
		}),
		TimeText = 0,
		MuteButton = 0
	}

	local v19 = if not props.isTimeHidden then React.createElement(text, {
		LayoutOrder = 2,
		Text = string.format("%s / %s", v8, v11),
		tag = "auto-xy text-body-large"
	}) else nil
	v18.TimeText = v19

	v18.MuteButton = React.createElement(iconButton, {
		icon = props.isMuted and "icons/controls/speakerMute" or "icons/controls/speaker",
		isDisabled = false,
		LayoutOrder = 3,
		onActivated = props.onMuteButtonActivated,
		size = buttonSize.Medium
	})
	v15.CTAContainer = createElement2(
		view,
		{
			LayoutOrder = 2,
			isDisabled = true,
			tag = "row flex-between align-x-center align-y-center size-full-1000"
		},
		v18
	)
	return createElement(view, v14, v15)
end

return ProgressBar
