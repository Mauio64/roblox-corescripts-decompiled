local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/cyO")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local modules = require("@luauforge/bundled/dpZ").Modules
local addOmniRecommendations = modules.LuaApp.Actions.Games.AddOmniRecommendations
local addSearchResultsOmniFeed = modules.Personalization.OmniFeed.DataStore.AddSearchResultsOmniFeed
local feedItemModel = modules.Personalization.OmniFeed.DataStore.FeedItemModel
local addExploreOmniItems = modules.Personalization.OmniFeed.DataStore.AddExploreOmniItems
local setOmniAutocompleteSorts = modules.LuaApp.Actions.Games.SetOmniAutocompleteSorts
local setFeedItemRenderedRows = modules.Personalization.OmniFeed.DataStore.SetFeedItemRenderedRows
local clearFeedItemRenderedRows = modules.Personalization.OmniFeed.DataStore.ClearFeedItemRenderedRows

local module = require("@luauforge/bundled/dAW")
local module2 = require("@luauforge/bundled/dAX")
local module3 = require("@luauforge/bundled/dAY")

local fFlagLuaAppAddRequestIdToRfySignalApportioning = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddRequestIdToRfySignalApportioning
local fFlagLuaAppRfyRevealRows = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppRfyRevealRows

return function(options, data)
	local joined = options or {}

	if data.type == addOmniRecommendations.name then
		local recommendations = data.recommendations

		for k, recommendation in pairs(recommendations) do
			if k ~= appPage.Home then
				continue
			end

			assert(k == recommendation.pageType)
			local home = appPage.Home
			local v5 = joined[home] or {}

			local sorts = recommendation.sorts
			local recommendationsId

			if fFlagLuaAppAddRequestIdToRfySignalApportioning or fFlagLuaAppRfyRevealRows then
				recommendationsId = recommendation.recommendationsId
			end

			local count = #sorts
			local omniRecommendationsSortsCount = v5.omniRecommendationsSortsCount or 0
			local joined2 = {}

			for total, sort in ipairs(sorts) do
				if data.isAppend then
					total += omniRecommendationsSortsCount
				end

				local fromDiscoveryApi = feedItemModel.fromDiscoveryApi
				local v6

				if fFlagLuaAppAddRequestIdToRfySignalApportioning or fFlagLuaAppRfyRevealRows then
					v6 = recommendationsId
				end

				table.insert(joined2, (fromDiscoveryApi(total, sort, v6)))
			end

			if data.isAppend then
				joined2 = Cryo.List.join(v5.allItems or {}, joined2)
				count = omniRecommendationsSortsCount + count
			end

			local joined3 = Cryo.Dictionary.join(v5, {
				allItems = module3.combineOmniFeedItems(v5.localItems or {}, joined2),
				omniRecommendationsSortsCount = count
			})

			joined = Cryo.Dictionary.join(joined, { [home] = joined3 })
		end

		return joined
	elseif data.type == setOmniAutocompleteSorts.name then
		local searchLandingPage = appPage.SearchLandingPage
		local v5 = {}

		for i, v6 in ipairs(data.sortsTable) do
			table.insert(v5, (feedItemModel.fromOmniAutocompleteApi(i, v6)))
		end

		local v6 = joined[searchLandingPage] or {}
		local joined2 = Cryo.Dictionary.join(v6, {
			allItems = module3.combineOmniFeedItems(v6.localItems or {}, v5)
		})

		return (Cryo.Dictionary.join(joined, { [searchLandingPage] = joined2 }))
	elseif data.type == addExploreOmniItems.name then
		local v5 = joined[data.appPage] or {}
		local allItems = v5.allItems or {}

		local v6 = data.isAppend and #allItems or 0
		local joined2 = {}

		for k, topicInfo in data.topicInfos do
			table.insert(
				joined2,
				(feedItemModel.fromExploreTopicInfo(v6 + k, topicInfo, data.omniFeedPageSection))
			)
		end

		if data.isAppend then
			joined2 = Cryo.List.join(allItems, joined2)
		end

		return (Cryo.Dictionary.join(joined, {
			[data.appPage] = Cryo.Dictionary.join(v5, {
				allItems = module3.combineOmniFeedItems(v5.localItems or {}, joined2)
			})
		}))
	elseif data.type == module.name then
		local v5 = {}

		if data.localItems then
			for i, localItem in ipairs(data.localItems) do
				table.insert(
					v5,
					(feedItemModel.fromLocalData(
						localItem.orderIndex,
						localItem.treatmentType,
						localItem.treatmentProps,
						localItem.numberOfRows
					))
				)
			end
		end

		table.sort(v5, function(a, b): boolean
			if a.orderHint == nil or b.orderHint == nil then
				return a.orderHint ~= nil
			end

			return a.orderHint < b.orderHint
		end)

		local v6 = joined[data.appPage] or {}

		local joined2 = Cryo.Dictionary.join(v6, {
			hasLocalItems = true,
			localItems = v5,
			allItems = module3.combineOmniFeedItems(v5, v6.allItems)
		})

		return (Cryo.Dictionary.join(joined, { [data.appPage] = joined2 }))
	elseif data.type == addSearchResultsOmniFeed.name then
		local v5 = { allItems = {}, localItems = {} }

		if joined[appPage.SearchPage] then
			if joined[appPage.SearchPage][data.searchUuid] then
				for i, allItem in ipairs(joined[appPage.SearchPage][data.searchUuid].allItems) do
					if data.topicId == allItem.treatmentProps.topicId then
						return joined
					end
				end
			else
				joined[appPage.SearchPage][data.searchUuid] = v5
			end
		else
			joined = Cryo.Dictionary.join(joined, {
				[appPage.SearchPage] = { [data.searchUuid] = v5 }
			})
		end

		local v6 = { (feedItemModel.fromSearchApi(
				data.searchUuid,
				data.topicId,
				data.treatmentType,
				data.sortIndex,
				data.topicLayoutData
			)) }
		local v7 = {
			allItems = Cryo.List.join(joined[appPage.SearchPage][data.searchUuid].allItems, v6),
			localItems = {}
		}

		local v10 = Cryo.Dictionary.join(joined[appPage.SearchPage], {
			[data.searchUuid] = v7
		})

		return (Cryo.Dictionary.join(joined, { [appPage.SearchPage] = v10 }))
	elseif data.type == module2.name then
		local searchUuid = data.searchUuid
		local searchPage = appPage.SearchPage
		local v5 = {}

		for i, sort in ipairs(data.sorts) do
			local topicId = sort.topicId
			local treatmentType = sort.treatmentType
			local topicLayoutData = sort.topicLayoutData

			table.insert(
				v5,
				(feedItemModel.fromSearchApi(searchUuid, topicId, treatmentType, i, topicLayoutData))
			)
		end

		local v6 = {
			[searchPage] = Cryo.Dictionary.join(joined[searchPage] or {}, {
				[searchUuid] = { allItems = v5, localItems = {} }
			})
		}

		return (Cryo.Dictionary.join(joined, v6))
	elseif data.type == setFeedItemRenderedRows.name then
		local v5 = joined[data.appPage]

		if data.secondaryKey and v5 then
			v5 = v5[data.secondaryKey]
		end

		if not v5 then
			return joined
		end

		local v6 = module3.setFeedItemRenderedRows(
			v5.allItems,
			data.feedItemPosition,
			data.feedItem,
			data.actualNumberOfRows
		)

		if not v6 then
			return joined
		end

		local v7 = Cryo.Dictionary.join(v5, { allItems = v6 })

		if data.secondaryKey then
			v7 = Cryo.Dictionary.join(joined[data.appPage], { [data.secondaryKey] = v7 })
		end

		return (Cryo.Dictionary.join(joined, { [data.appPage] = v7 }))
	else
		if data.type ~= clearFeedItemRenderedRows.name then
			return joined
		end

		local v5 = joined[data.appPage]

		if data.secondaryKey and v5 then
			v5 = v5[data.secondaryKey]
		end

		if not v5 then
			return joined
		end

		local v6 = module3.setFeedItemRenderedRows(v5.allItems, data.feedItemPosition, data.feedItem, nil)

		if v6 then
			local v7 = Cryo.Dictionary.join(v5, { allItems = v6 })

			if data.secondaryKey then
				v7 = Cryo.Dictionary.join(joined[data.appPage], {
					[data.secondaryKey] = v7
				})
			end

			joined = Cryo.Dictionary.join(joined, { [data.appPage] = v7 })
		end

		return joined
	end
end
