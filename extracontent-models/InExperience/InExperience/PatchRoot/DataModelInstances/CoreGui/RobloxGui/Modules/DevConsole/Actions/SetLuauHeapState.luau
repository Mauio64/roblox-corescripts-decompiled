local Action = require(script.Parent.Parent.Action)

require(script.Parent.Parent.Components.LuauHeap.LuauHeapTypes)

return Action(script.Name, function(b1: boolean, p1) -- line: 8
	return {
		isClientState = b1,
		sessionState = p1
	}
end)
