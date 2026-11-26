local module = require("@luauforge/deferred/eil")
local module2 = require("@luauforge/deferred/eiE")

local module3 = require("@luauforge/deferred/eiY")
local module4 = require("@luauforge/deferred/eiI")
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization
local appPage = require("@luauforge/deferred/eio").AppPage
local module5 = require("@luauforge/deferred/eiN")

local screenSizeImpressionsTracker = require("@luauforge/deferred/elu").ScreenSizeImpressionsTracker

local useCollectionImpressionsSignal = require("@luauforge/deferred/ejW").useCollectionImpressionsSignal

local module6 = require("@luauforge/deferred/eiT")
local useSelectionCursor = module6.App.SelectionImage.useSelectionCursor
local cursorKind = module6.App.SelectionImage.CursorKind

local module7 = require("@luauforge/deferred/elv")
local module8 = require("@luauforge/deferred/elB")
local module9 = require("@luauforge/deferred/elC")

local module10 = require("@luauforge/deferred/eiu")
local useFireUserTileImpressionEvent = module10.useFireUserTileImpressionEvent
local useFireAnalyticsEvent = module10.useFireAnalyticsEvent
local eventNames = module10.EventNames
local namespaces = module10.Namespaces

local module11 = require("@luauforge/deferred/eka")
local userListLayoutAdaptor = module11.UserListLayoutAdaptor
local layoutMode = module11.Enums.LayoutMode

local useTokens = require("@luauforge/deferred/eiU").Hooks.useTokens

local module12 = require("@luauforge/deferred/elD")

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@luauforge/deferred/eiz").FFlagAddFriendsPageHighlightUnseenTrustedRequests
local fIntTrustedFriendRequestsPageSize = require("@luauforge/deferred/eiz").FIntTrustedFriendRequestsPageSize
local fIntInitialTrustedFriendRequestsPageSize = require("@luauforge/deferred/eiz").FIntInitialTrustedFriendRequestsPageSize
local dataStatus = require("@luauforge/deferred/eiI").DataStatus
require("@luauforge/deferred/elE")

local module13 = require("@luauforge/deferred/elI")

local v5 = module4.TrustedConnections.TrustedConnectionsStore.get()

