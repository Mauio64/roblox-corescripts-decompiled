local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

require(CorePackages.Workspace.Packages.Chrome)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local availabilitySignalState = { Unavailable = 0, Loading = 1, Available = 2, Pinned = 3 }

local class = {}
class.__index = class

function class.new(p: number)
	local v = {
		_state = p or availabilitySignalState.Unavailable,
		_forceUnavailable = not FFlagEnableConsoleExpControls and nil,
		_changeSignal = Signal.new()
	}

	return (setmetatable(v, class))
end

function class:connect(p)
	return self._changeSignal:connect(p)
end

function class:set(state: number)
	if self._state ~= state then
		self._state = state

		if not (FFlagEnableConsoleExpControls and self._forceUnavailable) then
			self._changeSignal:fire(state)
		end
	end
end

function class:get()
	if FFlagEnableConsoleExpControls and self._forceUnavailable then
		return availabilitySignalState.Unavailable
	end

	return self._state
end

function class:available()
	self:set(availabilitySignalState.Available)
end

function class:loading()
	self:set(availabilitySignalState.Loading)
end

function class:unavailable()
	self:set(availabilitySignalState.Unavailable)
end

function class:pinned()
	self:set(availabilitySignalState.Pinned)
end

function class:forceUnavailable()
	if FFlagEnableConsoleExpControls and not self._forceUnavailable then
		self._forceUnavailable = true

		if self._state ~= availabilitySignalState.Unavailable then
			self._changeSignal:fire(availabilitySignalState.Unavailable)
		end
	end
end

function class:unforceUnavailable()
	if FFlagEnableConsoleExpControls and self._forceUnavailable then
		self._forceUnavailable = false

		if self._state ~= availabilitySignalState.Unavailable then
			self._changeSignal:fire(self._state)
		end
	end
end

local class2 = {}
class2.__index = class2

function class2.new(flag: boolean?)
	return (setmetatable({
		_value = { type = "empty", value = nil },
		_changeSignal = Signal.new(),
		_excludeFromTotalCounts = flag or false
	}, class2))
end

function class2:setExcludeFromTotalCounts(excludeFromTotalCounts: boolean)
	self._excludeFromTotalCounts = excludeFromTotalCounts
end

function class2:excludeFromTotalCounts()
	return self._excludeFromTotalCounts
end

function class2:connect(callback)
	return self._changeSignal:connect(callback)
end

function class2:get()
	return self._value
end

function class2:clear()
	if self._value and self._value.type ~= "empty" then
		self._value = { type = "empty", value = nil }
		self._changeSignal:fire(self._value)
	end
end

function class2:fireCount(p: number)
	local v = { type = "count", value = p }

	if self._value ~= v then
		self._value = v
		self._changeSignal:fire(self._value)
	end
end

function class2:isEmpty()
	return self._value and self._value.type == "empty"
end

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({ ["_value"] = p, _changeSignal = Signal.new() }, class3))
end

function class3:get()
	return self._value
end

function class3:setMomentary(p, duration: number, p2)
	if self._value ~= p then
		self._value = p
		self._changeSignal:fire(p)
	end

	local momentaryClearThread = self._momentaryClearThread

	if momentaryClearThread then
		task.cancel(momentaryClearThread)
	end

	self._momentaryClearThread = task.delay(duration, function()
		self._momentaryClearThread = nil
		self.set(self, p2)
	end)
end

function class3:set(p)
	local momentaryClearThread = self._momentaryClearThread

	if momentaryClearThread then
		task.cancel(momentaryClearThread)
		self._momentaryClearThread = nil
	end

	if self._value ~= p then
		self._value = p
		self._changeSignal:fire(p)
	end
end

function class3:signal()
	return self._changeSignal
end

function class3:connect(callback, p)
	local connection = self._changeSignal:connect(callback)

	if p == true then
		callback(self._value)
	end

	return connection
end

local class4 = {}
class4.__index = class4
function class4.new(signal, fetchMapFunction, eventReceiver)
	if not signal then
		error("No signal provided to MappedSignal")
	end

	if not fetchMapFunction then
		error("No fetchMapFunction provided to MappedSignal")
	end

	return (setmetatable(
		{
			["_signal"] = signal,
			_fetchMapFunction = fetchMapFunction,
			_eventReceiver = eventReceiver
		},
		class4
	))
end

function class4:connect(callback)
	if not self._signal then
		warn("MappedSignal: Missing signal")
		return function() end
	end

	local connection = self._signal:connect(function()
		if self._eventReceiver then
			self._eventReceiver()
		end

		callback(self._fetchMapFunction())
	end)

	if self._eventReceiver then
		self._eventReceiver()
	end

	callback(self._fetchMapFunction())

	return connection
end

function class4:get()
	return self._fetchMapFunction()
end

function setCoreGuiAvailability(p, p2, callback)
	local function updateAvailable() -- 1 equivalent call inferred from this helper
		local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(p2)

		if callback then
			callback(coreGuiEnabled)
		elseif coreGuiEnabled then
			p.availability:available()
		else
			p.availability:unavailable()
		end
	end

	local coreGuiChangedSignalConnection = StarterGui.CoreGuiChangedSignal:Connect(updateAvailable)
	updateAvailable() -- inferred equivalent call
	return coreGuiChangedSignalConnection
end

return {
	MappedSignal = class4,
	AvailabilitySignal = class,
	AvailabilitySignalState = availabilitySignalState,
	NotifySignal = class2,
	ObservableValue = class3,
	setCoreGuiAvailability = setCoreGuiAvailability
}
