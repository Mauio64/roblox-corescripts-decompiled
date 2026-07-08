local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuauPolyfill = require(scriptParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local Trie = require(scriptParent.wry.trie).Trie
local Cache = require(script.cache).Cache
local Entry = require(script.entry).Entry
local parentEntrySlot = require(script.context).parentEntrySlot
local context = require(script.context)

t1.bindContext = context.bindContext
t1.noContext = context.noContext
t1.setTimeout = context.setTimeout
t1.dep = require(script.dep).dep

local function makeDefaultMakeCacheKeyFunction() -- line: 61
	-- upvalues: Trie (copy)
	local v17 = Trie.new(true)

	return function(_, ...) -- line: 64
		-- upvalues: v17 (copy)
		return v17:lookupArray({ ... })
	end
end

local v15 = Trie.new(true)

function t1.defaultMakeCacheKey(_, ...) -- line: 64
	-- upvalues: v15 (copy)
	return v15:lookupArray({ ... })
end

t1.KeyTrie = Trie
require(script.initTypes)

local v16 = Set.new()

function t1.wrap(p3: ((...any) -> ...any), p4, p5) -- line: 104
	-- upvalues: Cache (copy), Boolean (copy), Trie (copy), Entry (copy), Array (copy), v16 (copy), parentEntrySlot (copy), Object (copy)
	local g27 = nil
	local makeCacheKey = nil

	if p4 == nil then
		p4 = {}
	end

	local v24 = Cache.new(Boolean.toJSBoolean(p4.max) and p4.max or 65536, function(p6) -- line: 115
		return p6:dispose()
	end)
	local keyArgs = p4.keyArgs

	if Boolean.toJSBoolean(p4.makeCacheKey) then
		makeCacheKey = p4.makeCacheKey

		if makeCacheKey then
			g27 = true
		end
	end

	if not g27 then
		local v28 = Trie.new(true)

		function makeCacheKey(_, ...) -- line: 64
			-- upvalues: v28 (copy)
			return v28:lookupArray({ ... })
		end
	end

	g27 = false

	local v29 = makeCacheKey

	if p5 ~= nil then
		local v30 = p3

		function p3(...) -- line: 126
			-- upvalues: v30 (copy), p5 (copy)
			return v30(p5, ...)
		end
	end

	local self = setmetatable({}, {
		__call = function(_, p9, ...) -- line: 134
			-- upvalues: p5 (copy), v29 (copy), keyArgs (copy), p3 (ref), v24 (copy), Entry (copy), p4 (ref), Array (copy), v16 (copy), parentEntrySlot (copy)
			local u45 = if p5 == nil then {
				p9,
				...
			} else { ... }
			local v46 = v29(nil, table.unpack((function() -- line: 147
				-- upvalues: keyArgs (copy), u45 (ref)
				if keyArgs then
					return keyArgs(nil, table.unpack(u45))
				end

				return u45
			end)()))

			if v46 == nil then
				return p3(table.unpack(u45))
			end

			local v47 = v24:get(v46)

			if v47 == nil then
				v47 = Entry.new(p3)
				v24:set(v46, v47)
				v47.subscribe = p4.subscribe

				function v47.forget() -- line: 167
					-- upvalues: v24 (copy), v46 (copy)
					return v24:delete(v46)
				end
			end

			local v48 = v47:recompute((Array.slice(u45)))

			v24:set(v46, v47)
			v16:add(v24)

			if not parentEntrySlot:hasValue() then
				v16:forEach(function(p10) -- line: 184
					return p10:clean()
				end)
				v16:clear()
			end

			return v48
		end,
		__index = function(p11, p12) -- line: 193
			-- upvalues: v24 (copy)
			if p12 == "size" then
				return v24.map.size
			end

			return (rawget(p11, p12))
		end,
		__newindex = function(p13, p14, p15) -- line: 199
			if p14 == "size" then
				error("attempt to update a read-only table", 2)
			end

			rawset(p13, p14, p15)
		end
	})

	local function asMethod(p16: ((...any) -> ...any)) -- line: 213
		return function(_, ...) -- line: 214
			-- upvalues: p16 (copy)
			return p16(...)
		end
	end
	local function dirtyKey(p18) -- line: 219
		-- upvalues: v24 (copy), Boolean (copy)
		local v56 = v24:get(p18)

		if Boolean.toJSBoolean(v56) then
			v56:setDirty()
		end
	end

	function self.dirtyKey(_, ...) -- line: 214
		-- upvalues: dirtyKey (copy)
		return dirtyKey(...)
	end

	local function v34(...) -- line: 228
		-- upvalues: v29 (copy), v24 (copy), Boolean (copy)
		local v58 = v29(nil, ...)
		local v59 = v24:get(v58)

		if Boolean.toJSBoolean(v59) then
			v59:setDirty()
		end
	end

	function self.dirty(_, ...) -- line: 214
		-- upvalues: v34 (copy)
		return v34(...)
	end

	local function peekKey(p21) -- line: 232
		-- upvalues: v24 (copy), Boolean (copy)
		local v62 = v24:get(p21)

		if Boolean.toJSBoolean(v62) then
			return v62:peek()
		end
	end

	function self.peekKey(_, ...) -- line: 214
		-- upvalues: peekKey (copy)
		return peekKey(...)
	end

	local function v36(...) -- line: 242
		-- upvalues: peekKey (copy), v29 (copy)
		return peekKey(v29(nil, ...))
	end

	function self.peek(_, ...) -- line: 214
		-- upvalues: v36 (copy)
		return v36(...)
	end

	local function forgetKey(p24) -- line: 246
		-- upvalues: v24 (copy)
		return v24:delete(p24)
	end

	function self.forgetKey(_, ...) -- line: 214
		-- upvalues: forgetKey (copy)
		return forgetKey(...)
	end

	local function v38(...) -- line: 252
		-- upvalues: forgetKey (copy), v29 (copy)
		return forgetKey(v29(nil, ...))
	end

	function self.forget(_, ...) -- line: 214
		-- upvalues: v38 (copy)
		return v38(...)
	end

	self.makeCacheKey = v29

	if Boolean.toJSBoolean(keyArgs) then
		local function v39(...) -- line: 260
			-- upvalues: v29 (copy), keyArgs (copy)
			return v29(nil, table.unpack(keyArgs(...)))
		end

		function self.getKey(_, ...) -- line: 214
			-- upvalues: v39 (copy)
			return v39(...)
		end
	else
		self.getKey = v29
	end

	return Object.freeze(self)
end

return t1
