local ParentParent = script.Parent.Parent

require(ParentParent.ToastNotificationsProtocol)

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
	Portrait = "Portrait",
	Landscape = "Landscape",
	Unknown = "Unknown"
}
local t4 = {
	Report = "reportNotification",
	Deeplink = "deeplink",
	NotificationApi = "notificationAPI",
	Dismiss = "dismiss",
	Reload = "reload",
	None = "none",
	VoltronBroadcast = "voltronBroadcast",
	UpdateState = "updateState",
	ClientTrigger = "clientTrigger"
}
local t5 = {
	Primary = "Primary",
	Secondary = "Secondary",
	Alert = "Alert",
	Growth = "Growth"
}
local t6 = {
	User = "userThumbnail",
	Game = "gameThumbnail",
	Group = "groupThumbnail",
	Asset = "assetThumbnail",
	Bundle = "bundleThumbnail",
	Icon = "icon",
	GamePass = "gamePassThumbnail",
	AvatarImageUrl = "avatarImageUrlThumbnail"
}
local t7 = {
	CallReceived = "CallReceived"
}
local t8 = {
	App = "toast-in-app-notifications",
	Experience = "toast-in-experience-notifications",
	Dual = "toast-in-app-and-experience-notifications",
	Desktop = "toast-in-app-and-experience-desktop-notifications"
}
local t9 = {
	ModalCancel = "modalCancel",
	ModalConfirm = "modalConfirm",
	Dismissed = "dismissed",
	Display = "displayed",
	Hover = "hoverOver",
	Ignored = "ignored",
	Update = "update",
	DeeplinkFailed = "deeplinkFailed"
}

return {
	ChannelListEnum = t8,
	ActionTypeEnum = t4,
	SENDERButtonStyleEnum = t5,
	SENDERThumbnailTypeEnum = t6,
	ToastNotificationActionsEnum = t9,
	RenderLocationEnum = t2,
	DeviceOrientationEnum = t3,
	VisualItemTypeEnum = t1,
	NotificationTypeEnum = t7
}
