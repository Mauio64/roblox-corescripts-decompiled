local Action = require(script.Parent.Parent.Action)

require(script.Parent.Parent.Components.LuauHeap.LuauHeapTypes)

return Action(script.Name, function(isClientState: boolean, sessionState)
	return { isClientState = isClientState, sessionState = sessionState }
end)
