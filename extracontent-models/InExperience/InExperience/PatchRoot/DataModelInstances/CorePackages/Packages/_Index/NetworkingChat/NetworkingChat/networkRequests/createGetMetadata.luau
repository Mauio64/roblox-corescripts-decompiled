local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetMetadata" }, function(callback)
		return callback(CHAT_URL):path("v2"):path("metadata")
	end)
end
