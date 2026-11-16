local parent = script.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local trie = require(parent.wry.trie)
local trie2 = trie.Trie

local cache = require(script.cache)
local cache2 = cache.Cache
local entry = require(script.entry)
local entry2 = entry.Entry

local context = require(script.context)
local parentEntrySlot = context.parentEntrySlot

local context2 = require(script.context)
local Optimism = {}

Optimism.bindContext = context2.bindContext
Optimism.noContext = context2.noContext
Optimism.setTimeout = context2.setTimeout

local dep = require(script.dep)
Optimism.dep = dep.dep

local function makeDefaultMakeCacheKeyFunction() -- 2 equivalent calls inferred from this helper
	local v = trie2.new(true)
	return function(_, ...)
		return v:lookupArray({ ... })
	end
end

Optimism.defaultMakeCacheKey = makeDefaultMakeCacheKeyFunction() -- inferred equivalent call

Optimism.KeyTrie = trie2

require(script.initTypes)

local v = Set.new()

function Optimism.wrap(callback, p, p2)
	local v2 = p == nil and {} or p

	local v3 = cache2.new(Boolean.toJSBoolean(v2.max) and v2.max or 65536, function(object)
		return object:dispose()
	end)

	local keyArgs = v2.keyArgs
	local v4 = Boolean.toJSBoolean(v2.makeCacheKey) and v2.makeCacheKey or makeDefaultMakeCacheKeyFunction() -- inferred equivalent call

	if p2 ~= nil then
		local v5 = callback
		callback = function(...)
			return v5(p2, ...)
		end
	end

	local object = setmetatable({}, {
		__call = function(_, p3, ...)
			local v5 = p2 == nil and { p3, ... } or { ... }

			local v6 = v4(nil, table.unpack((function()
				if keyArgs then
					return keyArgs(nil, table.unpack(v5))
				end

				return v5
			end)()))

			if v6 == nil then
				return callback(table.unpack(v5))
			end

			local v7 = v3:get(v6)

			if v7 == nil then
				v7 = entry2.new(callback)
				v3:set(v6, v7)
				v7.subscribe = v2.subscribe

				function v7.forget()
					return v3:delete(v6)
				end
			end

			local recompute = v7:recompute((Array.slice(v5)))

			v3:set(v6, v7)

			v:add(v3)

			if not parentEntrySlot:hasValue() then
				v:forEach(function(object)
					return object:clean()
				end)

				v:clear()
			end

			return recompute
		end,
		__index = function(p3, p4)
			if p4 == "size" then
				return v3.map.size
			end

			return (rawget(p3, p4))
		end,
		__newindex = function(p3, p4, p5)
			if p4 == "size" then
				error("attempt to update a read-only table", 2)
			end

			rawset(p3, p4, p5)
		end
	})

	local function asMethod(callback2) -- 7 equivalent calls inferred from this helper
		return function(_, ...)
			return callback2(...)
		end
	end

	local function dirtyKey(p3) -- 1 equivalent call inferred from this helper
		local v5 = v3:get(p3)

		if Boolean.toJSBoolean(v5) then
			v5:setDirty()
		end
	end

	object.dirtyKey = asMethod(dirtyKey) -- inferred equivalent call

	local function fn(...)
		dirtyKey(v4(nil, ...)) -- inferred equivalent call
	end

	object.dirty = asMethod(fn) -- inferred equivalent call

	local function peekKey(p3)
		local v5 = v3:get(p3)

		if Boolean.toJSBoolean(v5) then
			return v5:peek()
		end
	end

	object.peekKey = asMethod(peekKey) -- inferred equivalent call

	local function fn2(...)
		return peekKey(v4(nil, ...))
	end

	object.peek = asMethod(fn2) -- inferred equivalent call

	local function forgetKey(p3)
		return v3:delete(p3)
	end

	object.forgetKey = asMethod(forgetKey) -- inferred equivalent call

	local function fn3(...)
		return forgetKey(v4(nil, ...))
	end

	object.forget = asMethod(fn3) -- inferred equivalent call

	object.makeCacheKey = v4

	if Boolean.toJSBoolean(keyArgs) then
		local function fn4(...)
			return v4(nil, table.unpack(keyArgs(...)))
		end

		object.getKey = asMethod(fn4) -- inferred equivalent call
	else
		object.getKey = v4
	end

	return Object.freeze(object)
end
return Optimism
