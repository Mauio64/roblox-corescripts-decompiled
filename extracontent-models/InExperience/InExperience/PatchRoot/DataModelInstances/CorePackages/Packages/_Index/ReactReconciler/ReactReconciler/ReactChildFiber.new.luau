local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local console = require(ParentParent.Shared).console
local describeError = require(ParentParent.Shared).describeError
local __DEV__ = ReactGlobals.__DEV__
local v9 = require(ParentParent.SafeFlags).createGetFFlag("ReactPreventAssigningKeyToChildren")()

require(ParentParent.Shared)
require(ParentParent.React)
require(script.Parent.ReactInternalTypes)
require(script.Parent.ReactFiberLane)

local getComponentName = require(ParentParent.Shared).getComponentName
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Placement = ReactFiberFlags.Placement
local Deletion = ReactFiberFlags.Deletion
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local _ = ReactWorkTags.FunctionComponent
local _ = ReactWorkTags.ClassComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local _ = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local _ = ReactWorkTags.SimpleMemoComponent
local Block = ReactWorkTags.Block
local invariant = require(ParentParent.Shared).invariant
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableLazyElements = ReactFeatureFlags.enableLazyElements
local enableBlocksAPI = ReactFeatureFlags.enableBlocksAPI
local lib = require(script.Parent["ReactFiber.new"])
local createWorkInProgress = lib.createWorkInProgress
local resetWorkInProgress = lib.resetWorkInProgress
local createFiberFromElement = lib.createFiberFromElement
local createFiberFromFragment = lib.createFiberFromFragment
local createFiberFromText = lib.createFiberFromText
local createFiberFromPortal = lib.createFiberFromPortal
local isCompatibleFamilyForHotReloading = require(script.Parent["ReactFiberHotReloading.new"]).isCompatibleFamilyForHotReloading
local t1 = {}
local u43 = nil
local t2 = nil
local t3 = nil

local function u46(_, _) -- line: 97
end

if __DEV__ then
	u43 = false
	t2 = {}
	t3 = {}

	function u46(p3, p4) -- line: 119
		-- upvalues: invariant (copy), getComponentName (copy), t2 (ref), console (copy)
		if p3 == nil or type(p3) ~= "table" then
			return
		end

		if not p3._store or p3._store.validated or p3.key ~= nil then
			return
		end

		invariant(p3._store ~= nil and type(p3._store) == "table", "React Component in warnForMissingKey should have a _store. This error is likely caused by a bug in React. Please file an issue.")
		p3._store.validated = true

		local v54 = getComponentName(p4.type) or "Component"

		if t2[v54] then
			return
		end

		t2[v54] = true
		console.error("Each child in a list should have a unique \"key\" prop. See https://reactjs.org/link/warning-keys for more information.")
	end
end

local isArray = Array.isArray

function coerceRef(p5, _, p7) -- line: 150
	-- upvalues: __DEV__ (copy), getComponentName (copy), Error (copy)
	local ref = p7.ref

	if ref ~= nil and type(ref) == "string" then
		if not p7._owner or not p7._self or p7._owner.stateNode == p7._self then
			local v59 = not __DEV__ and "<enable __DEV__ mode for component names>" or (getComponentName(p5.type) or "Component")

			error(Error.new(string.format("Component \"%s\" contains the string ref \"%s\". Support for string refs has been removed. We recommend using useRef() or createRef() instead. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-string-ref", v59, (tostring(ref)))))
		end

		if not p7._owner then
			error("Expected ref to be a function or an object returned by React.createRef(), or nil.")
		end
	end

	return ref
end

local function warnOnFunctionType(p8) -- line: 323
	-- upvalues: __DEV__ (copy), getComponentName (copy), t3 (ref), console (copy)
	if __DEV__ then
		local v61 = getComponentName(p8.type) or "Component"

		if t3[v61] then
			return
		end

		t3[v61] = true
		console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
	end
end

function resolveLazyType(p9) -- line: 342
	-- upvalues: describeError (copy)
	local _payload = p9._payload
	local _init = p9._init
	local ok, result = xpcall(_init, describeError, _payload)

	if not ok then
		return p9
	end

	return result
end

