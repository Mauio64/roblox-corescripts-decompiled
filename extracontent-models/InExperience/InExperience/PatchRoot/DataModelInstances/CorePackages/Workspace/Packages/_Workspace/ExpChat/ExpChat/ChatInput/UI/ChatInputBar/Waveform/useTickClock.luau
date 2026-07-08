local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

return {
	useTickClock = function(t1: {[any]: any}) -- line: 38
		-- upvalues: React (copy), RunService (copy)
		local v10 = React.useRef(t1.onTick)

		v10.current = t1.onTick

		local v11 = React.useRef(t1.onFrame)

		v11.current = t1.onFrame

		local intervalSec = t1.intervalSec
		local enabled = t1.enabled
		local v14 = t1.testHeartbeat or RunService.Heartbeat

		React.useEffect(function() -- line: 49
			-- upvalues: enabled (copy), v14 (copy), intervalSec (copy), v10 (copy), v11 (copy)
			if not enabled then
				return
			end

			local n1 = 0
			local connection = v14:Connect(function(n2: number) -- line: 55
				-- upvalues: n1 (ref), intervalSec (copy), v10 (copy), v11 (copy)
				local v18 = n1
				local v19 = intervalSec
				local v20 = v18 + n2
				local n3

				if v19 <= 0 then
					n3 = 0
				else
					n3 = math.floor(v20 / v19)
					v20 -= n3 * v19
				end

				n1 = v20

				for _ = 1, n3 do
					v10.current()
				end

				local v23 = not (intervalSec > 0) and 0 or n1 / intervalSec

				v11.current(v23)
			end)

			return function() -- line: 67
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {
			enabled,
			intervalSec,
			v14
		})
	end,
	advanceClock = function(n4: number, n5: number, n6: number) -- line: 29
		local v7 = n4 + n5

		if n6 <= 0 then
			return 0, v7
		end

		local v8 = math.floor(v7 / n6)

		return v8, v7 - v8 * n6
	end
}
