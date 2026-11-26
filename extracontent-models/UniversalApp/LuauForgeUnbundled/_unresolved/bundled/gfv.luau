local module = require("@luauforge/bundled/gfw")
local module2 = require("@luauforge/bundled/gfx")

return function(p2)
	return function(object)
		return module(p2):andThen(function(p3)
			local unreadNotifications = p3.responseBody.unreadNotifications
			object:dispatch(module2(unreadNotifications))

			return unreadNotifications
		end)
	end
end
