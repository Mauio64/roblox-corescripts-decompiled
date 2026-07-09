local Parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(Parent.React)
local RealtimeContext = require(script.Parent.RealtimeContext)

local function useRobloxEventReceiver() -- line: 7
	-- upvalues: React (copy), RealtimeContext (copy)
	return React.useContext(RealtimeContext)
end

return useRobloxEventReceiver
