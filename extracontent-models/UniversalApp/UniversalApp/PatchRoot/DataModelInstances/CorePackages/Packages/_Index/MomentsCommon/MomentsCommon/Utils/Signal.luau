local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local Immutable = require(MomentsCommon.Utils.Immutable)

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

	return {
		disconnect = function()
			v.isConnected = false
			self._listeners = Immutable.RemoveValueFromList(self._listeners, v)
		end
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if listener.isConnected then
			listener.callback(...)
		end
	end
end

return Signal
