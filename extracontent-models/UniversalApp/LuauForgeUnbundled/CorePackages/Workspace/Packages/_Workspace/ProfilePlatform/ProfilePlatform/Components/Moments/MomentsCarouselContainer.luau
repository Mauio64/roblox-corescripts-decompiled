local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")

local MomentsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsCarousel")
local useUserMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useUserMoments")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local makeProfileTileFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/makeProfileTileFields")

local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local eventNames = MomentsCommon.Analytics.EventNames

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagProfileMomentsLoadFailureAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileMomentsLoadFailureAnalytics")
local v5 = fFlagProfileMomentsFeedRootRoute
	and fFlagEnableArgus
	and fFlagEnableArgusImmersiveNav
	and fFlagProfileRenderAvatarMoments
local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local v6 = fFlagProfileMomentsFeedRootRoute or fFlagProfileRenderAvatarMoments

local function MomentsCarouselContainer(p2)
	local v7 = useProfileWrapperContext()
	local v8 = useProfileAnalyticsContext()
	local v9 = useNavigation()

	local v10 = if v6 then useDispatch() else nil

	local profileId = v7.profileId
	local v11 = useUserMoments(profileId)
	local moments = v11.moments

	if FFlagProfileMomentsLoadFailureAnalytics then
		React.useEffect(function()
			if v11.hasFailed and profileId ~= nil then
				fireAnalyticsEvent(eventNames.ProfileLoadFailed, { userId = profileId })
			end
		end, { v11.hasFailed, profileId })
	end

	local v12 = React.useCallback(function()
		v8.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v9.navigate(Enums.Screens.MomentsAll, {
			extraProps = { profileId = profileId }
		})
	end, { v8, v9, profileId })

	local v13 = React.useCallback(function(p3)
		local moment = moments[p3]

		local v14 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "carousel", p3)

		if v14 then
			fireAnalyticsEvent(eventNames.ProfileMomentSelected, v14)
		end

		local v15 = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = p3,
			initialMomentId = 0
		}

		local v16 = if fFlagMomentsOptimisticProfilePending and moment ~= nil then moment.momentId else nil
		v15.initialMomentId = v16

		if not v6 then
			v9.navigate(Enums.Screens.MomentsFeed, { extraProps = v15 })

			return
		end

		local v18 = if v5 then appPage.MomentsImmersive else appPage.ProfileMomentsFeed
		local v17 = { name = v18, extraProps = v15 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v17))
		else
			v10(navigateDown(v17))
		end
	end, { v8, v9, v10, profileId, moments })

	local v14 = React.useCallback(function(p3)
		local moment = moments[p3]
		local v15 = moment
			and profileId
			and moment.recommendationMetadata
			and makeProfileTileFields.makeProfileTileImpressionFields(moment, profileId, "carousel", p3)

		if v15 then
			fireAnalyticsEvent(eventNames.ProfileMomentTileImpression, v15)
		end
	end, { profileId, moments })

	if #moments == 0 then
		return React.None
	end

	return React.createElement(MomentsCarousel, {
		layoutOrder = p2.layoutOrder,
		moments = moments,
		onActivateHeader = v12,
		onSelectMoment = v13,
		onTileImpression = v14
	})
end

return MomentsCarouselContainer
