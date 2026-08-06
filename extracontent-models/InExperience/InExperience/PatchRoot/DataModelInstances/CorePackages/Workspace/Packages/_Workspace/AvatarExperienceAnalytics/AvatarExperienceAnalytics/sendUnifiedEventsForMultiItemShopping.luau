local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)
local reportAvatarEventCounterV1 = require(script.Parent.reportAvatarEventCounterV1)
local Constants = require(script.Parent.Constants)
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
local v11 = game:DefineFastFlag("AXAddV1CountersForMISPurchaseSuccess", false)

return function(p1, p2) -- line: 15
	-- upvalues: UnifiedSelectionListStore (copy), UnifiedEventLogConstants (copy), UnifiedEventLoggingUtils (copy), Cryo (copy), v11 (copy), UnifiedEventLogEnums (copy), reportAvatarEventCounterV1 (copy), Constants (copy), sendUnifiedEventLog (copy)
	local v14 = UnifiedSelectionListStore.getSelectionList()
	local v15 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v16 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

	for _, v18 in p1 do
		local v19 = nil

		for _, v21 in v14 do
			if tostring(v21[v15]) == tostring(v18.itemId) and tostring(v21[v16]) == tostring(v18.itemType) then
				v19 = v21

				break
			end
		end

		local v22 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v19)
		local v23 = Cryo.Dictionary.join(v22, v18)
		local v24 = Cryo.Dictionary.join(v23, {
			surface = p2
		})

		if v11 and v24.action == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS then
			if v24.itemType == UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET then
				reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseAsset)
			elseif v24.itemType == UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE then
				reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseBundle)
			end
		end

		sendUnifiedEventLog(v24)
	end
end
