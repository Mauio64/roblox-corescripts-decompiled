local function makeEvents(items)
	local events = {}
	local result = {}
	local result2 = {}

	for k, item in items do
		local bindableEvent = Instance.new("BindableEvent")
		events[item] = bindableEvent.Event
		result[item] = function(...)
			bindableEvent:Fire(...)
		end
		result2[item] = function()
			bindableEvent:Destroy()
		end
	end

	return events, result, result2
end

return makeEvents
