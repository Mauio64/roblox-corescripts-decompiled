local function waitForFirst(...) -- line: 1
	local BindableEvent = Instance.new("BindableEvent")
	local t1 = { ... }

	local function fire(...) -- line: 5
		-- upvalues: t1 (copy), BindableEvent (copy)
		for i = 1, #t1 do
			t1[i]:Disconnect()
		end

		return BindableEvent:Fire(...)
	end

	for i = 1, #t1 do
		t1[i] = t1[i]:Connect(fire)
	end

	return BindableEvent.Event:Wait()
end

return waitForFirst
