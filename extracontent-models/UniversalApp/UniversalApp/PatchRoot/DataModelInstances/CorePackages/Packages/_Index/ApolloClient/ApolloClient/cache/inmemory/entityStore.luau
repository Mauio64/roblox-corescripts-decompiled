local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local isCallable = require(ParentParent.luaUtils.isCallable)
local objectKeysForEach = require(ParentParent.luaUtils.objectKeysForEach)
local dep = require(ParentParent.optimism).dep
local invariant = require(ParentParent.jsutils.invariant).invariant
local equal = require(ParentParent.jsutils.equal)
local Trie = require(ParentParent.wry.trie).Trie
local utilities = require(script.Parent.Parent.Parent.utilities)
local isReference = utilities.isReference
local makeReference = utilities.makeReference
local DeepMerger = utilities.DeepMerger
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

local t2 = {}

local function delModifier() -- line: 80
	-- upvalues: t2 (copy)
	return t2
end

local t3 = {}
local self = nil
local self2 = nil
local makeDepKey = nil
local storeObjectReconciler = nil
local supportsResultCaching = nil
local t4 = {}

t4.__index = t4

function t4.new(p1, t5: {[any]: any}) -- line: 136
	-- upvalues: t4 (copy), maybeDeepFreeze (copy), isReference (copy), makeReference (copy)
	local self3 = setmetatable({}, t4)

	self3.policies = p1
	self3.group = t5
	self3.data = {}
	self3.rootIds = {}
	self3.refs = {}

	function self3.getFieldValue(_: {[any]: any}, p2, s1: string) -- line: 152
		-- upvalues: maybeDeepFreeze (copy), isReference (copy), self3 (copy)
		return (maybeDeepFreeze(if not isReference(p2) then p2 and p2[s1] else self3:get(p2.__ref, s1)))
	end
	function self3.canRead(_: {[any]: any}, p3) -- line: 169
		-- upvalues: isReference (copy), self3 (copy)
		if isReference(p3) then
			return self3:has(p3.__ref)
		end

		return typeof(p3) == "table"
	end
	function self3.toReference(_: {[any]: any}, p4, p5) -- line: 181
		-- upvalues: makeReference (copy), isReference (copy), self3 (copy)
		if type(p4) == "string" then
			return makeReference(p4)
		end

		if isReference(p4) then
			return p4
		end

		local v174 = table.unpack(self3.policies:identify(p4), 1, 1)

		if v174 then
			local v175 = makeReference(v174)

			if p5 then
				self3:merge(v174, p4)
			end

			return v175
		end
	end

	return self3
end
function t4.addLayer(_: {[any]: any}, _: string, _: ((...any) -> ...any)) -- line: 211
	error("not implemented abstract method")
end
function t4.removeLayer(_: {[any]: any}, _: string) -- line: 215
	error("not implemented abstract method")
end
function t4.toObject(p7) -- line: 223
	return table.clone(p7.data)
end
function t4.has(t11: {[any]: any}, s4: string) -- line: 229
	return t11:lookup(s4, true) ~= nil
end
function t4.get(t12: {[any]: any}, s5: string, s6: string) -- line: 233
	-- upvalues: hasOwn (copy), Boolean (copy), instanceof (copy), self (ref)
	t12.group:depend(s5, s6)

	if hasOwn(t12.data, s5) then
		local v51 = t12.data[s5]

		if Boolean.toJSBoolean(v51) and hasOwn(v51, s6) then
			return v51[s6]
		end
	end

	if s6 == "__typename" and hasOwn(t12.policies.rootTypenamesById, s5) then
		return t12.policies.rootTypenamesById[s5]
	end

	if instanceof(t12, self) then
		return t12.parent:get(s5, s6)
	end

	return nil
end
function t4.lookup(t13: {[any]: any}, s7: string, b1: boolean?) -- line: 252
	-- upvalues: hasOwn (copy), instanceof (copy), self (ref)
	if b1 then
		t13.group:depend(s7, "__exists")
	end

	if hasOwn(t13.data, s7) then
		return t13.data[s7]
	end

	if instanceof(t13, self) then
		return t13.parent:lookup(s7, b1)
	end

	if t13.policies.rootTypenamesById[s7] then
		return {}
	end

	return nil
