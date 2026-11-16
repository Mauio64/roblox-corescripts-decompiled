local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local RunService = game:GetService("RunService")

local React = require(parent.React)
local useBinding = React.useBinding
local useEffect = React.useEffect

local determineChatTimeoutInfo = require(InterventionShared.Utils.determineChatTimeoutInfo)

local function useTimeoutInfoBinding(p: string?, p2: number?)
	local heading, v = useBinding("")
	local description, v2 = useBinding("")
	local dateTime

	if p and p ~= "" then
		dateTime = DateTime.fromIsoDate(p)
	else
		dateTime = nil
	end

	useEffect(function()
		local _, v3, v4 = determineChatTimeoutInfo(dateTime, p2)
		v(v3)
		v2(v4)
	end, { dateTime, p2 })

	useEffect(function()
		local heartbeatConnection = nil

		if dateTime == nil then
			return
		end

		local now = DateTime.now()

		if dateTime.UnixTimestamp - now.UnixTimestamp <= 0 then
			return
		end

		local v3 = 0

		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now2 = os.clock()

			if now2 - v3 < 1 then
				return
			end

			v3 = now2

			local v4, v5, v6 = determineChatTimeoutInfo(dateTime, p2)
			v(v5)
			v2(v6)

			if v4 <= 0 and heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end)

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end
	end, { dateTime })

	return { heading = heading, description = description }
end

return useTimeoutInfoBinding
