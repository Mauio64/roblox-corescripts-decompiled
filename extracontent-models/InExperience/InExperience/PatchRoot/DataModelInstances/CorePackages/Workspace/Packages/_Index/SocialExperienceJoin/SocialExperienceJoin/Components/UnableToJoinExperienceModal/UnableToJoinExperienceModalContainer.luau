local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local UserProfiles = require(parent.UserProfiles)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)

local initializeSocialExperienceJoinAnalytics = require(SocialExperienceJoin.Analytics.initializeSocialExperienceJoinAnalytics)
local EventNames = require(SocialExperienceJoin.Analytics.EventNames)

local useNavigation = Navigation.useNavigation
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useScreenSize = RobloxAppHooks.useScreenSize

local UnableToJoinExperienceModal = require(script.Parent.UnableToJoinExperienceModal)

return function(p)
	local v = useNavigation()
	local v2 = useNavigationProps(function(universeId, data)
		return {
			universeId = universeId,
			userId = data.userId,
			openGameDetailsPeekViewClosed = data.openGameDetailsPeekViewClosed,
			analyticProps = data.analyticProps
		}
	end)

	local v3 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(v2.analyticProps)
	end, { v2.analyticProps })

	local screenSize = useScreenSize()
	local v4 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v2.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local userPrimaryName = not v4.data and "" or UserProfiles.Selectors.getCombinedNameFromId(v4.data, v2.userId)

	local v5 = React.useCallback(function()
		v.pop()
	end, { v })

	local cancel = React.useCallback(function()
		v3.fireAnalyticsEvent(EventNames.UnableToJoinCancel, {
			universeId = v2.universeId,
			profileUserId = v2.userId
		})

		v5()
	end, { v5 })

	local openGameDetailsPeekView = React.useCallback(function()
		v3.fireAnalyticsEvent(EventNames.UnableToJoinViewDetails, {
			universeId = v2.universeId,
			profileUserId = v2.userId
		})

		v5()

		p.openGameDetailsPeekView(v2.universeId, {
			mountAsFullView = true,
			showBackButton = true,
			onPeekViewClosed = v2.openGameDetailsPeekViewClosed
		})
	end, {
		v,
		v2.universeId,
		v2.userId,
		v2.openGameDetailsPeekViewClosed,
		p.openGameDetailsPeekView,
		v5
	})

	return React.createElement(UnableToJoinExperienceModal, {
		cancel = cancel,
		openGameDetailsPeekView = openGameDetailsPeekView,
		screenSize = screenSize,
		userPrimaryName = userPrimaryName
	})
end
