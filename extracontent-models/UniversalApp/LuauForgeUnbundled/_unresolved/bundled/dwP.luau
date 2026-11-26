local module = require("@luauforge/bundled/dtg")
local setNetworkingErrorToast = require("@luauforge/bundled/dwQ").Thunks.SetNetworkingErrorToast

return function(p2)
	return function(object)
		return object:dispatch(p2):andThen(function(p3)
			return module.resolve(p3)
		end, function(p3)
			object:dispatch(setNetworkingErrorToast(p3))
			return module.reject(p3)
		end)
	end
end
