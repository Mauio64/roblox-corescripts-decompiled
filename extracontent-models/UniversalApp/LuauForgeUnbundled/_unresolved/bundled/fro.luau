local module = require("@luauforge/bundled/frp")
local module2 = require("@luauforge/bundled/frq")

return module.createComputed(function()
	local sessionScopedSignal, v5 = module2.createSessionScopedSignal(false)

	return {
		getFocused = sessionScopedSignal,
		setFocused = v5,
		reset = function()
			v5(false)
		end
	}
end)
