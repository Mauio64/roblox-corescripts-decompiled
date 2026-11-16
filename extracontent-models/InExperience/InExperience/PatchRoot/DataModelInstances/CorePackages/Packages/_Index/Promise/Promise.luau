local v = { __mode = "k" }

local success, result = pcall(game.DefineFastFlag, game, "ReducePromiseTaskDefer", false)

if not success then
	result = false
end

local function isCallable(value): boolean -- 17 equivalent calls inferred from this helper
	if type(value) == "function" then
		return true
	end

	if type(value) == "table" then
		local metatable = getmetatable(value)

		if metatable and type((rawget(metatable, "__call"))) == "function" then
			return true
		end
	end

	return false
end

local function makeEnum(p, list)
	local v2 = {}

	for _, item in ipairs(list) do
		v2[item] = item
	end

	return (setmetatable(v2, {
		__index = function(_, p2)
			error(string.format("%s is not in %s!", p2, p), 2)
		end,
		__newindex = function()
			error(string.format("Creating new members in %s is not allowed!", p), 2)
		end
	}))
end

local err = {
	Kind = makeEnum("Promise.Error.Kind", {
		"ExecutionError",
		"AlreadyCancelled",
		"NotResolvedInTime",
		"TimedOut"
	})
}

err.__index = err

function err.new(options, parent)
	local v2 = options or {}
	return (setmetatable({
		error = tostring(v2.error) or "[This error has no error text.]",
		trace = v2.trace,
		context = v2.context,
		kind = v2.kind,
		parent = parent,
		createdTick = os.clock(),
		createdTrace = debug.traceback()
	}, err))
end

function err.is(p): boolean
	if type(p) ~= "table" then
		return false
	end

	local metatable = getmetatable(p)

	if type(metatable) == "table" then
		return rawget(p, "error") ~= nil and type((rawget(metatable, "extend"))) == "function"
	end

	return false
end

