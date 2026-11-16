local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")

local CallParticipantCard = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/CallParticipantCard")

local headerBar = Foundation.HeaderBar
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function useElapsedText(connectedAt)
	local state, setState = React.useState(nil)
	React.useEffect(function()
		if connectedAt == nil then
			setState(nil)
			return
		end

		local v5 = true
		local function tick2()
			if not v5 then
				return
			end

			local v6 = math.max(0, (math.floor(os.clock() - connectedAt)))
			setState(string.format("%02d:%02d", math.floor(v6 / 60), v6 % 60))
			task.delay(1, tick2)
		end
		tick2()
		return function()
			v5 = false
		end
	end, { connectedAt })
	return state
end

local function ExpandedCallOverlay(props)
	local v5 = useTokens()
	local v6 = useElapsedText(props.connectedAt)
	local createElement = React.createElement
	local v8 = {
		padding = { top = UDim.new(0, props.topPadding) },
		tag = {
			["col size-full bg-surface-100"] = true,
			["stroke-standard stroke-default radius-large clip"] = props.hasRoundedCorners
		}
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		ref = props.onDragInputTarget,
		tag = "size-full-0 auto-y",
		testId = "friends-calling-pip-drag-target"
	}

	local createElement3 = React.createElement
	local root = headerBar.Root

	local children2 = {
		Leading = React.createElement(headerBar.Leading, nil, {
			Actions = React.createElement(headerBar.Actions, {
				actions = {
					{
						id = "collapse",
						icon = iconName.TwoArrowsToCenter,
						onActivated = props.onCollapse
					}
				}
			})
		}),
		Content = 0,
		Trailing = 0
	}

	local createElement4 = React.createElement
	local content = headerBar.Content
	local createElement5 = React.createElement

	local v17 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.participant.name,
			tag = "auto-xy text-title-large content-emphasis",
			testId = "friends-calling-pip-title"
		}),
		Timer = 0
	}

	local v18 = if v6 ~= nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = v6,
		tag = "auto-xy text-body-medium content-default",
		testId = "friends-calling-pip-timer"
	}) else nil
	v17.Timer = v18
	children2.Content = createElement4(content, nil, {
		Titles = createElement5(view, { tag = "col align-x-center auto-xy" }, v17)
	})

	children2.Trailing = React.createElement(headerBar.Trailing, nil, {
		Spacer = React.createElement(view, { tag = "size-1000-1000" })
	})
	local children = {
		Header = createElement2(view, v10, {
			Bar = createElement3(root, { hasBackground = false }, children2)
		}),
		Body = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "fill size-full-0 padding-x-xlarge padding-bottom-xxlarge"
			},
			{
				PlayerCard = React.createElement(CallParticipantCard, {
					userId = props.participant.userId,
					name = props.participant.name,
					statusText = props.participant.statusText,
					isMuted = props.participant.isMuted,
					isSpeaking = props.participant.isSpeaking,
					isDimmed = props.participant.isDimmed,
					showStatusAnimation = props.participant.showStatusAnimation,
					testId = "friends-calling-pip-player-card"
				})
			}
		),
		Actions = 0
	}

	local createElement6 = React.createElement

	local createElement7 = React.createElement

	local children3 = {
		Message = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = iconName.SpeechBubbleAlignCenter,
			isCircular = true,
			onActivated = props.onOpenChat,
			size = inputSize.Large,
			testId = "friends-calling-pip-message"
		}),
		Headphones = React.createElement(iconButton, {
			LayoutOrder = 2,
			icon = iconName.Headphones,
			isCircular = true,
			onActivated = props.onToggleConversationAudio,
			size = inputSize.Large,
			testId = "friends-calling-pip-headphones"
		}),
		Microphone = 0,
		EndCall = 0
	}

	local createElement8 = React.createElement

	local v26 = if props.isMicrophoneMuted then iconName.MicrophoneSlash else iconName.Microphone
	children3.Microphone = createElement8(iconButton, {
		LayoutOrder = 3,
		icon = v26,
		isCircular = true,
		onActivated = props.onToggleMicrophone,
		size = inputSize.Large,
		testId = "friends-calling-pip-microphone"
	})

	children3.EndCall = React.createElement(
		view,
		{
			LayoutOrder = 4,
			onActivated = props.onEndCall,
			tag = "align-x-center align-y-center size-1200-1200 radius-circle bg-system-alert",
			testId = "friends-calling-pip-end-call"
		},
		{
			Icon = React.createElement(icon, {
				name = iconName.X,
				size = iconSize.Medium,
				style = v5.Color.Extended.White.White_100
			})
		}
	)
	children.Actions = createElement6(
		view,
		{
			LayoutOrder = 3,
			tag = "align-x-center size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge"
		},
		{
			Pill = createElement7(
				view,
				{
					tag = "row align-y-center gap-medium auto-xy padding-medium radius-circle bg-over-media-0"
				},
				children3
			)
		}
	)
	return createElement(view, v8, children)
end

return ExpandedCallOverlay
