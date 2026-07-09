local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local CollectionService = game:GetService("CollectionService")
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local AvatarExperienceFlags = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)
local FFlagAXAvatarSortInDiscoveryUnifiedPurchase = require(AvatarExperienceAnalyticsParent.SharedFlags).FFlagAXAvatarSortInDiscoveryUnifiedPurchase
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedSelectionListStore (copy), UnifiedEventLogConstants (copy), UnifiedEventLoggingUtils (copy), Cryo (copy), sendUnifiedEventLog (copy), CollectionService (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), sendUnifiedEventLogForInstance (copy)
	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		local v14 = UnifiedSelectionListStore.getSelectionList()
		local v15 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v16 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
		local v17 = nil

		for _, v19 in v14 do
			if v19[v15] == t1.itemId and tostring(v19[v16]) == tostring(t1.itemType) then
				v17 = v19

				break
			end
		end

		local v20 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v17)
		local v21 = Cryo.Dictionary.join(v20, t1)

		sendUnifiedEventLog(v21)

		return
	end

	local UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

	if FFlagAXAvatarSortInDiscoveryUnifiedPurchase then
		if #UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME > 0 then
			for _, v24 in UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME do
				sendUnifiedEventLogForInstance(v24, t1, {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end

			return
		end

		sendUnifiedEventLog(t1)

		return
	end

	for _, v26 in UnifiedEventLogConstantsLAST_ACTIVATED_TAG_NAME do
		sendUnifiedEventLogForInstance(v26, t1, {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end
