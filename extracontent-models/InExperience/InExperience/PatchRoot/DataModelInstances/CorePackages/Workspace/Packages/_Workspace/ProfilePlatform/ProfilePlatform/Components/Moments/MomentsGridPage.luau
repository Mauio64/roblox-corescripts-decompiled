local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local AppBlox = require(ProfilePlatformParent.AppBlox)
local InputUi = require(ProfilePlatformParent.InputUi)
local Navigation = require(ProfilePlatformParent.Navigation)
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
local getSafeAreaSize = InputUi.getSafeAreaSize
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagProfileMomentsVideoPlaybackFix = SharedFlags.FFlagProfileMomentsVideoPlaybackFix
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local ChevronLargeLeft = IconName.ChevronLargeLeft
local v49 = table.freeze({})

local function MomentsGridPage() -- line: 76
	-- upvalues: useNavigation (copy), useStyle (copy), useTokens (copy), useProfileFormFactor (copy), Enums (copy), FFlagAXEnableProfileTab (copy), useProfileWrapperContext (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), React (copy), useUserProfilesFetch (copy), UserProfiles (copy), useUserMoments (copy), fireAnalyticsEvent (copy), EventNames (copy), makeProfileTileFields (copy), MomentGridItem (copy), View (copy), IconButton (copy), ChevronLargeLeft (copy), ButtonSize (copy), UserTile (copy), LayoutMode (copy), FFlagProfileMomentsVideoPlaybackFix (copy), useNavigationFocus (copy), ScrollingGridView (copy), MomentsCarouselMediaProvider (copy), v49 (copy), ProfileModalView (copy), FullscreenPageWithSafeArea (copy)
	local v51 = useNavigation()
	local v52 = v51.getParam("extraProps")
	local Theme = useStyle().Theme
	local v54 = useTokens()
	local v55 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v56 = if not FFlagAXEnableProfileTab then nil else useProfileWrapperContext()
	local v57 = if not FFlagAXEnableProfileTab then nil else v56.forceFullView == true
	local v58 = useScreenSize()
	local v59 = useSelector(function(p1) -- line: 94
		return p1.GlobalGuiInset
	end)
	local v60 = getSafeAreaSize(v58, v59)
	local v61 = if not FFlagProfilePlatformNewProfileHeader then math.min(v60.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v55) else useProfileCardWidth2()
	local v62 = if not v52 then nil else v52.profileId
	local v63 = React.useMemo(function() -- line: 106
		-- upvalues: v62 (copy)
		if v62 ~= nil then
			return { v62 }
		end

		return {}
	end, { v62 })
	local v64 = useUserProfilesFetch({
		userIds = v63,
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v65 = if v64.data == nil or v62 == nil then nil else UserProfiles.Selectors.getCombinedNameFromId(v64.data, v62)
	local v66 = if v64.data == nil or v62 == nil then nil else UserProfiles.Selectors.getUsernameFromId(v64.data, v62)
	local v67 = useUserMoments(v62)
	local moments = v67.moments
	local hasMore = v67.hasMore
	local loadMore = v67.loadMore
	local v71, v72 = React.useState(nil)
	local v73 = React.useRef(false)

	React.useEffect(function() -- line: 128
		-- upvalues: v73 (copy), moments (copy), v62 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v73.current and (#moments > 0 and v62 ~= nil) then
			v73.current = true
			fireAnalyticsEvent(EventNames.ProfileScreenImpression, {
				userId = v62,
				momentsCount = tostring(#moments)
			})
		end
	end, {
		moments,
		v62
	})
	React.useEffect(function() -- line: 138
		-- upvalues: v67 (copy), v62 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v67.hasFailed and v62 ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, {
				userId = v62
			})
		end
	end, {
		v67.hasFailed,
		v62
	})

	local v74 = React.useCallback(function() -- line: 146
		-- upvalues: v51 (copy)
		v51.goBack()
	end, { v51.goBack })
	local v75 = React.useCallback(function(n1: number) -- line: 150
		-- upvalues: moments (copy), v62 (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames (copy), v51 (copy), Enums (copy)
		local v89 = moments[n1]

		if v89 and v62 then
			local v90 = makeProfileTileFields.makeProfileTileInteractionFields(v89, v62, "grid", n1)

			if v90 then
				fireAnalyticsEvent(EventNames.ProfileMomentSelected, v90)
			end
		end

		v51.navigate(Enums.Screens.MomentsFeed, {
			extraProps = {
				targetUserId = tonumber(v62) or 0,
				initialIndex = n1
			}
		})
	end, {
		v51,
		v62,
		moments
	})
	local v76 = React.useCallback(function(p2, n2: number) -- line: 167
		-- upvalues: React (copy), MomentGridItem (copy), v71 (copy), v62 (copy), v75 (copy), v72 (copy)
		return React.createElement(MomentGridItem, {
			moment = p2,
			isActive = n2 == v71,
			userId = v62,
			index = n2,
			onActivated = function() -- line: 173
				-- upvalues: v75 (copy), n2 (copy)
				v75(n2)
			end,
			onHoverChanged = function(b1: boolean) -- line: 176
				-- upvalues: v72 (copy), n2 (copy)
				v72(function(n3: number?) -- line: 177
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
		v75,
		v71,
		v62
	})
	local v77 = React.useCallback(function() -- line: 189
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local v78 = if v66 == nil or v66 == "" then nil else `@{ v66 }`
	local v79 = React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v54.Padding.Large),
			right = UDim.new(0, v54.Padding.Large)
		}
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v74
		}),
		User = React.createElement(View, {
			LayoutOrder = 2,
			tag = "grow",
			Size = UDim2.new(0, 0, 1, 0)
		}, {
			UserTile = React.createElement(UserTile, {
				userPresenceType = nil,
				userId = v62 or "",
				title = v65,
				subtitle = v78,
				layoutMode = LayoutMode.wide,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v54.Typography.HeadingSmall,
				subtitleStyle = v54.Typography.BodyMedium,
				isTitleLoading = v65 == nil,
				isSubtitleLoading = v66 == nil
			})
		})
	})
	local v80 = React.useMemo(function() -- line: 231
		-- upvalues: moments (copy)
		for _, v94 in moments do
			if v94.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v81 = not FFlagProfileMomentsVideoPlaybackFix or useNavigationFocus()
	local v82 = if v71 == nil then nil else moments[v71]
	local v83 = v82 ~= nil and (v82.metadata.captureType == Enum.CaptureType.Video and v81)
	local v84 = React.createElement(View, {
		tag = "grow size-full-0",
		padding = {
			left = UDim.new(0, v54.Padding.Large),
			right = UDim.new(0, v54.Padding.Large),
			top = UDim.new(0, v54.Padding.Large),
			bottom = UDim.new(0, v54.Padding.Large)
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
			renderItem = v76,
			renderEmptyState = v77,
			shouldShowShowMoreButton = hasMore,
			onShowMoreCallback = loadMore
		})
	})
	local v85 = if not v80 then v84 else React.createElement(MomentsCarouselMediaProvider, {
		moments = if not v83 then v49 else moments,
		activeIndex = v71 or 1,
		playbackActive = v83
	}, {
		Grid = v84
	})

	if FFlagAXEnableProfileTab and v57 then
		return React.createElement(View, {
			tag = "col gap-medium size-full padding-top-xlarge",
			backgroundStyle = {
				Color3 = Theme.BackgroundDefault.Color,
				Transparency = Theme.BackgroundDefault.Transparency
			}
		}, {
			Header = v79,
			Grid = v85
		})
	end

	if v55 then
		local v86 = 56 + v54.Padding.XLarge

		return React.createElement(ProfileModalView, {
			topBarHeight = 56,
			viewWidth = v61,
			navigateBack = v74,
			renderTopBar = function() -- line: 306
				-- upvalues: React (copy), View (copy), v86 (copy), v54 (copy), v79 (copy)
				return React.createElement(View, {
					tag = "col",
					Size = UDim2.new(1, 0, 0, v86),
					padding = {
						top = UDim.new(0, v54.Padding.XLarge)
					}
				}, {
					Header = v79
				})
			end,
			renderContent = function() -- line: 315
				-- upvalues: React (copy), View (copy), v86 (copy), v85 (copy)
				return React.createElement(View, {
					tag = "col size-full",
					padding = {
						top = UDim.new(0, v86)
					}
				}, {
					Grid = v85
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
				top = UDim.new(0, v54.Padding.XLarge)
			}
		}, {
			Header = v79,
			Grid = v85
		})
	})
end

return MomentsGridPage
