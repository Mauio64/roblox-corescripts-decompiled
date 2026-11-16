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
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local fFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local FFlagProfileMomentsLoadFailureAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileMomentsLoadFailureAnalytics")
local defineFastFlag = game:DefineFastFlag("ProfileMomentsGridMeTabTopInset", false)

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local v5 = fFlagProfileMomentsFeedRootRoute or fFlagProfileRenderAvatarMoments

local view = Foundation.View
local iconButton = Foundation.IconButton
local buttonSize = Foundation.Enums.ButtonSize
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local chevronLargeLeft = iconName.ChevronLargeLeft

local frozen = table.freeze({})

local function MomentsGridPage()
	local v6 = useNavigation()

	local v7 = if v5 then useDispatch() else nil

	local param = v6.getParam("extraProps")
	local theme = useStyle().Theme
	local v8 = useTokens()
	local v9 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	local v10 = if fFlagAXEnableProfileTab then useProfileWrapperContext() else nil

	local v11 = if fFlagAXEnableProfileTab then v10.forceFullView == true else nil

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p2)
		return p2.GlobalGuiInset
	end)))
	local v14 = not defineFastFlag and 0 or useStatusBarHeight()
	local v15

	if fFlagProfilePlatformNewProfileHeader then
		v15 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module23(v9)
	else
		v15 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local profileId = if param then param.profileId else nil

	local v17 = useUserProfilesFetch({
		userIds = React.useMemo(function()
			if profileId == nil then
				return {}
			end

			return { profileId }
		end, { profileId }),
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local v18

	if not (v17.data == nil or profileId == nil) then
		v18 = UserProfiles.Selectors.getCombinedNameFromId(v17.data, profileId)
	end

	local v19

	if not (v17.data == nil or profileId == nil) then
		v19 = UserProfiles.Selectors.getUsernameFromId(v17.data, profileId)
	end

	local v20 = useUserMoments(profileId)
	local moments = v20.moments
	local hasMore = v20.hasMore
	local loadMore = v20.loadMore

	local v21 = useLocalization({ feedEndTitle = TextKeys.MomentsFeedEndTitle })
	local v22 = useAppPolicy(function(p2)
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
		if not FFlagProfileMomentsLoadFailureAnalytics and v20.hasFailed and profileId ~= nil then
			fireAnalyticsEvent(eventNames.ProfileLoadFailed, { userId = profileId })
		end
	end, { v20.hasFailed, profileId })

	local v23 = React.useCallback(function()
		v6.goBack()
	end, { v6.goBack })

	local v24 = React.useCallback(function(p2)
		local moment = moments[p2]

		local v25 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "grid", p2)

		if v25 then
			fireAnalyticsEvent(eventNames.ProfileMomentSelected, v25)
		end

		local v26 = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = p2,
			initialMomentId = 0
		}

		local v27 = if fFlagMomentsOptimisticProfilePending and moment ~= nil then moment.momentId else nil
		v26.initialMomentId = v27

		if fFlagMomentsOptimisticProfilePending and ref ~= nil and ref.current ~= nil then
			ref.current.release()
		end

		if not v5 then
			v6.navigate(Enums.Screens.MomentsFeed, { extraProps = v26 })

			return
		end

		local v28 = { name = appPage.ProfileMomentsFeed, extraProps = v26 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v28))
		else
			v7(navigateDown(v28))
		end
	end, { v6, v7, profileId, moments })

	local v25 = React.useCallback(function(p2, p3)
		return React.createElement(MomentGridItem, {
			moment = p2,
			isActive = state == p3,
			userId = profileId,
			index = p3,
			onActivated = function()
				v24(p3)
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
	end, { v24, state, profileId })

	local v26 = React.useCallback(function()
		return React.createElement(view, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})

	local v27 = if not (v19 == nil or v19 == "") then `@{v19}` else nil

	local element = React.createElement(view, {
		Size = UDim2.new(1, 0, 0, 56),
		padding = {
			left = UDim.new(0, v8.Padding.Large),
			right = UDim.new(0, v8.Padding.Large)
		},
		tag = "row align-x-left align-y-center gap-small"
	}, {
		BackButton = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = chevronLargeLeft,
			size = buttonSize.Medium,
			onActivated = v23
		}),
		User = React.createElement(view, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 1, 0),
			tag = "grow"
		}, {
			UserTile = React.createElement(userTile, {
				userId = profileId or "",
				title = v18,
				subtitle = v27,
				layoutMode = layoutMode.wide,
				userPresenceType = nil,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v8.Typography.HeadingSmall,
				subtitleStyle = v8.Typography.BodyMedium,
				isTitleLoading = v18 == nil,
				isSubtitleLoading = v19 == nil
			})
		})
	})

	local v28 = React.useMemo(function(): boolean
		for k, moment in moments do
			local v29

			if fFlagProfileMomentSceneOutfitPoster then
				v29 = isPlayableVideoMoment(moment)
			else
				v29 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v29 then
				return true
			end
		end

		return false
	end, { moments })

	local v29 = useNavigationFocus()

	local v30 = if state ~= nil then moments[state] else nil

	if fFlagProfileMomentSceneOutfitPoster then
		v29 = not (v30 == nil) and (isPlayableVideoMoment(v30) and v29)
	elseif v30 == nil then
		v29 = false
	elseif v30.metadata.captureType ~= Enum.CaptureType.Video then
		v29 = false
	end

	local v31

	if #moments > 0 then
		v31 = React.createElement(Foundation.Text, {
			Text = v21.feedEndTitle,
			tag = "auto-xy padding-large text-body-medium text-align-x-center content-muted"
		})
	end

	local v32 = React.createElement(view, {
		padding = {
			left = UDim.new(0, v8.Padding.Large),
			right = UDim.new(0, v8.Padding.Large),
			top = UDim.new(0, v8.Padding.Large),
			bottom = UDim.new(0, v8.Padding.Large)
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
			renderItem = v25,
			renderEmptyState = v26,
			shouldShowShowMoreButton = hasMore,
			showMoreButtonText = "Show More",
			onShowMoreCallback = loadMore,
			enableInfiniteScroll = v22 and true or nil,
			footer = v31
		})
	})

	if v28 then
		v32 = React.createElement(MomentsCarouselMediaProvider, {
			moments = if v29 then moments else frozen,
			activeIndex = state or 1,
			playbackActive = v29,
			handoffRef = if fFlagMomentsOptimisticProfilePending then ref else nil
		}, { Grid = v32 })
	end

	if fFlagAXEnableProfileTab and v11 then
		return React.createElement(view, {
			backgroundStyle = {
				Color3 = theme.BackgroundDefault.Color,
				Transparency = theme.BackgroundDefault.Transparency
			},
			padding = defineFastFlag and {
				top = UDim.new(0, v14 + v8.Padding.XLarge)
			} or nil,
			tag = defineFastFlag and "col gap-medium size-full" or "col gap-medium size-full padding-top-xlarge"
		}, { Header = element, Grid = v32 })
	end

	if not v9 then
		return React.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency
			},
			{
				Content = React.createElement(view, {
					padding = { top = UDim.new(0, v8.Padding.XLarge) },
					tag = "col gap-medium size-full"
				}, { Header = element, Grid = v32 })
			}
		)
	end

	local v33 = 56 + v8.Padding.XLarge
	return React.createElement(ProfileModalView, {
		topBarHeight = 56,
		viewWidth = v15,
		navigateBack = v23,
		renderTopBar = function()
			return React.createElement(view, {
				Size = UDim2.new(1, 0, 0, v33),
				padding = { top = UDim.new(0, v8.Padding.XLarge) },
				tag = "col"
			}, { Header = element })
		end,
		renderContent = function()
			return React.createElement(view, {
				padding = { top = UDim.new(0, v33) },
				tag = "col size-full"
			}, { Grid = v32 })
		end
	})
end

return MomentsGridPage
