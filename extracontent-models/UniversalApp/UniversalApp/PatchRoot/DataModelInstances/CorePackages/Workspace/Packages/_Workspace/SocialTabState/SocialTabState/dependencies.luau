local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local v3 = require(ParentParent.Lumberyak).Logger.new(nil, "SocialTabState")
local v4 = game:DefineFastInt("SocialTabStateHttpRetryCount", 3)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v6 = v3:new("SocialTabState Networking")
local v7 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 13
		-- upvalues: v6 (copy), httpRequest (copy)
		v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 17
		-- upvalues: v6 (copy)
		v6:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v4
})
local v8 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "SocialTab.NetworkStatus",
	networkImpl = v7
})
local FriendsRodux = require(ParentParent.FriendsRodux)
local getFFlagSocialTabReplaceRefreshConversations = require(ParentParent.SharedFlags).getFFlagSocialTabReplaceRefreshConversations

return {
	Rodux = require(ParentParent.Rodux),
	RoduxNetworking = v8,
	ShowContactImporterParams = require(ParentParent.ContactImporter).ShowContactImporterParams,
	AppChatNetworking = require(ParentParent.AppChatNetworking),
	llama = LuaSocialLibrariesDeps.llama,
	NetworkingChat = getFFlagSocialTabReplaceRefreshConversations() and LuaSocialLibrariesDeps.NetworkingChat.config({
		roduxNetworking = v8
	}) or nil,
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = "SocialTab.Users"
	}),
	RoduxFriends = FriendsRodux.config({
		keyPath = "SocialTab.Friends"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "SocialTab.Presence"
	})
}
