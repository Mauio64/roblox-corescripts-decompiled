local DispatchBindableEvent = require(script.Parent.DispatchBindableEvent)

local function createDispatchBindableEvent(p1) -- line: 3
	-- upvalues: DispatchBindableEvent (copy)
	DispatchBindableEvent.Event:Connect(function(p2) -- line: 4
		-- upvalues: p1 (copy)
		p1:dispatch(p2)
	end)
	DispatchBindableEvent:SetAttribute("isConnected", true)

	return DispatchBindableEvent
end

return createDispatchBindableEvent