function err.isKind(p, p2)
	assert(p2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

	return err.is(p) and p.kind == p2
end

function err:extend(options)
	local v2 = options or {}

	v2.kind = v2.kind or self.kind

	return err.new(v2, self)
end

function err:getErrorChain()
	local parents = { self }

	while parents[#parents].parent do
		table.insert(parents, parents[#parents].parent)
	end

	return parents
end

function err:__tostring()
	local values = { string.format("-- Promise.Error(%s) --", self.kind or "?") }

	for _, v2 in ipairs(self:getErrorChain()) do
		table.insert(values, table.concat({ v2.trace or v2.error, v2.context }, "\n"))
	end

	return table.concat(values, "\n")
end

local function pack(...)
	return select("#", ...), { ... }
end

local function packResult(p, ...)
	return p, select("#", ...), { ... }
end

local function makeErrorHandler(p) -- 1 equivalent call inferred from this helper
	assert(p ~= nil, "traceback is nil")

	return function(err2)
		if type(err2) == "table" then
			return err2
		end

		return err.new({
			error = err2,
			kind = err.Kind.ExecutionError,
			trace = debug.traceback(tostring(err2), 2),
			context = "Promise created at:\n\n" .. p
		})
	end
end

local function runExecutor(p, callback, ...)
	return packResult(xpcall(callback, makeErrorHandler(p), ...)) -- inferred equivalent call
end

local function createAdvancer(p, p2, callback, callback2) -- 3 equivalent calls inferred from this helper
	return function(...)
		local v2, v3, v4 = runExecutor(p, p2, ...)

		if v2 then
			callback(unpack(v4, 1, v3))
		else
			callback2(v4[1])
		end
	end
end

local function isEmpty(queuedReject): boolean -- 1 equivalent call inferred from this helper
	return next(queuedReject) == nil
end

local Promise = {
	Error = err,
	Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
	_getTime = os.clock,
	_timeEvent = 0,
	_unhandledRejectionCallbacks = 0
}
local RunService = game:GetService("RunService")
Promise._timeEvent = RunService.Heartbeat
Promise._unhandledRejectionCallbacks = {}

Promise.prototype = {}
Promise.__index = Promise.prototype

function Promise._new(source, p, parent)
	if parent ~= nil and not Promise.is(parent) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local v2 = {
		_thread = nil,
		_source = source,
		_status = Promise.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = true,
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},
		_cancellationHook = nil,
		_parent = parent,
		_consumers = setmetatable({}, v)
	}

	if parent and parent._status == Promise.Status.Started then
		parent._consumers[v2] = true
	end

	setmetatable(v2, Promise)

	local function resolve(...)
		v2:_resolve(...)
	end

	local function reject(...)
		v2:_reject(...)
	end

	local function onCancel(cancellationHook): boolean
		if cancellationHook then
			if v2._status == Promise.Status.Cancelled then
				cancellationHook()
			else
				v2._cancellationHook = cancellationHook
			end
		end

		return v2._status == Promise.Status.Cancelled
	end

	v2._thread = coroutine.create(function()
		local v3, _, v4 = runExecutor(v2._source, p, resolve, reject, onCancel)

		if not v3 then
			reject(v4[1])
		end
	end)

	task.spawn(v2._thread)

	return v2
end

function Promise.new(p)
	return Promise._new(debug.traceback(nil, 2), p)
end

function Promise:__tostring()
	return string.format("Promise(%s)", self._status)
end

function Promise.defer(p)
	local traceback = debug.traceback(nil, 2)

	return (Promise._new(traceback, function(p2, callback, p3)
		local connection = nil
		connection = Promise._timeEvent:Connect(function()
			connection:Disconnect()
			local v2, _, v3 = runExecutor(traceback, p, p2, callback, p3)

			if not v2 then
				callback(v3[1])
			end
		end)
	end))
end

Promise.async = Promise.defer

function Promise.resolve(...)
	local v2, v3 = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(callback)
		callback(unpack(v3, 1, v2))
	end)
end

function Promise.reject(...)
	local v2, v3 = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(_, callback)
		callback(unpack(v3, 1, v2))
	end)
end

function Promise._try(p, callback, ...)
	local v2, v3 = pack(...)

	return Promise._new(p, function(callback2)
		callback2(callback(unpack(v3, 1, v2)))
	end)
end

function Promise.try(p, ...)
	return Promise._try(debug.traceback(nil, 2), p, ...)
end

function Promise._all(p, list, p2)
	if type(list) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
	end

	for k, item in pairs(list) do
		if not Promise.is(item) then
			error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(k))), 3)
		end
	end

	if #list == 0 or p2 == 0 then
		return Promise.resolve({})
	end

	return Promise._new(p, function(callback, callback2, callback3)
		local v2 = {}
		local v3 = {}

		local count = 0
		local count2 = 0
		local flag = false

		local function cancel() -- 3 equivalent calls inferred from this helper
			for _, v4 in ipairs(v3) do
				v4:cancel()
			end
		end

		local function resolveOne(i, ...)
			if flag then
				return
			end

			count += 1

			if p2 == nil then
				v2[i] = ...
			else
				v2[count] = ...
			end

			if count >= (p2 or #list) then
				flag = true
				callback(v2)
				cancel() -- inferred equivalent call
			end
		end

		callback3(cancel)

		for i, item in ipairs(list) do
			v3[i] = item:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				count2 += 1

				if p2 == nil or #list - count2 < p2 then
					cancel() -- inferred equivalent call
					flag = true

					callback2(...)
				end
			end)
		end

		if flag then
			cancel() -- inferred equivalent call
		end
	end)
end

function Promise.all(...)
	local v2 = { ... }

	if type(v2[1]) == "table" and not Promise.is(v2[1]) then
		v2 = v2[1]
	end

	return Promise._all(debug.traceback(nil, 2), v2)
