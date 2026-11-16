local module = require("@luauforge/deferred/eeO")

local useDesignTokens = require("@luauforge/deferred/eeS").useDesignTokens
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization
local module2 = require("@luauforge/deferred/efi")
local appPage = require("@luauforge/deferred/eeR").AppPage
local module3 = require("@luauforge/deferred/efZ")

local module4 = require("@luauforge/deferred/eiI")

local module5 = require("@luauforge/deferred/egi")
local friendsRequestsStore = require("@luauforge/deferred/eig").FriendsRequestsStore
local dataStatus = require("@luauforge/deferred/efT").DataStatus
local module6 = require("@luauforge/deferred/eiM")

local screenSizeImpressionsTracker = require("@luauforge/deferred/eia").ScreenSizeImpressionsTracker

local module7 = require("@luauforge/deferred/egB")
local collectionGrid = module7.CollectionGrid
local useCollectionImpressionsSignal = module7.useCollectionImpressionsSignal

local module8 = require("@luauforge/deferred/egd")
local useSelectionCursor = module8.App.SelectionImage.useSelectionCursor
local cursorKind = module8.App.SelectionImage.CursorKind
local button = module8.App.Button.Button
local buttonType = module8.App.Button.Enum.ButtonType

local module9 = require("@luauforge/deferred/egD")
local module10 = require("@luauforge/deferred/eib")
local module11 = require("@luauforge/deferred/eih")
local module12 = require("@luauforge/deferred/eiP")

local module13 = require("@luauforge/deferred/eiT")
local module14 = require("@luauforge/deferred/eii")
require("@luauforge/deferred/eij")

local module15 = require("@luauforge/deferred/eeX")
local useFireUserTileImpressionEvent = module15.useFireUserTileImpressionEvent
local useFireAnalyticsEvent = module15.useFireAnalyticsEvent
local eventNames = module15.EventNames
local namespaces = module15.Namespaces
local module16 = require("@luauforge/deferred/efQ")

local module17 = require("@luauforge/deferred/egF")
local userListLayoutAdaptor = module17.UserListLayoutAdaptor
local layoutMode = module17.Enums.LayoutMode

local useTokens = require("@luauforge/deferred/ege").Hooks.useTokens

local module18 = require("@luauforge/deferred/eiS")

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@luauforge/deferred/efc").FFlagAddFriendsPageHighlightUnseenTrustedRequests
local fFlagAddFriendsSessionId = require("@luauforge/deferred/efc").FFlagAddFriendsSessionId

local module19 = require("@luauforge/deferred/eiO")

local module20 = require("@luauforge/deferred/efP")

