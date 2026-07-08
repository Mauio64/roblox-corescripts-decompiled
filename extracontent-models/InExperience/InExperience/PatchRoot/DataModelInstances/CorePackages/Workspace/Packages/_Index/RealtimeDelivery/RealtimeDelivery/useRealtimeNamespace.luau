local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local RealtimeDeliveryParent = RealtimeDelivery.Parent
local List = require(RealtimeDeliveryParent.Cryo).List
local React = require(RealtimeDeliveryParent.React)

require(RealtimeDelivery.RealtimeTypes)

local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)

local function useRealtimeNamespace(s1: string, p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 11
	-- upvalues: useRobloxEventReceiver (copy), React (copy), List (copy)
	local v10 = useRobloxEventReceiver()

	React.useEffect(function() -- line: 14
		-- upvalues: v10 (copy), s1 (copy), p1 (copy)
		local v11 = v10:observeEvent(s1, p1)

		return function() -- line: 17
			-- upvalues: v11 (copy)
			v11:disconnect()
		end
	end, List.join({
		s1,
		v10
	}, t1))
end

return useRealtimeNamespace
