local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.DiscoveryTypes)

local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local AddOmniRecommendations = Modules.LuaApp.Actions.Games.AddOmniRecommendations
local AddSearchResultsOmniFeed = Modules.Personalization.OmniFeed.DataStore.AddSearchResultsOmniFeed
local FeedItemModel = Modules.Personalization.OmniFeed.DataStore.FeedItemModel
local AddExploreOmniItems = Modules.Personalization.OmniFeed.DataStore.AddExploreOmniItems
local SetOmniAutocompleteSorts = Modules.LuaApp.Actions.Games.SetOmniAutocompleteSorts
local SetFeedItemRenderedRows = Modules.Personalization.OmniFeed.DataStore.SetFeedItemRenderedRows
local ClearFeedItemRenderedRows = Modules.Personalization.OmniFeed.DataStore.ClearFeedItemRenderedRows
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local AddLocalOmniItems = require(Modules2.Personalization.OmniFeed.DataStore.AddLocalOmniItems)
local AddSearchResultsOmniFeedSorts = require(Modules2.Personalization.OmniFeed.DataStore.AddSearchResultsOmniFeedSorts)
local OrderedOmniItemsUtility = require(Modules2.Personalization.OmniFeed.DataStore.OrderedOmniItemsUtility)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagLuaAppAddRequestIdToRfySignalApportioning = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddRequestIdToRfySignalApportioning
local FFlagLuaAppRfyRevealRows = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagLuaAppChartsStickyHeader = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsStickyHeader

