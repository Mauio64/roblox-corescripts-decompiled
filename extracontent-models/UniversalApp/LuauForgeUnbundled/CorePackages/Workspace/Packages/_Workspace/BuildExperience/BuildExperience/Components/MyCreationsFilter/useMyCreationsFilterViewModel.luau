local CreatorGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorGroups")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

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

	local v13 = useLocalization({
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
	local all = v13.all
	local v14 = v13.allGames
	local groupGames = v13.groupGames
	local myGames = v13.myGames
	local sharedGames = v13.sharedGames

	local state, setState = React.useState(v7)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)

	local v15 = React.useCallback(function()
		setState(filterStore.getFilter())
		setState2("")
		setState3(true)
	end, { filterStore })

	local v16 = React.useCallback(function()
		setState3(false)
	end, {})

	local v17 = useClosableFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = state3,
		onClose = v16
	})

	local v18 = React.useCallback(function(p2)
		if table.find(v11, p2) then
			setState(function(p3)
				local v19 = { games = p2, groupId = 0 }

				local v20 = if p2 == "GroupGames" then p3.groupId else nil
				v19.groupId = v20
				return v19
			end)
		end
	end, { v11 })

	local v19 = React.useCallback(function(p2)
		setState(function(p3)
			local v21 = if p3.groupId ~= p2 then p2 else nil
			return { games = "GroupGames", groupId = v21 }
		end)
	end, {})

	local v20 = React.useCallback(function()
		filterStore.setFilter(state)
		setState3(false)
	end, { state, filterStore })

	local v21 = React.useCallback(function()
		setState(v10)
		setState2("")
	end, { v10 })

	local v22 = groups == nil or #groups == 0

	local v23 = React.useMemo(function()
		if FFlagBuildExperiencePreviewsTab then
			local v24 = {
				[GamesFilter.All] = all,
				[GamesFilter.MyGames] = myGames,
				[GamesFilter.GroupGames] = groupGames,
				[GamesFilter.SharedGames] = sharedGames
			}

			local result = {}

			for k, v25 in v11 do
				if not v22 or v25 ~= GamesFilter.GroupGames then
					table.insert(result, { value = v25, label = v24[v25] })
				end
			end

			return result
		else
			local v24 = {
				{ value = "All", label = all },
				{ value = "MyGames", label = myGames }
			}

			if not v22 then
				table.insert(v24, { value = "GroupGames", label = groupGames })
			end

			table.insert(v24, { value = "SharedGames", label = sharedGames })
			return v24
		end
	end, { all, groupGames, v22, myGames, sharedGames, v11 })

	local groupId = state.groupId
	local v24 = React.useMemo(function()
		local result = {}

		if groups == nil then
			return result
		end

		for k, group in groups do
			if not matchesSearchQuery(group.name, state2) then
				continue
			end

			local v25 = {
				id = group.id,
				name = group.name,
				icon = 0,
				isSelected = 0,
				onActivated = 0
			}
			local id = group.id
			v25.icon = string.format("rbxthumb://type=GroupIcon&id=%d&w=150&h=150", id)
			v25.isSelected = group.id == groupId
			function v25.onActivated()
				v19(group.id)
			end

			table.insert(result, v25)
		end

		return result
	end, { state2, groups, v19, groupId })

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
			v14 = myGames
		elseif v7.games == "GroupGames" then
			v14 = groupGames
		elseif v7.games == "SharedGames" then
			v14 = sharedGames
		end
	else
		v14 = name
	end

	return {
		LayoutOrder = data.LayoutOrder,
		label = v14,
		onOpenSheet = v15,
		isSheetOpen = state3,
		onSheetClosed = v16,
		focusRootRef = v17,
		titleText = v13.title,
		gamesLegend = v13.games,
		gamesOptions = v23,
		selectedGames = state.games,
		onGamesChanged = v18,
		isGroupsVisible = state.games == "GroupGames" and groups ~= nil and #groups > 0,
		groupsLegend = v13.groups,
		groupSearchText = state2,
		groupSearchPlaceholder = v13.searchGroups,
		onGroupSearchTextChanged = setState2,
		groups = v24,
		applyText = v13.apply,
		resetText = v13.reset,
		onApply = v20,
		onReset = v21,
		testId = data.testId
	}
end

return useMyCreationsFilterViewModel
