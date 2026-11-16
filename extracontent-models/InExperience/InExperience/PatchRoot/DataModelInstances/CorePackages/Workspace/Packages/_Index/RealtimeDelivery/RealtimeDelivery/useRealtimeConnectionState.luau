local parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(parent.React)

local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)

local function useRealtimeConnectionState()
	local v = useRobloxEventReceiver()
	local state, setState = React.useState(Enum.ConnectionState.Connected)

	React.useEffect(function()
		local v2 = v:observeEvent("signalR", function(p)
			setState(p)
		end)

		return function()
			v2:disconnect()
		end
	end, { v })

	return state
end

return useRealtimeConnectionState
