local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Players = game:GetService("Players")

local FIntMyCreationsSessionListPollingIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntMyCreationsSessionListPollingIntervalSeconds")

local FFlagBuildExperienceMyCreationsFindSessionsByUniverse = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMyCreationsFindSessionsByUniverse")
local FFlagBuildWithGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildWithGroups")
local FFlagBuildExperienceCursorSearchPages = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceCursorSearchPages")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = Localization.Hooks.useLocalization
local localizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local CreatorGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorGroups")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local UniverseSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseSearch")

local privacyType = UniverseConfiguration.PrivacyType

local thumbForUniverseId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/thumbForUniverseId")
local useCursorSearchPages = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useCursorSearchPages")

local GetBuildExperienceRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildExperienceRefreshStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore")
local GetSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")

local useSignalState = SignalsReact.useSignalState
local v5 = FFlagBuildExperienceMyCreationsFindSessionsByUniverse and 15 or 50
local v6 = {}
local v7 = { games = "All" }

local function privacyLabelForSearchItem(p2, p3)
	if UniverseConfiguration.getPrivacyTypeForAudiences(p2.audiences) == privacyType.Public then
		return p3.live
	end

	return nil
end

local function universeSearchParamsForPage(p2, search, p3)
	local v8 = {
		creatorType = "User",
		creatorTargetId = p2,
		surface = "CreatorHubCreations",
		isArchived = false,
		isTeamCreateEnabled = true,
		sortParam = "LastUpdated",
		sortOrder = "Desc",
		pageIndex = p3,
		pageSize = v5,
		search = nil,
		needsAssetOptions = true
	}

	if search == "" then
		search = nil
	end

	v8.search = search
	return v8
end

local function multiCreatorSearchParamsForPage(p2, search, p3)
	local v8 = {
		creators = p2,
		surface = "Build",
		isArchived = false,
		isTeamCreateEnabled = true,
		sortParam = "LastUpdated",
		sortOrder = "Desc",
		pageSize = v5,
		cursor = p3,
		search = nil,
		needsAssetOptions = true
	}

	if search == "" then
		search = nil
	end

	v8.search = search
	return v8
end

local function keyForCreators(list)
	if list == nil then
		return nil
	end

	local v8 = table.create(#list)

	for k, item in list do
		v8[k] = `{item.creatorType}:{item.creatorTargetId}`
	end

	return table.concat(v8, ",")
end

local function isCursorRequested(items, p2): boolean
	if items == nil then
		return false
	end

	for k, item in items do
		if item == p2 then
			return true
		end
	end

	return false
end

local function descriptionForSessionStatus(p2, p3)
	local roblox = p2._meta and p2._meta._roblox
	local sessionStatus = if roblox then roblox.sessionStatus else nil

	if sessionStatus == nil then
		return nil
	end

	return p3[sessionStatus]
end

local function requestHandleToPromise(more)
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

local function getSessionUniverseId(p2)
	local roblox = p2._meta and p2._meta._roblox

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

	for k, item in items do
		local roblox = item._meta and item._meta._roblox
		local universeId

		if roblox ~= nil then
			universeId = roblox.universeId

			if typeof(universeId) ~= "number" or universeId == 0 then
				universeId = nil
			end
		end

		if universeId ~= nil and latestSessionByUniverseId[universeId] == nil then
			latestSessionByUniverseId[universeId] = item
		end
	end

	return latestSessionByUniverseId
end

local function useUniverseSessions(p2, current)
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

	local v8 = React.useCallback(function(p3)
		local v9 = {}

		for k, v10 in ref3.current do
			if v10.isArchived then
				continue
			end

			local id = v10.id
			local v11 = ref2.current[id]

			if v11 == nil then
				if p3 or ref.current[id] == nil then
					local sessionFindByUniverse = p2.sessionFindByUniverse({
						universeId = id,
						sort = "desc",
						application = "build",
						filterByPinForBuild = true
					})

					local v12 = { handle = sessionFindByUniverse, promise = nil }

					ref2.current[id] = v12
					local v13 = Promise.new(function(callback, callback2)
						task.spawn(function()
							while sessionFindByUniverse.state(false).status == "pending" do
								task.wait()
							end

							local state2 = sessionFindByUniverse.state(false)

							if state2.status == "succeeded" then
								callback(state2.result)
							else
								callback2(state2.error)
							end
						end)
					end):andThen(function()
						local v14 = ref2.current[id]

						if v14 == nil or v14.handle ~= sessionFindByUniverse then
							return
						end

						ref2.current[id] = nil

						if ref4.current then
							local clone = table.clone(ref.current)
							clone[id] = sessionFindByUniverse
							ref.current = clone
							setState(clone)
						end
					end, function(p4)
						local v14 = ref2.current[id]

						if v14 ~= nil and v14.handle == sessionFindByUniverse then
							ref2.current[id] = nil
						end

						return Promise.reject(p4)
					end)

					v12.promise = v13
					table.insert(v9, v13)
				end
			else
				table.insert(v9, v11.promise)
			end
		end

		return Promise.all(v9)
	end, { p2 })

	React.useEffect(function()
		v8(false):catch(ignorePromiseRejection)
	end, { current, v8 })

	return {
		entries = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3)
				local result = {}

				for k, v10 in current do
					local v11 = state[v10.id]
					local v12 = if v11 ~= nil then v11.state(p3) else nil

					if not (v12 ~= nil and v12.status == "succeeded" and v12.result ~= nil) then
						continue
					end

					local sessions = v12.result.sessions
					local v13 = if typeof(sessions) == "table" then sessions[1] else nil

					if v13 ~= nil then
						table.insert(result, v13)
					end
				end

				return result
			end)
		end, { current, state }))),
		refresh = React.useCallback(function()
			return v8(true)
		end, { v8 })
	}