end

function Promise.fold(p, callback, p2)
	assert(type(p) == "table", "Bad argument #1 to Promise.fold: must be a table")
	assert(isCallable(callback), "Bad argument #2 to Promise.fold: must be a function") -- inferred equivalent call

	local resolved = Promise.resolve(p2)
	return Promise.each(p, function(p3, p4)
		resolved = resolved:andThen(function(p5)
			return callback(p5, p3, p4)
		end)
	end):andThen(function()
		return resolved
	end)
end

function Promise.some(p, value)
	assert(type(value) == "number", "Bad argument #2 to Promise.some: must be a number")

	return Promise._all(debug.traceback(nil, 2), p, value)
end

function Promise.any(p)
	return Promise._all(debug.traceback(nil, 2), p, 1):andThen(function(list)
		return list[1]
	end)
end

function Promise.allSettled(list)
	if type(list) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
	end

	for k, item in pairs(list) do
		if not Promise.is(item) then
			error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(k))), 2)
		end
	end

	if #list == 0 then
		return Promise.resolve({})
	end

	return Promise._new(debug.traceback(nil, 2), function(callback, _, callback2)
		local v2 = {}
		local v3 = {}

		local count = 0

		local function resolveOne(i, ...)
			count += 1

			v2[i] = ...

			if count >= #list then
				callback(v2)
			end
		end

		callback2(function()
			for _, v4 in ipairs(v3) do
				v4:cancel()
			end
		end)

		for i, item in ipairs(list) do
			v3[i] = item:finally(function(...)
				resolveOne(i, ...)
			end)
		end
	end)
end

function Promise.race(list)
	assert(type(list) == "table", string.format("Please pass a list of promises to %s", "Promise.race"))

	for k, item in pairs(list) do
		assert(
			Promise.is(item),
			string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(k)))
		)
	end

	return Promise._new(debug.traceback(nil, 2), function(callback, callback2, callback3)
		local v2 = {}
		local flag = false

		local function cancel() -- 2 equivalent calls inferred from this helper
			for _, v3 in ipairs(v2) do
				v3:cancel()
			end
		end

		local function finalize(callback4) -- 3 equivalent calls inferred from this helper
			return function(...)
				cancel() -- inferred equivalent call
				flag = true
				return callback4(...)
			end
		end

		if callback3(finalize(callback2)) then -- inferred equivalent call
			return
		end

		for i, item in ipairs(list) do
			v2[i] = item:andThen(finalize(callback), finalize(callback2)) -- inferred equivalent call
		end

		if flag then
			cancel() -- inferred equivalent call
		end
	end)
end

function Promise.each(list, callback)
	assert(type(list) == "table", string.format("Please pass a list of promises to %s", "Promise.each"))
	assert(isCallable(callback), string.format("Please pass a handler function to %s!", "Promise.each")) -- inferred equivalent call

	return Promise._new(debug.traceback(nil, 2), function(callback2, callback3, callback4)
		local v2 = {}
		local values = {}

		local flag = false

		local function cancel() -- 5 equivalent calls inferred from this helper
			for _, v3 in ipairs(values) do
				v3:cancel()
			end
		end

		callback4(function()
			flag = true
			cancel() -- inferred equivalent call
		end)

		local v3 = {}

		for i, item in ipairs(list) do
			if Promise.is(item) then
				if item:getStatus() == Promise.Status.Cancelled then
					cancel() -- inferred equivalent call
					return callback3(err.new({
						error = "Promise is cancelled",
						kind = err.Kind.AlreadyCancelled,
						context = string.format(
							"The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
							i,
							item._source
						)
					}))
				elseif item:getStatus() == Promise.Status.Rejected then
					cancel() -- inferred equivalent call
					return callback3(select(2, item:await()))
				else
					local v4 = item:andThen(function(...)
						return ...
					end)

					table.insert(values, v4)
					v3[i] = v4
				end
			else
				v3[i] = item
			end
		end

		for i, v4 in ipairs(v3) do
			if Promise.is(v4) then
				local v5
				v5, v4 = v4:await()

				if not v5 then
					cancel() -- inferred equivalent call
					return callback3(v4)
				end
			end

			if flag then
				return
			end

			local resolved = Promise.resolve(callback(v4, i))

			table.insert(values, resolved)

			local v5, v6 = resolved:await()

			if v5 then
				v2[i] = v6
			else
				cancel() -- inferred equivalent call
				return callback3(v6)
			end
		end

		callback2(v2)
	end)
