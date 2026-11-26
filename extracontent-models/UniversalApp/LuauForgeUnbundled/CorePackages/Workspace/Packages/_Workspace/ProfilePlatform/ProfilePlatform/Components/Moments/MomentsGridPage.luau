local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppBlox")
local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputUi")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UniversalAppPolicy").useAppPolicy
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local eventNames = analytics.EventNames
local makeProfileTileFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/makeProfileTileFields")

local MomentGridItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentGridItem")
local MomentsCarouselMediaProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsCarouselMediaProvider")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local ProfileModalView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformViewAdaptor/ProfileModalView")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useUserMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useUserMoments")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local module23 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCardWidth")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").LayoutMode

local fullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local scrollingGridView = MomentsCommon.ScrollingGridView
local useNavigation = Navigation.useNavigation
local useNavigationFocus = Navigation.useNavigationFocus
local useStyle = UIBlox.Core.Style.useStyle
local useScreenSize = RobloxAppHooks.useScreenSize
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local navigateDown = NavigationRodux.Thunks.NavigateDown
local getSafeAreaSize = InputUi.getSafeAreaSize

local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local fFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local isPlayableVideoMoment = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/isPlayableVideoMoment")
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local fFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local FFlagProfileMomentsLoadFailureAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileMomentsLoadFailureAnalytics")
local defineFastFlag = game:DefineFastFlag("ProfileMomentsGridMeTabTopInset", false)
local v5 = fFlagProfileMomentsFeedRootRoute
	and fFlagEnableArgus
	and fFlagEnableArgusImmersiveNav
	and fFlagProfileRenderAvatarMoments
local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local v6 = fFlagProfileMomentsFeedRootRoute or fFlagProfileRenderAvatarMoments

local view = Foundation.View
local iconButton = Foundation.IconButton
local buttonSize = Foundation.Enums.ButtonSize
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local chevronLargeLeft = iconName.ChevronLargeLeft

local frozen = table.freeze({})

