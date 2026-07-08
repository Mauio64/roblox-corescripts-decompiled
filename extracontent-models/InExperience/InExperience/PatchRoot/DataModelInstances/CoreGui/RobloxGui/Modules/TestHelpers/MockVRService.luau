local t1 = {}

t1.__index = t1

function t1.GetPropertyChangedSignal(p1, p2) -- line: 4
	if p2 == "VRDeviceAvailable" then
		return p1._vrDeviceAvailableChanged.Event
	end

	error(("%s is not a valid property name"):format((tostring(p2))))
end
function t1.toggleHeadsetConnectionState(p3) -- line: 11
	local v5 = not p3.VRDeviceAvailable

	p3.VRDeviceAvailable = v5
	p3._vrDeviceAvailableChanged:Fire(v5)
end
function t1.new() -- line: 18
	-- upvalues: t1 (copy)
	local t2 = {
		VRDeviceAvailable = true,
		_vrDeviceAvailableChanged = Instance.new("BindableEvent")
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end

return t1
