local ParentParent = script.Parent.Parent

require(ParentParent.ToastNotificationsProtocol)

local Images = require(ParentParent.UIBlox).App.ImageSet.Images
local t1 = {
	Button = "button",
	TextBody = "textBody",
	Thumbnail = "thumbnail",
	MetaAction = "metaAction"
}
local t2 = {
	UniversalApp = "universalApp",
	CoreScript = "coreScript"
}
local t3 = {
	Mute = "Mute",
	Unmute = "Unmute"
}
local t4 = {
	Portrait = "Portrait",
	Landscape = "Landscape",
	Unknown = "Unknown"
}
local t5 = {
	Report = "reportNotification",
	Deeplink = "deeplink",
	NotificationApi = "notificationAPI",
	Dismiss = "dismiss",
	Reload = "reload",
	None = "none",
	VoltronBroadcast = "voltronBroadcast",
	UpdateState = "updateState",
	WebView = "webview"
}
local t6 = {
	Primary = "Primary",
	Secondary = "Secondary",
	Alert = "Alert",
	Growth = "Growth"
}
local t7 = {
	User = "userThumbnail",
	Game = "gameThumbnail",
	Group = "groupThumbnail",
	Asset = "assetThumbnail",
	Bundle = "bundleThumbnail",
	Icon = "icon",
	AvatarImageUrl = "avatarImageUrlThumbnail"
}
local t8 = {
	CallReceived = "CallReceived",
	ChatNewMessage = "ChatNewMessage",
	ScheduledSquadReminder = "ScheduledSquadReminder",
	ScheduledSquadHappeningNow = "ScheduledSquadHappeningNow",
	SquadInvitation = "SquadInvitation",
	SquadInvitationV2 = "SquadInvitationV2",
	SquadExperienceInvitation = "SquadExperienceInvitation",
	SquadJoinRequestPrompt = "SquadJoinRequestPrompt",
	SquadAcceptJoinRequest = "SquadAcceptJoinRequest",
	SquadStartPartyPrompt = "SquadStartPartyPrompt",
	SquadNudgeInvite = "SquadNudgeInvite",
	NudgeForInviterSquad = "NudgeForInviterSquad",
	PromptUserToRequest = "PromptUserToRequest",
	RequestToJoinParty = "RequestToJoinParty",
	ClientNotification = "ClientNotification",
	FriendRequestReceived = "FriendRequestReceived",
	SecurityAlert = "SecurityAlert"
}
local t9 = {
	App = "toast-in-app-notifications",
	Experience = "toast-in-experience-notifications",
	Dual = "toast-in-app-and-experience-notifications",
	Desktop = "toast-in-app-and-experience-desktop-notifications"
}
local t10 = {
	ModalCancel = "modalCancel",
	ModalConfirm = "modalConfirm",
	Dismissed = "dismissed",
	Display = "displayed",
	Hover = "hoverOver",
	Ignored = "ignored",
	Update = "update",
	DeeplinkFailed = "deeplinkFailed"
}
local t11 = {
	snooze = Images["icons/common/snoozeNotificationsOff"]
}

return {
	ChannelListEnum = t9,
	ActionTypeEnum = t5,
	SENDERButtonStyleEnum = t6,
	SENDERThumbnailTypeEnum = t7,
	ToastNotificationActionsEnum = t10,
	RenderLocationEnum = t2,
	DeviceOrientationEnum = t4,
	VisualItemTypeEnum = t1,
	MetaActionIcons = t11,
	NotificationTypeEnum = t8,
	SnoozeActionEnum = t3
}
