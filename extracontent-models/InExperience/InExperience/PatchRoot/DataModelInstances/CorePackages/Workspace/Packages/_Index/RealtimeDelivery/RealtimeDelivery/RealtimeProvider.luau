local Parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(Parent.React)
local RealtimeContext = require(script.Parent.RealtimeContext)

local function RealtimeProvider(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), RealtimeContext (copy)
	return React.createElement(RealtimeContext.Provider, {
		value = t1.realtime
	}, t1.children)
end

return RealtimeProvider
