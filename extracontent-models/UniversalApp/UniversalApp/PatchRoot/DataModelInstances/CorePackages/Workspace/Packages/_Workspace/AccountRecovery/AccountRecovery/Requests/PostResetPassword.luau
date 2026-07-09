local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local Url = require(AccountRecoveryParent.Http).Url

require(AccountRecoveryParent.Http)
require(AccountRecovery.Common.AccountRecoveryRequestTypes)

function getResetPasswordUrl() -- line: 10
	-- upvalues: Url (copy)
	return string.format("%sv2/passwords/reset", Url.AUTH_URL)
end

return function(p1, p2) -- line: 14
	-- upvalues: HttpService (copy)
	local json = HttpService:JSONEncode(p2)

	return p1(getResetPasswordUrl(), "POST", {
		postBody = json
	})
end
