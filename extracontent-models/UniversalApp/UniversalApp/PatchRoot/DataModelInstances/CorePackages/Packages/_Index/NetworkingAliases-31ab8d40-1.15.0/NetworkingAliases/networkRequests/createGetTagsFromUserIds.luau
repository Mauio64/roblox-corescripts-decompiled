local ALIAS_URL = require(script.Parent.Parent.ALIAS_URL)

require(script.Parent.Parent.networkingAliasesTypes)

return function(p1) -- line: 4
	-- upvalues: ALIAS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "GetTagsFromUserIds"
	}, function(p2, p3) -- line: 7
		-- upvalues: ALIAS_URL (copy)
		return p2(ALIAS_URL):path("v1"):path("user"):path("get-tags"):body({
			targetUserIds = p3
		})
	end)
end
