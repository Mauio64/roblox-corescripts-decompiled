local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local Url = require(Parent.Http).Url

require(Parent.Http)

function getRequestRecoveryUrl() -- line: 7
	-- upvalues: Url (copy)
	return string.format("%sphone-number-api/v1/phone-prefix-list", Url.APIS_URL)
end

return function(p1) -- line: 11
	return p1(getRequestRecoveryUrl(), "GET")
end
