local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.BtnValues)
local Constants = require(ParentParent.Common.Constants)
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry
local FFlagHomepagePYMKPresenceAnalytics = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics

local function v14(p1) -- line: 18
	return p1
end
local function v15(p2) -- line: 22
	if p2 then
		return (tostring(p2))
	end

	return nil
end

local t1 = {
	[EventNames.CarouselLoadedWithUsers] = {
		context = Contexts.HomePage,
		eventType = EventTypes.FriendsCarouselLoaded,
		additionalInfo = {
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			recommendationLimit = nil,
			recommendationCount = v14,
			refreshCount = v14
		}
	},
	[EventNames.PYMKCarouselLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		additionalInfo = {
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			loadingTime = v14
		}
	},
	[EventNames.UserSeen] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			isRecommendation = true,
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v14,
			recommendationContextType = formatRecommendationContextType,
			friendStatus = v14,
			recommendationRank = v14,
			userId = v14,
			contactId = v14,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else v15
		}
	},
	[EventNames.UserPressed] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			isRecommendation = true,
			contentType = "User",
			actionType = "OpenProfile",
			source = Constants.HomepagePYMKCarouselSourceName,
			btn = BtnValues.OpenPeopleList
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v14,
			positionInRow = v14,
			recommendationContextType = formatRecommendationContextType,
			recommendationId = v14,
			friendStatus = v14,
			recommendationRank = v14,
			contactId = v14,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else v15,
			interactionUuid = v14
		}
	},
	[EventNames.RequestFriendship] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			contentType = "User",
			actionType = "RequestFriendship",
			btn = BtnValues.RequestFriendship,
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v14,
			positionInRow = v14,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = v14,
			requestedId = v14,
			contactId = v14,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else v15,
			interactionUuid = v14
		}
	},
	[EventNames.AcceptFriendship] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.AcceptFriendship,
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v14,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = v14,
			requestedId = v14,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else v15
		}
	},
	[EventNames.PYMKUserPresenceLoad] = if not FFlagHomepagePYMKPresenceAnalytics then nil else {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		additionalInfo = {
			source = "HomepagePYMKUserPresence"
		},
		formatRulesForAdditionalInfo = {
			loadingTime = v14
		}
	}
}

if getFFlagPYMKAddFriendsEntry() then
	local t2 = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			btn = v14
		}
	}

	t1[EventNames.CarouselGenericTileClicked] = t2
end

return t1
