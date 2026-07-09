local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local Url = require(LoginV2Parent.Http).Url

require(LoginV2.Common.LoginV2RequestTypes)

function getInitializeLoginUrl() -- line: 9
	-- upvalues: Url (copy)
	return string.format("%sv1/identity/initialize-login", Url.AUTH_URL)
end

return function(p1, p2) -- line: 13
	-- upvalues: HttpService (copy)
	local json = HttpService:JSONEncode(p2)

	return p1(getInitializeLoginUrl(), "POST", {
		postBody = json
	})
end
