local function unimplemented(s1: string) -- line: 12
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. s1)
	error("FIXME (roblox): " .. s1 .. " is unimplemented")
end

local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local __DEV__ = ReactGlobals.__DEV__
local createRef = require(ParentParent.React).createRef
local createBinding = require(ParentParent.React).createBinding
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local ReactHookEffectTags = require(script.Parent.ReactHookEffectTags)
local ReactSharedInternals = require(ParentParent.Shared).ReactSharedInternals
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local enableNewReconciler = ReactFeatureFlags.enableNewReconciler
local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local DebugTracingMode = require(script.Parent.ReactTypeOfMode).DebugTracingMode
local NoLane = ReactFiberLane.NoLane
local NoLanes = ReactFiberLane.NoLanes
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local mergeLanes = ReactFiberLane.mergeLanes
local removeLanes = ReactFiberLane.removeLanes
local markRootEntangled = ReactFiberLane.markRootEntangled
local markRootMutableRead = ReactFiberLane.markRootMutableRead
local readContext = require(script.Parent["ReactFiberNewContext.new"]).readContext
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Update = ReactFiberFlags.Update
local Passive = ReactFiberFlags.Passive
local PassiveStatic = ReactFiberFlags.PassiveStatic
local MountLayoutDev = ReactFiberFlags.MountLayoutDev
local MountPassiveDev = ReactFiberFlags.MountPassiveDev
local HasEffect = ReactHookEffectTags.HasEffect
local Layout = ReactHookEffectTags.Layout
local Passive2 = ReactHookEffectTags.Passive
local lib = require(script.Parent["ReactFiberWorkLoop.new"])
local warnIfNotCurrentlyActingUpdatesInDEV = lib.warnIfNotCurrentlyActingUpdatesInDEV
local scheduleUpdateOnFiber = lib.scheduleUpdateOnFiber
local warnIfNotScopedWithMatchingAct = lib.warnIfNotScopedWithMatchingAct
local requestEventTime = lib.requestEventTime
local requestUpdateLane = lib.requestUpdateLane
local markSkippedUpdateLanes = lib.markSkippedUpdateLanes
local getWorkInProgressRoot = lib.getWorkInProgressRoot
local warnIfNotCurrentlyActingEffectsInDEV = lib.warnIfNotCurrentlyActingEffectsInDEV
local invariant = require(ParentParent.Shared).invariant
local getComponentName = require(ParentParent.Shared).getComponentName

local function is(p1, p2) -- line: 117
	return p1 == p2 and (p1 ~= 0 or 1 / p1 == 1 / p2) or p1 ~= p1 and p2 ~= p2
end

local markWorkInProgressReceivedUpdate = require(script.Parent["ReactFiberBeginWork.new"]).markWorkInProgressReceivedUpdate
local getIsHydrating = require(script.Parent["ReactFiberHydrationContext.new"]).getIsHydrating
local makeClientId = require(script.Parent.ReactFiberHostConfig).makeClientId
local lib2 = require(script.Parent["ReactMutableSource.new"])
local warnAboutMultipleRenderersDEV = lib2.warnAboutMultipleRenderersDEV
local getWorkInProgressVersion = lib2.getWorkInProgressVersion
local setWorkInProgressVersion = lib2.setWorkInProgressVersion
local markSourceAsDirty = lib2.markSourceAsDirty
local logStateUpdateScheduled = require(script.Parent.DebugTracing).logStateUpdateScheduled
local markStateUpdateScheduled = require(script.Parent.SchedulingProfiler).markStateUpdateScheduled
local ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
local v61 = require(ParentParent.SafeFlags).createGetFFlag("ReactCleanQueueOnUpdateBailout")()
local t1 = nil

if __DEV__ then
	t1 = {}
end

local t2 = {}
local u64 = NoLanes
local u65 = nil
local u66 = nil
local u67 = nil
local u68 = false
local u69 = false
local u70 = nil
local t4 = nil
local n1 = 0
local t53 = nil
local t60 = nil
local t67 = nil
local t74 = nil
local t81 = nil
local t88 = nil
local t95 = nil

local function getHighestIndex(t3: {[any]: any}) -- line: 265
	local n2 = 0

	for v105, _ in t3 do
		if n2 < v105 then
			n2 = v105
		end
	end

	return n2
end
local function isArrayOrSparseArray(p3) -- line: 275
	if type(p3) ~= "table" then
		return false
	end

	for v108, _ in p3 do
		if type(v108) ~= "number" then
			return false
		end
	end

	return true
end
local function mountHookTypesDev() -- line: 287
	-- upvalues: __DEV__ (copy), u70 (ref), t4 (ref)
	if __DEV__ then
		local v110 = u70

		if t4 == nil then
			t4 = { v110 }

			return
		end

		table.insert(t4, v110)
	end
end

function updateHookTypesDev() -- line: 300
	-- upvalues: __DEV__ (copy), u70 (ref), t4 (ref), n1 (ref)
	if __DEV__ then
		local v111 = u70

		if t4 ~= nil then
			n1 += 1

			if v111 ~= t4[n1] then
				warnOnHookMismatchInDev(v111)
			end
		end
	end
end

local function checkDepsAreArrayDev(p4) -- line: 314
	-- upvalues: __DEV__ (copy), console (copy), u70 (ref)
	if __DEV__ and p4 ~= nil then
		local v113, g116

		if type(p4) ~= "table" then
			v113 = false
		else
			g116 = nil
			v113 = nil

			for v114, _ in p4 do
				if type(v114) ~= "number" then
					v113 = false
					g116 = true
				end

				if g116 then
					break
				end
			end

			if not g116 then
				v113 = true
			end
		end

		g116 = false

		if not v113 then
			console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(p4)))
		end
	end
end

function warnOnHookMismatchInDev(p5) -- line: 329
	-- upvalues: __DEV__ (copy), getComponentName (copy), u65 (ref), t1 (ref), t4 (ref), n1 (ref), console (copy)
	if __DEV__ then
		local v118 = getComponentName(u65.type) or "Component"

		if not t1[v118] then
			t1[v118] = true

			if t4 ~= nil then
				local s2 = ""

				for i = 1, n1 do
					local v121 = t4[i]
					local v122 = if i ~= n1 then v121 else p5
					local v123 = tostring(i) .. ". " .. (v121 or "undefined")

					while string.len(v123) < 30 do
						v123 ..= " "
					end

					s2 ..= v123 .. v122 .. "\n"
				end

				console.error("React has detected a change in the order of Hooks called by %s. This will lead to bugs and errors if not fixed. For more information, read the Rules of Hooks: https://reactjs.org/link/rules-of-hooks\n\n   Previous render            Next render\n   ------------------------------------------------------\n%s   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n", v118, s2)
			end
		end
	end
end

local function throwInvalidHookError() -- line: 381
	-- upvalues: Error (copy)
	error(Error.new("Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n1. You might have mismatching versions of React and the renderer (such as React DOM)\n2. You might be breaking the Rules of Hooks\n3. You might have more than one copy of React in the same app\nSee https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem."))
end
local function areHookInputsEqual(t5: {[any]: any}, t6: {[any]: any}) -- line: 396
	-- upvalues: __DEV__ (copy), console (copy), u70 (ref)
	if not __DEV__ then
	end

	if t6 == nil then
		if __DEV__ then
			console.error("%s received a final argument during this render, but not during the previous render. Even though the final argument is optional, its type cannot change between renders.", u70)
		end

		return false
	end

	local n3 = 0

	for v127, _ in t5 do
		if n3 < v127 then
			n3 = v127
		end
	end

	local n4 = 0

	for v130, _ in t6 do
		if n4 < v130 then
			n4 = v130
		end
	end

	if n3 ~= n4 then
		return false
	end

	for i = 1, math.min(n4, n3) do
		local v133 = t5[i]
		local v134 = t6[i]

		if (v133 ~= v134 or v133 == 0 and 1 / v133 ~= 1 / v134) and (v133 == v133 or v134 == v134) then
			return false
		end
	end

	return true
end

function t2.bailoutHooks(p6, p7, p8) -- line: 460
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), MountPassiveDev (copy), Passive (copy), MountLayoutDev (copy), Update (copy), removeLanes (copy)
	p7.updateQueue = p6.updateQueue

	if __DEV__ and enableDoubleInvokingEffects then
		p7.flags = bit32.band(p7.flags, (bit32.bnot((bit32.bor(MountPassiveDev, Passive, MountLayoutDev, Update)))))
	else
		p7.flags = bit32.band(p7.flags, (bit32.bnot((bit32.bor(Passive, Update)))))
	end

	p6.lanes = removeLanes(p6.lanes, p8)
end

local u86 = false

