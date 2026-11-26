local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Navigation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppHooks")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/UserProfiles")
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppNavigation")

local initializeSocialExperienceJoinAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/initializeSocialExperienceJoinAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/EventNames")

local useNavigation = Navigation.useNavigation
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useScreenSize = RobloxAppHooks.useScreenSize

local UnableToJoinExperienceModal = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Components/UnableToJoinExperienceModal/UnableToJoinExperienceModal")

return function(p2)
	local v5 = useNavigation()
	local v6 = useNavigationProps(function(p3, data)
		return {
			universeId = p3,
			userId = data.userId,
			openGameDetailsPeekViewClosed = data.openGameDetailsPeekViewClosed,
			analyticProps = data.analyticProps
		}
	end)

	local v7 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(v6.analyticProps)
	end, { v6.analyticProps })

	local v8 = useScreenSize()
	local v9 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v6.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v10 = not v9.data and "" or UserProfiles.Selectors.getCombinedNameFromId(v9.data, v6.userId)

	local v11 = React.useCallback(function()
		v5.pop()
	end, { v5 })

	local v12 = React.useCallback(function()
		v7.fireAnalyticsEvent(EventNames.UnableToJoinCancel, {
			universeId = v6.universeId,
			profileUserId = v6.userId
		})

		v11()
	end, { v11 })

	local v13 = React.useCallback(function()
		v7.fireAnalyticsEvent(EventNames.UnableToJoinViewDetails, {
			universeId = v6.universeId,
			profileUserId = v6.userId
		})

		v11()

		p2.openGameDetailsPeekView(v6.universeId, {
			mountAsFullView = true,
			showBackButton = true,
			onPeekViewClosed = v6.openGameDetailsPeekViewClosed
		})
	end, {
		v5,
		v6.universeId,
		v6.userId,
		v6.openGameDetailsPeekViewClosed,
		p2.openGameDetailsPeekView,
		v11
	})

	return React.createElement(UnableToJoinExperienceModal, {
		cancel = v12,
		openGameDetailsPeekView = v13,
		screenSize = v8,
		userPrimaryName = v10
	})
end
