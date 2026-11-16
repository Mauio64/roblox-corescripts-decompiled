local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Players = game:GetService("Players")

local FIntMyCreationsSessionListPollingIntervalSeconds = require(BuildExperience.Flags.FIntMyCreationsSessionListPollingIntervalSeconds)

local FFlagBuildExperienceMyCreationsFindSessionsByUniverse = require(BuildExperience.Flags.FFlagBuildExperienceMyCreationsFindSessionsByUniverse)
local FFlagBuildWithGroups = require(BuildExperience.Flags.FFlagBuildWithGroups)
local FFlagBuildExperienceCursorSearchPages = require(BuildExperience.Flags.FFlagBuildExperienceCursorSearchPages)

local Localization = require(parent.Localization)
local Promise = require(parent.Promise)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local CreatorGroups = require(parent.DataHydration.CreatorGroups)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseSearch = require(parent.DataHydration.UniverseSearch)

local PrivacyType = UniverseConfiguration.PrivacyType

local thumbForUniverseId = require(BuildExperience.utils.thumbForUniverseId)
local useCursorSearchPages = require(BuildExperience.utils.useCursorSearchPages)

local GetBuildExperienceRefreshStore = require(BuildExperience.Stores.GetBuildExperienceRefreshStore)
require(BuildExperience.Stores.GetMyCreationsFilterStore)
local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)
require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local useSignalState = SignalsReact.useSignalState
local pageSize = FFlagBuildExperienceMyCreationsFindSessionsByUniverse and 15 or 50
local v = {}
local v2 = { games = "All" }

local function privacyLabelForSearchItem(item, p) -- 1 equivalent call inferred from this helper
	if UniverseConfiguration.getPrivacyTypeForAudiences(item.audiences) == PrivacyType.Public then
		return p.live
	end

	return nil
end

local function universeSearchParamsForPage(creatorTargetId: number, query: string, pageIndex: number) -- 1 equivalent call inferred from this helper
	local v3 = {
		creatorType = "User",
		creatorTargetId = creatorTargetId,
		surface = "CreatorHubCreations",
		isArchived = false,
		isTeamCreateEnabled = true,
		sortParam = "LastUpdated",
		sortOrder = "Desc",
		pageIndex = pageIndex,
		pageSize = pageSize,
		search = nil,
		needsAssetOptions = true
	}

	if query == "" then
		query = nil
	end

	v3.search = query
	return v3
end

local function multiCreatorSearchParamsForPage(creators, search: string, cursor: string?) -- 2 equivalent calls inferred from this helper
	local v3 = {
		creators = creators,
		surface = "Build",
		isArchived = false,
		isTeamCreateEnabled = true,
		sortParam = "LastUpdated",
		sortOrder = "Desc",
		pageSize = pageSize,
		cursor = cursor,
		search = nil,
		needsAssetOptions = true
	}

	if search == "" then
		search = nil
	end

	v3.search = search
	return v3
end

