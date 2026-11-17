local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local NavigationRodux = require(parent.NavigationRodux)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local MomentsCommon = require(parent.MomentsCommon)

local MomentsCarousel = require(script.Parent.MomentsCarousel)
local useUserMoments = require(ProfilePlatform.Hooks.useUserMoments)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Enums = require(ProfilePlatform.Common.Enums)
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)

local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local eventNames = MomentsCommon.Analytics.EventNames

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagProfileMomentsLoadFailureAnalytics = require(ProfilePlatform.Flags.FFlagProfileMomentsLoadFailureAnalytics)
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

local function MomentsCarouselContainer(p)
	local v3 = useProfileWrapperContext()
	local v4 = useProfileAnalyticsContext()
	local v5 = useNavigation()
	local v6

	if v2 then
		v6 = useDispatch()
	else
		v6 = nil
	end

	local profileId = v3.profileId
	local v7 = useUserMoments(profileId)
	local moments = v7.moments

	if FFlagProfileMomentsLoadFailureAnalytics then
		React.useEffect(function()
			if v7.hasFailed and profileId ~= nil then
				fireAnalyticsEvent(eventNames.ProfileLoadFailed, { userId = profileId })
			end
		end, { v7.hasFailed, profileId })
	end

	local onActivateHeader = React.useCallback(function()
		v4.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v5.navigate(Enums.Screens.MomentsAll, {
			extraProps = { profileId = profileId }
		})
	end, { v4, v5, profileId })

	local onSelectMoment = React.useCallback(function(initialIndex: number)
		local moment = moments[initialIndex]

		local v8 = moment
			and profileId
			and makeProfileTileFields.makeProfileTileInteractionFields(moment, profileId, "carousel", initialIndex)

		if v8 then
			fireAnalyticsEvent(eventNames.ProfileMomentSelected, v8)
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

		if not v2 then
			v5.navigate(Enums.Screens.MomentsFeed, { extraProps = extraProps })

			return
		end

		local name

		if v then
			name = AppPage.MomentsImmersive
		else
			name = AppPage.ProfileMomentsFeed
		end

		local v9 = { name = name, extraProps = extraProps }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v6(NavigateDown(v9))
		end
	end, { v4, v5, v6, profileId, moments })

	local onTileImpression = React.useCallback(function(p2: number)
		local moment = moments[p2]
		local v8 = moment
			and profileId
			and moment.recommendationMetadata
			and makeProfileTileFields.makeProfileTileImpressionFields(moment, profileId, "carousel", p2)

		if v8 then
			fireAnalyticsEvent(eventNames.ProfileMomentTileImpression, v8)
		end
	end, { profileId, moments })

	if #moments == 0 then
		return React.None
	end

	return React.createElement(MomentsCarousel, {
		layoutOrder = p.layoutOrder,
		moments = moments,
		onActivateHeader = onActivateHeader,
		onSelectMoment = onSelectMoment,
		onTileImpression = onTileImpression
	})
end

return MomentsCarouselContainer
