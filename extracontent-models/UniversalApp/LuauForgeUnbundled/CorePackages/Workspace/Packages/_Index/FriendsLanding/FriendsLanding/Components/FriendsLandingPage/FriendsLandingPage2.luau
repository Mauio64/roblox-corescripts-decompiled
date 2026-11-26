local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Roact")
local uiBlox = dependencies.UIBlox
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Navigation").useNavigation
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation").Hooks.useTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppHooks").useUiModeInfo
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppHooks").useScreenSize
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").UiMode
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FocusNavigationUtils")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/PlayerContextualMenu")
local dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactUtils").Hooks.dependencyArray
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").Hooks.useLocalization
local collectionGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/CollectionViews").CollectionGrid
local horizontalPageMargin = uiBlox.App.Container.HorizontalPageMargin
local getPageMargin = uiBlox.App.Container.getPageMargin

local convertUserPresenceTypeToString = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialCommon").Utils.convertUserPresenceTypeToString

local useFocusGuiObject = dependencies.useFocusGuiObject
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")

local FriendsLandingAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics")

local refreshScrollingFrame = dependencies.SocialLibraries.Components.RefreshScrollingFrame

local gridMetrics = uiBlox.App.Grid.GridMetrics

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")
local ButtonClickEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ButtonClickEvents")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/Constants")
local useAnimatedScrollToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppHooks").useAnimatedScrollToSelection
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SignalsReact").useSignalState
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Display")
local useFocusOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FocusNavigationUtils").useFocusOnMount

local FilterByButton = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FilterByButton")
local FriendTile = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendTile")
local EmptyResultsView = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/EmptyResultsView")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/NoFriendsView")
local isFromConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/isFromConnectionsHub")

local ampApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AmpUpsell").AmpApiProvider
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AmpUpsell").AmpEnums.AccessResponseEnum

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local useTextSizeOffset = uiBlox.Core.Style.useTextSizeOffset

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").AppPage

local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserList")
local userListLayoutAdaptor = UserList.UserListLayoutAdaptor
local layoutMode = UserList.Enums.LayoutMode

local function onFewestInteractionsSelection() end
local FFlagFixScalingOnFriendsLanding = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFixScalingOnFriendsLanding")
local FFlagFriendsPageUserListCtaEnabled = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFriendsPageUserListCtaEnabled")

local v5 = if FFlagFriendsPageUserListCtaEnabled then require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/FriendsLandingCtaConfig") else nil

local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagConnectionManagementChips
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagCreateConnectionsHub

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ThemeBackground").useThemeBackground
local FFlagFixFriendsListGapInConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFixFriendsListGapInConnectionsHub")
local fFlagFriendsPageAlwaysOpenPPV = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageAlwaysOpenPPV
local fFlagFriendsPageUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageUserListEnabled
local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagExtendScrollingFramesBySafeInsets
local fStringIsUserInTcEligibleCountryAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FStringIsUserInTcEligibleCountryAmpFeature
local fStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FStringCanAccessTrustedContactsAmpNameSpace
local defineFastFlag = game:DefineFastFlag("FixFriendsLandingRightMargin", false)