local function keyForCreators(list)
	if list == nil then
		return nil
	end

	local v3 = table.create(#list)

	for k, item in list do
		v3[k] = `{item.creatorType}:{item.creatorTargetId}`
	end

	return table.concat(v3, ",")
end

local function isCursorRequested(cursors, nextCursor: string): boolean -- 1 equivalent call inferred from this helper
	if cursors == nil then
		return false
	end

	for _, item in cursors do
		if item == nextCursor then
			return true
		end
	end

	return false
end

local function descriptionForSessionStatus(p, p2) -- 1 equivalent call inferred from this helper
	local roblox = p._meta and p._meta._roblox
	local sessionStatus

	if roblox then
		sessionStatus = roblox.sessionStatus
	end

	if sessionStatus == nil then
		return nil
	end

	return p2[sessionStatus]
end

local function requestHandleToPromise(more) -- 2 equivalent calls inferred from this helper
	return Promise.new(function(callback, callback2)
		task.spawn(function()
			while more.state(false).status == "pending" do
				task.wait()
			end

			local state = more.state(false)

			if state.status == "succeeded" then
				callback(state.result)
			else
				callback2(state.error)
			end
		end)
	end)
end

local function ignorePromiseRejection() end

local function getSessionUniverseId(item) -- 1 equivalent call inferred from this helper
	local roblox = item._meta and item._meta._roblox

	if roblox == nil then
		return nil
	end

	local universeId = roblox.universeId

	if typeof(universeId) == "number" and universeId ~= 0 then
		return universeId
	end

	return nil
end

local function buildLatestSessionByUniverseId(items)
	local latestSessionByUniverseId = {}

	for _, item in items do
		local sessionUniverseId = getSessionUniverseId(item) -- inferred equivalent call

		if sessionUniverseId ~= nil and latestSessionByUniverseId[sessionUniverseId] == nil then
			latestSessionByUniverseId[sessionUniverseId] = item
		end
	end

	return latestSessionByUniverseId
end

local function useUniverseSessions(p, current)
	local state, setState = React.useState({})

	local ref = React.useRef(state)
	ref.current = state
	local ref2 = React.useRef({})

	local ref3 = React.useRef(current)
	ref3.current = current
	local ref4 = React.useRef(true)

	React.useEffect(function()
		ref4.current = true
		return function()
			ref4.current = false
		end
	end, {})

	local v3 = React.useCallback(function(flag: boolean)
		local v3 = {}

		for _, v4 in ref3.current do
			if v4.isArchived then
				continue
			end

			local id = v4.id
			local v5 = ref2.current[id]

			if v5 == nil then
				if flag or ref.current[id] == nil then
					local sessionFindByUniverse = p.sessionFindByUniverse({
						universeId = id,
						sort = "desc",
						application = "build",
						filterByPinForBuild = true
					})

					local v6 = { handle = sessionFindByUniverse, promise = nil }

					ref2.current[id] = v6
					local promise = requestHandleToPromise(sessionFindByUniverse):andThen(function() -- inferred equivalent call
						local v7 = ref2.current[id]

						if v7 == nil or v7.handle ~= sessionFindByUniverse then
							return
						end

						ref2.current[id] = nil

						if ref4.current then
							local clone = table.clone(ref.current)
							clone[id] = sessionFindByUniverse
							ref.current = clone
							setState(clone)
						end
					end, function(p2)
						local v7 = ref2.current[id]

						if v7 ~= nil and v7.handle == sessionFindByUniverse then
							ref2.current[id] = nil
						end

						return Promise.reject(p2)
					end)

					v6.promise = promise
					table.insert(v3, promise)
				end
			else
				table.insert(v3, v5.promise)
			end
		end

		return Promise.all(v3)
	end, { p })

	React.useEffect(function()
		v3(false):catch(ignorePromiseRejection)
	end, { current, v3 })

	return {
		entries = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				local result = {}

				for _, v4 in current do
					local v5 = state[v4.id]
					local v6

					if v5 ~= nil then
						v6 = v5.state(p2)
					end

					if not (v6 ~= nil and v6.status == "succeeded" and v6.result ~= nil) then
						continue
					end

					local sessions = v6.result.sessions
					local v7

					if typeof(sessions) == "table" then
						v7 = sessions[1]
					end

					if v7 ~= nil then
						table.insert(result, v7)
					end
				end

				return result
			end)
		end, { current, state }))),
		refresh = React.useCallback(function()
			return v3(true)
		end, { v3 })
	}
end

local function buildUniverseItems(items, p, p2, p3, callback)
	local latestSessionByUniverseId = buildLatestSessionByUniverseId(p)
	local universeItems = {}

	for _, item in items do
		if item.isArchived then
			continue
		end

		local id = item.id
		local v3 = latestSessionByUniverseId[id]
		local experienceName = item.name

		if typeof(experienceName) ~= "string" or experienceName == "" then
			experienceName = callback(id)
		end

		local sessionId

		if v3 then
			sessionId = v3.sessionId
		end

		local v4 = {
			sessionId = sessionId,
			universeId = id,
			placeId = item.rootPlaceId,
			experienceName = experienceName,
			creatorName = 0,
			description = 0,
			visibilityLabel = 0,
			gameIcon = 0,
			isGroupGame = 0
		}
		local creatorName

		if typeof(item.creatorName) == "string" and item.creatorName ~= "" then
			creatorName = item.creatorName
		end

		v4.creatorName = creatorName
		local description

		if v3 then
			description = descriptionForSessionStatus(v3, p2) -- inferred equivalent call
		end

		v4.description = description
		v4.visibilityLabel = privacyLabelForSearchItem(item, p3) -- inferred equivalent call
		v4.gameIcon = thumbForUniverseId(id)
		local isGroupGame

		if FFlagBuildWithGroups then
			isGroupGame = item.creatorType == "Group"
		end

		v4.isGroupGame = isGroupGame
		table.insert(universeItems, v4)
	end

	return universeItems