end
function t4.merge(p8, p9, p10) -- line: 281
	-- upvalues: isReference (copy), invariant (copy), DeepMerger (copy), storeObjectReconciler (ref), objectKeysForEach (copy), fieldNameFromStoreName (copy), instanceof (copy), self (ref)
	local u58 = nil

	if isReference(p9) then
		p9 = p9.__ref
	end

	if isReference(p10) then
		p10 = p10.__ref
	end

	local u59

	if type(p9) == "string" then
		u58 = p9
		u59 = p8:lookup(u58)
	else
		u59 = p9
	end

	if type(p10) == "string" then
		u58 = p10
		p10 = p8:lookup(u58)
	end

	if not p10 then
		return
	end

	invariant(typeof(u58) == "string", "store.merge expects a string ID")

	local v60 = DeepMerger.new(storeObjectReconciler):merge(u59, p10)

	p8.data[u58] = v60

	if v60 ~= u59 then
		p8.refs[u58] = nil

		if p8.group.caching then
			local t14 = {}

			if not u59 then
				t14.__exists = 1
			end

			objectKeysForEach(p10, function(p11) -- line: 350
				-- upvalues: u59 (ref), v60 (copy), t14 (copy), fieldNameFromStoreName (copy), p8 (copy), instanceof (copy), self (ref)
				if not u59 or u59[p11] ~= v60[p11] then
					t14[p11] = 1

					local v177 = fieldNameFromStoreName(p11)

					if v177 ~= p11 and not p8.policies:hasKeyArgs(v60.__typename, v177) then
						t14[v177] = 1
					end

					if v60[p11] == nil and not instanceof(p8, self) then
						v60[p11] = nil
					end
				end
			end)

			if t14.__typename and ((not u59 or not u59.__typename) and p8.policies.rootTypenamesById[u58] == v60.__typename) then
				t14.__typename = nil
			end

			objectKeysForEach(t14, function(p12) -- line: 397
				-- upvalues: p8 (copy), u58 (ref)
				return p8.group:dirty(u58, p12)
			end)
		end
	end
end
function t4.modify(t15: {[any]: any}, s8: string, p13) -- line: 405
	-- upvalues: t2 (copy), t3 (copy), isReference (copy), makeReference (copy), objectKeysForEach (copy), fieldNameFromStoreName (copy), isCallable (copy), delModifier (ref), maybeDeepFreeze (copy), Object (copy), DeepMerger (copy), instanceof (copy), self (ref)
	local v65 = t15:lookup(s8)

	if v65 then
		local t16 = {}
		local u67 = false
		local u68 = true
		local t17 = {
			DELETE = t2,
			INVALIDATE = t3,
			isReference = function(_, ...) -- line: 418
				-- upvalues: isReference (copy)
				return isReference(...)
			end,
			toReference = t15.toReference,
			canRead = t15.canRead,
			readField = function(_, p16, p17) -- line: 423
				-- upvalues: t15 (copy), makeReference (copy), s8 (copy)
				return t15.policies:readField(typeof(p16) == "string" and {
					fieldName = p16,
					from = p17 or makeReference(s8)
				} or p16, {
					store = t15
				})
			end
		}

		objectKeysForEach(v65, function(p18) -- line: 440
			-- upvalues: fieldNameFromStoreName (copy), v65 (copy), isCallable (copy), p13 (copy), delModifier (ref), t2 (copy), maybeDeepFreeze (copy), Object (copy), t17 (copy), t15 (copy), s8 (copy), t3 (copy), DeepMerger (copy), t16 (copy), u67 (ref), u68 (ref)
			local v184 = fieldNameFromStoreName(p18)
			local v185 = v65[p18]

			if v185 == nil then
				return
			end

			local v186

			if isCallable(p13) then
				v186 = p13
			else
				local v187 = p13

				v186 = v187[p18] or v187[v184]
			end

			if v186 then
				local v188 = if v186 ~= delModifier then v186(not isCallable(p13) and p13 or nil, maybeDeepFreeze(v185), Object.assign(table.clone(t17), {
					fieldName = v184,
					storeFieldName = p18,
					storage = t15:getStorage(s8, p18)
				})) else t2

				if v188 == t3 then
					t15.group:dirty(s8, p18)
				else
					if v188 == t2 then
						v188 = DeepMerger.None
					end

					if v188 ~= v185 then
						t16[p18] = v188
						u67 = true
						v185 = v188
					end
				end
			end

			if v185 ~= nil and v185 ~= DeepMerger.None then
				u68 = false
			end
		end)

		if u67 then
			t15:merge(s8, t16)

			if u68 then
				if instanceof(t15, self) then
					t15.data[s8] = nil
				else
					t15.data[s8] = nil
				end

				t15.group:dirty(s8, "__exists")
			end

			return true
		end
	end

	return false
