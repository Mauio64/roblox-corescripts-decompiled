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
local v48 = table.freeze({})

local function MomentsGridPage() -- line: 75
	-- upvalues: useNavigation (copy), useStyle (copy), useTokens (copy), useProfileFormFactor (copy), Enums (copy), FFlagAXEnableProfileTab (copy), useProfileWrapperContext (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), React (copy), useUserProfilesFetch (copy), UserProfiles (copy), useUserMoments (copy), fireAnalyticsEvent (copy), EventNames (copy), MomentGridItem (copy), View (copy), IconButton (copy), ChevronLargeLeft (copy), ButtonSize (copy), UserTile (copy), LayoutMode (copy), FFlagProfileMomentsVideoPlaybackFix (copy), useNavigationFocus (copy), ScrollingGridView (copy), MomentsCarouselMediaProvider (copy), v48 (copy), ProfileModalView (copy), FullscreenPageWithSafeArea (copy)
	local v50 = useNavigation()
	local v51 = v50.getParam("extraProps")
	local Theme = useStyle().Theme
	local v53 = useTokens()
	local v54 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v55 = if not FFlagAXEnableProfileTab then nil else useProfileWrapperContext()
	local v56 = if not FFlagAXEnableProfileTab then nil else v55.forceFullView == true
	local v57 = useScreenSize()
	local v58 = useSelector(function(p1) -- line: 93
		return p1.GlobalGuiInset
	end)
	local v59 = getSafeAreaSize(v57, v58)
	local v60 = if not FFlagProfilePlatformNewProfileHeader then math.min(v59.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v54) else useProfileCardWidth2()
	local v61 = if not v51 then nil else v51.profileId
	local v62 = React.useMemo(function() -- line: 105
		-- upvalues: v61 (copy)
		if v61 ~= nil then
			return { v61 }
		end

		return {}
	end, { v61 })
	local v63 = useUserProfilesFetch({
		userIds = v62,
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v64 = if v63.data == nil or v61 == nil then nil else UserProfiles.Selectors.getCombinedNameFromId(v63.data, v61)
	local v65 = if v63.data == nil or v61 == nil then nil else UserProfiles.Selectors.getUsernameFromId(v63.data, v61)
	local v66 = useUserMoments(v61)
	local moments = v66.moments
	local hasMore = v66.hasMore
	local loadMore = v66.loadMore
	local v70, v71 = React.useState(nil)
	local v72 = React.useRef(false)

	React.useEffect(function() -- line: 127
		-- upvalues: v72 (copy), moments (copy), v61 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v72.current and (#moments > 0 and v61 ~= nil) then
			v72.current = true
			fireAnalyticsEvent(EventNames.ProfileScreenImpression, {
				userId = v61,
				momentsCount = tostring(#moments)
			})
		end
	end, {
		moments,
		v61
	})
	React.useEffect(function() -- line: 137
		-- upvalues: v66 (copy), v61 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v66.hasFailed and v61 ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, {
				userId = v61
			})
		end
	end, {
		v66.hasFailed,
		v61
	})

	local v73 = React.useCallback(function() -- line: 145
		-- upvalues: v50 (copy)
		v50.goBack()
	end, { v50.goBack })
	local v74 = React.useCallback(function(n1: number) -- line: 149
		-- upvalues: moments (copy), v61 (copy), fireAnalyticsEvent (copy), EventNames (copy), v50 (copy), Enums (copy)
		local v88 = moments[n1]

		if v88 and v61 then
			local recommendationMetadata = v88.recommendationMetadata

			fireAnalyticsEvent(EventNames.ProfileMomentSelected, {
				userId = v61,
				itemId = not recommendationMetadata and "" or (recommendationMetadata.itemId or ""),
				gridIndex = tostring(n1)
			})
		end

		v50.navigate(Enums.Screens.MomentsFeed, {
			extraProps = {
				targetUserId = tonumber(v61) or 0,
				initialIndex = n1
			}
		})
	end, {
		v50,
		v61,
		moments
	})
	local v75 = React.useCallback(function(p2, n2: number) -- line: 167
		-- upvalues: React (copy), MomentGridItem (copy), v70 (copy), v61 (copy), v74 (copy), v71 (copy)
		return React.createElement(MomentGridItem, {
			moment = p2,
			isActive = n2 == v70,
			userId = v61,
			index = n2,
			onActivated = function() -- line: 173
				-- upvalues: v74 (copy), n2 (copy)
				v74(n2)
			end,
			onHoverChanged = function(b1: boolean) -- line: 176
				-- upvalues: v71 (copy), n2 (copy)
				v71(function(n3: number?) -- line: 177
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
		v74,
		v70,
		v61
	})
	local v76 = React.useCallback(function() -- line: 189
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local v77 = if v65 == nil or v65 == "" then nil else `@{ v65 }`
	local v78 = React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v53.Padding.Large),
			right = UDim.new(0, v53.Padding.Large)
		}
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v73
		}),
		User = React.createElement(View, {
			LayoutOrder = 2,
			tag = "grow",
			Size = UDim2.new(0, 0, 1, 0)
		}, {
			UserTile = React.createElement(UserTile, {
				userPresenceType = nil,
				userId = v61 or "",
				title = v64,
				subtitle = v77,
				layoutMode = LayoutMode.wide,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v53.Typography.HeadingSmall,
				subtitleStyle = v53.Typography.BodyMedium,
				isTitleLoading = v64 == nil,
				isSubtitleLoading = v65 == nil
			})
		})
	})
	local v79 = React.useMemo(function() -- line: 231
		-- upvalues: moments (copy)
		for _, v93 in moments do
			if v93.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v80 = not FFlagProfileMomentsVideoPlaybackFix or useNavigationFocus()
	local v81 = if v70 == nil then nil else moments[v70]
	local v82 = v81 ~= nil and (v81.metadata.captureType == Enum.CaptureType.Video and v80)
	local v83 = React.createElement(View, {
		tag = "grow size-full-0",
		padding = {
			left = UDim.new(0, v53.Padding.Large),
			right = UDim.new(0, v53.Padding.Large),
			top = UDim.new(0, v53.Padding.Large),
			bottom = UDim.new(0, v53.Padding.Large)
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
			renderItem = v75,
			renderEmptyState = v76,
			shouldShowShowMoreButton = hasMore,
			onShowMoreCallback = loadMore
		})
	})
	local v84 = if not v79 then v83 else React.createElement(MomentsCarouselMediaProvider, {
		moments = if not v82 then v48 else moments,
		activeIndex = v70 or 1,
		playbackActive = v82
	}, {
		Grid = v83
	})

	if FFlagAXEnableProfileTab and v56 then
		return React.createElement(View, {
			tag = "col gap-medium size-full padding-top-xlarge",
			backgroundStyle = {
				Color3 = Theme.BackgroundDefault.Color,
				Transparency = Theme.BackgroundDefault.Transparency
			}
		}, {
			Header = v78,
			Grid = v84
		})
	end

	if v54 then
		local v85 = 56 + v53.Padding.XLarge

		return React.createElement(ProfileModalView, {
			topBarHeight = 56,
			viewWidth = v60,
			navigateBack = v73,
			renderTopBar = function() -- line: 306
				-- upvalues: React (copy), View (copy), v85 (copy), v53 (copy), v78 (copy)
				return React.createElement(View, {
					tag = "col",
					Size = UDim2.new(1, 0, 0, v85),
					padding = {
						top = UDim.new(0, v53.Padding.XLarge)
					}
				}, {
					Header = v78
				})
			end,
			renderContent = function() -- line: 315
				-- upvalues: React (copy), View (copy), v85 (copy), v84 (copy)
				return React.createElement(View, {
					tag = "col size-full",
					padding = {
						top = UDim.new(0, v85)
					}
				}, {
					Grid = v84
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
				top = UDim.new(0, v53.Padding.XLarge)
			}
		}, {
			Header = v78,
			Grid = v84
		})
	})
end

return MomentsGridPage
