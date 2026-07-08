local useEventConnection = require(script.Parent.useEventConnection)

local function EventConnection(t1: {[any]: any}) -- line: 20
	-- upvalues: useEventConnection (copy)
	useEventConnection(t1.event, t1.callback, {
		t1.event,
		t1.callback
	})
end

return EventConnection
