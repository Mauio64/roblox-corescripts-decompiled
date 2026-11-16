local module = require("@luauforge/bundled/fBd")
local module2 = require("@luauforge/bundled/fBe")

return function(p2)
	return function(object)
		return module(p2):andThen(function(p3)
			local unreadNotifications = p3.responseBody.unreadNotifications
			object:dispatch(module2(unreadNotifications))

			return unreadNotifications
		end)
	end
end
