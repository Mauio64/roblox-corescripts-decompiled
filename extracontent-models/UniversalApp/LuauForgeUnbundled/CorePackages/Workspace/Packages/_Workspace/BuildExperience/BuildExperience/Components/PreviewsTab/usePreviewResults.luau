local Players = game:GetService("Players")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local CreatorGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorGroups")
local UniverseSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseSearch")

local GamesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/GamesFilter")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore")
local thumbForUniverseId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/thumbForUniverseId")
local useCursorSearchPages = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useCursorSearchPages")

local dataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState

local v5 = { games = GamesFilter.All }
local v6 = {}
local v7 = {}

local function toPreviewItem(item)
	local previewItem = {
		universeId = item.id,
		experienceName = item.name or "",
		creatorName = 0,
		gameIcon = 0,
		isGroupGame = 0
	}
	local v8 = if typeof(item.creatorName) == "string" and item.creatorName ~= "" then item.creatorName else nil
	previewItem.creatorName = v8
	previewItem.gameIcon = thumbForUniverseId(item.id)
	previewItem.isGroupGame = item.creatorType == "Group"
	return previewItem
end

local function createSource(list)
	local v8 = table.create(#list)

	for k, item in list do
		v8[k] = `{item.creatorType}:{item.creatorTargetId}`
	end

	return {
		key = table.concat(v8, ","),
		params = {
			creators = list,
			surface = "BuildPreview",
			isArchived = false,
			sortParam = "LastUpdated",
			sortOrder = "Desc",
			pageSize = 15
		}
	}
end

local function ignorePromiseRejection() end

local function usePreviewSources(creatorGroupsStore, userId, filter)
	local v8 = React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("BuildPreview"))
	end, { creatorGroupsStore })

	local v9 = useSignalState(v8.data)
	local v10 = useSignalState(v8.status)

	local games = filter.games
	local groupId = filter.groupId

	return (React.useMemo(function()
		if v9 == nil and games ~= GamesFilter.SharedGames then
			local v11 = { sources = nil, previewGroups = v6, status = 0 }

			local v12 = if v10 == dataStatus.Failed then dataStatus.Failed else dataStatus.NotReady
			v11.status = v12
			return v11
		else
			local v11 = if v9 == nil then v6 else v9.groups
			local v12 = false

			for k, v13 in v11 do
				v12 = v12 or v13.id == groupId
			end

			local v13 = {}

			if games ~= GamesFilter.SharedGames then
				local v14 = {}

				for k, v15 in v11 do
					if not v12 or games ~= GamesFilter.GroupGames or v15.id == groupId then
						table.insert(v14, {
							creatorType = "Group",
							creatorTargetId = v15.id
						})
					end
				end

				if #v14 > 0 then
					table.insert(v13, createSource(v14))
				end
			end

			if games ~= GamesFilter.GroupGames then
				table.insert(v13, createSource({
					{ creatorType = "Team", creatorTargetId = userId }
				}))
			end

			return { sources = v13, previewGroups = v11, status = dataStatus.Ready }
		end
	end, { games, groupId, v9, v10, userId }))
end

local function usePreviewResults(data)
	local searchStore = data.searchStore or UniverseSearch.getUniverseSearchStore()
	local creatorGroupsStore = data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore()
	local userId = data.userId or not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
	local isFocused = data.isFocused ~= false

	local filter = data.filter or v5
	local v8 = usePreviewSources(creatorGroupsStore, userId, filter)
	local v9 = useCursorSearchPages({ searchStore = searchStore, sources = v8.sources })

	local refresh = v9.refresh
	local games = filter.games
	local v10 = React.useCallback(function()
		if games ~= GamesFilter.SharedGames then
			creatorGroupsStore.fetchGroups("BuildPreview")
		end

		return refresh()
	end, { creatorGroupsStore, games, refresh })

	local ref = React.useRef(false)
	React.useEffect(function()
		local current = ref.current
		ref.current = isFocused

		if isFocused and not current then
			v10():catch(ignorePromiseRejection)
		end
	end, { isFocused, v10 })

	local v11 = React.useMemo(function()
		if #v9.items == 0 then
			return v7
		end

		local result = table.create(#v9.items)

		for k, item in v9.items do
			table.insert(result, toPreviewItem(item))
		end

		return result
	end, { v9.items })

	local v13 = if v8.sources == nil then v8.status else v9.status
	return {
		items = v11,
		status = v13,
		hasPreviews = #v11 > 0,
		previewGroups = v8.previewGroups,
		isLoadingMore = v9.isLoadingMore,
		failedLoadMore = v9.failedLoadMore,
		refresh = v10,
		loadMore = v9.loadMore
	}
end

return usePreviewResults
