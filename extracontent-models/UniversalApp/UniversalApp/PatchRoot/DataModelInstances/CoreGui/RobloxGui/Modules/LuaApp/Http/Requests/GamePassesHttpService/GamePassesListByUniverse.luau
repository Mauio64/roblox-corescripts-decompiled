local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 4
	-- upvalues: Url (copy)
	return p1(string.format("%sgame-passes/v1/universes/%s/game-passes?pageSize=50&passView=Full", Url.APIS_URL, p2), "GET")
end
