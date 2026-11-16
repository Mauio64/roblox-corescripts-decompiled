require("@luauforge/bundled/frX")
local module = require("@luauforge/bundled/frZ")
local createSessionScopedSignal = require("@luauforge/bundled/fsa").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)
	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)
	local sessionScopedSignal3, v7 = createSessionScopedSignal(nil)

	local sessionScopedSignal4, v8 = createSessionScopedSignal(nil)

	local sessionScopedSignal5, v9 = createSessionScopedSignal(nil)

	return {
		getIsGeneric = sessionScopedSignal,
		getPromptType = sessionScopedSignal2,
		getMetadata = sessionScopedSignal3,
		getLastUpdatedPromptTypeAt = sessionScopedSignal4,
		getAccountPinUnlockedUntil = sessionScopedSignal5,
		updatePromptType = function(p2, p3, p4)
			module.batch(function()
				local v10 = sessionScopedSignal2(false) ~= p3
				v5(p2 or nil)
				v6(p3 or nil)
				v7(p4 or nil)

				if v10 then
					v8(DateTime.now())
				end
			end)
		end,
		updateAccountPinUnlockTimeout = function(p2)
			v9(p2 or nil)
		end,
		reset = function()
			module.batch(function()
				v5(nil)
				v6(nil)
				v7(nil)
				v8(nil)
				v9(nil)
			end)
		end
	}
end
