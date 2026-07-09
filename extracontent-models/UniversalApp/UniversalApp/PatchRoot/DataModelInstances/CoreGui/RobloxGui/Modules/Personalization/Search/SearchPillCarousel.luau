local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local useCollectionImpressionsSignal = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionImpressionsSignal
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FrameBoundsImpressionsTracker = require(CorePackages.Workspace.Packages.Impressions).FrameBoundsImpressionsTracker
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local React = require(CorePackages.Packages.React)
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local VariableItemWidthCarousel = require(CorePackages.Workspace.Packages.VariableItemWidthCarousel).VariableItemWidthCarousel
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchPill = Modules.Personalization.Search.SearchPill
local querySuggestionClicked = Modules.Personalization.Analytics.querySuggestionClicked
local queryImpressionsEvent = Modules.Personalization.Analytics.queryImpressionsEvent
local SearchConstants = Modules.Personalization.Search.SearchConstants
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local ConfirmSearch = require(Modules2.LuaApp.Thunks.ConfirmSearch)
local FetchAutocompleteSuggestion = require(Modules2.LuaApp.Thunks.FetchAutocompleteSuggestion)
local FIntSearchLandingPageSideMargin = Modules.Personalization.Search.FIntSearchLandingPageSideMargin
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING

function SearchPillCarousel(t1: {[any]: any}) -- line: 59
	-- upvalues: AppUserLayers (copy), useUserExperiment (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), AppEventIngestService (copy), useNavigation (copy), RoactNetworking (copy), AppSessionService (copy), useSelector (copy), FormFactor (copy), SearchConstants (copy), React (copy), useCollectionImpressionsSignal (copy), ConfirmSearch (copy), FetchAutocompleteSuggestion (copy), SearchTypes (copy), querySuggestionClicked (copy), queryImpressionsEvent (copy), TextService (copy), SearchPill (copy), VariableItemWidthCarousel (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), FIntSearchLandingPageSideMargin (copy), FrameBoundsImpressionsTracker (copy)
	local t2 = { AppUserLayers.SearchAutocompleteLayer }
	local v34 = useUserExperiment(t2, function(p1) -- line: 63
		-- upvalues: AppUserLayers (copy)
		return p1[AppUserLayers.SearchAutocompleteLayer] or {}
	end)
	local v35 = useDesignTokens()
	local v36 = useDispatch()
	local v37 = useRoactService(AppEventIngestService)
	local v38 = useNavigation()
	local v39 = useRoactService(RoactNetworking)
	local v40 = useRoactService(AppSessionService)
	local v41 = useSelector(function(p2) -- line: 76
		return p2.AutocompleteSuggestions
	end)
	local v42 = useSelector(function(p3) -- line: 79
		-- upvalues: FormFactor (copy)
		return p3.FormFactor == FormFactor.COMPACT
	end)
	local entries = t1.entries
	local trendingSearches = SearchConstants.getSearchTokens(v35).searchLandingPage.trendingSearches
	local pillTextSize = trendingSearches.pillTextSize
	local pillVerticalPadding = trendingSearches.pillVerticalPadding
	local pillHorizontalPadding = trendingSearches.pillHorizontalPadding
	local pillFont = trendingSearches.pillFont
	local pillTextColor = trendingSearches.pillTextColor
	local pillBackgroundColor = trendingSearches.pillBackgroundColor
	local pillBackgroundTransparency = trendingSearches.pillBackgroundTransparency
	local columnGap = trendingSearches.columnGap
	local v53 = pillTextSize + pillVerticalPadding * 2
	local v54 = `SearchPillCarousel_{ t1.sortName }{ t1.sortIndex }`
	local v55 = React.useRef(nil)
	local v56, v57 = useCollectionImpressionsSignal(t1.scrollViewPositionChangedSignal)
	local v58 = React.useCallback(function(p4, p5) -- line: 102
		-- upvalues: v36 (copy), ConfirmSearch (copy)
		return v36(ConfirmSearch(p4, p5))
	end, { v36 })
	local v59 = React.useCallback(function(p6) -- line: 106
		-- upvalues: v41 (copy)
		return v41[p6]
	end, { v41 })
	local v60 = React.useCallback(function(s1: string?) -- line: 110
		-- upvalues: v36 (copy), FetchAutocompleteSuggestion (copy), v39 (copy), v34 (copy), SearchTypes (copy)
		if not s1 then
			warn("requestAutocompleteSuggestion called with nil keyword")

			return
		end

		v36(FetchAutocompleteSuggestion.Fetch(v39, s1, v34, SearchTypes.Auto))
	end, {
		v36,
		v39,
		v34
	})
	local v61 = React.useCallback(function(p7, p8) -- line: 118
		-- upvalues: SearchTypes (copy), v38 (copy), v40 (copy), v37 (copy), v58 (copy), querySuggestionClicked (copy), t1 (copy), v59 (copy), v60 (copy)
		local t3 = {
			isAutocompleteSuggestion = true,
			isAvatarAutocompleteEnabled = false,
			allAutocompleteSuggestions = {},
			searchType = SearchTypes.TopResults,
			navigation = v38,
			pageOwner = v38.state.routeName,
			sessionService = v40,
			eventIngest = v37
		}

		v58(p7, t3)
		querySuggestionClicked(v37, t1.pageContext, {
			componentType = "Pill",
			pos = p8,
			sortPos = t1.sortIndex,
			sortId = t1.sortName,
			queryText = p7
		})

		if not v59(p7) then
			v60(p7)
		end
	end, {
		v58,
		v38,
		v40,
		v37,
		v59,
		v60
	})
	local v62 = React.useCallback(function(p9) -- line: 153
		-- upvalues: t1 (copy), queryImpressionsEvent (copy), v37 (copy)
		local t4 = {}
		local t5 = {}

		for _, v in ipairs(p9) do
			local v80 = t1.entries[v]

			if v80 then
				table.insert(t4, v)
				table.insert(t5, v80.query)
			end
		end

		local v81 = table.concat(t4, ",")
		local v82 = table.concat(t5, ",")

		queryImpressionsEvent(v37, t1.pageContext, {
			componentType = "Pill",
			absPositions = v81,
			queryTexts = v82,
			sortPos = t1.sortIndex,
			sortId = t1.sortName
		})
	end, {
		queryImpressionsEvent,
		v37,
		t1.pageContext,
		t1.sortIndex,
		t1.sortName,
		t1.entries
	})
	local v63 = React.useCallback(function(p10) -- line: 178
		-- upvalues: entries (copy), TextService (copy), pillTextSize (copy), pillFont (copy), pillHorizontalPadding (copy)
		local v84 = entries[p10]

		if not v84 then
			return 0
		end

		return TextService:GetTextSize(v84.query, pillTextSize, pillFont, Vector2.new(1e999, pillTextSize)).X + pillHorizontalPadding * 2
	end, {
		entries,
		pillTextSize,
		pillFont,
		pillHorizontalPadding
	})
	local v64 = React.useCallback(function(p11, p12) -- line: 188
		-- upvalues: React (copy), SearchPill (copy), pillFont (copy), pillTextSize (copy), pillTextColor (copy), pillVerticalPadding (copy), pillHorizontalPadding (copy), pillBackgroundColor (copy), pillBackgroundTransparency (copy), v61 (copy), v54 (copy)
		return React.createElement(SearchPill, {
			layoutOrder = p12,
			text = p11.query,
			font = pillFont,
			textSize = pillTextSize,
			textColor = pillTextColor,
			verticalPadding = pillVerticalPadding,
			horizontalPadding = pillHorizontalPadding,
			backgroundColor = pillBackgroundColor,
			backgroundTransparency = pillBackgroundTransparency,
			onActivated = function() -- line: 199
				-- upvalues: v61 (copy), p11 (copy), p12 (copy)
				v61(p11.query, p12)
			end,
			impressionsTag = v54,
			index = p12
		})
	end, {
		pillBackgroundColor,
		pillBackgroundTransparency,
		pillFont,
		pillHorizontalPadding,
		pillTextColor,
		pillTextSize,
		pillVerticalPadding,
		v61,
		v54
	})

	return React.createElement(React.Fragment, nil, {
		React.createElement(VariableItemWidthCarousel, {
			hideHeaderButton = true,
			scrollButtonsEnabled = true,
			title = t1.headerText,
			items = entries,
			renderItem = v64,
			itemPadding = columnGap,
			itemHeight = v53,
			sideMargin = if not v42 then FIntSearchLandingPageSideMargin else GAME_CAROUSEL_SIDE_COMPACT_PADDING,
			scrollingFrameRef = v55,
			calculateItemWidth = v63,
			onCanvasPositionChanged = v57
		}),
		ImpressionsTracker = if not v62 or not v54 then nil else React.createElement(FrameBoundsImpressionsTracker, {
			parentRef = v55,
			pageContext = t1.pageContext,
			impressionsTag = v54,
			scrollViewPositionChangedSignal = v56,
			sendImpressions = v62
		})
	})
end

return SearchPillCarousel
