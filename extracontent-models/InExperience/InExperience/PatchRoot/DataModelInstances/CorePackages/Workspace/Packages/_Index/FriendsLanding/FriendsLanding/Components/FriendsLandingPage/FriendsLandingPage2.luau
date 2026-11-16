local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local parent = FriendsLanding.Parent
local React = require(parent.React)
local Roact = require(parent.Roact)
local uiBlox = dependencies.UIBlox
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks2.useScreenSize
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
require(parent.PlayerContextualMenu)
local RoactUtils = require(parent.RoactUtils)
local dependencyArray = RoactUtils.Hooks.dependencyArray
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local horizontalPageMargin = uiBlox.App.Container.HorizontalPageMargin
local getPageMargin = uiBlox.App.Container.getPageMargin

local SocialCommon = require(parent.SocialCommon)
local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString

local useFocusGuiObject = dependencies.useFocusGuiObject
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)

local refreshScrollingFrame = dependencies.SocialLibraries.Components.RefreshScrollingFrame

local gridMetrics = uiBlox.App.Grid.GridMetrics

local EnumScreens = require(FriendsLanding.EnumScreens)
local filterStates = require(FriendsLanding.Friends.filterStates)
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local Constants = require(FriendsLanding.Common.Constants)
local RobloxAppHooks3 = require(parent.RobloxAppHooks)
local useAnimatedScrollToSelection = RobloxAppHooks3.useAnimatedScrollToSelection
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Display = require(parent.Display)
local FocusNavigationUtils2 = require(parent.FocusNavigationUtils)
local useFocusOnMount = FocusNavigationUtils2.useFocusOnMount

local FilterByButton = require(FriendsLanding.Components.FilterByButton)
local FriendTile = require(FriendsLanding.Components.FriendTile)
local EmptyResultsView = require(FriendsLanding.Components.EmptyResultsView)
local NoFriendsView = require(FriendsLanding.Components.NoFriendsView)
local isFromConnectionsHub = require(FriendsLanding.Navigator.isFromConnectionsHub)

local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpUpsell2 = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell2.AmpEnums.AccessResponseEnum

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local useTextSizeOffset = uiBlox.Core.Style.useTextSizeOffset

local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums2.AppPage

