game:GetService("AppLifecycleObserverService")
local Players = game:GetService("Players")

local FFlagBuildExperienceMyCreationsCreateGameButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMyCreationsCreateGameButton")
local FFlagBuildExperienceMyCreationsLongPressMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMyCreationsLongPressMenu")
local FFlagBuildWithGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildWithGroups")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LuaSocialLibrariesDeps")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseSearch")

local button = Foundation.Button
local list = Foundation.List
local view = Foundation.View
local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local listItemInputType = Foundation.Enums.ListItemInputType
local v5 = FFlagBuildExperienceMyCreationsLongPressMenu and "MyCreationsTab.NewGameRow" or nil
local BuildEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildEmptyState/BuildEmptyState")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchEmptyState/SearchEmptyState")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local GetMyCreationsFilterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore")
local GetSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")
local ExperienceResultsList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsList")
local ExperienceResultsLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsLoadingSkeleton")
local MyCreationsFilterContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/MyCreationsFilterContainer")
local useMyCreationsResults = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/useMyCreationsResults")

local function MyCreationsTab(props)
	local v7 = {
		building = LocalizationStrings.MY_CREATIONS_BUILDING,
		buildWithAI = LocalizationStrings.MY_CREATIONS_BUILD_WITH_AI,
		createNewGame = 0,
		inputNeeded = 0,
		loadError = 0,
		newGame = 0,
		noGames = 0,
		private = 0,
		public = 0,
		publiclyUnavailable = 0,
		ready = 0,
		restricted = 0
	}

	local v8 = if FFlagBuildExperienceMyCreationsCreateGameButton then LocalizationStrings.MY_CREATIONS_CREATE_NEW_GAME else nil
	v7.createNewGame = v8

	v7.inputNeeded = LocalizationStrings.MY_CREATIONS_INPUT_NEEDED
	v7.loadError = LocalizationStrings.MY_CREATIONS_LOAD_ERROR
	v7.newGame = LocalizationStrings.MY_CREATIONS_NEW_GAME
	v7.noGames = LocalizationStrings.MY_CREATIONS_NO_GAMES
	v7.private = LocalizationStrings.MY_CREATIONS_PRIVATE
	v7.public = LocalizationStrings.MY_CREATIONS_PUBLIC
	v7.publiclyUnavailable = LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE
	v7.ready = LocalizationStrings.MY_CREATIONS_READY
	v7.restricted = LocalizationStrings.MY_CREATIONS_RESTRICTED
	local v9 = useLocalization(v7)

	local buildWithAI = v9.buildWithAI
	local createNewGame = v9.createNewGame
	local loadError = v9.loadError
	local newGame = v9.newGame
	local noGames = v9.noGames
	local searchQueryStore = props.searchQueryStore or GetSearchQueryStore()
	local isFocused = props.isFocused ~= false
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	useScrollPerformanceTracker("LuaApp_Build_Home_Scroll", ref)

	local v10 = searchQueryStore.useShowEmptyState()

	local v11 = if FFlagBuildWithGroups or FFlagBuildExperienceMyCreationsCreateGameButton then searchQueryStore.useIsSearchActive() else false

	local v12 = searchQueryStore.useDraftQuery()
	local filterStore = if FFlagBuildWithGroups then props.filterStore or GetMyCreationsFilterStore() else nil

	local v13 = if FFlagBuildWithGroups then filterStore.useFilter() else nil

	local v15 = {
		creatorAgentChatStore = props.creatorAgentChatStore,
		creatorGroupsStore = props.creatorGroupsStore,
		configurationStore = props.configurationStore,
		searchStore = props.searchStore,
		searchQueryStore = searchQueryStore,
		appLifecycleObserverService = props.appLifecycleObserverService,
		isFocused = isFocused,
		pollingIntervalSeconds = props.pollingIntervalSeconds,
		userId = props.userId,
		filter = 0
	}

	if v11 then
		v13 = nil
	end

	v15.filter = v13
	local v16 = useMyCreationsResults(v15)

	local displayedItems = v16.displayedItems
	local items = v16.items
	local hasPendingSummary = v16.hasPendingSummary
	local listStatus = v16.listStatus
	local hasDisplayedResult = v16.hasDisplayedResult
	local failedLoadMore = v16.failedLoadMore
	local retryLoadMore = v16.retryLoadMore
	local refresh = v16.refresh
	local loadMoreIfNeeded = v16.loadMoreIfNeeded

	local v17 = React.useCallback(function()
		ref2.current = true
		local onOpenChat = props.onOpenChat
		local v18 = {
			experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
			isNewGameTarget = true,
			creatorName = 0
		}

		local v19 = if Players.LocalPlayer then Players.LocalPlayer.Name else nil
		v18.creatorName = v19
		onOpenChat(v18)
	end, { props.onOpenChat })
	local v18 = v16.hasCompletedFocusedRefresh

	if v18 then
		v18 = v16.sessionListStatus == "Ready" and v16.sessionCount == 0 and v12 == ""
	end

	React.useEffect(function()
		if props.autoOpenNewGame ~= false and isFocused and v18 and not ref2.current then
			v17()
		end
	end, { v18, v17, isFocused, props.autoOpenNewGame })

	local none = if FFlagBuildExperienceMyCreationsLongPressMenu and props.onOpenConfigurationPage ~= nil then listItemInputType.None else nil

	local v19 = React.useCallback(function()
		if v16.isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "MyCreationsTab"
			})
		end

		return nil
	end, { v16.isLoadingMore })
	local v20

	if not FFlagBuildExperienceMyCreationsCreateGameButton then
		v20 = React.useMemo(function()
			return {
				CreateRow = React.createElement(list.Item, {
					LayoutOrder = 1,
					leading = iconName.PlusLarge,
					title = newGame,
					description = buildWithAI,
					testId = v5,
					onActivated = v17,
					input = none
				})
			}
		end, { buildWithAI, v17, newGame, none })
	end

	local v21

	if v10 then
		v21 = {
			SearchEmptyState = React.createElement(module10, {
				testId = "MyCreationsTab.SearchEmptyState"
			})
		}
	elseif hasDisplayedResult and not hasPendingSummary and #displayedItems == 0 then
		v21 = { EmptyContent = 0 }
		local createElement = React.createElement

		local v25 = if not FFlagBuildExperienceMyCreationsCreateGameButton then React.createElement(list.Root, {
			LayoutOrder = 1,
			hasDivider = false,
			isContained = { isContained = false, hasMargin = false },
			size = inputSize.Large
		}, {
			CreateRow = React.createElement(list.Item, {
				LayoutOrder = 1,
				leading = iconName.PlusLarge,
				title = newGame,
				description = buildWithAI,
				testId = v5,
				onActivated = v17,
				input = none
			})
		}) else nil

		local createElement2 = React.createElement

		local createElement3 = React.createElement

		if not FFlagBuildWithGroups then
			noGames = nil
		end

		v21.EmptyContent = createElement(view, { tag = "col size-full" }, {
			CreateList = v25,
			EmptyState = createElement2(
				view,
				{
					LayoutOrder = 2,
					tag = "col align-x-center align-y-center fill size-full-0 padding-large",
					testId = "MyCreationsTab.Empty"
				},
				{
					Content = createElement3(BuildEmptyState, { message = noGames })
				}
			)
		})
	else
		v21 = {
			ExperienceList = React.createElement(ExperienceResultsList, {
				items = items,
				hasDisplayedItems = #displayedItems > 0,
				hasDisplayedResult = hasDisplayedResult,
				hasPendingSummary = hasPendingSummary,
				listStatus = listStatus,
				failedLoadMore = failedLoadMore,
				retryLoadMore = retryLoadMore,
				loadError = loadError,
				onOpenChat = props.onOpenChat,
				onOpenConfigurationPage = props.onOpenConfigurationPage,
				leadingItems = v20,
				firstResultLayoutOrder = 2,
				testIdPrefix = "MyCreationsTab"
			})
		}
	end

	local element = React.createElement(
		view,
		{
			tag = "composition-content-body col size-full-0 auto-y",
			testId = "MyCreationsTab.ContentBody"
		},
		v21
	)

	local element2 = React.createElement(refreshScrollingFrame, {
		refresh = refresh,
		ref = ref,
		onCanvasPositionChangedCallback = loadMoreIfNeeded,
		onCanvasSizeChangedCallback = loadMoreIfNeeded,
		createFooter = v19,
		usesBuilderIcon = true,
		scrollingElementProps = {
			LayoutOrder = (FFlagBuildExperienceMyCreationsCreateGameButton or FFlagBuildWithGroups) and 1 or props.LayoutOrder,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Tag] = "fill"
		}
	}, {
		ContentLayout = React.createElement(view, {
			tag = {
				["composition-layout-detail"] = true,
				["size-full-0 auto-y"] = true
			},
			testId = "MyCreationsTab.ContentLayout"
		}, { ContentBody = element })
	})
	local v25

	if FFlagBuildWithGroups then
		v25 = React.createElement(MyCreationsFilterContainer, {
			LayoutOrder = 0,
			filterStore = filterStore,
			creatorGroupsStore = props.creatorGroupsStore
		})
	end

	if FFlagBuildExperienceMyCreationsCreateGameButton then
		local element3 = React.createElement(
			view,
			{ tag = "composition-content-body col size-full-0 auto-y padding-y-medium" },
			{
				CreateGameButton = React.createElement(button, {
					text = createNewGame,
					onActivated = v17,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					width = UDim.new(1, 0),
					testId = "MyCreationsTab.CreateGameButton"
				})
			}
		)

		local createElement2 = React.createElement
		local v27 = { LayoutOrder = props.LayoutOrder, tag = "col fill size-full" }

		if v11 then
			v25 = nil
		end

		local v29 = if not v11 then React.createElement(view, {
			LayoutOrder = 2,
			tag = {
				["composition-layout-detail"] = true,
				["size-full-0 auto-y"] = true
			},
			testId = "MyCreationsTab.CreateGameLayout"
		}, { CreateGameBody = element3 }) else nil
		return createElement2(view, v27, {
			Filter = v25,
			Results = element2,
			CreateGameFooter = v29
		})
	else
		if v25 == nil then
			return element2
		end

		local createElement2 = React.createElement
		local v27 = { LayoutOrder = props.LayoutOrder, tag = "col fill size-full" }

		if v11 then
			v25 = nil
		end

		return createElement2(view, v27, { Filter = v25, Results = element2 })
	end
end

return MyCreationsTab
