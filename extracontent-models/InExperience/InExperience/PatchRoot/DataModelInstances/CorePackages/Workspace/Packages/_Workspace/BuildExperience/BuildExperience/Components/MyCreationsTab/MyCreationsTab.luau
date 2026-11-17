local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

game:GetService("AppLifecycleObserverService")
local Players = game:GetService("Players")

local FFlagBuildExperienceMyCreationsCreateGameButton = require(BuildExperience.Flags.FFlagBuildExperienceMyCreationsCreateGameButton)
local FFlagBuildExperienceMyCreationsLongPressMenu = require(BuildExperience.Flags.FFlagBuildExperienceMyCreationsLongPressMenu)
local FFlagBuildWithGroups = require(BuildExperience.Flags.FFlagBuildWithGroups)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local React = require(parent.React)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(parent.DataHydration.CreatorAgentChat)
require(parent.DataHydration.UniverseConfiguration)
require(parent.DataHydration.UniverseSearch)

local Button = Foundation.Button
local List = Foundation.List
local View = Foundation.View
local refreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local ListItemInputType = Foundation.Enums.ListItemInputType
local testId = FFlagBuildExperienceMyCreationsLongPressMenu and "MyCreationsTab.NewGameRow" or nil
local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local SearchEmptyState = require(BuildExperience.Components.SearchEmptyState.SearchEmptyState)

local chatConstants = require(script.Parent.Parent.Parent.Chat.chatConstants)
require(script.Parent.Parent.Parent.Chat.chatTypes)

local GetMyCreationsFilterStore = require(script.Parent.Parent.Parent.Stores.GetMyCreationsFilterStore)
local GetSearchQueryStore = require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore)
require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)
local useScrollPerformanceTracker = require(script.Parent.Parent.Parent.Telemetry.useScrollPerformanceTracker)
local ExperienceResultsList = require(script.Parent.ExperienceResultsList)
local ExperienceResultsLoadingSkeleton = require(script.Parent.ExperienceResultsLoadingSkeleton)
local MyCreationsFilterContainer = require(BuildExperience.Components.MyCreationsFilter.MyCreationsFilterContainer)
local useMyCreationsResults = require(script.Parent.useMyCreationsResults)

