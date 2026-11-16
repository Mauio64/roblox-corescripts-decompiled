local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")

local avatar = Foundation.Avatar
local avatarSize = Foundation.Enums.AvatarSize
local view = Foundation.View

local function ParticipantAvatar(props)
	local createElement = React.createElement
	local v6 = {
		Size = UDim2.fromOffset(props.ringSize, props.ringSize),
		tag = "position-center-center anchor-center-center"
	}

	local v8 = if props.isSpeaking then React.createElement(view, {
		Size = UDim2.fromOffset(props.ringSize, props.ringSize),
		tag = "position-center-center anchor-center-center stroke-thick stroke-system-success radius-circle",
		testId = "friends-calling-participant-speaking"
	}) else nil
	return createElement(view, v6, {
		SpeakingRing = v8,
		Avatar = React.createElement(view, {
			GroupTransparency = props.isDimmed and 0.7 or nil,
			tag = "position-center-center anchor-center-center auto-xy",
			testId = "friends-calling-participant-avatar"
		}, {
			Headshot = React.createElement(avatar, {
				size = props.avatarSize,
				userId = props.userId
			})
		})
	})
end

return ParticipantAvatar
