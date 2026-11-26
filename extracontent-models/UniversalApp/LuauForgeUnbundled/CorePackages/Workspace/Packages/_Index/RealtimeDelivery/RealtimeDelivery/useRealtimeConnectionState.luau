local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")

local useRobloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/useRobloxEventReceiver")

local function useRealtimeConnectionState()
	local v5 = useRobloxEventReceiver()
	local state, setState = React.useState(Enum.ConnectionState.Connected)

	React.useEffect(function()
		local v6 = v5:observeEvent("signalR", function(p2)
			setState(p2)
		end)

		return function()
			v6:disconnect()
		end
	end, { v5 })

	return state
end

return useRealtimeConnectionState
