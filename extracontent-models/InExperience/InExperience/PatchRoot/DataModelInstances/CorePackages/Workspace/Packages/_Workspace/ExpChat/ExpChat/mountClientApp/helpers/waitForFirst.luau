local function waitForFirst(...)
	local bindableEvent = Instance.new("BindableEvent")
	local connections = { ... }

	local function fire(...)
		for i = 1, #connections do
			connections[i]:Disconnect()
		end

		return bindableEvent:Fire(...)
	end

	for i = 1, #connections do
		connections[i] = connections[i]:Connect(fire)
	end

	return bindableEvent.Event:Wait()
end

return waitForFirst
