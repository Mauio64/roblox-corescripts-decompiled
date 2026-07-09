local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Dash = require(CorePackages.Packages.Dash)
local AvatarExperienceSearch = require(CorePackages.Workspace.Packages.AvatarExperienceSearch)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local SearchLandingPageRecentlyViewedWidget = WidgetConstants.ContextWidgets.SearchLandingPageRecentlyViewedWidget
local ReceivedRecentlyViewedItemsData = require(Modules.AvatarExperience.Catalog.Actions.ReceivedRecentlyViewedItemsData)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local GetFFlagAXRemoveAwaitUsageInThunks = require(Modules.AvatarExperience.Flags.GetFFlagAXRemoveAwaitUsageInThunks)
local GetFFlagAXRecentlyViewedCounters = AvatarExperienceSearch.Flags.GetFFlagAXRecentlyViewedCounters

local function mapItemsToWidgetContent(t1: {[any]: any}) -- line: 38
	-- upvalues: Dash (copy), Constants (copy), WidgetConstants (copy)
	return Dash.map(t1, function(p1) -- line: 39
		-- upvalues: Constants (copy), WidgetConstants (copy)
		return {
			id = p1.id,
			type = if p1.itemType ~= Constants.ItemType.Asset then WidgetConstants.ContentType.Bundle else WidgetConstants.ContentType.Asset
		}
	end)
end
local function createWidgetInfo(t2: {[any]: any}) -- line: 49
	-- upvalues: IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), SearchLandingPageRecentlyViewedWidget (copy), Dash (copy), Constants (copy), WidgetConstants (copy)
	local s1 = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedSearchItems"

	if IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog) then
		s1 = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedItems"
	end

	return {
		[SearchLandingPageRecentlyViewedWidget.Context] = {
			content = Dash.map(t2, function(p2) -- line: 39
				-- upvalues: Constants (copy), WidgetConstants (copy)
				return {
					id = p2.id,
					type = if p2.itemType ~= Constants.ItemType.Asset then WidgetConstants.ContentType.Bundle else WidgetConstants.ContentType.Asset
				}
			end),
			template = {
				title = s1,
				type = WidgetConstants.Templates.ItemGroup
			},
			id = SearchLandingPageRecentlyViewedWidget.WidgetId,
			requestId = SearchLandingPageRecentlyViewedWidget.RequestId,
			type = WidgetConstants.Types.SearchLandingPageRecentlyViewedWidget
		}
	}
end
local function getValidItems(t3: {[any]: any}) -- line: 71
	-- upvalues: Dash (copy)
	if #t3.items == #t3.existingItems + #t3.fetchedItems then
		return t3.items
	end

	local t4 = {}

	for _, v31 in t3.items do
		local v32 = Dash.find(t3.fetchedItems, function(p3) -- line: 79
			-- upvalues: v31 (copy)
			return tostring(p3.id) == tostring(v31.id) and p3.itemType == v31.itemType
		end)
		local v33 = Dash.find(t3.existingItems, function(p4) -- line: 82
			-- upvalues: v31 (copy)
			return tostring(p4.id) == tostring(v31.id) and p4.itemType == v31.itemType
		end)

		if v32 or v33 then
			table.insert(t4, v31)
		end
	end

	return t4
end