end

function Promise.is(p)
	if type(p) ~= "table" then
		return false
	end

	local metatable = getmetatable(p)

	if metatable == Promise then
		return true
	end

	if metatable == nil then
		return isCallable(p.andThen) -- inferred equivalent call
	end

	if
		type(metatable) == "table"
		and type((rawget(metatable, "__index"))) == "table"
		and isCallable(rawget(rawget(metatable, "__index"), "andThen")) -- inferred equivalent call
	then
		return true
	end

	return false
end

function Promise.promisify(p)
	return function(...)
		return Promise._try(debug.traceback(nil, 2), p, ...)
	end
end

local nextNode2 = nil
local connection = nil

function Promise.delay(value)
	assert(type(value) == "number", "Bad argument #1 to Promise.delay, must be a number.")
	local v2 = (not (value >= 1 / 60) or value == 1e999) and 1 / 60 or value
	return Promise._new(debug.traceback(nil, 2), function(resolve, _, callback)
		local time = Promise._getTime()
		local endTime = time + v2

		local v3 = { resolve = resolve, startTime = time, endTime = endTime }

		if connection == nil then
			nextNode2 = v3
			connection = Promise._timeEvent:Connect(function()
				local time2 = Promise._getTime()

				while nextNode2 ~= nil and nextNode2.endTime < time2 do
					local v4 = nextNode2
					nextNode2 = v4.next

					if nextNode2 == nil then
						connection:Disconnect()
						connection = nil
					else
						nextNode2.previous = nil
					end

					v4.resolve(Promise._getTime() - v4.startTime)
				end
			end)
		elseif nextNode2.endTime < endTime then
			local previous = nextNode2
			local nextNode = previous.next

			while nextNode ~= nil and nextNode.endTime < endTime do
				previous = nextNode
				nextNode = nextNode.next
			end

			previous.next = v3
			v3.previous = previous

			if nextNode ~= nil then
				v3.next = nextNode
				nextNode.previous = v3
			end
		else
			v3.next = nextNode2
			nextNode2.previous = v3
			nextNode2 = v3
		end

		callback(function()
			local nextNode = v3.next

			if nextNode2 == v3 then
				if nextNode == nil then
					connection:Disconnect()
					connection = nil
				else
					nextNode.previous = nil
				end

				nextNode2 = nextNode
			else
				local previous = v3.previous

				previous.next = nextNode

				if nextNode ~= nil then
					nextNode.previous = previous
				end
			end
		end)
	end)
end

function Promise.prototype.timeout(p, p2, p3)
	local traceback = debug.traceback(nil, 2)

	return Promise.race({
		Promise.delay(p2):andThen(function()
			return Promise.reject(p3 == nil and err.new({
				kind = err.Kind.TimedOut,
				error = "Timed out",
				context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p2, traceback)
			}) or p3)
		end),
		p
	})
end

function Promise.prototype:getStatus()
	return self._status
end

