local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(`{Url.APIS_URL}user-settings-api/v1/user-settings/settings-and-options`, "GET")
end
