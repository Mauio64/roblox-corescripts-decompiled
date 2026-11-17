local parent = script.Parent
local parent2 = parent.Parent

local Http = require(parent2.Http)
local Url = Http.Url

local translate = require(parent.translate)

local v = {
	PersonalizedRecommendations = "personalized-recommendations",
	AccountDataDeactivationAndDeletion = "privacy/AccountDataDeactivationAndDeletion"
}

local v2 = {
	PersonalizedRecommendations = "Feature.AccountSettings.Heading.Tab.PersonalizedRecommendations",
	AccountDataDeactivationAndDeletion = "Feature.AccountSettings.Heading.Tab.Privacy"
}
local AccountSettingsPage = {}
AccountSettingsPage.PersonalizedRecommendations = "PersonalizedRecommendations"
AccountSettingsPage.AccountDataDeactivationAndDeletion = "AccountDataDeactivationAndDeletion"

function AccountSettingsPage.getUrl(p: string)
	return `{Url.WWW_URL}my/account#!/{v[p]}`
end

function AccountSettingsPage.getTitle(p: string)
	return translate(v2[p])
end

return AccountSettingsPage
