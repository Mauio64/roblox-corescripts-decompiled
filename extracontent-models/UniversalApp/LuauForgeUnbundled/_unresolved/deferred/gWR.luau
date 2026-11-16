local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/fpM")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/bundled/dMB")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module6 = require("@luauforge/bundled/dMx")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local sendAXStat = AvatarExperienceAnalytics.sendAXStat

local searchLandingPageRecentlyViewedWidget = widgetConstants.ContextWidgets.SearchLandingPageRecentlyViewedWidget

local module8 = require("@luauforge/bundled/dNb")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local getFFlagAXRecentlyViewedCounters = module.Flags.GetFFlagAXRecentlyViewedCounters

local function mapItemsToWidgetContent(p2)
	return Dash.map(p2, function(p3)
		local v5 = { id = p3.id, type = 0 }
		local v6 = if p3.itemType == module6.ItemType.Asset then widgetConstants.ContentType.Asset else widgetConstants.ContentType.Bundle
		v5.type = v6
		return v5
	end)
end

local function createWidgetInfo(p2)
	local v5 = module4.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog)
		and "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedItems"
		or "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedSearchItems"
	return {
		[searchLandingPageRecentlyViewedWidget.Context] = {
			content = Dash.map(p2, function(p3)
				local v6 = { id = p3.id, type = 0 }
				local v7 = if p3.itemType == module6.ItemType.Asset then widgetConstants.ContentType.Asset else widgetConstants.ContentType.Bundle
				v6.type = v7
				return v6
			end),
			template = { title = v5, type = widgetConstants.Templates.ItemGroup },
			id = searchLandingPageRecentlyViewedWidget.WidgetId,
			requestId = searchLandingPageRecentlyViewedWidget.RequestId,
			type = widgetConstants.Types.SearchLandingPageRecentlyViewedWidget
		}
	}
end

local function getValidItems(data)
	if #data.items == #data.existingItems + #data.fetchedItems then
		return data.items
	end

	local result = {}

	for k, item in data.items do
		local v5 = Dash.find(data.fetchedItems, function(p2): boolean
			return tostring(p2.id) == tostring(item.id) and p2.itemType == item.itemType
		end)

		local v6 = Dash.find(data.existingItems, function(p2): boolean
			return tostring(p2.id) == tostring(item.id) and p2.itemType == item.itemType
		end)

		if v5 or v6 then
			table.insert(result, item)
		end
	end

	return result
end

return function(p2, p3, items)
	return performFetch.Single(p3, function(object)
		local common = object:getState().AvatarExperience.Common
		local v5 = {}
		local v6 = {}

		for k, item in items do
			if itemData(common, item.id, item.itemType) then
				table.insert(v5, item)
			else
				table.insert(v6, item)
			end
		end

		local v7 = {}
		local v8 = {}
		local v9 = {}

		if not (#v6 > 0) then
			object:dispatch(module8({
				assetData = v8,
				bundleData = v9,
				widget = {
					widgetInfo = createWidgetInfo(getValidItems({
						items = items,
						existingItems = v5,
						itemsToFetch = v6,
						fetchedItems = v7
					})),
					requestId = searchLandingPageRecentlyViewedWidget.RequestId,
					context = searchLandingPageRecentlyViewedWidget.Context
				}
			}))

			return Promise.resolve()
		end

		local mapped = Dash.map(v6, function(p4)
			return { id = tonumber(p4.id), itemType = p4.itemType }
		end)

		local now = if getFFlagAXRecentlyViewedCounters() then os.clock() else nil
		return GetExperienceSourceLanguage.FetchItemDetails(p2, mapped):andThen(function(p4)
			v7 = not (p4.responseBody and p4.responseBody.data) and {} or p4.responseBody.data

			for k, v10 in v7 do
				if v10.itemType == module6.ItemType.Asset then
					table.insert(v8, v10)
				elseif v10.itemType == module6.ItemType.Bundle then
					table.insert(v9, v10)
				end
			end

			if getFFlagAXRecentlyViewedCounters() and typeof(now) == "number" then
				local v10 = (os.clock() - now) * 1000
				sendAXStat({
					statName = module.Enums.Stat.FetchRecentlyViewedItemsMs,
					metaData = {
						count = tostring(#v6)
					},
					deltaMs = v10,
					excludeTelemetry = true
				})
			end

			object:dispatch(module8({
				assetData = v8,
				bundleData = v9,
				widget = {
					widgetInfo = createWidgetInfo(getValidItems({
						items = items,
						existingItems = v5,
						itemsToFetch = v6,
						fetchedItems = v7
					})),
					requestId = searchLandingPageRecentlyViewedWidget.RequestId,
					context = searchLandingPageRecentlyViewedWidget.Context
				}
			}))
		end)
	end)
end