end

local function useUniverseSearchList(p, userId: number, current: string, isFocused: boolean, p2, p3, p4, callback, creatorAgentChatStore, p5)
	local ref = React.useRef({})
	local ref2 = React.useRef(current)
	ref2.current = current
	local creators

	if FFlagBuildWithGroups then
		creators = p5.creators
	end

	local v3

	if FFlagBuildWithGroups then
		v3 = keyForCreators(creators)
	else
		v3 = nil
	end

	local ref3

	if FFlagBuildWithGroups then
		ref3 = React.useRef(creators)
	else
		ref3 = nil
	end

	if FFlagBuildWithGroups then
		ref3.current = creators
	end

	local state, setState = React.useState({
		query = current,
		pageIndexes = { 0 },
		creators = creators,
		cursors = FFlagBuildWithGroups and {} or nil
	})

	local v4 = React.useMemo(function()
		local result = {}

		if FFlagBuildWithGroups then
			local creators2 = state.creators

			if creators2 ~= nil then
				local cursors = state.cursors or {}

				for _, pageIndex in state.pageIndexes do
					local v4 = multiCreatorSearchParamsForPage(creators2, state.query, cursors[pageIndex]) -- inferred equivalent call
					table.insert(result, (p.getSearch(v4)))
				end

				return result
			end
		else
			for _, pageIndex in state.pageIndexes do
				local getSearch = p.getSearch
				table.insert(result, (getSearch(universeSearchParamsForPage(userId, state.query, pageIndex)))) -- inferred equivalent call
			end
		end

		return result
	end, { state, p, userId })

	local v5 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p6)
			local total = 0
			local idSet = {}
			local items = {}
			local totalResults = nil
			local v5 = "NotReady"
			local v6 = nil
			local count = 0
			local status = "NotReady"

			for k, v7 in v4 do
				local data = v7.data(p6)
				v5 = v7.status(p6)

				if k == 1 then
					status = v5
				end

				if data == nil then
					continue
				end

				totalResults = data.totalResults or data.totalHits or totalResults
				local data2 = data.data or v
				total += #data2
				v6 = data
				count = 0

				for _, v8 in data2 do
					if idSet[v8.id] then
						continue
					end

					idSet[v8.id] = true
					count += 1
					table.insert(items, v8)
				end
			end

			local nextPageIndex = nil
			local nextCursor2 = nil
			local failedPageIndex = nil

			if FFlagBuildWithGroups then
				if v5 == "Ready" and v6 ~= nil then
					local nextCursor = v6.nextCursor

					if
						nextCursor ~= nil
						and nextCursor ~= ""
						and count > 0
						and not isCursorRequested(state.cursors, nextCursor) -- inferred equivalent call
					then
						nextPageIndex = #state.pageIndexes
						nextCursor2 = nextCursor
					end
				elseif v5 == "Failed" and #v4 > 1 then
					failedPageIndex = state.pageIndexes[#state.pageIndexes]
				end
			elseif v5 == "Ready" and v6 ~= nil then
				local nextResultIndex = v6.nextResultIndex

				if nextResultIndex == nil then
					if totalResults ~= nil and total < totalResults then
						nextPageIndex = state.pageIndexes[#state.pageIndexes] + 1
					end
				else
					nextPageIndex = nextResultIndex / pageSize
				end

				if nextPageIndex ~= nil and (nextPageIndex < 0 or table.find(state.pageIndexes, nextPageIndex)) then
					nextPageIndex = nil
				end
			elseif v5 == "Failed" and #v4 > 1 then
				failedPageIndex = state.pageIndexes[#state.pageIndexes]
			end

			return {
				items = items,
				status = status,
				nextPageIndex = nextPageIndex,
				nextCursor = nextCursor2,
				failedPageIndex = failedPageIndex,
				isLoadingMore = #v4 > 1 and v5 == "NotReady"
			}
		end)
	end, { state.pageIndexes, state.cursors, v4 })))
	local v6

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		v6 = useUniverseSessions(creatorAgentChatStore, v5.items)
	else
		v6 = nil
	end

	local v7 = React.useCallback(function(search: string, pageIndex: number, flag: boolean?, cursor: string?, creators2)
		local v7

		if FFlagBuildWithGroups then
			v7 = ("%*\0%*\0%*\0%*"):format(pageIndex, search, cursor or "", keyForCreators(creators2) or "")
		else
			v7 = ("%*\0%*"):format(pageIndex, search)
		end

		if flag then
			ref.current[v7] = nil
		end

		local v8 = ref.current[v7]

		if v8 ~= nil then
			return v8
		end

		local v9

		if FFlagBuildWithGroups then
			v9 = {
				creators = creators2,
				surface = "Build",
				isArchived = false,
				isTeamCreateEnabled = true,
				sortParam = "LastUpdated",
				sortOrder = "Desc",
				pageSize = pageSize,
				cursor = cursor,
				search = 0,
				needsAssetOptions = true
			}
		else
			v9 = {
				creatorType = "User",
				creatorTargetId = userId,
				surface = "CreatorHubCreations",
				isArchived = false,
				isTeamCreateEnabled = true,
				sortParam = "LastUpdated",
				sortOrder = "Desc",
				pageIndex = pageIndex,
				pageSize = pageSize,
				search = 0,
				needsAssetOptions = true
			}
		end

		if search == "" then
			search = nil
		end

		v9.search = search

		local v10 = nil
		v10 = p.refreshSearch(v9):finally(function()
			if ref.current[v7] == v10 then
				ref.current[v7] = nil
			end
		end)
		ref.current[v7] = v10
		return v10
	end, { p, userId })

	local refresh = React.useCallback(function(p6: string?)
		local query = p6 or ref2.current

		if not FFlagBuildWithGroups then
			setState({
				query = query,
				pageIndexes = { 0 }
			})

			return v7(query, 0)
		end

		local current2 = ref3.current
		setState({
			query = query,
			pageIndexes = { 0 },
			creators = current2,
			cursors = {}
		})

		if current2 == nil then
			return Promise.resolve()
		end

		return v7(query, 0, nil, nil, current2)
	end, { v7 })

	React.useEffect(function()
		if not isFocused then
			return
		end

		local v8 = FFlagBuildWithGroups and keyForCreators(state.creators) ~= v3

		if state.query ~= current or v8 then
			refresh(current):catch(ignorePromiseRejection)
		end
	end, { v3, current, isFocused, refresh, state.creators, state.query })

	local loadMore = React.useCallback(function()
		local failedPageIndex = v5.failedPageIndex or v5.nextPageIndex
		local query = state.query

		if v5.isLoadingMore or failedPageIndex == nil or ref2.current ~= query then
			return
		end

		if FFlagBuildWithGroups then
			local creators2 = state.creators

			if creators2 == nil or keyForCreators(creators2) ~= keyForCreators(ref3.current) then
				return
			end

			local v8 = v5.failedPageIndex ~= nil
			local v9

			if v8 then
				v9 = (state.cursors or {})[failedPageIndex]
			else
				v9 = v5.nextCursor
			end

			if not v8 then
				setState(function(data)
					if
						data.query ~= query
						or data.creators ~= creators2
						or table.find(data.pageIndexes, failedPageIndex)
					then
						return data
					end

					local clone = table.clone(data.pageIndexes)
					table.insert(clone, failedPageIndex)
					local clone2 = table.clone(data.cursors or {})
					clone2[failedPageIndex] = v9
					return {
						query = data.query,
						pageIndexes = clone,
						creators = data.creators,
						cursors = clone2
					}
				end)
			end

			v7(query, failedPageIndex, v8, v9, creators2):catch(ignorePromiseRejection)
		else
			if v5.failedPageIndex == nil then
				setState(function(p6)
					if p6.query ~= query or table.find(p6.pageIndexes, failedPageIndex) then
						return p6
					end

					local clone = table.clone(p6.pageIndexes)
					table.insert(clone, failedPageIndex)
					return { query = p6.query, pageIndexes = clone }
				end)
			end

			v7(query, failedPageIndex, v5.failedPageIndex ~= nil):catch(ignorePromiseRejection)
		end
	end, { v5, v7, state.creators, state.cursors, state.query })

	local useMemo = React.useMemo
	local function fn()
		local items = v5.items
		local v8

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			v8 = v6.entries
		else
			v8 = p2
		end

		return buildUniverseItems(items, v8, p3, p4, callback)
	end

	local items = v5.items
	local v8

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		v8 = v6.entries
	else
		v8 = p2
	end

	local v9 = {
		items = useMemo(fn, { p3, items, v8, p4, callback }),
		status = 0,
		sourceItemCount = 0,
		failedLoadMore = 0,
		isLoadingMore = 0,
		query = 0,
		refresh = 0,
		refreshSessions = 0,
		loadMore = 0
	}
	local status

	if FFlagBuildWithGroups and p5.creators == nil then
		status = p5.status
	else
		status = v5.status
	end

	v9.status = status

	v9.sourceItemCount = #v5.items
	v9.failedLoadMore = v5.failedPageIndex ~= nil
	v9.isLoadingMore = v5.isLoadingMore
	v9.query = state.query
	v9.refresh = refresh
	local refreshSessions

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		refreshSessions = v6.refresh
	end

	v9.refreshSessions = refreshSessions

	v9.loadMore = loadMore
	return v9
