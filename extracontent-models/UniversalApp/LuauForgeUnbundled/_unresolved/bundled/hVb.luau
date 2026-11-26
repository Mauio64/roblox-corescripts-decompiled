local module = require("@luauforge/bundled/hVa")
local module2 = require("@luauforge/bundled/hVc")

require("@luauforge/bundled/hUX")

local context = module.createContext(nil)

return table.freeze({
	useRoute = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useRoute must be used within a RouteContext")
		end

		return v5
	end,
	useFocused = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useRoute must be used within a RouteContext")
		end

		return module2.useSignalState(v5.focused)
	end,
	RouteContext = context
})
