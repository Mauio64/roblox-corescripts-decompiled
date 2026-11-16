local parent = script.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local instanceof = LuauPolyfill.instanceof
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local setTimeout = LuauPolyfill.setTimeout
local Array = LuauPolyfill.Array
local Symbol = LuauPolyfill.Symbol

local class = nil
local class2 = nil
local notifySubscription

local function isCallable(value): boolean -- 8 equivalent calls inferred from this helper
	if typeof(value) == "function" then
		return true
	end

	if typeof(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)

	if metatable and rawget(metatable, "__call") or value._isMockFunction then
		return true
	end

	return false
end

local function hasSymbols(): boolean -- 3 equivalent calls inferred from this helper
	return typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function"
end

local function hasSymbol(p: string) -- 5 equivalent calls inferred from this helper
	return hasSymbols() and Boolean.toJSBoolean(Symbol[p]) -- inferred equivalent call
end

local function getSymbol(p: string)
	if hasSymbol(p) then -- inferred equivalent call
		return Symbol[p]
	end

	return "@@" .. p
end

if hasSymbols() and not hasSymbol("observable") then -- inferred equivalent call
	Symbol.observable = Symbol("observable")
end

if hasSymbol("iterator") then -- inferred equivalent call
	local _iterator = Symbol.iterator
end

local symbol = not hasSymbol("observable") and "@@observable" or Symbol.observable -- inferred equivalent call
local v = not hasSymbol("species") and "@@species" or Symbol.species -- inferred equivalent call

local function getMethod(p, p2) -- 2 equivalent calls inferred from this helper
	local v2 = p[p2]

	if v2 == nil then
		return nil
	end

	if not isCallable(v2) then -- inferred equivalent call
		error(Error.new(tostring(v2) .. " is not a function"))
	end

	return v2
end

local function getSpecies(p) -- 5 equivalent calls inferred from this helper
	local v2 = p[v]
	return if v2 == nil then class else v2
end

local function isObservable(p) -- 1 equivalent call inferred from this helper
	return instanceof(p, class)
end

local hostReportError = nil
hostReportError = setmetatable({}, {
	__call = function(_, message)
		if hostReportError.log then
			hostReportError:log(message)
		else
			setTimeout(function()
				error(message)
			end, 0)
		end
	end
})

local function enqueue(fn) -- 3 equivalent calls inferred from this helper
	Promise.delay(0):doneCall(function()
		xpcall(fn, function(p)
			hostReportError(p)
		end)
	end)
end

local function cleanupSubscription(p)
	local cleanup = p._cleanup

	if cleanup == nil then
		return
	end

	p._cleanup = nil

	if not cleanup then
		return
	end

	local success = true
	local result = nil

	if isCallable(cleanup) then -- inferred equivalent call
		success, result = pcall(cleanup)
	else
		local method = getMethod(cleanup, "unsubscribe") -- inferred equivalent call

		if method then
			success, result = pcall(method, cleanup)
		end
	end

	if not success then
		hostReportError(result)
	end
end

local function closeSubscription(p) -- 3 equivalent calls inferred from this helper
	p._observer = nil
	p._queue = nil
	p._state = "closed"
end

local function flushSubscription(state)
	local queue = state._queue

	if not Boolean.toJSBoolean(queue) then
		return
	end

	state._queue = nil
	state._state = "ready"

	for i = 1, #queue do
		notifySubscription(state, queue[i].type, queue[i].value)

		if state._state == "closed" then
			break
		end
	end
end

notifySubscription = function(state, p, p2)
	state._state = "running"
	local observer = state._observer

	local result = nil
	local success, result2 = pcall(getMethod, observer, p)

	if not success then
		hostReportError(result2)
		return
	end

	if p == "next" then
		if result2 then
			success, result = pcall(result2, observer, p2)
		end
	elseif p == "error" then
		closeSubscription(state) -- inferred equivalent call

		if result2 then
			success, result = pcall(result2, observer, p2)
		else
			hostReportError(p2)
		end
	elseif p == "complete" then
		closeSubscription(state) -- inferred equivalent call

		if result2 then
			success, result = pcall(result2, observer, p2)
		end
	end

	if not success then
		hostReportError(result)
	end

	if state._state == "closed" then
		cleanupSubscription(state)
	elseif state._state == "running" then
		state._state = "ready"
	end
end

