local module = require("@luauforge/deferred/eim")
local enums = require("@luauforge/deferred/eiw").Analytics.Enums
local eventTypes = enums.EventTypes
local contexts = enums.Contexts
local sources = enums.Sources

local module2 = require("@luauforge/deferred/eiy")

local fFlagEnableSchoolEntry = require("@luauforge/deferred/eiz").FFlagEnableSchoolEntry

local function fn(p2)
	if p2 then
		return (tostring(p2))
	end

	return nil
end

return {
	[module2.PageLoad] = {
		context = contexts.AddFriends,
		eventType = eventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			recommendationCount = module.identity,
			status = module.identity
		}
	},
	[module2.AddFriendsPageLoadingTime] = {
		context = contexts.AddFriends,
		eventType = eventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			loadingTime = module.identity,
			status = module.identity
		}
	},
	[module2.AFPUserTileLoadFromHomeCarousel] = {
		context = contexts.AddFriends,
		eventType = eventTypes.LoadingTime,
		additionalInfo = {
			source = sources.HomePageFriendsCarousel,
			fetch = "userTileLoad"
		},
		formatRulesForAdditionalInfo = { loadingTime = module.identity }
	},
	[module2.UserSearchClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "peopleSearchBar" }
	},
	[module2.CIBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "connectWithFriends" }
	},
	[module2.QRCodeBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "shareProfileQRCode" }
	},
	[module2.CIBtnImpression] = {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "connectWithFriends" }
	},
	[module2.QRCodeBtnImpression] = {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "shareProfileQRCode" }
	},
	[module2.SchoolBtnClick] = fFlagEnableSchoolEntry and {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "school" }
	} or nil,
	[module2.SchoolBtnImpression] = fFlagEnableSchoolEntry and {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "school" }
	} or nil,
	[module2.RequestFriendshipBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "requestFriendship" },
		formatRulesForAdditionalInfo = {
			namespace = module.identity,
			targetUserId = module.identity,
			absolutePosition = module.identity,
			rank = module.identity,
			contextType = module.identity,
			entityType = module.identity,
			presence = fn
		}
	},
	[module2.AcceptFriendshipBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "acceptFriendship" },
		formatRulesForAdditionalInfo = {
			namespace = module.identity,
			targetUserId = module.identity,
			absolutePosition = module.identity,
			rank = module.identity,
			contextType = module.identity,
			entityType = module.identity,
			presence = fn
		}
	},
	[module2.DeclineFriendshipBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "declineFriendship" },
		formatRulesForAdditionalInfo = {
			namespace = module.identity,
			targetUserId = module.identity,
			absolutePosition = module.identity,
			rank = module.identity,
			contextType = module.identity,
			entityType = module.identity,
			presence = fn
		}
	},
	[module2.PlayerTileClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "userTileClick" },
		formatRulesForAdditionalInfo = {
			namespace = module.identity,
			targetUserId = module.identity,
			absolutePosition = module.identity,
			rank = module.identity,
			contextType = module.identity,
			entityType = module.identity,
			friendStatus = module.identity,
			presence = fn
		}
	},
	[module2.IgnoreAllBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "ignoreAll" },
		formatRulesForAdditionalInfo = { namespace = module.identity }
	},
	[module2.ShowMoreBtnClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "loadMoreUsers" },
		formatRulesForAdditionalInfo = { namespace = module.identity }
	},
	[module2.UserTileImpression] = {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "userTileImpression" },
		formatRulesForAdditionalInfo = {
			namespace = module.identity,
			targetUserId = module.identity,
			absolutePosition = module.identity,
			rank = module.identity,
			contextType = module.identity,
			entityType = module.identity,
			friendStatus = module.identity,
			rowInSort = module.identity,
			presence = module.identity
		}
	},
	[module2.FriendingOSAEducationSubtitleImpression] = {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "friendingOSAEducationSubtitle" }
	},
	[module2.TrustedContactsEducationalBannerClick] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "trustedContactsEducationalBanner" }
	},
	[module2.TrustedContactsEducationalBannerClose] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { action = "TrustedContactsEducationalBannerClose" }
	},
	[module2.TrustedContactsEducationalBannerImpression] = {
		context = contexts.AddFriends,
		eventType = eventTypes.UserSeen,
		additionalInfo = { action = "trustedContactsEducationalBanner" }
	},
	[module2.PYMKUserPresenceLoad] = {
		context = contexts.AddFriends,
		eventType = eventTypes.LoadingTime,
		additionalInfo = { source = "AddFriendsPYMKUserPresence" }
	}
}
