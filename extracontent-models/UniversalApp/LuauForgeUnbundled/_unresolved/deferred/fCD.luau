local module = require("@luauforge/deferred/fCC")

return {
	[module.NotEnoughRobux] = "CoreScripts.PurchasePrompt.PurchaseFailed.NotEnoughRobux",
	[module.PurchaseDisabled] = "CoreScripts.PurchasePrompt.PurchaseFailed.PurchaseDisabled",
	[module.UnknownFailure] = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
	[module.NotForSale] = "CoreScripts.PurchasePrompt.PurchaseFailed.NotForSale",
	[module.Under13] = "CoreScripts.PurchasePrompt.PurchaseFailed.Under13",
	[module.AlreadyOwn] = "CoreScripts.PurchasePrompt.PurchaseFailed.AlreadyOwn",
	[module.TooManyPurchases] = "Feature.Toast.NetworkingError.TooManyRequests",
	[module.InvalidRequest] = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
	[module.Unauthorized] = "Feature.Toast.NetworkingError.Unauthorized"
}
