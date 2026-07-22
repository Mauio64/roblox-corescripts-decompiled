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
local MomentsCommon = require(ProfilePlatformParent.MomentsCommon)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
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
local v49 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local ChevronLargeLeft = IconName.ChevronLargeLeft
local v56 = table.freeze({})

local function MomentsGridPage() -- line: 85
	-- upvalues: useNavigation (copy), FFlagProfileMomentsFeedRootRoute (copy), useDispatch (copy), useStyle (copy), useTokens (copy), useProfileFormFactor (copy), Enums (copy), FFlagAXEnableProfileTab (copy), useProfileWrapperContext (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), React (copy), useUserProfilesFetch (copy), UserProfiles (copy), useUserMoments (copy), fireAnalyticsEvent (copy), EventNames (copy), makeProfileTileFields (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v49 (copy), NavigateDown (copy), MomentGridItem (copy), View (copy), IconButton (copy), ChevronLargeLeft (copy), ButtonSize (copy), UserTile (copy), LayoutMode (copy), FFlagProfileMomentsVideoPlaybackFix (copy), useNavigationFocus (copy), ScrollingGridView (copy), MomentsCarouselMediaProvider (copy), v56 (copy), ProfileModalView (copy), FullscreenPageWithSafeArea (copy)
	local v58 = useNavigation()
	local v59 = if not FFlagProfileMomentsFeedRootRoute then nil else useDispatch()
	local v60 = v58.getParam("extraProps")
	local Theme = useStyle().Theme
	local v62 = useTokens()
	local v63 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v64 = if not FFlagAXEnableProfileTab then nil else useProfileWrapperContext()
	local v65 = if not FFlagAXEnableProfileTab then nil else v64.forceFullView == true
	local v66 = useScreenSize()
	local v67 = useSelector(function(p1) -- line: 104
		return p1.GlobalGuiInset
	end)
	local v68 = getSafeAreaSize(v66, v67)
	local v69 = if not FFlagProfilePlatformNewProfileHeader then math.min(v68.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v63) else useProfileCardWidth2()
	local v70 = if not v60 then nil else v60.profileId
	local v71 = React.useMemo(function() -- line: 116
		-- upvalues: v70 (copy)
		if v70 ~= nil then
			return { v70 }
		end

		return {}
	end, { v70 })
	local v72 = useUserProfilesFetch({
		userIds = v71,
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v73 = if v72.data == nil or v70 == nil then nil else UserProfiles.Selectors.getCombinedNameFromId(v72.data, v70)
	local v74 = if v72.data == nil or v70 == nil then nil else UserProfiles.Selectors.getUsernameFromId(v72.data, v70)
	local v75 = useUserMoments(v70)
	local moments = v75.moments
	local hasMore = v75.hasMore
	local loadMore = v75.loadMore
	local v79, v80 = React.useState(nil)
	local v81 = React.useRef(false)

	React.useEffect(function() -- line: 138
		-- upvalues: v81 (copy), moments (copy), v70 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v81.current and (#moments > 0 and v70 ~= nil) then
			v81.current = true
			fireAnalyticsEvent(EventNames.ProfileScreenImpression, {
				userId = v70,
				momentsCount = tostring(#moments)
			})
		end
	end, {
		moments,
		v70
	})
	React.useEffect(function() -- line: 148
		-- upvalues: v75 (copy), v70 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v75.hasFailed and v70 ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, {
				userId = v70
			})
		end
	end, {
		v75.hasFailed,
		v70
	})

	local v82 = React.useCallback(function() -- line: 156
		-- upvalues: v58 (copy)
		v58.goBack()
	end, { v58.goBack })
	local v83 = React.useCallback(function(n1: number) -- line: 160
		-- upvalues: moments (copy), v70 (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames (copy), FFlagProfileMomentsFeedRootRoute (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v49 (copy), v59 (copy), NavigateDown (copy), v58 (copy), Enums (copy)
		local v97 = moments[n1]

		if v97 and v70 then
			local v98 = makeProfileTileFields.makeProfileTileInteractionFields(v97, v70, "grid", n1)

			if v98 then
				fireAnalyticsEvent(EventNames.ProfileMomentSelected, v98)
			end
		end

		local t1 = {
			targetUserId = tonumber(v70) or 0,
			initialIndex = n1
		}

		if FFlagProfileMomentsFeedRootRoute then
			local t2 = {
				name = AppPage.ProfileMomentsFeed,
				extraProps = t1
			}

			if FFlagSignalsNavP3Dispatch then
				v49.down(v49.fromLegacyPage(t2))

				return
			end

			v59(NavigateDown(t2))

			return
		end

		v58.navigate(Enums.Screens.MomentsFeed, {
			extraProps = t1
		})
	end, {
		v58,
		v59,
		v70,
		moments
	})
	local v84 = React.useCallback(function(p2, n2: number) -- line: 190
		-- upvalues: React (copy), MomentGridItem (copy), v79 (copy), v70 (copy), v83 (copy), v80 (copy)
		return React.createElement(MomentGridItem, {
			moment = p2,
			isActive = n2 == v79,
			userId = v70,
			index = n2,
			onActivated = function() -- line: 196
				-- upvalues: v83 (copy), n2 (copy)
				v83(n2)
			end,
			onHoverChanged = function(b1: boolean) -- line: 199
				-- upvalues: v80 (copy), n2 (copy)
				v80(function(n3: number?) -- line: 200
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
		v83,
		v79,
		v70
	})
	local v85 = React.useCallback(function() -- line: 212
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local v86 = if v74 == nil or v74 == "" then nil else `@{ v74 }`
	local v87 = React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v62.Padding.Large),
			right = UDim.new(0, v62.Padding.Large)
		}
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v82
		}),
		User = React.createElement(View, {
			LayoutOrder = 2,
			tag = "grow",
			Size = UDim2.new(0, 0, 1, 0)
		}, {
			UserTile = React.createElement(UserTile, {
				userPresenceType = nil,
				userId = v70 or "",
				title = v73,
				subtitle = v86,
				layoutMode = LayoutMode.wide,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v62.Typography.HeadingSmall,
				subtitleStyle = v62.Typography.BodyMedium,
				isTitleLoading = v73 == nil,
				isSubtitleLoading = v74 == nil
			})
		})
	})
	local v88 = React.useMemo(function() -- line: 254
		-- upvalues: moments (copy)
		for _, v104 in moments do
			if v104.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v89 = not FFlagProfileMomentsVideoPlaybackFix or useNavigationFocus()
	local v90 = if v79 == nil then nil else moments[v79]
	local v91 = v90 ~= nil and (v90.metadata.captureType == Enum.CaptureType.Video and v89)
	local v92 = React.createElement(View, {
		tag = "grow size-full-0",
		padding = {
			left = UDim.new(0, v62.Padding.Large),
			right = UDim.new(0, v62.Padding.Large),
			top = UDim.new(0, v62.Padding.Large),
			bottom = UDim.new(0, v62.Padding.Large)
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
			renderItem = v84,
			renderEmptyState = v85,
			shouldShowShowMoreButton = hasMore,
			onShowMoreCallback = loadMore
		})
	})
	local v93 = if not v88 then v92 else React.createElement(MomentsCarouselMediaProvider, {
		moments = if not v91 then v56 else moments,
		activeIndex = v79 or 1,
		playbackActive = v91
	}, {
		Grid = v92
	})

	if FFlagAXEnableProfileTab and v65 then
		return React.createElement(View, {
			tag = "col gap-medium size-full padding-top-xlarge",
			backgroundStyle = {
				Color3 = Theme.BackgroundDefault.Color,
				Transparency = Theme.BackgroundDefault.Transparency
			}
		}, {
			Header = v87,
			Grid = v93
		})
	end

	if v63 then
		local v94 = 56 + v62.Padding.XLarge

		return React.createElement(ProfileModalView, {
			topBarHeight = 56,
			viewWidth = v69,
			navigateBack = v82,
			renderTopBar = function() -- line: 329
				-- upvalues: React (copy), View (copy), v94 (copy), v62 (copy), v87 (copy)
				return React.createElement(View, {
					tag = "col",
					Size = UDim2.new(1, 0, 0, v94),
					padding = {
						top = UDim.new(0, v62.Padding.XLarge)
					}
				}, {
					Header = v87
				})
			end,
			renderContent = function() -- line: 338
				-- upvalues: React (copy), View (copy), v94 (copy), v93 (copy)
				return React.createElement(View, {
					tag = "col size-full",
					padding = {
						top = UDim.new(0, v94)
					}
				}, {
					Grid = v93
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
				top = UDim.new(0, v62.Padding.XLarge)
			}
		}, {
			Header = v87,
			Grid = v93
		})
	})
end

return MomentsGridPage