function Promise.prototype._andThen(state, p, p2, p3)
	state._unhandledRejection = false

	return Promise._new(p, function(callback, callback2)
		local v2

		if p2 then
			v2 = createAdvancer(p, p2, callback, callback2) -- inferred equivalent call
		else
			v2 = callback
		end

		local v3

		if p3 then
			v3 = createAdvancer(p, p3, callback, callback2) -- inferred equivalent call
		else
			v3 = callback2
		end

		if state._status == Promise.Status.Started then
			table.insert(state._queuedResolve, v2)
			table.insert(state._queuedReject, v3)
		elseif state._status == Promise.Status.Resolved then
			v2(unpack(state._values, 1, state._valuesLength))
		elseif state._status == Promise.Status.Rejected then
			v3(unpack(state._values, 1, state._valuesLength))
		elseif state._status == Promise.Status.Cancelled then
			callback2(err.new({
				error = "Promise is cancelled",
				kind = err.Kind.AlreadyCancelled,
				context = "Promise created at\n\n" .. p
			}))
		end
	end, state)
end

function Promise.prototype:andThen(value, value2)
	assert(value == nil or isCallable(value), string.format("Please pass a handler function to %s!", "Promise:andThen")) -- inferred equivalent call
	assert(
		value2 == nil or isCallable(value2), -- inferred equivalent call
		string.format("Please pass a handler function to %s!", "Promise:andThen")
	)

	return self:_andThen(debug.traceback(nil, 2), value, value2)
end

function Promise.prototype.andThenAsync(object, value, value2)
	assert(
		value == nil or isCallable(value), -- inferred equivalent call
		string.format("Please pass a handler function to %s!", "Promise:andThenAsync")
	)
	assert(
		value2 == nil or isCallable(value2), -- inferred equivalent call
		string.format("Please pass a handler function to %s!", "Promise:andThenAsync")
	)

	return object:_andThen(debug.traceback(nil, 2), function(...)
		local v2, v3 = pack(...)
		return Promise.defer(function(callback)
			callback(unpack(v3, 1, v2))
		end)
	end, function(...)
		local v2, v3 = pack(...)
		return Promise.defer(function(_, callback)
			callback(unpack(v3, 1, v2))
		end)
	end):andThen(value, value2)
end

function Promise.prototype:catch(value)
	assert(value == nil or isCallable(value), string.format("Please pass a handler function to %s!", "Promise:catch")) -- inferred equivalent call
	return self:_andThen(debug.traceback(nil, 2), nil, value)
end

function Promise.prototype.tap(object, callback)
	assert(isCallable(callback), string.format("Please pass a handler function to %s!", "Promise:tap")) -- inferred equivalent call
	return object:_andThen(debug.traceback(nil, 2), function(...)
		local v2 = callback(...)

		if not Promise.is(v2) then
			return ...
		end

		local v3, v4 = pack(...)
		return v2:andThen(function()
			return unpack(v4, 1, v3)
		end)
	end)
end

function Promise.prototype.andThenCall(object, callback, ...)
	assert(isCallable(callback), string.format("Please pass a handler function to %s!", "Promise:andThenCall")) -- inferred equivalent call
	local v2, v3 = pack(...)
	return object:_andThen(debug.traceback(nil, 2), function()
		return callback(unpack(v3, 1, v2))
	end)
end

function Promise.prototype.andThenReturn(object, ...)
	local v2, v3 = pack(...)
	return object:_andThen(debug.traceback(nil, 2), function()
		return unpack(v3, 1, v2)
	end)
end

function Promise.prototype:cancel()
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Cancelled

	if self._cancellationHook then
		self._cancellationHook()
	end

	coroutine.close(self._thread)

	if self._parent then
		self._parent:_consumerCancelled(self)
	end

	for k in pairs(self._consumers) do
		k:cancel()
	end

	self:_finalize()
end

function Promise.prototype:_consumerCancelled(p)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._consumers[p] = nil

	if next(self._consumers) == nil then
		self:cancel()
	end
end