local function onNotify(subscription, p, p2)
	if subscription._state == "closed" then
		return
	end

	if subscription._state == "buffering" then
		assert(subscription._queue, "observable subscription queue nil during onNotify")
		table.insert(subscription._queue, { type = p, value = p2 })
	else
		if subscription._state == "ready" then
			notifySubscription(subscription, p, p2)
			return
		end

		subscription._state = "buffering"

		subscription._queue = {
			{ type = p, value = p2 }
		}
		local function fn()
			return flushSubscription(subscription)
		end

		enqueue(fn) -- inferred equivalent call
	end
end

local class3 = {}

function class3:__index(p)
	if p == "closed" then
		return self._state == "closed"
	end

	if rawget(self, p) then
		return (rawget(self, p))
	end

	if rawget(class3, p) then
		return (rawget(class3, p))
	end

	return nil
end

function class3.__newindex(p, p2, p3)
	if p2 == "closed" then
		error("setting getter-only property 'closed'")
	end

	rawset(p, p2, p3)
end

function class3.new(observer, callback)
	local self = setmetatable({}, class3)

	self._cleanup = nil
	self._observer = observer
	self._queue = nil
	self._state = "initializing"

	local v2 = class2.new(self)

	local success, result = pcall(callback, v2)

	if success then
		self._cleanup = result
	else
		v2:error(result)
	end

	if self._state == "initializing" then
		self._state = "ready"
	end

	return self
end

function class3:unsubscribe()
	if self._state ~= "closed" then
		closeSubscription(self) -- inferred equivalent call
		cleanupSubscription(self)
	end
end

class2 = {}
function class2:__index(p)
	if p == "closed" then
		return self._subscription._state == "closed"
	end

	if rawget(class2, p) then
		return (rawget(class2, p))
	end

	return (rawget(self, p))
end

function class2.__newindex(p, p2, p3)
	if p2 == "closed" then
		error("setting getter-only property 'closed'")
	end

	rawset(p, p2, p3)
end

function class2.new(subscription)
	return (setmetatable({ _subscription = subscription }, class2))
end

function class2:next(p)
	onNotify(self._subscription, "next", p)
end

function class2:error(p)
	onNotify(self._subscription, "error", p)
end

function class2:complete()
	onNotify(self._subscription, "complete")
end

class = {}
class.__index = class

local function isObservableClass(p): boolean
	return typeof(p) == "table" and p[symbol] == class[symbol] and typeof((rawget(p, "new"))) == "function"
end

function class.new(subscriber)
	if not isCallable(subscriber) then -- inferred equivalent call
		error("Observable initializer must be a function")
	end

	return (setmetatable({ _subscriber = subscriber }, class))
end

function class:subscribe(nextNode, err, complete)
	local v2 = (typeof(nextNode) ~= "table" or nextNode == nil)
		and { start = nil, next = nextNode, error = err, complete = complete }
		or nextNode

	return (class3.new(v2, self._subscriber))
end

function class:forEach(callback)
	return Promise.new(function(callback2, callback3)
		if not isCallable(callback) then -- inferred equivalent call
			callback3(Error.new(tostring(callback) .. " is not a function"))
			return
		end

		local v2 = nil
		local function done()
			v2:unsubscribe()
			callback2()
		end

		v2 = self:subscribe({
			next = function(self, p)
				local success, result = pcall(callback, p, done)

				if not success then
					callback3(result)
					v2:unsubscribe()
				end
			end,
			error = function(self, p)
				callback3(p)
			end,
			complete = function(self)
				callback2()
			end
		})
	end)
end

function class:map(callback)
	if not isCallable(callback) then -- inferred equivalent call
		error(Error.new(tostring(callback) .. " is not a function"))
	end

	return getSpecies(self).new(function(object) -- inferred equivalent call
		return self:subscribe({
			next = function(self, p)
				local success, result = pcall(callback, p)

				if success then
					object:next(result)
				else
					object:error(result)
				end
			end,
			error = function(self, p)
				object:error(p)
			end,
			complete = function(self)
				object:complete()
			end
		})
	end)
end

function class:filter(callback)
	if not isCallable(callback) then -- inferred equivalent call
		error(Error.new(tostring(callback) .. " is not a function"))
	end

	return getSpecies(self).new(function(object) -- inferred equivalent call
		return self:subscribe({
			next = function(self, p)
				local success, result = xpcall(callback, function(p2)
					object:error(p2)
				end, p)

				if success and not Boolean.toJSBoolean(result) or not success then
					return
				end

				object:next(p)
			end,
			error = function(self, p)
				object:error(p)
			end,
			complete = function(self)
				object:complete()
			end
		})
	end)
end

