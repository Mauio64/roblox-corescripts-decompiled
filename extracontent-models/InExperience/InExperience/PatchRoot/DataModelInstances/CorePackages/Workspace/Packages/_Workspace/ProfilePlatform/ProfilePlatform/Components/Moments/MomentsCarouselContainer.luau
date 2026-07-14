local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
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

local function MomentsCarouselContainer(t1: {[any]: any}) -- line: 30
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useNavigation (copy), useUserMoments (copy), React (copy), EventNames (copy), Enums (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy), MomentsCarousel (copy)
	local v19 = useProfileWrapperContext()
	local v20 = useProfileAnalyticsContext()
	local v21 = useNavigation()
	local profileId = v19.profileId
	local moments = useUserMoments(profileId).moments
	local v24 = React.useCallback(function() -- line: 38
		-- upvalues: v20 (copy), EventNames (copy), v21 (copy), Enums (copy), profileId (copy)
		v20.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v21.navigate(Enums.Screens.MomentsAll, {
			extraProps = {
				profileId = profileId
			}
		})
	end, {
		v20,
		v21,
		profileId
	})
	local v25 = React.useCallback(function(n1: number) -- line: 47
		-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), moments (copy), profileId (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy), v20 (copy), EventNames (copy), v21 (copy), Enums (copy)
		if GetFFlagMomentsAnalyticsSchemaIdentity() then
			local v28 = moments[n1]

			if v28 and profileId then
				local v29 = makeProfileTileFields.makeProfileTileInteractionFields(v28, profileId, "carousel", n1)

				if v29 then
					fireAnalyticsEvent(EventNames2.ProfileMomentSelected, v29)
				end
			end
		else
			v20.fireAnalyticsEvent(EventNames.MomentOpened)
		end

		v21.navigate(Enums.Screens.MomentsFeed, {
			extraProps = {
				targetUserId = tonumber(profileId) or 0,
				initialIndex = n1
			}
		})
	end, {
		v20,
		v21,
		profileId,
		moments
	})
	local v26 = React.useCallback(function(n2: number) -- line: 75
		-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), moments (copy), profileId (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames2 (copy)
		if not GetFFlagMomentsAnalyticsSchemaIdentity() then
			return
		end

		local v31 = moments[n2]

		if v31 and profileId and v31.recommendationMetadata then
			local v32 = makeProfileTileFields.makeProfileTileImpressionFields(v31, profileId, "carousel", n2)

			if v32 then
				fireAnalyticsEvent(EventNames2.ProfileMomentTileImpression, v32)
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
		onActivateHeader = v24,
		onSelectMoment = v25,
		onTileImpression = if not GetFFlagMomentsAnalyticsSchemaIdentity() then nil else v26
	})
end

return MomentsCarouselContainer
