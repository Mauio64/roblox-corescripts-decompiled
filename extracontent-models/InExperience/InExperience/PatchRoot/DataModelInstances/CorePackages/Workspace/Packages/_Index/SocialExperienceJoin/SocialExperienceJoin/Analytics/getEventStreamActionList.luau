local Parent = script:FindFirstAncestor("SocialExperienceJoin").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local SubPages = SocialLuaAnalytics.Analytics.Enums.SubPages
local EventNames = require(script.Parent.EventNames)
local BtnValues = require(script.Parent.BtnValues)

local function v8(p1) -- line: 10
	return p1
end

local PlayerProfile = Contexts.PlayerProfile
local PeekView = SubPages.PeekView

return function(t1: {[any]: any}?) -- line: 17
	-- upvalues: PlayerProfile (copy), PeekView (copy), EventNames (copy), EventTypes (copy), BtnValues (copy), v8 (copy)
	local v13 = t1 and t1.context or PlayerProfile
	local v14 = t1 and t1.subpage or PeekView

	return {
		[EventNames.JoinExperience] = {
			context = v13,
			eventType = EventTypes.JoinGameInPeopleList,
			additionalInfo = {
				btn = BtnValues.JoinExperience,
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				placeId = v8,
				rootPlaceId = v8,
				gameInstanceId = v8,
				profileUserId = v8,
				uid = v8,
				isHomePageCarousel = v8,
				absolutePosition = v8,
				joinAttemptId = v8,
				status = v8
			}
		},
		[EventNames.PurchaseExperience] = {
			context = v13,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.PurchaseExperience,
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				profileUserId = v8,
				uid = v8
			}
		},
		[EventNames.PurchaseExperienceAttempt] = {
			context = v13,
			eventType = EventTypes.PurchaseExperienceAttempt,
			additionalInfo = {
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				universeId = v8,
				profileUserId = v8,
				status = v8
			}
		},
		[EventNames.CancelPurchaseExperience] = {
			context = v13,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.CancelPurchaseExperience,
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				universeId = v8,
				profileUserId = v8
			}
		},
		[EventNames.UnableToJoinViewDetails] = {
			context = v13,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.UnableToJoinViewDetails,
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				universeId = v8,
				profileUserId = v8
			}
		},
		[EventNames.UnableToJoinCancel] = {
			context = v13,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.UnableToJoinCancel,
				subpage = v14
			},
			formatRulesForAdditionalInfo = {
				universeId = v8,
				profileUserId = v8
			}
		}
	}
end
