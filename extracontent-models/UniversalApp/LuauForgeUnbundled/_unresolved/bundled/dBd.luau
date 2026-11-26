require("@luauforge/bundled/dBc")
local createSessionScopedSignal = require("@luauforge/bundled/dBe").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal("")

	return {
		getCountryCode = sessionScopedSignal,
		setCountryCode = v5,
		reset = function()
			v5("")
		end
	}
end
