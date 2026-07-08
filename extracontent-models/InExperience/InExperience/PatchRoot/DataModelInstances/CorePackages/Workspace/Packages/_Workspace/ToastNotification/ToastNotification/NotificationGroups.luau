local scriptParent = script.Parent
local NotificationTypeEnum = require(scriptParent.type).NotificationTypeEnum

return {
	ChatMessageGroup = {
		NotificationTypeEnum.ChatNewMessage,
		NotificationTypeEnum.SquadInvitation
	},
	ChatLandingNotificationsGroup = {
		NotificationTypeEnum.ChatNewMessage,
		NotificationTypeEnum.SquadInvitation,
		NotificationTypeEnum.SquadStartPartyPrompt,
		NotificationTypeEnum.SquadNudgeInvite
	},
	SquadNudgeInviteGroup = { NotificationTypeEnum.SquadNudgeInvite },
	SquadStartPartyPromptGroup = { NotificationTypeEnum.SquadStartPartyPrompt }
}
