local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local Url = require(AccountRecoveryParent.Http).Url

require(AccountRecoveryParent.Http)
require(AccountRecovery.Common.AccountRecoveryRequestTypes)

function getSetEmailUrl() -- line: 10
	-- upvalues: Url (copy)
	return string.format("%saccount-recovery-service/v1/set-email", Url.APIS_URL)
end

return function(p1, p2) -- line: 14
	-- upvalues: HttpService (copy)
	local json = HttpService:JSONEncode(p2)

	return p1(getSetEmailUrl(), "POST", {
		postBody = json
	})
end
