local Immutable = require(script.Parent.Immutable)

local Signal = {}

Signal.__index = Signal

function Signal.new()
	local v = { _listeners = {} }

	setmetatable(v, Signal)

	return v
end

function Signal:connect(callback)
	local v = { callback = callback, isConnected = true }

	self._listeners = Immutable.Append(self._listeners, v)

	local function disconnect() -- 1 equivalent call inferred from this helper
		v.isConnected = false
		self._listeners = Immutable.RemoveValueFromList(self._listeners, v)
	end

	return {
		Disconnect = function()
			warn(string.format(
				"Connection:Disconnect() has been deprecated, use Connection:disconnect()\n%s]",
				debug.traceback()
			))
			disconnect() -- inferred equivalent call
		end,
		disconnect = disconnect
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if listener.isConnected then
			listener.callback(...)
		end
	end
end

function Signal:Connect(...)
	warn(string.format("Signal:Connect() has been deprecated, use Signal:connect()\n%s]", debug.traceback()))
	return self:connect(...)
end

function Signal:Fire(...)
	warn(string.format("Signal:Fire() has been deprecated, use Signal:fire()\n%s]", debug.traceback()))
	self:fire(...)
end

return Signal
