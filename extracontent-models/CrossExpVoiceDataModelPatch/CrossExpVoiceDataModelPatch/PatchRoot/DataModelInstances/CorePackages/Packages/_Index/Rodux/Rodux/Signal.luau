local __DEV__ = _G.__DEV__

local _, result = xpcall(function()
	return game:DefineFastFlag("RoduxRemoveConnectTraceback", false)
end, function(): boolean
	return true
end)

local function immutableAppend(listeners, ...)
	local count = #listeners
	local result2 = {}

	for i = 1, count do
		result2[i] = listeners[i]
	end

	for i = 1, select("#", ...) do
		result2[count + i] = select(i, ...)
	end

	return result2
end

local function immutableRemoveValue(listeners, p)
	local result2 = {}

	for i = 1, #listeners do
		if listeners[i] ~= p then
			table.insert(result2, listeners[i])
		end
	end

	return result2
end

local Signal = {}

Signal.__index = Signal

function Signal.new(store)
	local v = { _listeners = {}, _store = store }

	setmetatable(v, Signal)

	return v
end

function Signal:connect(callback)
	if typeof(callback) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if self._store and self._store._isDispatching then
		error("You may not call store.changed:connect() while the reducer is executing. If you would like to be notified after the store has been updated, subscribe from a component and invoke store:getState() in the callback to access the latest state. ")
	end

	local v = {
		callback = callback,
		disconnected = false,
		connectTraceback = nil,
		disconnectTraceback = nil
	}

	if not result or __DEV__ then
		v.connectTraceback = debug.traceback()
	end

	self._listeners = immutableAppend(self._listeners, v)

	return {
		disconnect = function()
			if v.disconnected then
				error(("Listener connected at: \n%s\nwas already disconnected at: \n%s\n"):format(
					tostring(v.connectTraceback),
					(tostring(v.disconnectTraceback))
				))
			end

			if self._store and self._store._isDispatching then
				error("You may not unsubscribe from a store listener while the reducer is executing.")
			end

			if not result or __DEV__ then
				v.disconnectTraceback = debug.traceback()
			end

			v.disconnected = true
			self._listeners = immutableRemoveValue(self._listeners, v)
		end
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if not listener.disconnected then
			listener.callback(...)
		end
	end
end

return Signal