function Promise.prototype:_finally(p, p2, p3)
	if not p3 then
		self._unhandledRejection = false
	end

	return Promise._new(p, function(callback, callback2)
		local v2

		if p2 then
			v2 = createAdvancer(p, p2, callback, callback2) -- inferred equivalent call
		else
			v2 = callback
		end

		local fn = p3 and function(...)
			if self._status == Promise.Status.Rejected then
				return callback(self)
			end

			return v2(...)
		end or v2

		if self._status == Promise.Status.Started then
			table.insert(self._queuedFinally, fn)
		else
			fn(self._status)
		end
	end, self)
end

function Promise.prototype:finally(value)
	assert(value == nil or isCallable(value), string.format("Please pass a handler function to %s!", "Promise:finally")) -- inferred equivalent call
	return self:_finally(debug.traceback(nil, 2), value)
end

function Promise.prototype:finallyCall(callback, ...)
	assert(isCallable(callback), string.format("Please pass a handler function to %s!", "Promise:finallyCall")) -- inferred equivalent call
	local v2, v3 = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(v3, 1, v2))
	end)
end

function Promise.prototype:finallyReturn(...)
	local v2, v3 = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(v3, 1, v2)
	end)
end

function Promise.prototype:done(value)
	assert(value == nil or isCallable(value), string.format("Please pass a handler function to %s!", "Promise:done")) -- inferred equivalent call

	return self:_finally(debug.traceback(nil, 2), value, true)
end

function Promise.prototype:doneCall(callback, ...)
	assert(isCallable(callback), string.format("Please pass a handler function to %s!", "Promise:doneCall")) -- inferred equivalent call
	local v2, v3 = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(v3, 1, v2))
	end, true)
end

function Promise.prototype:doneReturn(...)
	local v2, v3 = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(v3, 1, v2)
	end, true)
end

function Promise.prototype:awaitStatus()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local thread = coroutine.running()

		self:finally(function()
			task.spawn(thread)
		end)

		coroutine.yield()
	end

	if not (self._status ~= Promise.Status.Resolved and self._status ~= Promise.Status.Rejected) then
		return self._status, unpack(self._values, 1, self._valuesLength)
	end

	return self._status
end

local function awaitHelper(p, ...)
	return p == Promise.Status.Resolved, ...
end

function Promise.prototype:await()
	return awaitHelper(self:awaitStatus())
end

local function expectHelper(p, ...)
	if p ~= Promise.Status.Resolved then
		error(... == nil and "Expected Promise rejected with no value." or ..., 3)
	end

	return ...
end

function Promise.prototype:expect()
	return expectHelper(self:awaitStatus())
end

Promise.prototype.awaitValue = Promise.prototype.expect

function Promise.prototype:_unwrap()
	if self._status == Promise.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return self._status == Promise.Status.Resolved, unpack(self._values, 1, self._valuesLength)
end

function Promise.prototype._resolve(object, ...)
	if object._status == Promise.Status.Started then
		if Promise.is((...)) then
			if select("#", ...) > 1 then
				local v2 = string.format(
					"When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s",
					object._source
				)

				warn(v2)
			end

			local v2 = ...

			local parent = v2:andThen(function(...)
				object:_resolve(...)
			end, function(...)
				local v3 = v2._values[1]

				if v2._error then
					v3 = err.new({
						error = v2._error,
						kind = err.Kind.ExecutionError,
						context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]"
					})
				end

				if err.isKind(v3, err.Kind.ExecutionError) then
					return object:_reject(v3:extend({
						error = "This Promise was chained to a Promise that errored.",
						trace = "",
						context = string.format(
							"The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
							object._source
						)
					}))
				end

				object:_reject(...)
			end)

			if parent._status == Promise.Status.Cancelled then
				object:cancel()
			elseif parent._status == Promise.Status.Started then
				object._parent = parent
				parent._consumers[object] = true
			end
		else
			object._status = Promise.Status.Resolved
			local valuesLength, values = pack(...)
			object._valuesLength = valuesLength
			object._values = values

			for _, callback in ipairs(object._queuedResolve) do
				coroutine.wrap(callback)(...)
			end

			object:_finalize()
		end
	elseif Promise.is((...)) then
		(...):_consumerCancelled(object)
	end
