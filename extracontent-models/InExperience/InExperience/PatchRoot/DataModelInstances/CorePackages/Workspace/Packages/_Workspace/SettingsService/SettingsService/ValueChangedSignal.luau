local parent = script.Parent
local parent2 = parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local Signal = AppCommonLib.Signal
require(parent.Types)

local ValueChangedSignal = {}
ValueChangedSignal.__index = ValueChangedSignal

function ValueChangedSignal.new(p)
	return (setmetatable({ ["_value"] = p, _changeSignal = Signal.new() }, ValueChangedSignal))
end

function ValueChangedSignal:get()
	return self._value
end

function ValueChangedSignal:set(p)
	if self._value ~= p then
		self._value = p
		self._changeSignal:fire(p)
	end
end

function ValueChangedSignal:signal()
	return self._changeSignal
end

function ValueChangedSignal:connect(callback, p)
	local connection = self._changeSignal:connect(callback)

	if p == true then
		callback(self._value)
	end

	return connection
end

return ValueChangedSignal