return function(p1, p2) -- line: 32
	-- upvalues: AddOmniRecommendations (copy), AppPage (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), FFlagLuaAppRfyRevealRows (copy), FeedItemModel (copy), Cryo (copy), OrderedOmniItemsUtility (copy), FFlagSearchOmniAutocompletePage (copy), SetOmniAutocompleteSorts (copy), AddExploreOmniItems (copy), FFlagLuaAppChartsStickyHeader (copy), AddLocalOmniItems (copy), AddSearchResultsOmniFeed (copy), AddSearchResultsOmniFeedSorts (copy), SetFeedItemRenderedRows (copy), ClearFeedItemRenderedRows (copy)
	local v22 = p1 or {}

	if p2.type == AddOmniRecommendations.name then
		local recommendations = p2.recommendations

		for k, v in pairs(recommendations) do
			if k == AppPage.Home then
				assert(k == v.pageType)

				local Home = AppPage.Home
				local v27 = v22[Home] or {}
				local sorts = v.sorts
				local v29 = if not FFlagLuaAppAddRequestIdToRfySignalApportioning and not FFlagLuaAppRfyRevealRows then nil else v.recommendationsId
				local t1 = {}
				local v31 = #sorts
				local v32 = v27.omniRecommendationsSortsCount or 0

				for i, v2 in ipairs(sorts) do
					local v35 = i

					if p2.isAppend then
						v35 += v32
					end

					table.insert(t1, (FeedItemModel.fromDiscoveryApi(v35, v2, if not FFlagLuaAppAddRequestIdToRfySignalApportioning and not FFlagLuaAppRfyRevealRows then nil else v29)))
				end

				if p2.isAppend then
					t1 = Cryo.List.join(v27.allItems or {}, t1)
					v31 = v32 + v31
				end

				local v36 = Cryo.Dictionary.join(v27, {
					allItems = OrderedOmniItemsUtility.combineOmniFeedItems(v27.localItems or {}, t1),
					omniRecommendationsSortsCount = v31
				})

				v22 = Cryo.Dictionary.join(v22, {
					[Home] = v36
				})
			end
		end

		return v22
	end

	if FFlagSearchOmniAutocompletePage and p2.type == SetOmniAutocompleteSorts.name then
		local SearchLandingPage = AppPage.SearchLandingPage
		local t2 = {}

		for i, v in ipairs(p2.sortsTable) do
			table.insert(t2, (FeedItemModel.fromOmniAutocompleteApi(i, v)))
		end

		local v41 = v22[SearchLandingPage] or {}
		local v42 = Cryo.Dictionary.join(v41, {
			allItems = OrderedOmniItemsUtility.combineOmniFeedItems(v41.localItems or {}, t2)
		})

		return (Cryo.Dictionary.join(v22, {
			[SearchLandingPage] = v42
		}))
	end

	if p2.type == AddExploreOmniItems.name then
		local v43 = v22[p2.appPage] or {}
		local v44 = v43.allItems or {}
		local t3 = {}
		local v46 = not p2.isAppend and 0 or #v44

		for v47, v48 in p2.topicInfos do
			table.insert(t3, (FeedItemModel.fromExploreTopicInfo(v46 + v47, v48, if not FFlagLuaAppChartsStickyHeader then nil else p2.omniFeedPageSection)))
		end

		if p2.isAppend then
			t3 = Cryo.List.join(v44, t3)
		end

		return (Cryo.Dictionary.join(v22, {
			[p2.appPage] = Cryo.Dictionary.join(v43, {
				allItems = OrderedOmniItemsUtility.combineOmniFeedItems(v43.localItems or {}, t3)
			})
		}))
	end

	if p2.type == AddLocalOmniItems.name then
		local t4 = {}

		if p2.localItems then
			for _, v in ipairs(p2.localItems) do
				table.insert(t4, (FeedItemModel.fromLocalData(v.orderIndex, v.treatmentType, v.treatmentProps, v.numberOfRows)))
			end
		end

		table.sort(t4, function(p3, p4) -- line: 147
			if p3.orderHint ~= nil and p4.orderHint ~= nil then
				return p3.orderHint < p4.orderHint
			end

			if p3.orderHint ~= nil then
				return true
			end

			return false
		end)

		local v52 = v22[p2.appPage] or {}
		local v53 = Cryo.Dictionary.join(v52, {
			hasLocalItems = true,
			localItems = t4,
			allItems = OrderedOmniItemsUtility.combineOmniFeedItems(t4, v52.allItems)
		})

		return (Cryo.Dictionary.join(v22, {
			[p2.appPage] = v53
		}))
	end

	if p2.type == AddSearchResultsOmniFeed.name then
		local t5 = {
			allItems = {},
			localItems = {}
		}

		if v22[AppPage.SearchPage] then
			if v22[AppPage.SearchPage][p2.searchUuid] then
				for _, v in ipairs(v22[AppPage.SearchPage][p2.searchUuid].allItems) do
					if p2.topicId == v.treatmentProps.topicId then
						return v22
					end
				end
			else
				v22[AppPage.SearchPage][p2.searchUuid] = t5
			end
		else
			v22 = Cryo.Dictionary.join(v22, {
				[AppPage.SearchPage] = {
					[p2.searchUuid] = t5
				}
			})
		end

		local v57 = FeedItemModel.fromSearchApi(p2.searchUuid, p2.topicId, p2.treatmentType, p2.sortIndex, p2.topicLayoutData)
		local t6 = {
			allItems = Cryo.List.join(v22[AppPage.SearchPage][p2.searchUuid].allItems, { v57 }),
			localItems = {}
		}
		local v59 = Cryo.Dictionary.join(v22[AppPage.SearchPage], {
			[p2.searchUuid] = t6
		})

		return (Cryo.Dictionary.join(v22, {
			[AppPage.SearchPage] = v59
		}))
	end

	if p2.type == AddSearchResultsOmniFeedSorts.name then
		local searchUuid = p2.searchUuid
		local SearchPage = AppPage.SearchPage
		local t7 = {}

		for i, v in ipairs(p2.sorts) do
			local topicId = v.topicId
			local treatmentType = v.treatmentType
			local topicLayoutData = v.topicLayoutData

			table.insert(t7, (FeedItemModel.fromSearchApi(searchUuid, topicId, treatmentType, i, topicLayoutData)))
		end

		local t8 = {
			[SearchPage] = Cryo.Dictionary.join(v22[SearchPage] or {}, {
				[searchUuid] = {
					allItems = t7,
					localItems = {}
				}
			})
		}

		return (Cryo.Dictionary.join(v22, t8))
	end

	if p2.type == SetFeedItemRenderedRows.name then
		local v69 = v22[p2.appPage]

		if p2.secondaryKey and v69 then
			v69 = v69[p2.secondaryKey]
		end

		if v69 then
			local v70 = OrderedOmniItemsUtility.setFeedItemRenderedRows(v69.allItems, p2.feedItemPosition, p2.feedItem, p2.actualNumberOfRows)

			if v70 then
				local v71 = Cryo.Dictionary.join(v69, {
					allItems = v70
				})

				if p2.secondaryKey then
					v71 = Cryo.Dictionary.join(v22[p2.appPage], {
						[p2.secondaryKey] = v71
					})
				end

				return (Cryo.Dictionary.join(v22, {
					[p2.appPage] = v71
				}))
			end
		end
	elseif p2.type == ClearFeedItemRenderedRows.name then
		local v72 = v22[p2.appPage]

		if p2.secondaryKey and v72 then
			v72 = v72[p2.secondaryKey]
		end

		if v72 then
			local v73 = OrderedOmniItemsUtility.setFeedItemRenderedRows(v72.allItems, p2.feedItemPosition, p2.feedItem, nil)

			if v73 then
				local v74 = Cryo.Dictionary.join(v72, {
					allItems = v73
				})

				if p2.secondaryKey then
					v74 = Cryo.Dictionary.join(v22[p2.appPage], {
						[p2.secondaryKey] = v74
					})
				end

				v22 = Cryo.Dictionary.join(v22, {
					[p2.appPage] = v74
				})
			end
		end
	end

	return v22
end
