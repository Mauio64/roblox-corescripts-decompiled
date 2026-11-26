local CorePackages = game:GetService("CorePackages")
local useCollectionImpressionsSignal = require("@luauforge/bundled/ehg").useCollectionImpressionsSignal
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local frameBoundsImpressionsTracker = require("@luauforge/bundled/egA").FrameBoundsImpressionsTracker
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local React = require(CorePackages.Packages.React)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appSessionService = RoactServiceTags.AppSessionService
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local getTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens
local variableItemWidthCarousel = require("@luauforge/bundled/iqM").VariableItemWidthCarousel
local module4 = require("@luauforge/bundled/cBc")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local modules = require("@luauforge/bundled/dtb").Modules
local searchPill = modules.Personalization.Search.SearchPill
local querySuggestionClicked = modules.Personalization.Analytics.querySuggestionClicked
local queryImpressionsEvent = modules.Personalization.Analytics.queryImpressionsEvent
local searchConstants = modules.Personalization.Search.SearchConstants

local module5 = require("@luauforge/bundled/fvZ")
local module6 = require("@luauforge/bundled/fxa")

local fIntSearchLandingPageSideMargin = modules.Personalization.Search.FIntSearchLandingPageSideMargin

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module4.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING

function LUAUFORGE_MODULE_GLOBALS_iqL_SearchPillCarousel(props)
	local v6 = useUserExperiment({ appUserLayers.SearchAutocompleteLayer }, function(p2)
		return p2[appUserLayers.SearchAutocompleteLayer] or {}
	end)
	local v7 = useDesignTokens()
	local v8 = useDispatch()
	local v9 = useRoactService(appEventIngestService)
	local v10 = useNavigation()
	local v11 = useRoactService(roactNetworking)
	local v12 = useRoactService(appSessionService)

	local v13 = useSelector(function(p2)
		return p2.AutocompleteSuggestions
	end)

	local v14 = useSelector(function(p2): boolean
		return p2.FormFactor == formFactor.COMPACT
	end)

	local entries = props.entries
	local trendingSearches = searchConstants.getSearchTokens(v7).searchLandingPage.trendingSearches
	local pillTextSize = trendingSearches.pillTextSize
	local pillVerticalPadding = trendingSearches.pillVerticalPadding
	local pillHorizontalPadding = trendingSearches.pillHorizontalPadding
	local pillFont = trendingSearches.pillFont
	local pillTextColor = trendingSearches.pillTextColor
	local pillBackgroundColor = trendingSearches.pillBackgroundColor
	local pillBackgroundTransparency = trendingSearches.pillBackgroundTransparency
	local columnGap = trendingSearches.columnGap
	local v15 = pillTextSize + pillVerticalPadding * 2
	local formatted = `SearchPillCarousel_{props.sortName}{props.sortIndex}`
	local ref = React.useRef(nil)

	local v16, v17 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local v18 = React.useCallback(function(p2, p3)
		return v8(module5(p2, p3))
	end, { v8 })

	local v19 = React.useCallback(function(p2)
		return v13[p2]
	end, { v13 })

	local v20 = React.useCallback(function(p2)
		if p2 then
			v8(module6.Fetch(v11, p2, v6, searchTypes.Auto))
		else
			warn("requestAutocompleteSuggestion called with nil keyword")
		end
	end, { v8, v11, v6 })

	local v21 = React.useCallback(function(p2, p3)
		v18(p2, {
			isAutocompleteSuggestion = true,
			allAutocompleteSuggestions = {},
			searchType = searchTypes.TopResults,
			isAvatarAutocompleteEnabled = false,
			navigation = v10,
			pageOwner = v10.state.routeName,
			sessionService = v12,
			eventIngest = v9
		})

		querySuggestionClicked(v9, props.pageContext, {
			pos = p3,
			sortPos = props.sortIndex,
			sortId = props.sortName,
			componentType = "Pill",
			queryText = p2
		})

		if not v19(p2) then
			v20(p2)
		end
	end, { v18, v10, v12, v9, v19, v20 })

	local v22 = React.useCallback(function(list)
		local v23 = {}
		local queries = {}

		for i, item in ipairs(list) do
			local entry = props.entries[item]

			if not entry then
				continue
			end

			table.insert(v23, item)
			table.insert(queries, entry.query)
		end

		local joined = table.concat(v23, ",")
		local joined2 = table.concat(queries, ",")
		queryImpressionsEvent(v9, props.pageContext, {
			absPositions = joined,
			queryTexts = joined2,
			sortPos = props.sortIndex,
			sortId = props.sortName,
			componentType = "Pill"
		})
	end, {
		queryImpressionsEvent,
		v9,
		props.pageContext,
		props.sortIndex,
		props.sortName,
		props.entries
	})

	local v23 = React.useCallback(function(p2)
		local entry = entries[p2]

		if entry then
			return getTextSize(entry.query, pillTextSize, pillFont, Vector2.new(1e999, pillTextSize), {
				addTemporaryPadding = false
			}).X + pillHorizontalPadding * 2
		end

		return 0
	end, { entries, pillTextSize, pillFont, pillHorizontalPadding })

	local v24 = React.useCallback(function(p2, p3)
		return React.createElement(searchPill, {
			layoutOrder = p3,
			text = p2.query,
			font = pillFont,
			textSize = pillTextSize,
			textColor = pillTextColor,
			verticalPadding = pillVerticalPadding,
			horizontalPadding = pillHorizontalPadding,
			backgroundColor = pillBackgroundColor,
			backgroundTransparency = pillBackgroundTransparency,
			onActivated = function()
				v21(p2.query, p3)
			end,
			impressionsTag = formatted,
			index = p3
		})
	end, {
		pillBackgroundColor,
		pillBackgroundTransparency,
		pillFont,
		pillHorizontalPadding,
		pillTextColor,
		pillTextSize,
		pillVerticalPadding,
		v21,
		formatted
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local v26 = { [1] = nil, (React.createElement(variableItemWidthCarousel, {
			title = props.headerText,
			hideHeaderButton = true,
			items = entries,
			renderItem = v24,
			itemPadding = columnGap,
			itemHeight = v15,
			sideMargin = if v14 then GAME_CAROUSEL_SIDE_COMPACT_PADDING else fIntSearchLandingPageSideMargin,
			scrollButtonsEnabled = true,
			scrollingFrameRef = ref,
			calculateItemWidth = v23,
			onCanvasPositionChanged = v17
		})) }

	local v30 = if v22 and formatted then React.createElement(frameBoundsImpressionsTracker, {
		parentRef = ref,
		pageContext = props.pageContext,
		impressionsTag = formatted,
		scrollViewPositionChangedSignal = v16,
		sendImpressions = v22
	}) else nil
	v26.ImpressionsTracker = v30
	return createElement(fragment, nil, v26)
end

return LUAUFORGE_MODULE_GLOBALS_iqL_SearchPillCarousel
