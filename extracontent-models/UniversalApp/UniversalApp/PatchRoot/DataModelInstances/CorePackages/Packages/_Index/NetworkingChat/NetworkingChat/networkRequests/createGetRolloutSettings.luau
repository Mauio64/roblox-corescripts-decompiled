local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetRolloutSettings" }, function(callback, p2)
		return callback(CHAT_URL):path("v2"):path("get-rollout-settings"):expandedQueryArgsWithIds("featureNames", p2)
	end)
end
