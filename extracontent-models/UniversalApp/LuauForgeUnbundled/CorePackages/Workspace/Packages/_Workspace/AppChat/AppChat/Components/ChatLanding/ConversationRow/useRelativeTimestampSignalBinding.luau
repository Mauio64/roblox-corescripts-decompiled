local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local getConversationTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationTimestamp")

local function computeTimestamp(p2)
	if p2 == nil then
		return ""
	end

	return getConversationTimestamp(dateTime.fromUnixTimestamp(p2))
end

local function useRelativeTimestampSignalBinding(callback, callback2)
	local v5 = React.useState(function()
		local signal, v6 = Signals.createSignal(0)
		return { signal = signal, setSignal = v6 }
	end)

	React.useEffect(function()
		local flag = false
		local count = 0
		local function scheduleUpdate()
			task.delay(30, function()
				if flag then
					return
				end

				count += 1
				v5.setSignal(count)
				scheduleUpdate()
			end)
		end

		task.delay(30, function()
			if flag then
				return
			end

			count += 1
			v5.setSignal(count)
			scheduleUpdate()
		end)

		return function()
			flag = true
		end
	end, { v5 })

	local v6 = React.useCallback(function(p2, p3)
		v5.signal(p3)
		return computeTimestamp(callback2(p2, p3))
	end, { v5, callback2 })

	return SignalsReact.useSignalBinding(function(p2)
		return v6(callback(p2), p2)
	end)
end

return useRelativeTimestampSignalBinding
