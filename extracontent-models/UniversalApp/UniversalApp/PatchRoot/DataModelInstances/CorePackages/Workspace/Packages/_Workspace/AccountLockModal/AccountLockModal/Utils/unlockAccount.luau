local Parent = script:FindFirstAncestor("AccountLockModal").Parent
local Url = require(Parent.Http).Url
local HttpService = game:GetService("HttpService")

return function(p1) -- line: 9
	-- upvalues: Url (copy), HttpService (copy)
	return p1(Url.APIS_URL .. "account-unlock-api/v1/unlock", "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
