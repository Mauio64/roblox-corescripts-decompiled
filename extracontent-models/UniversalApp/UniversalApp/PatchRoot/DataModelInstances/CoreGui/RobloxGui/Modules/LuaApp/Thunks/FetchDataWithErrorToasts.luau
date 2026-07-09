local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local SetNetworkingErrorToast = require(script.Parent.SetNetworkingErrorToast)

return function(p1) -- line: 7
	-- upvalues: Promise (copy), SetNetworkingErrorToast (copy)
	return function(p2) -- line: 8
		-- upvalues: p1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return p2:dispatch(p1):andThen(function(p3) -- line: 9
			-- upvalues: Promise (copy)
			return Promise.resolve(p3)
		end, function(p4) -- line: 11
			-- upvalues: p2 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p2:dispatch(SetNetworkingErrorToast(p4))

			return Promise.reject(p4)
		end)
	end
end