local function TrustedFriendRequestsSection(p2)
	local sectionProps = p2.sectionProps
	local layoutOrder = sectionProps.LayoutOrder
	local v6

	if sectionProps.shouldFold then
		v6 = fIntInitialTrustedFriendRequestsPageSize
	else
		v6 = fIntTrustedFriendRequestsPageSize
	end

	local v8 = useSelectionCursor(cursorKind.Invisible)

	local v9 = useFireAnalyticsEvent()
	local v10 = module.useCallback(function()
		v5.loadMoreTrustedFriendRequests()
		v9(eventNames.ShowMoreBtnClick, { namespace = namespaces.TrustedFriendRequests })
	end, { v9 })

	local v11 = useLocalization({
		trustedFriendRequestsText = "Feature.AddFriends.Label.TrustedFriendRequests",
		showMoreButtonText = "Feature.Friends.Action.ViewMore"
	})

	local v12 = module.useMemo(function()
		return v5.getTrustedFriendRequests({
			forceFetch = fFlagAddFriendsPageHighlightUnseenTrustedRequests
		})
	end, {})
	local v13 = module3.useSignalState(v12.data)
	local v14 = module3.useSignalState(v12.status)
	local v15 = module.useMemo(function()
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return (if v13 then v13.requests else nil) or {}
		else
			local senderIds = if v13 then v13.senderIds else nil

			if senderIds then
				return module2.List.map(senderIds, function(p3)
					return { id = p3 }
				end)
			end

			return {}
		end
	end, { v13 })

	local v16 = module.useMemo(function()
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return v5.getTrustedFriendRequestsCount({ forceFetch = true })
		end

		return v5.getTrustedFriendRequestsCount()
	end, {})

	local v17 = module3.useSignalState(v16.data) or 0
	local v18 = module3.useSignalState(v16.status)

	module.useEffect(function()
		sectionProps.onLoadingChange(v14 == dataStatus.NotReady or v18 == dataStatus.NotReady)

		sectionProps.onCountChange(v17)
	end, { sectionProps, v17, v14, v18 })

	if not fFlagAddFriendsPageHighlightUnseenTrustedRequests then
		module.useEffect(function()
			v5.refetchTrustedFriendRequests()
			v5.refetchTrustedFriendRequestsCount()
		end, {})
	end

	module.useEffect(function()
		if not sectionProps.refreshSignal then
			return
		end

		local refreshSignalConnection = sectionProps.refreshSignal:connect(function()
			v5.refetchTrustedFriendRequests()
			v5.refetchTrustedFriendRequestsCount()
		end)
		return function()
			refreshSignalConnection:disconnect()
		end
	end, { sectionProps })

	local v19, v20, v21 = module9(v6, fIntTrustedFriendRequestsPageSize, 1, v10)

	local v22 = module.useCallback(function(p3, p4, p5)
		return module.createElement(module13, {
			entity = p4,
			createRow = p3,
			position = p5,
			selected = p5 == v21,
			impressionsTag = "ADDFRIENDSPAGE_TRUSTEDFRIEND_REQUESTS_TILE_IMPRESSIONS"
		})
	end, { v21 })
	local v23 = v17 > 0
	local v24

	if v23 then
		if module12.FRIEND_REQUESTS_DISPLAY_LIMIT <= v17 then
			v24 = ` ({module12.FRIEND_REQUESTS_DISPLAY_LIMIT}+)`
		else
			v24 = ` ({v17})`
		end
	else
		v24 = ""
	end

	local v25 = v20 * 1 < v17

	local ref = module.useRef(nil)

	local ref2 = module.useRef(module5.Signal.new())
	local v26 = useCollectionImpressionsSignal(ref2.current)

	local v27 = useFireUserTileImpressionEvent(v15, 1, namespaces.TrustedFriendRequests)
	local v28 = module.useCallback(function()
		ref2.current:fire()
	end, { ref2 })

	local v29 = module8()

	local v30 = useTokens()
	local v31 = v30.Typography.LabelLarge.FontSize + v30.Padding.Large

	if sectionProps.hide or not v23 then
		return nil
	end

	local createElement = module.createElement
	local v33 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		SelectionImageObject = v8,
		LayoutOrder = layoutOrder,
		ref = ref,
		[module.Change.AbsolutePosition] = v28
	}
	local children = {
		IgnoreAllMenu = module.createElement(module7, {
			open = v29.isMenuOpen,
			closeMenu = v29.closeMenu,
			openPositionY = UDim.new(0, v31),
			anchorRef = v29.iconRef,
			isTrustedFriendRequest = true
		}),
		UserListLayoutAdaptor = 0,
		ScreenSizeImpressionsDetector = 0
	}

	local createElement2 = module.createElement
	local v35 = {
		layoutMode = layoutMode.Vertical,
		entities = v15,
		isScrollEnabled = false,
		initialRowCount = v20,
		hasMore = v25,
		onLoadMore = v19,
		renderRow = v22,
		configs = { showSubtitle = false, showUsernameAsContextualFallback = true },
		header = 0
	}
	local v36 = {
		title = v11.trustedFriendRequestsText .. v24,
		trailingIcon = 0,
		trailingIconRef = 0,
		onTrailingIconActivated = 0
	}
	local v37 = if v23 then v29.menuIcon else nil
	v36.trailingIcon = v37
	v36.trailingIconRef = v29.iconRef
	v36.onTrailingIconActivated = v29.onIconClick
	v35.header = v36
	children.UserListLayoutAdaptor = createElement2(userListLayoutAdaptor, v35)

	children.ScreenSizeImpressionsDetector = module.createElement(screenSizeImpressionsTracker, {
		parentRef = ref,
		pageContext = appPage.AddFriendsPage,
		impressionsTag = "ADDFRIENDSPAGE_TRUSTEDFRIEND_REQUESTS_TILE_IMPRESSIONS",
		sendImpressions = v27,
		scrollViewPositionChangedSignal = v26
	})
	return createElement("Frame", v33, children)
end

return TrustedFriendRequestsSection
