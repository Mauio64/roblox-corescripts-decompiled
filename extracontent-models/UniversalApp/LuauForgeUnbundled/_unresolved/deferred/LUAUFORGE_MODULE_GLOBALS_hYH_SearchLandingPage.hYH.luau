local CorePackages = game:GetService("CorePackages")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module = require("@luauforge/bundled/dzG")
local module2 = require("@luauforge/bundled/dDZ")
local useCollectionLayoutConfig = require("@luauforge/bundled/ehg").useCollectionLayoutConfig
local module3 = require("@luauforge/bundled/dCR")
local fetchStatusReducer = module3.FetchStatusReducer
local fetchStatusNamespace = module3.FetchStatusNamespace
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService

local useCurrentSquadId = require("@luauforge/deferred/hYG").useCurrentSquadId

local searchLandingPageSurface = require("@luauforge/bundled/cBc").SearchLandingPageSurface
local modules = require("@luauforge/bundled/dtb").Modules
local searchConstants = modules.Personalization.Search.SearchConstants
local searchLandingPageSession = modules.Personalization.Sessions.SearchLandingPageSession
local apiFetchSearchLandingPage = modules.LuaApp.Thunks.Search.ApiFetchSearchLandingPage

local module4 = require("@luauforge/bundled/hPX")
local module5 = require("@luauforge/deferred/hYI")

local module6 = require("@luauforge/deferred/hYJ")

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppLayoutParamsInContext

local searchLandingPage = appPage.SearchLandingPage

function LUAUFORGE_MODULE_GLOBALS_hYH_SearchLandingPage(props)
	local v5 = useDispatch()
	local v6 = useDesignTokens()
	local v7 = useCurrentSquadId()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(appSessionService)

	local searchTokens = searchConstants.getSearchTokens(v6)
	local scrollingFrameRef = props.scrollingFrameRef or React.useRef(nil)
	local state, v10

	if fFlagLuaAppLayoutParamsInContext then
		local setState
		state, setState = React.useState(nil)
		v10 = React.useCallback(function(current)
			scrollingFrameRef.current = current
			setState(current)
		end, {})
	end

	local v11 = useSelector(function(p2)
		return p2.Personalization.OrderedOmniItems[searchLandingPage] or nil
	end)

	local allItems = v11 and v11.allItems or {}

	local v12 = React.useCallback(function()
		module5(v9, true)

		if v7 == "" or v7 == nil then
			return v5(apiFetchSearchLandingPage(v8, searchLandingPageSession:Get()))
		end

		return v5(apiFetchSearchLandingPage(
			v8,
			searchLandingPageSession:Get(),
			searchLandingPageSurface.Party
		))
	end, { v5, v8, searchLandingPageSession, v7, v9 })

	local onAbsoluteContentSizeChanged = props.onAbsoluteContentSizeChanged

	local v13 = if fFlagLuaAppLayoutParamsInContext then useCollectionLayoutConfig(state) else nil

	local useSduiContextFromRoduxAndProcessConfigs = module2.useSduiContextFromRoduxAndProcessConfigs

	if not fFlagLuaAppLayoutParamsInContext then
		v13 = nil
	end

	local v15 = useSduiContextFromRoduxAndProcessConfigs(searchLandingPage, v13)

	local v16 = useSelector(function(p2)
		return p2.Personalization[fetchStatusReducer.key][fetchStatusNamespace.SearchLandingPage][searchLandingPageSession:Get()]
			or retrievalStatus.NotStarted
	end)

	if React.useMemo(function()
		if next(allItems) == nil then
			return v16
		end

		return retrievalStatus.Done
	end, { v16, allItems }) ~= retrievalStatus.Done then
		return React.createElement(module6, {
			Size = props.size,
			LayoutOrder = props.layoutOrder,
			onAbsoluteContentSizeChanged = onAbsoluteContentSizeChanged,
			topPadding = searchTokens.searchLandingPage.topPadding,
			bottomPadding = searchTokens.searchLandingPage.bottomPadding,
			isCompactView = props.isCompactView,
			defaultContainerSize = props.defaultContainerSize
		})
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v17 = {
		LayoutOrder = props.layoutOrder,
		Size = props.size or UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = props.position or UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = searchTokens.backgroundContainer.backgroundColor3,
		BackgroundTransparency = searchTokens.backgroundContainer.backgroundTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}

	local createElement2 = React.createElement
	local v20 = {
		pageContext = appPage.SearchLandingPage,
		refresh = v12,
		omniFeedItems = allItems,
		impressionsTag = "SEARCHLANDINGPAGE_FEEDITEM_IMPRESSIONS",
		scrollingFrameRef = 0,
		analyticsContext = 0,
		createEndOfScrollElement = false,
		topPadding = 0,
		bottomPadding = 0,
		onAbsoluteContentSizeChanged = 0,
		sduiContext = 0,
		scrollBarThickness = 0,
		defaultContainerSize = 0
	}

	if not fFlagLuaAppLayoutParamsInContext then
		v10 = scrollingFrameRef
	end

	v20.scrollingFrameRef = v10
	v20.analyticsContext = module.Constants.Context.ExperienceTile

	v20.topPadding = searchTokens.searchLandingPage.topPadding
	v20.bottomPadding = searchTokens.searchLandingPage.bottomPadding
	v20.onAbsoluteContentSizeChanged = onAbsoluteContentSizeChanged
	v20.sduiContext = v15

	v20.defaultContainerSize = props.defaultContainerSize
	return createElement(frame, v17, {
		SearchOmniAutocompleteFeedView = createElement2(module4, v20)
	})
end

return LUAUFORGE_MODULE_GLOBALS_hYH_SearchLandingPage
