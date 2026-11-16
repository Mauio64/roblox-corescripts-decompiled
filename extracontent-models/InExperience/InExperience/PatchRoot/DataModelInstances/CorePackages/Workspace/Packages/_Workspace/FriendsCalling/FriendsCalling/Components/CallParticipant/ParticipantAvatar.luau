local parent = script:FindFirstAncestor("FriendsCalling").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Avatar = Foundation.Avatar
local AvatarSize = Foundation.Enums.AvatarSize
local View = Foundation.View

local function ParticipantAvatar(props)
	local createElement = React.createElement
	local v = {
		Size = UDim2.fromOffset(props.ringSize, props.ringSize),
		tag = "position-center-center anchor-center-center"
	}
	local speakingRing

	if props.isSpeaking then
		speakingRing = React.createElement(View, {
			Size = UDim2.fromOffset(props.ringSize, props.ringSize),
			tag = "position-center-center anchor-center-center stroke-thick stroke-system-success radius-circle",
			testId = "friends-calling-participant-speaking"
		})
	end

	return createElement(View, v, {
		SpeakingRing = speakingRing,
		Avatar = React.createElement(View, {
			GroupTransparency = props.isDimmed and 0.7 or nil,
			tag = "position-center-center anchor-center-center auto-xy",
			testId = "friends-calling-participant-avatar"
		}, {
			Headshot = React.createElement(Avatar, {
				size = props.avatarSize,
				userId = props.userId
			})
		})
	})
end

return ParticipantAvatar
