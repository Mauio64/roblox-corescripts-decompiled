local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local FriendsLandingParent = FriendsLanding.Parent
local React = require(FriendsLandingParent.React)
local Roact = require(FriendsLandingParent.Roact)
local UIBlox = dependencies.UIBlox
local useNavigation = require(FriendsLandingParent.Navigation).useNavigation
local useDesignTokens = require(FriendsLandingParent.Style).useDesignTokens
local useTokens = require(FriendsLandingParent.Foundation).Hooks.useTokens
local useUiModeInfo = require(FriendsLandingParent.RobloxAppHooks).useUiModeInfo
local useScreenSize = require(FriendsLandingParent.RobloxAppHooks).useScreenSize
local UiMode = require(FriendsLandingParent.RobloxAppEnums).UiMode
local RobloxAppEnums = require(FriendsLandingParent.RobloxAppEnums)
local FocusNavigationUtils = require(FriendsLandingParent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(FriendsLandingParent.ReactFocusNavigation)
local InputHandlers = require(FriendsLandingParent.InputHandlers)

require(FriendsLandingParent.PlayerContextualMenu)

local dependencyArray = require(FriendsLandingParent.RoactUtils).Hooks.dependencyArray
local useLocalization = require(FriendsLandingParent.Localization).Hooks.useLocalization
local CollectionGrid = require(FriendsLandingParent.CollectionViews).CollectionGrid
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local getPageMargin = UIBlox.App.Container.getPageMargin
local convertUserPresenceTypeToString = require(FriendsLandingParent.SocialCommon).Utils.convertUserPresenceTypeToString
local useFocusGuiObject = dependencies.useFocusGuiObject
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local RefreshScrollingFrame = dependencies.SocialLibraries.Components.RefreshScrollingFrame
local GridMetrics = UIBlox.App.Grid.GridMetrics
local EnumScreens = require(FriendsLanding.EnumScreens)
local filterStates = require(FriendsLanding.Friends.filterStates)
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local Constants = require(FriendsLanding.Common.Constants)
local useAnimatedScrollToSelection = require(FriendsLandingParent.RobloxAppHooks).useAnimatedScrollToSelection
local useSignalState = require(FriendsLandingParent.SignalsReact).useSignalState
local Display = require(FriendsLandingParent.Display)
local useFocusOnMount = require(FriendsLandingParent.FocusNavigationUtils).useFocusOnMount
local FilterByButton = require(FriendsLanding.Components.FilterByButton)
local FriendTile = require(FriendsLanding.Components.FriendTile)
local EmptyResultsView = require(FriendsLanding.Components.EmptyResultsView)
local NoFriendsView = require(FriendsLanding.Components.NoFriendsView)
local isFromConnectionsHub = require(FriendsLanding.Navigator.isFromConnectionsHub)
local AmpApiProvider = require(FriendsLandingParent.AmpUpsell).AmpApiProvider
local AccessResponseEnum = require(FriendsLandingParent.AmpUpsell).AmpEnums.AccessResponseEnum
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local AppPage = require(FriendsLandingParent.RobloxAppEnums).AppPage
local UserList = require(FriendsLandingParent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode

local function v51() -- line: 66
end

local FFlagFixScalingOnFriendsLanding = require(FriendsLanding.Flags.FFlagFixScalingOnFriendsLanding)
local FFlagConnectionManagementChips = require(FriendsLandingParent.SharedFlags).FFlagConnectionManagementChips
local FFlagCreateConnectionsHub = require(FriendsLandingParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagFixCohubUiBugs = require(FriendsLandingParent.SharedFlags).FFlagFixCohubUiBugs
local FFlagFriendsPageAlwaysOpenPPV = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageAlwaysOpenPPV
local FFlagFriendsPageUserListEnabled = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageUserListEnabled
local FFlagFriendsPageUnifiedOpenProfileLogic = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageUnifiedOpenProfileLogic
local FFlagExtendScrollingFramesBySafeInsets = require(FriendsLandingParent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagEnableLeftNavOnConsole = require(FriendsLandingParent.SharedFlags).FFlagEnableLeftNavOnConsole
local FStringIsUserInTcEligibleCountryAmpFeature = require(FriendsLandingParent.SharedFlags).FStringIsUserInTcEligibleCountryAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(FriendsLandingParent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local v63 = game:DefineFastFlag("FixSearchYNavigation", false)
local v64 = game:DefineFastFlag("FixFriendsLandingRightMargin", false)
local FFlagLuaAppsDefaultSelection = require(FriendsLandingParent.SharedFlags).FFlagLuaAppsDefaultSelection

local function FriendsLandingPage(t1: {[any]: any}) -- line: 107
	-- upvalues: useLocalization (copy), React (copy), FriendsLandingContext (copy), FriendsLandingAnalytics (copy), useNavigation (copy), useDesignTokens (copy), useUiModeInfo (copy), FFlagFixScalingOnFriendsLanding (copy), useTokens (copy), useFocusGuiObject (copy), FFlagFixCohubUiBugs (copy), getPageMargin (copy), useScreenSize (copy), UiMode (copy), FocusNavigationUtils (copy), InputHandlers (copy), v63 (copy), FFlagEnableLeftNavOnConsole (copy), AppPage (copy), RobloxAppEnums (copy), EnumScreens (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), useTextSizeOffset (copy), FFlagConnectionManagementChips (copy), AmpApiProvider (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), FFlagFriendsPageAlwaysOpenPPV (copy), convertUserPresenceTypeToString (copy), ButtonClickEvents (copy), Constants (copy), FFlagFriendsPageUserListEnabled (copy), FFlagFriendsPageUnifiedOpenProfileLogic (copy), FriendTile (copy), dependencyArray (copy), v51 (copy), filterStates (copy), FFlagCreateConnectionsHub (copy), GridMetrics (copy), useAnimatedScrollToSelection (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), isFromConnectionsHub (copy), FFlagLuaAppsDefaultSelection (copy), useFocusOnMount (copy), Roact (copy), HorizontalPageMargin (copy), v64 (copy), RefreshScrollingFrame (copy), FilterByButton (copy), EmptyResultsView (copy), NoFriendsView (copy), UserListLayoutAdaptor (copy), LayoutMode (copy), CollectionGrid (copy), Button (copy), ButtonType (copy)
	local v68 = useLocalization({
		pageError = "CommonUI.Messages.Response.PageError",
		successText = "Feature.Friends.Action.FriendRemoved",
		errorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		friends = "CommonUI.Features.Label.Friends",
		showMore = "Feature.Avatar.Action.ShowMore"
	})
	local v69 = React.useContext(FriendsLandingContext.Context)
	local v70 = React.useContext(FriendsLandingAnalytics.Context)
	local v71 = useNavigation()
	local navigateToLuaAppPages = v69.navigateToLuaAppPages
	local v73 = useDesignTokens()
	local v74 = useUiModeInfo()
	local v75 = if not FFlagFixScalingOnFriendsLanding then nil else useTokens()
	local v76 = useFocusGuiObject()
	local v77 = if not FFlagFixCohubUiBugs then nil else getPageMargin(useScreenSize().X)
	local v78 = v74.uiMode == UiMode.TenFoot
	local v79 = FocusNavigationUtils.useLastInputMode() == "Cursor"
	local v80 = InputHandlers.onRelease(function(p1) -- line: 132
		-- upvalues: v63 (copy), v78 (copy), FFlagEnableLeftNavOnConsole (copy), v71 (copy), AppPage (copy), RobloxAppEnums (copy), navigateToLuaAppPages (copy), EnumScreens (copy)
		p1:cancel()

		if v63 then
			if v78 and not FFlagEnableLeftNavOnConsole then
				v71.navigate(AppPage.SearchPage, {
					defaultSearchType = RobloxAppEnums.SearchTypes.Players
				})

				return
			end

			v71.navigate(AppPage.UserSearch, {
				shouldShowUserSearchLandingPage = true
			})

			return
		end

		navigateToLuaAppPages[EnumScreens.SearchPage]()
	end)
	local v81 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.Search, v80)
	local v82 = if not v78 then v73.Size.Size_2000 else v73.Size.Size_1600
	local v83 = useTextSizeOffset()
	local u84 = v82 + v83 * 3
	local v85 = nil
	local u86 = nil

	if FFlagConnectionManagementChips then
		local v87

		v85, v87 = React.useState(false)
		u86 = v87
	end

	React.useEffect(function() -- line: 164
		-- upvalues: v70 (copy), FFlagConnectionManagementChips (copy), AmpApiProvider (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), u86 (ref)
		v70:pageMountingTimeReport()

		if FFlagConnectionManagementChips and AmpApiProvider.upsellFeatureAccess(FStringIsUserInTcEligibleCountryAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AccessResponseEnum.Granted then
			u86(true)
		end
	end, {})

	local v88 = if not FFlagFriendsPageAlwaysOpenPPV then React.useCallback(function(p2) -- line: 176
		-- upvalues: v69 (copy), convertUserPresenceTypeToString (copy)
		return function() -- line: 177
			-- upvalues: v69 (copy), p2 (copy), convertUserPresenceTypeToString (copy)
			v69.openPlayerContextualMenu({
				friendshipOriginSourceType = nil,
				subjectUserId = p2.id,
				robloxFriendshipStatus = Enum.FriendStatus.Friend,
				subjectPresence = {
					locationString = p2.lastLocation,
					locationPlaceId = p2.placeId,
					locationRootPlaceId = p2.rootPlaceId,
					locationUniverseId = p2.universeId,
					status = convertUserPresenceTypeToString(p2.userPresenceType)
				}
			})
		end
	end, { v69.openPlayerContextualMenu }) else nil
	local v89 = React.useCallback(function(p3, n1: number, _, _, _) -- line: 194
		-- upvalues: v70 (copy), EnumScreens (copy), ButtonClickEvents (copy), v69 (copy), Constants (copy)
		return function() -- line: 195
			-- upvalues: v70 (copy), EnumScreens (copy), ButtonClickEvents (copy), p3 (copy), n1 (copy), v69 (copy), Constants (copy)
			v70:navigate(EnumScreens.ViewUserProfile)
			v70:buttonClick(ButtonClickEvents.PlayerTile, {
				subpage = "peekView",
				page = "playerProfile",
				friendId = p3,
				position = n1 - 1
			})
			v69.openProfilePeekView(p3, {
				source = Constants.FriendsLandingPageSourceName
			})
		end
	end, {
		v70,
		v69.openProfilePeekView
	})
	local v90 = if not FFlagFriendsPageUserListEnabled and not FFlagFriendsPageUnifiedOpenProfileLogic then nil else React.useCallback(function(p7, n2: number, p8) -- line: 211
		-- upvalues: FFlagFriendsPageAlwaysOpenPPV (copy), FFlagFriendsPageUnifiedOpenProfileLogic (copy), v78 (copy), v88 (copy), v70 (copy), EnumScreens (copy), ButtonClickEvents (copy), v69 (copy), Constants (copy)
		if not FFlagFriendsPageAlwaysOpenPPV and (FFlagFriendsPageUnifiedOpenProfileLogic and v78 and v88) then
			return v88(p8)()
		end

		v70:navigate(EnumScreens.ViewUserProfile)
		v70:buttonClick(ButtonClickEvents.PlayerTile, {
			subpage = "peekView",
			page = "playerProfile",
			friendId = p7,
			position = n2 - 1
		})
		v69.openProfilePeekView(p7, {
			source = Constants.FriendsLandingPageSourceName
		})
	end, {
		v70,
		if not FFlagFriendsPageUnifiedOpenProfileLogic then nil else v88,
		if not FFlagFriendsPageUnifiedOpenProfileLogic then nil else v78
	})

	local function v91() -- line: 238
		-- upvalues: v70 (copy)
		v70:pageLoadingTimeReport()
	end

	local v92 = React.useCallback(function() -- line: 242
		-- upvalues: v71 (copy), EnumScreens (copy), v68 (copy)
		return function() -- line: 243
			-- upvalues: v71 (copy), EnumScreens (copy), v68 (copy)
			v71.navigate(EnumScreens.GenericToast, {
				toastProps = {
					toastContent = {
						toastTitle = v68.errorText
					}
				}
			})
		end
	end, {
		v71,
		v68
	})
	local v93 = React.useCallback(function(p9, p10) -- line: 252
		-- upvalues: React (copy), FriendTile (copy), FFlagFriendsPageUnifiedOpenProfileLogic (copy), FFlagFriendsPageAlwaysOpenPPV (copy), v89 (copy), v78 (copy), v88 (copy), v92 (copy), v90 (copy), v91 (copy), t1 (copy), v76 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = p10
		}, {
			tile = React.createElement(FriendTile, {
				user = p9,
				index = p10,
				openPlayerProfile = if not FFlagFriendsPageUnifiedOpenProfileLogic then if not FFlagFriendsPageAlwaysOpenPPV then if not v78 then v89 else if v88 ~= nil then v88 else v92 else v89 else nil,
				openPlayerProfileHandle = if not FFlagFriendsPageUnifiedOpenProfileLogic then nil else v90,
				isPlayerContextualMenuEnabled = if not FFlagFriendsPageUnifiedOpenProfileLogic then v78 else nil,
				pageLoadingTimeReport = v91,
				selected = p10 == t1.selectedItemIndex,
				focusGuiObject = v76
			})
		}), "FriendTile"
	end, {
		t1.selectedItemIndex,
		v78,
		if not FFlagFriendsPageAlwaysOpenPPV and not FFlagFriendsPageUnifiedOpenProfileLogic then v88 else nil,
		v89,
		if not FFlagFriendsPageUnifiedOpenProfileLogic then nil else v90
	})
	local v94 = React.useCallback(function(n3: number) -- line: 291
		-- upvalues: u84 (ref)
		return n3 + u84
	end, dependencyArray(u84, v83))
	local v95 = React.useCallback(function() -- line: 295
		-- upvalues: v70 (copy), ButtonClickEvents (copy), v71 (copy), EnumScreens (copy), v51 (copy), t1 (copy)
		v70:buttonClick(ButtonClickEvents.FriendFilterPill)
		v71.navigate(EnumScreens.FilterByModal, {
			onFewestInteractionsSelection = v51,
			friendCount = t1.totalFriendCount
		})
	end, dependencyArray(v71, v70))
	local v96 = if not FFlagConnectionManagementChips then nil else React.useCallback(function(s1: string) -- line: 304
		-- upvalues: v70 (copy), ButtonClickEvents (copy), v69 (copy)
		v70:buttonClick(ButtonClickEvents.FriendFilterPill)
		v69.setFilterKeys(s1)
	end, dependencyArray(v70, v69.setFilterKeys))
	local v97 = React.useCallback(function() -- line: 310
		-- upvalues: v70 (copy), v69 (copy), filterStates (copy), v68 (copy)
		v70:pageLoaded()
		v69.setFilterKeys(filterStates.All)

		return v69.refreshPage({
			errorMessage = v68.pageError,
			onResolve = function() -- line: 316
				-- upvalues: v70 (copy)
				v70:pageLoadedWithArgs()
			end
		})
	end, dependencyArray(v69.refreshPage, v68, v70, v69.setFilterKeys))
	local v98 = React.useCallback(function() -- line: 322
		-- upvalues: v70 (copy), ButtonClickEvents (copy), EnumScreens (copy), FFlagCreateConnectionsHub (copy), v71 (copy), AppPage (copy)
		v70:buttonClick(ButtonClickEvents.AddFriendsNoFriendsEmptyView)
		v70:navigate(EnumScreens.AddFriends)

		if FFlagCreateConnectionsHub then
			v71.navigate(AppPage.CoHubAddConnections)

			return
		end

		v71.navigate(AppPage.AddFriendsPage)
	end, dependencyArray(v70, v71))
	local v99 = t1.friends and #t1.friends or 0
	local v100 = t1.totalFriendCount or 0
	local v101 = v100 == 0
	local v102 = v99 == 0 and v100 > 0
	local v103 = t1.fetchMoreFriends and (not v101 and (not v102 and (not v69.filter or v69.filter == filterStates.All)))
	local v104 = React.useCallback(function() -- line: 341
		-- upvalues: t1 (copy)
		if t1.fetchMoreFriends then
			t1.fetchMoreFriends()
		end
	end, { t1.fetchMoreFriends })
	local v105 = not v78 and 12 or 24
	local v106, v107 = React.useState(100)
	local GridViewItemMetrics, GridHorizontalSpacing

	if v78 then
		GridViewItemMetrics = v73.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
		GridHorizontalSpacing = v73.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	else
		GridViewItemMetrics = {
			minimumItemsPerRow = 2,
			minimumItemWidth = not FFlagFixScalingOnFriendsLanding and 176 or 176 * v75.Config.UI.Scale
		}
		GridHorizontalSpacing = 12
	end

	local v110 = React.useMemo(function() -- line: 364
		-- upvalues: GridMetrics (copy), GridViewItemMetrics (ref)
		return GridMetrics.makeCustomMetricsGetter(GridViewItemMetrics)
	end, { GridViewItemMetrics })
	local v111 = React.useMemo(function() -- line: 368
		-- upvalues: v110 (copy), v106 (copy), GridHorizontalSpacing (ref)
		return v110(v106, GridHorizontalSpacing)
	end, { v110 })
	local v112 = React.useCallback(function(vector2: Vector2) -- line: 372
		-- upvalues: v107 (copy)
		v107(vector2.X)
	end, {})
	local v113 = React.useRef({})
	local ScrollAnimationConfig = v73.LuaApps.App.Page.ScrollAnimationConfig
	local v115, v116 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, 0, v73.Size.Size_2000, ScrollAnimationConfig)
	local v117 = not v78 and 8 or (not v101 and (not v102 and not v79) and 1000 or 8)
	local v118 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v119 = v117 + (not FFlagExtendScrollingFramesBySafeInsets and 0 or v118.bottom)
	local v120 = FFlagCreateConnectionsHub and isFromConnectionsHub(v71)
	local v121 = if not FFlagLuaAppsDefaultSelection then nil else useFocusOnMount()
	local v122 = if not FFlagFriendsPageUserListEnabled then nil else React.useCallback(function(p11, p12, p13) -- line: 399
		-- upvalues: React (copy), FriendTile (copy), v90 (copy), v91 (copy)
		return React.createElement(FriendTile, {
			isPlayerContextualMenuEnabled = nil,
			user = p12,
			createRow = p11,
			index = p13,
			openPlayerProfileHandle = v90,
			pageLoadingTimeReport = v91
		})
	end, {
		v91,
		v90
	})

	return React.createElement("Frame", {
		[Roact.Ref] = v81,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = if not v120 then v73.LuaApps.App.Page.BackgroundColor else nil,
		BackgroundTransparency = if not v120 then v73.LuaApps.App.Page.BackgroundTransparency else 1
	}, {
		HorizontalPageMargin = React.createElement(HorizontalPageMargin, {
			backgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Padding = if not FFlagFixCohubUiBugs then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v77),
				PaddingRight = if not v64 then nil else UDim.new(0, v77)
			}),
			scrollView = React.createElement(RefreshScrollingFrame, {
				scrollingElementProps = {
					Size = UDim2.new(1, 0, 1, -Constants.TOP_BAR_HEIGHT + (FFlagExtendScrollingFramesBySafeInsets and v118.bottom or 0)),
					BackgroundTransparency = 1,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 0,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.XY,
					CanvasPosition = v115,
					[Roact.Event.SelectionChanged] = v116,
					Selectable = not FFlagEnableLeftNavOnConsole and nil
				},
				[Roact.Ref] = v113,
				refresh = v97,
				usesBuilderIcon = true
			}, {
				UISizeConstraint = if not FFlagFriendsPageUserListEnabled then nil else React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(640, 1e999)
				}),
				layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				pulldownSpacing = React.createElement("Frame", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 1)
				}) or nil,
				filterByButton = if not v78 then React.createElement(FilterByButton, {
					layoutOrder = 2,
					analytics = v70,
					filter = v69.filter,
					friendCount = if v69.filter ~= filterStates.All then v99 else v100,
					isDisabled = v100 == 0,
					onActivated = if not FFlagConnectionManagementChips then v95 else v96,
					maxWidth = if not FFlagConnectionManagementChips then nil else 640,
					canAccessTrustedContacts = if not FFlagConnectionManagementChips then nil else v85
				}) else nil,
				NoResultsView = if not v102 then nil else React.createElement(EmptyResultsView, {
					layoutOrder = 6
				}),
				NoFriendsView = if not v101 then nil else React.createElement(NoFriendsView, {
					layoutOrder = 6,
					pageLoadingTimeReport = v91,
					openAddFriendsPage = v98
				}),
				UserListLayoutAdaptor = if not FFlagFriendsPageUserListEnabled then nil else if v102 or v101 then nil else React.createElement(UserListLayoutAdaptor, {
					layoutOrder = 6,
					isScrollEnabled = false,
					layoutMode = LayoutMode.Vertical,
					header = {
						title = v68.peopleYouMayKnow
					},
					entities = t1.friends,
					renderRow = v122,
					hasMore = v103,
					onLoadMore = v104
				}),
				FriendsGridView = if not FFlagFriendsPageUserListEnabled then if v102 or v101 then nil else React.createElement(CollectionGrid, {
					LayoutOrder = 6,
					containerRef = if not FFlagLuaAppsDefaultSelection then nil else v121,
					items = t1.friends,
					verticalScrollingFrameRef = v113,
					renderItem = v93,
					getItemHeight = v94,
					numColumns = v111.itemsPerRow,
					columnGap = GridHorizontalSpacing,
					verticalPadding = v105,
					onContainerSizeChanged = v112
				}) else nil,
				showMoreFrame = if not FFlagFriendsPageUserListEnabled then if not v103 then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Size = UDim2.new(1, 0, 0, Constants.CTA_BUTTON_HEIGHT)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2),
						PaddingTop = UDim.new(0, 10)
					}),
					showMoreButton = React.createElement(Button, {
						buttonType = ButtonType.Secondary,
						size = UDim2.new(1, 0, 1, 0),
						onActivated = v104,
						text = v68.showMore
					})
				}) else nil,
				additionalPadding = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 8,
					Size = UDim2.new(1, 0, 0, v119)
				})
			})
		})
	})
end

return FriendsLandingPage