end

local function buildUniverseItems(items, p2, p3, p4, callback)
	local latestSessionByUniverseId = buildLatestSessionByUniverseId(p2)
	local universeItems = {}

	for k, item in items do
		if item.isArchived then
			continue
		end

		local id = item.id
		local v8 = latestSessionByUniverseId[id]
		local v9 = item.name

		if typeof(v9) ~= "string" or v9 == "" then
			v9 = callback(id)
		end

		local v11 = if v8 then v8.sessionId else nil
		local v10 = {
			sessionId = v11,
			universeId = id,
			placeId = item.rootPlaceId,
			experienceName = v9,
			creatorName = 0,
			description = 0,
			visibilityLabel = 0,
			gameIcon = 0,
			isGroupGame = 0
		}

		local v12 = if typeof(item.creatorName) == "string" and item.creatorName ~= "" then item.creatorName else nil
		v10.creatorName = v12
		local v13

		if v8 then
			local roblox = v8._meta and v8._meta._roblox
			local sessionStatus = if roblox then roblox.sessionStatus else nil

			if sessionStatus ~= nil then
				v13 = p3[sessionStatus]
			end
		end

		v10.description = v13
		local v14 = if UniverseConfiguration.getPrivacyTypeForAudiences(item.audiences) == privacyType.Public then p4.live else nil

		v10.visibilityLabel = v14
		v10.gameIcon = thumbForUniverseId(id)
		local v15 = if FFlagBuildWithGroups then item.creatorType == "Group" else nil
		v10.isGroupGame = v15
		table.insert(universeItems, v10)
	end

	return universeItems
end

