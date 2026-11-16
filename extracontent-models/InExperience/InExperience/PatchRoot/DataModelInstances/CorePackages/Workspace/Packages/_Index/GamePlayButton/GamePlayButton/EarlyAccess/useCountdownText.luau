local parent = script:FindFirstAncestor("GamePlayButton").Parent

local RunService = game:GetService("RunService")

local React = require(parent.React)

local function formatRemaining(p: number)
	local v = math.max(math.floor(p), 0)
	local v2 = math.floor(v / 86400)
	local v3 = math.floor(v % 86400 / 3600)
	local v4 = math.floor(v % 3600 / 60)
	local v5 = v % 60

	local v6 = {}

	if v2 > 0 then
		table.insert(v6, string.format("%dd", v2))
	end

	if v3 > 0 then
		table.insert(v6, string.format("%dh", v3))
	end

	if v4 > 0 then
		table.insert(v6, string.format("%dm", v4))
	end

	table.insert(v6, string.format("%ds", v5))
	return table.concat(v6, " ")
end

local function computeText(p: number?)
	if p == nil then
		return ""
	end

	local v = p - DateTime.now().UnixTimestamp

	if v <= 0 then
		return ""
	end

	return formatRemaining(v)
end

local function useCountdownText(p: number?)
	local state, setState = React.useState(function()
		return computeText(p)
	end)

	React.useEffect(function()
		setState(computeText(p))

		if p == nil or p - DateTime.now().UnixTimestamp <= 0 then
			return
		end

		local heartbeatConnection = nil
		local v = 0
		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now = os.clock()

			if now - v < 1 then
				return
			end

			v = now
			setState(computeText(p))

			if p - DateTime.now().UnixTimestamp <= 0 and heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end)

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end, { p })

	return state
end

return useCountdownText
