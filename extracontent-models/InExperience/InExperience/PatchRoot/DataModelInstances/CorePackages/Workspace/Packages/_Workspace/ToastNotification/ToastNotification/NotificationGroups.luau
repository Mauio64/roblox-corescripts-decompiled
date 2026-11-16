local parent = script.Parent
local kind = require(parent.type)

local notificationTypeEnum = kind.NotificationTypeEnum

return {
	ChatMessageGroup = { notificationTypeEnum.ChatNewMessage, notificationTypeEnum.SquadInvitation },
	ChatLandingNotificationsGroup = {
		notificationTypeEnum.ChatNewMessage,
		notificationTypeEnum.SquadInvitation,
		notificationTypeEnum.SquadStartPartyPrompt,
		notificationTypeEnum.SquadNudgeInvite
	},
	SquadNudgeInviteGroup = { notificationTypeEnum.SquadNudgeInvite },
	SquadStartPartyPromptGroup = { notificationTypeEnum.SquadStartPartyPrompt }
}
