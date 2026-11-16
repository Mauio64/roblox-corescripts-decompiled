local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("DictationCore").Parent

local React = require(parent.React)
local UseTickClock = {}

function UseTickClock.useTickClock(data)
	local ref = React.useRef(data.onTick)
	ref.current = data.onTick

	local ref2 = React.useRef(data.onFrame)
	ref2.current = data.onFrame

	local intervalSec = data.intervalSec
	local enabled = data.enabled
	local testHeartbeat = data.testHeartbeat or RunService.Heartbeat

	React.useEffect(function()
		if not enabled then
			return
		end

		local v = 0
		local connection = testHeartbeat:Connect(function(p: number)
			local v2 = intervalSec
			local v3 = v + p
			local v4

			if v2 <= 0 then
				v4 = 0
			else
				v4 = math.floor(v3 / v2)
				v3 -= v4 * v2
			end

			v = v3

			for _ = 1, v4 do
				ref.current()
			end

			local v5 = not (intervalSec > 0) and 0 or v / intervalSec
			ref2.current(v5)
		end)

		return function()
			connection:Disconnect()
		end
	end, { enabled, intervalSec, testHeartbeat })
end

function UseTickClock.advanceClock(p: number, p2: number, p3: number)
	local v = p + p2

	if p3 <= 0 then
		return 0, v
	end

	local v2 = math.floor(v / p3)
	return v2, v - v2 * p3
end

return UseTickClock
