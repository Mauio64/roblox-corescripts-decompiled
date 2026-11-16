local module = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Enums/ProductPurchaseSurface")
return {
	Enums = {
		ProductKind = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Enums/ProductKind"),
		ProductPurchaseSurface = module,
		PurchaseLookItemStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Enums/PurchaseLookItemStatusEnum"),
		PurchaseLookStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Enums/PurchaseLookStatusEnum")
	},
	Events = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Events/PurchaseEvents"),
	Thunks = { OpenCentralOverlayForUnifiedPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/OpenCentralOverlayForUnifiedPurchasePrompt") },
	getIsUserEligibleForUnifiedPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Utils/getIsUserEligibleForUnifiedPurchaseFlow"),
	getTTIEventName = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/Utils/getTTIEventName")
}
