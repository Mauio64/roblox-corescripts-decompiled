local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local AppBlox = require(parent.AppBlox)
local InputUi = require(parent.InputUi)
local Navigation = require(parent.Navigation)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)

local MomentGridItem = require(script.Parent.MomentGridItem)
local MomentsCarouselMediaProvider = require(script.Parent.MomentsCarouselMediaProvider)
require(parent.DataHydration.MomentsStoreTypes)
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local ProfileModalView = require(ProfilePlatform.Components.ProfilePlatformViewAdaptor.ProfileModalView)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useUserMoments = require(ProfilePlatform.Hooks.useUserMoments)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth2 = ProfilePlatformCommon.Hooks.useProfileCardWidth

local UserProfiles = require(parent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode

local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local ScrollingGridView = MomentsCommon.ScrollingGridView
local useNavigation = Navigation.useNavigation
local useNavigationFocus = Navigation.useNavigationFocus
local useStyle = UIBlox.Core.Style.useStyle
local useScreenSize = RobloxAppHooks.useScreenSize
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local getSafeAreaSize = InputUi.getSafeAreaSize

local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local isPlayableVideoMoment = require(script.Parent.isPlayableVideoMoment)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local FFlagProfileMomentsLoadFailureAnalytics = require(ProfilePlatform.Flags.FFlagProfileMomentsLoadFailureAnalytics)
local defineFastFlag = game:DefineFastFlag("ProfileMomentsGridMeTabTopInset", false)
local v = FFlagProfileMomentsFeedRootRoute
	and FFlagEnableArgus
	and FFlagEnableArgusImmersiveNav
	and FFlagProfileRenderAvatarMoments
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local v2 = FFlagProfileMomentsFeedRootRoute or FFlagProfileRenderAvatarMoments

local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local ChevronLargeLeft = IconName.ChevronLargeLeft

local frozen = table.freeze({})

local function MomentsGridPage()
	local v3 = useNavigation()
	local v4

	if v2 then
		v4 = useDispatch()
	else
		v4 = nil
	end

	local param = v3.getParam("extraProps")
	local theme = useStyle().Theme
	local v5 = useTokens()
	local v6 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v7

	if FFlagAXEnableProfileTab then
		v7 = useProfileWrapperContext()
	end

	local v8

	if FFlagAXEnableProfileTab then
		v8 = v7.forceFullView == true
	end

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p)
		return p.GlobalGuiInset
	end)))
	local v9 = not defineFastFlag and 0 or useStatusBarHeight()
	local viewWidth

	if FFlagProfilePlatformNewProfileHeader then
		if FFlagSwitchProfileWidthHookToSocialCommon then
			viewWidth = useProfileCardWidth2()
		else
			viewWidth = useProfileCardWidth(v6)
		end
	else
		viewWidth = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local profileId

	if param then
		profileId = param.profileId
	else
		profileId = nil
	end

	local v10 = useUserProfilesFetch({
		userIds = React.useMemo(function()
			if profileId == nil then
				return {}
			end

			return { profileId }
		end, { profileId }),
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local title

	if not (v10.data == nil or profileId == nil) then
		title = UserProfiles.Selectors.getCombinedNameFromId(v10.data, profileId)
	end

	local v11

	if not (v10.data == nil or profileId == nil) then
		v11 = UserProfiles.Selectors.getUsernameFromId(v10.data, profileId)
	end

	local v12 = useUserMoments(profileId)
	local moments = v12.moments
	local hasMore = v12.hasMore
	local loadMore = v12.loadMore

	local v13 = useLocalization({ feedEndTitle = TextKeys.MomentsFeedEndTitle })
	local v14 = useAppPolicy(function(p)
		return p.getEnableContinuousLoad()
	end)

	local state, setState = React.useState(nil)
	local ref

	if FFlagMomentsOptimisticProfilePending then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if not ref2.current and #moments > 0 and profileId ~= nil then
			ref2.current = true
			fireAnalyticsEvent(EventNames.ProfileScreenImpression, {
				userId = profileId,
				momentsCount = tostring(#moments)
			})
		end
	end, { moments, profileId })

	React.useEffect(function()
		if not FFlagProfileMomentsLoadFailureAnalytics and v12.hasFailed and profileId ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, { userId = profileId })
		end
	end, { v12.hasFailed, profileId })

	local v15 = React.useCallback(function()
		v3.goBack()
	end, { v3.goBack })

	local v16 = React.useCallback(function(initialIndex: number)
		local moment = moments[initialIndex]

		local v16 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "grid", initialIndex)

		if v16 then
			fireAnalyticsEvent(EventNames.ProfileMomentSelected, v16)
		end

		local extraProps = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = initialIndex,
			initialMomentId = 0
		}
		local initialMomentId

		if FFlagMomentsOptimisticProfilePending and moment ~= nil then
			initialMomentId = moment.momentId
		end

		extraProps.initialMomentId = initialMomentId

		if FFlagMomentsOptimisticProfilePending and ref ~= nil and ref.current ~= nil then
			ref.current.release()
		end

		if not v2 then
			v3.navigate(Enums.Screens.MomentsFeed, { extraProps = extraProps })

			return
		end

		local name

		if v then
			name = AppPage.MomentsImmersive
		else
			name = AppPage.ProfileMomentsFeed
		end

		local v17 = { name = name, extraProps = extraProps }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v17))
		else
			v4(NavigateDown(v17))
		end
	end, { v3, v4, profileId, moments })

	local renderItem = React.useCallback(function(moment, p: number)
		return React.createElement(MomentGridItem, {
			moment = moment,
			isActive = state == p,
			userId = profileId,
			index = p,
			onActivated = function()
				v16(p)
			end,
			onHoverChanged = function(flag: boolean)
				setState(function(p2: number?)
					if flag then
						return p
					end

					return if p2 ~= p then p2 else nil
				end)
			end
		})
	end, { v16, state, profileId })

	local renderEmptyState = React.useCallback(function()
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local subtitle

	if not (v11 == nil or v11 == "") then
		subtitle = `@{v11}`
	end

	local element = React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 56),
		padding = { left = UDim.new(0, v5.Padding.Large), right = UDim.new(0, v5.Padding.Large) },
		tag = "row align-x-left align-y-center gap-small"
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v15
		}),
		User = React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 1, 0),
			tag = "grow"
		}, {
			UserTile = React.createElement(userTile, {
				userId = profileId or "",
				title = title,
				subtitle = subtitle,
				layoutMode = LayoutMode.wide,
				userPresenceType = nil,
				avatarSize = UDim2.fromOffset(40, 40),
				titleStyle = v5.Typography.HeadingSmall,
				subtitleStyle = v5.Typography.BodyMedium,
				isTitleLoading = title == nil,
				isSubtitleLoading = v11 == nil
			})
		})
	})

	local v17 = React.useMemo(function(): boolean
		for _, moment in moments do
			local v17

			if FFlagProfileMomentSceneOutfitPoster then
				v17 = isPlayableVideoMoment(moment)
			else
				v17 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v17 then
				return true
			end
		end

		return false
	end, { moments })

	local playbackActive = useNavigationFocus()
	local v18

	if state ~= nil then
		v18 = moments[state]
	end

	if FFlagProfileMomentSceneOutfitPoster then
		if v18 == nil then
			playbackActive = false
		else
			playbackActive = isPlayableVideoMoment(v18) and playbackActive
		end
	elseif v18 == nil then
		playbackActive = false
	elseif v18.metadata.captureType ~= Enum.CaptureType.Video then
		playbackActive = false
	end

	local footer

	if #moments > 0 then
		footer = React.createElement(Foundation.Text, {
			Text = v13.feedEndTitle,
			tag = "auto-xy padding-large text-body-medium text-align-x-center content-muted"
		})
	end

	local grid = React.createElement(View, {
		padding = {
			left = UDim.new(0, v5.Padding.Large),
			right = UDim.new(0, v5.Padding.Large),
			top = UDim.new(0, v5.Padding.Large),
			bottom = UDim.new(0, v5.Padding.Large)
		},
		tag = "grow size-full-0"
	}, {
		ScrollingGridView = React.createElement(ScrollingGridView, {
			aspectRatio = 1.5,
			items = moments,
			itemConfig = {
				padding = 8,
				maxItemsPerRow = 3,
				minItemsPerPage = 9,
				minItemWidth = 100
			},
			renderItem = renderItem,
			renderEmptyState = renderEmptyState,
			shouldShowShowMoreButton = hasMore,
			showMoreButtonText = "Show More",
			onShowMoreCallback = loadMore,
			enableInfiniteScroll = v14 and true or nil,
			footer = footer
		})
	})

	if v17 then
		local createElement = React.createElement
		local moments2 = if playbackActive then moments else frozen
		local v19 = {
			moments = moments2,
			activeIndex = state or 1,
			playbackActive = playbackActive,
			handoffRef = nil
		}
		local handoffRef

		if FFlagMomentsOptimisticProfilePending then
			handoffRef = ref
		end

		v19.handoffRef = handoffRef
		grid = createElement(MomentsCarouselMediaProvider, v19, { Grid = grid })
	end

	if FFlagAXEnableProfileTab and v8 then
		return React.createElement(View, {
			backgroundStyle = {
				Color3 = theme.BackgroundDefault.Color,
				Transparency = theme.BackgroundDefault.Transparency
			},
			padding = defineFastFlag and {
				top = UDim.new(0, v9 + v5.Padding.XLarge)
			} or nil,
			tag = defineFastFlag and "col gap-medium size-full" or "col gap-medium size-full padding-top-xlarge"
		}, { Header = element, Grid = grid })
	end

	if not v6 then
		return React.createElement(
			FullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency
			},
			{
				Content = React.createElement(View, {
					padding = { top = UDim.new(0, v5.Padding.XLarge) },
					tag = "col gap-medium size-full"
				}, { Header = element, Grid = grid })
			}
		)
	end

	local v19 = 56 + v5.Padding.XLarge
	return React.createElement(ProfileModalView, {
		topBarHeight = 56,
		viewWidth = viewWidth,
		navigateBack = v15,
		renderTopBar = function()
			return React.createElement(View, {
				Size = UDim2.new(1, 0, 0, v19),
				padding = { top = UDim.new(0, v5.Padding.XLarge) },
				tag = "col"
			}, { Header = element })
		end,
		renderContent = function()
			return React.createElement(View, {
				padding = { top = UDim.new(0, v19) },
				tag = "col size-full"
			}, { Grid = grid })
		end
	})
end

return MomentsGridPage
