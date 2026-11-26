require("@luauforge/bundled/hId")

local module = require("@luauforge/bundled/hIg")
local module2 = require("@luauforge/bundled/hIl")
local module3 = require("@luauforge/bundled/hIe")
local module4 = require("@luauforge/bundled/hIC")
require("@luauforge/bundled/hIG")

local viewName = module3.ViewName
local eventType = module3.EventType
local viewMessage = module3.ViewMessage

local function isVpcOptimizedDialog(p2): boolean
	return p2 ~= module4.PurchaseDisabledAskParentModal
end

local function getPurchaseDisabledViewName(p2)
	if p2 ~= module4.PurchaseDisabledAskParentModal then
		return viewName.OptimizedPurchaseVpcModal
	end

	return viewName.PurchaseVpcModal
end

return {
	createPurchaseWarningsTracking = function(p2, data)
		local purchaseFlowUuid = data.purchaseFlowUuid

		if typeof(purchaseFlowUuid) ~= "string" or purchaseFlowUuid == "" then
			return nil
		end

		local function getTracker()
			return module.get(purchaseFlowUuid, p2.dependencies.eventIngest)
		end

		return {
			onPurchaseStarted = function()
				if module2 then
					module.get(purchaseFlowUuid, p2.dependencies.eventIngest).flushPendingImpressions()
				end

				local trackFlow = module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow
				local productPurchase = viewName.ProductPurchase
				local userInput = eventType.UserInput
				local formatted = `{data.productId},{data.displayName or ""}`
				local v5 = { productId = data.productId, purchaseFromSectionType = 0 }
				local sectionType = data.sectionType
				local v6 = if typeof(sectionType) == "string" then module3.PurchaseFromSectionType[sectionType] else nil

				v5.purchaseFromSectionType = v6 or module3.UnknownSectionType
				trackFlow(productPurchase, userInput, formatted, v5)
			end,
			onPurchaseWarningShown = function(p3)
				module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow(
					viewName.PurchaseWarning,
					eventType.ViewShown,
					p3
				)
			end,
			onEconomicRestrictionShown = function()
				module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow(
					viewName.EconomicRestrictionError,
					eventType.ViewShown
				)
			end,
			onPurchaseDisabledShown = function(p3)
				local trackFlow = module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow
				local v5 = if p3 ~= module4.PurchaseDisabledAskParentModal then viewName.OptimizedPurchaseVpcModal else viewName.PurchaseVpcModal

				trackFlow(v5, eventType.ViewShown, viewMessage.PurchaseNotEnabled)
			end,
			onPurchaseDisabledGoToSettings = function(p3)
				local trackFlow = module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow
				local v5 = if p3 ~= module4.PurchaseDisabledAskParentModal then viewName.OptimizedPurchaseVpcModal else viewName.PurchaseVpcModal

				trackFlow(v5, eventType.UserInput, viewMessage.GoToSettings)
			end,
			onPurchaseDisabledClosed = function(p3)
				local trackFlow = module.get(purchaseFlowUuid, p2.dependencies.eventIngest).trackFlow
				local v5

				if p3 ~= module4.PurchaseDisabledAskParentModal then
					v5 = viewName.OptimizedPurchaseVpcModal
				else
					v5 = viewName.PurchaseVpcModal
				end

				local userInput = eventType.UserInput
				local v6 = if p3 ~= module4.PurchaseDisabledAskParentModal then viewMessage.Close else viewMessage.Cancel
				trackFlow(v5, userInput, v6)
			end
		}
	end,
	getPurchaseFromSectionType = function(value)
		return (if typeof(value) == "string" then module3.PurchaseFromSectionType[value] else nil)
			or module3.UnknownSectionType
	end
}
