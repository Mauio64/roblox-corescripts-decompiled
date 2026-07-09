local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local Url = require(Parent.Http).Url

require(Parent.Http)

function getCurrentTwoStepMethodUrl(s1: string) -- line: 7
	-- upvalues: Url (copy)
	return string.format("%saccount-recovery-service/v1/get-current-two-step-method?recoverySessionId=%s", Url.APIS_URL, s1)
end

return function(p1, s2: string) -- line: 15
	return p1(getCurrentTwoStepMethodUrl(s2), "GET")
end
