require("@luauforge/bundled/gvb")
local module = require("@luauforge/bundled/gvd")
local createSessionScopedSignal = require("@luauforge/bundled/gve").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)
	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)

	return {
		getUserModerated = sessionScopedSignal,
		getModerationDetail = sessionScopedSignal2,
		setModerationStatus = function(p2)
			module.batch(function()
				v5(p2)
				v6(nil)
			end)
		end,
		setModerationDetail = function(p2)
			v6(p2)
		end,
		reset = function()
			module.batch(function()
				v5(nil)
				v6(nil)
			end)
		end
	}
end