function t2.resetHooksAfterThrow() -- line: 485
	-- upvalues: ReactCurrentDispatcher (copy), t2 (copy), u68 (ref), u65 (ref), u64 (ref), NoLanes (copy), u66 (ref), u67 (ref), __DEV__ (copy), t4 (ref), n1 (ref), u70 (ref), u86 (ref), u69 (ref)
	ReactCurrentDispatcher.current = t2.ContextOnlyDispatcher

	if u68 then
		local memoizedState = u65.memoizedState

		while memoizedState ~= nil do
			local queue = memoizedState.queue

			if queue ~= nil then
				queue.pending = nil
			end

			memoizedState = memoizedState.next
		end

		u68 = false
	end

	u64 = NoLanes
	u65 = nil
	u66 = nil
	u67 = nil

	if __DEV__ then
		t4 = nil
		n1 = 0
		u70 = nil
		u86 = false
	end

	u69 = false
end

local function mountWorkInProgressHook() -- line: 530
	-- upvalues: u67 (ref), u65 (ref)
	local t7 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t7
		u67 = t7
	else
		u67.next = t7
		u67 = t7
	end

	return u67
end
local function updateWorkInProgressHook() -- line: 553
	-- upvalues: u66 (ref), u65 (ref), u67 (ref), Error (copy)
	local v142

	if u66 == nil then
		local alternate = u65.alternate

		v142 = if alternate == nil then nil else alternate.memoizedState
	else
		v142 = u66.next
	end

	local v143 = if u67 ~= nil then u67.next else u65.memoizedState

	if v143 ~= nil then
		u67 = v143

		local _ = u67.next

		u66 = v142
	else
		if v142 == nil then
			error(Error.new("Rendered more hooks than during the previous render."))
		end

		u66 = v142

		local t8 = {
			next = nil,
			memoizedState = u66.memoizedState,
			baseState = u66.baseState,
			baseQueue = u66.baseQueue,
			queue = u66.queue
		}

		if u67 == nil then
			u67 = t8
			u65.memoizedState = t8
		else
			u67.next = t8
			u67 = t8
		end
	end

	return u67
end

function basicStateReducer(p9, p10) -- line: 628
	if type(p10) == "function" then
		return p10(p9)
	end

	return p10
end
function mountReducer(p11: ((...any) -> ...any), p12, p13: ((...any) -> ...any)?) -- line: 637
	-- upvalues: u67 (ref), u65 (ref)
	local t9 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t9
		u67 = t9
	else
		u67.next = t9
		u67 = t9
	end

	local v152 = u67
	local v153 = if p13 == nil then p12 else p13(p12)

	v152.baseState = v153
	v152.memoizedState = v152.baseState

	local t10 = {
		pending = nil,
		dispatch = nil,
		lastRenderedReducer = p11,
		lastRenderedState = v153
	}

	v152.queue = t10

	local v155 = u65

	local function v156(p14, ...) -- line: 664
		-- upvalues: v155 (copy), t10 (copy)
		dispatchAction(v155, t10, p14, ...)
	end

	t10.dispatch = v156

	return v152.memoizedState, v156
end
function updateReducer(p15: ((...any) -> ...any), _, _: ((...any) -> ...any)?) -- line: 674
	-- upvalues: updateWorkInProgressHook (copy), u66 (ref), u64 (ref), u65 (ref), mergeLanes (copy), markSkippedUpdateLanes (copy), NoLane (copy), markWorkInProgressReceivedUpdate (copy)
	local v160 = updateWorkInProgressHook()
	local queue = v160.queue

	assert(queue ~= nil, "Should have a queue. This is likely a bug in React. Please file an issue.")
	queue.lastRenderedReducer = p15

	local v162 = u66
	local baseQueue = v162.baseQueue
	local pending = queue.pending

	if pending ~= nil then
		if baseQueue ~= nil then
			local next = baseQueue.next

			baseQueue.next = pending.next
			pending.next = next
		end

		baseQueue = pending
		v162.baseQueue = baseQueue
		queue.pending = nil
	end

	if baseQueue ~= nil then
		local next = baseQueue.next
		local baseState = v162.baseState
		local v168 = nil
		local v169 = nil
		local v170 = nil
		local v171 = next

		repeat
			local lane = v171.lane

			if lane ~= bit32.band(u64, lane) then
				local t11 = {
					next = nil,
					lane = lane,
					action = v171.action,
					eagerReducer = v171.eagerReducer,
					eagerState = v171.eagerState
				}

				if v170 == nil then
					v170 = t11
					v169 = v170
					v168 = baseState
				else
					v170.next = t11
					v170 = v170.next
				end

				u65.lanes = mergeLanes(u65.lanes, lane)
				markSkippedUpdateLanes(lane)
			else
				if v170 ~= nil then
					v170.next = {
						next = nil,
						lane = NoLane,
						action = v171.action,
						eagerReducer = v171.eagerReducer,
						eagerState = v171.eagerState
					}
					v170 = v170.next
				end

				baseState = if p15 ~= v171.eagerReducer then p15(baseState, v171.action) else v171.eagerState
			end

			v171 = v171.next
		until v171 == nil or v171 == next

		if v170 == nil then
			v168 = baseState
		else
			v170.next = v169
		end

		local memoizedState = v160.memoizedState

		if (baseState ~= memoizedState or baseState == 0 and 1 / baseState ~= 1 / memoizedState) and (baseState == baseState or memoizedState == memoizedState) then
			markWorkInProgressReceivedUpdate()
		end

		v160.memoizedState = baseState
		v160.baseState = v168
		v160.baseQueue = v170
		queue.lastRenderedState = baseState
	end

	local dispatch = queue.dispatch

	return v160.memoizedState, dispatch
end
function rerenderReducer(p18: ((...any) -> ...any), _, _: ((...any) -> ...any)?) -- line: 815
	-- upvalues: updateWorkInProgressHook (copy), markWorkInProgressReceivedUpdate (copy)
	local v179 = updateWorkInProgressHook()
	local queue = v179.queue

	assert(queue ~= nil, "Should have a queue. This is likely a bug in React. Please file an issue.")
	queue.lastRenderedReducer = p18

	local dispatch = queue.dispatch
	local pending = queue.pending
	local memoizedState = v179.memoizedState

	if pending ~= nil then
		queue.pending = nil

		local next = pending.next
		local v185 = next

		repeat
			memoizedState = p18(memoizedState, v185.action)
			v185 = v185.next
		until v185 == next

		local memoizedState2 = v179.memoizedState

		if (memoizedState ~= memoizedState2 or memoizedState == 0 and 1 / memoizedState ~= 1 / memoizedState2) and (memoizedState == memoizedState or memoizedState2 == memoizedState2) then
			markWorkInProgressReceivedUpdate()
		end

		v179.memoizedState = memoizedState

		if v179.baseQueue == nil then
			v179.baseState = memoizedState
		end

		queue.lastRenderedState = memoizedState
	end

	return memoizedState, dispatch
end
function readFromUnsubcribedMutableSource(p21, p22, p23) -- line: 880
	-- upvalues: __DEV__ (copy), warnAboutMultipleRenderersDEV (copy), getWorkInProgressVersion (copy), isSubsetOfLanes (copy), u64 (ref), setWorkInProgressVersion (copy), console (copy), markSourceAsDirty (copy), Error (copy)
	if __DEV__ then
		warnAboutMultipleRenderersDEV(p22)
	end

	local v190 = p22._getVersion(p22._source)
	local v191 = getWorkInProgressVersion(p22)
	local v192

	if v191 ~= nil then
		v192 = v191 == v190
	else
		v192 = isSubsetOfLanes(u64, p21.mutableReadLanes)

		if v192 then
			setWorkInProgressVersion(p22, v190)
		end
	end

	if v192 then
		local v193 = p23(p22._source)

		if __DEV__ and type(v193) == "function" then
			console.error("Mutable source should not return a function as the snapshot value. Functions may close over mutable values and cause tearing.")
		end

		return v193
	end

	markSourceAsDirty(p22)
	error(Error.new("Cannot read from mutable source during the current render without tearing. This is a bug in React. Please file an issue."))
