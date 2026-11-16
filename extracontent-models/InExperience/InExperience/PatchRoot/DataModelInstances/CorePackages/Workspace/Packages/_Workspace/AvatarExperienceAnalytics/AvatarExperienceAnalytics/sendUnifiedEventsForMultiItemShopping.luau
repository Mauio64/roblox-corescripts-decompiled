local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local Cryo = require(parent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)
local reportAvatarEventCounterV1 = require(script.Parent.reportAvatarEventCounterV1)
local Constants = require(script.Parent.Constants)
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
require(script.Parent.Generated.UnifiedEventTypes)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXFixSearchPurchaseSurface = AvatarExperienceFlags.FFlagAXFixSearchPurchaseSurface
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

return function(items, p: number?, p2)
	local selectionList = UnifiedSelectionListStore.getSelectionList()

	local v = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v2 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

	for k, item in items do
		local v3 = nil

		for _, selection in selectionList do
			if
				tostring(selection[v]) == tostring(item.itemId)
				and tostring(selection[v2]) == tostring(item.itemType)
			then
				v3 = selection
				break
			end
		end

		local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v3)
		local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, item)
		local surface

		if
			FFlagAXUnifiedEventStrictPayloads
			and FFlagAXFixSearchPurchaseSurface
			and fieldsToSendFromInstanceAttributes.surface ~= nil
		then
			surface = fieldsToSendFromInstanceAttributes.surface
		elseif FFlagAXFixSearchPurchaseSurface and joined.surface ~= nil then
			surface = joined.surface
		else
			surface = p
		end

		local joined2 = Cryo.Dictionary.join(joined, { surface = surface })

		if FFlagAXUnifiedEventStrictPayloads then
			local v4

			if p2 then
				v4 = p2[k]
			end

			joined2 = Cryo.Dictionary.join(v4 or {}, joined2)
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
