local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")

local function formatRemaining(p2)
	local v5 = math.max(math.floor(p2), 0)
	local v6 = math.floor(v5 / 86400)
	local v7 = math.floor(v5 % 86400 / 3600)
	local v8 = math.floor(v5 % 3600 / 60)
	local v9 = v5 % 60

	local v10 = {}

	if v6 > 0 then
		table.insert(v10, string.format("%dd", v6))
	end

	if v7 > 0 then
		table.insert(v10, string.format("%dh", v7))
	end

	if v8 > 0 then
		table.insert(v10, string.format("%dm", v8))
	end

	table.insert(v10, string.format("%ds", v9))
	return table.concat(v10, " ")
end

local function computeText(p2)
	if p2 == nil then
		return ""
	end

	local v5 = p2 - DateTime.now().UnixTimestamp

	if v5 <= 0 then
		return ""
	end

	return formatRemaining(v5)
end

local function useCountdownText(p2)
	local state, setState = React.useState(function()
		return computeText(p2)
	end)

	React.useEffect(function()
		setState(computeText(p2))

		if p2 == nil or p2 - DateTime.now().UnixTimestamp <= 0 then
			return
		end

		local heartbeatConnection = nil
		local v5 = 0
		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now = os.clock()

			if now - v5 < 1 then
				return
			end

			v5 = now
			setState(computeText(p2))

			if p2 - DateTime.now().UnixTimestamp <= 0 and heartbeatConnection then
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
	end, { p2 })

	return state
end

return useCountdownText
