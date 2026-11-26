local CreatorGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorGroups")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FFlagBuildExperienceFiltersSaveLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFiltersSaveLabel")
local FFlagBuildExperiencePreviewsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePreviewsTab")
local GamesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/GamesFilter")
local GetMyCreationsFilterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore")
local matchesSearchQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/matchesSearchQuery")
local useClosableFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useClosableFocusRoot")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/MyCreationsFilterView")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local v5 = { games = "MyGames" }
local v6 = { "All", "MyGames", "GroupGames", "SharedGames" }

local function getGroupIcon(p2)
	return string.format("rbxthumb://type=GroupIcon&id=%d&w=150&h=150", p2)
end

local function useMyCreationsFilterViewModel(data)
	local filterStore = data.filterStore or GetMyCreationsFilterStore()
	local v7 = filterStore.useFilter()
	local creatorGroupsStore = data.creatorGroupsStore or CreatorGroups.getCreatorGroupsStore()
	local v9 = useSignalState(React.useMemo(function()
		return (creatorGroupsStore.getAndFetchGroups("Build"))
	end, { creatorGroupsStore }).data)
	local groups = if v9 ~= nil then v9.groups else nil
	local v10 = v5
	local v11 = v6

	if FFlagBuildExperiencePreviewsTab then
		groups = data.groups or groups
		v10 = data.defaultFilter or v10
		v11 = data.options or v11
	end

	local v12 = {
		all = LocalizationStrings.MY_CREATIONS_FILTER_ALL,
		allGames = LocalizationStrings.MY_CREATIONS_FILTER_ALL_GAMES,
		apply = 0,
		games = 0,
		groupGames = 0,
		groups = 0,
		myGames = 0,
		reset = 0,
		searchGroups = 0,
		sharedGames = 0,
		title = 0
	}

	local v13 = if FFlagBuildExperienceFiltersSaveLabel then LocalizationStrings.MY_CREATIONS_FILTER_SAVE else LocalizationStrings.MY_CREATIONS_FILTER_APPLY
	v12.apply = v13

	v12.games = LocalizationStrings.MY_CREATIONS_FILTER_GAMES
	v12.groupGames = LocalizationStrings.MY_CREATIONS_FILTER_GROUP_GAMES
	v12.groups = LocalizationStrings.MY_CREATIONS_FILTER_GROUPS
	v12.myGames = LocalizationStrings.MY_CREATIONS_FILTER_MY_GAMES
	v12.reset = LocalizationStrings.MY_CREATIONS_FILTER_RESET
	v12.searchGroups = LocalizationStrings.MY_CREATIONS_FILTER_SEARCH_GROUPS
	v12.sharedGames = LocalizationStrings.MY_CREATIONS_FILTER_SHARED_GAMES
	v12.title = LocalizationStrings.MY_CREATIONS_FILTER_TITLE

	local v14 = useLocalization(v12)
	local all = v14.all
	local v15 = v14.allGames
	local groupGames = v14.groupGames
	local myGames = v14.myGames
	local sharedGames = v14.sharedGames

	local state, setState = React.useState(v7)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)

	local v16 = React.useCallback(function()
		setState(filterStore.getFilter())
		setState2("")
		setState3(true)
	end, { filterStore })

	local v17 = React.useCallback(function()
		setState3(false)
	end, {})

	local v18 = useClosableFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = state3,
		onClose = v17
	})

	local v19 = React.useCallback(function(p2)
		if table.find(v11, p2) then
			setState(function(p3)
				local v20 = { games = p2, groupId = 0 }

				local v21 = if p2 == "GroupGames" then p3.groupId else nil
				v20.groupId = v21
				return v20
			end)
		end
	end, { v11 })

	local v20 = React.useCallback(function(p2)
		setState(function(p3)
			local v22 = if p3.groupId ~= p2 then p2 else nil
			return { games = "GroupGames", groupId = v22 }
		end)
	end, {})

	local v21 = React.useCallback(function()
		filterStore.setFilter(state)
		setState3(false)
	end, { state, filterStore })

	local v22 = React.useCallback(function()
		setState(v10)
		setState2("")
	end, { v10 })

	local v23 = groups == nil or #groups == 0

	local v24 = React.useMemo(function()
		if FFlagBuildExperiencePreviewsTab then
			local v25 = {
				[GamesFilter.All] = all,
				[GamesFilter.MyGames] = myGames,
				[GamesFilter.GroupGames] = groupGames,
				[GamesFilter.SharedGames] = sharedGames
			}

			local result = {}

			for k, v26 in v11 do
				if not v23 or v26 ~= GamesFilter.GroupGames then
					table.insert(result, { value = v26, label = v25[v26] })
				end
			end

			return result
		else
			local v25 = {
				{ value = "All", label = all },
				{ value = "MyGames", label = myGames }
			}

			if not v23 then
				table.insert(v25, { value = "GroupGames", label = groupGames })
			end

			table.insert(v25, { value = "SharedGames", label = sharedGames })
			return v25
		end
	end, { all, groupGames, v23, myGames, sharedGames, v11 })

	local groupId = state.groupId
	local v25 = React.useMemo(function()
		local result = {}

		if groups == nil then
			return result
		end

		for k, group in groups do
			if not matchesSearchQuery(group.name, state2) then
				continue
			end

			local v26 = {
				id = group.id,
				name = group.name,
				icon = 0,
				isSelected = 0,
				onActivated = 0
			}
			local id = group.id
			v26.icon = string.format("rbxthumb://type=GroupIcon&id=%d&w=150&h=150", id)
			v26.isSelected = group.id == groupId
			function v26.onActivated()
				v20(group.id)
			end

			table.insert(result, v26)
		end

		return result
	end, { state2, groups, v20, groupId })

	local name = nil

	if v7.games == "GroupGames" and v7.groupId ~= nil and groups ~= nil then
		for k, group in groups do
			if group.id == v7.groupId then
				name = group.name
				break
			end
		end
	end

	if name == nil then
		if v7.games == "MyGames" then
			v15 = myGames
		elseif v7.games == "GroupGames" then
			v15 = groupGames
		elseif v7.games == "SharedGames" then
			v15 = sharedGames
		end
	else
		v15 = name
	end

	return {
		LayoutOrder = data.LayoutOrder,
		label = v15,
		onOpenSheet = v16,
		isSheetOpen = state3,
		onSheetClosed = v17,
		focusRootRef = v18,
		titleText = v14.title,
		gamesLegend = v14.games,
		gamesOptions = v24,
		selectedGames = state.games,
		onGamesChanged = v19,
		isGroupsVisible = state.games == "GroupGames" and groups ~= nil and #groups > 0,
		groupsLegend = v14.groups,
		groupSearchText = state2,
		groupSearchPlaceholder = v14.searchGroups,
		onGroupSearchTextChanged = setState2,
		groups = v25,
		applyText = v14.apply,
		resetText = v14.reset,
		onApply = v21,
		onReset = v22,
		testId = data.testId
	}
end

return useMyCreationsFilterViewModel