end
function useMutableSource(t12: {[any]: any}, p24, p25, p26) -- line: 963
	-- upvalues: getWorkInProgressRoot (copy), invariant (copy), ReactCurrentDispatcher (copy), u67 (ref), u65 (ref), __DEV__ (copy), console (copy), requestUpdateLane (copy), markRootMutableRead (copy), markRootEntangled (copy)
	local v198 = getWorkInProgressRoot()

	invariant(v198 ~= nil, "Expected a work-in-progress root. This is a bug in React. Please file an issue.")

	local _getVersion = p24._getVersion
	local v200 = _getVersion(p24._source)
	local current = ReactCurrentDispatcher.current

	assert(current ~= nil, "dispatcher was nil, this is a bug in React")

	local v202, u203 = current.useState(function() -- line: 988
		-- upvalues: v198 (copy), p24 (copy), p25 (copy)
		return readFromUnsubcribedMutableSource(v198, p24, p25)
	end)
	local u204 = v202
	local v205 = u67
	local memoizedState = t12.memoizedState

	if memoizedState.refs == nil then
		error((tostring(debug.traceback())))
	end

	local refs = memoizedState.refs
	local getSnapshot = refs.getSnapshot
	local source = memoizedState.source
	local subscribe = memoizedState.subscribe
	local v211 = u65

	t12.memoizedState = {
		refs = refs,
		source = p24,
		subscribe = p26
	}
	current.useEffect(function() -- line: 1017
		-- upvalues: refs (copy), p25 (copy), u203 (ref), _getVersion (copy), p24 (copy), v200 (copy), __DEV__ (copy), console (copy), u204 (ref), requestUpdateLane (copy), v211 (copy), markRootMutableRead (copy), v198 (copy), markRootEntangled (copy)
		refs.getSnapshot = p25
		refs.setSnapshot = u203

		local v655 = _getVersion(p24._source)
		local v656 = v200

		if (v656 ~= v655 or v656 == 0 and 1 / v656 ~= 1 / v655) and (v656 == v656 or v655 == v655) then
			local v657 = p25(p24._source)

			if __DEV__ and type(v657) == "function" then
				console.error("Mutable source should not return a function as the snapshot value. Functions may close over mutable values and cause tearing.")
			end

			local v658 = u204

			if (v658 ~= v657 or v658 == 0 and 1 / v658 ~= 1 / v657) and (v658 == v658 or v657 == v657) then
				u203(v657)

				local v659 = requestUpdateLane(v211)

				markRootMutableRead(v198, v659)
			end

			markRootEntangled(v198, v198.mutableReadLanes)
		end
	end, {
		p25,
		p24,
		p26
	})
	current.useEffect(function() -- line: 1055
		-- upvalues: refs (copy), p24 (copy), requestUpdateLane (copy), v211 (copy), markRootMutableRead (copy), v198 (copy), p26 (copy), __DEV__ (copy), console (copy)
		local v660 = p26(p24._source, function() -- line: 1056
			-- upvalues: refs (copy), p24 (copy), requestUpdateLane (copy), v211 (copy), markRootMutableRead (copy), v198 (copy)
			local getSnapshot2 = refs.getSnapshot
			local setSnapshot = refs.setSnapshot
			local ok, result = pcall(function() -- line: 1061
				-- upvalues: setSnapshot (copy), getSnapshot2 (copy), p24 (copy), requestUpdateLane (copy), v211 (copy), markRootMutableRead (copy), v198 (copy)
				setSnapshot(getSnapshot2(p24._source))

				local v666 = requestUpdateLane(v211)

				markRootMutableRead(v198, v666)
			end)

			if not ok then
				setSnapshot(function() -- line: 1075
					-- upvalues: result (copy)
					error(result)
				end)
			end
		end)

		if __DEV__ and type(v660) ~= "function" then
			console.error("Mutable source subscribe function must return an unsubscribe function.")
		end

		return v660
	end, {
		p24,
		p26
	})

	if (getSnapshot ~= p25 or getSnapshot == 0 and 1 / getSnapshot ~= 1 / p25) and (getSnapshot == getSnapshot or p25 == p25) or (source ~= p24 or source == 0 and 1 / source ~= 1 / p24) and (source == source or p24 == p24) or (subscribe ~= p26 or subscribe == 0 and 1 / subscribe ~= 1 / p26) and (subscribe == subscribe or p26 == p26) then
		local t13 = {
			pending = nil,
			dispatch = nil,
			lastRenderedReducer = basicStateReducer,
			lastRenderedState = u204
		}
		local v213 = u65

		function u203(...) -- line: 1124
			-- upvalues: v213 (copy), t13 (copy)
			dispatchAction(v213, t13, ...)
		end

		t13.dispatch = u203
		v205.queue = t13
		v205.baseQueue = nil
		u204 = readFromUnsubcribedMutableSource(v198, p24, p25)
		v205.baseState = u204
		v205.memoizedState = v205.baseState
	end

	return u204
end
function mountMutableSource(p27, p28, p29) -- line: 1138
	-- upvalues: u67 (ref), u65 (ref)
	local t14 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t14
		u67 = t14
	else
		u67.next = t14
		u67 = t14
	end

	local v218 = u67

	v218.memoizedState = {
		refs = {
			setSnapshot = nil,
			getSnapshot = p28
		},
		source = p27,
		subscribe = p29
	}

	return useMutableSource(v218, p27, p28, p29)
end
function updateMutableSource(p30, p31, p32) -- line: 1161
	-- upvalues: updateWorkInProgressHook (copy)
	local v222 = updateWorkInProgressHook()

	return useMutableSource(v222, p30, p31, p32)
end
function mountState(p33) -- line: 1176
	-- upvalues: u67 (ref), u65 (ref)
	local t15 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t15
		u67 = t15
	else
		u67.next = t15
		u67 = t15
	end

	local v225 = u67

	if type(p33) == "function" then
		p33 = p33()
	end

	v225.baseState = p33
	v225.memoizedState = v225.baseState

	local t16 = {
		pending = nil,
		dispatch = nil,
		lastRenderedReducer = nil,
		lastRenderedState = p33,
		lastRenderedReducer = basicStateReducer
	}

	v225.queue = t16

	local v227 = u65

	local function v228(p34, ...) -- line: 1198
		-- upvalues: v227 (copy), t16 (copy)
		dispatchAction(v227, t16, p34, ...)
	end

	t16.dispatch = v228

	return v225.memoizedState, v228
end
function updateState(p35) -- line: 1207
	return updateReducer(basicStateReducer, p35)
end
function rerenderState(p36) -- line: 1211
	return rerenderReducer(basicStateReducer, p36)
end

local function pushEffect(p37, p38, p39, p40) -- line: 1215
	-- upvalues: u65 (ref)
	local t17 = {
		next = nil,
		tag = p37,
		create = p38,
		destroy = p39,
		deps = p40
	}
	local updateQueue = u65.updateQueue

	if updateQueue == nil then
		local t18 = {
			lastEffect = nil
		}

		u65.updateQueue = t18
		t17.next = t17
		t18.lastEffect = t17

		return t17
	end

	local lastEffect = updateQueue.lastEffect

	if lastEffect == nil then
		updateQueue.lastEffect = t17
		t17.next = t17

		return t17
	end

	local next = lastEffect.next

	lastEffect.next = t17
	t17.next = next
	updateQueue.lastEffect = t17

	return t17
end

function mountBinding(p41) -- line: 1251
	-- upvalues: u67 (ref), u65 (ref), createBinding (copy)
	local t19 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t19
		u67 = t19
	else
		u67.next = t19
		u67 = t19
	end

	local v242 = u67
	local v243, v244 = createBinding(p41)

	v242.memoizedState = {
		v243,
		v244
	}

	return v243, v244
end
function updateBinding(_) -- line: 1260
	-- upvalues: updateWorkInProgressHook (copy)
	return unpack(updateWorkInProgressHook().memoizedState)
end
function mountRef(p43) -- line: 1265
	-- upvalues: u67 (ref), u65 (ref), createRef (copy)
	local t20 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t20
		u67 = t20
	else
		u67.next = t20
		u67 = t20
	end

	local v248 = u67
	local v249 = createRef()

	v249.current = p43
	v248.memoizedState = v249

	return v249
end
function updateRef(_) -- line: 1277
	-- upvalues: updateWorkInProgressHook (copy)
	return updateWorkInProgressHook().memoizedState
end

local function mountEffectImpl(p45, p46, p47, p48) -- line: 1282
	-- upvalues: u67 (ref), u65 (ref), pushEffect (copy), HasEffect (copy)
	local t21 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t21
		u67 = t21
	else
		u67.next = t21
		u67 = t21
	end

	local v256 = u67

	u65.flags = bit32.bor(u65.flags, p45)
	v256.memoizedState = pushEffect(bit32.bor(HasEffect, p46), p47, nil, p48)
end

function updateEffectImpl(p49, p50, p51, t22: {[any]: any}?) -- line: 1294
	-- upvalues: updateWorkInProgressHook (copy), u66 (ref), areHookInputsEqual (copy), pushEffect (copy), u65 (ref), HasEffect (copy)
	local v261 = updateWorkInProgressHook()
	local destroy = nil

	if u66 ~= nil then
		local memoizedState = u66.memoizedState

		destroy = memoizedState.destroy

		if t22 ~= nil then
			local deps = memoizedState.deps

			if areHookInputsEqual(t22, deps) then
				v261.memoizedState = pushEffect(p50, p51, destroy, t22)

				return
			end
		end
	end

	u65.flags = bit32.bor(u65.flags, p49)
	v261.memoizedState = pushEffect(bit32.bor(HasEffect, p50), p51, destroy, t22)
end

