local v = nil

local function acquireRunnerThreadAndCallEventHandler(callback, ...)
	local v2 = v
	v = nil
	callback(...)

	v = v2
end

local function runEventHandlerInFreeThread()
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local class = {}
class.__index = class

function class.new(signal, fn)
	return (setmetatable({ _connected = true, _signal = signal, _fn = fn, _next = false }, class))
end

function class:Disconnect()
	self._connected = false

	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next
		return
	end

	local v2 = self._signal._handlerListHead

	while v2 and v2._next ~= self do
		v2 = v2._next
	end

	if v2 then
		v2._next = self._next
	end
end

setmetatable(class, {
	__index = function(_, p)
		error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p))), 2)
	end,
	__newindex = function(_, p)
		error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p))), 2)
	end
})

local GoodSignal = {}
GoodSignal.__index = GoodSignal

function GoodSignal.new()
	return (setmetatable({ _handlerListHead = false }, GoodSignal))
end

function GoodSignal:Connect(p)
	local handlerListHead = class.new(self, p)

	if not self._handlerListHead then
		self._handlerListHead = handlerListHead

		return handlerListHead
	end

	handlerListHead._next = self._handlerListHead
	self._handlerListHead = handlerListHead
	return handlerListHead
end

function GoodSignal:DisconnectAll()
	self._handlerListHead = false
end

function GoodSignal:Fire(...)
	local v2 = self._handlerListHead

	while v2 do
		if v2._connected then
			if not v then
				v = coroutine.create(runEventHandlerInFreeThread)

				coroutine.resume(v)
			end

			task.spawn(v, v2._fn, ...)
		end

		v2 = v2._next
	end
end

function GoodSignal:Wait()
	local thread = coroutine.running()
	local connection = nil
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(thread, ...)
	end)
	return coroutine.yield()
end

function GoodSignal:Once(callback)
	local connection = nil
	connection = self:Connect(function(...)
		if connection._connected then
			connection:Disconnect()
		end

		callback(...)
	end)
	return connection
end

setmetatable(GoodSignal, {
	__index = function(_, p)
		error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p))), 2)
	end,
	__newindex = function(_, p)
		error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p))), 2)
	end
})

return GoodSignal
