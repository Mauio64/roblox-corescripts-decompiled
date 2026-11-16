local parent = script:FindFirstAncestor("AuthCommon").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%sv2/metadata", Url.AUTH_URL), "GET")
end
