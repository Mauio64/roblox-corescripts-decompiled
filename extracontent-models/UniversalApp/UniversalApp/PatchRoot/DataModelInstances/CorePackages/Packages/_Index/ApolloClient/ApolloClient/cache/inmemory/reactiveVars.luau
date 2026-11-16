local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local optimism = require(parent.optimism)
local dep = optimism.dep

local context = require(parent.wry.context)
local slot = context.Slot

require(script.Parent.Parent.core.cache)

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap

local broadcast

local cacheSlot = slot.new()
local ReactiveVars = {}
ReactiveVars.cacheSlot = cacheSlot
local v = WeakMap.new()

local function getCacheInfo(p)
	local cacheInfo = v:get(p)

	if not cacheInfo then
		cacheInfo = { vars = Set.new(), dep = dep() }

		v:set(p, cacheInfo)
	end

	return cacheInfo
end

function ReactiveVars:forgetCache()
	getCacheInfo(self).vars:forEach(function(object)
		return object:forgetCache(self)
	end)
end

function ReactiveVars.recallCache(p)
	getCacheInfo(p).vars:forEach(function(object)
		return object:attachCache(p)
	end)
end

function ReactiveVars.makeVar(p)
	local v2 = Set.new()
	local v3 = Set.new()
	local var = nil

	local fn

	var = setmetatable({}, {
		__call = function(_, ...)
			if select("#", ...) >= 1 then
				local v4 = ({ ... })[1]

				if p ~= v4 then
					p = v4
					v2:forEach(function(p2)
						getCacheInfo(p2).dep:dirty(var)

						broadcast(p2)
					end)

					local v5 = Array.from(v3)
					v3:clear()
					Array.forEach(v5, function(callback)
						callback(p)
					end)
				end
			else
				local value = cacheSlot:getValue()

				if value then
					fn(value)
					getCacheInfo(value).dep(var)
				end
			end

			return p
		end
	})

	function var.onNextChange(_, p2)
		v3:add(p2)
		return function()
			v3:delete(p2)
		end
	end

	fn = function(p2)
		v2:add(p2)
		getCacheInfo(p2).vars:add(var)
		return var
	end

	function var:attachCache(p2)
		return fn(p2)
	end

	function var:forgetCache(p2)
		return v2:delete(p2)
	end

	return var
end

broadcast = function(object)
	if object.broadcastWatches ~= nil then
		object:broadcastWatches()
	end
end

return ReactiveVars
