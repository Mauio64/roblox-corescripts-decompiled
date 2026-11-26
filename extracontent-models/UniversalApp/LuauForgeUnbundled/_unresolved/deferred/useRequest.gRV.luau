local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.LuauPolyfill)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gRT")
local Promise = require(CorePackages.Packages.Promise)

local function useRequest(callback)
	local state, setState = React.useState({ status = module.None })
	local ref = React.createRef()

	return state, (React.useCallback(function()
		if ref.current then
			return Promise.resolve()
		end

		setState({ status = module.Pending })
		ref.current = true

		return callback():andThen(function(p2)
			setState({ status = module.Resolved, response = p2 })
			ref.current = false
		end, function(p2)
			setState({ status = module.Rejected, response = p2 })
			ref.current = false
		end)
	end, { callback, ref.current }))
end

return useRequest
