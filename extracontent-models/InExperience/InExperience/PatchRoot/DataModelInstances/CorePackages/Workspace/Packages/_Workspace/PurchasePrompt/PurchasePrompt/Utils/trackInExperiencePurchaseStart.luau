local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local getPurchaseSurface = require(PurchasePrompt.Utils.getPurchaseSurface)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)

local function trackInExperiencePurchaseStart(object)
	local state = object:getState()

	if getPurchaseSurface(state.purchaseAnalyticsMetadata) ~= ProductPurchaseSurface.InExperience then
		return
	end

	local ttiEventName = getTTIEventName(ProductPurchaseSurface.InExperience)
	timeToInteractiveTracker.trackStart(ttiEventName)
	timeToInteractiveTracker.updateMetadata(ttiEventName, {
		page = ProductPurchaseSurface.InExperience,
		category = "unified_purchase_modal",
		subcategory = getProductTypeFromRequestType(state.promptRequest.requestType)
	})
end

return trackInExperiencePurchaseStart
