local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local parent = RealtimeDelivery.Parent
local Cryo = require(parent.Cryo)
local List = Cryo.List
local React = require(parent.React)
require(RealtimeDelivery.RealtimeTypes)

local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)
local useRealtimeNamespace = require(script.Parent.useRealtimeNamespace)

local function useRealtimeConnectionStateChanged(p: string, callback, p2)
	local v = useRobloxEventReceiver()
	local ref = React.useRef(nil)

	useRealtimeNamespace(p, function(p3)
		local sequenceNumber = p3.SequenceNumber

		if sequenceNumber and (ref.current == nil or ref.current < sequenceNumber) then
			ref.current = sequenceNumber
		end
	end, List.join({ p }, p2))

	React.useEffect(function()
		local v2 = v:observeEvent("signalR", function(p3, _, p4)
			local current = p4[p]
			local v2

			if current == nil then
				v2 = false
			else
				v2 = ref.current == nil or ref.current ~= current
			end

			if current then
				ref.current = current
			end

			callback(p3, v2)
		end)

		return function()
			v2:disconnect()
		end
	end, List.join({ v, ref.current }, p2))
end

return useRealtimeConnectionStateChanged
