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
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local FFlagProfileMomentsLoadFailureAnalytics = require(ProfilePlatform.Flags.FFlagProfileMomentsLoadFailureAnalytics)
local defineFastFlag = game:DefineFastFlag("ProfileMomentsGridMeTabTopInset", false)
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local v = FFlagProfileMomentsFeedRootRoute or FFlagProfileRenderAvatarMoments

local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local ChevronLargeLeft = IconName.ChevronLargeLeft

local frozen = table.freeze({})

local function MomentsGridPage()
	local v2 = useNavigation()
	local v3

	if v then
		v3 = useDispatch()
	else
		v3 = nil
	end

	local param = v2.getParam("extraProps")
	local theme = useStyle().Theme
	local v4 = useTokens()
	local v5 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v6

	if FFlagAXEnableProfileTab then
		v6 = useProfileWrapperContext()
	end

	local v7

	if FFlagAXEnableProfileTab then
		v7 = v6.forceFullView == true
	end

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p)
		return p.GlobalGuiInset
	end)))
	local v8 = not defineFastFlag and 0 or useStatusBarHeight()
	local viewWidth

	if FFlagProfilePlatformNewProfileHeader then
		if FFlagSwitchProfileWidthHookToSocialCommon then
			viewWidth = useProfileCardWidth2()
		else
			viewWidth = useProfileCardWidth(v5)
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

	local v9 = useUserProfilesFetch({
		userIds = React.useMemo(function()
			if profileId == nil then
				return {}
			end

			return { profileId }
		end, { profileId }),
		query = UserProfiles.Queries.userProfilesCombinedNameUsernameAndIsVerifiedByUserIds
	})
	local title

	if not (v9.data == nil or profileId == nil) then
		title = UserProfiles.Selectors.getCombinedNameFromId(v9.data, profileId)
	end

	local v10

	if not (v9.data == nil or profileId == nil) then
		v10 = UserProfiles.Selectors.getUsernameFromId(v9.data, profileId)
	end

	local v11 = useUserMoments(profileId)
	local moments = v11.moments
	local hasMore = v11.hasMore
	local loadMore = v11.loadMore

	local v12 = useLocalization({ feedEndTitle = TextKeys.MomentsFeedEndTitle })
	local v13 = useAppPolicy(function(p)
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
		if not FFlagProfileMomentsLoadFailureAnalytics and v11.hasFailed and profileId ~= nil then
			fireAnalyticsEvent(EventNames.ProfileLoadFailed, { userId = profileId })
		end
	end, { v11.hasFailed, profileId })

	local v14 = React.useCallback(function()
		v2.goBack()
	end, { v2.goBack })

	local v15 = React.useCallback(function(initialIndex: number)
		local moment = moments[initialIndex]

		local v15 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "grid", initialIndex)

		if v15 then
			fireAnalyticsEvent(EventNames.ProfileMomentSelected, v15)
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

		if not v then
			v2.navigate(Enums.Screens.MomentsFeed, { extraProps = extraProps })

			return
		end

		local v16 = { name = AppPage.ProfileMomentsFeed, extraProps = extraProps }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v16))
		else
			v3(NavigateDown(v16))
		end
	end, { v2, v3, profileId, moments })

	local renderItem = React.useCallback(function(moment, p: number)
		return React.createElement(MomentGridItem, {
			moment = moment,
			isActive = state == p,
			userId = profileId,
			index = p,
			onActivated = function()
				v15(p)
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
	end, { v15, state, profileId })

	local renderEmptyState = React.useCallback(function()
		return React.createElement(View, {
			tag = "col align-x-center align-y-center grow size-full"
		})
	end, {})
	local subtitle

	if not (v10 == nil or v10 == "") then
		subtitle = `@{v10}`
	end

	local element = React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 56),
		padding = { left = UDim.new(0, v4.Padding.Large), right = UDim.new(0, v4.Padding.Large) },
		tag = "row align-x-left align-y-center gap-small"
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = ChevronLargeLeft,
			size = ButtonSize.Medium,
			onActivated = v14
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
				titleStyle = v4.Typography.HeadingSmall,
				subtitleStyle = v4.Typography.BodyMedium,
				isTitleLoading = title == nil,
				isSubtitleLoading = v10 == nil
			})
		})
	})

	local v16 = React.useMemo(function(): boolean
		for _, moment in moments do
			local v16

			if FFlagProfileMomentSceneOutfitPoster then
				v16 = isPlayableVideoMoment(moment)
			else
				v16 = moment.metadata.captureType == Enum.CaptureType.Video
			end

			if v16 then
				return true
			end
		end

		return false
	end, { moments })

	local playbackActive = useNavigationFocus()
	local v17

	if state ~= nil then
		v17 = moments[state]
	end

	if FFlagProfileMomentSceneOutfitPoster then
		if v17 == nil then
			playbackActive = false
		else
			playbackActive = isPlayableVideoMoment(v17) and playbackActive
		end
	elseif v17 == nil then
		playbackActive = false
	elseif v17.metadata.captureType ~= Enum.CaptureType.Video then
		playbackActive = false
	end

	local footer

	if #moments > 0 then
		footer = React.createElement(Foundation.Text, {
			Text = v12.feedEndTitle,
			tag = "auto-xy padding-large text-body-medium text-align-x-center content-muted"
		})
	end

	local grid = React.createElement(View, {
		padding = {
			left = UDim.new(0, v4.Padding.Large),
			right = UDim.new(0, v4.Padding.Large),
			top = UDim.new(0, v4.Padding.Large),
			bottom = UDim.new(0, v4.Padding.Large)
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
			enableInfiniteScroll = v13 and true or nil,
			footer = footer
		})
	})

	if v16 then
		local createElement = React.createElement
		local moments2 = if playbackActive then moments else frozen
		local v18 = {
			moments = moments2,
			activeIndex = state or 1,
			playbackActive = playbackActive,
			handoffRef = nil
		}
		local handoffRef

		if FFlagMomentsOptimisticProfilePending then
			handoffRef = ref
		end

		v18.handoffRef = handoffRef
		grid = createElement(MomentsCarouselMediaProvider, v18, { Grid = grid })
	end

	if FFlagAXEnableProfileTab and v7 then
		return React.createElement(View, {
			backgroundStyle = {
				Color3 = theme.BackgroundDefault.Color,
				Transparency = theme.BackgroundDefault.Transparency
			},
			padding = defineFastFlag and {
				top = UDim.new(0, v8 + v4.Padding.XLarge)
			} or nil,
			tag = defineFastFlag and "col gap-medium size-full" or "col gap-medium size-full padding-top-xlarge"
		}, { Header = element, Grid = grid })
	end

	if not v5 then
		return React.createElement(
			FullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency
			},
			{
				Content = React.createElement(View, {
					padding = { top = UDim.new(0, v4.Padding.XLarge) },
					tag = "col gap-medium size-full"
				}, { Header = element, Grid = grid })
			}
		)
	end

	local v18 = 56 + v4.Padding.XLarge
	return React.createElement(ProfileModalView, {
		topBarHeight = 56,
		viewWidth = viewWidth,
		navigateBack = v14,
		renderTopBar = function()
			return React.createElement(View, {
				Size = UDim2.new(1, 0, 0, v18),
				padding = { top = UDim.new(0, v4.Padding.XLarge) },
				tag = "col"
			}, { Header = element })
		end,
		renderContent = function()
			return React.createElement(View, {
				padding = { top = UDim.new(0, v18) },
				tag = "col size-full"
			}, { Grid = grid })
		end
	})
end

return MomentsGridPage