end

local function useUniverseListItems(items, p, p2, p3, callback, p4)
	local v3

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		v3 = useUniverseSessions(p4, items)
	end

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		p = v3.entries
	end

	local v4 = {
		items = React.useMemo(function()
			return buildUniverseItems(items, p, p2, p3, callback)
		end, { p2, p, items, p3, callback }),
		refreshSessions = 0
	}
	local refreshSessions

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		refreshSessions = v3.refresh
	end

	v4.refreshSessions = refreshSessions
	return v4
end

local function useCreatorSearchList(searchStore, current: string, isFocused: boolean, p, p2, p3, callback, creatorAgentChatStore, p4)
	local creators = p4.creators
	local v3 = keyForCreators(creators)

	local ref = React.useRef(current)

	if isFocused then
		ref.current = current
	end

	local current2 = ref.current

	local v4 = useCursorSearchPages({
		searchStore = searchStore,
		sources = React.useMemo(function()
			if creators == nil then
				return nil
			end

			return {
				{
					key = ("%*\0%*"):format(current2, v3),
					params = multiCreatorSearchParamsForPage(creators, current2) -- inferred equivalent call
				}
			}
		end, { current2, creators, v3 })
	})

	local v5 = useUniverseListItems(v4.items, p, p2, p3, callback, creatorAgentChatStore)

	local v6 = {
		items = v5.items,
		status = 0,
		sourceItemCount = 0,
		failedLoadMore = 0,
		isLoadingMore = 0,
		query = 0,
		refresh = 0,
		refreshSessions = 0,
		loadMore = 0
	}
	local status = if creators == nil then p4.status else v4.status
	v6.status = status
	v6.sourceItemCount = #v4.items
	v6.failedLoadMore = v4.failedLoadMore
	v6.isLoadingMore = v4.isLoadingMore
	v6.query = current2
	v6.refresh = v4.refresh
	v6.refreshSessions = v5.refreshSessions
	v6.loadMore = v4.loadMore
	return v6