local function MomentsGridPage()
	local v7 = useNavigation()

	local v8 = if v6 then useDispatch() else nil

	local param = v7.getParam("extraProps")
	local theme = useStyle().Theme
	local v9 = useTokens()
	local v10 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	local v11 = if fFlagAXEnableProfileTab then useProfileWrapperContext() else nil

	local v12 = if fFlagAXEnableProfileTab then v11.forceFullView == true else nil

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p2)
		return p2.GlobalGuiInset
	end)))
	local v15 = not defineFastFlag and 0 or useStatusBarHeight()
	local v16

	if fFlagProfilePlatformNewProfileHeader then
		v16 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module23(v10)
	else
		v16 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local profileId = if param then param.profileId else nil

	local v18 = useUserProfilesFetch({
		userIds = React.useMemo(function()
			if profileId == nil then
				return {}
			end

			return { profileId }
		end, { profileId }),
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v19

	if not (v18.data == nil or profileId == nil) then
		v19 = UserProfiles.Selectors.getCombinedNameFromId(v18.data, profileId)
	end

	local v20

	if not (v18.data == nil or profileId == nil) then
		v20 = UserProfiles.Selectors.getUsernameFromId(v18.data, profileId)
	end

	local v21 = useUserMoments(profileId)
	local moments = v21.moments
	local hasMore = v21.hasMore
	local loadMore = v21.loadMore

	local v22 = useLocalization({ feedEndTitle = TextKeys.MomentsFeedEndTitle })
	local v23 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local state, setState = React.useState(nil)

	local ref = if fFlagMomentsOptimisticProfilePending then React.useRef(nil) else nil

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if not ref2.current and #moments > 0 and profileId ~= nil then
			ref2.current = true
			fireAnalyticsEvent(eventNames.ProfileScreenImpression, {
				userId = profileId,
				momentsCount = tostring(#moments)
			})
		end
	end, { moments, profileId })

	React.useEffect(function()
		if not FFlagProfileMomentsLoadFailureAnalytics and v21.hasFailed and profileId ~= nil then
			fireAnalyticsEvent(eventNames.ProfileLoadFailed, { userId = profileId })
		end
	end, { v21.hasFailed, profileId })

	local v24 = React.useCallback(function()
		v7.goBack()
	end, { v7.goBack })

	local v25 = React.useCallback(function(p2)
		local moment = moments[p2]

		local v26 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "grid", p2)

		if v26 then
			fireAnalyticsEvent(eventNames.ProfileMomentSelected, v26)
		end

		local v27 = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = p2,
			initialMomentId = 0
		}

		local v28 = if fFlagMomentsOptimisticProfilePending and moment ~= nil then moment.momentId else nil
		v27.initialMomentId = v28

		if fFlagMomentsOptimisticProfilePending and ref ~= nil and ref.current ~= nil then
			ref.current.release()
		end

		if not v6 then
			v7.navigate(Enums.Screens.MomentsFeed, { extraProps = v27 })

			return
		end

		local v30 = if v5 then appPage.MomentsImmersive else appPage.ProfileMomentsFeed
		local v29 = { name = v30, extraProps = v27 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v29))
		else
			v8(navigateDown(v29))
		end
	end, { v7, v8, profileId, moments })

	local v26 = React.useCallback(function(p2, p3)
		return React.createElement(MomentGridItem, {
			moment = p2,
			isActive = state == p3,
			userId = profileId,
			index = p3,
			onActivated = function()
				v25(p3)
			end,
			onHoverChanged = function(p4)
				setState(function(p5)
					if p4 then
						return p3
					end

					if p5 == p3 then
						return nil
					end

					return p5
				end)
			end
		})
	end, { v25, state, profileId })

	local v27 = React.useCallback(function()
		return React.createElement(view, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})

	local v28 = if not (v20 == nil or v20 == "") then `@{v20}` else nil

	local element = React.createElement(view, {
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v9.Padding.Large),
			right = UDim.new(0, v9.Padding.Large)
		},
		tag = "row align-x-left align-y-center gap-small"
	}, {
		BackButton = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = chevronLargeLeft,
			size = buttonSize.Medium,
			onActivated = v24
		}),
		User = React.createElement(view, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 1, 0),
			tag = "grow"
		}, {
			UserTile = React.createElement(userTile, {
				userId = profileId or "",
				title = v19,
				subtitle = v28,
				layoutMode = layoutMode.wide,
				userPresenceType = nil,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v9.Typography.HeadingSmall,
				subtitleStyle = v9.Typography.BodyMedium,
				isTitleLoading = v19 == nil,
				isSubtitleLoading = v20 == nil
			})
		})
	})

	local v29 = React.useMemo(function(): boolean
		for k, moment in moments do
			local v30

			if fFlagProfileMomentSceneOutfitPoster then
				v30 = isPlayableVideoMoment(moment)
			else
				v30 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v30 then
				return true
			end
		end

		return false
	end, { moments })

	local v30 = useNavigationFocus()

	local v31 = if state ~= nil then moments[state] else nil

	if fFlagProfileMomentSceneOutfitPoster then
		v30 = not (v31 == nil) and (isPlayableVideoMoment(v31) and v30)
	elseif v31 == nil then
		v30 = false
	elseif v31.metadata.captureType ~= Enum.CaptureType.Video then
		v30 = false
	end

	local v32

	if #moments > 0 then
		v32 = React.createElement(Foundation.Text, {
			Text = v22.feedEndTitle,
			tag = "auto-xy padding-large text-body-medium text-align-x-center content-muted"
		})
	end

	local v33 = React.createElement(view, {
		padding = {
			left = UDim.new(0, v9.Padding.Large),
			right = UDim.new(0, v9.Padding.Large),
			top = UDim.new(0, v9.Padding.Large),
			bottom = UDim.new(0, v9.Padding.Large)
		},
		tag = "grow size-full-0"
	}, {
		ScrollingGridView = React.createElement(scrollingGridView, {
			aspectRatio = 1.5,
			items = moments,
			itemConfig = {
				padding = 8,
				maxItemsPerRow = 3,
				minItemsPerPage = 9,
				minItemWidth = 100
			},
			renderItem = v26,
			renderEmptyState = v27,
			shouldShowShowMoreButton = hasMore,
			showMoreButtonText = "Show More",
			onShowMoreCallback = loadMore,
			enableInfiniteScroll = v23 and true or nil,
			footer = v32
		})
	})

	if v29 then
		v33 = React.createElement(MomentsCarouselMediaProvider, {
			moments = if v30 then moments else frozen,
			activeIndex = state or 1,
			playbackActive = v30,
			handoffRef = if fFlagMomentsOptimisticProfilePending then ref else nil
		}, { Grid = v33 })
	end

	if fFlagAXEnableProfileTab and v12 then
		return React.createElement(view, {
			backgroundStyle = {
				Color3 = theme.BackgroundDefault.Color,
				Transparency = theme.BackgroundDefault.Transparency
			},
			padding = defineFastFlag and {
				top = UDim.new(0, v15 + v9.Padding.XLarge)
			} or nil,
			tag = defineFastFlag and "col gap-medium size-full" or "col gap-medium size-full padding-top-xlarge"
		}, { Header = element, Grid = v33 })
	end

	if not v10 then
		return React.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency
			},
			{
				Content = React.createElement(view, {
					padding = { top = UDim.new(0, v9.Padding.XLarge) },
					tag = "col gap-medium size-full"
				}, { Header = element, Grid = v33 })
			}
		)
	end

	local v34 = 56 + v9.Padding.XLarge
	return React.createElement(ProfileModalView, {
		topBarHeight = 56,
		viewWidth = v16,
		navigateBack = v24,
		renderTopBar = function()
			return React.createElement(view, {
				Size = UDim2.new(1, 0, 0, v34),
				padding = { top = UDim.new(0, v9.Padding.XLarge) },
				tag = "col"
			}, { Header = element })
		end,
		renderContent = function()
			return React.createElement(view, {
				padding = { top = UDim.new(0, v34) },
				tag = "col size-full"
			}, { Grid = v33 })
		end
	})
end

return MomentsGridPage
