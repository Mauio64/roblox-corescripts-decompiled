local ALIAS_URL = require(script.Parent.Parent.ALIAS_URL)
require(script.Parent.Parent.networkingAliasesTypes)

return function(p)
	return p.roduxNetworking.POST({ Name = "SetUserTag" }, function(callback, targetUserId, userTag: string)
		return callback(ALIAS_URL):path("v1"):path("user"):path("tag"):body({
			targetUserId = targetUserId,
			userTag = userTag
		})
	end)
end