local function FriendsLandingPage(props)
	local v6 = useLocalization({
		pageError = "CommonUI.Messages.Response.PageError",
		successText = "Feature.Friends.Action.FriendRemoved",
		errorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		friends = "CommonUI.Features.Label.Friends",
		showMore = "Feature.Friends.Action.ViewMore"
	})

	local v7 = React.useContext(FriendsLandingContext.Context)
	local v8 = React.useContext(FriendsLandingAnalytics.Context)
	local v9 = useNavigation()

	local v10 = useDesignTokens()
	local v11 = useUiModeInfo()
	local v12 = if FFlagFixScalingOnFriendsLanding then useTokens() else nil
	local v13 = useFocusGuiObject()

	local pageMargin = getPageMargin(useScreenSize().X)
	local v14 = v11.uiMode == uiMode.TenFoot

	local v15 = FocusNavigationUtils.useLastInputMode() == "Cursor"
	local v16 = InputHandlers.onRelease(function(object)
		object:cancel()
		v9.navigate(appPage.UserSearch, { shouldShowUserSearchLandingPage = true })
	end)

	local v17 = ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.Search, v16)

	local v18 = if v14 then v10.Size.Size_1600 else v10.Size.Size_2000
	local v19 = useTextSizeOffset()
	local v20 = v18 + v19 * 3
	local state, setState

	if fFlagConnectionManagementChips then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	React.useEffect(function()
		v8:pageMountingTimeReport()

		if
			fFlagConnectionManagementChips
			and ampApiProvider.upsellFeatureAccess(
				fStringIsUserInTcEligibleCountryAmpFeature,
				{},
				fStringCanAccessTrustedContactsAmpNameSpace
			).access == accessResponseEnum.Granted
		then
			setState(true)
		end
	end, {})
	local v21

	if fFlagFriendsPageAlwaysOpenPPV then
		v21 = nil
	else
		v21 = React.useCallback(function(data)
			return function()
				v7.openPlayerContextualMenu({
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
		end, { v7.openPlayerContextualMenu })
	end

	local v22 = React.useCallback(function(p2, p3, p4)
		if not fFlagFriendsPageAlwaysOpenPPV and v14 and v21 then
			return v21(p4)()
		end

		v8:navigate(EnumScreens.ViewUserProfile)
		v8:buttonClick(ButtonClickEvents.PlayerTile, {
			friendId = p2,
			position = p3 - 1,
			subpage = "peekView",
			page = "playerProfile"
		})

		v7.openProfilePeekView(p2, { source = Constants.FriendsLandingPageSourceName })
	end, { v8, v21, v14 })

	local function fn()
		v8:pageLoadingTimeReport()
	end

	local v23 = React.useCallback(function(p2, p3)
		return
			React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = p3
				},
				{
					tile = React.createElement(FriendTile, {
						user = p2,
						index = p3,
						openPlayerProfileHandle = v22,
						pageLoadingTimeReport = fn,
						selected = p3 == props.selectedItemIndex,
						focusGuiObject = v13
					})
				}
			),
			"FriendTile"
	end, { props.selectedItemIndex, v14, v22 })

	local v24 = React.useCallback(function(p2)
		return p2 + v20
	end, dependencyArray(v20, v19))

	local v25 = React.useCallback(function()
		v8:buttonClick(ButtonClickEvents.FriendFilterPill)
		v9.navigate(EnumScreens.FilterByModal, {
			onFewestInteractionsSelection = onFewestInteractionsSelection,
			friendCount = props.totalFriendCount
		})
	end, dependencyArray(v9, v8))
	local v26

	if fFlagConnectionManagementChips then
		v26 = React.useCallback(function(p2)
			v8:buttonClick(ButtonClickEvents.FriendFilterPill)
			v7.setFilterKeys(p2)
		end, dependencyArray(v8, v7.setFilterKeys))
	end

	local v27 = React.useCallback(function()
		v8:pageLoaded()
		v7.setFilterKeys(filterStates.All)

		return v7.refreshPage({
			errorMessage = v6.pageError,
			onResolve = function()
				v8:pageLoadedWithArgs()
			end
		})
	end, dependencyArray(v7.refreshPage, v6, v8, v7.setFilterKeys))

	local v28 = React.useCallback(function()
		v8:buttonClick(ButtonClickEvents.AddFriendsNoFriendsEmptyView)
		v8:navigate(EnumScreens.AddFriends)

		if fFlagCreateConnectionsHub then
			v9.navigate(appPage.CoHubAddConnections)
		else
			v9.navigate(appPage.AddFriendsPage)
		end
	end, dependencyArray(v8, v9))

	local v29 = props.friends and #props.friends or 0
	local totalFriendCount = props.totalFriendCount or 0
	local v30 = totalFriendCount == 0
	local v31 = v29 == 0 and totalFriendCount > 0
	local v32 = props.fetchMoreFriends and not (v30 or v31) and (not v7.filter or v7.filter == filterStates.All)

	local v33 = React.useCallback(function()
		if props.fetchMoreFriends then
			props.fetchMoreFriends()
		end
	end, { props.fetchMoreFriends })

	local state2, setState2 = React.useState(100)
	local v35, v36

	if v14 then
		v35 = v10.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
		v36 = v10.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	else
		v35 = {
			minimumItemsPerRow = 2,
			minimumItemWidth = not FFlagFixScalingOnFriendsLanding and 176 or 176 * v12.Config.UI.Scale
		}
		v36 = 12
	end

	local v37 = React.useMemo(function()
		return gridMetrics.makeCustomMetricsGetter(v35)
	end, { v35 })

	local v38 = React.useMemo(function()
		return v37(state2, v36)
	end, { v37 })

	local v39 = React.useCallback(function(p2)
		setState2(p2.X)
	end, {})

	local ref = React.useRef({})
	local scrollAnimationConfig = v10.LuaApps.App.Page.ScrollAnimationConfig

	local v40, v41 = useAnimatedScrollToSelection(
		Enum.ScrollingDirection.Y,
		0,
		v10.Size.Size_2000,
		scrollAnimationConfig
	)
	local v43

	if fFlagExtendScrollingFramesBySafeInsets then
		v43 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	end

	local v44 = (v14 and ((v30 or v31 or v15) and 8 or 1000) or 8) + (not fFlagExtendScrollingFramesBySafeInsets and 0 or v43.bottom)

	local v45 = fFlagCreateConnectionsHub and isFromConnectionsHub(v9)

	local v46 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local v47 = -(FFlagFixFriendsListGapInConnectionsHub and 0 or Constants.TOP_BAR_HEIGHT) + (not fFlagExtendScrollingFramesBySafeInsets and 0 or v43.bottom)

	local v48 = useFocusOnMount()
	local v49

	if fFlagFriendsPageUserListEnabled then
		v49 = React.useCallback(function(p2, p3, p4)
			return React.createElement(FriendTile, {
				user = p3,
				createRow = p2,
				index = p4,
				openPlayerProfileHandle = v22,
				pageLoadingTimeReport = fn
			})
		end, { fn, v22 })
	end

	local createElement = React.createElement
	local v51 = { [Roact.Ref] = v17, Size = UDim2.new(1, 0, 1, 0) }
	local v52 = if not v45 then v10.LuaApps.App.Page.BackgroundColor else nil
	v51.BackgroundColor3 = v52
	v51.BackgroundTransparency = (v45 or v46) and 1 or v10.LuaApps.App.Page.BackgroundTransparency

	local createElement2 = React.createElement
	local v55 = { Size = UDim2.fromScale(1, 1), backgroundTransparency = 1 }

	local createElement3 = React.createElement
	local v57 = { PaddingLeft = UDim.new(0, pageMargin), PaddingRight = 0 }
	local v58 = if defineFastFlag then UDim.new(0, pageMargin) else nil
	v57.PaddingRight = v58
	local children = {
		Padding = createElement3("UIPadding", v57),
		scrollView = 0
	}

	local createElement4 = React.createElement
	local refsByRef = {
		scrollingElementProps = {
			Size = UDim2.new(1, 0, 1, v47),
			BackgroundTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasPosition = v40,
			[Roact.Event.SelectionChanged] = v41,
			Selectable = false
		},
		[Roact.Ref] = ref,
		refresh = v27,
		usesBuilderIcon = true
	}

	local v61 = if fFlagFriendsPageUserListEnabled then React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(640, 1e999)
	}) else nil
	local children2 = {
		UISizeConstraint = v61,
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

	local createElement5 = React.createElement
	local v63 = {
		analytics = v8,
		filter = v7.filter,
		friendCount = 0,
		isDisabled = 0,
		layoutOrder = 2,
		onActivated = 0,
		maxWidth = 0,
		canAccessTrustedContacts = 0
	}

	if v7.filter == filterStates.All then
		v29 = totalFriendCount
	end

	v63.friendCount = v29
	v63.isDisabled = totalFriendCount == 0

	if not fFlagConnectionManagementChips then
		v26 = v25
	end

	v63.onActivated = v26

	v63.maxWidth = fFlagConnectionManagementChips and 640 or nil

	if not fFlagConnectionManagementChips then
		state = nil
	end

	v63.canAccessTrustedContacts = state
	children2.filterByButton = createElement5(FilterByButton, v63)

	local v64 = if v31 then React.createElement(EmptyResultsView, { layoutOrder = 6 }) else nil
	children2.NoResultsView = v64

	local v65 = if v30 then React.createElement(module17, {
		layoutOrder = 6,
		pageLoadingTimeReport = fn,
		openAddFriendsPage = v28
	}) else nil
	children2.NoFriendsView = v65
	local v66

	if fFlagFriendsPageUserListEnabled and not (v31 or v30) then
		v66 = React.createElement(userListLayoutAdaptor, {
			layoutOrder = 6,
			layoutMode = layoutMode.Vertical,
			header = { title = v6.peopleYouMayKnow },
			entities = props.friends,
			isScrollEnabled = false,
			renderRow = v49,
			ctaConfig = if FFlagFriendsPageUserListCtaEnabled then v5 else nil,
			hasMore = v32,
			onLoadMore = v33
		})
	end

	children2.UserListLayoutAdaptor = v66

	local v67 = if not (fFlagFriendsPageUserListEnabled or v31 or v30) then React.createElement(collectionGrid, {
		containerRef = v48,
		LayoutOrder = 6,
		items = props.friends,
		verticalScrollingFrameRef = ref,
		renderItem = v23,
		getItemHeight = v24,
		numColumns = v38.itemsPerRow,
		columnGap = v36,
		verticalPadding = v14 and 24 or 12,
		onContainerSizeChanged = v39
	}) else nil
	children2.FriendsGridView = v67

	local v68 = if not (fFlagFriendsPageUserListEnabled or not v32) then React.createElement(
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
				onActivated = v33,
				text = v6.showMore
			})
		}
	) else nil
	children2.showMoreFrame = v68

	children2.additionalPadding = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v44),
		BackgroundTransparency = 1,
		LayoutOrder = 8
	})
	children.scrollView = createElement4(refreshScrollingFrame, refsByRef, children2)
	return createElement("Frame", v51, {
		HorizontalPageMargin = createElement2(horizontalPageMargin, v55, children)
	})
end

return FriendsLandingPage
