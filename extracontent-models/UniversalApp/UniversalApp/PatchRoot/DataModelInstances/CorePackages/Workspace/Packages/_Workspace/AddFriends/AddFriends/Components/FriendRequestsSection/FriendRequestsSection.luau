local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local RoactUtils = require(AddFriendsParent.RoactUtils)
local useDesignTokens = require(AddFriendsParent.Style).useDesignTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local Cryo = require(AddFriendsParent.Cryo)
local AppPage = require(AddFriendsParent.RobloxAppEnums).AppPage
local AppCommonLib = require(AddFriendsParent.AppCommonLib)
local ScreenSizeImpressionsTracker = require(AddFriendsParent.Impressions).ScreenSizeImpressionsTracker
local CollectionViews = require(AddFriendsParent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local UIBlox = require(AddFriendsParent.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ParentParent = script.Parent.Parent
local AddFriendsTile = require(ParentParent.AddFriendsTile)
local AddFriendsSectionHeaderFrame = require(ParentParent.AddFriendsSectionHeaderFrame)
local IgnoreAllFriendsRequestsMenu = require(ParentParent.IgnoreAllFriendsRequestsMenu)
local useControlIgnoreAllMenu = require(ParentParent.IgnoreAllFriendsRequestsMenu.useControlIgnoreAllMenu)
local FriendingOSAEducationSubtitle = require(ParentParent.FriendingOSAEducationSubtitle)
local AddFriendsSelector = require(AddFriendsParent.AddFriendsState).AddFriendsSelector
local useUserTileCollectionGridItemMetricsProps = require(ParentParent.SectionsUtils.useUserTileCollectionGridItemMetricsProps)
local useShowMore = require(ParentParent.SectionsUtils.useShowMore)
local Analytics = require(AddFriends.Analytics)
local useFireUserTileImpressionEvent = Analytics.useFireUserTileImpressionEvent
local Namespaces = Analytics.Namespaces
local UserList = require(AddFriendsParent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode
local useTokens = require(AddFriendsParent.Foundation).Hooks.useTokens
local useFriendingOSAEducationSubtitle = require(ParentParent.FriendingOSAEducationSubtitle.useFriendingOSAEducationSubtitle)
local FFlagAddFriendsRenderTileRefactor = require(AddFriendsParent.SharedFlags).FFlagAddFriendsRenderTileRefactor
local FFlagAddFriendsUserListEnabled = require(AddFriendsParent.SharedFlags).FFlagAddFriendsUserListEnabled
local FFlagConnectionsToFriendsRename = require(AddFriendsParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAddFriendsPageFriendRequestsLimitPlus = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPageFriendRequestsLimitPlus
local Constants = require(AddFriends.Common.Constants)

local function FriendRequestsSection(t1: {[any]: any}) -- line: 82
	-- upvalues: useDesignTokens (copy), useSelectionCursor (copy), CursorKind (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), useSelector (copy), AddFriendsSelector (copy), useUserTileCollectionGridItemMetricsProps (copy), FFlagAddFriendsUserListEnabled (copy), useShowMore (copy), React (copy), FFlagAddFriendsRenderTileRefactor (copy), AddFriendsTile (copy), FFlagAddFriendsPageFriendRequestsLimitPlus (copy), Constants (copy), AppCommonLib (copy), useCollectionImpressionsSignal (copy), useFireUserTileImpressionEvent (copy), Namespaces (copy), useControlIgnoreAllMenu (copy), useFriendingOSAEducationSubtitle (copy), useTokens (copy), IgnoreAllFriendsRequestsMenu (copy), UserListLayoutAdaptor (copy), LayoutMode (copy), ScreenSizeImpressionsTracker (copy), AppPage (copy), AddFriendsSectionHeaderFrame (copy), FriendingOSAEducationSubtitle (copy), CollectionGrid (copy), Cryo (copy), Button (copy), ButtonType (copy)
	local renderAddFriendsTile = t1.renderAddFriendsTile
	local friendRequests = t1.friendRequests
	local handleLoadMoreRequests = t1.handleLoadMoreRequests
	local initialRequestsRows = t1.initialRequestsRows
	local requestsPageSize = t1.requestsPageSize
	local v49 = useDesignTokens()
	local v50 = useSelectionCursor(CursorKind.Invisible)
	local v51 = useLocalization({
		showMoreButtonText = "Feature.Avatar.Action.ShowMore",
		friendRequestsText = not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Label.ConnectionRequests" or "Feature.AddFriends.Label.FriendRequests"
	})
	local v52 = useSelector(function(p1) -- line: 100
		-- upvalues: AddFriendsSelector (copy)
		return AddFriendsSelector(p1, "Friends.requests.receivedCount")
	end)
	local v53, v54 = useUserTileCollectionGridItemMetricsProps()
	local v55 = if not FFlagAddFriendsUserListEnabled then v53.numColumns else 1
	local v56, v57, v58 = useShowMore(initialRequestsRows, requestsPageSize, v55, handleLoadMoreRequests)
	local v59 = React.useCallback(function(p2, p3) -- line: 110
		-- upvalues: FFlagAddFriendsRenderTileRefactor (copy), React (copy), AddFriendsTile (copy), v54 (copy), v53 (copy), v58 (copy), renderAddFriendsTile (copy)
		if FFlagAddFriendsRenderTileRefactor then
			local v78 = tostring(p3) .. " "

			return React.createElement(AddFriendsTile, {
				isFriendRequest = true,
				impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
				layoutOrder = p3,
				position = p3,
				user = p2,
				size = Vector2.new(v54.itemWidth, v53.getItemHeight(v54.itemWidth)),
				selected = p3 == v58
			}), v78
		end

		return renderAddFriendsTile(p2, v54.itemWidth, v53.getItemHeight(v54.itemWidth), p3, v58, "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS"), tostring(p3) .. " "
	end, {
		v54,
		v53,
		v58
	})
	local v60 = if not FFlagAddFriendsUserListEnabled then nil else React.useCallback(function(p4, p5, p6) -- line: 145
		-- upvalues: React (copy), AddFriendsTile (copy), v58 (copy)
		return React.createElement(AddFriendsTile, {
			isFriendRequest = true,
			impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
			user = p5,
			createRow = p4,
			position = p6,
			selected = p6 == v58
		})
	end, { v58 })
	local v61 = v52 > 0
	local v62 = if not FFlagAddFriendsPageFriendRequestsLimitPlus then v61 and ` ({ v52 })` or "" else not v61 and "" or if not (v52 >= Constants.FRIEND_REQUESTS_DISPLAY_LIMIT) then ` ({ v52 })` else ` ({ Constants.FRIEND_REQUESTS_DISPLAY_LIMIT }+)`
	local v63 = v52 > v57 * v55
	local v64 = v49.LuaApps.FriendsLanding.ShowMore.ButtonWidth or 640
	local v65 = v49.LuaApps.FriendsLanding.ShowMore.ButtonHeight or 50
	local v66 = React.useRef(nil)
	local v67 = React.useRef(AppCommonLib.Signal.new())
	local v68 = useCollectionImpressionsSignal(v67.current)
	local v69 = useFireUserTileImpressionEvent(friendRequests, if not FFlagAddFriendsUserListEnabled then v54.itemsPerRow else v55, Namespaces.FriendRequests)
	local v70 = React.useCallback(function() -- line: 184
		-- upvalues: v67 (copy)
		v67.current:fire()
	end, { v67 })
	local v71 = useControlIgnoreAllMenu()
	local v72 = if not FFlagAddFriendsUserListEnabled then nil else useFriendingOSAEducationSubtitle()
	local v73 = if not FFlagAddFriendsUserListEnabled then nil else useTokens()
	local v74 = if not FFlagAddFriendsUserListEnabled then nil else v73.Typography.LabelLarge.FontSize + v73.Padding.Large

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		SelectionImageObject = v50,
		LayoutOrder = t1.LayoutOrder,
		ref = v66,
		[React.Change.AbsolutePosition] = v70
	}, if not FFlagAddFriendsUserListEnabled then {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		HeaderFrame = v61 and React.createElement(AddFriendsSectionHeaderFrame, {
			layoutOrder = 1,
			title = v51.friendRequestsText .. v62,
			icon = v71.menuIcon,
			iconVisible = v61,
			onIconActivated = v71.onIconClick
		}),
		IgnoreAllMenu = React.createElement(IgnoreAllFriendsRequestsMenu, {
			open = v71.isMenuOpen,
			closeMenu = v71.closeMenu
		}),
		FriendingOSAEducationSubtitle = React.createElement(FriendingOSAEducationSubtitle, {
			layoutOrder = 3
		}),
		FriendRequestsCollectionGrid = React.createElement(CollectionGrid, Cryo.Dictionary.join(v53, {
			LayoutOrder = 4,
			onViewableItemsChanged = nil,
			items = friendRequests,
			renderItem = v59,
			maxNumRows = v57
		})),
		ShowMoreButtonFrame = v63 and React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 10)
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v64, 1e999)
			}),
			ShowMoreButton = React.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.new(1, 0, 0, v65),
				onActivated = v56,
				text = v51.showMoreButtonText
			})
		}),
		ScreenSizeImpressionsDetector = React.createElement(ScreenSizeImpressionsTracker, {
			impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
			parentRef = v66,
			pageContext = AppPage.AddFriendsPage,
			sendImpressions = v69,
			scrollViewPositionChangedSignal = v68
		})
	} else {
		IgnoreAllMenu = React.createElement(IgnoreAllFriendsRequestsMenu, {
			open = v71.isMenuOpen,
			closeMenu = v71.closeMenu,
			openPositionY = UDim.new(0, v74)
		}),
		UserListLayoutAdaptor = React.createElement(UserListLayoutAdaptor, {
			isScrollEnabled = false,
			layoutMode = LayoutMode.Vertical,
			entities = friendRequests,
			initialRowCount = v57,
			hasMore = v63,
			onLoadMore = v56,
			renderRow = v60,
			header = {
				title = v51.friendRequestsText .. v62,
				subtitle = v72,
				trailingIcon = if not v61 then nil else v71.menuIcon,
				onTrailingIconActivated = v71.onIconClick
			}
		}),
		ScreenSizeImpressionsDetector = React.createElement(ScreenSizeImpressionsTracker, {
			impressionsTag = "ADDFRIENDSPAGE_REQUESTS_TILE_IMPRESSIONS",
			parentRef = v66,
			pageContext = AppPage.AddFriendsPage,
			sendImpressions = v69,
			scrollViewPositionChangedSignal = v68
		})
	})
end

return FriendRequestsSection
