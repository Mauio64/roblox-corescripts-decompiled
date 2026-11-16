local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(FriendsCalling.Components.CallParticipant.CallParticipantCard)
local ParticipantAvatar = require(FriendsCalling.Components.CallParticipant.ParticipantAvatar)

local AvatarSize = Foundation.Enums.AvatarSize
local IconName = Foundation.Enums.IconName
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local function CollapsedCallOverlay(props)
	local createElement = React.createElement

	local createElement2 = React.createElement
	local v = {
		LayoutOrder = 1,
		ref = props.onDragInputTarget,
		Size = UDim2.fromOffset(70, 70),
		testId = "friends-calling-pip-drag-target"
	}
	local content

	if props.participant.showStatusAnimation then
		content = React.createElement(Text, {
			Text = props.participant.statusText or "",
			tag = "auto-xy text-body-medium text-align-x-center content-default",
			testId = "friends-calling-pip-ringing"
		})
	elseif props.participant.userId ~= 0 then
		content = React.createElement(ParticipantAvatar, {
			avatarSize = AvatarSize.XLarge,
			isDimmed = props.participant.isDimmed,
			isSpeaking = props.participant.isSpeaking,
			ringSize = 70,
			userId = props.participant.userId
		})
	end

	local v2 = {
		Avatar = createElement2(View, v, { Content = content }),
		Actions = 0
	}
	local actions

	if not props.participant.showStatusAnimation then
		local createElement3 = React.createElement

		local v3 = {
			Headphones = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = IconName.Headphones,
				isCircular = true,
				onActivated = props.onToggleConversationAudio,
				size = InputSize.Medium,
				testId = "friends-calling-pip-headphones"
			}),
			Microphone = 0
		}

		local createElement4 = React.createElement
		local icon

		if props.isMicrophoneMuted then
			icon = IconName.MicrophoneSlash
		else
			icon = IconName.Microphone
		end

		v3.Microphone = createElement4(IconButton, {
			LayoutOrder = 2,
			icon = icon,
			isCircular = true,
			onActivated = props.onToggleMicrophone,
			size = InputSize.Medium,
			testId = "friends-calling-pip-microphone"
		})
		actions = createElement3(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center gap-xsmall auto-xy padding-xsmall radius-circle bg-over-media-300"
			},
			v3
		)
	end

	v2.Actions = actions
	return createElement(
		View,
		{
			tag = "col align-x-center align-y-center gap-small size-full padding-medium stroke-standard stroke-default radius-large clip bg-surface-200"
		},
		v2
	)
end

return CollapsedCallOverlay
