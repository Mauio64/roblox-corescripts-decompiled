local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local calculateCountdownTime = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/calculateCountdownTime")

local function validateTimeValues(data): boolean
	if data.days < 0 or (data.hours < 0 or data.hours > 23) then
		return false
	end

	return not (data.minutes < 0 or data.minutes > 59)
end

local function getUpdateFrequency(p2): number
	if p2 < 15 then
		return 1
	end

	return 15
end

local function useCountdownSubtitleTextBinding(p2, value, p3)
	local state, setState = React.useState("")
	local v5 = React.useCallback(function()
		if p3 == nil or p3 == "" or p2 == nil or value == nil or value == "" then
			return 0
		end

		local v6 = p3
		local v7 = p2 - DateTime.now().UnixTimestamp
		local v8 = calculateCountdownTime(v7)
		local v9

		if v8.days < 0 or v8.hours < 0 or v8.hours > 23 then
			v9 = false
		else
			v9 = not (v8.minutes < 0 or v8.minutes > 59)
		end

		if v9 then
			if v8.days > 0 then
				v6 = p3
			else
				v6 = value:gsub("{hours}", (tostring(v8.hours))):gsub("{minutes}", (tostring(v8.minutes)))
			end
		end

		setState(v6)
		return v7
	end, { p3, p2, value })

	React.useEffect(function()
		v5()
	end, { v5 })

	React.useEffect(function()
		local heartbeatConnection = nil

		if p3 ~= nil and p3 ~= "" and p2 ~= nil and value ~= nil and value ~= "" then
			local v6 = p2 - DateTime.now().UnixTimestamp

			if v6 > 0 then
				local v7 = 0
				local v8 = v6 < 15 and 1 or 15

				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now2 = os.clock()

					if now2 - v7 < v8 then
						return
					end

					v7 = now2
					v6 = v5()
					v8 = v6 < 15 and 1 or 15

					if v6 <= 0 and heartbeatConnection then
						heartbeatConnection:Disconnect()
						heartbeatConnection = nil
					end
				end)
			end
		end

		return function()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end, { p2, v5 })

	return state
end

return useCountdownSubtitleTextBinding
