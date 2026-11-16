local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local Map = LuauPolyfill.Map

local Object = require(parent.luaUtils.Object)

local HttpService = game:GetService("HttpService")

local trie = require(parent.wry.trie)
local trie2 = trie.Trie

local utilities = require(script.Parent.Parent.Parent.utilities)
local canUseWeakMap = utilities.canUseWeakMap

local isNonNullObject = utilities.isNonNullObject

local sortedEncode = require(parent.luaUtils.sortedEncode)
local sortedEncode2 = sortedEncode.sortedEncode

local resetCanonicalStringify

local v = nil
local v2 = nil

local function shallowCopy(p) -- 1 equivalent call inferred from this helper
	return (table.clone(p))
end

local function isArrayLike(list): boolean -- 1 equivalent call inferred from this helper
	return #list == 0 and not next(list) or #list > 1
end

local class = {}

class.__index = class

function class.new()
	local self = setmetatable({}, class)

	self.known = Set.new()
	self.pool = trie2.new(canUseWeakMap)
	self.passes = WeakMap.new()

	self.keysByJSON = Map.new(nil)

	self.empty = self:admit({})

	return self
end

function class.isKnown(p, p2)
	return isNonNullObject(p2) and p.known:has(p2)
end

function class.pass(p, p2)
	if not isNonNullObject(p2) then
		return p2
	end

	local v3 = shallowCopy(p2) -- inferred equivalent call
	p.passes:set(v3, p2)
	return v3
end

function class:admit(list)
	if not isNonNullObject(list) then
		return list
	end

	local v3 = self.passes:get(list)

	if v3 then
		return v3
	end

	if Object.getPrototypeOf(list) ~= nil then
		return list
	end

	if isArrayLike(list) then -- inferred equivalent call
		if self.known:has(list) then
			return list
		end

		local mapped = Array.map(list, self.admit, self)

		local array = self.pool:lookupArray(mapped)

		if array.array then
			return array.array
		end

		array.array = mapped
		self.known:add(array.array)

		if _G.__DEV__ then
			Object.freeze(mapped)
		end

		return array.array
	else
		if self.known:has(list) then
			return list
		end

		local prototypeOf = Object.getPrototypeOf(list)
		local v4 = { prototypeOf }
		local sortedKeys = self:sortedKeys(list)
		table.insert(v4, sortedKeys.json)
		local count = #v4
		Array.forEach(sortedKeys.sorted, function(p)
			table.insert(v4, self:admit(list[p]))
		end)

		local array = self.pool:lookupArray(v4)

		if array.object then
			return array.object
		end

		array.object = Object.create(prototypeOf)
		local object = array.object
		self.known:add(object)
		Array.forEach(sortedKeys.sorted, function(p, p2)
			object[p] = v4[count + p2]
		end)

		if _G.__DEV__ then
			Object.freeze(object)
		end

		return array.object
	end

	return list
end

function class:sortedKeys(p)
	local keys = Object.keys(p)
	local array = self.pool:lookupArray(keys)

	if array.keys then
		return array.keys
	end

	Array.sort(keys)
	local jsonEncode = HttpService:JSONEncode(keys)

	array.keys = self.keysByJSON:get(jsonEncode)

	if not array.keys then
		array.keys = { sorted = keys, json = jsonEncode }

		self.keysByJSON:set(jsonEncode, array.keys)
	end

	return array.keys
end

local ObjectCanon = {
	["ObjectCanon"] = class,
	canonicalStringify = Object.assign(setmetatable({}, {
		__call = function(_, p)
			if not isNonNullObject(p) then
				return HttpService:JSONEncode(p)
			end

			if v == nil then
				resetCanonicalStringify()
			end

			local admit = v:admit(p)
			local v3 = v2:get(admit)

			if v3 == nil then
				local v4 = v2

				v3 = sortedEncode2(admit)
				v4:set(admit, v3)
			end

			return v3
		end
	}), {
		reset = function(_)
			return resetCanonicalStringify()
		end
	})
}

resetCanonicalStringify = function()
	v = class.new()
	v2 = WeakMap.new()
end

return ObjectCanon
