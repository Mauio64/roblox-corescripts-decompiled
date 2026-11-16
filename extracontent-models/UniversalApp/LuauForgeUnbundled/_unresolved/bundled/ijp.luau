local fFlagEnableSchedulerFlagOverrides = require("@luauforge/bundled/ijq").FFlagEnableSchedulerFlagOverrides
local getReactSchedulerIXPConfig = require("@luauforge/bundled/ijq").GetReactSchedulerIXPConfig
local getSchedulerFlagOverrides = require("@luauforge/bundled/ijq").GetSchedulerFlagOverrides
local module = require("@luauforge/bundled/ijr")
local default = require("@luauforge/bundled/ijt").AppStartupSequence.default
require("@luauforge/bundled/iju")

local defineFastInt = game:DefineFastInt("LuaAppStartupReactSchedulerDelayMs", 0)
local defineFastInt2 = game:DefineFastInt("LuaAppStartupReactSchedulerInterval", 15)

return {
	startup = function()
		local reactSchedulerIXPConfig = getReactSchedulerIXPConfig()

		if reactSchedulerIXPConfig then
			module.unstable_setSchedulerFlags(reactSchedulerIXPConfig)
		end

		local v5 = fFlagEnableSchedulerFlagOverrides and getSchedulerFlagOverrides.getApp()

		if v5 then
			module.unstable_setSchedulerFlags(v5)
		end

		if defineFastInt > 0 then
			local unstable_getSchedulerFlags = module.unstable_getSchedulerFlags()

			module.unstable_setSchedulerFlags({ yieldInterval = defineFastInt2 })

			local thread = nil
			local changedConnection = nil

			local function resetFlags()
				module.unstable_setSchedulerFlags(unstable_getSchedulerFlags)

				if changedConnection then
					changedConnection:disconnect()
					changedConnection = nil
				end

				thread = nil
			end

			thread = task.delay(defineFastInt / 1000, resetFlags)

			changedConnection = default.changed:connect(function()
				if default.isInteractive and thread then
					task.cancel(thread)
					module.unstable_setSchedulerFlags(unstable_getSchedulerFlags)

					if changedConnection then
						changedConnection:disconnect()
						changedConnection = nil
					end

					thread = nil
				end
			end)
		end
	end
}
