local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local Map = LuauPolyfill.Map
local Object = require(ParentParent.luaUtils.Object)
local HttpService = game:GetService("HttpService")
local t1 = {}
local Trie = require(ParentParent.wry.trie).Trie
local utilities = require(script.Parent.Parent.Parent.utilities)
local canUseWeakMap = utilities.canUseWeakMap
local isNonNullObject = utilities.isNonNullObject
local sortedEncode = require(ParentParent.luaUtils.sortedEncode).sortedEncode
local resetCanonicalStringify = nil
local u17 = nil
local u18 = nil

local function shallowCopy(p1) -- line: 47
	return (table.clone(p1))
end
local function isArrayLike(p2) -- line: 53
	if #p2 == 0 and not next(p2) then
		return true
	end

	if #p2 > 1 then
		return true
	end

	return false
end

local t2 = {}

t2.__index = t2

function t2.new() -- line: 147
	-- upvalues: t2 (copy), Set (copy), Trie (copy), canUseWeakMap (copy), WeakMap (copy), Map (copy)
	local self = setmetatable({}, t2)

	self.known = Set.new()
	self.pool = Trie.new(canUseWeakMap)
	self.passes = WeakMap.new()
	self.keysByJSON = Map.new(nil)
	self.empty = self:admit({})

	return self
end
function t2.isKnown(p3, p4) -- line: 162
	-- upvalues: isNonNullObject (copy)
	return isNonNullObject(p4) and p3.known:has(p4)
end
function t2.pass(p5, p6) -- line: 166
	-- upvalues: isNonNullObject (copy)
	if isNonNullObject(p6) then
		local v29 = table.clone(p6)

		p5.passes:set(v29, p6)

		return v29
	end

	return p6
end
function t2.admit(p7, p8) -- line: 177
	-- upvalues: isNonNullObject (copy), Object (copy), Array (copy)
	if isNonNullObject(p8) then
		local v32 = p7.passes:get(p8)

		if v32 then
			return v32
		end

		if Object.getPrototypeOf(p8) == nil then
			if #p8 == 0 and not next(p8) or #p8 > 1 then
				if p7.known:has(p8) then
					return p8
				end

				local v33 = Array.map(p8, p7.admit, p7)
				local v34 = p7.pool:lookupArray(v33)

				if not v34.array then
					v34.array = v33
					p7.known:add(v34.array)

					if _G.__DEV__ then
						Object.freeze(v33)
					end
				end

				return v34.array
			end

			if p7.known:has(p8) then
				return p8
			end

			local v35 = Object.getPrototypeOf(p8)
			local t3 = { v35 }
			local v37 = p7:sortedKeys(p8)

			table.insert(t3, v37.json)

			local v38 = #t3

			Array.forEach(v37.sorted, function(p9) -- line: 226
				-- upvalues: t3 (copy), p7 (copy), p8 (copy)
				table.insert(t3, p7:admit(p8[p9]))
			end)

			local v39 = p7.pool:lookupArray(t3)

			if not v39.object then
				v39.object = Object.create(v35)

				local object = v39.object

				p7.known:add(object)
				Array.forEach(v37.sorted, function(p10, p11) -- line: 244
					-- upvalues: object (copy), t3 (copy), v38 (copy)
					object[p10] = t3[v38 + p11]
				end)

				if _G.__DEV__ then
					Object.freeze(object)
				end
			end

			return v39.object
		end
	end

	return p8
end
function t2.sortedKeys(t4: {[any]: any}, t5: {[any]: any}) -- line: 267
	-- upvalues: Object (copy), Array (copy), HttpService (copy)
	local v43 = Object.keys(t5)
	local v44 = t4.pool:lookupArray(v43)

	if not v44.keys then
		Array.sort(v43)

		local json = HttpService:JSONEncode(v43)

		v44.keys = t4.keysByJSON:get(json)

		if not v44.keys then
			v44.keys = {
				sorted = v43,
				json = json
			}
			t4.keysByJSON:set(json, v44.keys)
		end
	end

	return v44.keys
end

t1.ObjectCanon = t2
t1.canonicalStringify = Object.assign(setmetatable({}, {
	__call = function(_, p13) -- line: 301
		-- upvalues: isNonNullObject (copy), u17 (ref), resetCanonicalStringify (ref), u18 (ref), sortedEncode (copy), HttpService (copy)
		if isNonNullObject(p13) then
			if u17 == nil then
				resetCanonicalStringify()
			end

			local v48 = u17:admit(p13)
			local v49 = u18:get(v48)

			if v49 == nil then
				local v50 = u18

				v49 = sortedEncode(v48)
				v50:set(v48, v49)
			end

			return v49
		end

		return HttpService:JSONEncode(p13)
	end
}), {
	reset = function(_) -- line: 323
		-- upvalues: resetCanonicalStringify (ref)
		return resetCanonicalStringify()
	end
})

function resetCanonicalStringify() -- line: 330
	-- upvalues: u17 (ref), t2 (copy), u18 (ref), WeakMap (copy)
	u17 = t2.new()
	u18 = WeakMap.new()
end

return t1
