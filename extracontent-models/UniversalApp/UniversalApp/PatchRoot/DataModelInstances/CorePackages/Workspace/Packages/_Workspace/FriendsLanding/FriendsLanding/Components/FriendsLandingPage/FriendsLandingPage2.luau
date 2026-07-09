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
local FFlagExtendScrollingFramesBySafeInsets = require(FriendsLandingParent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagEnableLeftNavOnConsole = require(FriendsLandingParent.SharedFlags).FFlagEnableLeftNavOnConsole
local FStringIsUserInTcEligibleCountryAmpFeature = require(FriendsLandingParent.SharedFlags).FStringIsUserInTcEligibleCountryAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(FriendsLandingParent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local v62 = game:DefineFastFlag("FixSearchYNavigation", false)
local v63 = game:DefineFastFlag("FixFriendsLandingRightMargin", false)
local FFlagLuaAppsDefaultSelection = require(FriendsLandingParent.SharedFlags).FFlagLuaAppsDefaultSelection

local function FriendsLandingPage(t1: {[any]: any}) -- line: 106
	-- upvalues: useLocalization (copy), React (copy), FriendsLandingContext (copy), FriendsLandingAnalytics (copy), useNavigation (copy), useDesignTokens (copy), useUiModeInfo (copy), FFlagFixScalingOnFriendsLanding (copy), useTokens (copy), useFocusGuiObject (copy), FFlagFixCohubUiBugs (copy), getPageMargin (copy), useScreenSize (copy), UiMode (copy), FocusNavigationUtils (copy), InputHandlers (copy), v62 (copy), FFlagEnableLeftNavOnConsole (copy), AppPage (copy), RobloxAppEnums (copy), EnumScreens (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), useTextSizeOffset (copy), FFlagConnectionManagementChips (copy), AmpApiProvider (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), FFlagFriendsPageAlwaysOpenPPV (copy), convertUserPresenceTypeToString (copy), ButtonClickEvents (copy), Constants (copy), FFlagFriendsPageUserListEnabled (copy), FriendTile (copy), dependencyArray (copy), v51 (copy), filterStates (copy), FFlagCreateConnectionsHub (copy), GridMetrics (copy), useAnimatedScrollToSelection (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), isFromConnectionsHub (copy), FFlagLuaAppsDefaultSelection (copy), useFocusOnMount (copy), Roact (copy), HorizontalPageMargin (copy), v63 (copy), RefreshScrollingFrame (copy), FilterByButton (copy), EmptyResultsView (copy), NoFriendsView (copy), UserListLayoutAdaptor (copy), LayoutMode (copy), CollectionGrid (copy), Button (copy), ButtonType (copy)
	local v67 = useLocalization({
		pageError = "CommonUI.Messages.Response.PageError",
		successText = "Feature.Friends.Action.FriendRemoved",
		errorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		friends = "CommonUI.Features.Label.Friends",
		showMore = "Feature.Avatar.Action.ShowMore"
	})
	local v68 = React.useContext(FriendsLandingContext.Context)
	local v69 = React.useContext(FriendsLandingAnalytics.Context)
	local v70 = useNavigation()
	local navigateToLuaAppPages = v68.navigateToLuaAppPages
	local v72 = useDesignTokens()
	local v73 = useUiModeInfo()
	local v74 = if not FFlagFixScalingOnFriendsLanding then nil else useTokens()
	local v75 = useFocusGuiObject()
	local v76 = if not FFlagFixCohubUiBugs then nil else getPageMargin(useScreenSize().X)
	local v77 = v73.uiMode == UiMode.TenFoot
	local v78 = FocusNavigationUtils.useLastInputMode() == "Cursor"
	local v79 = InputHandlers.onRelease(function(p1) -- line: 131
		-- upvalues: v62 (copy), v77 (copy), FFlagEnableLeftNavOnConsole (copy), v70 (copy), AppPage (copy), RobloxAppEnums (copy), navigateToLuaAppPages (copy), EnumScreens (copy)
		p1:cancel()

		if v62 then
			if v77 and not FFlagEnableLeftNavOnConsole then
				v70.navigate(AppPage.SearchPage, {
					defaultSearchType = RobloxAppEnums.SearchTypes.Players
				})

				return
			end

			v70.navigate(AppPage.UserSearch, {
				shouldShowUserSearchLandingPage = true
			})

			return
		end

		navigateToLuaAppPages[EnumScreens.SearchPage]()
	end)
	local v80 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.Search, v79)
	local v81 = if not v77 then v72.Size.Size_2000 else v72.Size.Size_1600
	local v82 = useTextSizeOffset()
	local u83 = v81 + v82 * 3
	local v84 = nil
	local u85 = nil

	if FFlagConnectionManagementChips then
		local v86

		v84, v86 = React.useState(false)
		u85 = v86
	end

	React.useEffect(function() -- line: 163
		-- upvalues: v69 (copy), FFlagConnectionManagementChips (copy), AmpApiProvider (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), u85 (ref)
		v69:pageMountingTimeReport()

		if FFlagConnectionManagementChips and AmpApiProvider.upsellFeatureAccess(FStringIsUserInTcEligibleCountryAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AccessResponseEnum.Granted then
			u85(true)
		end
	end, {})

	local v87 = if not FFlagFriendsPageAlwaysOpenPPV then React.useCallback(function(p2) -- line: 175
		-- upvalues: v68 (copy), convertUserPresenceTypeToString (copy)
		return function() -- line: 176
			-- upvalues: v68 (copy), p2 (copy), convertUserPresenceTypeToString (copy)
			v68.openPlayerContextualMenu({
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
	end, { v68.openPlayerContextualMenu }) else nil
	local v88 = React.useCallback(function(p3, n1: number, _, _, _) -- line: 193
		-- upvalues: v69 (copy), EnumScreens (copy), ButtonClickEvents (copy), v68 (copy), Constants (copy)
		return function() -- line: 194
			-- upvalues: v69 (copy), EnumScreens (copy), ButtonClickEvents (copy), p3 (copy), n1 (copy), v68 (copy), Constants (copy)
			v69:navigate(EnumScreens.ViewUserProfile)
			v69:buttonClick(ButtonClickEvents.PlayerTile, {
				subpage = "peekView",
				page = "playerProfile",
				friendId = p3,
				position = n1 - 1
			})
			v68.openProfilePeekView(p3, {
				source = Constants.FriendsLandingPageSourceName
			})
		end
	end, {
		v69,
		v68.openProfilePeekView
	})
	local v89 = if not FFlagFriendsPageUserListEnabled then nil else React.useCallback(function(p7, n2: number) -- line: 210
		-- upvalues: v69 (copy), EnumScreens (copy), ButtonClickEvents (copy), v68 (copy), Constants (copy)
		v69:navigate(EnumScreens.ViewUserProfile)
		v69:buttonClick(ButtonClickEvents.PlayerTile, {
			subpage = "peekView",
			page = "playerProfile",
			friendId = p7,
			position = n2 - 1
		})
		v68.openProfilePeekView(p7, {
			source = Constants.FriendsLandingPageSourceName
		})
	end, { v69 })

	local function v90() -- line: 225
		-- upvalues: v69 (copy)
		v69:pageLoadingTimeReport()
	end

	local v91 = React.useCallback(function() -- line: 229
		-- upvalues: v70 (copy), EnumScreens (copy), v67 (copy)
		return function() -- line: 230
			-- upvalues: v70 (copy), EnumScreens (copy), v67 (copy)
			v70.navigate(EnumScreens.GenericToast, {
				toastProps = {
					toastContent = {
						toastTitle = v67.errorText
					}
				}
			})
		end
	end, {
		v70,
		v67
	})
	local v92 = React.useCallback(function(p8, p9) -- line: 239
		-- upvalues: React (copy), FriendTile (copy), FFlagFriendsPageAlwaysOpenPPV (copy), v88 (copy), v77 (copy), v87 (copy), v91 (copy), v90 (copy), t1 (copy), v75 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = p9
		}, {
			tile = React.createElement(FriendTile, {
				user = p8,
				index = p9,
				openPlayerProfile = if not FFlagFriendsPageAlwaysOpenPPV then if not v77 then v88 else if v87 ~= nil then v87 else v91 else v88,
				isPlayerContextualMenuEnabled = v77,
				pageLoadingTimeReport = v90,
				selected = p9 == t1.selectedItemIndex,
				focusGuiObject = v75
			})
		}), "FriendTile"
	end, {
		t1.selectedItemIndex,
		v77,
		if not FFlagFriendsPageAlwaysOpenPPV then v87 else nil,
		v88
	})
	local v93 = React.useCallback(function(n3: number) -- line: 267
		-- upvalues: u83 (ref)
		return n3 + u83
	end, dependencyArray(u83, v82))
	local v94 = React.useCallback(function() -- line: 271
		-- upvalues: v69 (copy), ButtonClickEvents (copy), v70 (copy), EnumScreens (copy), v51 (copy), t1 (copy)
		v69:buttonClick(ButtonClickEvents.FriendFilterPill)
		v70.navigate(EnumScreens.FilterByModal, {
			onFewestInteractionsSelection = v51,
			friendCount = t1.totalFriendCount
		})
	end, dependencyArray(v70, v69))
	local v95 = if not FFlagConnectionManagementChips then nil else React.useCallback(function(s1: string) -- line: 280
		-- upvalues: v69 (copy), ButtonClickEvents (copy), v68 (copy)
		v69:buttonClick(ButtonClickEvents.FriendFilterPill)
		v68.setFilterKeys(s1)
	end, dependencyArray(v69, v68.setFilterKeys))
	local v96 = React.useCallback(function() -- line: 286
		-- upvalues: v69 (copy), v68 (copy), filterStates (copy), v67 (copy)
		v69:pageLoaded()
		v68.setFilterKeys(filterStates.All)

		return v68.refreshPage({
			errorMessage = v67.pageError,
			onResolve = function() -- line: 292
				-- upvalues: v69 (copy)
				v69:pageLoadedWithArgs()
			end
		})
	end, dependencyArray(v68.refreshPage, v67, v69, v68.setFilterKeys))
	local v97 = React.useCallback(function() -- line: 298
		-- upvalues: v69 (copy), ButtonClickEvents (copy), EnumScreens (copy), FFlagCreateConnectionsHub (copy), v70 (copy), AppPage (copy)
		v69:buttonClick(ButtonClickEvents.AddFriendsNoFriendsEmptyView)
		v69:navigate(EnumScreens.AddFriends)

		if FFlagCreateConnectionsHub then
			v70.navigate(AppPage.CoHubAddConnections)

			return
		end

		v70.navigate(AppPage.AddFriendsPage)
	end, dependencyArray(v69, v70))
	local v98 = t1.friends and #t1.friends or 0
	local v99 = t1.totalFriendCount or 0
	local v100 = v99 == 0
	local v101 = v98 == 0 and v99 > 0
	local v102 = t1.fetchMoreFriends and (not v100 and (not v101 and (not v68.filter or v68.filter == filterStates.All)))
	local v103 = React.useCallback(function() -- line: 317
		-- upvalues: t1 (copy)
		if t1.fetchMoreFriends then
			t1.fetchMoreFriends()
		end
	end, { t1.fetchMoreFriends })
	local v104 = not v77 and 12 or 24
	local v105, v106 = React.useState(100)
	local GridViewItemMetrics, GridHorizontalSpacing

	if v77 then
		GridViewItemMetrics = v72.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
		GridHorizontalSpacing = v72.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	else
		GridViewItemMetrics = {
			minimumItemsPerRow = 2,
			minimumItemWidth = not FFlagFixScalingOnFriendsLanding and 176 or 176 * v74.Config.UI.Scale
		}
		GridHorizontalSpacing = 12
	end

	local v109 = React.useMemo(function() -- line: 340
		-- upvalues: GridMetrics (copy), GridViewItemMetrics (ref)
		return GridMetrics.makeCustomMetricsGetter(GridViewItemMetrics)
	end, { GridViewItemMetrics })
	local v110 = React.useMemo(function() -- line: 344
		-- upvalues: v109 (copy), v105 (copy), GridHorizontalSpacing (ref)
		return v109(v105, GridHorizontalSpacing)
	end, { v109 })
	local v111 = React.useCallback(function(vector2: Vector2) -- line: 348
		-- upvalues: v106 (copy)
		v106(vector2.X)
	end, {})
	local v112 = React.useRef({})
	local ScrollAnimationConfig = v72.LuaApps.App.Page.ScrollAnimationConfig
	local v114, v115 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, 0, v72.Size.Size_2000, ScrollAnimationConfig)
	local v116 = not v77 and 8 or (not v100 and (not v101 and not v78) and 1000 or 8)
	local v117 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v118 = v116 + (not FFlagExtendScrollingFramesBySafeInsets and 0 or v117.bottom)
	local v119 = FFlagCreateConnectionsHub and isFromConnectionsHub(v70)
	local v120 = if not FFlagLuaAppsDefaultSelection then nil else useFocusOnMount()
	local v121 = if not FFlagFriendsPageUserListEnabled then nil else React.useCallback(function(p10, p11, p12) -- line: 375
		-- upvalues: React (copy), FriendTile (copy), v89 (copy), v90 (copy)
		return React.createElement(FriendTile, {
			isPlayerContextualMenuEnabled = nil,
			user = p11,
			createRow = p10,
			index = p12,
			openPlayerProfileHandle = v89,
			pageLoadingTimeReport = v90
		})
	end, {
		v90,
		v89
	})

	return React.createElement("Frame", {
		[Roact.Ref] = v80,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = if not v119 then v72.LuaApps.App.Page.BackgroundColor else nil,
		BackgroundTransparency = if not v119 then v72.LuaApps.App.Page.BackgroundTransparency else 1
	}, {
		HorizontalPageMargin = React.createElement(HorizontalPageMargin, {
			backgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Padding = if not FFlagFixCohubUiBugs then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v76),
				PaddingRight = if not v63 then nil else UDim.new(0, v76)
			}),
			scrollView = React.createElement(RefreshScrollingFrame, {
				scrollingElementProps = {
					Size = UDim2.new(1, 0, 1, -Constants.TOP_BAR_HEIGHT + (FFlagExtendScrollingFramesBySafeInsets and v117.bottom or 0)),
					BackgroundTransparency = 1,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 0,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.XY,
					CanvasPosition = v114,
					[Roact.Event.SelectionChanged] = v115,
					Selectable = not FFlagEnableLeftNavOnConsole and nil
				},
				[Roact.Ref] = v112,
				refresh = v96,
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
				filterByButton = if not v77 then React.createElement(FilterByButton, {
					layoutOrder = 2,
					analytics = v69,
					filter = v68.filter,
					friendCount = if v68.filter ~= filterStates.All then v98 else v99,
					isDisabled = v99 == 0,
					onActivated = if not FFlagConnectionManagementChips then v94 else v95,
					maxWidth = if not FFlagConnectionManagementChips then nil else 640,
					canAccessTrustedContacts = if not FFlagConnectionManagementChips then nil else v84
				}) else nil,
				NoResultsView = if not v101 then nil else React.createElement(EmptyResultsView, {
					layoutOrder = 6
				}),
				NoFriendsView = if not v100 then nil else React.createElement(NoFriendsView, {
					layoutOrder = 6,
					pageLoadingTimeReport = v90,
					openAddFriendsPage = v97
				}),
				UserListLayoutAdaptor = if not FFlagFriendsPageUserListEnabled then nil else if v101 or v100 then nil else React.createElement(UserListLayoutAdaptor, {
					layoutOrder = 6,
					isScrollEnabled = false,
					layoutMode = LayoutMode.Vertical,
					header = {
						title = v67.peopleYouMayKnow
					},
					entities = t1.friends,
					renderRow = v121,
					hasMore = v102,
					onLoadMore = v103
				}),
				FriendsGridView = if not FFlagFriendsPageUserListEnabled then if v101 or v100 then nil else React.createElement(CollectionGrid, {
					LayoutOrder = 6,
					containerRef = if not FFlagLuaAppsDefaultSelection then nil else v120,
					items = t1.friends,
					verticalScrollingFrameRef = v112,
					renderItem = v92,
					getItemHeight = v93,
					numColumns = v110.itemsPerRow,
					columnGap = GridHorizontalSpacing,
					verticalPadding = v104,
					onContainerSizeChanged = v111
				}) else nil,
				showMoreFrame = if not FFlagFriendsPageUserListEnabled then if not v102 then nil else React.createElement("Frame", {
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
						onActivated = v103,
						text = v67.showMore
					})
				}) else nil,
				additionalPadding = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 8,
					Size = UDim2.new(1, 0, 0, v118)
				})
			})
		})
	})
end

return FriendsLandingPage
