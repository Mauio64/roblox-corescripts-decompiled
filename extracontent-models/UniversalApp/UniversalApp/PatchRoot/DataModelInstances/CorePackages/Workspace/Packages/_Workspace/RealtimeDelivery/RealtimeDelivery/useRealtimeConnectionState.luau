local Parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(Parent.React)
local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)

local function useRealtimeConnectionState() -- line: 7
	-- upvalues: useRobloxEventReceiver (copy), React (copy)
	local v5 = useRobloxEventReceiver()
	local v6, v7 = React.useState(Enum.ConnectionState.Connected)

	React.useEffect(function() -- line: 11
		-- upvalues: v5 (copy), v7 (copy)
		local v8 = v5:observeEvent("signalR", function(p1) -- line: 12
			-- upvalues: v7 (copy)
			v7(p1)
		end)

		return function() -- line: 16
			-- upvalues: v8 (copy)
			v8:disconnect()
		end
	end, { v5 })

	return v6
end

return useRealtimeConnectionState
