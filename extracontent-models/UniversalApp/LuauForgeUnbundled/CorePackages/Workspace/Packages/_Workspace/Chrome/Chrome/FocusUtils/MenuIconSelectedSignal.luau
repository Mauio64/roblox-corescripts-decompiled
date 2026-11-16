local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/AppCommonLib").Signal

local class = {}
class.__index = class

function class.new()
	return (setmetatable({ _value = false, _changeSignal = signal.new() }, class))
end

function class:get()
	return self._value
end

function class:set(p2)
	if self._value ~= p2 then
		self._value = p2
		self._changeSignal:fire(p2)
	end
end

function class:connect(callback, p3)
	local connection = self._changeSignal:connect(callback)

	if p3 == true then
		callback(self._value)
	end

	return connection
end

return class.new()
