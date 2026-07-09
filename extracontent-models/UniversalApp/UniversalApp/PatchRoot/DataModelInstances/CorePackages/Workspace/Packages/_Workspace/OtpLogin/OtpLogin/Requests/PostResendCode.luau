local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local HttpService = game:GetService("HttpService")
local UrlBuilder = dependencies.UrlBuilder.UrlBuilder
local UrlBase = dependencies.UrlBuilder.UrlBase

require(ParentParent.Common.otpLoginTypes)

local v6 = UrlBuilder.new({
	path = "otp-service/v1/resendCode",
	base = UrlBase.APIS
})

return function(p1, p2) -- line: 19
	-- upvalues: v6 (copy), HttpService (copy)
	local v9 = v6
	local json = HttpService:JSONEncode({
		origin = p2.origin,
		contactType = p2.contactType,
		otpSessionToken = p2.otpSessionToken
	})

	return p1(v9(), "POST", {
		postBody = json
	})
end
