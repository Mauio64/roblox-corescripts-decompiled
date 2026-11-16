local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SocialLuaAnalytics")
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local subPages = SocialLuaAnalytics.Analytics.Enums.SubPages
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/EventNames")
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/BtnValues")

local function fn(p2)
	return p2
end

local playerProfile = contexts.PlayerProfile
local peekView = subPages.PeekView

return function(p2)
	local context = p2 and p2.context or playerProfile
	local subpage = p2 and p2.subpage or peekView
	return {
		[EventNames.JoinExperience] = {
			context = context,
			eventType = eventTypes.JoinGameInPeopleList,
			additionalInfo = { btn = BtnValues.JoinExperience, subpage = subpage },
			formatRulesForAdditionalInfo = {
				placeId = fn,
				rootPlaceId = fn,
				gameInstanceId = fn,
				profileUserId = fn,
				uid = fn,
				isHomePageCarousel = fn,
				absolutePosition = fn,
				joinAttemptId = fn,
				status = fn
			}
		},
		[EventNames.PurchaseExperience] = {
			context = context,
			eventType = eventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.PurchaseExperience, subpage = subpage },
			formatRulesForAdditionalInfo = { profileUserId = fn, uid = fn }
		},
		[EventNames.PurchaseExperienceAttempt] = {
			context = context,
			eventType = eventTypes.PurchaseExperienceAttempt,
			additionalInfo = { subpage = subpage },
			formatRulesForAdditionalInfo = {
				universeId = fn,
				profileUserId = fn,
				status = fn
			}
		},
		[EventNames.CancelPurchaseExperience] = {
			context = context,
			eventType = eventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.CancelPurchaseExperience,
				subpage = subpage
			},
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		},
		[EventNames.UnableToJoinViewDetails] = {
			context = context,
			eventType = eventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.UnableToJoinViewDetails,
				subpage = subpage
			},
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		},
		[EventNames.UnableToJoinCancel] = {
			context = context,
			eventType = eventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.UnableToJoinCancel, subpage = subpage },
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		}
	}
end
