local Parent = script:FindFirstAncestor("LoginV2").Parent
local Url = require(Parent.Http).Url

function getStartAuthenticationUrl() -- line: 6
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/StartAuthentication", Url.AUTH_URL)
end

return function(p1) -- line: 10
	return p1(getStartAuthenticationUrl(), "POST")
end
