local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local isCallable = require(parent.luaUtils.isCallable)
local objectKeysForEach = require(parent.luaUtils.objectKeysForEach)

local optimism = require(parent.optimism)
local dep = optimism.dep

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

local equal = require(parent.jsutils.equal)

local trie = require(parent.wry.trie)
local trie2 = trie.Trie

local utilities = require(script.Parent.Parent.Parent.utilities)
local isReference = utilities.isReference

local makeReference = utilities.makeReference
local deepMerger = utilities.DeepMerger
local maybeDeepFreeze = utilities.maybeDeepFreeze
local canUseWeakMap = utilities.canUseWeakMap
local isNonNullObject = utilities.isNonNullObject

require(script.Parent.types)

local helpers = require(script.Parent.helpers)
local hasOwn = helpers.hasOwn
local fieldNameFromStoreName = helpers.fieldNameFromStoreName

require(script.Parent.policies)

require(script.Parent.Parent.core.types.Cache)

require(script.Parent.Parent.core.types.common)

local delete = {}

local function delModifier()
	return delete
end

local invalidate = {}

local v = nil
local v2 = nil
local makeDepKey
local storeObjectReconciler
local supportsResultCaching

local class = {}
class.__index = class

function class.new(policies, group)
	local object = setmetatable({}, class)
	object.policies = policies
	object.group = group
	object.data = {}

	object.rootIds = {}

	object.refs = {}

	function object:getFieldValue(p, p2: string)
		local v3

		if isReference(p) then
			v3 = object:get(p.__ref, p2)
		else
			v3 = p and p[p2]
		end

		return (maybeDeepFreeze(v3))
	end

	function object.canRead(_, p)
		if isReference(p) then
			return object:has(p.__ref)
		end

		return typeof(p) == "table"
	end

	function object.toReference(_, value, p)
		if type(value) == "string" then
			return makeReference(value)
		end

		if isReference(value) then
			return value
		end

		local v3 = table.unpack(object.policies:identify(value), 1, 1)

		if not v3 then
			return
		end

		local reference = makeReference(v3)

		if p then
			object:merge(v3, value)
		end

		return reference
	end

	return object
end

function class:addLayer(_: string, _)
	error("not implemented abstract method")
end

function class:removeLayer(_: string)
	error("not implemented abstract method")
end

function class:toObject()
	return table.clone(self.data)
end

function class:has(p: string): boolean
	return self:lookup(p, true) ~= nil
end

function class:get(p: string, p2: string)
	self.group:depend(p, p2)

	if hasOwn(self.data, p) then
		local v3 = self.data[p]

		if Boolean.toJSBoolean(v3) and hasOwn(v3, p2) then
			return v3[p2]
		end
	end

	if p2 == "__typename" and hasOwn(self.policies.rootTypenamesById, p) then
		return self.policies.rootTypenamesById[p]
	end

	if instanceof(self, v) then
		return self.parent:get(p, p2)
	end

	return nil
end

function class.lookup(data, p: string, flag: boolean?)
	if flag then
		data.group:depend(p, "__exists")
	end

	if hasOwn(data.data, p) then
		return data.data[p]
	end

	if instanceof(data, v) then
		return data.parent:lookup(p, flag)
	end

	if data.policies.rootTypenamesById[p] then
		return {}
	end

	return nil
end

function class:merge(value, value2)
	local v3 = nil

	if isReference(value) then
		value = value.__ref
	end

	if isReference(value2) then
		value2 = value2.__ref
	end

	if type(value) == "string" then
		v3 = value
		value = self:lookup(v3)
	end

	if type(value2) == "string" then
		v3 = value2
		value2 = self:lookup(v3)
	end

	if not value2 then
		return
	end

	invariant2(typeof(v3) == "string", "store.merge expects a string ID")

	local merged = deepMerger.new(storeObjectReconciler):merge(value, value2)

	self.data[v3] = merged

	if merged ~= value then
		self.refs[v3] = nil

		if self.group.caching then
			local v4 = {}

			if not value then
				v4.__exists = 1
			end

			objectKeysForEach(value2, function(p)
				if not value or value[p] ~= merged[p] then
					v4[p] = 1

					local v5 = fieldNameFromStoreName(p)

					if v5 ~= p and not self.policies:hasKeyArgs(merged.__typename, v5) then
						v4[v5] = 1
					end

					if merged[p] == nil and not instanceof(self, v) then
						merged[p] = nil
					end
				end
			end)

			if
				v4.__typename
				and not (value and value.__typename)
				and self.policies.rootTypenamesById[v3] == merged.__typename
			then
				v4.__typename = nil
			end

			objectKeysForEach(v4, function(p)
				return self.group:dirty(v3, p)
			end)
		end
	end
end

