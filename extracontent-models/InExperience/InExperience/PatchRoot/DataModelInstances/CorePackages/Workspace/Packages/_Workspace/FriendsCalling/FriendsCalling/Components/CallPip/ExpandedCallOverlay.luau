local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CallParticipantCard = require(FriendsCalling.Components.CallParticipant.CallParticipantCard)

local HeaderBar = Foundation.HeaderBar
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function useElapsedText(connectedAt: number?)
	local state, setState = React.useState(nil)
	React.useEffect(function()
		if connectedAt == nil then
			setState(nil)
			return
		end

		local v = true
		local function tick()
			if not v then
				return
			end

			local v2 = math.max(0, (math.floor(os.clock() - connectedAt)))
			setState(string.format("%02d:%02d", math.floor(v2 / 60), v2 % 60))
			task.delay(1, tick)
		end
		tick()
		return function()
			v = false
		end
	end, { connectedAt })
	return state
end

local function ExpandedCallOverlay(props)
	local v = useTokens()
	local text = useElapsedText(props.connectedAt)
	local createElement = React.createElement
	local v2 = {
		padding = { top = UDim.new(0, props.topPadding) },
		tag = {
			["col size-full bg-surface-100"] = true,
			["stroke-standard stroke-default radius-large clip"] = props.hasRoundedCorners
		}
	}

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		ref = props.onDragInputTarget,
		tag = "size-full-0 auto-y",
		testId = "friends-calling-pip-drag-target"
	}

	local createElement3 = React.createElement
	local root = HeaderBar.Root

	local children2 = {
		Leading = React.createElement(HeaderBar.Leading, nil, {
			Actions = React.createElement(HeaderBar.Actions, {
				actions = {
					{
						id = "collapse",
						icon = IconName.TwoArrowsToCenter,
						onActivated = props.onCollapse
					}
				}
			})
		}),
		Content = 0,
		Trailing = 0
	}

	local createElement4 = React.createElement
	local content = HeaderBar.Content
	local createElement5 = React.createElement

	local v4 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.participant.name,
			tag = "auto-xy text-title-large content-emphasis",
			testId = "friends-calling-pip-title"
		}),
		Timer = 0
	}
	local timer

	if text ~= nil then
		timer = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "auto-xy text-body-medium content-default",
			testId = "friends-calling-pip-timer"
		})
	end

	v4.Timer = timer
	children2.Content = createElement4(content, nil, {
		Titles = createElement5(View, { tag = "col align-x-center auto-xy" }, v4)
	})

	children2.Trailing = React.createElement(HeaderBar.Trailing, nil, {
		Spacer = React.createElement(View, { tag = "size-1000-1000" })
	})
	local children = {
		Header = createElement2(View, v3, {
			Bar = createElement3(root, { hasBackground = false }, children2)
		}),
		Body = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "fill size-full-0 padding-x-xlarge padding-bottom-xxlarge" },
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
		Message = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = IconName.SpeechBubbleAlignCenter,
			isCircular = true,
			onActivated = props.onOpenChat,
			size = InputSize.Large,
			testId = "friends-calling-pip-message"
		}),
		Headphones = React.createElement(IconButton, {
			LayoutOrder = 2,
			icon = IconName.Headphones,
			isCircular = true,
			onActivated = props.onToggleConversationAudio,
			size = InputSize.Large,
			testId = "friends-calling-pip-headphones"
		}),
		Microphone = 0,
		EndCall = 0
	}

	local createElement8 = React.createElement
	local icon

	if props.isMicrophoneMuted then
		icon = IconName.MicrophoneSlash
	else
		icon = IconName.Microphone
	end

	children3.Microphone = createElement8(IconButton, {
		LayoutOrder = 3,
		icon = icon,
		isCircular = true,
		onActivated = props.onToggleMicrophone,
		size = InputSize.Large,
		testId = "friends-calling-pip-microphone"
	})

	children3.EndCall = React.createElement(
		View,
		{
			LayoutOrder = 4,
			onActivated = props.onEndCall,
			tag = "align-x-center align-y-center size-1200-1200 radius-circle bg-system-alert",
			testId = "friends-calling-pip-end-call"
		},
		{
			Icon = React.createElement(Icon, {
				name = IconName.X,
				size = IconSize.Medium,
				style = v.Color.Extended.White.White_100
			})
		}
	)
	children.Actions = createElement6(
		View,
		{
			LayoutOrder = 3,
			tag = "align-x-center size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge"
		},
		{
			Pill = createElement7(
				View,
				{
					tag = "row align-y-center gap-medium auto-xy padding-medium radius-circle bg-over-media-0"
				},
				children3
			)
		}
	)
	return createElement(View, v2, children)
end

return ExpandedCallOverlay