local function mountEffect(p52: ((...any) -> ...any), t23: {[any]: any}?) -- line: 1320
	-- upvalues: __DEV__ (copy), ReactGlobals (copy), warnIfNotCurrentlyActingEffectsInDEV (copy), u65 (ref), enableDoubleInvokingEffects (copy), MountPassiveDev (copy), Passive (copy), PassiveStatic (copy), Passive2 (copy), u67 (ref), pushEffect (copy), HasEffect (copy)
	if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
		warnIfNotCurrentlyActingEffectsInDEV(u65)
	end

	if __DEV__ and enableDoubleInvokingEffects then
		local v267 = bit32.bor(MountPassiveDev, Passive, PassiveStatic)
		local v268 = Passive2
		local t24 = {
			memoizedState = nil,
			baseState = nil,
			baseQueue = nil,
			queue = nil,
			next = nil
		}

		if u67 == nil then
			u65.memoizedState = t24
			u67 = t24
		else
			u67.next = t24
			u67 = t24
		end

		local v270 = u67

		u65.flags = bit32.bor(u65.flags, v267)
		v270.memoizedState = pushEffect(bit32.bor(HasEffect, v268), p52, nil, t23)

		return
	end

	local v271 = bit32.bor(Passive, PassiveStatic)
	local v272 = Passive2
	local t25 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t25
		u67 = t25
	else
		u67.next = t25
		u67 = t25
	end

	local v274 = u67

	u65.flags = bit32.bor(u65.flags, v271)
	v274.memoizedState = pushEffect(bit32.bor(HasEffect, v272), p52, nil, t23)
end
local function updateEffect(p53: ((...any) -> ...any), t26: {[any]: any}?) -- line: 1350
	-- upvalues: __DEV__ (copy), ReactGlobals (copy), warnIfNotCurrentlyActingEffectsInDEV (copy), u65 (ref), Passive (copy), Passive2 (copy)
	if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
		warnIfNotCurrentlyActingEffectsInDEV(u65)
	end

	updateEffectImpl(Passive, Passive2, p53, t26)
end
local function mountLayoutEffect(p54: ((...any) -> ...any), t27: {[any]: any}?) -- line: 1365
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), MountLayoutDev (copy), Update (copy), Layout (copy), u67 (ref), u65 (ref), pushEffect (copy), HasEffect (copy)
	if __DEV__ and enableDoubleInvokingEffects then
		local v279 = bit32.bor(MountLayoutDev, Update)
		local v280 = Layout
		local t28 = {
			memoizedState = nil,
			baseState = nil,
			baseQueue = nil,
			queue = nil,
			next = nil
		}

		if u67 == nil then
			u65.memoizedState = t28
			u67 = t28
		else
			u67.next = t28
			u67 = t28
		end

		local v282 = u67

		u65.flags = bit32.bor(u65.flags, v279)
		v282.memoizedState = pushEffect(bit32.bor(HasEffect, v280), p54, nil, t27)

		return
	end

	local v283 = Update
	local v284 = Layout
	local t29 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t29
		u67 = t29
	else
		u67.next = t29
		u67 = t29
	end

	local v286 = u67

	u65.flags = bit32.bor(u65.flags, v283)
	v286.memoizedState = pushEffect(bit32.bor(HasEffect, v284), p54, nil, t27)
end
local function updateLayoutEffect(p55: ((...any) -> ...any), t30: {[any]: any}?) -- line: 1382
	-- upvalues: Update (copy), Layout (copy)
	updateEffectImpl(Update, Layout, p55, t30)
end

