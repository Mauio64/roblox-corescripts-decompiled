local gameSortGroups = require("@luauforge/bundled/dtp").GameSortGroups
local appPage = require("@luauforge/bundled/dup").AppPage
local module = require("@luauforge/bundled/dtf")
local module2 = require("@luauforge/bundled/dtg")
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local module3 = require("@luauforge/bundled/dtt")
local topicInfoModel = module3.TopicInfoModel
local addTopicInfos = module3.AddTopicInfos
local module4 = require("@luauforge/bundled/duu")
local setFetchStatus = module4.SetFetchStatus
local fetchStatusNamespace = module4.FetchStatusNamespace
local fetchStatusReducer = module4.FetchStatusReducer
local exploreContentType = require("@luauforge/bundled/dtp").ExploreContentType
local updateGameFiltersData = require("@luauforge/bundled/dvF").DataStore.updateGameFiltersData
local gameFiltersReducer = require("@luauforge/bundled/dvF").DataStore.GameFiltersReducer
local getSelectedGameFilterOptions = require("@luauforge/bundled/dvF").DataStore.getSelectedGameFilterOptions
local flaggedMutedError = require("@luauforge/bundled/duw").flaggedMutedError
local omniFeedPageSection = require("@luauforge/bundled/dtp").OmniFeedConstants.OmniFeedPageSection

local module5 = require("@luauforge/bundled/dvG")
local module6 = require("@luauforge/bundled/dvH")
local module7 = require("@luauforge/bundled/dvI")
local setPageSessionTimestamp = require("@luauforge/bundled/dtd").SetPageSessionTimestamp
local module8 = require("@luauforge/bundled/dwa")
local module9 = require("@luauforge/bundled/dwc")
local module10 = require("@luauforge/bundled/dtR")
local module11 = require("@luauforge/bundled/dtS")
local module12 = require("@luauforge/bundled/dwd")
local module13 = require("@luauforge/bundled/dwe")

local module14 = require("@luauforge/bundled/dvD")
local setNextDataExpirationTime = module14.SetNextDataExpirationTime
local expirationTimeNamespace = module14.ExpirationTimeNamespace

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dtD").FFlagEnableTopSongsSort

local fFlagLuaAppFixGamesListSortTokenExpiringTime = require("@luauforge/bundled/dtD").FFlagLuaAppFixGamesListSortTokenExpiringTime

local defineFastFlag = game:DefineFastFlag("LuaAppErrorOnBadSortGroup", false)
local defineFastInt = game:DefineFastInt("LuaAppGamesListSortTokenExpiryInSec", 600)

local function fn(p2, p3)
	return setFetchStatus(fetchStatusNamespace.GameSortToken, p2, p3)
end

