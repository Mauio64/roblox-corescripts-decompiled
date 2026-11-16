local MockUserGameSettings = {}
MockUserGameSettings.__index = MockUserGameSettings

function MockUserGameSettings.new()
	local bindableEvent = Instance.new("BindableEvent")

	local v = {
		FullscreenChanged = {
			Connect = function(self, onEvent)
				return bindableEvent.Event:Connect(onEvent)
			end,
			GoFullscreen = function()
				bindableEvent:Fire(true)
			end
		}
	}

	setmetatable(v, { __index = MockUserGameSettings })

	return v
end

function MockUserGameSettings.InFullScreen(_): boolean
	return false
end

return MockUserGameSettings
