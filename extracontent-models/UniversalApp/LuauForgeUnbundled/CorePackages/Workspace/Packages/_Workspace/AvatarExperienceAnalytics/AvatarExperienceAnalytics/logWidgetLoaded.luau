require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceModel")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")

local fFlagAXDeferWidgetLoadedUntilMarketplaceEntered = AvatarExperienceFlags.FFlagAXDeferWidgetLoadedUntilMarketplaceEntered
local fFlagAXLimitWidgetLoadedItemCount = AvatarExperienceFlags.FFlagAXLimitWidgetLoadedItemCount
local fIntAXWidgetLoadedItemCountLimit = AvatarExperienceFlags.FIntAXWidgetLoadedItemCountLimit
local fFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local getUnifiedDeferredEventStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/getUnifiedDeferredEventStore")

local WIDGET_LOADED = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED
local function logWidgetLoaded(items, requestId, callback)
	if fFlagAXDeferWidgetLoadedUntilMarketplaceEntered then
		local v5 = getUnifiedDeferredEventStore(false)

		if not v5.isEntered(false) then
			v5.enqueue(WIDGET_LOADED, function()
				logWidgetLoaded(items, requestId, if fFlagAXUnifiedEventCounters then callback else nil)
			end)
			return
		end
	end

	local v5 = if fFlagAXUnifiedEventCounters and callback ~= nil then callback() else nil

	for k, item in items do
		local ids = {}
		local ids2 = {}
		local ids3 = {}

		if item.content then
			for k2, v7 in item.content do
				if fFlagAXLimitWidgetLoadedItemCount and fIntAXWidgetLoadedItemCountLimit <= #ids3 then
					break
				end

				if v7.type == "Asset" then
					table.insert(ids, v7.id)
				elseif v7.type == "Bundle" then
					table.insert(ids2, v7.id)
				end

				table.insert(ids3, v7.id)
			end
		end

		sendUnifiedEventLog({
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED,
			surface = if fFlagAXUnifiedEventCounters then v5 else nil,
			requestId = requestId,
			widgetId = item.id,
			widgetType = item.type,
			themeId = item.tagId,
			gridPositionRow = k,
			gridPositionColumn = 1,
			assetIds = table.concat(ids, ","),
			bundleIds = table.concat(ids2, ","),
			widgetItemIds = table.concat(ids3, ",")
		})
	end
end

return logWidgetLoaded