function class:modify(p: string, p2): boolean
	local lookup = self:lookup(p)

	if not lookup then
		return false
	end

	local v3 = {}
	local flag = false
	local flag2 = true

	local v4 = {
		DELETE = delete,
		INVALIDATE = invalidate,
		isReference = function(_, ...)
			return isReference(...)
		end,
		toReference = self.toReference,
		canRead = self.canRead,
		readField = function(_, fieldName, p3)
			return self.policies:readField(typeof(fieldName) == "string" and ({
				fieldName = fieldName,
				from = p3 or makeReference(p)
			} or fieldName) or fieldName, { store = self })
		end
	}

	objectKeysForEach(lookup, function(storeFieldName)
		local fieldName = fieldNameFromStoreName(storeFieldName)
		local v5 = lookup[storeFieldName]

		if v5 == nil then
			return
		end

		local v6

		if isCallable(p2) then
			v6 = p2
		else
			local v7 = p2

			v6 = v7[storeFieldName] or v7[fieldName]
		end

		if v6 then
			local v7

			if v6 == delModifier then
				v7 = delete
			else
				local v8

				if not isCallable(p2) then
					v8 = p2 or nil
				end

				v7 = v6(
					v8,
					maybeDeepFreeze(v5),
					Object.assign(table.clone(v4), {
						fieldName = fieldName,
						storeFieldName = storeFieldName,
						storage = self:getStorage(p, storeFieldName)
					})
				)
			end

			if v7 == invalidate then
				self.group:dirty(p, storeFieldName)
			else
				if v7 == delete then
					v7 = deepMerger.None
				end

				if v7 ~= v5 then
					v3[storeFieldName] = v7
					flag = true
					v5 = v7
				end
			end
		end

		if v5 ~= nil and v5 ~= deepMerger.None then
			flag2 = false
		end
	end)

	if not flag then
		return false
	end

	self:merge(p, v3)

	if flag2 then
		if instanceof(self, v) then
		end

		self.data[p] = nil

		self.group:dirty(p, "__exists")
	end

	return true
end

function class:delete(p: string, fieldName: string?, args)
	local lookup = self:lookup(p)

	if not lookup then
		return false
	end

	local fieldValue = self:getFieldValue(lookup, "__typename")

	if fieldName and args then
		fieldName = self.policies:getStoreFieldName({
			typename = fieldValue,
			fieldName = fieldName,
			args = args
		})
	end

	local v3

	if fieldName then
		v3 = { [fieldName] = delModifier }
	else
		v3 = delModifier
	end

	return self:modify(p, v3)
end

function class:evict(data)
	local v3 = false

	if not data.id then
		return false
	end

	if hasOwn(self.data, data.id) then
		v3 = self:delete(data.id, data.fieldName, data.args)
	end

	v3 = instanceof(self, v) and self.parent:evict(data) or v3

	if data.fieldName or v3 then
		self.group:dirty(data.id, data.fieldName or "__exists")
	end

	return v3
end

function class:clear()
	self:replace(nil)
end

function class:extract()
	local object = self:toObject()
	local v3 = {}
	self:getRootIdSet():forEach(function(p)
		if not hasOwn(self.policies.rootTypenamesById, p) then
			table.insert(v3, p)
		end
	end)

	if #v3 > 0 then
		object.__META = { extraRootIds = Array.sort(v3) }
	end

	return object
end

function class:replace(p)
	objectKeysForEach(self.data, function(p2)
		if not (p and hasOwn(p, p2)) then
			self:delete(p2)
		end
	end)

	if p ~= nil then
		local __meta = p.__META
		local v3 = Object.assign(table.clone(p), { __META = Object.None })

		objectKeysForEach(v3, function(p2)
			self:merge(p2, v3[p2])
		end)

		if __meta ~= nil then
			Array.forEach(__meta.extraRootIds, self.retain, self)
		end
	end
end

function class:getStorage(_, ...)
	error("not implemented abstract method")
end

function class.retain(p, p2: string)
	p.rootIds[p2] = (not Boolean.toJSBoolean(p.rootIds[p2]) and 0 or p.rootIds[p2]) + 1

	return p.rootIds[p2]
end

function class.release(p, p2: string)
	if not (p.rootIds[p2] > 0) then
		return 0
	end

	p.rootIds[p2] -= 1

	local rootId = p.rootIds[p2]

	if not Boolean.toJSBoolean(rootId) then
		p.rootIds[p2] = nil
	end

	return rootId
end

function class:getRootIdSet(p)
	if p == nil then
		p = Set.new()
	end

	Array.forEach(Object.keys(self.rootIds), p.add, p)

	if instanceof(self, v) then
		self.parent:getRootIdSet(p)
		return p
	end

	Array.forEach(Object.keys(self.policies.rootTypenamesById), p.add, p)

	return p
end

