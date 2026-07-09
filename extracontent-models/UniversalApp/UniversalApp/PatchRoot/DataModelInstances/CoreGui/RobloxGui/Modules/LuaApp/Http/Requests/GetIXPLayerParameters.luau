local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 4
	-- upvalues: Url (copy)
	return p1(string.format("%sproduct-experimentation-platform/v1/projects/1/layers/%s/values?parameters=%s", Url.APIS_URL, p2, table.concat(p3, ",")), "GET", {
		maxRetryCount = 0
	})
end
