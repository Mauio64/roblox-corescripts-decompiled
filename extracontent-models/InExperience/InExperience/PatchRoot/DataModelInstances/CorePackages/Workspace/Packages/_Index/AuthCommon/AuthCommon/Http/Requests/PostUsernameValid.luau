local AuthCommon = script:FindFirstAncestor("AuthCommon")
local HttpService = game:GetService("HttpService")
local AuthCommonParent = AuthCommon.Parent
local UrlBuilder = require(AuthCommonParent.UrlBuilder).UrlBuilder
local UsernameValidationContext = require(AuthCommon.Enums.UsernameValidationContext)

return function(p1, p2, p3, p4) -- line: 12
	-- upvalues: UsernameValidationContext (copy), UrlBuilder (copy), HttpService (copy)
	if not p4 then
		p4 = UsernameValidationContext.Unknown
	end

	assert(type(p2) == "string", "invalid username")
	assert(type(p3) == "string", "invalid birthday")

	local v10 = UrlBuilder.fromString("auth:v2/usernames/validate")
	local json = HttpService:JSONEncode({
		username = p2,
		birthday = p3,
		context = p4
	})

	return p1(v10(), "POST", {
		postBody = json
	})
end
