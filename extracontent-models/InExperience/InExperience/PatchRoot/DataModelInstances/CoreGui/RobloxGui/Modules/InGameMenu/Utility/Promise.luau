local function pack(...)
	return select("#", ...), { ... }
end

local function wpcallPacked(callback, ...)
	local v, v2 = pack(...)

	local v3, v4 = pack(xpcall(function()
		return callback(unpack(v2, 1, v))
	end, debug.traceback))

	return v3, v4
end

local function createAdvancer(p, callback, callback2) -- 2 equivalent calls inferred from this helper
	return function(...)
		local v, v2 = wpcallPacked(p, ...)

		if v2[1] then
			callback(unpack(v2, 2, v))
		else
			callback2(unpack(v2, 2, v))
		end
	end
end

local function isEmpty(queuedReject): boolean -- 1 equivalent call inferred from this helper
	return next(queuedReject) == nil
end

local function createSymbol(name)
	assert(type(name) == "string", "createSymbol requires `name` to be a string.")

	local symbol = newproxy(true)

	getmetatable(symbol).__tostring = function()
		return ("Symbol(%s)"):format(name)
	end

	return symbol
end

assert(true, "createSymbol requires `name` to be a string.")

local v = newproxy(true)

local v2 = "PromiseMarker"
getmetatable(v).__tostring = function()
	return ("Symbol(%s)"):format(v2)
end

local Promise = {}
Promise.prototype = {}
Promise.__index = Promise.prototype
assert(true, "createSymbol requires `name` to be a string.")

local started = newproxy(true)

local v3 = "Started"
getmetatable(started).__tostring = function()
	return ("Symbol(%s)"):format(v3)
end

assert(true, "createSymbol requires `name` to be a string.")

local resolved = newproxy(true)

local v4 = "Resolved"
getmetatable(resolved).__tostring = function()
	return ("Symbol(%s)"):format(v4)
end

assert(true, "createSymbol requires `name` to be a string.")

local rejected = newproxy(true)

local v5 = "Rejected"
getmetatable(rejected).__tostring = function()
	return ("Symbol(%s)"):format(v5)
end

Promise.Status = { Started = started, Resolved = resolved, Rejected = rejected }

function Promise.new(p)
	local v6 = {
		_source = debug.traceback(),
		[v] = true,
		_status = Promise.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = false,
		_queuedResolve = {},
		_queuedReject = {}
	}

	setmetatable(v6, Promise)

	local function resolve(...)
		v6:_resolve(...)
	end

	local function reject(...)
		v6:_reject(...)
	end

	local _, v7 = wpcallPacked(p, resolve, reject)
	local v8 = v7[1]
	local v9 = v7[2]

	if not v8 and v6._status == Promise.Status.Started then
		reject(v9)
	end

	return v6
end

function Promise.resolve(p)
	return Promise.new(function(callback)
		callback(p)
	end)
end

function Promise.reject(p)
	return Promise.new(function(_, callback)
		callback(p)
	end)
end

function Promise.all(list)
	if type(list) ~= "table" then
		error("Please pass a list of promises to Promise.all", 2)
	end

	if #list == 0 then
		return Promise.resolve({})
	end

	for i = 1, #list do
		if not Promise.is(list[i]) then
			error(("Non-promise value passed into Promise.all at index #%d"):format(i), 2)
		end
	end

	return Promise.new(function(callback, callback2)
		local v6 = {}

		local count = 0

		local function resolveOne(i, ...)
			v6[i] = ...
			count += 1

			if count == #list then
				callback(v6)
			end
		end

		for i = 1, #list do
			list[i]:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				callback2(...)
			end)
		end
	end)
end

function Promise.is(p): boolean
	return type(p) == "table" and p[v] == true
end

function Promise.prototype:getStatus()
	return self._status
end

function Promise.prototype:andThen(p, p2)
	self._unhandledRejection = false

	return Promise.new(function(callback, callback2)
		local v6

		if p then
			v6 = createAdvancer(p, callback, callback2) -- inferred equivalent call
		else
			v6 = callback
		end

		local v7

		if p2 then
			v7 = createAdvancer(p2, callback, callback2) -- inferred equivalent call
		else
			v7 = callback2
		end

		if self._status == Promise.Status.Started then
			table.insert(self._queuedResolve, v6)
			table.insert(self._queuedReject, v7)
		elseif self._status == Promise.Status.Resolved then
			v6(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Rejected then
			v7(unpack(self._values, 1, self._valuesLength))
		end
	end)
end

function Promise.prototype:catch(p)
	return self:andThen(nil, p)
end

function Promise.prototype:await()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local v6 = nil
		local v7 = nil
		local bindableEvent = Instance.new("BindableEvent")

		self:andThen(function(...)
			v7, v6 = pack(...)
			bindableEvent:Fire(true)
		end, function(...)
			v7, v6 = pack(...)
			bindableEvent:Fire(false)
		end)

		local v8 = bindableEvent.Event:Wait()
		bindableEvent:Destroy()

		return v8, unpack(v6, 1, v7)
	end

	if self._status == Promise.Status.Resolved then
		return true, unpack(self._values, 1, self._valuesLength)
	end

	if self._status == Promise.Status.Rejected then
		return false, unpack(self._values, 1, self._valuesLength)
	end

	error("Promise had an invalid status.")
end

function Promise.prototype:_unwrap()
	if self._status == Promise.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return self._status == Promise.Status.Resolved, unpack(self._values, 1, self._valuesLength)
end

function Promise.prototype:_resolve(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	if Promise.is((...)) then
		if select("#", ...) > 1 then
			local formatted = ("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s"):format(self._source)

			warn(formatted)
		end

		(...):andThen(function(...)
			self:_resolve(...)
		end, function(...)
			self:_reject(...)
		end)
	else
		self._status = Promise.Status.Resolved
		local valuesLength, values = pack(...)
		self._valuesLength = valuesLength
		self._values = values

		for _, v6 in ipairs(self._queuedResolve) do
			v6(...)
		end
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
		self._unhandledRejection = true
		local v6 = tostring((...))

		spawn(function()
			if not self._unhandledRejection then
				return
			end

			local formatted = ("Unhandled promise rejection:\n\n%s\n\n%s"):format(v6, self._source)

			warn(formatted)
		end)
	else
		for _, v6 in ipairs(self._queuedReject) do
			v6(...)
		end
	end
end

return Promise
