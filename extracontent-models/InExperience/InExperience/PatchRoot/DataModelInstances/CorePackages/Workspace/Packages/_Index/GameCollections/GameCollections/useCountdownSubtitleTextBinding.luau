local RunService = game:GetService("RunService")
local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent
local React = require(parent.React)
local calculateCountdownTime = require(GameCollections.calculateCountdownTime)

local function validateTimeValues(data): boolean -- 1 equivalent call inferred from this helper
	if data.days < 0 then
		return false
	end

	return not (data.hours < 0 or data.hours > 23) and not (data.minutes < 0 or data.minutes > 59)
end

local function getUpdateFrequency(p: number): number -- 2 equivalent calls inferred from this helper
	return if p < 15 then 1 else 15
end

local function useCountdownSubtitleTextBinding(p: number?, value: string?, p2: string?)
	local state, setState = React.useState("")
	local v = React.useCallback(function()
		if p2 == nil or p2 == "" or p == nil or value == nil or value == "" then
			return 0
		end

		local v = p2
		local v2 = p - DateTime.now().UnixTimestamp
		local v3 = calculateCountdownTime(v2)

		if validateTimeValues(v3) then -- inferred equivalent call
			if v3.days > 0 then
				v = p2
			else
				v = value:gsub("{hours}", (tostring(v3.hours))):gsub("{minutes}", (tostring(v3.minutes)))
			end
		end

		setState(v)
		return v2
	end, { p2, p, value })

	React.useEffect(function()
		v()
	end, { v })

	React.useEffect(function()
		local heartbeatConnection = nil

		if p2 ~= nil and p2 ~= "" and p ~= nil and value ~= nil and value ~= "" then
			local v2 = p - DateTime.now().UnixTimestamp

			if v2 > 0 then
				local v3 = 0
				local updateFrequency = getUpdateFrequency(v2) -- inferred equivalent call
				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now = os.clock()

					if now - v3 < updateFrequency then
						return
					end

					v3 = now
					v2 = v()
					updateFrequency = getUpdateFrequency(v2) -- inferred equivalent call

					if v2 <= 0 and heartbeatConnection then
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
	end, { p, v })

	return state
end

return useCountdownSubtitleTextBinding
