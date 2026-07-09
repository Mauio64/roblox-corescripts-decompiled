local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 14
	-- upvalues: Url (copy)
	return p1(string.format("%sv2/stream-notifications/unread-count", Url.NOTIFICATION_URL), "GET")
end
