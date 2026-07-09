local Parent = script:FindFirstAncestor("AuthCommon").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1) -- line: 6
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("auth:v1/session/refresh")(), "POST", {
		postBody = ""
	})
end
