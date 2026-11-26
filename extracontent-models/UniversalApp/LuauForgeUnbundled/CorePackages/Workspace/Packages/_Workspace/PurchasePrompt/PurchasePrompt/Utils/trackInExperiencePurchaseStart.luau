local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")
local productPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getTTIEventName = PurchasePromptLite.getTTIEventName
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/TimeToInteractiveTracker").TimeToInteractiveTracker
local getPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPurchaseSurface")
local getProductTypeFromRequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getProductTypeFromRequestType")

local function trackInExperiencePurchaseStart(object)
	local state = object:getState()

	if getPurchaseSurface(state.purchaseAnalyticsMetadata) ~= productPurchaseSurface.InExperience then
		return
	end

	local ttiEventName = getTTIEventName(productPurchaseSurface.InExperience)
	timeToInteractiveTracker.trackStart(ttiEventName)
	timeToInteractiveTracker.updateMetadata(ttiEventName, {
		page = productPurchaseSurface.InExperience,
		category = "unified_purchase_modal",
		subcategory = getProductTypeFromRequestType(state.promptRequest.requestType)
	})
end

return trackInExperiencePurchaseStart
