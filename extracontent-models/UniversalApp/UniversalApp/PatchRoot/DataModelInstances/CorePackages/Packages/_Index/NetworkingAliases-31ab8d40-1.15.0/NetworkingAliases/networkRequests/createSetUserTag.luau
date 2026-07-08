local ALIAS_URL = require(script.Parent.Parent.ALIAS_URL)

require(script.Parent.Parent.networkingAliasesTypes)

return function(p1) -- line: 4
	-- upvalues: ALIAS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "SetUserTag"
	}, function(p2, p3, s1: string) -- line: 9
		-- upvalues: ALIAS_URL (copy)
		return p2(ALIAS_URL):path("v1"):path("user"):path("tag"):body({
			targetUserId = p3,
			userTag = s1
		})
	end)
end
