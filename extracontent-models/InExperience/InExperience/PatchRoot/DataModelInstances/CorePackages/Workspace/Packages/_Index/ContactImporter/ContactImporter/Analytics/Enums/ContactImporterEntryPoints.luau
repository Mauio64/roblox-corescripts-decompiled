local ParentParent = script.Parent.Parent.Parent
local Contexts = require(ParentParent.dependencies).SocialLuaAnalytics.Analytics.Enums.Contexts

return {
	HomePage = `{ Contexts.HomePage }FriendsSort`,
	AddFriends = Contexts.AddFriends
}