function class:reduce(callback, ...)
	local v2 = { callback, ... }

	if not isCallable(callback) then -- inferred equivalent call
		error(Error.new(tostring(callback) .. " is not a function"))
	end

	local species = getSpecies(self) -- inferred equivalent call
	local v3 = #v2 > 1
	local v4 = false
	local v5 = v2[2]

	return species.new(function(object)
		return self:subscribe({
			next = function(self, p)
				local v6 = not v4
				v4 = true

				if v6 and not v3 then
					v5 = p

					return
				end

				local _, result = xpcall(callback, function(p2)
					object:error(p2)
				end, v5, p)
				v5 = result
			end,
			error = function(self, p)
				object:error(p)
			end,
			complete = function(self)
				if not (v4 or v3) then
					object:error(Error.new("Cannot reduce an empty sequence"))
				end

				object:next(v5)
				object:complete()
			end
		})
	end)
end

function class.concat(p, ...)
	local v2 = { ... }
	local species = getSpecies(p) -- inferred equivalent call
	return species.new(function(object)
		local v3 = nil
		local v4 = 1
		local function startNext(object2)
			v3 = object2:subscribe({
				next = function(self, p2)
					object:next(p2)
				end,
				error = function(self, p2)
					object:error(p2)
				end,
				complete = function(self)
					if v4 == #v2 + 1 then
						v3 = nil
						object:complete()
					else
						local from = species.from
						local v5 = v4
						v4 += 1
						startNext(from(v2[v5]))
					end
				end
			})
		end

		startNext(p)

		return function()
			if Boolean.toJSBoolean(v3) then
				v3:unsubscribe()
				v3 = nil
			end
		end
	end)
end

function class:flatMap(callback)
	local v2 = nil

	if not isCallable(callback) then -- inferred equivalent call
		error(Error.new(tostring(callback) .. " is not a function"))
	end

	local species = getSpecies(self) -- inferred equivalent call
	return species.new(function(object)
		local v3 = {}
		local v4 = self:subscribe({
			next = function(self, result): nil
				if Boolean.toJSBoolean(callback) then
					local success
					success, result = xpcall(callback, function(p)
						object:error(p)
					end, result)
				end

				local v4 = nil
				v4 = species.from(result):subscribe({
					next = function(self, p)
						object:next(p)
					end,
					error = function(self, p)
						object:error(p)
					end,
					complete = function(self)
						local index = Array.indexOf(v3, v4)

						if index >= 1 then
							Array.splice(v3, index, 1)
						end

						v2()
					end
				})

				table.insert(v3, v4)
				return nil
			end,
			error = function(self, p)
				object:error(p)
			end,
			complete = function(self)
				v2()
			end
		})

		local function completeIfDone()
			if v4.closed and #v3 == 0 then
				object:complete()
			end
		end

		v2 = completeIfDone

		return function()
			Array.forEach(v3, function(object2)
				return object2:unsubscribe()
			end)

			v4:unsubscribe()
		end
	end)
end

class[symbol] = function(p)
	return p
end

function class.from(items, p)
	local v2

	if isObservableClass(items) then
		v2 = items
		items = p
	else
		v2 = class
	end

	if items == nil then
		error(Error.new(tostring(items) .. " is not an object"))
	end

	local method = getMethod(items, symbol) -- inferred equivalent call

	if method then
		local v3 = method(items)

		if isObservable(v3) and v3.new == v2.new then -- inferred equivalent call
			return v3
		end

		return v2.new(function(p2)
			return v3:subscribe(p2)
		end)
	end

	if Array.isArray(items) then
		return class.new(function(object)
			local function fn()
				if object.closed then
					return
				end

				for _, item in pairs(items) do
					object:next(item)

					if object.closed then
						return
					end
				end

				object:complete()
			end

			enqueue(fn) -- inferred equivalent call
		end)
	end

	error(Error.new(tostring(items) .. " is not observable"))
end

function class.of(p, ...)
	local v2, v3

	if isObservableClass(p) then
		v2 = p
		v3 = { ... }
	else
		v2 = class
		v3 = { p, ... }
	end

	return v2.new(function(object)
		local function fn()
			if object.closed then
				return
			end

			for _, v4 in ipairs(v3) do
				object:next(v4)

				if object.closed then
					return
				end
			end

			object:complete()
		end

		enqueue(fn) -- inferred equivalent call
	end)
end

if hasSymbols() then -- inferred equivalent call
	class[Symbol("extensions")] = { symbol = symbol, hostReportError = hostReportError }
end

return { Observable = class }
