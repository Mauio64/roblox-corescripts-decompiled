local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local Roact = require(Parent.Roact)
local RoactUtils = require(Parent.RoactUtils)
local useNavigation = require(Parent.Navigation).useNavigation
local useDesignTokens = require(Parent.Style).useDesignTokens
local useAnimatedScrollToSelection = require(Parent.RobloxAppHooks).useAnimatedScrollToSelection
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local InputHandlers = require(Parent.InputHandlers)
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local UserSearchBarButton = require(Parent.SocialCommon).Components.UserSearchBar.UserSearchBarButton
local useSignalState = require(Parent.SignalsReact).useSignalState
local Display = require(Parent.Display)
local AddFriendsSelector = require(Parent.AddFriendsState).AddFriendsSelector
local ParentParent = script.Parent.Parent
local AddFriendsTile = require(ParentParent.AddFriendsTile)
local AddFriendsEmptyState = require(ParentParent.AddFriendsEmptyState)
local AddFriendsPageHeader = require(ParentParent.AddFriendsPageHeader)
local TrustedContactsEducationBanner = require(ParentParent.TrustedContactsEducationBanner)
local ConnectionChannelsSection = require(ParentParent.ConnectionChannelsSection)
local FriendRequestsSection = require(ParentParent.FriendRequestsSection)
local FriendRecommendationsSection = require(ParentParent.FriendRecommendationsSection)
local FAEEligibleBanner = require(ParentParent.FAEEligibleBanner)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AppPage = RobloxAppEnums.AppPage
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources
local RefreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame
local getPageMargin = UIBlox.App.Container.getPageMargin
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local useTokens = Foundation.Hooks.useTokens
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local UiMode = RobloxAppEnums.UiMode
local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub
local FFlagFixCohubUiBugs = require(Parent.SharedFlags).FFlagFixCohubUiBugs
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagAddFriendsRenderTileRefactor = require(Parent.SharedFlags).FFlagAddFriendsRenderTileRefactor
local FFlagAddFriendsUserListEnabled = require(Parent.SharedFlags).FFlagAddFriendsUserListEnabled
local FFlagExtendScrollingFramesBySafeInsets = require(Parent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagAFPConnectionsChannelsHeader = require(Parent.SharedFlags).FFlagAFPConnectionsChannelsHeader

local function AddFriendsPage(t1: {[any]: any}) -- line: 80
	-- upvalues: useScreenSize (copy), useNavigation (copy), useLastInputMode (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), React (copy), RobloxAppEnums (copy), InputHandlers (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), useDesignTokens (copy), FFlagFixCohubUiBugs (copy), useTokens (copy), useAnimatedScrollToSelection (copy), FFlagAddFriendsRenderTileRefactor (copy), AddFriendsTile (copy), useSelector (copy), AddFriendsSelector (copy), Sources (copy), getPageMargin (copy), AddFriendsEmptyState (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), Roact (copy), RefreshScrollingFrame (copy), VerticalScrollViewWithMargin (copy), FFlagAddFriendsUserListEnabled (copy), TrustedContactsEducationBanner (copy), ConnectionChannelsSection (copy), FriendRequestsSection (copy), FriendRecommendationsSection (copy), AddFriendsPageHeader (copy), FFlagAFPConnectionsChannelsHeader (copy), FAEEligibleBanner (copy), UserSearchBarButton (copy)
	local v51 = useScreenSize()
	local v52 = useNavigation()
	local v53 = useLastInputMode()
	local v54 = v53 == "Focus"
	local v55 = v53 == "Cursor"
	local v56 = useUiModeInfo()
	local v57 = v56 and v56.uiMode == UiMode.TenFoot
	local u58 = not v57 or FFlagEnableLeftNavOnConsole
	local v59 = not v57 or FFlagEnableLeftNavOnConsole

	if FFlagCreateConnectionsHub and v52.state.routeName == AppPage.CoHubAddConnections then
		v59 = false
		u58 = false
	end

	local v60 = React.useCallback(function(p1) -- line: 104
		-- upvalues: u58 (ref), v52 (copy), AppPage (copy), RobloxAppEnums (copy), t1 (copy)
		if not u58 then
			p1:cancel()
			v52.navigate(AppPage.SearchPage, {
				defaultSearchType = RobloxAppEnums.SearchTypes.Players
			})

			return
		end

		p1:cancel()
		v52.navigate(AppPage.UserSearch, {
			shouldShowUserSearchLandingPage = true
		})
		t1.fireSearchbarPressedEvent()
	end, {
		v52,
		t1.fireSearchbarPressedEvent,
		t1.navigateToLuaAppPages,
		u58
	})
	local v61 = InputHandlers.onRelease(v60)
	local v62 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.Search, v61)
	local v63 = useDesignTokens()
	local v64 = if not FFlagFixCohubUiBugs then nil else useTokens()
	local ScrollAnimationConfig = v63.LuaApps.App.Page.ScrollAnimationConfig
	local v66, v67 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, 0, v63.Size.Size_1200, ScrollAnimationConfig)

	if not v54 then
		v66 = nil
	end

	if not v54 then
		v67 = nil
	end

	local Size_1200 = v63.Size.Size_1200
	local v69 = if not FFlagAddFriendsRenderTileRefactor then React.useCallback(function(p2, p3, p4, p5, p6, s1: string?) -- line: 143
		-- upvalues: React (copy), AddFriendsTile (copy)
		return React.createElement(AddFriendsTile, {
			layoutOrder = p5,
			position = p5,
			user = p2,
			size = Vector2.new(p3, p4),
			isFriendRequest = not p2.isRecommendation,
			isRecommendation = p2.isRecommendation,
			selected = p5 == p6,
			impressionsTag = s1
		})
	end, {}) else nil
	local v70 = useSelector(function(p7) -- line: 161
		-- upvalues: AddFriendsSelector (copy)
		return AddFriendsSelector(p7, "Friends.requests.receivedCount")
	end)
	local v71 = React.useCallback(function() -- line: 165
		-- upvalues: v52 (copy), AppPage (copy), Sources (copy), t1 (copy)
		v52.navigate(AppPage.UserSearch, {
			shouldShowUserSearchLandingPage = true,
			entryPoint = Sources.AddFriendsPage
		})
		t1.fireSearchbarPressedEvent()
	end, {
		v52,
		t1.fireSearchbarPressedEvent
	})
	local v72 = v63.LuaApps.FriendsLanding.AddFriendsPage.PagePaddingTop or 0
	local SafeAreaMargin = v63.LuaApps.App.Page.SafeAreaMargin
	local v74 = if not (SafeAreaMargin.X > 0) or FFlagEnableLeftNavOnConsole then getPageMargin(v51.X) else SafeAreaMargin.X
	local v75 = t1.friendRecommendations and #t1.friendRecommendations or 0
	local v76 = v70 > 0
	local v77 = v75 > 0
	local v78 = v76 or v77
	local v79 = React.useMemo(function() -- line: 191
		-- upvalues: React (copy), AddFriendsEmptyState (copy)
		return React.createElement(AddFriendsEmptyState, {
			layoutOrder = 4
		})
	end, {})
	local v80 = if not u58 then -Size_1200 else Size_1200 * -2

	if FFlagExtendScrollingFramesBySafeInsets then
		v80 += useSignalState(Display.GetDisplayStore().getDeviceSafePadding).bottom
	end

	local v81 = Roact.createFragment({
		pagePadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v72)
		}),
		page = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v63.LuaApps.App.Page.BackgroundColor,
			BackgroundTransparency = v63.LuaApps.App.Page.BackgroundTransparency,
			ref = v62
		}, {
			contentFrame = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				ScrollView = React.createElement(RefreshScrollingFrame, {
					usesBuilderIcon = true,
					ScrollingElement = VerticalScrollViewWithMargin,
					scrollingElementProps = {
						size = UDim2.new(1, 0, 1, v80),
						useAutomaticCanvasSize = v77 or v76,
						canvasSizeY = UDim.new(1, 1),
						paddingHorizontal = v74,
						Selectable = not not FFlagAddFriendsUserListEnabled,
						onSelectionChanged = v67,
						CanvasPosition = v66,
						ScrollingEnabled = v55
					},
					refresh = t1.refreshPage
				}, {
					UISizeConstraint = if not FFlagAddFriendsUserListEnabled then nil else React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(640, 1e999)
					}),
					layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, v63.Size.Size_300)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = if not FFlagFixCohubUiBugs or not FFlagCreateConnectionsHub then UDim.new(0, 8) else UDim.new(0, v64.Padding.XLarge)
					}),
					TrustedContactsEducationBanner = React.createElement(TrustedContactsEducationBanner, {
						maxWidth = 640,
						layoutOrder = 1
					}),
					ConnectionChannelsSection = React.createElement(ConnectionChannelsSection, {
						layoutOrder = 2,
						navigateToLuaAppPages = t1.navigateToLuaAppPages
					}),
					requestSection = if not v76 then nil else React.createElement(FriendRequestsSection, {
						LayoutOrder = 4,
						renderAddFriendsTile = if not FFlagAddFriendsRenderTileRefactor then v69 else nil,
						initialRequestsRows = t1.initialRequestsRows,
						requestsPageSize = t1.requestsPageSize,
						handleLoadMoreRequests = t1.handleLoadMoreRequests,
						friendRequests = t1.friendRequests
					}),
					inbetweenUserGridsPadding = if not v76 then nil else React.createElement("Frame", {
						LayoutOrder = 5,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(0, v63.Size.Size_400)
					}),
					recommendationSection = if not v77 then nil else React.createElement(FriendRecommendationsSection, {
						LayoutOrder = 6,
						renderAddFriendsTile = if not FFlagAddFriendsRenderTileRefactor then v69 else nil,
						friendRecommendations = t1.friendRecommendations
					}),
					emptyView = if not not v78 then nil else v79,
					BottomWhitespace = if v55 or not v76 then nil else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1000,
						Size = UDim2.new(1, 0, 0, 3000)
					})
				})
			})
		})
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v63.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = v63.LuaApps.App.Page.BackgroundTransparency
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		AddFriendsPageHeader = if not v59 then nil else Roact.createElement(AddFriendsPageHeader, {
			topBarHeight = Size_1200,
			layoutOrder = if not FFlagAFPConnectionsChannelsHeader then nil else -2
		}),
		FAEEligibleBanner = if not FFlagAFPConnectionsChannelsHeader then nil else React.createElement(FAEEligibleBanner, {
			layoutOrder = -1
		}),
		SearchbarButton = if not u58 then nil else React.createElement(UserSearchBarButton, {
			onActivated = v71
		}),
		v81
	})
end

return AddFriendsPage
