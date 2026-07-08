local ProductPurchaseSurface = require(script.Enums.ProductPurchaseSurface)
local ProductKind = require(script.Enums.ProductKind)

return {
	FFlagUnifiedPurchaseFlowShouldCacheExperimentResult = require(script.Flags.FFlagUnifiedPurchaseFlowShouldCacheExperimentResult),
	GetFFlagDevSubsEligibleForUnifiedPurchaseFlow = require(script.Flags.GetFFlagDevSubsEligibleForUnifiedPurchaseFlow),
	Enums = {
		ProductKind = ProductKind,
		ProductPurchaseSurface = ProductPurchaseSurface,
		PurchaseLookItemStatusEnum = require(script.Enums.PurchaseLookItemStatusEnum),
		PurchaseLookStatusEnum = require(script.Enums.PurchaseLookStatusEnum)
	},
	Events = require(script.Events.PurchaseEvents),
	Thunks = {
		OpenCentralOverlayForUnifiedPurchasePrompt = require(script.State.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
	},
	getIsUserEligibleForUnifiedPurchaseFlow = require(script.Utils.getIsUserEligibleForUnifiedPurchaseFlow),
	getTTIEventName = require(script.Utils.getTTIEventName),
	["jest.config"] = script["jest.config"]
}
