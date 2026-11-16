local parent = script.Parent.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local ObservableValue = {}
ObservableValue.__index = ObservableValue

local function defaultCompareFn(p, p2): boolean
	return p == p2
end

function ObservableValue.new(p, callback)
	return (setmetatable({
		["_isEqual"] = callback or defaultCompareFn,
		_value = p,
		_changeSignal = Signal.new()
	}, ObservableValue))
end

function ObservableValue:get()
	return self._value
end

function ObservableValue:set(p)
	if not self._isEqual(self._value, p) then
		self._value = p
		self._changeSignal:fire(p)
	end
end

function ObservableValue:connect(callback, p)
	local connection = self._changeSignal:connect(callback)

	if p == true then
		callback(self._value)
	end

	return connection
end

function ObservableValue:__tostring()
	return "ObservableValue(" .. tostring(self._value) .. ")"
end

return ObservableValue