return function(p5, s2: string, t5: {[any]: any}) -- line: 92
	-- upvalues: PerformFetch (copy), ItemData (copy), GetFFlagAXRemoveAwaitUsageInThunks (copy), Dash (copy), GetFFlagAXRecentlyViewedCounters (copy), WebApi (copy), Constants (copy), sendAXStat (copy), AvatarExperienceSearch (copy), ReceivedRecentlyViewedItemsData (copy), createWidgetInfo (copy), getValidItems (copy), SearchLandingPageRecentlyViewedWidget (copy), Promise (copy)
	return PerformFetch.Single(s2, function(p6) -- line: 93
		-- upvalues: t5 (copy), ItemData (copy), GetFFlagAXRemoveAwaitUsageInThunks (copy), Dash (copy), GetFFlagAXRecentlyViewedCounters (copy), WebApi (copy), p5 (copy), Constants (copy), sendAXStat (copy), AvatarExperienceSearch (copy), ReceivedRecentlyViewedItemsData (copy), createWidgetInfo (copy), getValidItems (copy), SearchLandingPageRecentlyViewedWidget (copy), Promise (copy)
		local t6 = {}
		local t7 = {}
		local Common = p6:getState().AvatarExperience.Common

		for _, v46 in t5 do
			if ItemData(Common, v46.id, v46.itemType) then
				table.insert(t6, v46)
			else
				table.insert(t7, v46)
			end
		end

		if GetFFlagAXRemoveAwaitUsageInThunks() then
			local t8 = {}
			local t9 = {}
			local t10 = {}

			if #t7 > 0 then
				local v50 = Dash.map(t7, function(p7) -- line: 117
					return {
						id = tonumber(p7.id),
						itemType = p7.itemType
					}
				end)
				local v51 = if not GetFFlagAXRecentlyViewedCounters() then nil else os.clock()

				return WebApi.FetchItemDetails(p5, v50):andThen(function(p8) -- line: 121
					-- upvalues: t8 (ref), Constants (copy), t9 (copy), t10 (copy), GetFFlagAXRecentlyViewedCounters (copy), v51 (copy), sendAXStat (copy), AvatarExperienceSearch (copy), t7 (copy), p6 (copy), ReceivedRecentlyViewedItemsData (copy), createWidgetInfo (copy), getValidItems (copy), t5 (copy), t6 (copy), SearchLandingPageRecentlyViewedWidget (copy)
					t8 = if not p8.responseBody or not p8.responseBody.data then {} else p8.responseBody.data

					for _, v66 in t8 do
						if v66.itemType == Constants.ItemType.Asset then
							table.insert(t9, v66)
						elseif v66.itemType == Constants.ItemType.Bundle then
							table.insert(t10, v66)
						end
					end

					if GetFFlagAXRecentlyViewedCounters() and typeof(v51) == "number" then
						local v67 = (os.clock() - v51) * 1000

						sendAXStat({
							excludeTelemetry = true,
							statName = AvatarExperienceSearch.Enums.Stat.FetchRecentlyViewedItemsMs,
							metaData = {
								count = tostring(#t7)
							},
							deltaMs = v67
						})
					end

					p6:dispatch(ReceivedRecentlyViewedItemsData({
						assetData = t9,
						bundleData = t10,
						widget = {
							widgetInfo = createWidgetInfo((getValidItems({
								items = t5,
								existingItems = t6,
								itemsToFetch = t7,
								fetchedItems = t8
							}))),
							requestId = SearchLandingPageRecentlyViewedWidget.RequestId,
							context = SearchLandingPageRecentlyViewedWidget.Context
						}
					}))
				end)
			end

			p6:dispatch(ReceivedRecentlyViewedItemsData({
				assetData = t9,
				bundleData = t10,
				widget = {
					widgetInfo = createWidgetInfo((getValidItems({
						items = t5,
						existingItems = t6,
						itemsToFetch = t7,
						fetchedItems = t8
					}))),
					requestId = SearchLandingPageRecentlyViewedWidget.RequestId,
					context = SearchLandingPageRecentlyViewedWidget.Context
				}
			}))

			return Promise.resolve()
		end

		local t11 = {}
		local t12 = {}
		local t13 = {}

		if #t7 > 0 then
			local v55 = Dash.map(t7, function(p9) -- line: 180
				return {
					id = tonumber(p9.id),
					itemType = p9.itemType
				}
			end)
			local v56 = WebApi.FetchItemDetails(p5, v55)
			local v57 = if not GetFFlagAXRecentlyViewedCounters() then nil else os.clock()
			local v58, v59 = v56:await()

			if GetFFlagAXRecentlyViewedCounters() and typeof(v57) == "number" then
				local v60 = (os.clock() - v57) * 1000

				sendAXStat({
					excludeTelemetry = true,
					statName = AvatarExperienceSearch.Enums.Stat.FetchRecentlyViewedItemsMs,
					metaData = {
						count = tostring(#t7)
					},
					deltaMs = v60
				})
			end

			if not v58 then
				return Promise.reject(v59)
			end

			t11 = if not v59.responseBody or not v59.responseBody.data then {} else v59.responseBody.data

			for _, v62 in t11 do
				if v62.itemType == Constants.ItemType.Asset then
					table.insert(t12, v62)
				elseif v62.itemType == Constants.ItemType.Bundle then
					table.insert(t13, v62)
				end
			end
		end

		p6:dispatch(ReceivedRecentlyViewedItemsData({
			assetData = t12,
			bundleData = t13,
			widget = {
				widgetInfo = createWidgetInfo((getValidItems({
					items = t5,
					existingItems = t6,
					itemsToFetch = t7,
					fetchedItems = t11
				}))),
				requestId = SearchLandingPageRecentlyViewedWidget.RequestId,
				context = SearchLandingPageRecentlyViewedWidget.Context
			}
		}))

		return Promise.resolve()
	end)
end
