local t1 = {
	events = {}
}

t1.__index = t1

function t1.GetPropertyChangedSignal(p1, p2) -- line: 6
	local BindableEvent = Instance.new("BindableEvent")

	p1.events[p2] = p1.events[p2] or {}
	table.insert(p1.events[p2], BindableEvent)

	return BindableEvent.Event
end
function t1.callPropertyChanged(p3, p4) -- line: 13
	if not p3.events[p4] then
		return
	end

	for _, v8 in p3.events[p4] do
		v8:Fire()
	end
end
function t1.new(_) -- line: 22
	-- upvalues: t1 (copy)
	local t2 = {
		GamepadEnabled = false,
		KeyboardEnabled = false,
		MouseEnabled = false,
		TouchEnabled = false,
		PreferredInput = Enum.PreferredInput.KeyboardAndMouse,
		events = {}
	}

	setmetatable(t2, t1)

	return t2
end

return t1
