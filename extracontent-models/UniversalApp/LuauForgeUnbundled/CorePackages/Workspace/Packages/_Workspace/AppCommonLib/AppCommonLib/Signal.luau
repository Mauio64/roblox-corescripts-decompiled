local Immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Immutable")

local class = {}

class.__index = class

function class.new()
	local v5 = { _listeners = {} }

	setmetatable(v5, class)

	return v5
end

function class:connect(p3)
	local v5 = { callback = p3, isConnected = true }

	self._listeners = Immutable.Append(self._listeners, v5)

	return {
		Disconnect = function()
			warn(string.format(
				"Connection:Disconnect() has been deprecated, use Connection:disconnect()\n%s]",
				debug.traceback()
			))
			v5.isConnected = false
			self._listeners = Immutable.RemoveValueFromList(self._listeners, v5)
		end,
		disconnect = function()
			v5.isConnected = false
			self._listeners = Immutable.RemoveValueFromList(self._listeners, v5)
		end
	}
end

function class:fire(...)
	for i, listener in ipairs(self._listeners) do
		if listener.isConnected then
			listener.callback(...)
		end
	end
end

function class:Connect(...)
	warn(string.format("Signal:Connect() has been deprecated, use Signal:connect()\n%s]", debug.traceback()))
	return self:connect(...)
end

function class:Fire(...)
	warn(string.format("Signal:Fire() has been deprecated, use Signal:fire()\n%s]", debug.traceback()))
	self:fire(...)
end

return class
