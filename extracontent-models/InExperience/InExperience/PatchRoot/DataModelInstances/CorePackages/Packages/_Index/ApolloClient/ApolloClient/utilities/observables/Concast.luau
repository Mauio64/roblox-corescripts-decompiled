local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

local Promise = require(parent.Promise)

local sub2 = {}

local Observable = require(script.Parent.Observable)
local observable = Observable.Observable

local iteration = require(script.Parent.iteration)
local iterateObserversSafely = iteration.iterateObserversSafely
local subclassing = require(script.Parent.subclassing)
local fixObservableSubclass = subclassing.fixObservableSubclass

local function isPromiseLike(p) -- 2 equivalent calls inferred from this helper
	return Boolean.toJSBoolean(p) and typeof(p.andThen) == "function"
end

local object = setmetatable({}, { __index = observable })
object.__index = object

function object.new(callback)
	local v = nil
	v = setmetatable(observable.new(function(p)
		v:addObserver(p)
		return function()
			return v:removeObserver(p)
		end
	end), object)

	v.observers = Set.new()

	v.sub = sub2

	v.source = {}

	v.latest = nil

	v.addCount = 0

	v.promise = Promise.new(function(callback2, callback3)
		function v:resolve(...)
			callback2(...)
		end
		function v:reject(...)
			callback3(...)
		end
	end)

	v.handlers = {
		next = function(_, p)
			if v.sub ~= nil then
				v.latest = { "next", p }
				iterateObserversSafely(v.observers, "next", p)
			end
		end,
		error = function(self, p)
			local sub = v.sub

			if sub ~= nil then
				if Boolean.toJSBoolean(sub) then
					Promise.delay(0):andThen(function()
						return sub:unsubscribe()
					end)
				end

				v.sub = nil
				v.latest = { "error", p }
				v:reject(p)
				iterateObserversSafely(v.observers, "error", p)
			end
		end,
		complete = function(_)
			if v.sub ~= nil then
				local v2 = table.remove(v.sources, 1)

				if Boolean.toJSBoolean(v2) then
					if isPromiseLike(v2) then -- inferred equivalent call
						v2:andThen(function(object2)
							v.sub = object2:subscribe(v.handlers)
						end)
					else
						v.sub = v2:subscribe(v.handlers)
					end
				else
					v.sub = nil

					if v.latest == nil or v.latest[1] ~= "next" then
						v:resolve()
					else
						v:resolve(v.latest[2])
					end

					iterateObserversSafely(v.observers, "complete")
				end
			end
		end
	}

	function v.cancel(_, p)
		v:reject(p)
		v.sources = {}
		v.handlers:complete()
	end

	v.promise:catch(function() end)

	local v2 = typeof(callback) == "function" and { observable.new(callback) } or callback

	if isPromiseLike(v2) then -- inferred equivalent call
		v2:andThen(function(p)
			v:start(p)
		end, function(...)
			v.handlers:error(...)
		end)
	else
		v:start(v2)
	end

	return v
end

function object:start(p)
	if self.sub ~= sub2 then
		return
	end

	self.sources = Array.from(p)

	self.handlers:complete()
end

function object:deliverLastMessage(p)
	if Boolean.toJSBoolean(self.latest) then
		local v = self.latest[1]
		local v2 = p[v]

		if Boolean.toJSBoolean(v2) then
			v2(p, self.latest[2])
		end

		if self.sub == nil and v == "next" and p.complete ~= nil then
			p.complete(p)
		end
	end
end

function object:addObserver(p)
	if not self.observers:has(p) then
		self:deliverLastMessage(p)
		self.observers:add(p)
		self.addCount += 1
	end
end

function object:removeObserver(p, flag: boolean?)
	if self.observers:delete(p) then
		self.addCount -= 1

		if self.addCount < 1 and not flag then
			self.handlers:error(Error.new("Observable cancelled prematurely"))
		end
	end
end

function object:cleanup(callback)
	local v = false
	local v2 = nil
	local function once()
		if not v then
			v = true

			self.observers:delete(v2)
			callback()
		end
	end
	v2 = { next = once, error = once, complete = once }
	local addCount = self.addCount
	self:addObserver(v2)

	self.addCount = addCount
end

function object.of(...)
	return observable.of(object, ...)
end

function object.from(...)
	return observable.from(object, ...)
end

fixObservableSubclass(object)
return { Concast = object }
