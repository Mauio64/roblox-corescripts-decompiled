local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

local Shared = require(parent.Shared)
local console = Shared.console
local Shared2 = require(parent.Shared)
local describeError = Shared2.describeError

local __DEV__ = ReactGlobals.__DEV__

local SafeFlags = require(parent.SafeFlags)

local v = SafeFlags.createGetFFlag("ReactPreventAssigningKeyToChildren")()

require(parent.Shared)

require(parent.React)

require(script.Parent.ReactInternalTypes)

require(script.Parent.ReactFiberLane)

local Shared3 = require(parent.Shared)
local getComponentName = Shared3.getComponentName
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Placement = ReactFiberFlags.Placement
local Deletion = ReactFiberFlags.Deletion
local Shared4 = require(parent.Shared)
local ReactSymbols = Shared4.ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local FunctionComponent = ReactWorkTags.FunctionComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local ForwardRef = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local Block = ReactWorkTags.Block
local Shared5 = require(parent.Shared)
local invariant = Shared5.invariant
local Shared6 = require(parent.Shared)
local ReactFeatureFlags = Shared6.ReactFeatureFlags

local enableLazyElements = ReactFeatureFlags.enableLazyElements
local enableBlocksAPI = ReactFeatureFlags.enableBlocksAPI

local ReactFibernew = require(script.Parent["ReactFiber.new"])
local createWorkInProgress = ReactFibernew.createWorkInProgress
local resetWorkInProgress = ReactFibernew.resetWorkInProgress
local createFiberFromElement = ReactFibernew.createFiberFromElement
local createFiberFromFragment = ReactFibernew.createFiberFromFragment
local createFiberFromText = ReactFibernew.createFiberFromText
local createFiberFromPortal = ReactFibernew.createFiberFromPortal

local ReactFiberHotReloadingnew = require(script.Parent["ReactFiberHotReloading.new"])

local isCompatibleFamilyForHotReloading = ReactFiberHotReloadingnew.isCompatibleFamilyForHotReloading

local v2 = nil

local set = nil
local fn, set2

if __DEV__ then
	v2 = false

	set = {}

	fn = function(p, p2)
		if p == nil or type(p) ~= "table" then
			return
		end

		if not p._store or p._store.validated or p.key ~= nil then
			return
		end

		invariant(
			p._store ~= nil and type(p._store) == "table",
			"React Component in warnForMissingKey should have a _store. This error is likely caused by a bug in React. Please file an issue."
		)

		p._store.validated = true

		local v3 = getComponentName(p2.type) or "Component"

		if set[v3] then
			return
		end

		set[v3] = true

		console.error("Each child in a list should have a unique \"key\" prop. See https://reactjs.org/link/warning-keys for more information.")
	end

	set2 = {}
else
	set2 = nil

	fn = function(_, _) end
end

local isArray = Array.isArray

function coerceRef(p, _, data)
	local ref = data.ref

	if ref == nil or type(ref) ~= "string" then
		return ref
	end

	if not data._owner or not data._self or data._owner.stateNode == data._self then
		local v3 = __DEV__ and (getComponentName(p.type) or "Component") or "<enable __DEV__ mode for component names>"

		error(Error.new(string.format(
			"Component \"%s\" contains the string ref \"%s\". Support for string refs has been removed. We recommend using useRef() or createRef() instead. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-string-ref",
			v3,
			(tostring(ref))
		)))
	end

	if not data._owner then
		error("Expected ref to be a function or an object returned by React.createRef(), or nil.")
	end

	return ref
end

local function warnOnFunctionType(p) -- 4 equivalent calls inferred from this helper
	if __DEV__ then
		local v3 = getComponentName(p.type) or "Component"

		if set2[v3] then
			return
		end

		set2[v3] = true

		console.error("Functions are not valid as a React child. This may happen if you return a Component instead of <Component /> from render. Or maybe you meant to call this function rather than return it.")
	end
end

function resolveLazyType(p)
	local payload = p._payload
	local success, result = xpcall(p._init, describeError, payload)
	return if success then result else p
end

