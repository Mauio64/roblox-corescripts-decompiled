local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

require(parent.AvatarExperienceModel)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagAXDeferWidgetLoadedUntilMarketplaceEntered = AvatarExperienceFlags.FFlagAXDeferWidgetLoadedUntilMarketplaceEntered
local FFlagAXLimitWidgetLoadedItemCount = AvatarExperienceFlags.FFlagAXLimitWidgetLoadedItemCount
local FIntAXWidgetLoadedItemCountLimit = AvatarExperienceFlags.FIntAXWidgetLoadedItemCountLimit
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local getUnifiedDeferredEventStore = require(script.Parent.Store.getUnifiedDeferredEventStore)

local WIDGET_LOADED = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED
local function logWidgetLoaded(items, requestId: string, callback)
	if FFlagAXDeferWidgetLoadedUntilMarketplaceEntered then
		local unifiedDeferredEventStore = getUnifiedDeferredEventStore(false)

		if not unifiedDeferredEventStore.isEntered(false) then
			unifiedDeferredEventStore.enqueue(WIDGET_LOADED, function()
				local v

				if FFlagAXUnifiedEventCounters then
					v = callback
				end

				logWidgetLoaded(items, requestId, v)
			end)
			return
		end
	end

	local v

	if FFlagAXUnifiedEventCounters and callback ~= nil then
		v = callback()
	end

	for k, item in items do
		local ids = {}
		local ids2 = {}
		local ids3 = {}

		if item.content then
			for _, v2 in item.content do
				if FFlagAXLimitWidgetLoadedItemCount and FIntAXWidgetLoadedItemCountLimit <= #ids3 then
					break
				end

				if v2.type == "Asset" then
					table.insert(ids, v2.id)
				elseif v2.type == "Bundle" then
					table.insert(ids2, v2.id)
				end

				table.insert(ids3, v2.id)
			end
		end

		local v2 = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED,
			surface = 0,
			requestId = 0,
			widgetId = 0,
			widgetType = 0,
			themeId = 0,
			gridPositionRow = 0,
			gridPositionColumn = 1,
			assetIds = 0,
			bundleIds = 0,
			widgetItemIds = 0
		}
		local surface

		if FFlagAXUnifiedEventCounters then
			surface = v
		end

		v2.surface = surface
		v2.requestId = requestId
		v2.widgetId = item.id
		v2.widgetType = item.type
		v2.themeId = item.tagId
		v2.gridPositionRow = k

		v2.assetIds = table.concat(ids, ",")
		v2.bundleIds = table.concat(ids2, ",")
		v2.widgetItemIds = table.concat(ids3, ",")
		sendUnifiedEventLog(v2)
	end
end

return logWidgetLoaded
