local list = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/Cryo").List
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")
require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/RealtimeTypes")

local useRobloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/useRobloxEventReceiver")
local useRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/useRealtimeNamespace")

local function useRealtimeConnectionStateChanged(p2, callback, p3)
	local v5 = useRobloxEventReceiver()
	local ref = React.useRef(nil)

	useRealtimeNamespace(p2, function(p4)
		local sequenceNumber = p4.SequenceNumber

		if sequenceNumber and (ref.current == nil or ref.current < sequenceNumber) then
			ref.current = sequenceNumber
		end
	end, list.join({ p2 }, p3))

	React.useEffect(function()
		local v6 = v5:observeEvent("signalR", function(p4, p5, p6)
			local v7 = p6[p2]
			local v8 = not (v7 == nil) and (ref.current == nil or ref.current ~= v7)

			if v7 then
				ref.current = v7
			end

			callback(p4, v8)
		end)

		return function()
			v6:disconnect()
		end
	end, list.join({ v5, ref.current }, p3))
end

return useRealtimeConnectionStateChanged
