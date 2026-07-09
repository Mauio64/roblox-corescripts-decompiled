local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url
local v3 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "phone-number-api/v1/phone-prefix-list",
	base = Url.APIS_URL
})

return function(p1) -- line: 23
	-- upvalues: v3 (copy)
	return p1(v3(), "GET")
end