end

local function useBuildCreators(creatorGroupsStore, userId: number, filter)
	local v3 = React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("Build"))
	end, { creatorGroupsStore })
	local v4 = useSignalState(v3.data)
	local v5 = useSignalState(v3.status)
	local games = filter.games
	local groupId = filter.groupId

	return React.useMemo(function()
		local v6 = { creatorType = "User", creatorTargetId = userId }

		if games == "MyGames" then
			return {
				creators = { v6 },
				status = "Ready"
			}
		elseif games == "SharedGames" then
			return {
				creators = {
					{ creatorType = "Team", creatorTargetId = userId }
				},
				status = "Ready"
			}
		end

		if v4 == nil then
			return {
				creators = nil,
				status = v5 == "Failed" and "Failed" or "NotReady"
			}
		end

		if games == "GroupGames" and groupId ~= nil then
			for _, group in v4.groups do
				if group.id == groupId then
					return {
						creators = {
							{ creatorType = "Group", creatorTargetId = group.id }
						},
						status = "Ready"
					}
				end
			end
		end

		if games == "GroupGames" and #v4.groups == 0 then
			return { creators = nil, status = "Ready" }
		end

		local creators = games == "GroupGames" and {} or { v6 }

		for _, group in v4.groups do
			table.insert(creators, { creatorType = "Group", creatorTargetId = group.id })
		end

		return { creators = creators, status = "Ready" }
	end, { games, groupId, v4, v5, userId })
