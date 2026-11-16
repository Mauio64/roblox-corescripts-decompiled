local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local parent = RealtimeDelivery.Parent
local Cryo = require(parent.Cryo)
local List = Cryo.List
local React = require(parent.React)
require(RealtimeDelivery.RealtimeTypes)

local useRobloxEventReceiver = require(script.Parent.useRobloxEventReceiver)

local function useRealtimeNamespace(p: string, callback, p2)
	local v = useRobloxEventReceiver()

	React.useEffect(function()
		local v2 = v:observeEvent(p, callback)

		return function()
			v2:disconnect()
		end
	end, List.join({ p, v }, p2))
end

return useRealtimeNamespace
