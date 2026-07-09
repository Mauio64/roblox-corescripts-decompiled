local Parent = script:FindFirstAncestor("AuthCommon").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1) -- line: 6
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("apis:auth-token-service/v1/login/create")(), "POST", {
		postBody = ""
	})
end
