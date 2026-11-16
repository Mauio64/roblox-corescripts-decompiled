local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/efZ")

local module3 = require("@luauforge/deferred/ega")
local module4 = require("@luauforge/deferred/efh")
local useNavigation = require("@luauforge/deferred/eeQ").useNavigation
local useDesignTokens = require("@luauforge/deferred/eeS").useDesignTokens
local useAnimatedScrollToSelection = require("@luauforge/deferred/efV").useAnimatedScrollToSelection
local module5 = require("@luauforge/deferred/egb")
local module6 = require("@luauforge/deferred/egc")
local module7 = require("@luauforge/deferred/efV")
local module8 = require("@luauforge/deferred/egd")
local module9 = require("@luauforge/deferred/ege")
local module10 = require("@luauforge/deferred/eeR")
local module11 = require("@luauforge/deferred/eeZ")
local module12 = require("@luauforge/deferred/egf")
local module13 = require("@luauforge/deferred/egg")
local userSearchBarButton = require("@luauforge/deferred/egh").Components.UserSearchBar.UserSearchBarButton
local useSignalState = require("@luauforge/deferred/egi").useSignalState
local module14 = require("@luauforge/deferred/egj")

local addFriendsSelector = require("@luauforge/deferred/efj").AddFriendsSelector

local module15 = require("@luauforge/deferred/egk")
local module16 = require("@luauforge/deferred/egn")
local module17 = require("@luauforge/deferred/egq")
local module18 = require("@luauforge/deferred/egy")
local module19 = require("@luauforge/deferred/ehY")
local module20 = require("@luauforge/deferred/eiG")
local module21 = require("@luauforge/deferred/eiU")
local module22 = require("@luauforge/deferred/eiZ")
local module23 = require("@luauforge/deferred/eij")
local module24 = require("@luauforge/deferred/eje")
local module25 = require("@luauforge/deferred/ejf")
local RelationshipTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/RelationshipTypes")

local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum
local useLastInputMode = module5.useLastInputMode
local useScreenSize = module7.useScreenSize
local useSelector = module4.Hooks.RoactRodux.useSelector
local appPage = module10.AppPage
local sources = module11.Analytics.Enums.Sources
local refreshScrollingFrame = module13.SocialLibraries.config({}).Components.RefreshScrollingFrame

local getPageMargin = module8.App.Container.getPageMargin
local verticalScrollViewWithMargin = module8.App.Container.VerticalScrollViewWithMargin
local useTokens = module9.Hooks.useTokens

local fFlagCreateConnectionsHub = require("@luauforge/deferred/efc").FFlagCreateConnectionsHub

local fFlagAppThemeHalloween2026FriendsBackground = require("@luauforge/deferred/efc").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@luauforge/deferred/ejg").useThemeBackground

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled
local fFlagExtendScrollingFramesBySafeInsets = require("@luauforge/deferred/efc").FFlagExtendScrollingFramesBySafeInsets
local fFlagAFPConnectionsChannelsHeader = require("@luauforge/deferred/efc").FFlagAFPConnectionsChannelsHeader

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@luauforge/deferred/efc").FFlagAddFriendsPageTrustedFriendRequestSection

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@luauforge/deferred/efc").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local module27 = require("@luauforge/deferred/eiO")

local function AddFriendsSectionsEmptyView(p2)
	return module.createElement(module15, { layoutOrder = p2.LayoutOrder })
end

