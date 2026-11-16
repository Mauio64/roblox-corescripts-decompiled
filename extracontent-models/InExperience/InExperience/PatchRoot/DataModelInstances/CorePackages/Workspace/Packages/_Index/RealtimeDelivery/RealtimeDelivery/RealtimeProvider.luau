local parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(parent.React)

local RealtimeContext = require(script.Parent.RealtimeContext)

local function RealtimeProvider(p)
	return React.createElement(RealtimeContext.Provider, { value = p.realtime }, p.children)
end

return RealtimeProvider
