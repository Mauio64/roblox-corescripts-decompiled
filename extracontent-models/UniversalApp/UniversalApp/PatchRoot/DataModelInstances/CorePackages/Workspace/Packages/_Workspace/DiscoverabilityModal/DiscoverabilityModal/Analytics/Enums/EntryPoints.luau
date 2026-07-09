local ParentParent = script.Parent.Parent.Parent
local Contexts = require(ParentParent.dependencies).SocialLuaAnalytics.Analytics.Enums.Contexts

return {
	AddFriends = Contexts.AddFriends,
	HomePage = `{ Contexts.HomePage }FriendsSort`,
	HomePageProfile = `{ Contexts.HomePage }Profile`,
	SocialTabProfile = `{ Contexts.SocialTab }Profile`,
	ContactsList = `{ Contexts.ContactImport }FindFriendsBanner`
}
