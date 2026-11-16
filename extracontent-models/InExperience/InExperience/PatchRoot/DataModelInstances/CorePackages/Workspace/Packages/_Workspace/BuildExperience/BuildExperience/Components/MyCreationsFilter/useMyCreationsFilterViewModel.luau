local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorGroups = require(parent.DataHydration.CreatorGroups)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperiencePreviewsTab = require(BuildExperience.Flags.FFlagBuildExperiencePreviewsTab)
local GamesFilter = require(BuildExperience.Stores.GetMyCreationsFilterStore.GamesFilter)
local GetMyCreationsFilterStore = require(BuildExperience.Stores.GetMyCreationsFilterStore)
local matchesSearchQuery = require(BuildExperience.utils.matchesSearchQuery)
local useClosableFocusRoot = require(BuildExperience.utils.useClosableFocusRoot)
require(script.Parent.MyCreationsFilterView)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local v = { games = "MyGames" }
local v2 = { "All", "MyGames", "GroupGames", "SharedGames" }

local function getGroupIcon(id: number) -- 1 equivalent call inferred from this helper
	return string.format("rbxthumb://type=GroupIcon&id=%d&w=150&h=150", id)
end

local function useMyCreationsFilterViewModel(data)
	local filterStore = data.filterStore or GetMyCreationsFilterStore()
	local v3 = filterStore.useFilter()
	local creatorGroupsStore = data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore()
	local v4 = useSignalState(React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("Build"))
	end, { creatorGroupsStore }).data)
	local groups

	if v4 == nil then
		groups = nil
	else
		groups = v4.groups
	end

	local v5 = v
	local v6 = v2

	if FFlagBuildExperiencePreviewsTab then
		groups = data.groups or groups
		v5 = data.defaultFilter or v5
		v6 = data.options or v6
	end

	local v7 = useLocalization({
		all = LocalizationStrings.MY_CREATIONS_FILTER_ALL,
		allGames = LocalizationStrings.MY_CREATIONS_FILTER_ALL_GAMES,
		apply = LocalizationStrings.MY_CREATIONS_FILTER_APPLY,
		games = LocalizationStrings.MY_CREATIONS_FILTER_GAMES,
		groupGames = LocalizationStrings.MY_CREATIONS_FILTER_GROUP_GAMES,
		groups = LocalizationStrings.MY_CREATIONS_FILTER_GROUPS,
		myGames = LocalizationStrings.MY_CREATIONS_FILTER_MY_GAMES,
		reset = LocalizationStrings.MY_CREATIONS_FILTER_RESET,
		searchGroups = LocalizationStrings.MY_CREATIONS_FILTER_SEARCH_GROUPS,
		sharedGames = LocalizationStrings.MY_CREATIONS_FILTER_SHARED_GAMES,
		title = LocalizationStrings.MY_CREATIONS_FILTER_TITLE
	})
	local all = v7.all
	local label = v7.allGames
	local groupGames = v7.groupGames
	local myGames = v7.myGames
	local sharedGames = v7.sharedGames

	local state, setState = React.useState(v3)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)

	local onOpenSheet = React.useCallback(function()
		setState(filterStore.getFilter())
		setState2("")
		setState3(true)
	end, { filterStore })

	local v8 = React.useCallback(function()
		setState3(false)
	end, {})

	local focusRootRef = useClosableFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = state3,
		onClose = v8
	})

	local onGamesChanged = React.useCallback(function(games: string)
		if table.find(v6, games) then
			setState(function(p)
				local v9 = { games = games, groupId = 0 }
				local groupId

				if games == "GroupGames" then
					groupId = p.groupId
				end

				v9.groupId = groupId
				return v9
			end)
		end
	end, { v6 })

	local v9 = React.useCallback(function(p: number)
		setState(function(p2)
			local groupId

			if p2.groupId ~= p then
				groupId = p
			end

			return { games = "GroupGames", groupId = groupId }
		end)
	end, {})

	local onApply = React.useCallback(function()
		filterStore.setFilter(state)
		setState3(false)
	end, { state, filterStore })

	local onReset = React.useCallback(function()
		setState(v5)
		setState2("")
	end, { v5 })

	local v10 = groups == nil or #groups == 0

	local gamesOptions = React.useMemo(function()
		if FFlagBuildExperiencePreviewsTab then
			local v11 = {
				[GamesFilter.All] = all,
				[GamesFilter.MyGames] = myGames,
				[GamesFilter.GroupGames] = groupGames,
				[GamesFilter.SharedGames] = sharedGames
			}

			local result = {}

			for _, v12 in v6 do
				if not v10 or v12 ~= GamesFilter.GroupGames then
					table.insert(result, { value = v12, label = v11[v12] })
				end
			end

			return result
		else
			local v11 = {
				{ value = "All", label = all },
				{ value = "MyGames", label = myGames }
			}

			if not v10 then
				table.insert(v11, { value = "GroupGames", label = groupGames })
			end

			table.insert(v11, { value = "SharedGames", label = sharedGames })
			return v11
		end
	end, { all, groupGames, v10, myGames, sharedGames, v6 })

	local groupId = state.groupId
	local groups2 = React.useMemo(function()
		local result = {}

		if groups == nil then
			return result
		end

		for _, group in groups do
			if not matchesSearchQuery(group.name, state2) then
				continue
			end

			local v11 = {
				id = group.id,
				name = group.name,
				icon = getGroupIcon(group.id), -- inferred equivalent call
				isSelected = group.id == groupId,
				onActivated = function()
					v9(group.id)
				end
			}
			table.insert(result, v11)
		end

		return result
	end, { state2, groups, v9, groupId })

	local name = nil

	if v3.games == "GroupGames" and v3.groupId ~= nil and groups ~= nil then
		for _, group in groups do
			if group.id == v3.groupId then
				name = group.name
				break
			end
		end
	end

	if name == nil then
		if v3.games == "MyGames" then
			label = myGames
		elseif v3.games == "GroupGames" then
			label = groupGames
		elseif v3.games == "SharedGames" then
			label = sharedGames
		end
	else
		label = name
	end

	return {
		LayoutOrder = data.LayoutOrder,
		label = label,
		onOpenSheet = onOpenSheet,
		isSheetOpen = state3,
		onSheetClosed = v8,
		focusRootRef = focusRootRef,
		titleText = v7.title,
		gamesLegend = v7.games,
		gamesOptions = gamesOptions,
		selectedGames = state.games,
		onGamesChanged = onGamesChanged,
		isGroupsVisible = state.games == "GroupGames" and groups ~= nil and #groups > 0,
		groupsLegend = v7.groups,
		groupSearchText = state2,
		groupSearchPlaceholder = v7.searchGroups,
		onGroupSearchTextChanged = setState2,
		groups = groups2,
		applyText = v7.apply,
		resetText = v7.reset,
		onApply = onApply,
		onReset = onReset,
		testId = data.testId
	}
end

return useMyCreationsFilterViewModel
