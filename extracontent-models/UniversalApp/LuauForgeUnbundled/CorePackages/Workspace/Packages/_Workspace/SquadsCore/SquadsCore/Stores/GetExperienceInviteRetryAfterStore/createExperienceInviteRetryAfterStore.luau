require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SignalsUtils").createSessionScopedSignal

local function defaultSchedule(duration, callback)
	local thread = task.delay(duration, callback)
	return function()
		task.cancel(thread)
	end
end

return function(p2)
	local schedule = p2 and p2.schedule or defaultSchedule

	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)

	local v6 = nil

	return {
		getBlockedSquadId = sessionScopedSignal,
		block = function(p3, p4)
			if v6 then
				v6()
				v6 = nil
			end

			if p4 <= 0 then
				v5(nil)
				return
			end

			v5(p3)
			v6 = schedule(p4, function()
				v6 = nil
				v5(nil)
			end)
		end,
		unblock = function(p3)
			if p3 ~= nil and sessionScopedSignal(false) ~= p3 then
				return
			end

			if v6 then
				v6()
				v6 = nil
			end

			v5(nil)
		end
	}
end
