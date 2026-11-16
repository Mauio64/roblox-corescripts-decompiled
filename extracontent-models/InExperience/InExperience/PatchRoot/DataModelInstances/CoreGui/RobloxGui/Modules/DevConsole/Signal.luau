local Immutable = require(script.Parent.Immutable)

local Signal = {}

Signal.__index = Signal

function Signal.new()
	local v = { _listeners = {} }

	setmetatable(v, Signal)

	return v
end

function Signal:Connect(callback)
	local v = { callback = callback, isConnected = true }

	self._listeners = Immutable.Append(self._listeners, v)

	local function disconnect()
		v.isConnected = false
		self._listeners = Immutable.RemoveValueFromList(self._listeners, v)
	end

	return { Disconnect = disconnect }
end

function Signal:Fire(...)
	for _, listener in ipairs(self._listeners) do
		if listener.isConnected then
			listener.callback(...)
		end
	end
end

return Signal
