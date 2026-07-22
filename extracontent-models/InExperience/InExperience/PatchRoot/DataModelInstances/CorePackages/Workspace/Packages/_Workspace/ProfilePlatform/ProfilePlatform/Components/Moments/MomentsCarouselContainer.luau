local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local MomentsCommon = require(ProfilePlatformParent.MomentsCommon)
local MomentsCarousel = require(script.Parent.MomentsCarousel)
local useUserMoments = require(ProfilePlatform.Hooks.useUserMoments)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Enums = require(ProfilePlatform.Common.Enums)
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local EventNames2 = MomentsCommon.Analytics.EventNames
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity
local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagProfileMomentsFeedRootRoute = SharedFlags.FFlagProfileMomentsFeedRootRoute
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function MomentsCarouselContainer(t1: {[any]: any}) -- line: 41
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useNavigation (copy), FFlagProfileMomentsFeedRootRoute (copy), useDispatch (copy), useUserMoments (copy), React (copy), EventNames (copy), Enums (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateDown (copy), MomentsCarousel (copy)
	local v28 = useProfileWrapperContext()
	local v29 = useProfileAnalyticsContext()
	local v30 = useNavigation()
	local v31 = if not FFlagProfileMomentsFeedRootRoute then nil else useDispatch()
	local profileId = v28.profileId
	local moments = useUserMoments(profileId).moments
	local v34 = React.useCallback(function() -- line: 50
		-- upvalues: v29 (copy), EventNames (copy), v30 (copy), Enums (copy), profileId (copy)
		v29.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v30.navigate(Enums.Screens.MomentsAll, {
			extraProps = {
				profileId = profileId
			}
		})
	end, {
		v29,
		v30,
		profileId
	})
	local v35 = React.useCallback(function(n1: number) -- line: 59
		-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), moments (copy), profileId (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy), v29 (copy), EventNames (copy), FFlagProfileMomentsFeedRootRoute (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v31 (copy), NavigateDown (copy), v30 (copy), Enums (copy)
		if GetFFlagMomentsAnalyticsSchemaIdentity() then
			local v38 = moments[n1]

			if v38 and profileId then
				local v39 = makeProfileTileFields.makeProfileTileInteractionFields(v38, profileId, "carousel", n1)

				if v39 then
					fireAnalyticsEvent(EventNames2.ProfileMomentSelected, v39)
				end
			end
		else
			v29.fireAnalyticsEvent(EventNames.MomentOpened)
		end

		local t2 = {
			targetUserId = tonumber(profileId) or 0,
			initialIndex = n1
		}

		if FFlagProfileMomentsFeedRootRoute then
			local t3 = {
				name = AppPage.ProfileMomentsFeed,
				extraProps = t2
			}

			if FFlagSignalsNavP3Dispatch then
				v25.down(v25.fromLegacyPage(t3))

				return
			end

			v31(NavigateDown(t3))

			return
		end

		v30.navigate(Enums.Screens.MomentsFeed, {
			extraProps = t2
		})
	end, {
		v29,
		v30,
		v31,
		profileId,
		moments
	})
	local v36 = React.useCallback(function(n2: number) -- line: 100
		-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), moments (copy), profileId (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy)
		if not GetFFlagMomentsAnalyticsSchemaIdentity() then
			return
		end

		local v43 = moments[n2]

		if v43 and profileId and v43.recommendationMetadata then
			local v44 = makeProfileTileFields.makeProfileTileImpressionFields(v43, profileId, "carousel", n2)

			if v44 then
				fireAnalyticsEvent(EventNames2.ProfileMomentTileImpression, v44)
			end
		end
	end, {
		profileId,
		moments
	})

	if #moments == 0 then
		return React.None
	end

	return React.createElement(MomentsCarousel, {
		layoutOrder = t1.layoutOrder,
		moments = moments,
		onActivateHeader = v34,
		onSelectMoment = v35,
		onTileImpression = if not GetFFlagMomentsAnalyticsSchemaIdentity() then nil else v36
	})
end

return MomentsCarouselContainer
