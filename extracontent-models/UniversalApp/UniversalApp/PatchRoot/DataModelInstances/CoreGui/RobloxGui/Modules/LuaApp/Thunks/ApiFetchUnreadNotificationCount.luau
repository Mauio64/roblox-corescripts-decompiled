local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetUnreadNotificationCount = require(Modules.LuaApp.Http.Requests.GetUnreadNotificationCount)
local SetNotificationCount = require(Modules.LuaApp.Actions.SetNotificationCount)

return function(p1) -- line: 7
	-- upvalues: GetUnreadNotificationCount (copy), SetNotificationCount (copy)
	return function(p2) -- line: 8
		-- upvalues: GetUnreadNotificationCount (copy), p1 (copy), SetNotificationCount (copy)
		return GetUnreadNotificationCount(p1):andThen(function(p3) -- line: 9
			-- upvalues: p2 (copy), SetNotificationCount (copy)
			local unreadNotifications = p3.responseBody.unreadNotifications

			p2:dispatch(SetNotificationCount(unreadNotifications))

			return unreadNotifications
		end)
	end
end
