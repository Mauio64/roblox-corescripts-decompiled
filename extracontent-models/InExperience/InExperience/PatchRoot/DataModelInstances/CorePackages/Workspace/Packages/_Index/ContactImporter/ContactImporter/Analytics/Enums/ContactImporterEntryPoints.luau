local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts

return {
	HomePage = `{contexts.HomePage}FriendsSort`,
	AddFriends = contexts.AddFriends
}
