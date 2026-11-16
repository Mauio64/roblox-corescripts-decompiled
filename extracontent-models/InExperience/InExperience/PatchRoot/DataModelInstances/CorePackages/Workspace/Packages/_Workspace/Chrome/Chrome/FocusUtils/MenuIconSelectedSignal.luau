local parent = script.Parent.Parent.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local class = {}
class.__index = class

function class.new()
	return (setmetatable({ _value = false, _changeSignal = Signal.new() }, class))
end

function class:get()
	return self._value
end

function class:set(flag: boolean)
	if self._value ~= flag then
		self._value = flag
		self._changeSignal:fire(flag)
	end
end

function class:connect(callback, p)
	local connection = self._changeSignal:connect(callback)

	if p == true then
		callback(self._value)
	end

	return connection
end

return class.new()
