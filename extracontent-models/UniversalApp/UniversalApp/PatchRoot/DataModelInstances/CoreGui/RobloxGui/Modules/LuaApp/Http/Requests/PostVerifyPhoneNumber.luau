local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 6
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p3) == "string", "invalid challenge has been passed into PostVerifyPhoneNumber")
	assert(type(p2) == "string", "invalid code has been passed into PostVerifyPhoneNumber")

	local v7 = string.format("%sv1/verified-signup/voucher", Url.AUTH_URL)
	local json = HttpService:JSONEncode({
		code = p2,
		challenge = p3
	})

	return p1(v7, "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
