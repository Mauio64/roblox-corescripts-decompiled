local MockVRService = {}
MockVRService.__index = MockVRService

function MockVRService:GetPropertyChangedSignal(p)
	if p == "VRDeviceAvailable" then
		return self._vrDeviceAvailableChanged.Event
	end

	error(("%s is not a valid property name"):format((tostring(p))))
end

function MockVRService:toggleHeadsetConnectionState()
	local vrDeviceAvailable = not self.VRDeviceAvailable
	self.VRDeviceAvailable = vrDeviceAvailable

	self._vrDeviceAvailableChanged:Fire(vrDeviceAvailable)
end

function MockVRService.new()
	local v = {
		VRDeviceAvailable = true,
		_vrDeviceAvailableChanged = Instance.new("BindableEvent")
	}

	setmetatable(v, { __index = MockVRService })

	return v
end

return MockVRService
