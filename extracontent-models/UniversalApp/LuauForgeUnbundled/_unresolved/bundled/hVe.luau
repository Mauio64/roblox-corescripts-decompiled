local module = require("@luauforge/bundled/hVa")
local module2 = require("@luauforge/bundled/hVc")

require("@luauforge/bundled/hUX")

local context = module.createContext(nil)

return table.freeze({
	NavigatorContext = context,
	useNavigator = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useNavigator must be used within a NavigatorContext")
		end

		return v5
	end,
	useState = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useNavigator must be used within a NavigatorContext")
		end

		if v5.route.state == nil then
			error("useState must be used within a NavigatorContext")
		end

		return module2.useSignalState(v5.route.state)
	end
})
