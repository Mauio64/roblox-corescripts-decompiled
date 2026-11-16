local parent = script:FindFirstAncestor("SocialExperienceJoin").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local SubPages = SocialLuaAnalytics.Analytics.Enums.SubPages
local EventNames = require(script.Parent.EventNames)
local BtnValues = require(script.Parent.BtnValues)

local function fn(p)
	return p
end

local PlayerProfile = Contexts.PlayerProfile
local PeekView = SubPages.PeekView

return function(p)
	local context = p and p.context or PlayerProfile
	local subpage = p and p.subpage or PeekView
	return {
		[EventNames.JoinExperience] = {
			context = context,
			eventType = EventTypes.JoinGameInPeopleList,
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
			eventType = EventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.PurchaseExperience, subpage = subpage },
			formatRulesForAdditionalInfo = { profileUserId = fn, uid = fn }
		},
		[EventNames.PurchaseExperienceAttempt] = {
			context = context,
			eventType = EventTypes.PurchaseExperienceAttempt,
			additionalInfo = { subpage = subpage },
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn, status = fn }
		},
		[EventNames.CancelPurchaseExperience] = {
			context = context,
			eventType = EventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.CancelPurchaseExperience, subpage = subpage },
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		},
		[EventNames.UnableToJoinViewDetails] = {
			context = context,
			eventType = EventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.UnableToJoinViewDetails, subpage = subpage },
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		},
		[EventNames.UnableToJoinCancel] = {
			context = context,
			eventType = EventTypes.ButtonClick,
			additionalInfo = { btn = BtnValues.UnableToJoinCancel, subpage = subpage },
			formatRulesForAdditionalInfo = { universeId = fn, profileUserId = fn }
		}
	}
end
