local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Promise = require(ParentParent.Promise)
local t2 = {}
local Observable = require(script.Parent.Observable).Observable
local iterateObserversSafely = require(script.Parent.iteration).iterateObserversSafely
local fixObservableSubclass = require(script.Parent.subclassing).fixObservableSubclass

local function isPromiseLike(p1) -- line: 50
	-- upvalues: Boolean (copy)
	return Boolean.toJSBoolean(p1) and typeof(p1.andThen) == "function"
end

local self = setmetatable({}, {
	__index = Observable
})

self.__index = self

function self.new(p2) -- line: 125
	-- upvalues: Observable (copy), self (copy), Set (copy), t2 (copy), Promise (copy), iterateObserversSafely (copy), Boolean (copy)
	local u17 = nil

	u17 = setmetatable(Observable.new(function(p3) -- line: 129
		-- upvalues: u17 (ref)
		u17:addObserver(p3)

		return function() -- line: 131
			-- upvalues: u17 (ref), p3 (copy)
			return u17:removeObserver(p3)
		end
	end), self)
	u17.observers = Set.new()
	u17.sub = t2
	u17.source = {}
	u17.latest = nil
	u17.addCount = 0
	u17.promise = Promise.new(function(resolve, reject) -- line: 163
		-- upvalues: u17 (ref)
		function u17.resolve(_, ...) -- line: 164
			-- upvalues: resolve (copy)
			resolve(...)
		end
		function u17.reject(_, ...) -- line: 167
			-- upvalues: reject (copy)
			reject(...)
		end
	end)
	u17.handlers = {
		next = function(_, p7) -- line: 175
			-- upvalues: u17 (ref), iterateObserversSafely (copy)
			if u17.sub ~= nil then
				u17.latest = {
					"next",
					p7
				}
				iterateObserversSafely(u17.observers, "next", p7)
			end
		end,
		error = function(_, p9) -- line: 181
			-- upvalues: u17 (ref), Boolean (copy), Promise (copy), iterateObserversSafely (copy)
			local sub = u17.sub

			if sub ~= nil then
				if Boolean.toJSBoolean(sub) then
					Promise.delay(0):andThen(function() -- line: 188
						-- upvalues: sub (copy)
						return sub:unsubscribe()
					end)
				end

				u17.sub = nil
				u17.latest = {
					"error",
					p9
				}
				u17:reject(p9)
				iterateObserversSafely(u17.observers, "error", p9)
			end
		end,
		complete = function(_) -- line: 198
			-- upvalues: u17 (ref), Boolean (copy), iterateObserversSafely (copy)
			if u17.sub ~= nil then
				local v44 = table.remove(u17.sources, 1)

				if not Boolean.toJSBoolean(v44) then
					u17.sub = nil

					if u17.latest ~= nil and u17.latest[1] == "next" then
						u17:resolve(u17.latest[2])
					else
						u17:resolve()
					end

					iterateObserversSafely(u17.observers, "complete")

					return
				end

				if Boolean.toJSBoolean(v44) and typeof(v44.andThen) == "function" then
					v44:andThen(function(p11) -- line: 216
						-- upvalues: u17 (ref)
						u17.sub = p11:subscribe(u17.handlers)
					end)

					return
				end

				u17.sub = v44:subscribe(u17.handlers)
			end
		end
	}

	function u17.cancel(_, p13) -- line: 227
		-- upvalues: u17 (ref)
		u17:reject(p13)
		u17.sources = {}
		u17.handlers:complete()
	end

	u17.promise:catch(function() -- line: 236
	end)

	if typeof(p2) == "function" then
		p2 = { Observable.new(p2) }
	end

	if Boolean.toJSBoolean(p2) and typeof(p2.andThen) == "function" then
		p2:andThen(function(p14) -- line: 246
			-- upvalues: u17 (ref)
			u17:start(p14)
		end, function(...) -- line: 248
			-- upvalues: u17 (ref)
			u17.handlers:error(...)
		end)
	else
		u17:start(p2)
	end

	return u17
end
function self.start(p15, p16) -- line: 261
	-- upvalues: t2 (copy), Array (copy)
	if p15.sub ~= t2 then
		return
	end

	p15.sources = Array.from(p16)
	p15.handlers:complete()
end
function self.deliverLastMessage(p17, p18) -- line: 278
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p17.latest) then
		local v22 = p17.latest[1]
		local v23 = p18[v22]

		if Boolean.toJSBoolean(v23) then
			v23(p18, p17.latest[2])
		end

		if p17.sub == nil and v22 == "next" and p18.complete ~= nil then
			p18:complete()
		end
	end
end
function self.addObserver(p19, p20) -- line: 296
	if not p19.observers:has(p20) then
		p19:deliverLastMessage(p20)
		p19.observers:add(p20)
		p19.addCount = p19.addCount + 1
	end
end
function self.removeObserver(t3: {[any]: any}, p21, b1: boolean?) -- line: 306
	-- upvalues: Error (copy)
	if t3.observers:delete(p21) then
		t3.addCount = t3.addCount - 1

		if t3.addCount < 1 and not b1 then
			t3.handlers:error(Error.new("Observable cancelled prematurely"))
		end
	end
end
function self.cleanup(t4: {[any]: any}, p22: ((...any) -> ...any)) -- line: 322
	local u31 = false
	local t5 = nil

	local function once() -- line: 325
		-- upvalues: u31 (ref), t4 (copy), t5 (ref), p22 (copy)
		if not u31 then
			u31 = true
			t4.observers:delete(t5)
			p22()
		end
	end

	t5 = {
		next = once,
		error = once,
		complete = once
	}

	local addCount = t4.addCount

	t4:addObserver(t5)
	t4.addCount = addCount
end
function self.of(...) -- line: 345
	-- upvalues: Observable (copy), self (copy)
	return Observable.of(self, ...)
end
function self.from(...) -- line: 349
	-- upvalues: Observable (copy), self (copy)
	return Observable.from(self, ...)
end

t1.Concast = self
fixObservableSubclass(self)

return t1