function class.gc(object)
	local rootIdSet = object:getRootIdSet()
	local object2 = object:toObject()

	for _, v3 in rootIdSet do
		if not hasOwn(object2, v3) then
			continue
		end

		Array.forEach(Object.keys(object:findChildRefIds(v3)), rootIdSet.add, rootIdSet)

		object2[v3] = nil
	end

	local keys = Object.keys(object2)

	if Boolean.toJSBoolean(#keys) then
		while instanceof(object, v) do
			object = object.parent
		end

		Array.forEach(keys, function(p)
			return object:delete(p)
		end)
	end

	return keys
end

function class.findChildRefIds(p, p2: string)
	if hasOwn(p.refs, p2) then
		return p.refs[p2]
	end

	p.refs[p2] = {}
	local ref = p.refs[p2]
	local v3 = p.data[p2]

	if not v3 then
		return ref
	end

	local v4 = Set.new({ v3 })

	for _, v5 in v4 do
		if isReference(v5) then
			ref[v5.__ref] = true
		end

		if isNonNullObject(v5) then
			objectKeysForEach(v5, function(p3)
				local v6 = v5[p3]

				if isNonNullObject(v6) then
					v4:add(v6)
				end
			end)
		end
	end

	return p.refs[p2]
end

function class.makeCacheKey(p, ...)
	return p.group.keyMaker:lookupArray({ ... })
end

local EntityStore = {}
EntityStore.EntityStore = class
local class2 = {}
class2.__index = class2
function class2.new(caching: boolean, parent3)
	local self = setmetatable({}, class2)
	self.caching = caching
	self.parent = parent3
	self.d = nil
	self:resetCaching()
	return self
end

function class2:resetCaching()
	local v3

	if self.caching then
		v3 = dep()
	end

	self.d = v3

	self.keyMaker = trie2.new(canUseWeakMap)
end

function class2:depend(p: string, p2: string)
	if self.d then
		self.d(makeDepKey(p, p2))
		local v3 = fieldNameFromStoreName(p2)

		if v3 ~= p2 then
			self.d(makeDepKey(p, v3))
		end

		if self.parent then
			self.parent:depend(p, p2)
		end
	end
end

function class2:dirty(p: string, p2: string)
	if self.d then
		self.d:dirty(makeDepKey(p, p2), p2 == "__exists" and "forget" or "setDirty")
	end
end

makeDepKey = function(p: string, p2: string)
	return p2 .. "#" .. p
end

function EntityStore.maybeDependOnExistenceOfEntity(p, p2: string)
	if supportsResultCaching(p) then
		p.group:depend(p2, "__exists")
	end
end

local object = setmetatable({}, { __index = class })
object.__index = object

function object.new(data)
	local policies = data.policies
	local resultCaching = data.resultCaching
	local seed = data.seed
	local v3 = data.resultCaching == nil or resultCaching

	local object2 = setmetatable(class.new(policies, class2.new(v3)), object)

	object2.stump = v2.new(object2)
	object2.storageTrie = trie2.new(canUseWeakMap)

	if seed then
		object2:replace(seed)
	end

	return object2
end

function object:addLayer(p: string, callback)
	return self.stump:addLayer(p, callback)
end

function object:removeLayer()
	return self
end

function object:getStorage(...)
	return self.storageTrie:lookupArray({ ... })
end

EntityStore.EntityStore_Root = object

v = setmetatable({}, { __index = class })
v.__index = v

function v.new(id: string, parent3, replay, group)
	local self = setmetatable(class.new(parent3.policies, group), v)
	self.id = id
	self.parent = parent3
	self.replay = replay
	self.group = group
	replay(self, self)
	return self
end

function v:addLayer(p: string, callback)
	return v.new(p, self, callback, self.group)
end

function v:removeLayer(p: string)
	local v3 = self.parent:removeLayer(p)

	if p == self.id then
		if self.group.caching then
			objectKeysForEach(self.data, function(p2)
				local v4 = self.data[p2]
				local lookup = v3.lookup(v3, p2)

				if not lookup then
					self:delete(p2)
				elseif v4 then
					if v4 ~= lookup then
						objectKeysForEach(v4, function(p3)
							if not equal(v4[p3], lookup[p3]) then
								self.group:dirty(p2, p3)
							end
						end)
					end
				else
					self.group:dirty(p2, "__exists")

					objectKeysForEach(lookup, function(p3)
						self.group:dirty(p2, p3)
					end)
				end
			end)
		end

		return v3
	elseif v3 == self.parent then
		return self
	else
		return v3:addLayer(self.id, self.replay)
	end
end

function v:toObject()
	return Object.assign({}, self.parent:toObject(), self.data)
end

function v.findChildRefIds(p, p2: string)
	local childRefIds = p.parent:findChildRefIds(p2)
	local __index = getmetatable((getmetatable(p))).__index

	return hasOwn(p.data, p2) and Object.assign({}, childRefIds, __index.findChildRefIds(p, p2)) or childRefIds
end

function v:getStorage(...)
	local parent3 = self.parent

	while parent3.parent do
		parent3 = parent3.parent
	end

	return parent3:getStorage(...)
end

v2 = setmetatable({}, { __index = v })
v2.__index = v2

function v2.new(p)
	return (setmetatable(v.new("EntityStore.Stump", p, function() end, class2.new(p.group.caching, p.group)), v2))
end

function v2:removeLayer()
	return self
end

function v2:merge(...)
	return self.parent:merge(...)
end

storeObjectReconciler = function(_, p, p2, p3: string)
	local v3 = p[p3]
	local v4 = p2[p3]

	return if equal(v3, v4) then v3 else v4
end

supportsResultCaching = function(p): boolean
	return type(p) == "table" and type(p.group) == "table" and p.group.caching == true
end

EntityStore.supportsResultCaching = supportsResultCaching

return EntityStore