end
function t4.delete(t18: {[any]: any}, s9: string, s10: string?, t19: {[any]: any}?) -- line: 520
	-- upvalues: delModifier (ref)
	local v74 = t18:lookup(s9)

	if v74 then
		local v75 = t18:getFieldValue(v74, "__typename")
		local v76 = if not s10 or not t19 then s10 else t18.policies:getStoreFieldName({
			typename = v75,
			fieldName = s10,
			args = t19
		})

		return t18:modify(s9, if not v76 then delModifier else {
			[v76] = delModifier
		})
	end

	return false
end
function t4.evict(p19, p20) -- line: 547
	-- upvalues: hasOwn (copy), instanceof (copy), self (ref)
	local v79 = false

	if p20.id then
		if hasOwn(p19.data, p20.id) then
			v79 = p19:delete(p20.id, p20.fieldName, p20.args)
		end

		if instanceof(p19, self) then
			v79 = p19.parent:evict(p20) or v79
		end

		if p20.fieldName or v79 then
			p19.group:dirty(p20.id, p20.fieldName or "__exists")
		end
	end

	return v79
end
function t4.clear(p21) -- line: 575
	p21:replace(nil)
end
function t4.extract(p22) -- line: 579
	-- upvalues: hasOwn (copy), Array (copy)
	local v82 = p22:toObject()
	local t20 = {}

	p22:getRootIdSet():forEach(function(p23) -- line: 582
		-- upvalues: hasOwn (copy), p22 (copy), t20 (copy)
		if not hasOwn(p22.policies.rootTypenamesById, p23) then
			table.insert(t20, p23)
		end
	end)

	if #t20 > 0 then
		v82.__META = {
			extraRootIds = Array.sort(t20)
		}
	end

	return v82
end
function t4.replace(p24, p25) -- line: 595
	-- upvalues: objectKeysForEach (copy), hasOwn (copy), Object (copy), Array (copy)
	objectKeysForEach(p24.data, function(p26) -- line: 597
		-- upvalues: p25 (copy), hasOwn (copy), p24 (copy)
		if not p25 or not hasOwn(p25, p26) then
			p24:delete(p26)
		end
	end)

	if p25 ~= nil then
		local __META = p25.__META
		local v87 = Object.assign(table.clone(p25), {
			__META = Object.None
		})

		objectKeysForEach(v87, function(p27) -- line: 613
			-- upvalues: p24 (copy), v87 (copy)
			p24:merge(p27, v87[p27])
		end)

		if __META ~= nil then
			Array.forEach(__META.extraRootIds, p24.retain, p24)
		end
	end
end
function t4.getStorage(_, _, ...) -- line: 626
	error("not implemented abstract method")
end
function t4.retain(t21: {[any]: any}, s11: string) -- line: 630
	-- upvalues: Boolean (copy)
	t21.rootIds[s11] = (not Boolean.toJSBoolean(t21.rootIds[s11]) and 0 or t21.rootIds[s11]) + 1

	return t21.rootIds[s11]
end
function t4.release(t22: {[any]: any}, s12: string) -- line: 637
	-- upvalues: Boolean (copy)
	if t22.rootIds[s12] > 0 then
		local rootIds = t22.rootIds

		rootIds[s12] = rootIds[s12] - 1

		local v95 = t22.rootIds[s12]

		if not Boolean.toJSBoolean(v95) then
			t22.rootIds[s12] = nil
		end

		return v95
	end

	return 0
end
function t4.getRootIdSet(p30, p31) -- line: 654
	-- upvalues: Set (copy), Array (copy), Object (copy), instanceof (copy), self (ref)
	if p31 == nil then
		p31 = Set.new()
	end

	Array.forEach(Object.keys(p30.rootIds), p31.add, p31)

	if instanceof(p30, self) then
		p30.parent:getRootIdSet(p31)

		return p31
	end

	Array.forEach(Object.keys(p30.policies.rootTypenamesById), p31.add, p31)

	return p31