end

local function useMyCreationsResults(data)
	local v3 = useLocalization({
		building = LocalizationStrings.MY_CREATIONS_BUILDING,
		inputNeeded = LocalizationStrings.MY_CREATIONS_INPUT_NEEDED,
		loadError = LocalizationStrings.MY_CREATIONS_LOAD_ERROR,
		live = LocalizationStrings.MY_CREATIONS_LIVE,
		private = LocalizationStrings.MY_CREATIONS_PRIVATE,
		public = LocalizationStrings.MY_CREATIONS_PUBLIC,
		publiclyUnavailable = LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE,
		ready = LocalizationStrings.MY_CREATIONS_READY,
		restricted = LocalizationStrings.MY_CREATIONS_RESTRICTED
	})

	local v4 = React.useContext(LocalizationRoactContext)
	local v5 = { v4, v3[Localization.RobloxLocaleIdKey] }
	local v6 = React.useCallback(function(p: number)
		return v4:Format(LocalizationStrings.MY_CREATIONS_UNIVERSE_NAME, { UNIVERSE_ID = p })
	end, v5)

	local loadError = v3.loadError
	local v7 = React.useMemo(function()
		return { waiting_on_client = v3.inputNeeded, idle = v3.ready, working = v3.building }
	end, { v3.inputNeeded, v3.ready, v3.building })

	local v8 = React.useMemo(function()
		return {
			live = v3.live,
			private = v3.private,
			public = v3.public,
			publiclyUnavailable = v3.publiclyUnavailable,
			restricted = v3.restricted
		}
	end, { v3.live, v3.private, v3.public, v3.publiclyUnavailable, v3.restricted })

	local creatorAgentChatStore = data.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v9 = data.searchStore

	if v9 == nil then
		v9 = UniverseSearch.getUniverseSearchStore()
	end

	local searchQueryStore = data.searchQueryStore or GetSearchQueryStore()
	local buildExperienceRefreshStore = GetBuildExperienceRefreshStore()
	local appLifecycleObserverService = data.appLifecycleObserverService or AppLifecycleObserverService
	local isFocused = data.isFocused ~= false
	local state, setState = React.useState(false)
	local v10 = searchQueryStore.useDebouncedQuery()
	local current = useSignalState(buildExperienceRefreshStore.getRefreshTick)
	local ref

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		ref = React.useRef(current)
	else
		ref = nil
	end

	local ref2

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		ref2 = React.useRef(isFocused)
	else
		ref2 = nil
	end

	local sessionListStore = creatorAgentChatStore.getSessionListStore()
	local v11 = useSignalState(sessionListStore.getSessions)
	local v12 = useSignalState(sessionListStore.getNextPageToken)
	local v13 = useSignalState(sessionListStore.getStatus)
	local v14 = useSignalState(sessionListStore.getLoadMoreStatus)
	local sessionListStatus = v13 == "pending" and "NotReady" or v13 == "succeeded" and "Ready" or "Failed"

	local userId = data.userId or not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
	local creatorGroupsStore

	if FFlagBuildWithGroups then
		creatorGroupsStore = data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore()
	else
		creatorGroupsStore = nil
	end

	local v15

	if FFlagBuildWithGroups then
		v15 = useBuildCreators(creatorGroupsStore, userId, data.filter or v2)
	end

	local v16

	if FFlagBuildExperienceCursorSearchPages then
		if not FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			creatorAgentChatStore = nil
		end

		v16 = useCreatorSearchList(v9, v10, isFocused, v11, v7, v8, v6, creatorAgentChatStore, v15)
	else
		if not FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			creatorAgentChatStore = nil
		end

		v16 = useUniverseSearchList(v9, userId, v10, isFocused, v11, v7, v8, v6, creatorAgentChatStore, v15)
	end

	local refresh = v16.refresh
	local refreshSessions

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		refreshSessions = v16.refreshSessions
	end

	local ref3

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		ref3 = React.useRef(refreshSessions)
	else
		ref3 = nil
	end

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		ref3.current = refreshSessions
	end

	local refresh2 = React.useCallback(function()
		local handleToPromise = requestHandleToPromise(sessionListStore.refresh()) -- inferred equivalent call

		if FFlagBuildWithGroups then
			creatorGroupsStore.fetchGroups("Build")
		end

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			return Promise.all({ refresh(), handleToPromise, ref3.current():catch(ignorePromiseRejection) })
		end

		return Promise.all({ refresh(), handleToPromise })
	end, { creatorGroupsStore, refresh, sessionListStore })

	React.useEffect(function()
		local onUnhideConnection = appLifecycleObserverService.OnUnhide:Connect(function()
			if isFocused then
				refresh():catch(ignorePromiseRejection)

				if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
					ref3.current():catch(ignorePromiseRejection)
				end

				sessionListStore.refresh()
			end
		end)

		return function()
			onUnhideConnection:Disconnect()
		end
	end, { appLifecycleObserverService, isFocused, refresh, sessionListStore })

	React.useEffect(function()
		local v17

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			v17 = ref.current ~= current or isFocused and not ref2.current
			ref.current = current
			ref2.current = isFocused
		else
			v17 = false
		end

		if not isFocused then
			setState(false)
			return
		end

		setState(false)
		refresh():catch(ignorePromiseRejection)

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse and v17 then
			ref3.current():catch(ignorePromiseRejection)
		end

		local v18 = sessionListStore.refresh()
		return Signals.createEffect(function(p)
			if v18.state(p).status == "succeeded" then
				setState(true)
			end
		end)
	end, { isFocused, current, refresh, sessionListStore })

	local v17 = math.max(0, data.pollingIntervalSeconds or FIntMyCreationsSessionListPollingIntervalSeconds)
	React.useEffect(function()
		if not isFocused or v17 == 0 then
			return
		end

		local flag = false
		local function scheduleNextPoll()
			task.delay(v17, function()
				if flag then
					return
				end

				if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
					ref3.current():catch(ignorePromiseRejection)
				end

				sessionListStore.refresh()
				scheduleNextPoll()
			end)
		end

		task.delay(v17, function()
			if flag then
				return
			end

			if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
				ref3.current():catch(ignorePromiseRejection)
			end

			sessionListStore.refresh()
			scheduleNextPoll()
		end)

		return function()
			flag = true
		end
	end, { isFocused, v17, sessionListStore })

	local items = v16.items
	local items2 = v16.items

	local status = v16.status
	local sourceItemCount = v16.sourceItemCount
	local hasDisplayedResult = status == "Ready" or sourceItemCount > 0
	local v18 = v14 == "pending"
	local failedLoadMore = v16.failedLoadMore
	local isLoadingMore = v16.isLoadingMore

	local v19 = React.useCallback(function()
		local more = sessionListStore.loadMore()

		if more == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(more)
	end, { v18, v12, sessionListStatus, sessionListStore })

	local loadMore = v16.loadMore

	local loadMoreIfNeeded = React.useCallback(function(data2)
		local y = data2.AbsoluteCanvasSize.Y

		if data2.CanvasPosition.Y <= 0 or y <= 0 or data2.AbsoluteWindowSize.Y <= 0 then
			return
		end

		if math.max(0, y - data2.AbsoluteWindowSize.Y - 250) < data2.CanvasPosition.Y then
			loadMore()

			if v12 ~= nil and not v18 and sessionListStatus == "Ready" then
				v19()
			end
		end
	end, { v18, v19, loadMore, v12, sessionListStatus })

	local query = v16.query

	return {
		displayedItems = items,
		items = items2,
		listStatus = status,
		hasDisplayedResult = hasDisplayedResult,
		hasPendingSummary = false,
		isSettledNoResults = query == v10 and hasDisplayedResult and #items2 == 0,
		query = query,
		sourceItemCount = sourceItemCount,
		sessionCount = #v11,
		sessionListStatus = sessionListStatus,
		hasCompletedFocusedRefresh = state,
		loadError = loadError,
		refresh = refresh2,
		loadMoreIfNeeded = loadMoreIfNeeded,
		failedLoadMore = failedLoadMore,
		retryLoadMore = loadMore,
		isLoadingMore = isLoadingMore
	}
end

return useMyCreationsResults