local function ChildReconciler(p)
	local function deleteChild(state, p2) -- 9 equivalent calls inferred from this helper
		if not p then
			return
		end

		local deletions = state.deletions

		if deletions ~= nil then
			table.insert(deletions, p2)

			return
		end

		state.deletions = { p2 }
		state.flags = bit32.bor(state.flags, Deletion)
	end

	local function deleteRemainingChildren(state, p2): nil -- 8 equivalent calls inferred from this helper
		if not p then
			return nil
		end

		while p2 ~= nil do
			deleteChild(state, p2) -- inferred equivalent call
			p2 = p2.sibling
		end

		return nil
	end

	local function mapRemainingChildren(_, data)
		local result = {}

		while data ~= nil do
			if data.key == nil then
				result[data.index] = data
			else
				result[data.key] = data
			end

			data = data.sibling
		end

		return result
	end

	local function useFiber(p2, p3) -- 9 equivalent calls inferred from this helper
		local workInProgress = createWorkInProgress(p2, p3)

		workInProgress.index = 1

		if ReactFeatureFlags.enableWorkLoopTrims then
			if workInProgress.sibling ~= nil then
				workInProgress.sibling = nil
				return workInProgress
			end
		else
			workInProgress.sibling = nil
		end

		return workInProgress
	end

	local function placeChild(state, p2: number, p3: number) -- 6 equivalent calls inferred from this helper
		state.index = p3

		if not p then
			return p2
		end

		local alternate = state.alternate

		if alternate == nil then
			state.flags = bit32.bor(state.flags, Placement)
			return p2
		end

		local index = alternate.index

		if index < p2 then
			state.flags = bit32.bor(state.flags, Placement)
			return p2
		end

		return index
	end

	local function placeSingleChild(state) -- 3 equivalent calls inferred from this helper
		if p and state.alternate == nil then
			state.flags = bit32.bor(state.flags, Placement)
		end

		return state
	end

	local function updateTextNode(return_, p2, p3: string, p4) -- 2 equivalent calls inferred from this helper
		if p2 == nil or p2.tag ~= HostText then
			local fiberFromText = createFiberFromText(p3, return_.mode, p4)
			fiberFromText.return_ = return_
			return fiberFromText
		else
			local workInProgress = useFiber(p2, p3) -- inferred equivalent call
			workInProgress.return_ = return_
			return workInProgress
		end
	end

	local function updateElement(return_, data, data2, p2)
		if data ~= nil then
			if data.elementType == data2.type or __DEV__ and isCompatibleFamilyForHotReloading(data, data2) then
				local workInProgress = useFiber(data, data2.props) -- inferred equivalent call

				if ReactFeatureFlags.enableWorkLoopTrims then
					local ref = coerceRef(return_, data, data2)

					if ref ~= nil or workInProgress.ref ~= nil then
						workInProgress.ref = ref
					end
				else
					workInProgress.ref = coerceRef(return_, data, data2)
				end

				workInProgress.return_ = return_

				if __DEV__ then
					workInProgress._debugSource = data2._source
					workInProgress._debugOwner = data2._owner
				end

				return workInProgress
			elseif enableBlocksAPI and data.tag == Block then
				local kind = data2.type

				if type(kind) == "table" and kind["$$typeof"] == REACT_LAZY_TYPE then
					kind = resolveLazyType(kind)
				end

				if kind["$$typeof"] == REACT_BLOCK_TYPE and kind._render == data.type._render then
					local workInProgress = useFiber(data, data2.props) -- inferred equivalent call
					workInProgress.return_ = return_
					workInProgress.type = kind

					if __DEV__ then
						workInProgress._debugSource = data2._source
						workInProgress._debugOwner = data2._owner
					end

					return workInProgress
				end
			end
		end

		local fiberFromElement = createFiberFromElement(data2, return_.mode, p2)
		fiberFromElement.ref = coerceRef(return_, data, data2)
		fiberFromElement.return_ = return_
		return fiberFromElement
	end

	local function updatePortal(return_, p2, data, p3)
		if
			p2 == nil
			or p2.tag ~= HostPortal
			or p2.stateNode.containerInfo ~= data.containerInfo
			or p2.stateNode.implementation ~= data.implementation
		then
			local fiberFromPortal = createFiberFromPortal(data, return_.mode, p3)
			fiberFromPortal.return_ = return_
			return fiberFromPortal
		else
			local workInProgress = useFiber(p2, data.children or {}) -- inferred equivalent call
			workInProgress.return_ = return_
			return workInProgress
		end
	end

	local function updateFragment(return_, p2, p3, p4, key: string?) -- 4 equivalent calls inferred from this helper
		if p2 == nil or p2.tag ~= Fragment then
			local fiberFromFragment = createFiberFromFragment(p3, return_.mode, p4, key)
			fiberFromFragment.return_ = return_
			return fiberFromFragment
		else
			local workInProgress = useFiber(p2, p3) -- inferred equivalent call
			workInProgress.return_ = return_
			return workInProgress
		end
	end

	local function assignStableKey(p2, data) -- 3 equivalent calls inferred from this helper
		if data.key == nil then
			local typeName = type(p2)

			if typeName == "string" or typeName == "number" then
				data.key = p2
			elseif typeName == "table" then
				data.key = tostring(p2)
			end
		end
	end

	local function createChild(return_, data, p2, p3)
		if data == nil then
			return nil
		end

		local typeName = type(data)

		if typeName == "table" then
			assignStableKey(p3, data) -- inferred equivalent call
			local Typeof = data["$$typeof"]

			if Typeof == REACT_ELEMENT_TYPE then
				local fiberFromElement = createFiberFromElement(data, return_.mode, p2)
				fiberFromElement.ref = coerceRef(return_, nil, data)
				fiberFromElement.return_ = return_
				return fiberFromElement
			elseif Typeof == REACT_PORTAL_TYPE then
				local fiberFromPortal = createFiberFromPortal(data, return_.mode, p2)
				fiberFromPortal.return_ = return_
				return fiberFromPortal
			elseif Typeof == REACT_LAZY_TYPE and enableLazyElements then
				local payload = data._payload
				return createChild(return_, data._init(payload), p2)
			else
				local fiberFromFragment = createFiberFromFragment(data, return_.mode, p2, nil)
				fiberFromFragment.return_ = return_
				return fiberFromFragment
			end
		elseif typeName == "string" or typeName == "number" then
			local fiberFromText = createFiberFromText(tostring(data), return_.mode, p2)
			fiberFromText.return_ = return_
			return fiberFromText
		else
			if __DEV__ and typeName == "function" then
				warnOnFunctionType(return_) -- inferred equivalent call
			end

			return nil
		end
	end

	local function updateSlot(return_, p2, data, p3, p4)
		if data == nil then
			return nil
		end

		local key

		if p2 ~= nil then
			key = p2.key
		end

		local typeName = type(data)

		if typeName == "table" then
			assignStableKey(p4, data) -- inferred equivalent call
			local Typeof = data["$$typeof"]

			if Typeof == REACT_ELEMENT_TYPE then
				if data.key ~= key then
					return nil
				end

				if data.type ~= REACT_FRAGMENT_TYPE then
					return updateElement(return_, p2, data, p3)
				end

				return updateFragment(return_, p2, data.props.children, p3, key) -- inferred equivalent call
			elseif Typeof == REACT_PORTAL_TYPE then
				if data.key == key then
					return updatePortal(return_, p2, data, p3)
				end

				return nil
			elseif Typeof == REACT_LAZY_TYPE and enableLazyElements then
				local payload = data._payload
				return updateSlot(return_, p2, data._init(payload), p3)
			else
				if key ~= nil then
					return nil
				end

				return updateFragment(return_, p2, data, p3) -- inferred equivalent call
			end
		elseif typeName == "string" or typeName == "number" then
			if key ~= nil then
				return nil
			end

			return updateTextNode(return_, p2, tostring(data), p3) -- inferred equivalent call
		else
			if __DEV__ and typeName == "function" then
				warnOnFunctionType(return_) -- inferred equivalent call
			end

			return nil
		end
	end

	local function updateFromMap(p2, return_, p3: number, data, p4, p5)
		if data == nil then
			return nil
		end

		local typeName = type(data)

		if typeName == "table" then
			assignStableKey(p5, data) -- inferred equivalent call
			local Typeof = data["$$typeof"]

			if Typeof == REACT_ELEMENT_TYPE then
				if data.key ~= nil then
					p3 = data.key
				end

				local v3 = p2[p3]

				if data.type ~= REACT_FRAGMENT_TYPE then
					return updateElement(return_, v3, data, p4)
				end

				return updateFragment(return_, v3, data.props.children, p4, data.key) -- inferred equivalent call
			elseif Typeof == REACT_PORTAL_TYPE then
				if data.key ~= nil then
					p3 = data.key
				end

				return updatePortal(return_, p2[p3], data, p4)
			elseif Typeof == REACT_LAZY_TYPE and enableLazyElements then
				local payload = data._payload
				return updateFromMap(p2, return_, p3, data._init(payload), p4)
			else
				return updateFragment(return_, p2[p3], data, p4) -- inferred equivalent call
			end
		elseif typeName == "string" or typeName == "number" then
			return updateTextNode(return_, p2[p3] or nil, tostring(data), p4) -- inferred equivalent call
		else
			if __DEV__ and typeName == "function" then
				warnOnFunctionType(return_) -- inferred equivalent call
			end

			return nil
		end
	end

	local function warnOnInvalidKey(data, p2, state)
		if not __DEV__ or (data == nil or type(data) ~= "table") then
			return p2
		end

		local Typeof = data["$$typeof"]

		if Typeof == REACT_ELEMENT_TYPE or Typeof == REACT_PORTAL_TYPE then
			fn(data, state)
			local key = data.key

			if type(key) ~= "string" then
				return p2
			end

			if p2 == nil then
				local set3 = {}
				set3[key] = true
				return set3
			end

			if p2[key] then
				console.error(
					"Encountered two children with the same key, `%s`. Keys should be unique so that components maintain their identity across updates. Non-unique keys may cause children to be duplicated and/or omitted — the behavior is unsupported and could change in a future version.",
					key
				)
			else
				p2[key] = true
			end

			return p2
		elseif Typeof == REACT_LAZY_TYPE and enableLazyElements then
			local payload = data._payload
			warnOnInvalidKey(data._init(payload), p2, state)
		end

		return p2
	end

	local function reconcileChildrenArray(state, p2, list, p3)
		if __DEV__ then
			local v3 = nil

			for _, item in list do
				v3 = warnOnInvalidKey(item, v3, state)
			end
		end

		local count = #list
		local v3 = 1
		local v4 = nil
		local v5 = 1
		local v6 = nil

		while p2 ~= nil and v3 <= count do
			local v7

			if v3 < p2.index then
				v7 = p2
				p2 = nil
			else
				v7 = p2.sibling
			end

			local item = list[v3]
			local sibling

			if item == nil or type(item) ~= "table" or item["$$typeof"] == nil then
				sibling = updateSlot(state, p2, item, p3)
			else
				sibling = updateSlot(state, p2, item, p3, v3)
			end

			if sibling == nil then
				if p2 ~= nil then
					break
				end

				p2 = v7
				break
			end

			if p and p2 and sibling.alternate == nil then
				deleteChild(state, p2) -- inferred equivalent call
			end

			v5 = placeChild(sibling, v5, v3) -- inferred equivalent call

			if v6 == nil then
				v4 = sibling
			else
				v6.sibling = sibling
			end

			v3 += 1
			v6 = sibling
			p2 = v7
		end

		if count < v3 then
			deleteRemainingChildren(state, p2) -- inferred equivalent call
			return v4
		elseif p2 == nil then
			while v3 <= count do
				local item = list[v3]
				local sibling

				if item == nil or type(item) ~= "table" or item["$$typeof"] == nil then
					sibling = createChild(state, item, p3)
				else
					sibling = createChild(state, item, p3, v3)
				end

				if sibling == nil then
					v3 += 1
				else
					v5 = placeChild(sibling, v5, v3) -- inferred equivalent call

					if v6 == nil then
						v4 = sibling
					else
						v6.sibling = sibling
					end

					v3 += 1
					v6 = sibling
				end
			end

			return v4
		else
			local v7 = mapRemainingChildren(state, p2)

			while v3 <= count do
				local item = list[v3]
				local sibling

				if v and (item == nil or type(item) ~= "table" or item["$$typeof"] == nil) then
					sibling = updateFromMap(v7, state, v3, item, p3)
				else
					sibling = updateFromMap(v7, state, v3, item, p3, v3)
				end

				if sibling ~= nil then
					if p and sibling.alternate ~= nil then
						local v8

						if sibling.key == nil then
							v8 = v3
						else
							v8 = sibling.key
						end

						v7[v8] = nil
					end

					v5 = placeChild(sibling, v5, v3) -- inferred equivalent call

					if v6 == nil then
						v4 = sibling
					else
						v6.sibling = sibling
					end

					v6 = sibling
				end

				v3 += 1
			end

			if p then
				for _, v8 in v7 do
					deleteChild(state, v8) -- inferred equivalent call
				end
			end

			return v4
		end
	end

	local function reconcileChildrenIterator(state, p2, data, p3, iteratorFn)
		if __DEV__ then
			if data.entries == iteratorFn then
				if not v2 then
					console.error("Using Maps as children is not supported. Use an array of keyed ReactElements instead.")
				end

				v2 = true
			end

			local v3 = iteratorFn(data)

			if v3 then
				local v4 = v3.next()
				local v5 = nil

				while not v4.done do
					v4 = v3.next()
					v5 = warnOnInvalidKey(v4.value, v5, state)
				end
			end
		end

		local v3 = iteratorFn(data)

		local v4 = v3.next()
		local v5 = 1
		local v6 = nil
		local v7 = 1
		local v8 = nil

		while p2 ~= nil and not v4.done do
			local v9

			if v5 < p2.index then
				v9 = p2
				p2 = nil
			else
				v9 = p2.sibling
			end

			local sibling = updateSlot(state, p2, v4.value, p3, v4.key)

			if sibling == nil then
				if p2 ~= nil then
					break
				end

				p2 = v9
				break
			end

			if p and p2 and sibling.alternate == nil then
				deleteChild(state, p2) -- inferred equivalent call
			end

			v7 = placeChild(sibling, v7, v5) -- inferred equivalent call

			if v8 == nil then
				v6 = sibling
			else
				v8.sibling = sibling
			end

			v5 += 1
			v4 = v3.next()
			v8 = sibling
			p2 = v9
		end

		if v4.done then
			deleteRemainingChildren(state, p2) -- inferred equivalent call
			return v6
		elseif p2 == nil then
			while not v4.done do
				local sibling = createChild(state, v4.value, p3, v4.key)

				if sibling == nil then
					v5 += 1
					v4 = v3.next()
				else
					v7 = placeChild(sibling, v7, v5) -- inferred equivalent call

					if v8 == nil then
						v6 = sibling
					else
						v8.sibling = sibling
					end

					v5 += 1
					v4 = v3.next()
					v8 = sibling
				end
			end

			return v6
		else
			local v9 = nil

			while not v4.done do
				v9 = v9 or mapRemainingChildren(state, p2)

				local sibling = updateFromMap(v9, state, v5, v4.value, p3, v4.key)

				if sibling ~= nil then
					if p and sibling.alternate ~= nil then
						if sibling.key == nil then
							v9[v5] = nil
						else
							v9[sibling.key] = nil
						end
					end

					v7 = placeChild(sibling, v7, v5) -- inferred equivalent call

					if v8 == nil then
						v6 = sibling
					else
						v8.sibling = sibling
					end

					v8 = sibling
				end

				v5 += 1
				v4 = v3.next()
			end

			if p then
				for _, v10 in v9 do
					deleteChild(state, v10) -- inferred equivalent call
				end
			end

			return v6
		end
	end

	local function reconcileSingleTextNode(return_, p2, p3: string, p4)
		if p2 == nil or p2.tag ~= HostText then
			deleteRemainingChildren(return_, p2) -- inferred equivalent call
			local fiberFromText = createFiberFromText(p3, return_.mode, p4)
			fiberFromText.return_ = return_
			return fiberFromText
		else
			deleteRemainingChildren(return_, p2.sibling) -- inferred equivalent call
			local workInProgress = useFiber(p2, p3) -- inferred equivalent call
			workInProgress.return_ = return_
			return workInProgress
		end
	end

	local function reconcileSingleElement(return_, p2, data, p3)
		local key = data.key
		local v3 = p2

		while v3 ~= nil do
			if v3.key == key then
				if v3.tag == Fragment then
					if data.type == REACT_FRAGMENT_TYPE then
						deleteRemainingChildren(return_, v3.sibling) -- inferred equivalent call
						local result = useFiber(v3, data.props.children) -- inferred equivalent call
						result.return_ = return_

						if __DEV__ then
							result._debugSource = data._source
							result._debugOwner = data._owner
						end

						return result
					end
				elseif v3.elementType == data.type or __DEV__ and isCompatibleFamilyForHotReloading(v3, data) then
					deleteRemainingChildren(return_, v3.sibling) -- inferred equivalent call
					local result = useFiber(v3, data.props) -- inferred equivalent call

					if ReactFeatureFlags.enableWorkLoopTrims then
						local ref = coerceRef(return_, v3, data)

						if ref ~= nil or result.ref ~= nil then
							result.ref = ref
						end
					else
						result.ref = coerceRef(return_, v3, data)
					end

					result.return_ = return_

					if __DEV__ then
						result._debugSource = data._source
						result._debugOwner = data._owner
					end

					return result
				end

				if not p then
					break
				end

				while v3 ~= nil do
					deleteChild(return_, v3) -- inferred equivalent call
					v3 = v3.sibling
				end

				break
			end

			deleteChild(return_, v3) -- inferred equivalent call
			v3 = v3.sibling
		end

		if data.type == REACT_FRAGMENT_TYPE then
			local fiberFromFragment = createFiberFromFragment(data.props.children, return_.mode, p3, data.key)

			fiberFromFragment.return_ = return_
			return fiberFromFragment
		else
			local fiberFromElement = createFiberFromElement(data, return_.mode, p3)
			fiberFromElement.ref = coerceRef(return_, p2, data)
			fiberFromElement.return_ = return_
			return fiberFromElement
		end
	end

	local function reconcileSinglePortal(return_, data, data2, p2)
		local key = data2.key

		while data ~= nil do
			if data.key == key then
				if
					data.tag == HostPortal
					and data.stateNode.containerInfo == data2.containerInfo
					and data.stateNode.implementation == data2.implementation
				then
					deleteRemainingChildren(return_, data.sibling) -- inferred equivalent call
					local result = useFiber(data, data2.children or {}) -- inferred equivalent call
					result.return_ = return_
					return result
				end

				if not p then
					break
				end

				while data ~= nil do
					deleteChild(return_, data) -- inferred equivalent call
					data = data.sibling
				end

				break
			end

			deleteChild(return_, data) -- inferred equivalent call
			data = data.sibling
		end

		local fiberFromPortal = createFiberFromPortal(data2, return_.mode, p2)
		fiberFromPortal.return_ = return_
		return fiberFromPortal
	end

	local function reconcileChildFibers(return_, p2, data, p3)
		local typeName = type(data)
		local v3

		if data == nil or typeName ~= "table" or data.type ~= REACT_FRAGMENT_TYPE then
			v3 = false
		else
			v3 = data.key == nil
		end

		if v3 then
			data = data.props.children
			typeName = type(data)
		end

		local array = isArray(data)
		local v4

		if data == nil or typeName ~= "table" then
			v4 = false
		else
			v4 = not array
		end

		if v4 then
			local Typeof = data["$$typeof"]

			if Typeof == REACT_ELEMENT_TYPE then
				return placeSingleChild(reconcileSingleElement(return_, p2, data, p3)) -- inferred equivalent call
			elseif Typeof == REACT_PORTAL_TYPE then
				return placeSingleChild(reconcileSinglePortal(return_, p2, data, p3)) -- inferred equivalent call
			elseif Typeof == REACT_LAZY_TYPE and enableLazyElements then
				local payload = data._payload
				return reconcileChildFibers(return_, p2, data._init(payload), p3)
			end
		else
			if array then
				return reconcileChildrenArray(return_, p2, data, p3)
			end

			if typeName == "string" or typeName == "number" then
				return placeSingleChild(reconcileSingleTextNode(return_, p2, tostring(data), p3)) -- inferred equivalent call
			end
		end

		local iteratorFn = getIteratorFn(data)

		if iteratorFn then
			return reconcileChildrenIterator(return_, p2, data, p3, iteratorFn)
		end

		if __DEV__ and typeName == "function" then
			warnOnFunctionType(return_) -- inferred equivalent call
		end

		return deleteRemainingChildren(return_, p2) -- inferred equivalent call
	end

	return reconcileChildFibers
end

local New = {}
New.reconcileChildFibers = ChildReconciler(true)
New.mountChildFibers = ChildReconciler(false)

function New.cloneChildFibers(_, return_)
	if return_.child == nil then
		return
	end

	local v3 = return_.child
	local child = createWorkInProgress(v3, v3.pendingProps)
	return_.child = child

	child.return_ = return_

	while v3.sibling ~= nil do
		v3 = v3.sibling
		child.sibling = createWorkInProgress(v3, v3.pendingProps)

		child = child.sibling
		child.return_ = return_
	end

	child.sibling = nil
end

function New.resetChildFibers(p, p2)
	local v3 = p.child

	while v3 ~= nil do
		resetWorkInProgress(v3, p2)
		v3 = v3.sibling
	end
end

return New