local function useUniverseSearchList(p2, p3, current, p4, p5, p6, p7, p8, p9, p10)
	local ref = React.useRef({})
	local ref2 = React.useRef(current)
	ref2.current = current
	local creators = if FFlagBuildWithGroups then p10.creators else nil
	local v8 = if FFlagBuildWithGroups then keyForCreators(creators) else nil
	local ref3 = if FFlagBuildWithGroups then React.useRef(creators) else nil

	if FFlagBuildWithGroups then
		ref3.current = creators
	end

	local state, setState = React.useState({
		query = current,
		pageIndexes = { 0 },
		creators = creators,
		cursors = FFlagBuildWithGroups and {} or nil
	})

	local v9 = React.useMemo(function()
		local result = {}

		if FFlagBuildWithGroups then
			local creators2 = state.creators

			if creators2 ~= nil then
				local cursors = state.cursors or {}

				for k, pageIndex in state.pageIndexes do
					local query = state.query
					local v10 = {
						creators = creators2,
						surface = "Build",
						isArchived = false,
						isTeamCreateEnabled = true,
						sortParam = "LastUpdated",
						sortOrder = "Desc",
						pageSize = v5,
						cursor = cursors[pageIndex],
						search = nil,
						needsAssetOptions = true
					}

					if query == "" then
						query = nil
					end

					v10.search = query

					table.insert(result, (p2.getSearch(v10)))
				end

				return result
			end
		else
			for k, pageIndex in state.pageIndexes do
				local getSearch = p2.getSearch
				local query = state.query
				local v11 = {
					creatorType = "User",
					creatorTargetId = p3,
					surface = "CreatorHubCreations",
					isArchived = false,
					isTeamCreateEnabled = true,
					sortParam = "LastUpdated",
					sortOrder = "Desc",
					pageIndex = pageIndex,
					pageSize = v5,
					search = nil,
					needsAssetOptions = true
				}

				if query == "" then
					query = nil
				end

				v11.search = query

				table.insert(result, (getSearch(v11)))
			end
		end

		return result
	end, { state, p2, p3 })

	local v11 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p11)
			local total = 0
			local idSet = {}
			local v11 = {}
			local totalResults = nil
			local v12 = "NotReady"
			local v13 = nil
			local count = 0
			local v14 = "NotReady"

			for k, v15 in v9 do
				local data = v15.data(p11)
				v12 = v15.status(p11)

				if k == 1 then
					v14 = v12
				end

				if data == nil then
					continue
				end

				totalResults = data.totalResults or data.totalHits or totalResults
				local data2 = data.data or v6
				total += #data2
				v13 = data
				count = 0

				for k2, v16 in data2 do
					if idSet[v16.id] then
						continue
					end

					idSet[v16.id] = true
					count += 1
					table.insert(v11, v16)
				end
			end

			local v15 = nil
			local v16 = nil
			local v17 = nil

			if FFlagBuildWithGroups then
				if v12 == "Ready" and v13 ~= nil then
					local nextCursor = v13.nextCursor

					if nextCursor ~= nil and nextCursor ~= "" and count > 0 then
						local cursors = state.cursors
						local v18

						if cursors == nil then
							v18 = false
						else
							local flag = true

							for k, cursor in cursors do
								if cursor == nextCursor then
									v18 = true
									flag = false
									break
								end
							end

							if flag then
								v18 = false
							end
						end

						if not v18 then
							v15 = #state.pageIndexes
							v16 = nextCursor
						end
					end
				elseif v12 == "Failed" and #v9 > 1 then
					v17 = state.pageIndexes[#state.pageIndexes]
				end
			elseif v12 == "Ready" and v13 ~= nil then
				local nextResultIndex = v13.nextResultIndex

				if nextResultIndex == nil then
					if totalResults ~= nil and total < totalResults then
						v15 = state.pageIndexes[#state.pageIndexes] + 1
					end
				else
					v15 = nextResultIndex / v5
				end

				if v15 ~= nil and (v15 < 0 or table.find(state.pageIndexes, v15)) then
					v15 = nil
				end
			elseif v12 == "Failed" and #v9 > 1 then
				v17 = state.pageIndexes[#state.pageIndexes]
			end

			return {
				items = v11,
				status = v14,
				nextPageIndex = v15,
				nextCursor = v16,
				failedPageIndex = v17,
				isLoadingMore = #v9 > 1 and v12 == "NotReady"
			}
		end)
	end, { state.pageIndexes, state.cursors, v9 })))

	local v12 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then useUniverseSessions(p9, v11.items) else nil

	local v13 = React.useCallback(function(search, p11, p12, value, p13)
		local v14

		if FFlagBuildWithGroups then
			v14 = ("%*\0%*\0%*\0%*"):format(p11, search, value or "", keyForCreators(p13) or "")
		else
			v14 = ("%*\0%*"):format(p11, search)
		end

		if p12 then
			ref.current[v14] = nil
		end

		local v15 = ref.current[v14]

		if v15 ~= nil then
			return v15
		end

		local v16

		if FFlagBuildWithGroups then
			v16 = {
				creators = p13,
				surface = "Build",
				isArchived = false,
				isTeamCreateEnabled = true,
				sortParam = "LastUpdated",
				sortOrder = "Desc",
				pageSize = v5,
				cursor = value,
				search = 0,
				needsAssetOptions = true
			}
		else
			v16 = {
				creatorType = "User",
				creatorTargetId = p3,
				surface = "CreatorHubCreations",
				isArchived = false,
				isTeamCreateEnabled = true,
				sortParam = "LastUpdated",
				sortOrder = "Desc",
				pageIndex = p11,
				pageSize = v5,
				search = 0,
				needsAssetOptions = true
			}
		end

		if search == "" then
			search = nil
		end

		v16.search = search

		local v17 = nil
		v17 = p2.refreshSearch(v16):finally(function()
			if ref.current[v14] == v17 then
				ref.current[v14] = nil
			end
		end)
		ref.current[v14] = v17
		return v17
	end, { p2, p3 })

	local v14 = React.useCallback(function(p11)
		local v15 = p11 or ref2.current

		if not FFlagBuildWithGroups then
			setState({
				query = v15,
				pageIndexes = { 0 }
			})

			return v13(v15, 0)
		end

		local current2 = ref3.current
		setState({
			query = v15,
			pageIndexes = { 0 },
			creators = current2,
			cursors = {}
		})

		if current2 == nil then
			return Promise.resolve()
		end

		return v13(v15, 0, nil, nil, current2)
	end, { v13 })

	React.useEffect(function()
		if not p4 then
			return
		end

		local v15 = FFlagBuildWithGroups and keyForCreators(state.creators) ~= v8

		if state.query ~= current or v15 then
			v14(current):catch(ignorePromiseRejection)
		end
	end, { v8, current, p4, v14, state.creators, state.query })

	local v15 = React.useCallback(function()
		local failedPageIndex = v11.failedPageIndex or v11.nextPageIndex
		local query = state.query

		if v11.isLoadingMore or failedPageIndex == nil or ref2.current ~= query then
			return
		end

		if FFlagBuildWithGroups then
			local creators2 = state.creators

			if creators2 == nil or keyForCreators(creators2) ~= keyForCreators(ref3.current) then
				return
			end

			local v16 = v11.failedPageIndex ~= nil
			local v17 = if v16 then (state.cursors or {})[failedPageIndex] else v11.nextCursor

			if not v16 then
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
					clone2[failedPageIndex] = v17
					return {
						query = data.query,
						pageIndexes = clone,
						creators = data.creators,
						cursors = clone2
					}
				end)
			end

			v13(query, failedPageIndex, v16, v17, creators2):catch(ignorePromiseRejection)
		else
			if v11.failedPageIndex == nil then
				setState(function(p11)
					if p11.query ~= query or table.find(p11.pageIndexes, failedPageIndex) then
						return p11
					end

					local clone = table.clone(p11.pageIndexes)
					table.insert(clone, failedPageIndex)
					return { query = p11.query, pageIndexes = clone }
				end)
			end

			v13(query, failedPageIndex, v11.failedPageIndex ~= nil):catch(ignorePromiseRejection)
		end
	end, { v11, v13, state.creators, state.cursors, state.query })

	local useMemo = React.useMemo
	local function fn()
		local items = v11.items

		local v17 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then v12.entries else p5
		return buildUniverseItems(items, v17, p6, p7, p8)
	end

	local items = v11.items

	local v17 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then v12.entries else p5
	local v18 = {
		items = useMemo(fn, { p6, items, v17, p7, p8 }),
		status = 0,
		sourceItemCount = 0,
		failedLoadMore = 0,
		isLoadingMore = 0,
		query = 0,
		refresh = 0,
		refreshSessions = 0,
		loadMore = 0
	}

	local v19 = if FFlagBuildWithGroups and p10.creators == nil then p10.status else v11.status
	v18.status = v19

	v18.sourceItemCount = #v11.items
	v18.failedLoadMore = v11.failedPageIndex ~= nil
	v18.isLoadingMore = v11.isLoadingMore
	v18.query = state.query
	v18.refresh = v14

	local v20 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then v12.refresh else nil
	v18.refreshSessions = v20

	v18.loadMore = v15
	return v18