local function ChildReconciler(p10) -- line: 360
	-- upvalues: Deletion (copy), createWorkInProgress (copy), Placement (copy), HostText (copy), createFiberFromText (copy), __DEV__ (copy), isCompatibleFamilyForHotReloading (copy), enableBlocksAPI (copy), Block (copy), REACT_LAZY_TYPE (copy), REACT_BLOCK_TYPE (copy), createFiberFromElement (copy), HostPortal (copy), createFiberFromPortal (copy), Fragment (copy), createFiberFromFragment (copy), REACT_ELEMENT_TYPE (copy), REACT_PORTAL_TYPE (copy), enableLazyElements (copy), getComponentName (copy), t3 (ref), console (copy), REACT_FRAGMENT_TYPE (copy), u46 (ref), v9 (copy), u43 (ref), isArray (copy), getIteratorFn (copy)
	local function deleteChild(p11, p12) -- line: 361
		-- upvalues: p10 (copy), Deletion (copy)
		if not p10 then
			return
		end

		local deletions = p11.deletions

		if deletions == nil then
			p11.deletions = { p12 }
			p11.flags = bit32.bor(p11.flags, Deletion)

			return
		end

		table.insert(deletions, p12)
	end
	local function deleteRemainingChildren(p13, p14) -- line: 375
		-- upvalues: p10 (copy), Deletion (copy)
		if not p10 then
			return nil
		end

		while p14 ~= nil do
			if p10 then
				local deletions = p13.deletions

				if deletions == nil then
					p13.deletions = { p14 }
					p13.flags = bit32.bor(p13.flags, Deletion)
				else
					table.insert(deletions, p14)
				end
			end

			p14 = p14.sibling
		end

		return nil
	end
	local function mapRemainingChildren(_, p16) -- line: 394
		local t4 = {}

		while p16 ~= nil do
			if p16.key ~= nil then
				t4[p16.key] = p16
			else
				t4[p16.index] = p16
			end

			p16 = p16.sibling
		end

		return t4
	end
	local function useFiber(p17, p18) -- line: 416
		-- upvalues: createWorkInProgress (copy)
		local v107 = createWorkInProgress(p17, p18)

		v107.index = 1
		v107.sibling = nil

		return v107
	end
	local function placeChild(p19, n1: number, n2: number) -- line: 426
		-- upvalues: p10 (copy), Placement (copy)
		p19.index = n2

		if not p10 then
			return n1
		end

		local alternate = p19.alternate

		if alternate ~= nil then
			local index = alternate.index

			if index < n1 then
				p19.flags = bit32.bor(p19.flags, Placement)

				return n1
			end

			return index
		end

		p19.flags = bit32.bor(p19.flags, Placement)

		return n1
	end
	local function placeSingleChild(p20) -- line: 454
		-- upvalues: p10 (copy), Placement (copy)
		if p10 and p20.alternate == nil then
			p20.flags = bit32.bor(p20.flags, Placement)
		end

		return p20
	end
	local function updateTextNode(p21, p22, s1: string, p23) -- line: 463
		-- upvalues: HostText (copy), createFiberFromText (copy), createWorkInProgress (copy)
		if p22 == nil or p22.tag ~= HostText then
			local v118 = createFiberFromText(s1, p21.mode, p23)

			v118.return_ = p21

			return v118
		end

		local v119 = createWorkInProgress(p22, s1)

		v119.index = 1
		v119.sibling = nil
		v119.return_ = p21

		return v119
	end
	local function updateElement(p24, p25, p26, p27) -- line: 483
		-- upvalues: __DEV__ (copy), isCompatibleFamilyForHotReloading (copy), createWorkInProgress (copy), enableBlocksAPI (copy), Block (copy), REACT_LAZY_TYPE (copy), REACT_BLOCK_TYPE (copy), createFiberFromElement (copy)
		if p25 ~= nil then
			if p25.elementType == p26.type or __DEV__ and isCompatibleFamilyForHotReloading(p25, p26) then
				local props = p26.props
				local v125 = createWorkInProgress(p25, props)

				v125.index = 1
				v125.sibling = nil
				v125.ref = coerceRef(p24, p25, p26)
				v125.return_ = p24

				if __DEV__ then
					v125._debugSource = p26._source
					v125._debugOwner = p26._owner
				end

				return v125
			end

			if enableBlocksAPI and p25.tag == Block then
				local type2 = p26.type

				if type(type2) == "table" and type2["$$typeof"] == REACT_LAZY_TYPE then
					type2 = resolveLazyType(type2)
				end

				if type2["$$typeof"] == REACT_BLOCK_TYPE and type2._render == p25.type._render then
					local props = p26.props
					local v128 = createWorkInProgress(p25, props)

					v128.index = 1
					v128.sibling = nil
					v128.return_ = p24
					v128.type = type2

					if __DEV__ then
						v128._debugSource = p26._source
						v128._debugOwner = p26._owner
					end

					return v128
				end
			end
		end

		local v129 = createFiberFromElement(p26, p24.mode, p27)

		v129.ref = coerceRef(p24, p25, p26)
		v129.return_ = p24

		return v129
	end
	local function updatePortal(p28, p29, p30, p31) -- line: 534
		-- upvalues: HostPortal (copy), createFiberFromPortal (copy), createWorkInProgress (copy)
		if p29 == nil or (p29.tag ~= HostPortal or p29.stateNode.containerInfo ~= p30.containerInfo or p29.stateNode.implementation ~= p30.implementation) then
			local v134 = createFiberFromPortal(p30, p28.mode, p31)

			v134.return_ = p28

			return v134
		end

		local v135 = p30.children or {}
		local v136 = createWorkInProgress(p29, v135)

		v136.index = 1
		v136.sibling = nil
		v136.return_ = p28

		return v136
	end
	local function updateFragment(p32, p33, p34, p35, s2: string?) -- line: 559
		-- upvalues: Fragment (copy), createFiberFromFragment (copy), createWorkInProgress (copy)
		if p33 == nil or p33.tag ~= Fragment then
			local v142 = createFiberFromFragment(p34, p32.mode, p35, s2)

			v142.return_ = p32

			return v142
		end

		local v143 = createWorkInProgress(p33, p34)

		v143.index = 1
		v143.sibling = nil
		v143.return_ = p32

		return v143
	end
	local function assignStableKey(p36, t5: {[any]: any}) -- line: 586
		if t5.key == nil then
			local v146 = type(p36)

			if v146 == "string" or v146 == "number" then
				t5.key = p36

				return
			end

			if v146 == "table" then
				t5.key = tostring(p36)
			end
		end
	end
	local function createChild(p37, p38, p39, p40) -- line: 605
		-- upvalues: REACT_ELEMENT_TYPE (copy), createFiberFromElement (copy), REACT_PORTAL_TYPE (copy), createFiberFromPortal (copy), REACT_LAZY_TYPE (copy), enableLazyElements (copy), createChild (copy), createFiberFromFragment (copy), createFiberFromText (copy), __DEV__ (copy), getComponentName (copy), t3 (ref), console (copy)
		if p38 == nil then
			return nil
		end

		local v151 = type(p38)

		if v151 == "table" then
			if p38.key == nil then
				local v152 = type(p40)

				if v152 == "string" or v152 == "number" then
					p38.key = p40
				elseif v152 == "table" then
					p38.key = tostring(p40)
				end
			end

			local v153 = p38["$$typeof"]

			if v153 == REACT_ELEMENT_TYPE then
				local v154 = createFiberFromElement(p38, p37.mode, p39)

				v154.ref = coerceRef(p37, nil, p38)
				v154.return_ = p37

				return v154
			end

			if v153 == REACT_PORTAL_TYPE then
				local v155 = createFiberFromPortal(p38, p37.mode, p39)

				v155.return_ = p37

				return v155
			end

			if v153 == REACT_LAZY_TYPE and enableLazyElements then
				local _payload = p38._payload
				local _init = p38._init

				return createChild(p37, _init(_payload), p39)
			end

			local v158 = createFiberFromFragment(p38, p37.mode, p39, nil)

			v158.return_ = p37

			return v158
		end

		if v151 == "string" or v151 == "number" then
			local v159 = createFiberFromText(tostring(p38), p37.mode, p39)

			v159.return_ = p37

			return v159
		end

		if __DEV__ and v151 == "function" and __DEV__ then
			local v160 = getComponentName(p37.type) or "Component"

			if not t3[v160] then
				t3[v160] = true
				console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
			end
		end

		return nil
	end
	local function updateSlot(p41, p42, p43, p44, p45) -- line: 676
		-- upvalues: REACT_ELEMENT_TYPE (copy), REACT_FRAGMENT_TYPE (copy), Fragment (copy), createFiberFromFragment (copy), createWorkInProgress (copy), updateElement (copy), REACT_PORTAL_TYPE (copy), updatePortal (copy), REACT_LAZY_TYPE (copy), enableLazyElements (copy), updateSlot (copy), HostText (copy), createFiberFromText (copy), __DEV__ (copy), getComponentName (copy), t3 (ref), console (copy)
		if p43 == nil then
			return nil
		end

		local v166 = if p42 == nil then nil else p42.key
		local v167 = type(p43)

		if v167 == "table" then
			if p43.key == nil then
				local v168 = type(p45)

				if v168 == "string" or v168 == "number" then
					p43.key = p45
				elseif v168 == "table" then
					p43.key = tostring(p45)
				end
			end

			local v169 = p43["$$typeof"]

			if v169 == REACT_ELEMENT_TYPE then
				if v166 == p43.key then
					if p43.type == REACT_FRAGMENT_TYPE then
						local children = p43.props.children

						if p42 == nil or p42.tag ~= Fragment then
							local v171 = createFiberFromFragment(children, p41.mode, p44, v166)

							v171.return_ = p41

							return v171
						end

						local v172 = createWorkInProgress(p42, children)

						v172.index = 1
						v172.sibling = nil
						v172.return_ = p41

						return v172
					end

					return (updateElement(p41, p42, p43, p44))
				end

				return nil
			end

			if v169 == REACT_PORTAL_TYPE then
				if v166 == p43.key then
					return (updatePortal(p41, p42, p43, p44))
				end

				return nil
			end

			if v169 == REACT_LAZY_TYPE and enableLazyElements then
				local _payload = p43._payload
				local _init = p43._init

				return updateSlot(p41, p42, _init(_payload), p44)
			end

			if v166 ~= nil then
				return nil
			end

			if p42 == nil or p42.tag ~= Fragment then
				local v175 = createFiberFromFragment(p43, p41.mode, p44, nil)

				v175.return_ = p41

				return v175
			end

			local v176 = createWorkInProgress(p42, p43)

			v176.index = 1
			v176.sibling = nil
			v176.return_ = p41

			return v176
		end

		if v167 == "string" or v167 == "number" then
			if v166 ~= nil then
				return nil
			end

			local str = tostring(p43)

			if p42 == nil or p42.tag ~= HostText then
				local v178 = createFiberFromText(str, p41.mode, p44)

				v178.return_ = p41

				return v178
			end

			local v179 = createWorkInProgress(p42, str)

			v179.index = 1
			v179.sibling = nil
			v179.return_ = p41

			return v179
		end

		if __DEV__ and v167 == "function" and __DEV__ then
			local v180 = getComponentName(p41.type) or "Component"

			if not t3[v180] then
				t3[v180] = true
				console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
			end
		end

		return nil
	end
	local function updateFromMap(t6: {[any]: any}, p46, n3: number, p47, p48, p49) -- line: 764
		-- upvalues: REACT_ELEMENT_TYPE (copy), REACT_FRAGMENT_TYPE (copy), Fragment (copy), createFiberFromFragment (copy), createWorkInProgress (copy), updateElement (copy), REACT_PORTAL_TYPE (copy), updatePortal (copy), REACT_LAZY_TYPE (copy), enableLazyElements (copy), updateFromMap (copy), HostText (copy), createFiberFromText (copy), __DEV__ (copy), getComponentName (copy), t3 (ref), console (copy)
		if p47 == nil then
			return nil
		end

		local v187 = type(p47)

		if v187 == "table" then
			if p47.key == nil then
				local v188 = type(p49)

				if v188 == "string" or v188 == "number" then
					p47.key = p49
				elseif v188 == "table" then
					p47.key = tostring(p49)
				end
			end

			local v189 = p47["$$typeof"]

			if v189 == REACT_ELEMENT_TYPE then
				local v190 = t6[if p47.key ~= nil then p47.key else n3]

				if p47.type == REACT_FRAGMENT_TYPE then
					local children = p47.props.children
					local key = p47.key

					if v190 == nil or v190.tag ~= Fragment then
						local v193 = createFiberFromFragment(children, p46.mode, p48, key)

						v193.return_ = p46

						return v193
					end

					local v194 = createWorkInProgress(v190, children)

					v194.index = 1
					v194.sibling = nil
					v194.return_ = p46

					return v194
				end

				return (updateElement(p46, v190, p47, p48))
			end

			if v189 == REACT_PORTAL_TYPE then
				local v195 = t6[if p47.key ~= nil then p47.key else n3]

				return (updatePortal(p46, v195, p47, p48))
			end

			if v189 == REACT_LAZY_TYPE and enableLazyElements then
				local _payload = p47._payload
				local _init = p47._init

				return updateFromMap(t6, p46, n3, _init(_payload), p48)
			end

			local v198 = t6[n3]

			if v198 == nil or v198.tag ~= Fragment then
				local v199 = createFiberFromFragment(p47, p46.mode, p48, nil)

				v199.return_ = p46

				return v199
			end

			local v200 = createWorkInProgress(v198, p47)

			v200.index = 1
			v200.sibling = nil
			v200.return_ = p46

			return v200
		end

		if v187 == "string" or v187 == "number" then
			local v201 = t6[n3] or nil
			local str = tostring(p47)

			if v201 == nil or v201.tag ~= HostText then
				local v203 = createFiberFromText(str, p46.mode, p48)

				v203.return_ = p46

				return v203
			end

			local v204 = createWorkInProgress(v201, str)

			v204.index = 1
			v204.sibling = nil
			v204.return_ = p46

			return v204
		end

		if __DEV__ and v187 == "function" and __DEV__ then
			local v205 = getComponentName(p46.type) or "Component"

			if not t3[v205] then
				t3[v205] = true
				console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
			end
		end

		return nil
	end
	local function warnOnInvalidKey(p50, t7: {[any]: any}?, p51) -- line: 858
		-- upvalues: __DEV__ (copy), REACT_ELEMENT_TYPE (copy), REACT_PORTAL_TYPE (copy), u46 (ref), console (copy), REACT_LAZY_TYPE (copy), enableLazyElements (copy), warnOnInvalidKey (copy)
		if __DEV__ then
			if p50 == nil or type(p50) ~= "table" then
				return t7
			end

			local v209 = p50["$$typeof"]

			if v209 == REACT_ELEMENT_TYPE or v209 == REACT_PORTAL_TYPE then
				u46(p50, p51)

				local key = p50.key

				if type(key) ~= "string" then
					return t7
				end

				if t7 == nil then
					return {
						[key] = true
					}
				end

				if not t7[key] then
					t7[key] = true

					return t7
				end

				console.error("Encountered two children with the same key, `%s`. Keys should be unique so that components maintain their identity across updates. Non-unique keys may cause children to be duplicated and/or omitted — the behavior is unsupported and could change in a future version.", key)

				return t7
			end

			if v209 == REACT_LAZY_TYPE and enableLazyElements then
				local _payload = p50._payload
				local _init = p50._init

				warnOnInvalidKey(_init(_payload), t7, p51)
			end
		end

		return t7
	end
	local function reconcileChildrenArray(p52, p53, t8: {[any]: any}, p54) -- line: 900
		-- upvalues: __DEV__ (copy), warnOnInvalidKey (copy), updateSlot (copy), p10 (copy), Deletion (copy), Placement (copy), createChild (copy), mapRemainingChildren (copy), v9 (copy), updateFromMap (copy)
		if __DEV__ then
			local v217 = nil

			for _, v219 in t8 do
				v217 = warnOnInvalidKey(v219, v217, p52)
			end
		end

		local v220 = nil
		local v221 = nil
		local n4 = 1
		local n5 = 1
		local v224 = #t8

		while p53 ~= nil and n5 <= v224 do
			local v225

			if n5 < p53.index then
				v225 = p53
				p53 = nil
			else
				v225 = p53.sibling
			end

			local v226 = t8[n5]
			local v227 = if v226 == nil or (type(v226) ~= "table" or v226["$$typeof"] == nil) then updateSlot(p52, p53, v226, p54) else updateSlot(p52, p53, v226, p54, n5)

			if v227 == nil then
				if p53 == nil then
					p53 = v225
				end

				break
			end

			if p10 and p53 and v227.alternate == nil then
				if p10 then
					local deletions = p52.deletions

					if deletions == nil then
						p52.deletions = { p53 }
						p52.flags = bit32.bor(p52.flags, Deletion)
					else
						table.insert(deletions, p53)
					end
				end
			end

			v227.index = n5

			if not p10 then
			else
				local alternate = v227.alternate

				if alternate ~= nil then
					local index = alternate.index

					if index < n4 then
						v227.flags = bit32.bor(v227.flags, Placement)
					else
						n4 = index
					end
				else
					v227.flags = bit32.bor(v227.flags, Placement)
				end
			end

			if v221 == nil then
				v220 = v227
			else
				v221.sibling = v227
			end

			v221 = v227
			p53 = v225
			n5 += 1
		end

		if v224 < n5 then
			if not p10 then
				return v220
			end

			while p53 ~= nil do
				if p10 then
					local deletions = p52.deletions

					if deletions == nil then
						p52.deletions = { p53 }
						p52.flags = bit32.bor(p52.flags, Deletion)
					else
						table.insert(deletions, p53)
					end
				end

				p53 = p53.sibling
			end

			return v220
		end

		if p53 == nil then
			while n5 <= v224 do
				local v232 = t8[n5]
				local v233 = if v232 == nil or (type(v232) ~= "table" or v232["$$typeof"] == nil) then createChild(p52, v232, p54) else createChild(p52, v232, p54, n5)

				if v233 == nil then
					n5 += 1
				else
					v233.index = n5

					if not p10 then
					else
						local alternate = v233.alternate

						if alternate ~= nil then
							local index = alternate.index

							if index < n4 then
								v233.flags = bit32.bor(v233.flags, Placement)
							else
								n4 = index
							end
						else
							v233.flags = bit32.bor(v233.flags, Placement)
						end
					end

					if v221 == nil then
						v220 = v233
					else
						v221.sibling = v233
					end

					v221 = v233
					n5 += 1
				end
			end

			return v220
		end

		local v236 = mapRemainingChildren(p52, p53)

		while n5 <= v224 do
			local v237 = t8[n5]
			local v238 = if not not v9 and (v237 == nil or (type(v237) ~= "table" or v237["$$typeof"] == nil)) then updateFromMap(v236, p52, n5, v237, p54) else updateFromMap(v236, p52, n5, v237, p54, n5)

			if v238 ~= nil then
				if p10 and v238.alternate ~= nil then
					v236[if v238.key ~= nil then v238.key else n5] = nil
				end

				v238.index = n5

				if not p10 then
				else
					local alternate = v238.alternate

					if alternate ~= nil then
						local index = alternate.index

						if index < n4 then
							v238.flags = bit32.bor(v238.flags, Placement)
						else
							n4 = index
						end
					else
						v238.flags = bit32.bor(v238.flags, Placement)
					end
				end

				if v221 == nil then
					v220 = v238
				else
					v221.sibling = v238
				end

				v221 = v238
			end

			n5 += 1
		end

		if p10 then
			for _, v242 in v236 do
				if p10 then
					local deletions = p52.deletions

					if deletions == nil then
						p52.deletions = { v242 }
						p52.flags = bit32.bor(p52.flags, Deletion)
					else
						table.insert(deletions, v242)
					end
				end
			end
		end

		return v220
	end
	local function reconcileChildrenIterator(p55, p56, p57, p58, p59: ((...any) -> ...any)) -- line: 1127
		-- upvalues: __DEV__ (copy), u43 (ref), console (copy), warnOnInvalidKey (copy), updateSlot (copy), p10 (copy), Deletion (copy), Placement (copy), createChild (copy), mapRemainingChildren (copy), updateFromMap (copy)
		if __DEV__ then
			if p59 == p57.entries then
				if not u43 then
					console.error("Using Maps as children is not supported. Use an array of keyed ReactElements instead.")
				end

				u43 = true
			end

			local v249 = p59(p57)

			if v249 then
				local v250 = nil
				local v251 = v249.next()

				while not v251.done do
					v251 = v249.next()

					local value = v251.value

					v250 = warnOnInvalidKey(value, v250, p55)
				end
			end
		end

		local v253 = p59(p57)
		local v254 = nil
		local v255 = nil
		local n6 = 1
		local n7 = 1
		local v258 = v253.next()

		while p56 ~= nil and not v258.done do
			local v259

			if n7 < p56.index then
				v259 = p56
				p56 = nil
			else
				v259 = p56.sibling
			end

			local v260 = updateSlot(p55, p56, v258.value, p58, v258.key)

			if v260 == nil then
				if p56 == nil then
					p56 = v259
				end

				break
			end

			if p10 and p56 and v260.alternate == nil then
				if p10 then
					local deletions = p55.deletions

					if deletions == nil then
						p55.deletions = { p56 }
						p55.flags = bit32.bor(p55.flags, Deletion)
					else
						table.insert(deletions, p56)
					end
				end
			end

			v260.index = n7

			if not p10 then
			else
				local alternate = v260.alternate

				if alternate ~= nil then
					local index = alternate.index

					if index < n6 then
						v260.flags = bit32.bor(v260.flags, Placement)
					else
						n6 = index
					end
				else
					v260.flags = bit32.bor(v260.flags, Placement)
				end
			end

			if v255 == nil then
				v254 = v260
			else
				v255.sibling = v260
			end

			v255 = v260
			p56 = v259
			n7 += 1
			v258 = v253.next()
		end

		if v258.done then
			if not p10 then
				return v254
			end

			while p56 ~= nil do
				if p10 then
					local deletions = p55.deletions

					if deletions == nil then
						p55.deletions = { p56 }
						p55.flags = bit32.bor(p55.flags, Deletion)
					else
						table.insert(deletions, p56)
					end
				end

				p56 = p56.sibling
			end

			return v254
		end

		if p56 == nil then
			while not v258.done do
				local v265 = createChild(p55, v258.value, p58, v258.key)

				if v265 == nil then
					n7 += 1
					v258 = v253.next()
				else
					v265.index = n7

					if not p10 then
					else
						local alternate = v265.alternate

						if alternate ~= nil then
							local index = alternate.index

							if index < n6 then
								v265.flags = bit32.bor(v265.flags, Placement)
							else
								n6 = index
							end
						else
							v265.flags = bit32.bor(v265.flags, Placement)
						end
					end

					if v255 == nil then
						v254 = v265
					else
						v255.sibling = v265
					end

					v255 = v265
					n7 += 1
					v258 = v253.next()
				end
			end

			return v254
		end

		local v268 = nil

		while not v258.done do
			if not v268 then
				v268 = mapRemainingChildren(p55, p56)
			end

			local v269 = updateFromMap(v268, p55, n7, v258.value, p58, v258.key)

			if v269 ~= nil then
				if p10 and v269.alternate ~= nil then
					if v269.key == nil then
						v268[n7] = nil
					else
						v268[v269.key] = nil
					end
				end

				v269.index = n7

				if not p10 then
				else
					local alternate = v269.alternate

					if alternate ~= nil then
						local index = alternate.index

						if index < n6 then
							v269.flags = bit32.bor(v269.flags, Placement)
						else
							n6 = index
						end
					else
						v269.flags = bit32.bor(v269.flags, Placement)
					end
				end

				if v255 == nil then
					v254 = v269
				else
					v255.sibling = v269
				end

				v255 = v269
			end

			n7 += 1
			v258 = v253.next()
		end

		if p10 then
			for _, v273 in v268 do
				if p10 then
					local deletions = p55.deletions

					if deletions == nil then
						p55.deletions = { v273 }
						p55.flags = bit32.bor(p55.flags, Deletion)
					else
						table.insert(deletions, v273)
					end
				end
			end
		end

		return v254
	end
	local function reconcileSingleTextNode(p60, p61, s3: string, p62) -- line: 1340
		-- upvalues: HostText (copy), p10 (copy), Deletion (copy), createWorkInProgress (copy), createFiberFromText (copy)
		if p61 ~= nil and p61.tag == HostText then
			local sibling = p61.sibling

			if p10 then
				while sibling ~= nil do
					if p10 then
						local deletions = p60.deletions

						if deletions == nil then
							p60.deletions = { sibling }
							p60.flags = bit32.bor(p60.flags, Deletion)
						else
							table.insert(deletions, sibling)
						end
					end

					sibling = sibling.sibling
				end
			end

			local v281 = createWorkInProgress(p61, s3)

			v281.index = 1
			v281.sibling = nil
			v281.return_ = p60

			return v281
		end

		if p10 then
			while p61 ~= nil do
				if p10 then
					local deletions = p60.deletions

					if deletions == nil then
						p60.deletions = { p61 }
						p60.flags = bit32.bor(p60.flags, Deletion)
					else
						table.insert(deletions, p61)
					end
				end

				p61 = p61.sibling
			end
		end

		local v283 = createFiberFromText(s3, p60.mode, p62)

		v283.return_ = p60

		return v283
	end
	local function reconcileSingleElement(p63, p64, p65, p66) -- line: 1365
		-- upvalues: Fragment (copy), REACT_FRAGMENT_TYPE (copy), p10 (copy), Deletion (copy), createWorkInProgress (copy), __DEV__ (copy), isCompatibleFamilyForHotReloading (copy), createFiberFromFragment (copy), createFiberFromElement (copy)
		local key = p65.key
		local v289 = p64

		while v289 ~= nil do
			if key == v289.key then
				if v289.tag == Fragment then
					if p65.type == REACT_FRAGMENT_TYPE then
						local sibling = v289.sibling

						if p10 then
							while sibling ~= nil do
								if p10 then
									local deletions = p63.deletions

									if deletions == nil then
										p63.deletions = { sibling }
										p63.flags = bit32.bor(p63.flags, Deletion)
									else
										table.insert(deletions, sibling)
									end
								end

								sibling = sibling.sibling
							end
						end

						local children = p65.props.children
						local v293 = createWorkInProgress(v289, children)

						v293.index = 1
						v293.sibling = nil
						v293.return_ = p63

						if __DEV__ then
							v293._debugSource = p65._source
							v293._debugOwner = p65._owner
						end

						return v293
					end
				elseif v289.elementType == p65.type or __DEV__ and isCompatibleFamilyForHotReloading(v289, p65) then
					local sibling = v289.sibling

					if p10 then
						while sibling ~= nil do
							if p10 then
								local deletions = p63.deletions

								if deletions == nil then
									p63.deletions = { sibling }
									p63.flags = bit32.bor(p63.flags, Deletion)
								else
									table.insert(deletions, sibling)
								end
							end

							sibling = sibling.sibling
						end
					end

					local props = p65.props
					local v297 = createWorkInProgress(v289, props)

					v297.index = 1
					v297.sibling = nil
					v297.ref = coerceRef(p63, v289, p65)
					v297.return_ = p63

					if __DEV__ then
						v297._debugSource = p65._source
						v297._debugOwner = p65._owner
					end

					return v297
				end

				if p10 then
					while v289 ~= nil do
						if p10 then
							local deletions = p63.deletions

							if deletions == nil then
								p63.deletions = { v289 }
								p63.flags = bit32.bor(p63.flags, Deletion)
							else
								table.insert(deletions, v289)
							end
						end

						v289 = v289.sibling
					end
				end

				break
			end

			if p10 then
				local deletions = p63.deletions

				if deletions == nil then
					p63.deletions = { v289 }
					p63.flags = bit32.bor(p63.flags, Deletion)
				else
					table.insert(deletions, v289)
				end
			end

			v289 = v289.sibling
		end

		if p65.type == REACT_FRAGMENT_TYPE then
			local v300 = createFiberFromFragment(p65.props.children, p63.mode, p66, p65.key)

			v300.return_ = p63

			return v300
		end

		local v301 = createFiberFromElement(p65, p63.mode, p66)

		v301.ref = coerceRef(p63, p64, p65)
		v301.return_ = p63

		return v301
	end
	local function reconcileSinglePortal(p67, p68, p69, p70) -- line: 1460
		-- upvalues: HostPortal (copy), p10 (copy), Deletion (copy), createWorkInProgress (copy), createFiberFromPortal (copy)
		local key = p69.key

		while p68 ~= nil do
			if key == p68.key then
				if p68.tag == HostPortal and p68.stateNode.containerInfo == p69.containerInfo and p68.stateNode.implementation == p69.implementation then
					local sibling = p68.sibling

					if p10 then
						while sibling ~= nil do
							if p10 then
								local deletions = p67.deletions

								if deletions == nil then
									p67.deletions = { sibling }
									p67.flags = bit32.bor(p67.flags, Deletion)
								else
									table.insert(deletions, sibling)
								end
							end

							sibling = sibling.sibling
						end
					end

					local v309 = p69.children or {}
					local v310 = createWorkInProgress(p68, v309)

					v310.index = 1
					v310.sibling = nil
					v310.return_ = p67

					return v310
				end

				if p10 then
					while p68 ~= nil do
						if p10 then
							local deletions = p67.deletions

							if deletions == nil then
								p67.deletions = { p68 }
								p67.flags = bit32.bor(p67.flags, Deletion)
							else
								table.insert(deletions, p68)
							end
						end

						p68 = p68.sibling
					end
				end

				break
			end

			if p10 then
				local deletions = p67.deletions

				if deletions == nil then
					p67.deletions = { p68 }
					p67.flags = bit32.bor(p67.flags, Deletion)
				else
					table.insert(deletions, p68)
				end
			end

			p68 = p68.sibling
		end

		local v313 = createFiberFromPortal(p69, p67.mode, p70)

		v313.return_ = p67

		return v313
	end
	local function reconcileChildFibers(p71, p72, p73, p74) -- line: 1499
		-- upvalues: REACT_FRAGMENT_TYPE (copy), isArray (copy), REACT_ELEMENT_TYPE (copy), reconcileSingleElement (copy), p10 (copy), Placement (copy), REACT_PORTAL_TYPE (copy), reconcileSinglePortal (copy), REACT_LAZY_TYPE (copy), enableLazyElements (copy), reconcileChildFibers (copy), reconcileChildrenArray (copy), reconcileSingleTextNode (copy), getIteratorFn (copy), reconcileChildrenIterator (copy), __DEV__ (copy), getComponentName (copy), t3 (ref), console (copy), Deletion (copy)
		local v318 = type(p73)
		local v319 = p73 ~= nil and (v318 == "table" and (p73.type == REACT_FRAGMENT_TYPE and p73.key == nil))

		if v319 then
			p73 = p73.props.children
			v318 = type(p73)
		end

		local v320 = isArray(p73)

		if p73 ~= nil and (v318 == "table" and not v320) then
			local v321 = p73["$$typeof"]

			if v321 == REACT_ELEMENT_TYPE then
				local v322 = reconcileSingleElement(p71, p72, p73, p74)

				if p10 and v322.alternate == nil then
					v322.flags = bit32.bor(v322.flags, Placement)
				end

				return v322
			end

			if v321 == REACT_PORTAL_TYPE then
				local v323 = reconcileSinglePortal(p71, p72, p73, p74)

				if p10 and v323.alternate == nil then
					v323.flags = bit32.bor(v323.flags, Placement)
				end

				return v323
			end

			if v321 == REACT_LAZY_TYPE and enableLazyElements then
				local _payload = p73._payload
				local _init = p73._init

				return reconcileChildFibers(p71, p72, _init(_payload), p74)
			end
		else
			if v320 then
				return (reconcileChildrenArray(p71, p72, p73, p74))
			end

			if v318 == "string" or v318 == "number" then
				local v326 = reconcileSingleTextNode(p71, p72, tostring(p73), p74)

				if p10 and v326.alternate == nil then
					v326.flags = bit32.bor(v326.flags, Placement)
				end

				return v326
			end
		end

		local v327 = getIteratorFn(p73)

		if v327 then
			return (reconcileChildrenIterator(p71, p72, p73, p74, v327))
		end

		if __DEV__ and v318 == "function" and __DEV__ then
			local v328 = getComponentName(p71.type) or "Component"

			if not t3[v328] then
				t3[v328] = true
				console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
			end
		end

		if p73 == nil then
			if v319 then
			end
		end

		if not p10 then
			return nil
		end

		while p72 ~= nil do
			if p10 then
				local deletions = p71.deletions

				if deletions == nil then
					p71.deletions = { p72 }
					p71.flags = bit32.bor(p71.flags, Deletion)
				else
					table.insert(deletions, p72)
				end
			end

			p72 = p72.sibling
		end

		return nil
	end

	return reconcileChildFibers
end

t1.reconcileChildFibers = ChildReconciler(true)
t1.mountChildFibers = ChildReconciler(false)

function t1.cloneChildFibers(_, p76) -- line: 1647
	-- upvalues: createWorkInProgress (copy)
	if p76.child == nil then
		return
	end

	local child = p76.child
	local v92 = createWorkInProgress(child, child.pendingProps)

	p76.child = v92
	v92.return_ = p76

	while child.sibling ~= nil do
		child = child.sibling
		v92.sibling = createWorkInProgress(child, child.pendingProps)
		v92 = v92.sibling
		v92.return_ = p76
	end

	v92.sibling = nil
end
function t1.resetChildFibers(p77, p78) -- line: 1674
	-- upvalues: resetWorkInProgress (copy)
	local child = p77.child

	while child ~= nil do
		resetWorkInProgress(child, p78)
		child = child.sibling
	end
end

return t1
