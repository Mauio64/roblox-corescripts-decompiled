local parent = script.Parent.Parent
local ACCOUNT_SETTINGS_URL = require(parent.ACCOUNT_SETTINGS_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetBlockedUsers" }, function(callback, p2)
		return callback(ACCOUNT_SETTINGS_URL, {
			currentUserId = p2 and p2.currentUserId or nil
		}):path("v1"):path("users"):path("get-detailed-blocked-users")
	end)
end
