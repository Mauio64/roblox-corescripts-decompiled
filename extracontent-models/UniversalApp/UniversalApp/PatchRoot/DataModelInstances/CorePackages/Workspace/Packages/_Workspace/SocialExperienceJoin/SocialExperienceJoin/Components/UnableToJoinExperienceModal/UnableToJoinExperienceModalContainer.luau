local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local React = require(SocialExperienceJoinParent.React)
local Navigation = require(SocialExperienceJoinParent.Navigation)
local RobloxAppHooks = require(SocialExperienceJoinParent.RobloxAppHooks)
local UserProfiles = require(SocialExperienceJoinParent.UserProfiles)
local RobloxAppNavigation = require(SocialExperienceJoinParent.RobloxAppNavigation)
local initializeSocialExperienceJoinAnalytics = require(SocialExperienceJoin.Analytics.initializeSocialExperienceJoinAnalytics)
local EventNames = require(SocialExperienceJoin.Analytics.EventNames)
local useNavigation = Navigation.useNavigation
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useScreenSize = RobloxAppHooks.useScreenSize
local UnableToJoinExperienceModal = require(script.Parent.UnableToJoinExperienceModal)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useNavigation (copy), useNavigationProps (copy), React (copy), initializeSocialExperienceJoinAnalytics (copy), useScreenSize (copy), UserProfiles (copy), EventNames (copy), UnableToJoinExperienceModal (copy)
	local v15 = useNavigation()
	local v16 = useNavigationProps(function(p1, p2) -- line: 27
		return {
			universeId = p1,
			userId = p2.userId,
			openGameDetailsPeekViewClosed = p2.openGameDetailsPeekViewClosed,
			analyticProps = p2.analyticProps
		}
	end)
	local v17 = React.useMemo(function() -- line: 36
		-- upvalues: initializeSocialExperienceJoinAnalytics (copy), v16 (copy)
		return initializeSocialExperienceJoinAnalytics(v16.analyticProps)
	end, { v16.analyticProps })
	local v18 = useScreenSize()
	local v19 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v16.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local v20 = not v19.data and "" or UserProfiles.Selectors.getCombinedNameFromId(v19.data, v16.userId)
	local v21 = React.useCallback(function() -- line: 49
		-- upvalues: v15 (copy)
		v15.pop()
	end, { v15 })
	local v22 = React.useCallback(function() -- line: 53
		-- upvalues: v17 (copy), EventNames (copy), v16 (copy), v21 (copy)
		v17.fireAnalyticsEvent(EventNames.UnableToJoinCancel, {
			universeId = v16.universeId,
			profileUserId = v16.userId
		})
		v21()
	end, { v21 })
	local v23 = React.useCallback(function() -- line: 63
		-- upvalues: v17 (copy), EventNames (copy), v16 (copy), v21 (copy), t1 (copy)
		v17.fireAnalyticsEvent(EventNames.UnableToJoinViewDetails, {
			universeId = v16.universeId,
			profileUserId = v16.userId
		})
		v21()
		t1.openGameDetailsPeekView(v16.universeId, {
			mountAsFullView = true,
			showBackButton = true,
			onPeekViewClosed = v16.openGameDetailsPeekViewClosed
		})
	end, {
		v15,
		v16.universeId,
		v16.userId,
		v16.openGameDetailsPeekViewClosed,
		t1.openGameDetailsPeekView,
		v21
	})

	return React.createElement(UnableToJoinExperienceModal, {
		cancel = v22,
		openGameDetailsPeekView = v23,
		screenSize = v18,
		userPrimaryName = v20
	})
end
