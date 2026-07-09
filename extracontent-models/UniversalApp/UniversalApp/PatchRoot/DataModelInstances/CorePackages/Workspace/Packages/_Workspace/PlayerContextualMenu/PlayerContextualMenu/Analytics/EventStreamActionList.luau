local ParentParent = script.Parent.Parent.Parent
local EventNames = require(script.Parent.EventNames)
local Enums = require(ParentParent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local SubPages = Enums.SubPages
local EventTypes = Enums.EventTypes

local function v7(p1) -- line: 11
	return p1
end

return {
	[EventNames.RequestFriendship] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "addFriend",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.Unfriend] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "unFriend",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.AcceptFriendRequest] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "acceptFriend",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.IgnoreFriendRequest] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "ignoreFriend",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.BlockPlayer] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "block",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.ReportPlayer] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "report",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.JoinExperience] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "joinUser",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.ViewExperienceDetails] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "viewExperienceDetails",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	},
	[EventNames.ViewPlatformProfile] = {
		context = Contexts.FriendsLanding,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = "viewPlatformProfile",
			subpage = SubPages.PlayerContextualMenu
		},
		formatRulesForAdditionalInfo = {
			profileUserId = v7
		}
	}
}
