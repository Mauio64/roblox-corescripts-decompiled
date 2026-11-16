local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Players = game:GetService("Players")

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local CreatorGroups = require(parent.DataHydration.CreatorGroups)
local UniverseSearch = require(parent.DataHydration.UniverseSearch)

local GamesFilter = require(BuildExperience.Stores.GetMyCreationsFilterStore.GamesFilter)
require(BuildExperience.Stores.GetMyCreationsFilterStore)
local thumbForUniverseId = require(BuildExperience.utils.thumbForUniverseId)
local useCursorSearchPages = require(BuildExperience.utils.useCursorSearchPages)

local DataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState

local v = { games = GamesFilter.All }
local previewGroups = {}
local v2 = {}

local function toPreviewItem(item)
	local previewItem = {
		universeId = item.id,
		experienceName = item.name or "",
		creatorName = 0,
		gameIcon = 0,
		isGroupGame = 0
	}
	local creatorName

	if typeof(item.creatorName) == "string" and item.creatorName ~= "" then
		creatorName = item.creatorName
	end

	previewItem.creatorName = creatorName
	previewItem.gameIcon = thumbForUniverseId(item.id)
	previewItem.isGroupGame = item.creatorType == "Group"
	return previewItem
end

local function createSource(creators)
	local v3 = table.create(#creators)

	for k, item in creators do
		v3[k] = `{item.creatorType}:{item.creatorTargetId}`
	end

	return {
		key = table.concat(v3, ","),
		params = {
			creators = creators,
			surface = "BuildPreview",
			isArchived = false,
			sortParam = "LastUpdated",
			sortOrder = "Desc",
			pageSize = 15
		}
	}
end

local function ignorePromiseRejection() end

local function usePreviewSources(creatorGroupsStore, userId: number, filter)
	local v3 = React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("BuildPreview"))
	end, { creatorGroupsStore })

	local v4 = useSignalState(v3.data)
	local v5 = useSignalState(v3.status)

	local games = filter.games
	local groupId = filter.groupId

	return (React.useMemo(function()
		if v4 == nil and games ~= GamesFilter.SharedGames then
			local v6 = { sources = nil, previewGroups = previewGroups, status = 0 }
			local status

			if v5 == DataStatus.Failed then
				status = DataStatus.Failed
			else
				status = DataStatus.NotReady
			end

			v6.status = status
			return v6
		else
			local previewGroups2

			if v4 == nil then
				previewGroups2 = previewGroups
			else
				previewGroups2 = v4.groups
			end

			local v6 = false

			for _, v7 in previewGroups2 do
				v6 = v6 or v7.id == groupId
			end

			local sources = {}

			if games ~= GamesFilter.SharedGames then
				local creators = {}

				for _, v7 in previewGroups2 do
					if not v6 or games ~= GamesFilter.GroupGames or v7.id == groupId then
						table.insert(creators, { creatorType = "Group", creatorTargetId = v7.id })
					end
				end

				if #creators > 0 then
					table.insert(sources, createSource(creators))
				end
			end

			if games ~= GamesFilter.GroupGames then
				table.insert(sources, createSource({
					{ creatorType = "Team", creatorTargetId = userId }
				}))
			end

			return { sources = sources, previewGroups = previewGroups2, status = DataStatus.Ready }
		end
	end, { games, groupId, v4, v5, userId }))
end

local function usePreviewResults(data)
	local searchStore = data.searchStore or UniverseSearch.getUniverseSearchStore()
	local creatorGroupsStore = data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore()
	local userId = data.userId or not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
	local isFocused = data.isFocused ~= false

	local filter = data.filter or v
	local v3 = usePreviewSources(creatorGroupsStore, userId, filter)
	local v4 = useCursorSearchPages({ searchStore = searchStore, sources = v3.sources })

	local refresh = v4.refresh
	local games = filter.games
	local refresh2 = React.useCallback(function()
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
			refresh2():catch(ignorePromiseRejection)
		end
	end, { isFocused, refresh2 })

	local items = React.useMemo(function()
		if #v4.items == 0 then
			return v2
		end

		local result = table.create(#v4.items)

		for _, item in v4.items do
			table.insert(result, toPreviewItem(item))
		end

		return result
	end, { v4.items })

	local status = if v3.sources == nil then v3.status else v4.status
	return {
		items = items,
		status = status,
		hasPreviews = #items > 0,
		previewGroups = v3.previewGroups,
		isLoadingMore = v4.isLoadingMore,
		failedLoadMore = v4.failedLoadMore,
		refresh = refresh2,
		loadMore = v4.loadMore
	}
end

return usePreviewResults
