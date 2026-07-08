local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 24
	-- upvalues: Url (copy)
	return p1(`{ Url.APIS_URL }user-settings-api/v1/user-settings/settings-and-options`, "GET")
end