local function AddFriendsPage(props)
	local ref = module.useRef(module2.Signal.new())

	local v5 = if fFlagAddFriendsPageHighlightUnseenTrustedRequests then module24() else nil

	local v6 = module.useCallback(function()
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and module27 then
			v5()
		end

		ref.current:fire()

		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and not module27 then
			v5()
		end

		return props.refreshPage()
	end, { props.refreshPage, v5 })

	local v7 = module.useMemo(function()
		local v8 = {}

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			table.insert(v8, { component = module19 })
		end

		table.insert(v8, {
			component = module20,
			analyticsKey = RelationshipTypes.FriendRequests
		})

		table.insert(v8, {
			component = module21,
			analyticsKey = RelationshipTypes.FriendRecommendations
		})

		return v8
	end, {})

	local v8 = useScreenSize()
	local v9 = useNavigation()

	local v10 = useLastInputMode()
	local v11 = v10 == "Focus"
	local v12 = v10 == "Cursor"
	local flag, flag2

	if fFlagCreateConnectionsHub and v9.state.routeName == appPage.CoHubAddConnections then
		flag = false
		flag2 = false
	else
		flag = true
		flag2 = true
	end

	local v13 = module.useCallback(function(object)
		object:cancel()

		v9.navigate(appPage.UserSearch, { shouldShowUserSearchLandingPage = true })
		props.fireSearchbarPressedEvent()
	end, { v9, props.fireSearchbarPressedEvent, props.navigateToLuaAppPages, flag })

	local v14 = module12.onRelease(v13)

	local v15 = module6.useEventHandler(focusNavigationEventNameEnum.Search, v14)

	local v16 = useDesignTokens()
	local v17 = useTokens()

	local v18 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local scrollAnimationConfig = v16.LuaApps.App.Page.ScrollAnimationConfig

	local v19, v20 = useAnimatedScrollToSelection(
		Enum.ScrollingDirection.Y,
		0,
		v16.Size.Size_1200,
		scrollAnimationConfig
	)

	if not v11 then
		v19 = nil
	end

	if not v11 then
		v20 = nil
	end

	local size_1200 = v16.Size.Size_1200

	local v21 = useSelector(function(p2)
		return addFriendsSelector(p2, "Friends.requests.receivedCount")
	end)

	local v22 = module.useCallback(function()
		v9.navigate(appPage.UserSearch, {
			shouldShowUserSearchLandingPage = true,
			entryPoint = sources.AddFriendsPage
		})

		props.fireSearchbarPressedEvent()
	end, { v9, props.fireSearchbarPressedEvent })

	local pagePaddingTop = v16.LuaApps.FriendsLanding.AddFriendsPage.PagePaddingTop or 0

	local pageMargin = getPageMargin(v8.X)
	local v23 = v21 > 0
	local v24 = if flag then -2 * size_1200 else -size_1200

	if fFlagExtendScrollingFramesBySafeInsets then
		v24 += useSignalState(module14.GetDisplayStore().getDeviceSafePadding).bottom
	end

	local createFragment = module3.createFragment
	local v25 = {
		pagePadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, pagePaddingTop)
		}),
		page = 0
	}

	local createElement = module.createElement
	local v27 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = v16.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = v18 and 1 or v16.LuaApps.App.Page.BackgroundTransparency,
		ref = v15
	}

	local createElement2 = module.createElement
	local v30 = {
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = 1,
		BackgroundTransparency = 1
	}

	local createElement3 = module.createElement
	local v33 = {
		ScrollingElement = verticalScrollViewWithMargin,
		scrollingElementProps = {
			size = UDim2.new(1, 0, 1, v24),
			useAutomaticCanvasSize = true,
			canvasSizeY = UDim.new(1, 1),
			paddingHorizontal = pageMargin,
			Selectable = fFlagAddFriendsUserListEnabled and true or false,
			onSelectionChanged = v20,
			CanvasPosition = v19,
			ScrollingEnabled = v12
		},
		refresh = v6,
		usesBuilderIcon = true
	}

	local v34 = if fFlagAddFriendsUserListEnabled then module.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(640, 1e999)
	}) else nil
	local children = {
		UISizeConstraint = v34,
		layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v16.Size.Size_300)
		}),
		UIPadding = 0,
		TrustedContactsEducationBanner = 0,
		ConnectionChannelsSection = 0,
		sections = 0,
		BottomWhitespace = 0
	}

	local createElement4 = module.createElement

	local v37 = if fFlagCreateConnectionsHub then UDim.new(0, v17.Padding.XLarge) else UDim.new(0, 8)
	children.UIPadding = createElement4("UIPadding", { PaddingTop = v37 })

	children.TrustedContactsEducationBanner = module.createElement(module17, {
		maxWidth = 640,
		layoutOrder = 1
	})

	children.ConnectionChannelsSection = module.createElement(module18, {
		layoutOrder = 2,
		navigateToLuaAppPages = props.navigateToLuaAppPages
	})

	children.sections = module.createElement(module23, {
		feedProps = { LayoutOrder = 3 },
		sections = v7,
		loadingView = module25,
		emptyView = AddFriendsSectionsEmptyView,
		refreshSignal = ref.current,
		onInitialLoadComplete = props.fireSectionsPageLoadEvents
	})

	local v38 = if not (v12 or not v23) then module.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 3000),
		BackgroundTransparency = 1,
		LayoutOrder = 1000
	}) else nil
	children.BottomWhitespace = v38
	v25.page = createElement("Frame", v27, {
		contentFrame = createElement2("Frame", v30, {
			ScrollView = createElement3(refreshScrollingFrame, v33, children)
		})
	})
	local fragment = createFragment(v25)

	local createElement5 = module.createElement
	local v40 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v16.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = v18 and 1 or v16.LuaApps.App.Page.BackgroundTransparency,
		BorderSizePixel = 0
	}

	local v41 = {
		[1] = nil,
		[1] = nil,
		nil,
		UIListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
	}

	local v42 = if flag2 then module3.createElement(module16, {
		topBarHeight = size_1200,
		layoutOrder = fFlagAFPConnectionsChannelsHeader and -2 or nil
	}) else nil
	v41.AddFriendsPageHeader = v42

	local v43 = if fFlagAFPConnectionsChannelsHeader then module.createElement(module22, {
		layoutOrder = -1
	}) else nil
	v41.FAEEligibleBanner = v43

	local v44 = if flag then module.createElement(userSearchBarButton, {
		onActivated = v22
	}) else nil
	v41.SearchbarButton = v44

	v41[1] = fragment
	return createElement5("Frame", v40, v41)
end

return AddFriendsPage