end

function Promise.prototype:_reject(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Rejected
	local valuesLength, values = pack(...)
	self._valuesLength = valuesLength
	self._values = values

	if isEmpty(self._queuedReject) then -- inferred equivalent call
		local v2 = tostring((...))

		coroutine.wrap(function()
			Promise._timeEvent:Wait()

			if not self._unhandledRejection then
				return
			end

			local v3 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", v2, self._source)

			for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do
				task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))
			end

			if Promise.TEST then
				return
			end

			warn(v3)
		end)()
	else
		for _, callback in ipairs(self._queuedReject) do
			coroutine.wrap(callback)(...)
		end
	end

	self:_finalize()
end

local threads = {}
local thread = nil

local function closeThreads()
	thread = nil
	local v2 = threads
	threads = {}

	for _, v3 in v2 do
		coroutine.close(v3)
	end
end

local function _finalize(state)
	for _, callback in ipairs(state._queuedFinally) do
		coroutine.wrap(callback)(state._status)
	end

	state._queuedFinally = nil
	state._queuedReject = nil
	state._queuedResolve = nil

	if not Promise.TEST then
		state._parent = nil
		state._consumers = nil
	end

	if result then
		table.insert(threads, state._thread)

		if not thread then
			thread = task.defer(closeThreads)
		end
	else
		task.defer(coroutine.close, state._thread)
	end
end

Promise.prototype._finalize = _finalize

function Promise.prototype.now(object, p)
	local traceback = debug.traceback(nil, 2)

	if object._status == Promise.Status.Resolved then
		return object:_andThen(traceback, function(...)
			return ...
		end)
	end

	local reject = Promise.reject
	p = p == nil and err.new({
		kind = err.Kind.NotResolvedInTime,
		error = "This Promise was not resolved in time for :now()",
		context = ":now() was called at:\n\n" .. traceback
	}) or p
	return reject(p)
end

function Promise.retry(callback, value, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function") -- inferred equivalent call
	assert(type(value) == "number", "Parameter #2 to Promise.retry must be a number")

	local v2 = { ... }
	local v3 = select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if value > 0 then
			return Promise.retry(callback, value - 1, unpack(v2, 1, v3))
		end

		return Promise.reject(...)
	end)
end

function Promise.retryWithDelay(callback, value, value2, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function") -- inferred equivalent call
	assert(type(value) == "number", "Parameter #2 (times) to Promise.retry must be a number")
	assert(type(value2) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

	local v2 = { ... }
	local v3 = select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if value > 0 then
			Promise.delay(value2):await()

			return Promise.retryWithDelay(callback, value - 1, value2, unpack(v2, 1, v3))
		end

		return Promise.reject(...)
	end)
end

function Promise.fromEvent(object, p)
	local v2 = p or function(): boolean
		return true
	end

	return Promise._new(debug.traceback(nil, 2), function(callback, _, callback2)
		local connection2 = nil
		local v3 = false

		local function disconnect() -- 1 equivalent call inferred from this helper
			connection2:Disconnect()
			connection2 = nil
		end

		connection2 = object:Connect(function(...)
			local v4 = v2(...)

			if v4 == true then
				callback(...)

				if not connection2 then
					v3 = true
					return
				end

				disconnect() -- inferred equivalent call
			elseif type(v4) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if v3 and connection2 then
			return disconnect()
		end

		callback2(disconnect)
	end)
end

function Promise.onUnhandledRejection(p)
	table.insert(Promise._unhandledRejectionCallbacks, p)

	return function()
		local index = table.find(Promise._unhandledRejectionCallbacks, p)

		if index then
			table.remove(Promise._unhandledRejectionCallbacks, index)
		end
	end
end

return Promise