end

local function useUniverseListItems(items, p2, p3, p4, p5, p6)
	local v8 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then useUniverseSessions(p6, items) else nil

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		p2 = v8.entries
	end

	local v9 = {
		items = React.useMemo(function()
			return buildUniverseItems(items, p2, p3, p4, p5)
		end, { p3, p2, items, p4, p5 }),
		refreshSessions = 0
	}

	local v10 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then v8.refresh else nil
	v9.refreshSessions = v10
	return v9
end

local function useCreatorSearchList(p2, current, p3, p4, p5, p6, p7, p8, p9)
	local creators = p9.creators
	local v8 = keyForCreators(creators)

	local ref = React.useRef(current)

	if p3 then
		ref.current = current
	end

	local current2 = ref.current

	local v10 = useCursorSearchPages({
		searchStore = p2,
		sources = React.useMemo(function()
			if creators == nil then
				return nil
			end

			local v11 = {
				key = ("%*\0%*"):format(current2, v8),
				params = 0
			}
			local v12 = current2
			local v13 = {
				creators = creators,
				surface = "Build",
				isArchived = false,
				isTeamCreateEnabled = true,
				sortParam = "LastUpdated",
				sortOrder = "Desc",
				pageSize = v5,
				cursor = nil,
				search = nil,
				needsAssetOptions = true
			}

			if v12 == "" then
				v12 = nil
			end

			v13.search = v12

			v11.params = v13
			return { v11 }
		end, { current2, creators, v8 })
	})

	local v11 = useUniverseListItems(v10.items, p4, p5, p6, p7, p8)

	local v12 = {
		items = v11.items,
		status = 0,
		sourceItemCount = 0,
		failedLoadMore = 0,
		isLoadingMore = 0,
		query = 0,
		refresh = 0,
		refreshSessions = 0,
		loadMore = 0
	}
	local v13 = if creators == nil then p9.status else v10.status
	v12.status = v13
	v12.sourceItemCount = #v10.items
	v12.failedLoadMore = v10.failedLoadMore
	v12.isLoadingMore = v10.isLoadingMore
	v12.query = current2
	v12.refresh = v10.refresh
	v12.refreshSessions = v11.refreshSessions
	v12.loadMore = v10.loadMore
	return v12
