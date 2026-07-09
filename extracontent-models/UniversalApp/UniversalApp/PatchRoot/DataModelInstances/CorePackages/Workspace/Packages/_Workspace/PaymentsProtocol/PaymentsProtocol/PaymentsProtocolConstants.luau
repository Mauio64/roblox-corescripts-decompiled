local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("Payments", "processPendingPurchase")
local MessageId2 = MessageBusService:GetMessageId("Payments", "sendIAPEvent")
local MessageId3 = MessageBusService:GetMessageId("Payments", "onPurchaseProcessed")

return {
	NAME = "Payments",
	METHOD_LIST_NATIVE_PRODUCTS = "listNativeProducts",
	METHOD_IS_AVAILABLE = "isAvailable",
	MESSAGE_PROCESS_PENDING_PURCHASE = MessageId,
	MESSAGE_SEND_IAP_EVENT = MessageId2,
	MESSAGE_ON_PURCHASE_PROCESSED_EVENT = MessageId3
}