local function parseExploreSortDataIntoStore(p2, object, p3, list, p4, p5)
	if not list then
		return module2.reject("No sort list found in response.")
	end

	if #list == 0 then
		return module2.resolve()
	end

	local state = object:getState()
	local v5 = state.Personalization.OrderedOmniItems
		and state.Personalization.OrderedOmniItems[appPage.Games]
	local allItems = v5 and v5.allItems or {}

	if
		p5 == omniFeedPageSection.Header
		and #allItems > 0
		and allItems[#allItems].pageSection ~= omniFeedPageSection.Header
		and p4
	then
		return module2.reject("Header sorts should not be added when there is already body content, to avoid adding header items in the middle of the feed.")
	end

	local v6 = {}
	local names = {}
	local topicLayoutDatas = {}

	for i, item in ipairs(list) do
		local v7 = topicInfoModel.fromExploreJsonData(item)

		v6[i] = v7
		names[i] = v7.name
		topicLayoutDatas[i] = v7.topicLayoutData

		if item.contentType == exploreContentType.Filters then
			updateGameFiltersData(object, p3, item.filters)
		elseif item.contentType == exploreContentType.Games then
			if item.games then
				module6(p2, object, item)
				object:dispatch(setFetchStatus(
					fetchStatusNamespace.GameSorts,
					v7.name,
					retrievalStatus.Done
				))
			end
		elseif fFlagEnableTopSongsSort and item.contentType == exploreContentType.Songs then
			if item.songs then
				module7(object, item, false, p2)
				object:dispatch(setFetchStatus(
					fetchStatusNamespace.GameSorts,
					v7.name,
					retrievalStatus.Done
				))
			end
		else
			warn(`unsupported explore content type: {item.contentType}`)
		end
	end

	object:dispatch(addTopicInfos(v6))

	if p4 then
		object:dispatch(module10(p3, names, topicLayoutDatas))
	else
		object:dispatch(module11(p3, names, "", topicLayoutDatas))
	end

	if p3 == gameSortGroups.Games then
		object:dispatch(module13(appPage.Games, v6, p4, p5))
	end

	return module2.resolve()
end

local function fetchToken(p2, object, p3, p4, options)
	local v5 = p4 and p4 ~= ""

	if p3 == gameSortGroups.GamesList then
		return module9(p2, module5:Get()):andThen(function(p5)
			local sortMetadata = p5 and p5.responseBody and p5.responseBody.sortMetadata
			return parseExploreSortDataIntoStore(p2, object, p3, sortMetadata):andThen(function()
				if fFlagLuaAppFixGamesListSortTokenExpiringTime then
					local v6 = math.floor(tick() + defineFastInt)
					object:dispatch(setNextDataExpirationTime(
						gameSortGroups.GamesList,
						v6,
						expirationTimeNamespace.GameSortGroup
					))
				end

				object:dispatch(fn(p3, retrievalStatus.Done))
			end)
		end):catch(function()
			object:dispatch(fn(p3, retrievalStatus.Failed))
		end)
	end

	if p3 == gameSortGroups.Games then
		if not v5 then
			module5:Refresh()
		end

		local v6 = object:getState().Personalization[gameFiltersReducer.key][p3]

		local selectedGameFilterOptions = getSelectedGameFilterOptions(not v6 and {} or v6.allFilters)

		return module8(
			p2,
			p4,
			module.Dictionary.join(selectedGameFilterOptions, options or {}),
			module5:Get()
		):andThen(function(p5)
			if not (p5 and p5.responseBody and p5.responseBody.sorts) then
				return module2.reject("Invalid response")
			end

			local sorts = if p5.responseBody.header then p5.responseBody.header.sorts else nil
			local sorts2 = p5.responseBody.sorts
			local nextSortsPageToken = p5.responseBody.nextSortsPageToken or ""
			object:dispatch(module12(nextSortsPageToken))
			object:dispatch(setPageSessionTimestamp(appPage.Games))

			if sorts and #sorts > 0 then
				return parseExploreSortDataIntoStore(p2, object, p3, sorts, v5, omniFeedPageSection.Header):andThen(function()
					if sorts2 and #sorts2 > 0 then
						return parseExploreSortDataIntoStore(p2, object, p3, sorts2, true)
					end

					return module2.resolve()
				end):andThen(function()
					return object:dispatch(fn(p3, retrievalStatus.Done))
				end)
			end

			return parseExploreSortDataIntoStore(p2, object, p3, sorts2, v5):andThen(function()
				return object:dispatch(fn(p3, retrievalStatus.Done))
			end)
		end):catch(function(value)
			object:dispatch(fn(p3, retrievalStatus.Failed))
			return module2.reject(value or "Update failed")
		end)
	else
		local formatted = `Unsupported GameSortGroups {p3} called.`
		object:dispatch(fn(p3, retrievalStatus.Failed))

		if defineFastFlag then
			flaggedMutedError("BadGameSortGroups", formatted)
		end

		return module2.reject(formatted)
	end
end

return function(p2, p3, p4, p5)
	return function(object)
		if object:getState().Personalization[fetchStatusReducer.key][fetchStatusNamespace.GameSortToken][p3] == retrievalStatus.Fetching then
			return module2.resolve("Data is fetching.")
		end

		object:dispatch(fn(p3, retrievalStatus.Fetching))

		return fetchToken(p2, object, p3, p4, p5)
	end
end