end

local function useBuildCreators(creatorGroupsStore, userId, filter)
	local v8 = React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("Build"))
	end, { creatorGroupsStore })
	local v9 = useSignalState(v8.data)
	local v10 = useSignalState(v8.status)
	local games = filter.games
	local groupId = filter.groupId

	return React.useMemo(function()
		local v11 = { creatorType = "User", creatorTargetId = userId }

		if games == "MyGames" then
			return {
				creators = { v11 },
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

		if v9 == nil then
			return {
				creators = nil,
				status = v10 == "Failed" and "Failed" or "NotReady"
			}
		end

		if games == "GroupGames" and groupId ~= nil then
			for k, group in v9.groups do
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

		if games == "GroupGames" and #v9.groups == 0 then
			return { creators = nil, status = "Ready" }
		end

		local v12 = games == "GroupGames" and {} or { v11 }

		for k, group in v9.groups do
			table.insert(v12, { creatorType = "Group", creatorTargetId = group.id })
		end

		return { creators = v12, status = "Ready" }
	end, { games, groupId, v9, v10, userId })
end

local function useMyCreationsResults(data)
	local v8 = useLocalization({
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

	local v9 = React.useContext(localizationRoactContext)
	local v10 = { v9, v8[Localization.RobloxLocaleIdKey] }
	local v11 = React.useCallback(function(p2)
		return v9:Format(LocalizationStrings.MY_CREATIONS_UNIVERSE_NAME, { UNIVERSE_ID = p2 })
	end, v10)

	local loadError = v8.loadError
	local v12 = React.useMemo(function()
		return {
			waiting_on_client = v8.inputNeeded,
			idle = v8.ready,
			working = v8.building
		}
	end, { v8.inputNeeded, v8.ready, v8.building })

	local v13 = React.useMemo(function()
		return {
			live = v8.live,
			private = v8.private,
			public = v8.public,
			publiclyUnavailable = v8.publiclyUnavailable,
			restricted = v8.restricted
		}
	end, { v8.live, v8.private, v8.public, v8.publiclyUnavailable, v8.restricted })

	local creatorAgentChatStore = data.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v14 = data.searchStore

	if v14 == nil then
		v14 = UniverseSearch.getUniverseSearchStore()
	end

	local searchQueryStore = data.searchQueryStore or GetSearchQueryStore()
	local v15 = GetBuildExperienceRefreshStore()
	local appLifecycleObserverService = data.appLifecycleObserverService or AppLifecycleObserverService
	local isFocused = data.isFocused ~= false
	local state, setState = React.useState(false)
	local v16 = searchQueryStore.useDebouncedQuery()
	local v17 = useSignalState(v15.getRefreshTick)

	local ref = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then React.useRef(v17) else nil

	local ref2 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then React.useRef(isFocused) else nil

	local sessionListStore = creatorAgentChatStore.getSessionListStore()
	local v18 = useSignalState(sessionListStore.getSessions)
	local v19 = useSignalState(sessionListStore.getNextPageToken)
	local v20 = useSignalState(sessionListStore.getStatus)
	local v21 = useSignalState(sessionListStore.getLoadMoreStatus)
	local v22 = v20 == "pending" and "NotReady" or v20 == "succeeded" and "Ready" or "Failed"

	local userId = data.userId or not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId

	local creatorGroupsStore = if FFlagBuildWithGroups then data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore() else nil

	local v23 = if FFlagBuildWithGroups then useBuildCreators(creatorGroupsStore, userId, data.filter or v7) else nil
	local v24

	if FFlagBuildExperienceCursorSearchPages then
		if not FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			creatorAgentChatStore = nil
		end

		v24 = useCreatorSearchList(v14, v16, isFocused, v18, v12, v13, v11, creatorAgentChatStore, v23)
	else
		if not FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			creatorAgentChatStore = nil
		end

		v24 = useUniverseSearchList(
			v14,
			userId,
			v16,
			isFocused,
			v18,
			v12,
			v13,
			v11,
			creatorAgentChatStore,
			v23
		)
	end

	local refresh = v24.refresh

	local refreshSessions = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then v24.refreshSessions else nil

	local ref3 = if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then React.useRef(refreshSessions) else nil

	if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
		ref3.current = refreshSessions
	end

	local v25 = React.useCallback(function()
		local v26 = sessionListStore.refresh()
		local v27 = Promise.new(function(callback, callback2)
			task.spawn(function()
				while v26.state(false).status == "pending" do
					task.wait()
				end

				local state2 = v26.state(false)

				if state2.status == "succeeded" then
					callback(state2.result)
				else
					callback2(state2.error)
				end
			end)
		end)

		if FFlagBuildWithGroups then
			creatorGroupsStore.fetchGroups("Build")
		end

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			return Promise.all({ refresh(), v27, ref3.current():catch(ignorePromiseRejection) })
		end

		return Promise.all({ refresh(), v27 })
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
		local v26

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse then
			v26 = ref.current ~= v17 or isFocused and not ref2.current
			ref.current = v17
			ref2.current = isFocused
		else
			v26 = false
		end

		if not isFocused then
			setState(false)
			return
		end

		setState(false)
		refresh():catch(ignorePromiseRejection)

		if FFlagBuildExperienceMyCreationsFindSessionsByUniverse and v26 then
			ref3.current():catch(ignorePromiseRejection)
		end

		local v27 = sessionListStore.refresh()
		return Signals.createEffect(function(p2)
			if v27.state(p2).status == "succeeded" then
				setState(true)
			end
		end)
	end, { isFocused, v17, refresh, sessionListStore })

	local v26 = math.max(0, data.pollingIntervalSeconds or FIntMyCreationsSessionListPollingIntervalSeconds)
	React.useEffect(function()
		if not isFocused or v26 == 0 then
			return
		end

		local flag = false
		local function scheduleNextPoll()
			task.delay(v26, function()
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

		task.delay(v26, function()
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
	end, { isFocused, v26, sessionListStore })

	local items = v24.items
	local items2 = v24.items

	local status = v24.status
	local sourceItemCount = v24.sourceItemCount
	local v27 = status == "Ready" or sourceItemCount > 0
	local v28 = v21 == "pending"
	local failedLoadMore = v24.failedLoadMore
	local isLoadingMore = v24.isLoadingMore

	local v29 = React.useCallback(function()
		local more = sessionListStore.loadMore()

		if more == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(more)
	end, { v28, v19, v22, sessionListStore })

	local loadMore = v24.loadMore

	local v30 = React.useCallback(function(data2)
		local y = data2.AbsoluteCanvasSize.Y

		if data2.CanvasPosition.Y <= 0 or y <= 0 or data2.AbsoluteWindowSize.Y <= 0 then
			return
		end

		if math.max(0, y - data2.AbsoluteWindowSize.Y - 250) < data2.CanvasPosition.Y then
			loadMore()

			if v19 ~= nil and not v28 and v22 == "Ready" then
				v29()
			end
		end
	end, { v28, v29, loadMore, v19, v22 })

	local query = v24.query

	return {
		displayedItems = items,
		items = items2,
		listStatus = status,
		hasDisplayedResult = v27,
		hasPendingSummary = false,
		isSettledNoResults = query == v16 and v27 and #items2 == 0,
		query = query,
		sourceItemCount = sourceItemCount,
		sessionCount = #v18,
		sessionListStatus = v22,
		hasCompletedFocusedRefresh = state,
		loadError = loadError,
		refresh = v25,
		loadMoreIfNeeded = v30,
		failedLoadMore = failedLoadMore,
		retryLoadMore = loadMore,
		isLoadingMore = isLoadingMore
	}
end

return useMyCreationsResults
