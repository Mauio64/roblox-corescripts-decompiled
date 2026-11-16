local parent = script:FindFirstAncestor("SquadsCore").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function defaultSchedule(duration: number, callback)
	local thread = task.delay(duration, callback)
	return function()
		task.cancel(thread)
	end
end

return function(p)
	local schedule = p and p.schedule or defaultSchedule

	local sessionScopedSignal, v = createSessionScopedSignal(nil)

	local v2 = nil

	local function fn() -- 2 equivalent calls inferred from this helper
		if v2 then
			v2()
			v2 = nil
		end
	end

	return {
		getBlockedSquadId = sessionScopedSignal,
		block = function(p2: string, p3: number)
			fn() -- inferred equivalent call

			if p3 <= 0 then
				v(nil)
				return
			end

			v(p2)
			v2 = schedule(p3, function()
				v2 = nil
				v(nil)
			end)
		end,
		unblock = function(p2: string?)
			if p2 ~= nil and sessionScopedSignal(false) ~= p2 then
				return
			end

			fn() -- inferred equivalent call
			v(nil)
		end
	}
end
