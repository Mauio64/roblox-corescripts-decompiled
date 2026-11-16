local ALIAS_URL = require(script.Parent.Parent.ALIAS_URL)
require(script.Parent.Parent.networkingAliasesTypes)

return function(p)
	return p.roduxNetworking.POST({ Name = "GetTagsFromUserIds" }, function(callback, targetUserIds)
		return callback(ALIAS_URL):path("v1"):path("user"):path("get-tags"):body({
			targetUserIds = targetUserIds
		})
	end)
end
