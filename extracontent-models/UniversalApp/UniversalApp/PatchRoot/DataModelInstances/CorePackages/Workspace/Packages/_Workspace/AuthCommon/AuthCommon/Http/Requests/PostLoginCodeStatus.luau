local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Promise = require(Parent.Promise)

return function(p1, p2, p3) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy), Promise (copy)
	if type(p2) == "string" and type(p3) == "string" then
		local v8 = UrlBuilder.fromString("apis:auth-token-service/v1/login/status")
		local json = HttpService:JSONEncode({
			code = p2,
			privateKey = p3
		})

		return p1(v8(), "POST", {
			postBody = json
		})
	end

	if type(p2) ~= "string" then
		return Promise.reject("invalid login code")
	end

	return Promise.reject("invalid private key")
end
