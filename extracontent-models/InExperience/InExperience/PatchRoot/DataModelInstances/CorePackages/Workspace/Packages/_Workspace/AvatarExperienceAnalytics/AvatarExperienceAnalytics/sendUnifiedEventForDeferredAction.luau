local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local CollectionService = game:GetService("CollectionService")
local Cryo = require(parent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local mapAnalyticsMetadataFields = require(AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields)
require(script.Parent.Generated.UnifiedEventTypes)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)
local LastDeferredSingleItemStore = require(script.Parent.Store.LastDeferredSingleItemStore)

local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging
local FFlagAXFixUnifiedPurchaseFieldLanding = AvatarExperienceFlags.FFlagAXFixUnifiedPurchaseFieldLanding
local FFlagAXFixDeferredItemIdTypeMatch = AvatarExperienceFlags.FFlagAXFixDeferredItemIdTypeMatch
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function fillUnsetFields(p, options) -- 4 equivalent calls inferred from this helper
	return Cryo.Dictionary.join(options or {}, p)
end

local function getUnsetInstanceFields(instance, items)
	local unsetInstanceFields = {}

	if items then
		for k, item in items do
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
	if FFlagAXFixUnifiedPurchaseFieldLanding then
		data = mapAnalyticsMetadataFields(data)
	end

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		local selectionList = UnifiedSelectionListStore.getSelectionList()

		local v = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v2 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
		local v3 = nil

		for _, selection in selectionList do
			local v4

			if FFlagAXFixDeferredItemIdTypeMatch then
				v4 = tostring(selection[v]) == tostring(data.itemId)
			else
				v4 = selection[v] == data.itemId
			end

			if v4 and tostring(selection[v2]) == tostring(data.itemType) then
				v3 = selection
				break
			end
		end

		if FFlagAXFixSingleItemPurchaseWidgetLogging and v3 == nil then
			if data.action == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS then
				local snapshot = LastDeferredSingleItemStore.getSnapshot()
				LastDeferredSingleItemStore.clearSnapshot()

				if snapshot then
					local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(snapshot)
					local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, data)

					if FFlagAXUnifiedEventStrictPayloads then
						joined = fillUnsetFields(joined, options) -- inferred equivalent call
					end

					sendUnifiedEventLog(joined)

					return
				end
			end

			if FFlagAXUnifiedEventStrictPayloads then
				data = fillUnsetFields(data, options) -- inferred equivalent call
			end

			sendUnifiedEventLog(data)
		else
			local fieldsToSendFromInstanceAttributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v3)
			local joined = Cryo.Dictionary.join(fieldsToSendFromInstanceAttributes, data)

			if FFlagAXUnifiedEventStrictPayloads then
				joined = fillUnsetFields(joined, options) -- inferred equivalent call
			end

			sendUnifiedEventLog(joined)
		end
	else
		local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

		if #tagged > 0 then
			for _, v in tagged do
				local v2

				if FFlagAXUnifiedEventStrictPayloads then
					v2 = Cryo.Dictionary.join(getUnsetInstanceFields(v, options), data)
				else
					v2 = data
				end

				sendUnifiedEventLogForInstance(v, v2, {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end
		else
			if FFlagAXUnifiedEventStrictPayloads then
				data = fillUnsetFields(data, options) -- inferred equivalent call
			end

			sendUnifiedEventLog(data)
		end
	end
end
