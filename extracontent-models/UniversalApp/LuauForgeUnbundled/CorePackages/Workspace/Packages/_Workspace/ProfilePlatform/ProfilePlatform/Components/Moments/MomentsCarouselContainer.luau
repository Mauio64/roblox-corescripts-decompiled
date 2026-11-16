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
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagProfileMomentsLoadFailureAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileMomentsLoadFailureAnalytics")

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local v5 = fFlagProfileMomentsFeedRootRoute or fFlagProfileRenderAvatarMoments

local function MomentsCarouselContainer(p2)
	local v6 = useProfileWrapperContext()
	local v7 = useProfileAnalyticsContext()
	local v8 = useNavigation()

	local v9 = if v5 then useDispatch() else nil

	local profileId = v6.profileId
	local v10 = useUserMoments(profileId)
	local moments = v10.moments

	if FFlagProfileMomentsLoadFailureAnalytics then
		React.useEffect(function()
			if v10.hasFailed and profileId ~= nil then
				fireAnalyticsEvent(eventNames.ProfileLoadFailed, { userId = profileId })
			end
		end, { v10.hasFailed, profileId })
	end

	local v11 = React.useCallback(function()
		v7.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v8.navigate(Enums.Screens.MomentsAll, {
			extraProps = { profileId = profileId }
		})
	end, { v7, v8, profileId })

	local v12 = React.useCallback(function(p3)
		local moment = moments[p3]

		local v13 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "carousel", p3)

		if v13 then
			fireAnalyticsEvent(eventNames.ProfileMomentSelected, v13)
		end

		local v14 = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = p3,
			initialMomentId = 0
		}

		local v15 = if fFlagMomentsOptimisticProfilePending and moment ~= nil then moment.momentId else nil
		v14.initialMomentId = v15

		if not v5 then
			v8.navigate(Enums.Screens.MomentsFeed, { extraProps = v14 })

			return
		end

		local v16 = { name = appPage.ProfileMomentsFeed, extraProps = v14 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v16))
		else
			v9(navigateDown(v16))
		end
	end, { v7, v8, v9, profileId, moments })

	local v13 = React.useCallback(function(p3)
		local moment = moments[p3]
		local v14 = moment
			and profileId
			and moment.recommendationMetadata
			and makeProfileTileFields.makeProfileTileImpressionFields(moment, profileId, "carousel", p3)

		if v14 then
			fireAnalyticsEvent(eventNames.ProfileMomentTileImpression, v14)
		end
	end, { profileId, moments })

	if #moments == 0 then
		return React.None
	end

	return React.createElement(MomentsCarousel, {
		layoutOrder = p2.layoutOrder,
		moments = moments,
		onActivateHeader = v11,
		onSelectMoment = v12,
		onTileImpression = v13
	})
end

return MomentsCarouselContainer
