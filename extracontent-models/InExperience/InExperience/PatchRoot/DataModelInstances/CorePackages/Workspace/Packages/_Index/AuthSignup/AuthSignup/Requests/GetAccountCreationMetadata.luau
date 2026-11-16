local parent = script:FindFirstAncestor("AuthSignup").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%sv1/account-creation/metadata", Url.AUTH_URL), "GET", {
		maxRetryCount = 0
	})
end
