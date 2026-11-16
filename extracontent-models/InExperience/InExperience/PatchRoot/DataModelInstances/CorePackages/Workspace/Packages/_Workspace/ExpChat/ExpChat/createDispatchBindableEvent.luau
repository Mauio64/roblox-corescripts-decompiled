local DispatchBindableEvent = require(script.Parent.DispatchBindableEvent)

local function createDispatchBindableEvent(object)
	DispatchBindableEvent.Event:Connect(function(p)
		object:dispatch(p)
	end)

	DispatchBindableEvent:SetAttribute("isConnected", true)
	return DispatchBindableEvent
end

return createDispatchBindableEvent
