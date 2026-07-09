local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PurchaseErrors = require(Modules.LuaApp.Enum.PurchaseErrors)

return {
	[PurchaseErrors.NotEnoughRobux] = "CoreScripts.PurchasePrompt.PurchaseFailed.NotEnoughRobux",
	[PurchaseErrors.PurchaseDisabled] = "CoreScripts.PurchasePrompt.PurchaseFailed.PurchaseDisabled",
	[PurchaseErrors.UnknownFailure] = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
	[PurchaseErrors.NotForSale] = "CoreScripts.PurchasePrompt.PurchaseFailed.NotForSale",
	[PurchaseErrors.Under13] = "CoreScripts.PurchasePrompt.PurchaseFailed.Under13",
	[PurchaseErrors.AlreadyOwn] = "CoreScripts.PurchasePrompt.PurchaseFailed.AlreadyOwn",
	[PurchaseErrors.TooManyPurchases] = "Feature.Toast.NetworkingError.TooManyRequests",
	[PurchaseErrors.InvalidRequest] = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
	[PurchaseErrors.Unauthorized] = "Feature.Toast.NetworkingError.Unauthorized"
}
