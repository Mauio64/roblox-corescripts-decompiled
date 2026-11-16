require("@luauforge/bundled/dxZ")
local createSessionScopedSignal = require("@luauforge/bundled/dyb").createSessionScopedSignal

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
