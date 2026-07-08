local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("ToastNotifications", "initializeToastNotifications")
local MessageId2 = MessageBusService:GetMessageId("ToastNotifications", "getToastNotification")
local MessageId3 = MessageBusService:GetMessageId("ToastNotifications", "updateToastNotificationState")
local MessageId4 = MessageBusService:GetMessageId("ToastNotifications", "dismissToastNotification")
local MessageId5 = MessageBusService:GetMessageId("ToastNotifications", "displayToastNotification")

return {
	PROTOCOL_NAME = "ToastNotifications",
	MESSAGE_INIT_TOAST_NOTIF = MessageId,
	MESSAGE_GET_TOAST_NOTIF = MessageId2,
	MESSAGE_UPDATE_TOAST_NOTIF = MessageId3,
	MESSAGE_DISMISS_TOAST_NOTIF = MessageId4,
	MESSAGE_DISPLAY_TOAST_NOTIF = MessageId5
}