function imperativeHandleEffect(p56: ((...any) -> ...any), p57) -- line: 1390
	-- upvalues: __DEV__ (copy), Object (copy), console (copy), Array (copy)
	if p57 ~= nil and type(p57) == "function" then
		p57((p56()))

		return function() -- line: 1399
			-- upvalues: p57 (copy)
			return p57(nil)
		end
	end

	if p57 ~= nil then
		if __DEV__ and (getmetatable(p57) == nil or #Object.keys(p57) ~= 0) then
			console.error("Expected useImperativeHandle() first argument to either be a ref callback or React.createRef() object. Instead received: %s.", "an object with keys {" .. Array.join(Object.keys(p57), ", ") .. "}")
		end

		p57.current = p56()

		return function() -- line: 1424
			-- upvalues: p57 (copy)
			p57.current = nil
		end
	end

	return nil
end
function mountImperativeHandle(p58, p59: ((...any) -> ...any), t31: {[any]: any}?) -- line: 1433
	-- upvalues: __DEV__ (copy), console (copy), Array (copy), enableDoubleInvokingEffects (copy), mountEffectImpl (copy), MountLayoutDev (copy), Update (copy), Layout (copy)
	if __DEV__ and type(p59) ~= "function" then
		console.error("Expected useImperativeHandle() second argument to be a function that creates a handle. Instead received: %s.", p59 == nil and "nil" or type(p59))
	end

	local v294 = if t31 == nil then nil else Array.concat(t31, { p58 })

	if __DEV__ and enableDoubleInvokingEffects then
		return mountEffectImpl(bit32.bor(MountLayoutDev, Update), Layout, function() -- line: 1456
			-- upvalues: p59 (copy), p58 (copy)
			return imperativeHandleEffect(p59, p58)
		end, v294)
	end

	return mountEffectImpl(Update, Layout, function() -- line: 1462
		-- upvalues: p59 (copy), p58 (copy)
		return imperativeHandleEffect(p59, p58)
	end, v294)
end
function updateImperativeHandle(p60, p61: ((...any) -> ...any), t32: {[any]: any}?) -- line: 1468
	-- upvalues: __DEV__ (copy), console (copy), Update (copy), Layout (copy)
	if __DEV__ and type(p61) ~= "function" then
		local s3 = "nil"

		if p61 then
			s3 = type(p61)
		end

		console.error("Expected useImperativeHandle() second argument to be a function that creates a handle. Instead received: %s.", s3)
	end

	local v299 = nil

	if t32 ~= nil then
		v299 = table.clone(t32)
		table.insert(v299, p60)
	end

	return updateEffectImpl(Update, Layout, function() -- line: 1495
		-- upvalues: p61 (copy), p60 (copy)
		return imperativeHandleEffect(p61, p60)
	end, v299)
end
function mountDebugValue(_, _: ((...any) -> ...any)?) -- line: 1500
end

local _mountDebugValue = mountDebugValue

function mountCallback(p64, t33: {[any]: any}?) -- line: 1508
	-- upvalues: u67 (ref), u65 (ref)
	local t34 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t34
		u67 = t34
	else
		u67.next = t34
		u67 = t34
	end

	u67.memoizedState = {
		p64,
		t33
	}

	return p64
end
function updateCallback(p65, t35: {[any]: any}?) -- line: 1516
	-- upvalues: updateWorkInProgressHook (copy), areHookInputsEqual (copy)
	local v307 = updateWorkInProgressHook()
	local memoizedState = v307.memoizedState

	if memoizedState ~= nil and t35 ~= nil then
		local v309 = memoizedState[2]

		if areHookInputsEqual(t35, v309) then
			return memoizedState[1]
		end
	end

	v307.memoizedState = {
		p65,
		t35
	}

	return p65
end
function mountMemo(p66: ((...any) -> ...any), t36: {[any]: any}?) -- line: 1535
	-- upvalues: u67 (ref), u65 (ref)
	local t37 = {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if u67 == nil then
		u65.memoizedState = t37
		u67 = t37
	else
		u67.next = t37
		u67 = t37
	end

	local v313 = u67
	local t38 = { p66() }

	v313.memoizedState = {
		t38,
		t36
	}

	return unpack(t38)
end
function updateMemo(p67: ((...any) -> ...any), t39: {[any]: any}?) -- line: 1547
	-- upvalues: updateWorkInProgressHook (copy), areHookInputsEqual (copy)
	local v317 = updateWorkInProgressHook()
	local memoizedState = v317.memoizedState

	if memoizedState ~= nil and t39 ~= nil then
		local v319 = memoizedState[2]

		if areHookInputsEqual(t39, v319) then
			return unpack(memoizedState[1])
		end
	end

	local t40 = { p67() }

	v317.memoizedState = {
		t40,
		t39
	}

	return unpack(t40)
end
function t2.getIsUpdatingOpaqueValueInRenderPhaseInDEV() -- line: 1697
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		return false
	end

	return nil
end
function mountOpaqueIdentifier() -- line: 1719
	-- upvalues: __DEV__ (copy), console (copy), makeClientId (copy), getIsHydrating (copy)
	local v321 = nil

	if __DEV__ then
		console.warn("!!! unimplemented: warnOnOpaqueIdentifierAccessInDEV")
	else
		v321 = makeClientId
	end

	if getIsHydrating() then
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: ReactFiberHooks: getIsHydrating() true")
		error("FIXME (roblox): ReactFiberHooks: getIsHydrating() true is unimplemented")

		return nil
	end

	local v322 = v321()

	mountState(v322)

	return v322
end
function updateOpaqueIdentifier() -- line: 1786
	local v323, _ = updateState(nil)

	return v323
end
function rerenderOpaqueIdentifier() -- line: 1791
	local v325, _ = rerenderState(nil)

	return v325
end
function dispatchAction(p68, t41: {[any]: any}, p69, ...) -- line: 1796
	-- upvalues: __DEV__ (copy), console (copy), requestEventTime (copy), requestUpdateLane (copy), u65 (ref), u68 (ref), u69 (ref), NoLanes (copy), ReactCurrentDispatcher (copy), t88 (ref), v61 (copy), ReactGlobals (copy), warnIfNotScopedWithMatchingAct (copy), warnIfNotCurrentlyActingUpdatesInDEV (copy), scheduleUpdateOnFiber (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logStateUpdateScheduled (copy), enableSchedulingProfiler (copy), markStateUpdateScheduled (copy)
	if __DEV__ then
		local v330 = nil

		if select("#", ...) == 1 then
			v330 = select(1, ...)
		end

		if type(v330) == "function" then
			console.error("State updates from the useState() and useReducer() Hooks don't support the second callback argument. To execute a side effect after rendering, declare it in the component body with useEffect().")
		end
	end

	local v331 = requestEventTime()
	local v332 = requestUpdateLane(p68)
	local t42 = {
		eagerReducer = nil,
		eagerState = nil,
		next = nil,
		lane = v332,
		action = p69
	}
	local pending = t41.pending

	if pending == nil then
		t42.next = t42
	else
		t42.next = pending.next
		pending.next = t42
	end

	t41.pending = t42

	local alternate = p68.alternate

	if p68 == u65 or alternate ~= nil and alternate == u65 then
		u68 = true
		u69 = true
	else
		if p68.lanes == NoLanes and (alternate == nil or alternate.lanes == NoLanes) then
			local lastRenderedReducer = t41.lastRenderedReducer

			if lastRenderedReducer ~= nil then
				local current = nil

				if __DEV__ then
					current = ReactCurrentDispatcher.current
					ReactCurrentDispatcher.current = t88
				end

				local lastRenderedState = t41.lastRenderedState
				local ok, result = pcall(lastRenderedReducer, lastRenderedState, p69)

				if ok then
					t42.eagerReducer = lastRenderedReducer
					t42.eagerState = result
				end

				if __DEV__ then
					ReactCurrentDispatcher.current = current
				end

				if result == lastRenderedState and (result ~= 0 or 1 / result == 1 / lastRenderedState) or result ~= result and lastRenderedState ~= lastRenderedState then
					if v61 then
						if pending == nil then
							t41.pending = nil

							return
						end

						pending.next = t42.next
						t41.pending = pending
					end

					return
				end

				if ok then
				end
			end
		end

		if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
			warnIfNotScopedWithMatchingAct(p68)
			warnIfNotCurrentlyActingUpdatesInDEV(p68)
		end

		scheduleUpdateOnFiber(p68, v332, v331)
	end

	if __DEV__ and enableDebugTracing and bit32.band(p68.mode, DebugTracingMode) ~= 0 then
		local v341 = getComponentName(p68.type) or "Unknown"

		logStateUpdateScheduled(v341, v332, p69)
	end

	if enableSchedulingProfiler then
		markStateUpdateScheduled(p68, v332)
	end
end

local t43 = {
	readContext = readContext,
	useCallback = throwInvalidHookError,
	useContext = throwInvalidHookError,
	useEffect = throwInvalidHookError,
	useImperativeHandle = throwInvalidHookError,
	useLayoutEffect = throwInvalidHookError,
	useMemo = throwInvalidHookError,
	useReducer = throwInvalidHookError,
	useRef = throwInvalidHookError,
	useBinding = throwInvalidHookError,
	useState = throwInvalidHookError,
	useDebugValue = throwInvalidHookError,
	useMutableSource = throwInvalidHookError,
	useOpaqueIdentifier = throwInvalidHookError,
	unstable_isNewReconciler = enableNewReconciler
}

t2.ContextOnlyDispatcher = t43

local t44 = {
	readContext = readContext,
	useCallback = mountCallback,
	useContext = readContext,
	useEffect = mountEffect,
	useImperativeHandle = mountImperativeHandle,
	useLayoutEffect = mountLayoutEffect,
	useMemo = mountMemo,
	useReducer = mountReducer,
	useRef = mountRef,
	useBinding = mountBinding,
	useState = mountState,
	useDebugValue = mountDebugValue,
	useMutableSource = mountMutableSource,
	useOpaqueIdentifier = mountOpaqueIdentifier,
	unstable_isNewReconciler = enableNewReconciler
}
local t45 = {
	readContext = readContext,
	useCallback = updateCallback,
	useContext = readContext,
	useEffect = updateEffect,
	useImperativeHandle = updateImperativeHandle,
	useLayoutEffect = updateLayoutEffect,
	useMemo = updateMemo,
	useReducer = updateReducer,
	useRef = updateRef,
	useBinding = updateBinding,
	useState = updateState,
	useDebugValue = _mountDebugValue,
	useMutableSource = updateMutableSource,
	useOpaqueIdentifier = updateOpaqueIdentifier,
	unstable_isNewReconciler = enableNewReconciler
}
local t46 = {
	readContext = readContext,
	useCallback = updateCallback,
	useContext = readContext,
	useEffect = updateEffect,
	useImperativeHandle = updateImperativeHandle,
	useLayoutEffect = updateLayoutEffect,
	useMemo = updateMemo,
	useReducer = rerenderReducer,
	useRef = updateRef,
	useBinding = updateBinding,
	useState = rerenderState,
	useDebugValue = _mountDebugValue,
	useMutableSource = updateMutableSource,
	useOpaqueIdentifier = rerenderOpaqueIdentifier,
	unstable_isNewReconciler = enableNewReconciler
}

if __DEV__ then
	t53 = {
		readContext = function(p70, p71) -- line: 2041
			-- upvalues: readContext (copy)
			return readContext(p70, p71)
		end,
		useCallback = function(p72, t47: {[any]: any}?) -- line: 2047
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), console (copy)
			u70 = "useCallback"

			local g350 = nil
			local v347 = nil

			if __DEV__ then
				local v346 = u70

				if t4 == nil then
					t4 = { v346 }
				else
					table.insert(t4, v346)
				end
			end

			if __DEV__ and t47 ~= nil then
				if type(t47) ~= "table" then
					v347 = false
				else
					for v348, _ in t47 do
						if type(v348) ~= "number" then
							v347 = false
							g350 = true
						end

						if g350 then
							break
						end
					end

					if not g350 then
						v347 = true
					end
				end

				g350 = false

				if not v347 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t47)))
				end
			end

			return mountCallback(p72, t47)
		end,
		useContext = function(p73, p74) -- line: 2053
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), readContext (copy)
			u70 = "useContext"

			if __DEV__ then
				local v353 = u70

				if t4 == nil then
					t4 = { v353 }
				else
					table.insert(t4, v353)
				end
			end

			return readContext(p73, p74)
		end,
		useEffect = function(p75: ((...any) -> ...any), t48: {[any]: any}?) -- line: 2061
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), console (copy), mountEffect (copy)
			u70 = "useEffect"

			local g360 = nil
			local v357 = nil

			if __DEV__ then
				local v356 = u70

				if t4 == nil then
					t4 = { v356 }
				else
					table.insert(t4, v356)
				end
			end

			if __DEV__ and t48 ~= nil then
				if type(t48) ~= "table" then
					v357 = false
				else
					for v358, _ in t48 do
						if type(v358) ~= "number" then
							v357 = false
							g360 = true
						end

						if g360 then
							break
						end
					end

					if not g360 then
						v357 = true
					end
				end

				g360 = false

				if not v357 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t48)))
				end
			end

			return mountEffect(p75, t48)
		end,
		useImperativeHandle = function(p76, p77: ((...any) -> ...any), t49: {[any]: any}?) -- line: 2071
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), console (copy)
			u70 = "useImperativeHandle"

			local g368 = nil
			local v365 = nil

			if __DEV__ then
				local v364 = u70

				if t4 == nil then
					t4 = { v364 }
				else
					table.insert(t4, v364)
				end
			end

			if __DEV__ and t49 ~= nil then
				if type(t49) ~= "table" then
					v365 = false
				else
					for v366, _ in t49 do
						if type(v366) ~= "number" then
							v365 = false
							g368 = true
						end

						if g368 then
							break
						end
					end

					if not g368 then
						v365 = true
					end
				end

				g368 = false

				if not v365 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t49)))
				end
			end

			return mountImperativeHandle(p76, p77, t49)
		end,
		useLayoutEffect = function(p78: ((...any) -> ...any), t50: {[any]: any}?) -- line: 2081
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), console (copy), mountLayoutEffect (copy)
			u70 = "useLayoutEffect"

			local g375 = nil
			local v372 = nil

			if __DEV__ then
				local v371 = u70

				if t4 == nil then
					t4 = { v371 }
				else
					table.insert(t4, v371)
				end
			end

			if __DEV__ and t50 ~= nil then
				if type(t50) ~= "table" then
					v372 = false
				else
					for v373, _ in t50 do
						if type(v373) ~= "number" then
							v372 = false
							g375 = true
						end

						if g375 then
							break
						end
					end

					if not g375 then
						v372 = true
					end
				end

				g375 = false

				if not v372 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t50)))
				end
			end

			return mountLayoutEffect(p78, t50)
		end,
		useMemo = function(p79: ((...any) -> ...any), t51: {[any]: any}?) -- line: 2092
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), console (copy), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useMemo"

			local g382 = nil
			local v379 = nil

			if __DEV__ then
				local v378 = u70

				if t4 == nil then
					t4 = { v378 }
				else
					table.insert(t4, v378)
				end
			end

			if __DEV__ and t51 ~= nil then
				if type(t51) ~= "table" then
					v379 = false
				else
					for v380, _ in t51 do
						if type(v380) ~= "number" then
							v379 = false
							g382 = true
						end

						if g382 then
							break
						end
					end

					if not g382 then
						v379 = true
					end
				end

				g382 = false

				if not v379 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t51)))
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local t52 = { pcall(mountMemo, p79, t51) }

			ReactCurrentDispatcher.current = current

			if not t52[1] then
				error(t52[2])
			end

			return unpack(t52, 2)
		end,
		useReducer = function(p80: ((...any) -> ...any), p81, p82: ((...any) -> ...any)?) -- line: 2110
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useReducer"

			if __DEV__ then
				local v388 = u70

				if t4 == nil then
					t4 = { v388 }
				else
					table.insert(t4, v388)
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v392 = pcall(mountReducer, p80, p81, p82)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v392
		end,
		useRef = function(p83) -- line: 2128
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref)
			u70 = "useRef"

			if __DEV__ then
				local v394 = u70

				if t4 == nil then
					t4 = { v394 }
				else
					table.insert(t4, v394)
				end
			end

			return mountRef(p83)
		end,
		useBinding = function(p84) -- line: 2134
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref)
			u70 = "useBinding"

			if __DEV__ then
				local v396 = u70

				if t4 == nil then
					t4 = { v396 }
				else
					table.insert(t4, v396)
				end
			end

			return mountBinding(p84)
		end,
		useState = function(p85) -- line: 2139
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useState"

			if __DEV__ then
				local v398 = u70

				if t4 == nil then
					t4 = { v398 }
				else
					table.insert(t4, v398)
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v402 = pcall(mountState, p85)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v402
		end,
		useDebugValue = function(p86, p87: ((...any) -> ...any)?) -- line: 2155
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref)
			u70 = "useDebugValue"

			if __DEV__ then
				local v405 = u70

				if t4 == nil then
					t4 = { v405 }
				else
					table.insert(t4, v405)
				end
			end

			return mountDebugValue(p86, p87)
		end,
		useMutableSource = function(p88, p89, p90) -- line: 2170
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref)
			u70 = "useMutableSource"

			if __DEV__ then
				local v409 = u70

				if t4 == nil then
					t4 = { v409 }
				else
					table.insert(t4, v409)
				end
			end

			return mountMutableSource(p88, p89, p90)
		end,
		useOpaqueIdentifier = function() -- line: 2185
			-- upvalues: u70 (ref), __DEV__ (copy), t4 (ref)
			u70 = "useOpaqueIdentifier"

			if __DEV__ then
				local v410 = u70

				if t4 == nil then
					t4 = { v410 }
				else
					table.insert(t4, v410)
				end
			end

			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t60 = {
		readContext = function(p91, p92) -- line: 2195
			-- upvalues: readContext (copy)
			return readContext(p91, p92)
		end,
		useCallback = function(p93, t54: {[any]: any}?) -- line: 2201
			-- upvalues: u70 (ref), __DEV__ (copy), console (copy)
			u70 = "useCallback"
			updateHookTypesDev()

			if __DEV__ and t54 ~= nil then
				local v415, g418

				if type(t54) ~= "table" then
					v415 = false
				else
					g418 = nil
					v415 = nil

					for v416, _ in t54 do
						if type(v416) ~= "number" then
							v415 = false
							g418 = true
						end

						if g418 then
							break
						end
					end

					if not g418 then
						v415 = true
					end
				end

				g418 = false

				if not v415 then
					console.error("%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.", u70, (type(t54)))
				end
			end

			return mountCallback(p93, t54)
		end,
		useContext = function(p94, p95) -- line: 2207
			-- upvalues: u70 (ref), readContext (copy)
			u70 = "useContext"
			updateHookTypesDev()

			return readContext(p94, p95)
		end,
		useEffect = function(p96: ((...any) -> ...any), t55: {[any]: any}?) -- line: 2215
			-- upvalues: u70 (ref), mountEffect (copy)
			u70 = "useEffect"
			updateHookTypesDev()

			return mountEffect(p96, t55)
		end,
		useImperativeHandle = function(p97, p98: ((...any) -> ...any), t56: {[any]: any}?) -- line: 2224
			-- upvalues: u70 (ref)
			u70 = "useImperativeHandle"
			updateHookTypesDev()

			return mountImperativeHandle(p97, p98, t56)
		end,
		useLayoutEffect = function(p99: ((...any) -> ...any), t57: {[any]: any}?) -- line: 2233
			-- upvalues: u70 (ref), mountLayoutEffect (copy)
			u70 = "useLayoutEffect"
			updateHookTypesDev()

			return mountLayoutEffect(p99, t57)
		end,
		useMemo = function(p100: ((...any) -> ...any), t58: {[any]: any}?) -- line: 2243
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useMemo"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local t59 = { pcall(mountMemo, p100, t58) }

			ReactCurrentDispatcher.current = current

			if not t59[1] then
				error(t59[2])
			end

			return unpack(t59, 2)
		end,
		useReducer = function(p101: ((...any) -> ...any), p102, p103: ((...any) -> ...any)?) -- line: 2259
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useReducer"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v438 = pcall(mountReducer, p101, p102, p103)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v438
		end,
		useRef = function(p104) -- line: 2277
			-- upvalues: u70 (ref)
			u70 = "useRef"
			updateHookTypesDev()

			return mountRef(p104)
		end,
		useBinding = function(p105) -- line: 2283
			-- upvalues: u70 (ref)
			u70 = "useBinding"
			updateHookTypesDev()

			return mountBinding(p105)
		end,
		useState = function(p106) -- line: 2288
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useState"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v445 = pcall(mountState, p106)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v445
		end,
		useDebugValue = function(p107, p108: ((...any) -> ...any)?) -- line: 2304
			-- upvalues: u70 (ref)
			u70 = "useDebugValue"
			updateHookTypesDev()

			return mountDebugValue(p107, p108)
		end,
		useMutableSource = function(p109, p110, p111) -- line: 2319
			-- upvalues: u70 (ref)
			u70 = "useMutableSource"
			updateHookTypesDev()

			return mountMutableSource(p109, p110, p111)
		end,
		useOpaqueIdentifier = function() -- line: 2334
			-- upvalues: u70 (ref)
			u70 = "useOpaqueIdentifier"
			updateHookTypesDev()

			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t67 = {
		readContext = function(p112, p113) -- line: 2344
			-- upvalues: readContext (copy)
			return readContext(p112, p113)
		end,
		useCallback = function(p114, t61: {[any]: any}?) -- line: 2350
			-- upvalues: u70 (ref)
			u70 = "useCallback"
			updateHookTypesDev()

			return updateCallback(p114, t61)
		end,
		useContext = function(p115, p116) -- line: 2355
			-- upvalues: u70 (ref), readContext (copy)
			u70 = "useContext"
			updateHookTypesDev()

			return readContext(p115, p116)
		end,
		useEffect = function(p117: ((...any) -> ...any), t62: {[any]: any}?) -- line: 2363
			-- upvalues: u70 (ref), updateEffect (copy)
			u70 = "useEffect"
			updateHookTypesDev()

			return updateEffect(p117, t62)
		end,
		useImperativeHandle = function(p118, p119: ((...any) -> ...any), t63: {[any]: any}?) -- line: 2372
			-- upvalues: u70 (ref)
			u70 = "useImperativeHandle"
			updateHookTypesDev()

			return updateImperativeHandle(p118, p119, t63)
		end,
		useLayoutEffect = function(p120: ((...any) -> ...any), t64: {[any]: any}?) -- line: 2381
			-- upvalues: u70 (ref), updateLayoutEffect (copy)
			u70 = "useLayoutEffect"
			updateHookTypesDev()

			return updateLayoutEffect(p120, t64)
		end,
		useMemo = function(p121: ((...any) -> ...any), t65: {[any]: any}?) -- line: 2391
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useMemo"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local t66 = { pcall(updateMemo, p121, t65) }

			ReactCurrentDispatcher.current = current

			if not t66[1] then
				error(t66[2])
			end

			return unpack(t66, 2)
		end,
		useReducer = function(p122: ((...any) -> ...any), p123, p124: ((...any) -> ...any)?) -- line: 2407
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useReducer"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v474 = pcall(updateReducer, p122, p123, p124)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v474
		end,
		useRef = function(p125) -- line: 2425
			-- upvalues: u70 (ref)
			u70 = "useRef"
			updateHookTypesDev()

			return updateRef(p125)
		end,
		useBinding = function(p126) -- line: 2431
			-- upvalues: u70 (ref)
			u70 = "useBinding"
			updateHookTypesDev()

			return updateBinding(p126)
		end,
		useState = function(p127) -- line: 2436
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useState"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v481 = pcall(updateState, p127)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v481
		end,
		useDebugValue = function(p128, p129: ((...any) -> ...any)?) -- line: 2452
			-- upvalues: u70 (ref), _mountDebugValue (copy)
			u70 = "useDebugValue"
			updateHookTypesDev()

			return _mountDebugValue(p128, p129)
		end,
		useMutableSource = function(p130, p131, p132) -- line: 2467
			-- upvalues: u70 (ref)
			u70 = "useMutableSource"
			updateHookTypesDev()

			return updateMutableSource(p130, p131, p132)
		end,
		useOpaqueIdentifier = function() -- line: 2482
			-- upvalues: u70 (ref)
			u70 = "useOpaqueIdentifier"
			updateHookTypesDev()

			return updateOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t74 = {
		readContext = function(p133, p134) -- line: 2492
			-- upvalues: readContext (copy)
			return readContext(p133, p134)
		end,
		useCallback = function(p135, t68: {[any]: any}?) -- line: 2498
			-- upvalues: u70 (ref)
			u70 = "useCallback"
			updateHookTypesDev()

			return updateCallback(p135, t68)
		end,
		useContext = function(p136, p137) -- line: 2503
			-- upvalues: u70 (ref), readContext (copy)
			u70 = "useContext"
			updateHookTypesDev()

			return readContext(p136, p137)
		end,
		useEffect = function(p138: ((...any) -> ...any), t69: {[any]: any}?) -- line: 2511
			-- upvalues: u70 (ref), updateEffect (copy)
			u70 = "useEffect"
			updateHookTypesDev()

			return updateEffect(p138, t69)
		end,
		useImperativeHandle = function(p139, p140: ((...any) -> ...any), t70: {[any]: any}?) -- line: 2520
			-- upvalues: u70 (ref)
			u70 = "useImperativeHandle"
			updateHookTypesDev()

			return updateImperativeHandle(p139, p140, t70)
		end,
		useLayoutEffect = function(p141: ((...any) -> ...any), t71: {[any]: any}?) -- line: 2529
			-- upvalues: u70 (ref), updateLayoutEffect (copy)
			u70 = "useLayoutEffect"
			updateHookTypesDev()

			return updateLayoutEffect(p141, t71)
		end,
		useMemo = function(p142: ((...any) -> ...any), t72: {[any]: any}?) -- line: 2539
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t95 (ref)
			u70 = "useMemo"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t95

			local t73 = { pcall(updateMemo, p142, t72) }

			ReactCurrentDispatcher.current = current

			if not t73[1] then
				error(t73[2])
			end

			return unpack(t73, 2)
		end,
		useReducer = function(p143: ((...any) -> ...any), p144, p145: ((...any) -> ...any)?) -- line: 2555
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t95 (ref)
			u70 = "useReducer"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t95

			local ok, result, v510 = pcall(rerenderReducer, p143, p144, p145)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v510
		end,
		useRef = function(p146) -- line: 2574
			-- upvalues: u70 (ref)
			u70 = "useRef"
			updateHookTypesDev()

			return updateRef(p146)
		end,
		useBinding = function(p147) -- line: 2580
			-- upvalues: u70 (ref)
			u70 = "useBinding"
			updateHookTypesDev()

			return updateBinding(p147)
		end,
		useState = function(p148) -- line: 2585
			-- upvalues: u70 (ref), ReactCurrentDispatcher (copy), t95 (ref)
			u70 = "useState"
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t95

			local ok, result, v517 = pcall(rerenderState, p148)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v517
		end,
		useDebugValue = function(p149, p150: ((...any) -> ...any)?) -- line: 2601
			-- upvalues: u70 (ref), _mountDebugValue (copy)
			u70 = "useDebugValue"
			updateHookTypesDev()

			return _mountDebugValue(p149, p150)
		end,
		useMutableSource = function(p151, p152, p153) -- line: 2616
			-- upvalues: u70 (ref)
			u70 = "useMutableSource"
			updateHookTypesDev()

			return updateMutableSource(p151, p152, p153)
		end,
		useOpaqueIdentifier = function() -- line: 2631
			-- upvalues: u70 (ref)
			u70 = "useOpaqueIdentifier"
			updateHookTypesDev()

			return rerenderOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t81 = {
		readContext = function(p154, p155) -- line: 2641
			-- upvalues: console (copy), readContext (copy)
			console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")

			return readContext(p154, p155)
		end,
		useCallback = function(p156, t75: {[any]: any}?) -- line: 2648
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useCallback"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v527 = u70

				if t4 == nil then
					t4 = { v527 }
				else
					table.insert(t4, v527)
				end
			end

			return mountCallback(p156, t75)
		end,
		useContext = function(p157, p158) -- line: 2654
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), readContext (copy)
			u70 = "useContext"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v530 = u70

				if t4 == nil then
					t4 = { v530 }
				else
					table.insert(t4, v530)
				end
			end

			return readContext(p157, p158)
		end,
		useEffect = function(p159: ((...any) -> ...any), t76: {[any]: any}?) -- line: 2663
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), mountEffect (copy)
			u70 = "useEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v533 = u70

				if t4 == nil then
					t4 = { v533 }
				else
					table.insert(t4, v533)
				end
			end

			return mountEffect(p159, t76)
		end,
		useImperativeHandle = function(p160, p161: ((...any) -> ...any), t77: {[any]: any}?) -- line: 2673
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useImperativeHandle"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v537 = u70

				if t4 == nil then
					t4 = { v537 }
				else
					table.insert(t4, v537)
				end
			end

			return mountImperativeHandle(p160, p161, t77)
		end,
		useLayoutEffect = function(p162: ((...any) -> ...any), t78: {[any]: any}?) -- line: 2683
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), mountLayoutEffect (copy)
			u70 = "useLayoutEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v540 = u70

				if t4 == nil then
					t4 = { v540 }
				else
					table.insert(t4, v540)
				end
			end

			return mountLayoutEffect(p162, t78)
		end,
		useMemo = function(p163: ((...any) -> ...any), t79: {[any]: any}?) -- line: 2694
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useMemo"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v543 = u70

				if t4 == nil then
					t4 = { v543 }
				else
					table.insert(t4, v543)
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local t80 = { pcall(mountMemo, p163, t79) }

			ReactCurrentDispatcher.current = current

			if not t80[1] then
				error(t80[2])
			end

			return unpack(t80, 2)
		end,
		useReducer = function(p164: ((...any) -> ...any), p165, p166: ((...any) -> ...any)?) -- line: 2711
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useReducer"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v549 = u70

				if t4 == nil then
					t4 = { v549 }
				else
					table.insert(t4, v549)
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v553 = pcall(mountReducer, p164, p165, p166)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v553
		end,
		useRef = function(p167) -- line: 2730
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useRef"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v555 = u70

				if t4 == nil then
					t4 = { v555 }
				else
					table.insert(t4, v555)
				end
			end

			return mountRef(p167)
		end,
		useBinding = function(p168) -- line: 2737
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useBinding"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v557 = u70

				if t4 == nil then
					t4 = { v557 }
				else
					table.insert(t4, v557)
				end
			end

			return mountBinding(p168)
		end,
		useState = function(p169) -- line: 2743
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref), ReactCurrentDispatcher (copy), t81 (ref)
			u70 = "useState"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v559 = u70

				if t4 == nil then
					t4 = { v559 }
				else
					table.insert(t4, v559)
				end
			end

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t81

			local ok, result, v563 = pcall(mountState, p169)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v563
		end,
		useDebugValue = function(p170, p171: ((...any) -> ...any)?) -- line: 2760
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useDebugValue"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v566 = u70

				if t4 == nil then
					t4 = { v566 }
				else
					table.insert(t4, v566)
				end
			end

			return mountDebugValue(p170, p171)
		end,
		useMutableSource = function(p172, p173, p174) -- line: 2778
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useMutableSource"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v570 = u70

				if t4 == nil then
					t4 = { v570 }
				else
					table.insert(t4, v570)
				end
			end

			return mountMutableSource(p172, p173, p174)
		end,
		useOpaqueIdentifier = function() -- line: 2794
			-- upvalues: u70 (ref), console (copy), __DEV__ (copy), t4 (ref)
			u70 = "useOpaqueIdentifier"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")

			if __DEV__ then
				local v571 = u70

				if t4 == nil then
					t4 = { v571 }
				else
					table.insert(t4, v571)
				end
			end

			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t88 = {
		readContext = function(p175, p176) -- line: 2805
			-- upvalues: console (copy), readContext (copy)
			console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")

			return readContext(p175, p176)
		end,
		useCallback = function(p177, t82: {[any]: any}?) -- line: 2812
			-- upvalues: u70 (ref), console (copy)
			u70 = "useCallback"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return mountCallback(p177, t82)
		end,
		useContext = function(p178, p179) -- line: 2818
			-- upvalues: u70 (ref), console (copy), readContext (copy)
			u70 = "useContext"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return readContext(p178, p179)
		end,
		useEffect = function(p180: ((...any) -> ...any), t83: {[any]: any}?) -- line: 2827
			-- upvalues: u70 (ref), console (copy), updateEffect (copy)
			u70 = "useEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateEffect(p180, t83)
		end,
		useImperativeHandle = function(p181, p182: ((...any) -> ...any), t84: {[any]: any}?) -- line: 2837
			-- upvalues: u70 (ref), console (copy)
			u70 = "useImperativeHandle"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateImperativeHandle(p181, p182, t84)
		end,
		useLayoutEffect = function(p183: ((...any) -> ...any), t85: {[any]: any}?) -- line: 2847
			-- upvalues: u70 (ref), console (copy), updateLayoutEffect (copy)
			u70 = "useLayoutEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateLayoutEffect(p183, t85)
		end,
		useMemo = function(p184: ((...any) -> ...any), t86: {[any]: any}?) -- line: 2858
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useMemo"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local t87 = { pcall(updateMemo, p184, t86) }

			ReactCurrentDispatcher.current = current

			if not t87[1] then
				error(t87[2])
			end

			return unpack(t87, 2)
		end,
		useReducer = function(p185: ((...any) -> ...any), p186, p187: ((...any) -> ...any)?) -- line: 2875
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useReducer"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v595 = pcall(updateReducer, p185, p186, p187)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v595
		end,
		useRef = function(p188) -- line: 2895
			-- upvalues: u70 (ref), console (copy)
			u70 = "useRef"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateRef(p188)
		end,
		useBinding = function(p189) -- line: 2902
			-- upvalues: u70 (ref), console (copy)
			u70 = "useBinding"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateBinding(p189)
		end,
		useState = function(p190) -- line: 2908
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useState"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v602 = pcall(updateState, p190)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v602
		end,
		useDebugValue = function(p191, p192: ((...any) -> ...any)?) -- line: 2925
			-- upvalues: u70 (ref), console (copy), _mountDebugValue (copy)
			u70 = "useDebugValue"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return _mountDebugValue(p191, p192)
		end,
		useMutableSource = function(p193, p194, p195) -- line: 2943
			-- upvalues: u70 (ref), console (copy)
			u70 = "useMutableSource"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateMutableSource(p193, p194, p195)
		end,
		useOpaqueIdentifier = function() -- line: 2959
			-- upvalues: u70 (ref), console (copy)
			u70 = "useOpaqueIdentifier"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
	t95 = {
		readContext = function(p196, p197) -- line: 2970
			-- upvalues: console (copy), readContext (copy)
			console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")

			return readContext(p196, p197)
		end,
		useCallback = function(p198, t89: {[any]: any}?) -- line: 2977
			-- upvalues: u70 (ref), console (copy)
			u70 = "useCallback"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateCallback(p198, t89)
		end,
		useContext = function(p199, p200) -- line: 2983
			-- upvalues: u70 (ref), console (copy), readContext (copy)
			u70 = "useContext"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return readContext(p199, p200)
		end,
		useEffect = function(p201: ((...any) -> ...any), t90: {[any]: any}?) -- line: 2992
			-- upvalues: u70 (ref), console (copy), updateEffect (copy)
			u70 = "useEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateEffect(p201, t90)
		end,
		useImperativeHandle = function(p202, p203: ((...any) -> ...any), t91: {[any]: any}?) -- line: 3002
			-- upvalues: u70 (ref), console (copy)
			u70 = "useImperativeHandle"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateImperativeHandle(p202, p203, t91)
		end,
		useLayoutEffect = function(p204: ((...any) -> ...any), t92: {[any]: any}?) -- line: 3012
			-- upvalues: u70 (ref), console (copy), updateLayoutEffect (copy)
			u70 = "useLayoutEffect"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateLayoutEffect(p204, t92)
		end,
		useMemo = function(p205: ((...any) -> ...any), t93: {[any]: any}?) -- line: 3023
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useMemo"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local t94 = { pcall(updateMemo, p205, t93) }

			ReactCurrentDispatcher.current = current

			if not t94[1] then
				error(t94[2])
			end

			return unpack(t94, 2)
		end,
		useReducer = function(p206: ((...any) -> ...any), p207, p208: ((...any) -> ...any)?) -- line: 3040
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useReducer"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v631 = pcall(rerenderReducer, p206, p207, p208)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v631
		end,
		useRef = function(p209) -- line: 3060
			-- upvalues: u70 (ref), console (copy)
			u70 = "useRef"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateRef(p209)
		end,
		useBinding = function(p210) -- line: 3067
			-- upvalues: u70 (ref), console (copy)
			u70 = "useBinding"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateBinding(p210)
		end,
		useState = function(p211) -- line: 3073
			-- upvalues: u70 (ref), console (copy), ReactCurrentDispatcher (copy), t88 (ref)
			u70 = "useState"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			local current = ReactCurrentDispatcher.current

			ReactCurrentDispatcher.current = t88

			local ok, result, v638 = pcall(rerenderState, p211)

			ReactCurrentDispatcher.current = current

			if not ok then
				error(result)
			end

			return result, v638
		end,
		useDebugValue = function(p212, p213: ((...any) -> ...any)?) -- line: 3090
			-- upvalues: u70 (ref), console (copy), _mountDebugValue (copy)
			u70 = "useDebugValue"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return _mountDebugValue(p212, p213)
		end,
		useMutableSource = function(p214, p215, p216) -- line: 3108
			-- upvalues: u70 (ref), console (copy)
			u70 = "useMutableSource"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return updateMutableSource(p214, p215, p216)
		end,
		useOpaqueIdentifier = function() -- line: 3124
			-- upvalues: u70 (ref), console (copy)
			u70 = "useOpaqueIdentifier"
			console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
			updateHookTypesDev()

			return rerenderOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
end

function t2.renderWithHooks(p217, p218, p219: ((...any) -> ...any), p220, p221, p222) -- line: 3135
	-- upvalues: u64 (ref), u65 (ref), __DEV__ (copy), t4 (ref), n1 (ref), NoLanes (copy), ReactCurrentDispatcher (copy), t67 (ref), t60 (ref), t53 (ref), t44 (copy), t45 (copy), u69 (ref), Error (copy), u66 (ref), u67 (ref), t74 (ref), t46 (copy), t43 (copy), u70 (ref), u68 (ref), getComponentName (copy)
	u64 = p222
	u65 = p218

	if __DEV__ then
		t4 = if p217 == nil then nil else p217._debugHookTypes
		n1 = 0
	end

	p218.memoizedState = nil
	p218.updateQueue = nil
	p218.lanes = NoLanes

	if __DEV__ then
		if p217 ~= nil and p217.memoizedState ~= nil then
			ReactCurrentDispatcher.current = t67
		elseif t4 ~= nil then
			ReactCurrentDispatcher.current = t60
		else
			ReactCurrentDispatcher.current = t53
		end
	else
		ReactCurrentDispatcher.current = not (p217 ~= nil and p217.memoizedState ~= nil) and t44 or t45
	end

	local v650 = p219(p220, p221)

	if u69 then
		local n5 = 0

		repeat
			u69 = false

			if n5 >= 25 then
				error(Error.new("Too many re-renders. React limits the number of renders to prevent an infinite loop."))
			end

			n5 += 1
			u66 = nil
			u67 = nil
			p218.updateQueue = nil

			if __DEV__ then
				n1 = 0
			end

			ReactCurrentDispatcher.current = __DEV__ and t74 or t46
			v650 = p219(p220, p221)
		until not u69
	end

	ReactCurrentDispatcher.current = t43

	if __DEV__ then
		p218._debugHookTypes = t4
	end

	local v652 = u66 ~= nil and u66.next ~= nil

	u64 = NoLanes
	u65 = nil
	u66 = nil
	u67 = nil

	if __DEV__ then
		u70 = nil
		t4 = nil
		n1 = 0
	end

	u68 = false

	if v652 then
		local s4 = "unknown"

		if v650 and v650.type then
			s4 = getComponentName(v650.type) or s4
		end

		error(Error.new("Rendered fewer hooks than expected. This may be caused by an accidental " .. "early return statement. Inside '" .. s4 .. "'"))
	end

	return v650
end

return t2