local function FriendRequestsSection(p2)
	local sectionProps = p2.sectionProps
	local layoutOrder = sectionProps.LayoutOrder

	local v5 = module.useMemo(function()
		local getFriendsRequests = friendsRequestsStore.get().getFriendsRequests

		local v7 = if fFlagAddFriendsSessionId then module16.getSessionId() else nil
		return getFriendsRequests({ forceFetch = true, sessionId = v7 })
	end, {})
	local v6 = module.useMemo(function()
		return friendsRequestsStore.get().getFriendsRequestCount({ forceFetch = true })
	end, {})

	module6()

	local v7 = module5.useSignalState(v5.data)
	local v8 = module5.useSignalState(v5.status)
	local v9 = module5.useSignalState(v6.data)
	local v10 = module5.useSignalState(v6.status)

	local requests = v7 and v7.requests or {}

	local v11 = sectionProps.shouldFold and 10 or 25

	local v12 = useFireAnalyticsEvent()

	local v13 = module.useCallback(function()
		local fetchMoreFriendsRequests = friendsRequestsStore.get().fetchMoreFriendsRequests
		local v14 = if fFlagAddFriendsSessionId then module16.getSessionId() else nil
		fetchMoreFriendsRequests(v14)
		v12(eventNames.ShowMoreBtnClick, { namespace = namespaces.FriendRequests })
	end, { v12 })

	local v14 = v9 or 0

	module.useEffect(function()
		sectionProps.onLoadingChange(v8 == dataStatus.NotReady or v10 == dataStatus.NotReady)

		sectionProps.onCountChange(v14)
	end, { sectionProps, v14, v8, v10 })

	module.useEffect(function()
		if not sectionProps.refreshSignal then
			return
		end

		local refreshSignalConnection = sectionProps.refreshSignal:connect(function()
			if module19 and not fFlagAddFriendsPageHighlightUnseenTrustedRequests then
				friendsRequestsStore.get().clearNewFriendRequest()
			end

			local refetchFriendRequests = friendsRequestsStore.get().refetchFriendRequests
			local v15 = if fFlagAddFriendsSessionId then module16.getSessionId() else nil
			refetchFriendRequests(v15)
			friendsRequestsStore.get().refetchFriendRequestCount()

			if not (module19 or fFlagAddFriendsPageHighlightUnseenTrustedRequests) then
				friendsRequestsStore.get().clearNewFriendRequest()
			end
		end)
		return function()
			refreshSignalConnection:disconnect()
		end
	end, { sectionProps })

	if not fFlagAddFriendsPageHighlightUnseenTrustedRequests then
		module.useEffect(function()
			friendsRequestsStore.get().clearNewFriendRequestCount()

			return function()
				friendsRequestsStore.get().clearNewFriendRequest()
			end
		end, {})
	end

	local v15 = useDesignTokens()
	local v16 = useSelectionCursor(cursorKind.Invisible)

	local v17 = useLocalization({
		friendRequestsText = "Feature.AddFriends.Label.FriendRequests",
		showMoreButtonText = "Feature.Friends.Action.ViewMore"
	})

	local v18, v19 = module13()
	local v20 = fFlagAddFriendsUserListEnabled and 1 or v18.numColumns

	local v21, v22, v23 = module14(v11, 25, v20, v13)

	local v24 = module.useCallback(function(p3, p4)
		local v25 = tostring(p4) .. " "

		return module.createElement(module4, {
			entity = p3,
			createRow = nil,
			position = p4,
			layoutOrder = p4,
			size = Vector2.new(v19.itemWidth, v18.getItemHeight(v19.itemWidth)),
			selected = p4 == v23,
			impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS"
		}), v25
	end, { v19, v18, v23 })
	local v25

	if fFlagAddFriendsUserListEnabled then
		v25 = module.useCallback(function(p3, p4, p5)
			return module.createElement(module4, {
				entity = p4,
				createRow = p3,
				position = p5,
				selected = p5 == v23,
				impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS"
			})
		end, { v23 })
	end

	local v26 = v14 > 0
	local v27

	if v26 then
		if module20.FRIEND_REQUESTS_DISPLAY_LIMIT <= v14 then
			v27 = ` ({module20.FRIEND_REQUESTS_DISPLAY_LIMIT}+)`
		else
			v27 = ` ({v14})`
		end
	else
		v27 = ""
	end

	local v28 = v22 * v20 < v14 or #requests < v14

	local buttonWidth = v15.LuaApps.FriendsLanding.ShowMore.ButtonWidth or 640
	local buttonHeight = v15.LuaApps.FriendsLanding.ShowMore.ButtonHeight or 50

	local ref = module.useRef(nil)

	local ref2 = module.useRef(module3.Signal.new())

	local v29 = useCollectionImpressionsSignal(ref2.current)

	if not fFlagAddFriendsUserListEnabled then
		v20 = v19.itemsPerRow
	end

	local v31 = useFireUserTileImpressionEvent(requests, v20, namespaces.FriendRequests)

	local v32 = module.useCallback(function()
		ref2.current:fire()
	end, { ref2 })

	local v33 = module11()

	local v34 = if fFlagAddFriendsUserListEnabled then module18() else nil

	local v35 = if fFlagAddFriendsUserListEnabled then useTokens() else nil
	local v36

	if fFlagAddFriendsUserListEnabled then
		v36 = v35.Typography.LabelLarge.FontSize + v35.Padding.Large
	end

	if sectionProps.hide or not v26 then
		return nil
	end

	local createElement = module.createElement

	local v38 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		SelectionImageObject = v16,
		LayoutOrder = layoutOrder,
		ref = ref,
		[module.Change.AbsolutePosition] = v32
	}
	local children

	if fFlagAddFriendsUserListEnabled then
		children = {
			IgnoreAllMenu = module.createElement(module10, {
				open = v33.isMenuOpen,
				closeMenu = v33.closeMenu,
				openPositionY = UDim.new(0, v36),
				anchorRef = v33.iconRef
			}),
			UserListLayoutAdaptor = 0,
			ScreenSizeImpressionsDetector = 0
		}

		local createElement2 = module.createElement
		local v40 = {
			layoutMode = layoutMode.Vertical,
			entities = requests,
			isScrollEnabled = false,
			initialRowCount = v22,
			hasMore = v28,
			onLoadMore = v21,
			renderRow = v25,
			header = 0
		}

		local v41 = {
			title = v17.friendRequestsText .. v27,
			subtitle = v34,
			trailingIcon = 0,
			trailingIconRef = 0,
			onTrailingIconActivated = 0
		}

		local v42 = if v26 then v33.menuIcon else nil
		v41.trailingIcon = v42
		v41.trailingIconRef = v33.iconRef
		v41.onTrailingIconActivated = v33.onIconClick
		v40.header = v41
		children.UserListLayoutAdaptor = createElement2(userListLayoutAdaptor, v40)

		children.ScreenSizeImpressionsDetector = module.createElement(screenSizeImpressionsTracker, {
			parentRef = ref,
			pageContext = appPage.AddFriendsPage,
			impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
			sendImpressions = v31,
			scrollViewPositionChangedSignal = v29
		})
	else
		children = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			HeaderFrame = v26 and module.createElement(module9, {
				layoutOrder = 1,
				title = v17.friendRequestsText .. v27,
				icon = v33.menuIcon,
				iconVisible = v26,
				onIconActivated = v33.onIconClick,
				iconRef = v33.iconRef
			}),
			IgnoreAllMenu = module.createElement(module10, {
				open = v33.isMenuOpen,
				closeMenu = v33.closeMenu,
				anchorRef = v33.iconRef
			}),
			FriendingOSAEducationSubtitle = module.createElement(module12, {
				layoutOrder = 3
			}),
			FriendRequestsCollectionGrid = module.createElement(
				collectionGrid,
				module2.Dictionary.join(v18, {
					items = requests,
					renderItem = v24,
					maxNumRows = v22,
					LayoutOrder = 4,
					onViewableItemsChanged = nil
				})
			),
			ShowMoreButtonFrame = v28 and module.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 5
				},
				{
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2),
						PaddingTop = UDim.new(0, 10)
					}),
					UISizeConstraint = module.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(buttonWidth, 1e999)
					}),
					ShowMoreButton = module.createElement(button, {
						buttonType = buttonType.Secondary,
						size = UDim2.new(1, 0, 0, buttonHeight),
						onActivated = v21,
						text = v17.showMoreButtonText
					})
				}
			),
			ScreenSizeImpressionsDetector = module.createElement(screenSizeImpressionsTracker, {
				parentRef = ref,
				pageContext = appPage.AddFriendsPage,
				impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
				sendImpressions = v31,
				scrollViewPositionChangedSignal = v29
			})
		}
	end

	return createElement("Frame", v38, children)
end

return FriendRequestsSection
