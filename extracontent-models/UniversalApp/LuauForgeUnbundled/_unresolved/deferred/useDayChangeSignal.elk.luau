local module = require("@luauforge/deferred/ejR")

local module2 = require("@luauforge/deferred/ell")

local function useDayChangeSignal()
	local state, setState = module.useState(function()
		return module2.getLocalDayStartMs(DateTime.now().UnixTimestampMillis)
	end)

	module.useEffect(function()
		local flag = false
		local thread = nil
		local function scheduleNextMidnightUpdate()
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v5 = (module2.getNextLocalMidnightMs(unixTimestampMillis) - unixTimestampMillis) / 1000

			thread = task.delay(math.max(v5, 1), function()
				thread = nil

				if flag then
					return
				end

				setState(module2.getLocalDayStartMs(DateTime.now().UnixTimestampMillis))
				scheduleNextMidnightUpdate()
			end)
		end

		scheduleNextMidnightUpdate()

		return function()
			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {})

	return state
end

return useDayChangeSignal
