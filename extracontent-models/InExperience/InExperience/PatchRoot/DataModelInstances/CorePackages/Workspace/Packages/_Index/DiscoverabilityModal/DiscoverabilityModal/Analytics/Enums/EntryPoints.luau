local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts

return {
	AddFriends = contexts.AddFriends,
	HomePage = `{contexts.HomePage}FriendsSort`,
	HomePageProfile = `{contexts.HomePage}Profile`,
	SocialTabProfile = `{contexts.SocialTab}Profile`,
	ContactsList = `{contexts.ContactImport}FindFriendsBanner`
}
