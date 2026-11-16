local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local function readWallClockMs()
	return DateTime.now().UnixTimestampMillis
end

local function useMessageClock(data)
	local ref = React.useRef(data.getNowMs or readWallClockMs)
	ref.current = data.getNowMs or readWallClockMs

	local v = React.useMemo(function()
		local signal, setNow = Signals.createSignal(ref.current())
		return { now = signal, setNow = setNow }
	end, {})

	local enabled = data.enabled ~= false
	local intervalSeconds = data.intervalSeconds or 30

	React.useEffect(function()
		if not enabled then
			return function() end
		end

		v.setNow(ref.current())
		local thread = nil
		local function scheduleNext()
			thread = task.delay(intervalSeconds, function()
				thread = nil
				v.setNow(ref.current())
				scheduleNext()
			end)
		end

		thread = task.delay(intervalSeconds, function()
			thread = nil
			v.setNow(ref.current())
			scheduleNext()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { enabled, intervalSeconds })

	return v.now
end

return useMessageClock
