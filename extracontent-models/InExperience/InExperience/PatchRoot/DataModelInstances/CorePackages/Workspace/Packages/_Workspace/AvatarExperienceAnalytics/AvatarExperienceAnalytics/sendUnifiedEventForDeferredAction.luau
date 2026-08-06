local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local CollectionService = game:GetService("CollectionService")
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local AvatarExperienceFlags = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)
local LastDeferredSingleItemStore = require(script.Parent.Store.LastDeferredSingleItemStore)
local FFlagAXAvatarSortInDiscoveryUnifiedPurchase = require(AvatarExperienceAnalyticsParent.SharedFlags).FFlagAXAvatarSortInDiscoveryUnifiedPurchase
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedSelectionListStore (copy), UnifiedEventLogConstants (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), LastDeferredSingleItemStore (copy), UnifiedEventLoggingUtils (copy), sendUnifiedEventLog (copy), Cryo (copy), CollectionService (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), sendUnifiedEventLogForInstance (copy)
	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		local v17 = UnifiedSelectionListStore.getSelectionList()
		local v18 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v19 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
		local v20 = nil

		for _, v22 in v17 do
			if v22[v18] == t1.itemId and tostring(v22[v19]) == tostring(t1.itemType) then
				v20 = v22

				break
			end
		end

		if FFlagAXFixSingleItemPurchaseWidgetLogging and v20 == nil then
			if t1.action == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS then
				local v23 = LastDeferredSingleItemStore.getSnapshot()

				LastDeferredSingleItemStore.clearSnapshot()

				if v23 then
					local v24 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v23)

					sendUnifiedEventLog(Cryo.Dictionary.join(v24, t1))

					return
				end
			end

			sendUnifiedEventLog(t1)

			return
		end

		local v25 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v20)
		local v26 = Cryo.Dictionary.join(v25, t1)

		sendUnifiedEventLog(v26)

		return
	end

	local UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

	if FFlagAXAvatarSortInDiscoveryUnifiedPurchase then
		if #UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME > 0 then
			for _, v29 in UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME do
				sendUnifiedEventLogForInstance(v29, t1, {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end

			return
		end

		sendUnifiedEventLog(t1)

		return
	end

	for _, v31 in UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME do
		sendUnifiedEventLogForInstance(v31, t1, {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end
