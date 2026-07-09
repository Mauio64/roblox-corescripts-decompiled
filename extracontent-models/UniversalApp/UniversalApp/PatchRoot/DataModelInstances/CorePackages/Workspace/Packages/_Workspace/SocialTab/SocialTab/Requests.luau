local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local FetchChatSettings = require(SocialTabParent.AppChat.FetchChatSettings)
local NetworkingUsers = require(SocialTab.dependencies).NetworkingUsers

return {
	FetchChatSettings = FetchChatSettings,
	GetUserV2FromUserId = NetworkingUsers.GetUserV2FromUserId
}