local UserList = require(parent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode

local function onFewestInteractionsSelection() end
local FFlagFixScalingOnFriendsLanding = require(FriendsLanding.Flags.FFlagFixScalingOnFriendsLanding)

local FFlagEnableFriendsLandingFilterChipsOnConsole = require(FriendsLanding.Flags.FFlagEnableFriendsLandingFilterChipsOnConsole)
local FFlagFriendsPageUserListCtaEnabled = require(FriendsLanding.Flags.FFlagFriendsPageUserListCtaEnabled)
local FriendsLandingCtaConfig

if FFlagFriendsPageUserListCtaEnabled then
	FriendsLandingCtaConfig = require(FriendsLanding.Common.FriendsLandingCtaConfig)
else
	FriendsLandingCtaConfig = nil
end

local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips
local SharedFlags2 = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags2.FFlagCreateConnectionsHub

local SharedFlags3 = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026FriendsBackground = SharedFlags3.FFlagAppThemeHalloween2026FriendsBackground
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagFixFriendsListGapInConnectionsHub = require(FriendsLanding.Flags.FFlagFixFriendsListGapInConnectionsHub)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagFriendsPageAlwaysOpenPPV = SharedFlags4.FFlagFriendsPageAlwaysOpenPPV
local SharedFlags5 = require(parent.SharedFlags)
local FFlagFriendsPageUserListEnabled = SharedFlags5.FFlagFriendsPageUserListEnabled
local SharedFlags6 = require(parent.SharedFlags)
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags6.FFlagExtendScrollingFramesBySafeInsets
local SharedFlags7 = require(parent.SharedFlags)
local FStringIsUserInTcEligibleCountryAmpFeature = SharedFlags7.FStringIsUserInTcEligibleCountryAmpFeature
local SharedFlags8 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags8.FStringCanAccessTrustedContactsAmpNameSpace
local defineFastFlag = game:DefineFastFlag("FixFriendsLandingRightMargin", false)

local function FriendsLandingPage(props)
	local v = useLocalization({
		pageError = "CommonUI.Messages.Response.PageError",
		successText = "Feature.Friends.Action.FriendRemoved",
		errorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		friends = "CommonUI.Features.Label.Friends",
		showMore = "Feature.Friends.Action.ViewMore"
	})

	local v2 = React.useContext(FriendsLandingContext.Context)
	local analytics = React.useContext(FriendsLandingAnalytics.Context)
	local v3 = useNavigation()

	local v4 = useDesignTokens()
	local v5 = useUiModeInfo()
	local v6

	if FFlagFixScalingOnFriendsLanding then
		v6 = useTokens()
	end

	local focusGuiObject = useFocusGuiObject()

	local pageMargin = getPageMargin(useScreenSize().X)
	local v7 = v5.uiMode == UiMode.TenFoot

	local v8 = FocusNavigationUtils.useLastInputMode() == "Cursor"
	local v9 = InputHandlers.onRelease(function(object)
		object:cancel()
		v3.navigate(AppPage.UserSearch, { shouldShowUserSearchLandingPage = true })
	end)

	local v10 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.Search, v9)

	local v11 = if v7 then v4.Size.Size_1600 else v4.Size.Size_2000
	local v12 = useTextSizeOffset()
	local v13 = v11 + v12 * 3
	local state, setState

	if FFlagConnectionManagementChips then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	React.useEffect(function()
		analytics:pageMountingTimeReport()

		if
			FFlagConnectionManagementChips
			and AmpApiProvider.upsellFeatureAccess(
				FStringIsUserInTcEligibleCountryAmpFeature,
				{},
				FStringCanAccessTrustedContactsAmpNameSpace
			).access == AccessResponseEnum.Granted
		then
			setState(true)
		end
	end, {})
	local v14

	if FFlagFriendsPageAlwaysOpenPPV then
		v14 = nil
	else
		v14 = React.useCallback(function(data)
			return function()
				v2.openPlayerContextualMenu({
					subjectUserId = data.id,
					robloxFriendshipStatus = Enum.FriendStatus.Friend,
					subjectPresence = {
						locationString = data.lastLocation,
						locationPlaceId = data.placeId,
						locationRootPlaceId = data.rootPlaceId,
						locationUniverseId = data.universeId,
						status = convertUserPresenceTypeToString(data.userPresenceType)
					},
					friendshipOriginSourceType = nil
				})
			end
		end, { v2.openPlayerContextualMenu })
	end

	local openPlayerProfileHandle = React.useCallback(function(friendId, p: number, p2)
		if not FFlagFriendsPageAlwaysOpenPPV and v7 and v14 then
			return v14(p2)()
		end

		analytics:navigate(EnumScreens.ViewUserProfile)
		analytics:buttonClick(ButtonClickEvents.PlayerTile, {
			friendId = friendId,
			position = p - 1,
			subpage = "peekView",
			page = "playerProfile"
		})

		v2.openProfilePeekView(friendId, { source = Constants.FriendsLandingPageSourceName })
	end, { analytics, v14, v7 })

	local function fn()
		analytics:pageLoadingTimeReport()
	end

	local renderItem = React.useCallback(function(user, layoutOrder)
		return
			React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder
				},
				{
					tile = React.createElement(FriendTile, {
						user = user,
						index = layoutOrder,
						openPlayerProfileHandle = openPlayerProfileHandle,
						pageLoadingTimeReport = fn,
						selected = layoutOrder == props.selectedItemIndex,
						focusGuiObject = focusGuiObject
					})
				}
			),
			"FriendTile"
	end, { props.selectedItemIndex, v7, openPlayerProfileHandle })

	local getItemHeight = React.useCallback(function(p: number)
		return p + v13
	end, dependencyArray(v13, v12))

	local v15 = React.useCallback(function()
		analytics:buttonClick(ButtonClickEvents.FriendFilterPill)
		v3.navigate(EnumScreens.FilterByModal, {
			onFewestInteractionsSelection = onFewestInteractionsSelection,
			friendCount = props.totalFriendCount
		})
	end, dependencyArray(v3, analytics))
	local onActivated

	if FFlagConnectionManagementChips then
		onActivated = React.useCallback(function(p: string)
			analytics:buttonClick(ButtonClickEvents.FriendFilterPill)
			v2.setFilterKeys(p)
		end, dependencyArray(analytics, v2.setFilterKeys))
	end

	local refresh = React.useCallback(function()
		analytics:pageLoaded()
		v2.setFilterKeys(filterStates.All)

		return v2.refreshPage({
			errorMessage = v.pageError,
			onResolve = function()
				analytics:pageLoadedWithArgs()
			end
		})
	end, dependencyArray(v2.refreshPage, v, analytics, v2.setFilterKeys))

	local openAddFriendsPage = React.useCallback(function()
		analytics:buttonClick(ButtonClickEvents.AddFriendsNoFriendsEmptyView)
		analytics:navigate(EnumScreens.AddFriends)

		if FFlagCreateConnectionsHub then
			v3.navigate(AppPage.CoHubAddConnections)
		else
			v3.navigate(AppPage.AddFriendsPage)
		end
	end, dependencyArray(analytics, v3))

	local friendCount = props.friends and #props.friends or 0
	local totalFriendCount = props.totalFriendCount or 0
	local v16 = totalFriendCount == 0
	local v17

	if friendCount == 0 then
		v17 = totalFriendCount > 0
	else
		v17 = false
	end

	local hasMore = props.fetchMoreFriends and not (v16 or v17) and (not v2.filter or v2.filter == filterStates.All)

	local v18 = React.useCallback(function()
		if props.fetchMoreFriends then
			props.fetchMoreFriends()
		end
	end, { props.fetchMoreFriends })
	local verticalPadding = v7 and 24 or 12
	local state2, setState2 = React.useState(100)
	local v19, columnGap

	if v7 then
		v19 = v4.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
		columnGap = v4.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	else
		v19 = {
			minimumItemsPerRow = 2,
			minimumItemWidth = not FFlagFixScalingOnFriendsLanding and 176 or 176 * v6.Config.UI.Scale
		}
		columnGap = 12
	end

	local v20 = React.useMemo(function()
		return gridMetrics.makeCustomMetricsGetter(v19)
	end, { v19 })

	local v21 = React.useMemo(function()
		return v20(state2, columnGap)
	end, { v20 })

	local onContainerSizeChanged = React.useCallback(function(vector2: Vector2)
		setState2(vector2.X)
	end, {})

	local ref = React.useRef({})
	local scrollAnimationConfig = v4.LuaApps.App.Page.ScrollAnimationConfig

	local canvasPosition, v22 = useAnimatedScrollToSelection(
		Enum.ScrollingDirection.Y,
		0,
		v4.Size.Size_2000,
		scrollAnimationConfig
	)
	local v23

	if FFlagExtendScrollingFramesBySafeInsets then
		v23 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	end

	local v24 = (v7 and ((v16 or v17 or v8) and 8 or 1000) or 8) + (not FFlagExtendScrollingFramesBySafeInsets and 0 or v23.bottom)

	local v25 = FFlagCreateConnectionsHub and isFromConnectionsHub(v3)
	local v26

	if FFlagAppThemeHalloween2026FriendsBackground then
		v26 = useThemeBackground() ~= nil
	else
		v26 = false
	end

	local v27 = -(FFlagFixFriendsListGapInConnectionsHub and 0 or Constants.TOP_BAR_HEIGHT) + (not FFlagExtendScrollingFramesBySafeInsets and 0 or v23.bottom)

	local containerRef = useFocusOnMount()
	local renderRow

	if FFlagFriendsPageUserListEnabled then
		renderRow = React.useCallback(function(createRow, user, p)
			return React.createElement(FriendTile, {
				user = user,
				createRow = createRow,
				index = p,
				openPlayerProfileHandle = openPlayerProfileHandle,
				pageLoadingTimeReport = fn
			})
		end, { fn, openPlayerProfileHandle })
	end

	local createElement = React.createElement
	local v28 = { [Roact.Ref] = v10, Size = UDim2.new(1, 0, 1, 0) }
	local backgroundColor

	if not v25 then
		backgroundColor = v4.LuaApps.App.Page.BackgroundColor
	end

	v28.BackgroundColor3 = backgroundColor
	v28.BackgroundTransparency = (v25 or v26) and 1 or v4.LuaApps.App.Page.BackgroundTransparency

	local createElement2 = React.createElement
	local v29 = { Size = UDim2.fromScale(1, 1), backgroundTransparency = 1 }

	local createElement3 = React.createElement
	local v30 = { PaddingLeft = UDim.new(0, pageMargin), PaddingRight = 0 }
	local paddingRight

	if defineFastFlag then
		paddingRight = UDim.new(0, pageMargin)
	end

	v30.PaddingRight = paddingRight
	local children = {
		Padding = createElement3("UIPadding", v30),
		scrollView = 0
	}

	local createElement4 = React.createElement
	local refsByRef = {
		scrollingElementProps = {
			Size = UDim2.new(1, 0, 1, v27),
			BackgroundTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasPosition = canvasPosition,
			[Roact.Event.SelectionChanged] = v22,
			Selectable = false
		},
		[Roact.Ref] = ref,
		refresh = refresh,
		usesBuilderIcon = true
	}
	local uiSizeConstraint

	if FFlagFriendsPageUserListEnabled then
		uiSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(640, 1e999)
		})
	end

	local children2 = {
		UISizeConstraint = uiSizeConstraint,
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		pulldownSpacing = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 0,
			BackgroundTransparency = 1
		}) or nil,
		filterByButton = 0,
		NoResultsView = 0,
		NoFriendsView = 0,
		UserListLayoutAdaptor = 0,
		FriendsGridView = 0,
		showMoreFrame = 0,
		additionalPadding = 0
	}
	local filterByButton

	if not (v7 and not FFlagEnableFriendsLandingFilterChipsOnConsole) then
		local createElement5 = React.createElement
		local v31 = {
			analytics = analytics,
			filter = v2.filter,
			friendCount = 0,
			isDisabled = 0,
			layoutOrder = 2,
			onActivated = 0,
			maxWidth = 0,
			canAccessTrustedContacts = 0
		}

		if v2.filter == filterStates.All then
			friendCount = totalFriendCount
		end

		v31.friendCount = friendCount

		v31.isDisabled = totalFriendCount == 0

		if not FFlagConnectionManagementChips then
			onActivated = v15
		end

		v31.onActivated = onActivated

		v31.maxWidth = FFlagConnectionManagementChips and 640 or nil

		if not FFlagConnectionManagementChips then
			state = nil
		end

		v31.canAccessTrustedContacts = state
		filterByButton = createElement5(FilterByButton, v31)
	end

	children2.filterByButton = filterByButton
	local noResultsView

	if v17 then
		noResultsView = React.createElement(EmptyResultsView, { layoutOrder = 6 })
	end

	children2.NoResultsView = noResultsView
	local noFriendsView

	if v16 then
		noFriendsView = React.createElement(NoFriendsView, {
			layoutOrder = 6,
			pageLoadingTimeReport = fn,
			openAddFriendsPage = openAddFriendsPage
		})
	end

	children2.NoFriendsView = noFriendsView
	local userListLayoutAdaptor

	if FFlagFriendsPageUserListEnabled and not (v17 or v16) then
		local createElement5 = React.createElement
		local v31 = {
			layoutOrder = 6,
			layoutMode = LayoutMode.Vertical,
			header = { title = v.peopleYouMayKnow },
			entities = props.friends,
			isScrollEnabled = false,
			renderRow = renderRow,
			ctaConfig = 0,
			hasMore = 0,
			onLoadMore = 0
		}
		local ctaConfig

		if FFlagFriendsPageUserListCtaEnabled then
			ctaConfig = FriendsLandingCtaConfig
		end

		v31.ctaConfig = ctaConfig
		v31.hasMore = hasMore
		v31.onLoadMore = v18
		userListLayoutAdaptor = createElement5(UserListLayoutAdaptor, v31)
	end

	children2.UserListLayoutAdaptor = userListLayoutAdaptor
	local friendsGridView

	if not (FFlagFriendsPageUserListEnabled or v17 or v16) then
		friendsGridView = React.createElement(CollectionGrid, {
			containerRef = containerRef,
			LayoutOrder = 6,
			items = props.friends,
			verticalScrollingFrameRef = ref,
			renderItem = renderItem,
			getItemHeight = getItemHeight,
			numColumns = v21.itemsPerRow,
			columnGap = columnGap,
			verticalPadding = verticalPadding,
			onContainerSizeChanged = onContainerSizeChanged
		})
	end

	children2.FriendsGridView = friendsGridView
	local showMoreFrame

	if not (FFlagFriendsPageUserListEnabled or not hasMore) then
		showMoreFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, Constants.CTA_BUTTON_HEIGHT),
				BackgroundTransparency = 1,
				LayoutOrder = 7
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 2),
					PaddingTop = UDim.new(0, 10)
				}),
				showMoreButton = React.createElement(button, {
					buttonType = buttonType.Secondary,
					size = UDim2.new(1, 0, 1, 0),
					onActivated = v18,
					text = v.showMore
				})
			}
		)
	end

	children2.showMoreFrame = showMoreFrame

	children2.additionalPadding = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v24),
		BackgroundTransparency = 1,
		LayoutOrder = 8
	})
	children.scrollView = createElement4(refreshScrollingFrame, refsByRef, children2)
	return createElement("Frame", v28, {
		HorizontalPageMargin = createElement2(horizontalPageMargin, v29, children)
	})
end

return FriendsLandingPage
