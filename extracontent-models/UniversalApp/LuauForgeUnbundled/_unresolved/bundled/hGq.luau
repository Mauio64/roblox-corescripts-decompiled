local module = require("@luauforge/bundled/hGr")
local logger = require("@luauforge/bundled/hGs").Logger.new(nil, "SocialTabState")

local defineFastInt = game:DefineFastInt("SocialTabStateHttpRetryCount", 3)

local httpRequest = module.httpRequest
local v5 = logger:new("SocialTabState Networking")
local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		v5:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p3.requestMethod,
				p3.url,
				p2.StatusCode,
				p2.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local config2 = module.RoduxNetworking.config({
	keyPath = "SocialTab.NetworkStatus",
	networkImpl = config
})

local module2 = require("@luauforge/bundled/hGt")

local getFFlagSocialTabReplaceRefreshConversations = require("@luauforge/bundled/hGu").getFFlagSocialTabReplaceRefreshConversations

local v6 = {
	Rodux = require("@luauforge/bundled/hGv"),
	RoduxNetworking = config2,
	ShowContactImporterParams = require("@luauforge/bundled/hGw").ShowContactImporterParams,
	AppChatNetworking = require("@luauforge/bundled/hGx"),
	llama = module.llama,
	NetworkingChat = 0,
	RoduxUsers = 0,
	RoduxFriends = 0,
	RoduxPresence = 0
}
local v7 = if getFFlagSocialTabReplaceRefreshConversations() then module.NetworkingChat.config({
	roduxNetworking = config2
}) else nil
v6.NetworkingChat = v7

v6.RoduxUsers = module.RoduxUsers.config({ keyPath = "SocialTab.Users" })

v6.RoduxFriends = module2.config({ keyPath = "SocialTab.Friends" })

v6.RoduxPresence = module.RoduxPresence.config({ keyPath = "SocialTab.Presence" })
return v6
