local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local RealtimeDeliveryParent = RealtimeDelivery.Parent
local List = require(RealtimeDeliveryParent.Cryo).List
local React = require(RealtimeDeliveryParent.React)

require(RealtimeDelivery.RealtimeTypes)

local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)
local useRealtimeNamespace = require(script.Parent.useRealtimeNamespace)

local function useRealtimeConnectionStateChanged(s1: string, p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 12
	-- upvalues: useRobloxEventReceiver (copy), React (copy), useRealtimeNamespace (copy), List (copy)
	local v11 = useRobloxEventReceiver()
	local v12 = React.useRef(nil)

	useRealtimeNamespace(s1, function(p2) -- line: 20
		-- upvalues: v12 (copy)
		local SequenceNumber = p2.SequenceNumber

		if SequenceNumber and (v12.current == nil or SequenceNumber > v12.current) then
			v12.current = SequenceNumber
		end
	end, List.join({ s1 }, t1))
	React.useEffect(function() -- line: 29
		-- upvalues: v11 (copy), s1 (copy), v12 (copy), p1 (copy)
		local v15 = v11:observeEvent("signalR", function(p3, _, p5) -- line: 32
			-- upvalues: s1 (copy), v12 (copy), p1 (copy)
			local v19 = p5[s1]
			local v20 = v19 ~= nil and (v12.current == nil or v19 ~= v12.current)

			if v19 then
				v12.current = v19
			end

			p1(p3, v20)
		end)

		return function() -- line: 47
			-- upvalues: v15 (copy)
			v15:disconnect()
		end
	end, List.join({
		v11,
		v12.current
	}, t1))
end

return useRealtimeConnectionStateChanged
