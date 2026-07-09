local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
local MomentsCarousel = require(script.Parent.MomentsCarousel)
local useUserMoments = require(ProfilePlatform.Hooks.useUserMoments)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Enums = require(ProfilePlatform.Common.Enums)
local useNavigation = Navigation.useNavigation

local function MomentsCarouselContainer(t1: {[any]: any}) -- line: 20
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useNavigation (copy), useUserMoments (copy), React (copy), EventNames (copy), Enums (copy), MomentsCarousel (copy)
	local v14 = useProfileWrapperContext()
	local v15 = useProfileAnalyticsContext()
	local v16 = useNavigation()
	local profileId = v14.profileId
	local moments = useUserMoments(profileId).moments
	local v19 = React.useCallback(function() -- line: 28
		-- upvalues: v15 (copy), EventNames (copy), v16 (copy), Enums (copy), profileId (copy)
		v15.fireAnalyticsEvent(EventNames.MomentsSeeAll)
		v16.navigate(Enums.Screens.MomentsAll, {
			extraProps = {
				profileId = profileId
			}
		})
	end, {
		v15,
		v16,
		profileId
	})
	local v20 = React.useCallback(function(n1: number) -- line: 37
		-- upvalues: v15 (copy), EventNames (copy), v16 (copy), Enums (copy), profileId (copy)
		v15.fireAnalyticsEvent(EventNames.MomentOpened)
		v16.navigate(Enums.Screens.MomentsFeed, {
			extraProps = {
				targetUserId = tonumber(profileId) or 0,
				initialIndex = n1
			}
		})
	end, {
		v15,
		v16,
		profileId
	})

	if #moments == 0 then
		return React.None
	end

	return React.createElement(MomentsCarousel, {
		layoutOrder = t1.layoutOrder,
		moments = moments,
		onActivateHeader = v19,
		onSelectMoment = v20
	})
end

return MomentsCarouselContainer