end
function t4.gc(p32) -- line: 675
	-- upvalues: hasOwn (copy), Array (copy), Object (copy), Boolean (copy), instanceof (copy), self (ref)
	local v99 = p32:getRootIdSet()
	local v100 = p32:toObject()

	for _, v102 in v99 do
		if hasOwn(v100, v102) then
			Array.forEach(Object.keys(p32:findChildRefIds(v102)), v99.add, v99)
			v100[v102] = nil
		end
	end

	local v103 = Object.keys(v100)

	if Boolean.toJSBoolean(#v103) then
		local u104 = p32

		while instanceof(u104, self) do
			u104 = u104.parent
		end

		Array.forEach(v103, function(p33) -- line: 700
			-- upvalues: u104 (ref)
			return u104:delete(p33)
		end)
	end

	return v103
end
function t4.findChildRefIds(t23: {[any]: any}, s13: string) -- line: 707
	-- upvalues: hasOwn (copy), Set (copy), isReference (copy), isNonNullObject (copy), objectKeysForEach (copy)
	if not hasOwn(t23.refs, s13) then
		t23.refs[s13] = {}

		local v107 = t23.refs[s13]
		local v108 = t23.data[s13]

		if not v108 then
			return v107
		end

		local v109 = Set.new({ v108 })

		for _, v111 in v109 do
			if isReference(v111) then
				v107[v111.__ref] = true
			end

			if isNonNullObject(v111) then
				objectKeysForEach(v111, function(p34) -- line: 736
					-- upvalues: v111 (copy), isNonNullObject (copy), v109 (copy)
					local v194 = v111[p34]

					if isNonNullObject(v194) then
						v109:add(v194)
					end
				end)
			end
		end
	end

	return t23.refs[s13]
end
function t4.makeCacheKey(p35, ...) -- line: 753
	return p35.group.keyMaker:lookupArray({ ... })
end

t1.EntityStore = t4

local t24 = {}

t24.__index = t24

function t24.new(b2: boolean, t25: {[any]: any}?) -- line: 784
	-- upvalues: t24 (copy)
	local self4 = setmetatable({}, t24)

	self4.caching = b2
	self4.parent = t25
	self4.d = nil
	self4:resetCaching()

	return self4
end
function t24.resetCaching(p36) -- line: 793
	-- upvalues: dep (copy), Trie (copy), canUseWeakMap (copy)
	p36.d = if not p36.caching then nil else dep()
	p36.keyMaker = Trie.new(canUseWeakMap)
end
function t24.depend(t26: {[any]: any}, s14: string, s15: string) -- line: 800
	-- upvalues: makeDepKey (ref), fieldNameFromStoreName (copy)
	if t26.d then
		t26.d(makeDepKey(s14, s15))

		local v120 = fieldNameFromStoreName(s15)

		if v120 ~= s15 then
			t26.d(makeDepKey(s14, v120))
		end

		if t26.parent then
			t26.parent:depend(s14, s15)
		end
	end
end
function t24.dirty(t27: {[any]: any}, s16: string, s17: string) -- line: 822
	-- upvalues: makeDepKey (ref)
	if t27.d then
		t27.d:dirty(makeDepKey(s16, s17), s17 ~= "__exists" and "setDirty" or "forget")
	end
end
function makeDepKey(s18: string, s19: string) -- line: 840
	return s19 .. "#" .. s18
end
function t1.maybeDependOnExistenceOfEntity(p37, s20: string) -- line: 847
	-- upvalues: supportsResultCaching (ref)
	if supportsResultCaching(p37) then
		p37.group:depend(s20, "__exists")
	end
end

local self5 = setmetatable({}, {
	__index = t4
})

self5.__index = self5

function self5.new(t28: {[any]: any}) -- line: 872
	-- upvalues: t4 (copy), t24 (copy), self5 (copy), self2 (ref), Trie (copy), canUseWeakMap (copy)
	local policies = t28.policies
	local resultCaching = t28.resultCaching
	local seed = t28.seed

	if t28.resultCaching == nil then
		resultCaching = true
	end

	local v132 = setmetatable(t4.new(policies, t24.new(resultCaching)), self5)

	v132.stump = self2.new(v132)
	v132.storageTrie = Trie.new(canUseWeakMap)

	if seed then
		v132:replace(seed)
	end

	return v132
end
function self5.addLayer(t29: {[any]: any}, s21: string, p38: ((...any) -> ...any)) -- line: 896
	return t29.stump:addLayer(s21, p38)
end
function self5.removeLayer(p39) -- line: 903
	return p39
end
function self5.getStorage(p40, ...) -- line: 908
	return p40.storageTrie:lookupArray({ ... })
end

t1.EntityStore_Root = self5
self = setmetatable({}, {
	__index = t4
})
self.__index = self

function self.new(s22: string, t30: {[any]: any}, p41: ((...any) -> ...any), t31: {[any]: any}) -- line: 930
	-- upvalues: t4 (copy), self (ref)
	local v142 = setmetatable(t4.new(t30.policies, t31), self)

	v142.id = s22
	v142.parent = t30
	v142.replay = p41
	v142.group = t31
	p41(v142, v142)

	return v142
end
function self.addLayer(t32: {[any]: any}, s23: string, p42: ((...any) -> ...any)) -- line: 945
	-- upvalues: self (ref)
	return self.new(s23, t32, p42, t32.group)
end
function self.removeLayer(t33: {[any]: any}, s24: string) -- line: 949
	-- upvalues: objectKeysForEach (copy), equal (copy)
	local v148 = t33.parent:removeLayer(s24)

	if s24 == t33.id then
		if t33.group.caching then
			objectKeysForEach(t33.data, function(p43) -- line: 960
				-- upvalues: t33 (copy), v148 (copy), objectKeysForEach (copy), equal (copy)
				local v196 = t33.data[p43]
				local v197 = v148.lookup(v148, p43)

				if not v197 then
					t33:delete(p43)

					return
				end

				if not v196 then
					t33.group:dirty(p43, "__exists")
					objectKeysForEach(v197, function(p44) -- line: 982
						-- upvalues: t33 (copy), p43 (copy)
						t33.group:dirty(p43, p44)
					end)

					return
				end

				if v196 ~= v197 then
					objectKeysForEach(v196, function(p45) -- line: 991
						-- upvalues: equal (copy), v196 (copy), v197 (copy), t33 (copy), p43 (copy)
						if not equal(v196[p45], v197[p45]) then
							t33.group:dirty(p43, p45)
						end
					end)
				end
			end)
		end

		return v148
	end

	if v148 == t33.parent then
		return t33
	end

	return v148:addLayer(t33.id, t33.replay)
end
function self.toObject(p46) -- line: 1012
	-- upvalues: Object (copy)
	return Object.assign({}, p46.parent:toObject(), p46.data)
end
function self.findChildRefIds(t34: {[any]: any}, s25: string) -- line: 1016
	-- upvalues: hasOwn (copy), Object (copy)
	local v152 = t34.parent:findChildRefIds(s25)
	local __index = getmetatable((getmetatable(t34))).__index

	return hasOwn(t34.data, s25) and Object.assign({}, v152, __index.findChildRefIds(t34, s25)) or v152
end
function self.getStorage(p47, ...) -- line: 1025
	local parent = p47.parent

	while parent.parent do
		parent = parent.parent
	end

	return parent:getStorage(...)
end

self2 = setmetatable({}, {
	__index = self
})
self2.__index = self2

function self2.new(p48) -- line: 1041
	-- upvalues: self (ref), t24 (copy), self2 (ref)
	return (setmetatable(self.new("EntityStore.Stump", p48, function() -- line: 1042
	end, t24.new(p48.group.caching, p48.group)), self2))
end
function self2.removeLayer(p49) -- line: 1047
	return p49
end
function self2.merge(p50, ...) -- line: 1052
	return p50.parent:merge(...)
end
function storeObjectReconciler(_, p52, p53, s26: string) -- line: 1061
	-- upvalues: equal (copy)
	local v163 = p52[s26]
	local v164 = p53[s26]

	if equal(v163, v164) then
		return v163
	end

	return v164
end
function supportsResultCaching(p54) -- line: 1081
	return type(p54) == "table" and (type(p54.group) == "table" and p54.group.caching == true)
end

t1.supportsResultCaching = supportsResultCaching

return t1
