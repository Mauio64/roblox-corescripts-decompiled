local RunService = game:GetService("RunService")
local Signal = require(script.Parent.Signal)
local NoYield = require(script.Parent.NoYield)
local t1 = {
	reportReducerError = function(_, _, p3) -- line: 9
		error(string.format("Received error: %s\n\n%s", p3.message, p3.thrownValue))
	end,
	reportUpdateError = function(_, _, _, p7) -- line: 12
		error(string.format("Received error: %s\n\n%s", p7.message, p7.thrownValue))
	end
}

local function tracebackReporter(p8) -- line: 17
	return debug.traceback((tostring(p8)))
end

local t2 = {
	_flushEvent = RunService.Heartbeat
}

t2.__index = t2

function t2.new(p9, p10, p11, p12, p13) -- line: 41
	-- upvalues: t1 (copy), Signal (copy), tracebackReporter (copy), t2 (copy)
	assert(typeof(p9) == "function", "Bad argument #1 to Store.new, expected function.")
	assert(p11 == nil or typeof(p11) == "table", "Bad argument #3 to Store.new, expected nil or table.")
	assert(p13 == nil or typeof(p13) == "table" and p13.__className == "Devtools", "Bad argument #5 to Store.new, expected nil or Devtools object.")

	if p11 ~= nil then
		for i = 1, #p11 do
			assert(typeof(p11[i]) == "function", ("Expected the middleware ('%s') at index %d to be a function."):format(tostring(p11[i]), i))
		end
	end

	local t3 = {
		_source = string.match(debug.traceback(), "^.-\n(.-)\n"),
		_errorReporter = p12 or t1,
		_isDispatching = false,
		_lastState = nil
	}

	t3.changed = Signal.new(t3)
	t3._reducer = p9

	function t3._flushHandler(p14) -- line: 66
		-- upvalues: t3 (copy)
		t3.changed:fire(p14, t3._lastState)
	end

	if p13 then
		t3._devtools = p13
		p13:_hookIntoStore(t3)
	end

	local t4 = {
		type = "@@INIT"
	}

	t3._actionLog = { t4 }

	local ok, result = xpcall(function() -- line: 82
		-- upvalues: t3 (copy), p10 (copy), t4 (copy)
		t3._state = t3._reducer(p10, t4)
	end, tracebackReporter)

	if not ok then
		t3._errorReporter.reportReducerError(p10, t4, {
			message = "Caught error in reducer with init",
			thrownValue = result
		})
		t3._state = p10
	end

	t3._lastState = t3._state
	t3._mutatedSinceFlush = false
	t3._connections = {}
	setmetatable(t3, t2)

	local connection = t3._flushEvent:Connect(function() -- line: 99
		-- upvalues: t3 (copy)
		t3:flush()
	end)

	table.insert(t3._connections, connection)

	if p11 then
		local dispatch = t3.dispatch

		local function u27(...) -- line: 106
			-- upvalues: dispatch (copy), t3 (copy)
			return dispatch(t3, ...)
		end

		for i = #p11, 1, -1 do
			u27 = p11[i](u27, t3)
		end

		function t3.dispatch(_, ...) -- line: 115
			-- upvalues: u27 (ref)
			return u27(...)
		end
	end

	return t3
end
function t2.getState(p16) -- line: 126
	if p16._isDispatching then
		error(("You may not call store:getState() while the reducer is executing. The reducer (%s) has already received the state as an argument. Pass it down from the top reducer instead of reading it from the store."):format((tostring(p16._reducer))))
	end

	return p16._state
end
function t2.dispatch(p17, p18) -- line: 143
	if typeof(p18) ~= "table" then
		error(("Actions must be tables. Use custom middleware for %q actions."):format((typeof(p18))), 2)
	end

	if p18.type == nil then
		error("Actions may not have an undefined 'type' property. " .. "Have you misspelled a constant? \n" .. tostring(p18), 2)
	end

	if p17._isDispatching then
		error("Reducers may not dispatch actions.")
	end

	local ok, result = pcall(function() -- line: 161
		-- upvalues: p17 (copy), p18 (copy)
		p17._isDispatching = true
		p17._state = p17._reducer(p17._state, p18)
		p17._mutatedSinceFlush = true
	end)

	p17._isDispatching = false

	if not ok then
		p17._errorReporter.reportReducerError(p17._state, p18, {
			message = "Caught error in reducer",
			thrownValue = result
		})
	end

	if #p17._actionLog == 3 then
		table.remove(p17._actionLog, 1)
	end

	table.insert(p17._actionLog, p18)
end
function t2.destruct(p19) -- line: 189
	for _, v in ipairs(p19._connections) do
		v:Disconnect()
	end

	p19._connections = nil
end
function t2.flush(p20) -- line: 200
	-- upvalues: NoYield (copy), tracebackReporter (copy)
	if not p20._mutatedSinceFlush then
		return
	end

	p20._mutatedSinceFlush = false

	local _state = p20._state
	local ok, result = xpcall(function() -- line: 212
		-- upvalues: NoYield (copy), p20 (copy), _state (copy)
		NoYield(p20._flushHandler, _state)
	end, tracebackReporter)

	if not ok then
		p20._errorReporter.reportUpdateError(p20._lastState, _state, p20._actionLog, {
			message = "Caught error flushing store updates",
			thrownValue = result
		})
	end

	p20._lastState = _state
end

return t2
