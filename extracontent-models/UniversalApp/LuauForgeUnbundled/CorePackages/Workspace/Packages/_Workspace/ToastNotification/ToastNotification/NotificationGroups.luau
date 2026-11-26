local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum

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
