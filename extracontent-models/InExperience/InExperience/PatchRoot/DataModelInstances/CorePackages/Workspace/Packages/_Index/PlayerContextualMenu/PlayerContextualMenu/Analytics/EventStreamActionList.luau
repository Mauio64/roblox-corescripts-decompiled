local parent = script.Parent.Parent.Parent

local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local SubPages = Enums.SubPages
local EventTypes = Enums.EventTypes

local function fn(p)
	return p
end

return {
	[EventNames.RequestFriendship] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "addFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.Unfriend] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "unFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.AcceptFriendRequest] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "acceptFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.IgnoreFriendRequest] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "ignoreFriend" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.BlockPlayer] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "block" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ReportPlayer] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "report" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.JoinExperience] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "joinUser" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ViewExperienceDetails] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "viewExperienceDetails" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	},
	[EventNames.ViewPlatformProfile] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { subpage = SubPages.PlayerContextualMenu, btn = "viewPlatformProfile" },
		formatRulesForAdditionalInfo = { profileUserId = fn }
	}
}
