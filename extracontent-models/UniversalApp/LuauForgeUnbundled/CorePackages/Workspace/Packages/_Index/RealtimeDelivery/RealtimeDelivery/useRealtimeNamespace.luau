local list = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/Cryo").List
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")
require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/RealtimeTypes")

local useRobloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/useRobloxEventReceiver")

local function useRealtimeNamespace(p2, p3, p4)
	local v5 = useRobloxEventReceiver()

	React.useEffect(function()
		local v6 = v5:observeEvent(p2, p3)

		return function()
			v6:disconnect()
		end
	end, list.join({ p2, v5 }, p4))
end

return useRealtimeNamespace
