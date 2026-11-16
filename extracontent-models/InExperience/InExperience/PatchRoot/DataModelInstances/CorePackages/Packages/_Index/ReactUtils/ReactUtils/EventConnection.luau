local parent = script:FindFirstAncestor("ReactUtils").Parent
require(parent.GoodSignal)

local useEventConnection = require(script.Parent.useEventConnection)

local function EventConnection(p)
	useEventConnection(p.event, p.callback, { p.event, p.callback })
end

return EventConnection
