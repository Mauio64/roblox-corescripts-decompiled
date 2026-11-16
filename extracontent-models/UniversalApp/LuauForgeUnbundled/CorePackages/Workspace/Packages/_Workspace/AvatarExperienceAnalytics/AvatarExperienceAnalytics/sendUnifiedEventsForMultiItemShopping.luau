local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local UnifiedSelectionListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedSelectionListStore")
local reportAvatarEventCounterV1 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportAvatarEventCounterV1")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXFixSearchPurchaseSurface = AvatarExperienceFlags.FFlagAXFixSearchPurchaseSurface
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

return function(items, p2, p3)
	local selectionList = UnifiedSelectionListStore.getSelectionList()

	local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v6 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

	for k, item in items do
		local v7 = nil

		for k2, selection in selectionList do
			if
				tostring(selection[v5]) == tostring(item.itemId)
				and tostring(selection[v6]) == tostring(item.itemType)
			then
				v7 = selection
				break
			end
		end

		local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v7)
		local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, item)
		local v9

		if
			fFlagAXUnifiedEventStrictPayloads
			and fFlagAXFixSearchPurchaseSurface
			and fieldsToSendFromInstanceAttributes.surface ~= nil
		then
			v9 = fieldsToSendFromInstanceAttributes.surface
		else
			v9 = if fFlagAXFixSearchPurchaseSurface and joined.surface ~= nil then joined.surface else p2
		end

		local joined2 = Cryo.Dictionary.join(joined, { surface = v9 })

		if fFlagAXUnifiedEventStrictPayloads then
			local v10 = if p3 then p3[k] else nil
			joined2 = Cryo.Dictionary.join(v10 or {}, joined2)
		end

		if joined2.action == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS then
			if joined2.itemType == UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET then
				reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseAsset)
			elseif joined2.itemType == UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE then
				reportAvatarEventCounterV1(Constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseBundle)
			end
		end

		sendUnifiedEventLog(joined2)
	end
end
