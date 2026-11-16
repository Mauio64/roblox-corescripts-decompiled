local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useBinding = React.useBinding
local useEffect = React.useEffect

local determineChatTimeoutInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/determineChatTimeoutInfo")

local function useTimeoutInfoBinding(p2, p3)
	local v5, v6 = useBinding("")
	local v7, v8 = useBinding("")

	local dateTime = if p2 and p2 ~= "" then DateTime.fromIsoDate(p2) else nil

	useEffect(function()
		local v9, v10, v11 = determineChatTimeoutInfo(dateTime, p3)
		v6(v10)
		v8(v11)
	end, { dateTime, p3 })

	useEffect(function()
		local heartbeatConnection = nil

		if dateTime == nil then
			return
		end

		local now = DateTime.now()

		if dateTime.UnixTimestamp - now.UnixTimestamp <= 0 then
			return
		end

		local v9 = 0

		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now2 = os.clock()

			if now2 - v9 < 1 then
				return
			end

			v9 = now2

			local v10, v11, v12 = determineChatTimeoutInfo(dateTime, p3)
			v6(v11)
			v8(v12)

			if v10 <= 0 and heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end)

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end
	end, { dateTime })

	return { heading = v5, description = v7 }
end

return useTimeoutInfoBinding
