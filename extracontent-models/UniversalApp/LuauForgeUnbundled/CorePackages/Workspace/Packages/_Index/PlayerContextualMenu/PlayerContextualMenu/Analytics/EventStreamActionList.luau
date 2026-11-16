local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics/EventNames")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SocialLuaAnalytics").Analytics.Enums
local contexts = enums.Contexts
local subPages = enums.SubPages
local eventTypes = enums.EventTypes

local function fn(p2)
	return p2
end

return {
	[EventNames.RequestFriendship] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { subpage = subPages.PlayerContextualMenu, btn = "addFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.Unfriend] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { subpage = subPages.PlayerContextualMenu, btn = "unFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.AcceptFriendRequest] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			subpage = subPages.PlayerContextualMenu,
			btn = "acceptFriend"
		},
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.IgnoreFriendRequest] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			subpage = subPages.PlayerContextualMenu,
			btn = "ignoreFriend"
		},
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.BlockPlayer] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { subpage = subPages.PlayerContextualMenu, btn = "block" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ReportPlayer] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { subpage = subPages.PlayerContextualMenu, btn = "report" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.JoinExperience] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { subpage = subPages.PlayerContextualMenu, btn = "joinUser" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ViewExperienceDetails] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			subpage = subPages.PlayerContextualMenu,
			btn = "viewExperienceDetails"
		},
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ViewPlatformProfile] = {
		context = contexts.FriendsLanding,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			subpage = subPages.PlayerContextualMenu,
			btn = "viewPlatformProfile"
		},
		formatRulesForAdditionalInfo = { profileUserId = fn }
	}
}
