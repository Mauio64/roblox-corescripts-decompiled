local scriptParent = script.Parent
local GetReactSchedulerIXPConfig = require(scriptParent.SharedFlags).GetReactSchedulerIXPConfig
local Scheduler = require(scriptParent.Scheduler)
local default = require(scriptParent.AppStartup).AppStartupSequence.default

require(scriptParent.AppCommonLib)

local v5 = game:DefineFastInt("LuaAppStartupReactSchedulerDelayMs", 0)
local v6 = game:DefineFastInt("LuaAppStartupReactSchedulerInterval", 15)

return {
	startup = function() -- line: 13
		-- upvalues: GetReactSchedulerIXPConfig (copy), Scheduler (copy), v5 (copy), v6 (copy), default (copy)
		local v7 = GetReactSchedulerIXPConfig()

		if v7 then
			Scheduler.unstable_setSchedulerFlags(v7)
		end

		if v5 > 0 then
			local v8 = Scheduler.unstable_getSchedulerFlags()

			Scheduler.unstable_setSchedulerFlags({
				yieldInterval = v6
			})

			local u9 = nil
			local u10 = nil

			local function resetFlags() -- line: 29
				-- upvalues: Scheduler (copy), v8 (copy), u10 (ref), u9 (ref)
				Scheduler.unstable_setSchedulerFlags(v8)

				if u10 then
					u10:disconnect()
					u10 = nil
				end

				u9 = nil
			end

			u9 = task.delay(v5 / 1000, resetFlags)
			u10 = default.changed:connect(function() -- line: 40
				-- upvalues: default (copy), u9 (ref), Scheduler (copy), v8 (copy), u10 (ref)
				if default.isInteractive and u9 then
					task.cancel(u9)
					Scheduler.unstable_setSchedulerFlags(v8)

					if u10 then
						u10:disconnect()
						u10 = nil
					end

					u9 = nil
				end
			end)
		end
	end
}
