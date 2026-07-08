local __DEV__ = _G.__DEV__
local _, result = xpcall(function() -- line: 9
	return game:DefineFastFlag("RoduxRemoveConnectTraceback", false)
end, function() -- line: 11
	return true
end)

local function immutableAppend(p1, ...) -- line: 15
	local t1 = {}
	local v9 = #p1

	for i = 1, v9 do
		t1[i] = p1[i]
	end

	for i = 1, select("#", ...) do
		t1[v9 + i] = select(i, ...)
	end

	return t1
end
local function immutableRemoveValue(p2, p3) -- line: 30
	local t2 = {}

	for i = 1, #p2 do
		if p3 ~= p2[i] then
			table.insert(t2, p2[i])
		end
	end

	return t2
end

local t3 = {}

t3.__index = t3

function t3.new(p4) -- line: 46
	-- upvalues: t3 (copy)
	local t4 = {
		_listeners = {},
		_store = p4
	}

	setmetatable(t4, t3)

	return t4
end
function t3.connect(p5, p6) -- line: 57
	-- upvalues: result (copy), __DEV__ (copy), immutableAppend (copy), immutableRemoveValue (copy)
	if typeof(p6) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if p5._store and p5._store._isDispatching then
		error("You may not call store.changed:connect() while the reducer is executing. If you would like to be notified after the store has been updated, subscribe from a component and invoke store:getState() in the callback to access the latest state. ")
	end

	local t5 = {
		disconnected = false,
		connectTraceback = nil,
		disconnectTraceback = nil,
		callback = p6
	}

	if not result or __DEV__ then
		t5.connectTraceback = debug.traceback()
	end

	p5._listeners = immutableAppend(p5._listeners, t5)

	return {
		disconnect = function() -- line: 83
			-- upvalues: t5 (copy), p5 (copy), result (copy), __DEV__ (copy), immutableRemoveValue (copy)
			if t5.disconnected then
				error(("Listener connected at: \n%s\nwas already disconnected at: \n%s\n"):format(tostring(t5.connectTraceback), (tostring(t5.disconnectTraceback))))
			end

			if p5._store and p5._store._isDispatching then
				error("You may not unsubscribe from a store listener while the reducer is executing.")
			end

			if not result or __DEV__ then
				t5.disconnectTraceback = debug.traceback()
			end

			t5.disconnected = true
			p5._listeners = immutableRemoveValue(p5._listeners, t5)
		end
	}
end
function t3.fire(p7, ...) -- line: 109
	for _, v in ipairs(p7._listeners) do
		if not v.disconnected then
			v.callback(...)
		end
	end
end

return t3
