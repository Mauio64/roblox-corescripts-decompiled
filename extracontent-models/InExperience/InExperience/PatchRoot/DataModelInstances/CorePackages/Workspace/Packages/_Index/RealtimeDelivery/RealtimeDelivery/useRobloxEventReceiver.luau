local parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(parent.React)

local RealtimeContext = require(script.Parent.RealtimeContext)

local function useRobloxEventReceiver()
	return React.useContext(RealtimeContext)
end

return useRobloxEventReceiver