local function MyCreationsTab(props)
	local v = {
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
	local createNewGame2

	if FFlagBuildExperienceMyCreationsCreateGameButton then
		createNewGame2 = LocalizationStrings.MY_CREATIONS_CREATE_NEW_GAME
	end

	v.createNewGame = createNewGame2

	v.inputNeeded = LocalizationStrings.MY_CREATIONS_INPUT_NEEDED
	v.loadError = LocalizationStrings.MY_CREATIONS_LOAD_ERROR
	v.newGame = LocalizationStrings.MY_CREATIONS_NEW_GAME
	v.noGames = LocalizationStrings.MY_CREATIONS_NO_GAMES
	v.private = LocalizationStrings.MY_CREATIONS_PRIVATE
	v.public = LocalizationStrings.MY_CREATIONS_PUBLIC
	v.publiclyUnavailable = LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE
	v.ready = LocalizationStrings.MY_CREATIONS_READY
	v.restricted = LocalizationStrings.MY_CREATIONS_RESTRICTED
	local v2 = useLocalization(v)

	local buildWithAI = v2.buildWithAI
	local createNewGame = v2.createNewGame
	local loadError = v2.loadError
	local newGame = v2.newGame
	local noGames = v2.noGames
	local searchQueryStore = props.searchQueryStore or GetSearchQueryStore()
	local isFocused = props.isFocused ~= false
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	useScrollPerformanceTracker("LuaApp_Build_Home_Scroll", ref)

	local v3 = searchQueryStore.useShowEmptyState()
	local v4

	if FFlagBuildWithGroups or FFlagBuildExperienceMyCreationsCreateGameButton then
		v4 = searchQueryStore.useIsSearchActive()
	else
		v4 = false
	end

	local v5 = searchQueryStore.useDraftQuery()
	local filterStore

	if FFlagBuildWithGroups then
		filterStore = props.filterStore or GetMyCreationsFilterStore()
	end

	local filter

	if FFlagBuildWithGroups then
		filter = filterStore.useFilter()
	end

	local v6 = {
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

	if v4 then
		filter = nil
	end

	v6.filter = filter
	local v7 = useMyCreationsResults(v6)

	local displayedItems = v7.displayedItems
	local items = v7.items
	local hasPendingSummary = v7.hasPendingSummary
	local listStatus = v7.listStatus
	local hasDisplayedResult = v7.hasDisplayedResult
	local failedLoadMore = v7.failedLoadMore
	local retryLoadMore = v7.retryLoadMore
	local refresh = v7.refresh
	local loadMoreIfNeeded = v7.loadMoreIfNeeded

	local onActivated = React.useCallback(function(p)
		ref2.current = true
		local onOpenChat = props.onOpenChat
		local v8 = {
			experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
			isNewGameTarget = true,
			creatorName = 0
		}
		local creatorName

		if Players.LocalPlayer then
			creatorName = Players.LocalPlayer.Name
		end

		v8.creatorName = creatorName
		onOpenChat(
			v8,
			FFlagBuildExperienceEventContextTelemetry and (p == "auto_new_game" and "auto_new_game" or "new_game") or nil
		)
	end, { props.onOpenChat })
	local v8 = v7.hasCompletedFocusedRefresh

	if v8 then
		if v7.sessionListStatus == "Ready" and v7.sessionCount == 0 then
			v8 = v5 == ""
		else
			v8 = false
		end
	end

	React.useEffect(function()
		if props.autoOpenNewGame ~= false and isFocused and v8 and not ref2.current then
			onActivated(FFlagBuildExperienceEventContextTelemetry and "auto_new_game" or nil)
		end
	end, { v8, onActivated, isFocused, props.autoOpenNewGame })
	local none

	if FFlagBuildExperienceMyCreationsLongPressMenu and props.onOpenConfigurationPage ~= nil then
		none = ListItemInputType.None
	else
		none = nil
	end

	local createFooter = React.useCallback(function()
		if v7.isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "MyCreationsTab"
			})
		end

		return nil
	end, { v7.isLoadingMore })
	local leadingItems

	if not FFlagBuildExperienceMyCreationsCreateGameButton then
		leadingItems = React.useMemo(function()
			return {
				CreateRow = React.createElement(List.Item, {
					LayoutOrder = 1,
					leading = IconName.PlusLarge,
					title = newGame,
					description = buildWithAI,
					testId = testId,
					onActivated = onActivated,
					input = none
				})
			}
		end, { buildWithAI, onActivated, newGame, none })
	end

	local v9

	if v3 then
		v9 = {
			SearchEmptyState = React.createElement(SearchEmptyState, {
				testId = "MyCreationsTab.SearchEmptyState"
			})
		}
	elseif hasDisplayedResult and not hasPendingSummary and #displayedItems == 0 then
		v9 = { EmptyContent = 0 }
		local createElement = React.createElement
		local createList

		if not FFlagBuildExperienceMyCreationsCreateGameButton then
			createList = React.createElement(List.Root, {
				LayoutOrder = 1,
				hasDivider = false,
				isContained = { isContained = false, hasMargin = false },
				size = InputSize.Large
			}, {
				CreateRow = React.createElement(List.Item, {
					LayoutOrder = 1,
					leading = IconName.PlusLarge,
					title = newGame,
					description = buildWithAI,
					testId = testId,
					onActivated = onActivated,
					input = none
				})
			})
		end

		local createElement2 = React.createElement

		local createElement3 = React.createElement

		if not FFlagBuildWithGroups then
			noGames = nil
		end

		v9.EmptyContent = createElement(View, { tag = "col size-full" }, {
			CreateList = createList,
			EmptyState = createElement2(
				View,
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
		v9 = {
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
				leadingItems = leadingItems,
				firstResultLayoutOrder = 2,
				testIdPrefix = "MyCreationsTab"
			})
		}
	end

	local element = React.createElement(
		View,
		{
			tag = "composition-content-body col size-full-0 auto-y",
			testId = "MyCreationsTab.ContentBody"
		},
		v9
	)

	local element2 = React.createElement(refreshScrollingFrame, {
		refresh = refresh,
		ref = ref,
		onCanvasPositionChangedCallback = loadMoreIfNeeded,
		onCanvasSizeChangedCallback = loadMoreIfNeeded,
		createFooter = createFooter,
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
		ContentLayout = React.createElement(View, {
			tag = { ["composition-layout-detail"] = true, ["size-full-0 auto-y"] = true },
			testId = "MyCreationsTab.ContentLayout"
		}, { ContentBody = element })
	})
	local filter2

	if FFlagBuildWithGroups then
		filter2 = React.createElement(MyCreationsFilterContainer, {
			LayoutOrder = 0,
			filterStore = filterStore,
			creatorGroupsStore = props.creatorGroupsStore
		})
	end

	if FFlagBuildExperienceMyCreationsCreateGameButton then
		local element3 = React.createElement(
			View,
			{ tag = "composition-content-body col size-full-0 auto-y padding-y-medium" },
			{
				CreateGameButton = React.createElement(Button, {
					text = createNewGame,
					onActivated = onActivated,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					testId = "MyCreationsTab.CreateGameButton"
				})
			}
		)

		local createElement = React.createElement
		local v10 = { LayoutOrder = props.LayoutOrder, tag = "col fill size-full" }

		if v4 then
			filter2 = nil
		end

		local createGameFooter

		if not v4 then
			createGameFooter = React.createElement(View, {
				LayoutOrder = 2,
				tag = { ["composition-layout-detail"] = true, ["size-full-0 auto-y"] = true },
				testId = "MyCreationsTab.CreateGameLayout"
			}, { CreateGameBody = element3 })
		end

		return createElement(View, v10, {
			Filter = filter2,
			Results = element2,
			CreateGameFooter = createGameFooter
		})
	else
		if filter2 == nil then
			return element2
		end

		local createElement = React.createElement
		local v10 = { LayoutOrder = props.LayoutOrder, tag = "col fill size-full" }

		if v4 then
			filter2 = nil
		end

		return createElement(View, v10, { Filter = filter2, Results = element2 })
	end
end

return MyCreationsTab
