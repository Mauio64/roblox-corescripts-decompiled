local CollectionService = game:GetService("CollectionService")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")
local mapAnalyticsMetadataFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/mapAnalyticsMetadataFields")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local UnifiedSelectionListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedSelectionListStore")
local LastDeferredSingleItemStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/LastDeferredSingleItemStore")

local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging
local fFlagAXFixUnifiedPurchaseFieldLanding = AvatarExperienceFlags.FFlagAXFixUnifiedPurchaseFieldLanding
local fFlagAXFixDeferredItemIdTypeMatch = AvatarExperienceFlags.FFlagAXFixDeferredItemIdTypeMatch
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function fillUnsetFields(p2, options)
	return Cryo.Dictionary.join(options or {}, p2)
end

local function getUnsetInstanceFields(instance, options)
	local unsetInstanceFields = {}

	if options then
		for k, item in options do
			unsetInstanceFields[k] = item
		end
	end

	for k in unsetInstanceFields do
		if instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k) ~= nil then
			unsetInstanceFields[k] = nil
		end
	end

	return unsetInstanceFields
end

return function(data, options)
	if fFlagAXFixUnifiedPurchaseFieldLanding then
		data = mapAnalyticsMetadataFields(data)
	end

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		local selectionList = UnifiedSelectionListStore.getSelectionList()

		local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v6 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
		local v7 = nil

		for k, selection in selectionList do
			local v9

			if fFlagAXFixDeferredItemIdTypeMatch then
				v9 = tostring(selection[v5]) == tostring(data.itemId)
			else
				v9 = selection[v5] == data.itemId
			end

			if v9 and tostring(selection[v6]) == tostring(data.itemType) then
				v7 = selection
				break
			end
		end

		if fFlagAXFixSingleItemPurchaseWidgetLogging and v7 == nil then
			if data.action == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS then
				local snapshot = LastDeferredSingleItemStore.getSnapshot()
				LastDeferredSingleItemStore.clearSnapshot()

				if snapshot then
					local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(snapshot)
					local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, data)

					if fFlagAXUnifiedEventStrictPayloads then
						joined = Cryo.Dictionary.join(options or {}, joined)
					end

					sendUnifiedEventLog(joined)

					return
				end
			end

			if fFlagAXUnifiedEventStrictPayloads then
				data = Cryo.Dictionary.join(options or {}, data)
			end

			sendUnifiedEventLog(data)
		else
			local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v7)
			local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, data)

			if fFlagAXUnifiedEventStrictPayloads then
				joined = Cryo.Dictionary.join(options or {}, joined)
			end

			sendUnifiedEventLog(joined)
		end
	else
		local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

		if #tagged > 0 then
			for k, v5 in tagged do
				local v7 = if fFlagAXUnifiedEventStrictPayloads then Cryo.Dictionary.join(
					getUnsetInstanceFields(v5, options),
					data
				) else data
				sendUnifiedEventLogForInstance(v5, v7, {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end
		else
			if fFlagAXUnifiedEventStrictPayloads then
				data = Cryo.Dictionary.join(options or {}, data)
			end

			sendUnifiedEventLog(data)
		end
	end
end
