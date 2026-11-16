local module = require("@luauforge/bundled/hKs")

local context = module.createContext(nil)

return table.freeze({
	useVisible = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useVisible must be used within a VisibleContext")
		end

		return v5
	end,
	VisibleContext = context
})
