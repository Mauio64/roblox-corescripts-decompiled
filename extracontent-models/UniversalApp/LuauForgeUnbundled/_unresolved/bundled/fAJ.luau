local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")

return function(p2)
	return function(object)
		object:dispatch(module2(module.LeaveRobloxAlert, { continueFunc = p2 }))
	end
end
