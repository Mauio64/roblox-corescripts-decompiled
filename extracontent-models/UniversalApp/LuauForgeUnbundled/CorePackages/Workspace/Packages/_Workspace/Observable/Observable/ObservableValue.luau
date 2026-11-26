local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Observable/AppCommonLib").Signal

local class = {}
class.__index = class

local function defaultCompareFn(p2, p3): boolean
	return p2 == p3
end

function class.new(p2, p3)
	return (setmetatable({
		["_isEqual"] = p3 or defaultCompareFn,
		_value = p2,
		_changeSignal = signal.new()
	}, class))
end

function class:get()
	return self._value
end

function class:set(p2)
	if not self._isEqual(self._value, p2) then
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

function class:__tostring()
	return "ObservableValue(" .. tostring(self._value) .. ")"
end

return class
