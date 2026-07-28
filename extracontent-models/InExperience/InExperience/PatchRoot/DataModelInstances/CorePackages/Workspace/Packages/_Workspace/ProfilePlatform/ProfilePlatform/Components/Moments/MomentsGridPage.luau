local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local AppBlox = require(ProfilePlatformParent.AppBlox)
local InputUi = require(ProfilePlatformParent.InputUi)
local Navigation = require(ProfilePlatformParent.Navigation)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local Localization = require(ProfilePlatformParent.Localization)
local MomentsCommon = require(ProfilePlatformParent.MomentsCommon)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local useAppPolicy = require(ProfilePlatformParent.UniversalAppPolicy).useAppPolicy
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)
local MomentGridItem = require(script.Parent.MomentGridItem)
local MomentsCarouselMediaProvider = require(script.Parent.MomentsCarouselMediaProvider)

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local ProfileModalView = require(ProfilePlatform.Components.ProfilePlatformViewAdaptor.ProfileModalView)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useUserMoments = require(ProfilePlatform.Hooks.useUserMoments)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local useProfileCardWidth2 = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local UserProfiles = require(ProfilePlatformParent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local UserTile = require(ProfilePlatformParent.UserTile).UserTile
local LayoutMode = require(ProfilePlatformParent.UserTile).LayoutMode
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local ScrollingGridView = MomentsCommon.ScrollingGridView
local useNavigation = Navigation.useNavigation
local useNavigationFocus = Navigation.useNavigationFocus
local useStyle = UIBlox.Core.Style.useStyle
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local getSafeAreaSize = InputUi.getSafeAreaSize
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagProfileMomentsVideoPlaybackFix = SharedFlags.FFlagProfileMomentsVideoPlaybackFix
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local FFlagMomentsProfileGridInfiniteLoad = MomentsCommon.Flags.FFlagMomentsProfileGridInfiniteLoad
local v54 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local ChevronLargeLeft = IconName.ChevronLargeLeft
local v61 = table.freeze({})

local function MomentsGridPage() -- line: 91
	-- upvalues: useNavigation (copy), FFlagProfileMomentsFeedRootRoute (copy), useDispatch (copy), useStyle (copy), useTokens (copy), useProfileFormFactor (copy), Enums (copy), FFlagAXEnableProfileTab (copy), useProfileWrapperContext (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), React (copy), useUserProfilesFetch (copy), UserProfiles (copy), useUserMoments (copy), FFlagMomentsProfileGridInfiniteLoad (copy), useLocalization (copy), TextKeys (copy), useAppPolicy (copy), fireAnalyticsEvent (copy), EventNames (copy), makeProfileTileFields (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v54 (copy), NavigateDown (copy), MomentGridItem (copy), View (copy), IconButton (copy), ChevronLargeLeft (copy), ButtonSize (copy), UserTile (copy), LayoutMode (copy), FFlagProfileMomentsVideoPlaybackFix (copy), useNavigationFocus (copy), Foundation (copy), ScrollingGridView (copy), MomentsCarouselMediaProvider (copy), v61 (copy), ProfileModalView (copy), FullscreenPageWithSafeArea (copy)
	local v63 = useNavigation()
	local v64 = if not FFlagProfileMomentsFeedRootRoute then nil else useDispatch()
	local v65 = v63.getParam("extraProps")
	local Theme = useStyle().Theme
	local v67 = useTokens()
	local v68 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v69 = if not FFlagAXEnableProfileTab then nil else useProfileWrapperContext()
	local v70 = if not FFlagAXEnableProfileTab then nil else v69.forceFullView == true
	local v71 = useScreenSize()
	local v72 = useSelector(function(p1) -- line: 110
		return p1.GlobalGuiInset
	end)
	local v73 = getSafeAreaSize(v71, v72)
	local v74 = if not FFlagProfilePlatformNewProfileHeader then math.min(v73.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v68) else useProfileCardWidth2()
	local v75 = if not v65 then nil else v65.profileId
	local v76 = React.useMemo(function() -- line: 122
		-- upvalues: v75 (copy)
		if v75 ~= nil then
			return { v75 }
		end

		return {}
	end, { v75 })
	local v77 = useUserProfilesFetch({
		userIds = v76,
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v78 = if v77.data == nil or v75 == nil then nil else UserProfiles.Selectors.getCombinedNameFromId(v77.data, v75)
	local v79 = if v77.data == nil or v75 == nil then nil else UserProfiles.Selectors.getUsernameFromId(v77.data, v75)
	local v80 = useUserMoments(v75)
	local moments = v80.moments
	local hasMore = v80.hasMore
	local loadMore = v80.loadMore
	local v84 = nil
	local v85 = false

	if FFlagMomentsProfileGridInfiniteLoad then
		v84 = useLocalization({
			feedEndTitle = TextKeys.MomentsFeedEndTitle
		})
		v85 = useAppPolicy(function(p2) -- line: 147
			return p2.getEnableContinuousLoad()
		end)
	end

	local v86, v87 = React.useState(nil)
	local v88 = React.useRef(false)

	React.useEffect(function() -- line: 156
		-- upvalues: v88 (copy), moments (copy), v75 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v88.current and (#moments > 0 and v75 ~= nil) then
			v88.current = true
			fireAnalyticsEvent(EventNames.ProfileScreenImpression, {
				userId = v75,
				momentsCount = tostring(#moments)
			})
		end
	end, {
		moments,
		v75
	})
	React.useEffect(function() -- line: 166
		-- upvalues: v80 (copy), v75 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v80.hasFailed and v75 ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, {
				userId = v75
			})
		end
	end, {
		v80.hasFailed,
		v75
	})

	local v89 = React.useCallback(function() -- line: 174
		-- upvalues: v63 (copy)
		v63.goBack()
	end, { v63.goBack })
	local v90 = React.useCallback(function(n1: number) -- line: 178
		-- upvalues: moments (copy), v75 (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames (copy), FFlagProfileMomentsFeedRootRoute (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v54 (copy), v64 (copy), NavigateDown (copy), v63 (copy), Enums (copy)
		local v106 = moments[n1]

		if v106 and v75 then
			local v107 = makeProfileTileFields.makeProfileTileInteractionFields(v106, v75, "grid", n1)

			if v107 then
				fireAnalyticsEvent(EventNames.ProfileMomentSelected, v107)
			end
		end

		local t1 = {
			targetUserId = tonumber(v75) or 0,
			initialIndex = n1
		}

		if FFlagProfileMomentsFeedRootRoute then
			local t2 = {
				name = AppPage.ProfileMomentsFeed,
				extraProps = t1
			}

			if FFlagSignalsNavP3Dispatch then
				v54.down(v54.fromLegacyPage(t2))

				return
			end

			v64(NavigateDown(t2))

			return
		end

		v63.navigate(Enums.Screens.MomentsFeed, {
			extraProps = t1
		})
	end, {
		v63,
		v64,
		v75,
		moments
	})
	local v91 = React.useCallback(function(p3, n2: number) -- line: 208
		-- upvalues: React (copy), MomentGridItem (copy), v86 (copy), v75 (copy), v90 (copy), v87 (copy)
		return React.createElement(MomentGridItem, {
			moment = p3,
			isActive = n2 == v86,
			userId = v75,
			index = n2,
			onActivated = function() -- line: 214
				-- upvalues: v90 (copy), n2 (copy)
				v90(n2)
			end,
			onHoverChanged = function(b1: boolean) -- line: 217
				-- upvalues: v87 (copy), n2 (copy)
				v87(function(n3: number?) -- line: 218
					-- upvalues: b1 (copy), n2 (copy)
					if b1 then
						return n2
					end

					if n3 == n2 then
						return nil
					end

					return n3
				end)
			end
		})
	end, {
		v90,
		v86,
		v75
	})
	local v92 = React.useCallback(function() -- line: 230
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local v93 = if v79 == nil or v79 == "" then nil else `@{ v79 }`
	local v94 = React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v67.Padding.Large),
			right = UDim.new(0, v67.Padding.Large)
		}
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v89
		}),
		User = React.createElement(View, {
			LayoutOrder = 2,
			tag = "grow",
			Size = UDim2.new(0, 0, 1, 0)
		}, {
			UserTile = React.createElement(UserTile, {
				userPresenceType = nil,
				userId = v75 or "",
				title = v78,
				subtitle = v93,
				layoutMode = LayoutMode.wide,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v67.Typography.HeadingSmall,
				subtitleStyle = v67.Typography.BodyMedium,
				isTitleLoading = v78 == nil,
				isSubtitleLoading = v79 == nil
			})
		})
	})
	local v95 = React.useMemo(function() -- line: 272
		-- upvalues: moments (copy)
		for _, v113 in moments do
			if v113.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v96 = not FFlagProfileMomentsVideoPlaybackFix or useNavigationFocus()
	local v97 = if v86 == nil then nil else moments[v86]
	local v98 = v97 ~= nil and (v97.metadata.captureType == Enum.CaptureType.Video and v96)
	local v99 = if not FFlagMomentsProfileGridInfiniteLoad or not (#moments > 0) then nil else React.createElement(Foundation.Text, {
		tag = "auto-xy padding-large text-body-medium text-align-x-center content-muted",
		Text = v84.feedEndTitle
	})
	local v100 = React.createElement(View, {
		tag = "grow size-full-0",
		padding = {
			left = UDim.new(0, v67.Padding.Large),
			right = UDim.new(0, v67.Padding.Large),
			top = UDim.new(0, v67.Padding.Large),
			bottom = UDim.new(0, v67.Padding.Large)
		}
	}, {
		ScrollingGridView = React.createElement(ScrollingGridView, {
			aspectRatio = 1.5,
			showMoreButtonText = "Show More",
			items = moments,
			itemConfig = {
				padding = 8,
				maxItemsPerRow = 3,
				minItemsPerPage = 9,
				minItemWidth = 100
			},
			renderItem = v91,
			renderEmptyState = v92,
			shouldShowShowMoreButton = hasMore,
			onShowMoreCallback = loadMore,
			enableInfiniteScroll = not not v85 or nil,
			footer = v99
		})
	})
	local v101 = if not v95 then v100 else React.createElement(MomentsCarouselMediaProvider, {
		moments = if not v98 then v61 else moments,
		activeIndex = v86 or 1,
		playbackActive = v98
	}, {
		Grid = v100
	})

	if FFlagAXEnableProfileTab and v70 then
		return React.createElement(View, {
			tag = "col gap-medium size-full padding-top-xlarge",
			backgroundStyle = {
				Color3 = Theme.BackgroundDefault.Color,
				Transparency = Theme.BackgroundDefault.Transparency
			}
		}, {
			Header = v94,
			Grid = v101
		})
	end

	if v68 then
		local v102 = 56 + v67.Padding.XLarge

		return React.createElement(ProfileModalView, {
			topBarHeight = 56,
			viewWidth = v74,
			navigateBack = v89,
			renderTopBar = function() -- line: 356
				-- upvalues: React (copy), View (copy), v102 (copy), v67 (copy), v94 (copy)
				return React.createElement(View, {
					tag = "col",
					Size = UDim2.new(1, 0, 0, v102),
					padding = {
						top = UDim.new(0, v67.Padding.XLarge)
					}
				}, {
					Header = v94
				})
			end,
			renderContent = function() -- line: 365
				-- upvalues: React (copy), View (copy), v102 (copy), v101 (copy)
				return React.createElement(View, {
					tag = "col size-full",
					padding = {
						top = UDim.new(0, v102)
					}
				}, {
					Grid = v101
				})
			end
		})
	end

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency
	}, {
		Content = React.createElement(View, {
			tag = "col gap-medium size-full",
			padding = {
				top = UDim.new(0, v67.Padding.XLarge)
			}
		}, {
			Header = v94,
			Grid = v101
		})
	})
end

return MomentsGridPage
