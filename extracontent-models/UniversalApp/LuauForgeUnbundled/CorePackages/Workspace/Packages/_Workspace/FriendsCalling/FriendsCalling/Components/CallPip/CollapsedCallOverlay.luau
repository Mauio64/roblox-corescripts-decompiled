local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/CallParticipantCard")
local ParticipantAvatar = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/ParticipantAvatar")

local avatarSize = Foundation.Enums.AvatarSize
local iconName = Foundation.Enums.IconName
local iconButton = Foundation.IconButton
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local view = Foundation.View

local function CollapsedCallOverlay(props)
	local createElement = React.createElement

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		ref = props.onDragInputTarget,
		Size = UDim2.fromOffset(70, 70),
		testId = "friends-calling-pip-drag-target"
	}
	local v11

	if props.participant.showStatusAnimation then
		v11 = React.createElement(text, {
			Text = props.participant.statusText or "",
			tag = "auto-xy text-body-medium text-align-x-center content-default",
			testId = "friends-calling-pip-ringing"
		})
	elseif props.participant.userId ~= 0 then
		v11 = React.createElement(ParticipantAvatar, {
			avatarSize = avatarSize.XLarge,
			isDimmed = props.participant.isDimmed,
			isSpeaking = props.participant.isSpeaking,
			ringSize = 70,
			userId = props.participant.userId
		})
	end

	local v7 = {
		Avatar = createElement2(view, v9, { Content = v11 }),
		Actions = 0
	}
	local v12

	if not props.participant.showStatusAnimation then
		local createElement3 = React.createElement

		local v15 = {
			Headphones = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.Headphones,
				isCircular = true,
				onActivated = props.onToggleConversationAudio,
				size = inputSize.Medium,
				testId = "friends-calling-pip-headphones"
			}),
			Microphone = 0
		}

		local createElement4 = React.createElement

		local v18 = if props.isMicrophoneMuted then iconName.MicrophoneSlash else iconName.Microphone
		v15.Microphone = createElement4(iconButton, {
			LayoutOrder = 2,
			icon = v18,
			isCircular = true,
			onActivated = props.onToggleMicrophone,
			size = inputSize.Medium,
			testId = "friends-calling-pip-microphone"
		})
		v12 = createElement3(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center gap-xsmall auto-xy padding-xsmall radius-circle bg-over-media-300"
			},
			v15
		)
	end

	v7.Actions = v12
	return createElement(
		view,
		{
			tag = "col align-x-center align-y-center gap-small size-full padding-medium stroke-standard stroke-default radius-large clip bg-surface-200"
		},
		v7
	)
end

return CollapsedCallOverlay
