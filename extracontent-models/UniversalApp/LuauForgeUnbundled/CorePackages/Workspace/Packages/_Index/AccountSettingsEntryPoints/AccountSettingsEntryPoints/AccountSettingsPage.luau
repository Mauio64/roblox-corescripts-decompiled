local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/Http").Url

local translate = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/translate")

local v5 = {
	PersonalizedRecommendations = "personalized-recommendations",
	AccountDataDeactivationAndDeletion = "privacy/AccountDataDeactivationAndDeletion"
}

local v6 = {
	PersonalizedRecommendations = "Feature.AccountSettings.Heading.Tab.PersonalizedRecommendations",
	AccountDataDeactivationAndDeletion = "Feature.AccountSettings.Heading.Tab.Privacy"
}

return {
	PersonalizedRecommendations = "PersonalizedRecommendations",
	AccountDataDeactivationAndDeletion = "AccountDataDeactivationAndDeletion",
	getUrl = function(p2)
		return `{url.WWW_URL}my/account#!/{v5[p2]}`
	end,
	getTitle = function(p2)
		return translate(v6[p2])
	end
}
