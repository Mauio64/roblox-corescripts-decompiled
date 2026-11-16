local function unimplemented(p: string) -- 1 equivalent call inferred from this helper
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. p)
	error("FIXME (roblox): " .. p .. " is unimplemented")
end
local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local __DEV__ = ReactGlobals.__DEV__

local React = require(parent.React)
local createRef = React.createRef
local React2 = require(parent.React)
local createBinding = React2.createBinding

local Shared = require(parent.Shared)
local console = Shared.console
local Shared2 = require(parent.Shared)
local MemoValues = Shared2.MemoValues

require(parent.Shared)

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

local ReactHookEffectTags = require(script.Parent.ReactHookEffectTags)

local Shared3 = require(parent.Shared)
local ReactSharedInternals = Shared3.ReactSharedInternals
local Shared4 = require(parent.Shared)
local ReactFeatureFlags = Shared4.ReactFeatureFlags
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local enableNewReconciler = ReactFeatureFlags.enableNewReconciler

local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local enableAllocationTrims = ReactFeatureFlags.enableAllocationTrims
local enableHookDoubleBuffering = ReactFeatureFlags.enableHookDoubleBuffering

local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local NoLane = ReactFiberLane.NoLane
local NoLanes = ReactFiberLane.NoLanes

local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local mergeLanes = ReactFiberLane.mergeLanes
local removeLanes = ReactFiberLane.removeLanes
local markRootEntangled = ReactFiberLane.markRootEntangled
local markRootMutableRead = ReactFiberLane.markRootMutableRead

local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
local readContext = ReactFiberNewContextnew.readContext
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Update = ReactFiberFlags.Update
local Passive = ReactFiberFlags.Passive
local PassiveStatic = ReactFiberFlags.PassiveStatic
local MountLayoutDev = ReactFiberFlags.MountLayoutDev
local MountPassiveDev = ReactFiberFlags.MountPassiveDev
local HasEffect = ReactHookEffectTags.HasEffect
local Layout = ReactHookEffectTags.Layout
local passive = ReactHookEffectTags.Passive
local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])

local warnIfNotCurrentlyActingUpdatesInDEV = ReactFiberWorkLoopnew.warnIfNotCurrentlyActingUpdatesInDEV
local scheduleUpdateOnFiber = ReactFiberWorkLoopnew.scheduleUpdateOnFiber
local warnIfNotScopedWithMatchingAct = ReactFiberWorkLoopnew.warnIfNotScopedWithMatchingAct
local requestEventTime = ReactFiberWorkLoopnew.requestEventTime
local requestUpdateLane = ReactFiberWorkLoopnew.requestUpdateLane
local markSkippedUpdateLanes = ReactFiberWorkLoopnew.markSkippedUpdateLanes
local getWorkInProgressRoot = ReactFiberWorkLoopnew.getWorkInProgressRoot

local warnIfNotCurrentlyActingEffectsInDEV = ReactFiberWorkLoopnew.warnIfNotCurrentlyActingEffectsInDEV

local Shared5 = require(parent.Shared)
local invariant = Shared5.invariant
local Shared6 = require(parent.Shared)
local getComponentName = Shared6.getComponentName

local function is(p, p2): boolean -- 10 equivalent calls inferred from this helper
	if p == p2 and (p ~= 0 or 1 / p == 1 / p2) then
		return true
	elseif p == p then
		return false
	else
		return p2 ~= p2
	end
end

local ReactFiberBeginWorknew = require(script.Parent["ReactFiberBeginWork.new"])
local markWorkInProgressReceivedUpdate = ReactFiberBeginWorknew.markWorkInProgressReceivedUpdate

local ReactFiberHydrationContextnew = require(script.Parent["ReactFiberHydrationContext.new"])
local getIsHydrating = ReactFiberHydrationContextnew.getIsHydrating

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local makeClientId = ReactFiberHostConfig.makeClientId

local ReactMutableSourcenew = require(script.Parent["ReactMutableSource.new"])
local warnAboutMultipleRenderersDEV = ReactMutableSourcenew.warnAboutMultipleRenderersDEV
local getWorkInProgressVersion = ReactMutableSourcenew.getWorkInProgressVersion
local setWorkInProgressVersion = ReactMutableSourcenew.setWorkInProgressVersion
local markSourceAsDirty = ReactMutableSourcenew.markSourceAsDirty

local DebugTracing = require(script.Parent.DebugTracing)
local logStateUpdateScheduled = DebugTracing.logStateUpdateScheduled

local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markStateUpdateScheduled = SchedulingProfiler.markStateUpdateScheduled

local ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher

local SafeFlags = require(parent.SafeFlags)
local v = SafeFlags.createGetFFlag("ReactCleanQueueOnUpdateBailout")()

local v2 = __DEV__ and {} or nil

local New = {}

local v3 = NoLanes

local v4 = nil

local alternate3 = nil

local v5 = nil

local v6 = nil
local v7 = nil

local flag = false

local flag2 = false

local v8 = nil

local debugHookTypes = nil
local count = 0

local current2 = nil
local current3 = nil
local current4 = nil
local v9 = nil
local current5 = nil
local current6 = nil
local current7 = nil

local function getHighestIndex(items) -- 2 equivalent calls inferred from this helper
	local highestIndex = 0

	for k, _ in items do
		if highestIndex < k then
			highestIndex = k
		end
	end

	return highestIndex
end

local function isArrayOrSparseArray(items): boolean -- 1 equivalent call inferred from this helper
	if type(items) ~= "table" then
		return false
	end

	for k, _ in items do
		if type(k) ~= "number" then
			return false
		end
	end

	return true
end

local function mountHookTypesDev() -- 26 equivalent calls inferred from this helper
	if __DEV__ then
		local v10 = v8

		if debugHookTypes == nil then
			debugHookTypes = { v10 }
		else
			table.insert(debugHookTypes, v10)
		end
	end
end

function updateHookTypesDev()
	if __DEV__ then
		local v10 = v8

		if debugHookTypes ~= nil then
			count += 1

			if debugHookTypes[count] ~= v10 then
				warnOnHookMismatchInDev(v10)
			end
		end
	end
end

local function checkDepsAreArrayDev(items) -- 6 equivalent calls inferred from this helper
	if __DEV__ and items ~= nil and not isArrayOrSparseArray(items) then -- inferred equivalent call
		console.error(
			"%s received a final argument that is not an array (instead, received `%s`). When specified, the final argument must be an array.",
			v8,
			(type(items))
		)
	end
end

function warnOnHookMismatchInDev(p)
	if __DEV__ then
		local v10 = getComponentName(v4.type) or "Component"

		if not v2[v10] then
			v2[v10] = true

			if debugHookTypes ~= nil then
				local v11 = ""

				for i = 1, count do
					local v12 = debugHookTypes[i]

					local v13 = if i == count then p else v12

					local v14 = tostring(i) .. ". " .. (v12 or "undefined")

					while string.len(v14) < 30 do
						v14 ..= " "
					end

					v11 ..= v14 .. v13 .. "\n"
				end

				console.error(
					"React has detected a change in the order of Hooks called by %s. This will lead to bugs and errors if not fixed. For more information, read the Rules of Hooks: https://reactjs.org/link/rules-of-hooks\n\n   Previous render            Next render\n   ------------------------------------------------------\n%s   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n",
					v10,
					v11
				)
			end
		end
	end
end

local function throwInvalidHookError()
	error(Error.new([[
Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:
1. You might have mismatching versions of React and the renderer (such as React DOM)
2. You might be breaking the Rules of Hooks
3. You might have more than one copy of React in the same app
See https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.]]))
end

local function areHookInputsEqual(list, list2): boolean
	if list2 == nil then
		if __DEV__ then
			console.error(
				"%s received a final argument during this render, but not during the previous render. Even though the final argument is optional, its type cannot change between renders.",
				v8
			)
		end

		return false
	else
		local highestIndex = getHighestIndex(list) -- inferred equivalent call
		local highestIndex2 = getHighestIndex(list2) -- inferred equivalent call

		if highestIndex ~= highestIndex2 then
			return false
		end

		for i = 1, math.min(highestIndex2, highestIndex) do
			if not is(list[i], list2[i]) then -- inferred equivalent call
				return false
			end
		end

		return true
	end
end

function New:bailoutHooks(p, p2)
	if enableHookDoubleBuffering and self.updateQueue ~= nil then
		self.updateQueue.alternate = nil
	end

	p.updateQueue = self.updateQueue

	if __DEV__ and enableDoubleInvokingEffects then
		p.flags = bit32.band(p.flags, (bit32.bnot((bit32.bor(MountPassiveDev, Passive, MountLayoutDev, Update)))))
	else
		p.flags = bit32.band(p.flags, (bit32.bnot((bit32.bor(Passive, Update)))))
	end

	self.lanes = removeLanes(self.lanes, p2)
end

local v10 = false
function New.resetHooksAfterThrow()
	ReactCurrentDispatcher.current = New.ContextOnlyDispatcher

	if flag then
		local v11 = v4.memoizedState

		while v11 ~= nil do
			local queue = v11.queue

			if queue ~= nil then
				queue.pending = nil
			end

			v11 = v11.next
		end

		flag = false
	end

	v3 = NoLanes
	v4 = nil

	alternate3 = nil
	v5 = nil

	if enableHookDoubleBuffering then
		v6 = nil
		v7 = nil
	end

	if __DEV__ then
		debugHookTypes = nil
		count = 0

		v8 = nil

		v10 = false
	end

	flag2 = false
end

local function mountWorkInProgressHook()
	local v11 = enableAllocationTrims and {
		memoizedState = nil,
		baseState = nil,
		queue = nil,
		next = nil
	} or {
		memoizedState = nil,
		baseState = nil,
		baseQueue = nil,
		queue = nil,
		next = nil
	}

	if v5 == nil then
		v4.memoizedState = v11
	else
		v5.next = v11
	end

	v5 = v11

	return v5
end

local function updateWorkInProgressHook()
	local v11

	if alternate3 == nil then
		local alternate = v4.alternate

		if alternate ~= nil then
			v11 = alternate.memoizedState
		end
	else
		v11 = alternate3.next
	end

	local v12 = if v5 == nil then v4.memoizedState else v5.next

	if v12 == nil then
		if v11 == nil then
			error(Error.new("Rendered more hooks than during the previous render."))
		end

		alternate3 = v11
		local v13

		if enableHookDoubleBuffering then
			v13 = alternate3.alternate

			if v13 == nil then
				v13 = {
					memoizedState = alternate3.memoizedState,
					baseState = alternate3.baseState,
					baseQueue = alternate3.baseQueue,
					queue = alternate3.queue,
					next = nil
				}

				v13.alternate = alternate3
				alternate3.alternate = v13
			else
				local memoizedState = alternate3.memoizedState

				if memoizedState ~= nil or v13.memoizedState ~= nil then
					v13.memoizedState = memoizedState
				end

				local baseState = alternate3.baseState

				if baseState ~= nil or v13.baseState ~= nil then
					v13.baseState = baseState
				end

				local baseQueue = alternate3.baseQueue

				if baseQueue ~= nil or v13.baseQueue ~= nil then
					v13.baseQueue = baseQueue
				end

				local queue = alternate3.queue

				if queue ~= nil or v13.queue ~= nil then
					v13.queue = queue
				end

				if v13.next ~= nil then
					v13.next = nil
				end
			end
		elseif enableAllocationTrims then
			local baseQueue = alternate3.baseQueue

			if baseQueue == nil then
				v13 = {
					memoizedState = alternate3.memoizedState,
					baseState = alternate3.baseState,
					queue = alternate3.queue,
					next = nil
				}
			else
				v13 = {
					memoizedState = alternate3.memoizedState,
					baseState = alternate3.baseState,
					baseQueue = baseQueue,
					queue = alternate3.queue,
					next = nil
				}
			end
		else
			v13 = {
				memoizedState = alternate3.memoizedState,
				baseState = alternate3.baseState,
				baseQueue = alternate3.baseQueue,
				queue = alternate3.queue,
				next = nil
			}
		end

		if v5 == nil then
			v5 = v13
			v4.memoizedState = v13
		else
			v5.next = v13
			v5 = v13
		end
	else
		v5 = v12
		local _next = v5.next

		alternate3 = v11
	end

	return v5
end

function basicStateReducer(p, callback)
	if type(callback) == "function" then
		return callback(p)
	end

	return callback
end

function mountReducer(lastRenderedReducer, baseState, callback)
	local v11 = mountWorkInProgressHook()

	if callback ~= nil then
		baseState = callback(baseState)
	end

	v11.baseState = baseState
	v11.memoizedState = v11.baseState

	local queue = {
		pending = nil,
		dispatch = nil,
		lastRenderedReducer = lastRenderedReducer,
		lastRenderedState = baseState
	}

	v11.queue = queue

	local v12 = v4

	local function fn(p, ...)
		dispatchAction(v12, queue, p, ...)
	end
	queue.dispatch = fn

	return v11.memoizedState, fn
end

function updateReducer(lastRenderedReducer, _, _)
	local v11 = updateWorkInProgressHook()
	local queue = v11.queue

	assert(queue ~= nil, "Should have a queue. This is likely a bug in React. Please file an issue.")

	queue.lastRenderedReducer = lastRenderedReducer

	local v12 = alternate3

	local v13 = v12.baseQueue

	local pending = queue.pending

	if pending ~= nil then
		if v13 ~= nil then
			local nextNode = v13.next
			v13.next = pending.next
			pending.next = nextNode
		end

		v12.baseQueue = pending
		queue.pending = nil
		v13 = pending
	end

	if v13 ~= nil then
		local nextNode = v13.next
		local v14 = v12.baseState
		local v15 = nextNode
		local baseQueue = nil
		local nextNode2 = nil
		local baseState = nil

		repeat
			local lane = v15.lane

			if bit32.band(v3, lane) == lane then
				if baseQueue ~= nil then
					baseQueue.next = {
						lane = NoLane,
						action = v15.action,
						eagerReducer = v15.eagerReducer,
						eagerState = v15.eagerState,
						next = nil
					}
					baseQueue = baseQueue.next
				end

				if v15.eagerReducer == lastRenderedReducer then
					v14 = v15.eagerState
				else
					v14 = lastRenderedReducer(v14, v15.action)
				end
			else
				local nextNode3 = {
					lane = lane,
					action = v15.action,
					eagerReducer = v15.eagerReducer,
					eagerState = v15.eagerState,
					next = nil
				}

				if baseQueue == nil then
					baseState = v14
					nextNode2 = nextNode3
					baseQueue = nextNode2
				else
					baseQueue.next = nextNode3
					baseQueue = baseQueue.next
				end

				v4.lanes = mergeLanes(v4.lanes, lane)
				markSkippedUpdateLanes(lane)
			end

			v15 = v15.next
		until v15 == nil or v15 == nextNode

		if baseQueue == nil then
			baseState = v14
		else
			baseQueue.next = nextNode2
		end

		if not is(v14, v11.memoizedState) then -- inferred equivalent call
			markWorkInProgressReceivedUpdate()
		end

		v11.memoizedState = v14
		v11.baseState = baseState
		v11.baseQueue = baseQueue

		queue.lastRenderedState = v14
	end

	local dispatch = queue.dispatch

	return v11.memoizedState, dispatch
end

function rerenderReducer(lastRenderedReducer, _, _)
	local v11 = updateWorkInProgressHook()
	local queue = v11.queue

	assert(queue ~= nil, "Should have a queue. This is likely a bug in React. Please file an issue.")

	queue.lastRenderedReducer = lastRenderedReducer

	local dispatch = queue.dispatch
	local pending = queue.pending
	local memoizedState = v11.memoizedState

	if pending == nil then
		return memoizedState, dispatch
	end

	queue.pending = nil

	local nextNode = pending.next
	local v12 = nextNode

	repeat
		memoizedState = lastRenderedReducer(memoizedState, v12.action)
		v12 = v12.next
	until v12 == nextNode

	if not is(memoizedState, v11.memoizedState) then -- inferred equivalent call
		markWorkInProgressReceivedUpdate()
	end

	v11.memoizedState = memoizedState

	if v11.baseQueue == nil then
		v11.baseState = memoizedState
	end

	queue.lastRenderedState = memoizedState

	return memoizedState, dispatch
end

function readFromUnsubcribedMutableSource(p, p2, callback)
	if __DEV__ then
		warnAboutMultipleRenderersDEV(p2)
	end

	local version = p2._getVersion(p2._source)

	local workInProgressVersion = getWorkInProgressVersion(p2)
	local v11

	if workInProgressVersion == nil then
		v11 = isSubsetOfLanes(v3, p.mutableReadLanes)

		if v11 then
			setWorkInProgressVersion(p2, version)
		end
	else
		v11 = workInProgressVersion == version
	end

	if v11 then
		local v12 = callback(p2._source)

		if __DEV__ and type(v12) == "function" then
			console.error("Mutable source should not return a function as the snapshot value. Functions may close over mutable values and cause tearing.")
		end

		return v12
	end

	markSourceAsDirty(p2)

	error(Error.new("Cannot read from mutable source during the current render without tearing. This is a bug in React. Please file an issue."))
end

function useMutableSource(p, source2, getSnapshot, subscribe2)
	local workInProgressRoot = getWorkInProgressRoot()
	invariant(
		workInProgressRoot ~= nil,
		"Expected a work-in-progress root. This is a bug in React. Please file an issue."
	)

	local getVersion = source2._getVersion
	local version = getVersion(source2._source)

	local current = ReactCurrentDispatcher.current

	assert(current ~= nil, "dispatcher was nil, this is a bug in React")

	local state, setState = current.useState(function()
		return readFromUnsubcribedMutableSource(workInProgressRoot, source2, getSnapshot)
	end)

	local v11 = state

	local v12 = v5

	local memoizedState = p.memoizedState

	if memoizedState.refs == nil then
		error((tostring(debug.traceback())))
	end

	local refs = memoizedState.refs
	local getSnapshot2 = refs.getSnapshot
	local source = memoizedState.source
	local subscribe = memoizedState.subscribe

	local v13 = v4

	p.memoizedState = { refs = refs, source = source2, subscribe = subscribe2 }

	current.useEffect(function()
		refs.getSnapshot = getSnapshot

		refs.setSnapshot = setState

		if not is(version, getVersion(source2._source)) then -- inferred equivalent call
			local snapshot = getSnapshot(source2._source)

			if __DEV__ and type(snapshot) == "function" then
				console.error("Mutable source should not return a function as the snapshot value. Functions may close over mutable values and cause tearing.")
			end

			if not is(v11, snapshot) then -- inferred equivalent call
				setState(snapshot)

				markRootMutableRead(workInProgressRoot, (requestUpdateLane(v13)))
			end

			markRootEntangled(workInProgressRoot, workInProgressRoot.mutableReadLanes)
		end
	end, { getSnapshot, source2, subscribe2 })

	current.useEffect(function()
		local function fn()
			local getSnapshot3 = refs.getSnapshot
			local setSnapshot = refs.setSnapshot

			local success, result = pcall(function()
				setSnapshot(getSnapshot3(source2._source))

				markRootMutableRead(workInProgressRoot, (requestUpdateLane(v13)))
			end)

			if not success then
				setSnapshot(function()
					error(result)
				end)
			end
		end

		local v14 = subscribe2(source2._source, fn)

		if __DEV__ and type(v14) ~= "function" then
			console.error("Mutable source subscribe function must return an unsubscribe function.")
		end

		return v14
	end, { source2, subscribe2 })
	local v14 = is(getSnapshot2, getSnapshot) -- inferred equivalent call
	local queue, v15

	if v14 then
		if is(source, source2) then -- inferred equivalent call
			if not is(subscribe, subscribe2) then -- inferred equivalent call
				queue = {
					pending = nil,
					dispatch = nil,
					lastRenderedReducer = basicStateReducer,
					lastRenderedState = v11
				}

				v15 = v4

				setState = function(...)
					dispatchAction(v15, queue, ...)
				end
				queue.dispatch = setState
				v12.queue = queue
				v12.baseQueue = nil
				v11 = readFromUnsubcribedMutableSource(workInProgressRoot, source2, getSnapshot)
				v12.baseState = v11
				v12.memoizedState = v12.baseState
			end
		else
			queue = {
				pending = nil,
				dispatch = nil,
				lastRenderedReducer = basicStateReducer,
				lastRenderedState = v11
			}

			v15 = v4

			setState = function(...)
				dispatchAction(v15, queue, ...)
			end
			queue.dispatch = setState
			v12.queue = queue
			v12.baseQueue = nil
			v11 = readFromUnsubcribedMutableSource(workInProgressRoot, source2, getSnapshot)
			v12.baseState = v11
			v12.memoizedState = v12.baseState
		end
	else
		queue = {
			pending = nil,
			dispatch = nil,
			lastRenderedReducer = basicStateReducer,
			lastRenderedState = v11
		}

		v15 = v4

		setState = function(...)
			dispatchAction(v15, queue, ...)
		end
		queue.dispatch = setState
		v12.queue = queue
		v12.baseQueue = nil
		v11 = readFromUnsubcribedMutableSource(workInProgressRoot, source2, getSnapshot)
		v12.baseState = v11
		v12.memoizedState = v12.baseState
	end

	return v11
end

function mountMutableSource(source, getSnapshot, subscribe)
	local v11 = mountWorkInProgressHook()
	v11.memoizedState = {
		refs = { getSnapshot = getSnapshot, setSnapshot = nil },
		source = source,
		subscribe = subscribe
	}

	return useMutableSource(v11, source, getSnapshot, subscribe)
end

function updateMutableSource(p, p2, p3)
	local v11 = updateWorkInProgressHook()
	return useMutableSource(v11, p, p2, p3)
end

function mountState(baseState)
	local v11 = mountWorkInProgressHook()

	if type(baseState) == "function" then
		baseState = baseState()
	end

	v11.baseState = baseState
	v11.memoizedState = v11.baseState
	local queue = {
		pending = nil,
		dispatch = nil,
		lastRenderedReducer = basicStateReducer,
		lastRenderedState = baseState
	}

	v11.queue = queue

	local v12 = v4
	local function fn(p, ...)
		dispatchAction(v12, queue, p, ...)
	end
	queue.dispatch = fn

	return v11.memoizedState, fn
end

function updateState(p)
	return updateReducer(basicStateReducer, p)
end

function rerenderState(p)
	return rerenderReducer(basicStateReducer, p)
end

local function reuseFunctionComponentUpdateQueue()
	local alternate = v4.alternate
	local updateQueue

	if alternate ~= nil then
		updateQueue = alternate.updateQueue
	end

	local alternate2

	if updateQueue ~= nil then
		alternate2 = updateQueue.alternate
	end

	if alternate2 == nil then
		v6 = nil
		v7 = nil

		if updateQueue == nil then
			return { lastEffect = nil }
		end

		local alternate4 = { lastEffect = nil, alternate = updateQueue }

		updateQueue.alternate = alternate4
		return alternate4
	else
		local lastEffect = alternate2.lastEffect
		v7 = lastEffect
		local v11

		if lastEffect ~= nil then
			v11 = lastEffect.next
		end

		v6 = v11
		alternate2.lastEffect = nil
		return alternate2
	end
end

local function pushEffect(tag, create, destroy, deps)
	if enableHookDoubleBuffering then
		local updateQueue = v4.updateQueue

		if updateQueue == nil then
			updateQueue = reuseFunctionComponentUpdateQueue()
			v4.updateQueue = updateQueue
		end

		local v11 = v6

		if v11 == nil then
			v11 = {
				tag = tag,
				create = create,
				destroy = destroy,
				deps = deps,
				next = nil
			}
		else
			local v12

			if v11 ~= v7 then
				v12 = v11.next
			end

			v6 = v12
			v11.tag = tag
			v11.create = create

			if destroy ~= nil or v11.destroy ~= nil then
				v11.destroy = destroy
			end

			v11.deps = deps
		end

		local lastEffect = updateQueue.lastEffect

		if lastEffect == nil then
			v11.next = v11
		else
			v11.next = lastEffect.next
			lastEffect.next = v11
		end

		updateQueue.lastEffect = v11
		return v11
	else
		local v11 = {
			tag = tag,
			create = create,
			destroy = destroy,
			deps = deps,
			next = nil
		}

		local updateQueue = v4.updateQueue

		if updateQueue == nil then
			local updateQueue2 = { lastEffect = nil }

			v4.updateQueue = updateQueue2
			v11.next = v11
			updateQueue2.lastEffect = v11
			return v11
		else
			local lastEffect = updateQueue.lastEffect

			if lastEffect == nil then
				updateQueue.lastEffect = v11
				v11.next = v11
				return v11
			else
				local nextNode = lastEffect.next
				lastEffect.next = v11
				v11.next = nextNode
				updateQueue.lastEffect = v11

				return v11
			end
		end
	end
end

function mountBinding(p)
	local v11 = mountWorkInProgressHook()
	local binding, baseState = createBinding(p)

	if not enableAllocationTrims then
		v11.memoizedState = { binding, baseState }

		return binding, baseState
	end

	v11.memoizedState = binding
	v11.baseState = baseState
	return binding, baseState
end

function updateBinding(_)
	local v11 = updateWorkInProgressHook()

	if enableAllocationTrims then
		return v11.memoizedState, v11.baseState
	end

	return unpack(v11.memoizedState)
end

function mountRef(current)
	local v11 = mountWorkInProgressHook()

	local ref = createRef()
	ref.current = current

	v11.memoizedState = ref
	return ref
end

function updateRef(_)
	return updateWorkInProgressHook().memoizedState
end

local function mountEffectImpl(p, layout, fn, joined) -- 4 equivalent calls inferred from this helper
	local v11 = mountWorkInProgressHook()

	v4.flags = bit32.bor(v4.flags, p)

	v11.memoizedState = pushEffect(bit32.bor(HasEffect, layout), fn, nil, joined)
end

function updateEffectImpl(p, tag, create, deps)
	local v11 = updateWorkInProgressHook()
	local destroy

	if alternate3 ~= nil then
		local memoizedState = alternate3.memoizedState
		destroy = memoizedState.destroy

		if deps ~= nil and areHookInputsEqual(deps, memoizedState.deps) then
			v11.memoizedState = pushEffect(tag, create, destroy, deps)
			return
		end
	end

	v4.flags = bit32.bor(v4.flags, p)

	v11.memoizedState = pushEffect(bit32.bor(HasEffect, tag), create, destroy, deps)
end

local function mountEffect(create, deps)
	if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
		warnIfNotCurrentlyActingEffectsInDEV(v4)
	end

	if __DEV__ and enableDoubleInvokingEffects then
		mountEffectImpl(bit32.bor(MountPassiveDev, Passive, PassiveStatic), passive, create, deps) -- inferred equivalent call
	else
		mountEffectImpl(bit32.bor(Passive, PassiveStatic), passive, create, deps) -- inferred equivalent call
	end
end

local function updateEffect(callback, p)
	if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
		warnIfNotCurrentlyActingEffectsInDEV(v4)
	end

	updateEffectImpl(Passive, passive, callback, p)
end

local function mountLayoutEffect(create, deps)
	if __DEV__ and enableDoubleInvokingEffects then
		mountEffectImpl(bit32.bor(MountLayoutDev, Update), Layout, create, deps) -- inferred equivalent call
	else
		mountEffectImpl(Update, Layout, create, deps) -- inferred equivalent call
	end
end

local function updateLayoutEffect(callback, p)
	updateEffectImpl(Update, Layout, callback, p)
end

function imperativeHandleEffect(callback, callback2)
	if callback2 ~= nil and type(callback2) == "function" then
		callback2((callback()))
		return function()
			return callback2(nil)
		end
	end

	if callback2 == nil then
		return nil
	end

	if __DEV__ then
		local v11

		if getmetatable(callback2) == nil then
			v11 = false
		else
			v11 = #Object.keys(callback2) == 0
		end

		if not v11 then
			console.error(
				"Expected useImperativeHandle() first argument to either be a ref callback or React.createRef() object. Instead received: %s.",
				"an object with keys {" .. Array.join(Object.keys(callback2), ", ") .. "}"
			)
		end
	end

	callback2.current = callback()
	return function()
		callback2.current = nil
	end
end

function mountImperativeHandle(p, callback, p2)
	if __DEV__ and type(callback) ~= "function" then
		console.error(
			"Expected useImperativeHandle() second argument to be a function that creates a handle. Instead received: %s.",
			callback == nil and "nil" or type(callback)
		)
	end

	local joined

	if p2 ~= nil then
		joined = Array.concat(p2, { p })
	end

	if __DEV__ and enableDoubleInvokingEffects then
		return mountEffectImpl(bit32.bor(MountLayoutDev, Update), Layout, function()
			return imperativeHandleEffect(callback, p)
		end, joined)
	end

	return mountEffectImpl(Update, Layout, function()
		return imperativeHandleEffect(callback, p)
	end, joined)
end

function updateImperativeHandle(p, callback, p2)
	if __DEV__ and type(callback) ~= "function" then
		local v11 = not callback and "nil" or type(callback)

		console.error(
			"Expected useImperativeHandle() second argument to be a function that creates a handle. Instead received: %s.",
			v11
		)
	end

	local clone

	if p2 ~= nil then
		clone = table.clone(p2)
		table.insert(clone, p)
	end

	return updateEffectImpl(Update, Layout, function()
		return imperativeHandleEffect(callback, p)
	end, clone)
end

function mountDebugValue(_, _) end

local mountDebugValue2 = mountDebugValue

function mountCallback(memoizedState, baseState)
	local v11 = mountWorkInProgressHook()

	if not enableAllocationTrims then
		v11.memoizedState = { memoizedState, baseState }

		return memoizedState
	end

	v11.memoizedState = memoizedState
	v11.baseState = baseState
	return memoizedState
end

function updateCallback(memoizedState, baseState)
	local v11 = updateWorkInProgressHook()

	if enableAllocationTrims then
		if baseState ~= nil and areHookInputsEqual(baseState, v11.baseState) then
			return v11.memoizedState
		end

		v11.memoizedState = memoizedState
		v11.baseState = baseState
		return memoizedState
	else
		local memoizedState2 = v11.memoizedState

		if memoizedState2 ~= nil and baseState ~= nil and areHookInputsEqual(baseState, memoizedState2[2]) then
			return memoizedState2[1]
		end

		v11.memoizedState = { memoizedState, baseState }
		return memoizedState
	end
end

function mountMemo(callback, baseState)
	local v11 = mountWorkInProgressHook()

	if enableAllocationTrims then
		local pack = MemoValues.pack(callback())
		v11.memoizedState = pack
		v11.baseState = baseState
		return MemoValues.unpack(pack)
	else
		local v12 = { callback() }
		v11.memoizedState = { v12, baseState }
		return unpack(v12)
	end
end

function updateMemo(callback, baseState)
	local v11 = updateWorkInProgressHook()

	if enableAllocationTrims then
		if baseState ~= nil and areHookInputsEqual(baseState, v11.baseState) then
			return MemoValues.unpack(v11.memoizedState)
		end

		local pack = MemoValues.pack(callback())
		v11.memoizedState = pack
		v11.baseState = baseState
		return MemoValues.unpack(pack)
	else
		local memoizedState = v11.memoizedState

		if memoizedState ~= nil and baseState ~= nil and areHookInputsEqual(baseState, memoizedState[2]) then
			return unpack(memoizedState[1])
		end

		local v12 = { callback() }
		v11.memoizedState = { v12, baseState }
		return unpack(v12)
	end
end

function New.getIsUpdatingOpaqueValueInRenderPhaseInDEV(): nil | boolean
	return if __DEV__ then false else nil
end

function mountOpaqueIdentifier()
	local v11 = nil

	if __DEV__ then
		console.warn("!!! unimplemented: warnOnOpaqueIdentifierAccessInDEV")
	else
		v11 = makeClientId
	end

	if getIsHydrating() then
		unimplemented("ReactFiberHooks: getIsHydrating() true") -- inferred equivalent call
		return nil
	else
		local v12 = v11()
		mountState(v12)
		return v12
	end
end

function updateOpaqueIdentifier()
	local v11, _ = updateState(nil)
	return v11
end

function rerenderOpaqueIdentifier()
	local v11, _ = rerenderState(nil)
	return v11
end

function dispatchAction(data, state, action, ...)
	if __DEV__ then
		local v11

		if select("#", ...) == 1 then
			v11 = select(1, ...)
		end

		if type(v11) == "function" then
			console.error("State updates from the useState() and useReducer() Hooks don't support the second callback argument. To execute a side effect after rendering, declare it in the component body with useEffect().")
		end
	end

	local v11 = requestEventTime()
	local lane = requestUpdateLane(data)

	local v12 = {
		lane = lane,
		action = action,
		eagerReducer = nil,
		eagerState = nil,
		next = nil
	}

	local pending = state.pending

	if pending == nil then
		v12.next = v12
	else
		v12.next = pending.next
		pending.next = v12
	end

	state.pending = v12

	local alternate = data.alternate

	if data == v4 or alternate ~= nil and alternate == v4 then
		flag = true
		flag2 = true
	else
		if data.lanes == NoLanes and (alternate == nil or alternate.lanes == NoLanes) then
			local lastRenderedReducer = state.lastRenderedReducer

			if lastRenderedReducer ~= nil then
				local current

				if __DEV__ then
					current = ReactCurrentDispatcher.current
					ReactCurrentDispatcher.current = current6
				end

				local lastRenderedState = state.lastRenderedState

				local success, result = pcall(lastRenderedReducer, lastRenderedState, action)

				if success then
					v12.eagerReducer = lastRenderedReducer
					v12.eagerState = result
				end

				if __DEV__ then
					ReactCurrentDispatcher.current = current
				end

				if ReactFeatureFlags.fixEagerReducerError then
					if success and is(result, lastRenderedState) then -- inferred equivalent call
						if not v then
							return
						end

						if pending == nil then
							state.pending = nil
							return
						end

						pending.next = v12.next
						state.pending = pending

						return
					end
				elseif is(result, lastRenderedState) then -- inferred equivalent call
					if not v then
						return
					end

					if pending == nil then
						state.pending = nil
						return
					end

					pending.next = v12.next
					state.pending = pending

					return
				end
			end
		end

		if __DEV__ and (type(_G.jest) ~= "nil" or ReactGlobals.__TESTEZ_RUNNING_TEST__) then
			warnIfNotScopedWithMatchingAct(data)
			warnIfNotCurrentlyActingUpdatesInDEV(data)
		end

		scheduleUpdateOnFiber(data, lane, v11)
	end

	if __DEV__ and enableDebugTracing and bit32.band(data.mode, DebugTracingMode) ~= 0 then
		logStateUpdateScheduled(getComponentName(data.type) or "Unknown", lane, action)
	end

	if enableSchedulingProfiler then
		markStateUpdateScheduled(data, lane)
	end
end

local v11 = {
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

New.ContextOnlyDispatcher = v11

local v12 = {
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

local v13 = {
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
	useDebugValue = mountDebugValue2,
	useMutableSource = updateMutableSource,
	useOpaqueIdentifier = updateOpaqueIdentifier,
	unstable_isNewReconciler = enableNewReconciler
}

local v14 = {
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
	useDebugValue = mountDebugValue2,
	useMutableSource = updateMutableSource,
	useOpaqueIdentifier = rerenderOpaqueIdentifier,
	unstable_isNewReconciler = enableNewReconciler
}

local function fn() -- 3 equivalent calls inferred from this helper
	console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")
end

local function fn2() -- 39 equivalent calls inferred from this helper
	console.error("Do not call Hooks inside useEffect(...), useMemo(...), or other built-in Hooks. You can only call Hooks at the top level of your React function. For more information, see https://reactjs.org/link/rules-of-hooks")
end

if __DEV__ then
	local function restoreDispatcherAndReturn(current, flag3: boolean, ...)
		ReactCurrentDispatcher.current = current

		if not flag3 then
			error((...))
		end

		return ...
	end

	current2 = {
		readContext = function(p, p2)
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			mountHookTypesDev() -- inferred equivalent call
			checkDepsAreArrayDev(p2) -- inferred equivalent call
			return mountCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			mountHookTypesDev() -- inferred equivalent call
			return readContext(p, p2)
		end,
		useEffect = function(create, deps)
			v8 = "useEffect"
			mountHookTypesDev() -- inferred equivalent call
			checkDepsAreArrayDev(deps) -- inferred equivalent call
			return mountEffect(create, deps)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			mountHookTypesDev() -- inferred equivalent call
			checkDepsAreArrayDev(p2) -- inferred equivalent call
			return mountImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(create, deps)
			v8 = "useLayoutEffect"
			mountHookTypesDev() -- inferred equivalent call
			checkDepsAreArrayDev(deps) -- inferred equivalent call
			return mountLayoutEffect(create, deps)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			mountHookTypesDev() -- inferred equivalent call
			checkDepsAreArrayDev(p) -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(mountMemo, callback, p))
			end

			local v15 = { pcall(mountMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			mountHookTypesDev() -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5
			local success, result, v15 = pcall(mountReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			mountHookTypesDev() -- inferred equivalent call
			return mountRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			mountHookTypesDev() -- inferred equivalent call
			return mountBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			mountHookTypesDev() -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			local success, result, v15 = pcall(mountState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			mountHookTypesDev() -- inferred equivalent call
			return mountDebugValue(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			mountHookTypesDev() -- inferred equivalent call
			return mountMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			mountHookTypesDev() -- inferred equivalent call
			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	current3 = {
		readContext = function(p, p2)
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			updateHookTypesDev()
			checkDepsAreArrayDev(p2) -- inferred equivalent call
			return mountCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			updateHookTypesDev()
			return readContext(p, p2)
		end,
		useEffect = function(create, deps)
			v8 = "useEffect"
			updateHookTypesDev()
			return mountEffect(create, deps)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			updateHookTypesDev()
			return mountImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(create, deps)
			v8 = "useLayoutEffect"
			updateHookTypesDev()
			return mountLayoutEffect(create, deps)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(mountMemo, callback, p))
			end

			local v15 = { pcall(mountMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5
			local success, result, v15 = pcall(mountReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			updateHookTypesDev()
			return mountRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			updateHookTypesDev()
			return mountBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			local success, result, v15 = pcall(mountState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			updateHookTypesDev()
			return mountDebugValue(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			updateHookTypesDev()
			return mountMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			updateHookTypesDev()
			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	current4 = {
		readContext = function(p, p2)
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			updateHookTypesDev()
			return updateCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			updateHookTypesDev()
			return readContext(p, p2)
		end,
		useEffect = function(callback, p)
			v8 = "useEffect"
			updateHookTypesDev()
			return updateEffect(callback, p)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			updateHookTypesDev()
			return updateImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(callback, p)
			v8 = "useLayoutEffect"
			updateHookTypesDev()
			return updateLayoutEffect(callback, p)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(updateMemo, callback, p))
			end

			local v15 = { pcall(updateMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6
			local success, result, v15 = pcall(updateReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			updateHookTypesDev()
			return updateRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			updateHookTypesDev()
			return updateBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			local success, result, v15 = pcall(updateState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			updateHookTypesDev()
			return mountDebugValue2(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			updateHookTypesDev()
			return updateMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			updateHookTypesDev()
			return updateOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	v9 = {
		readContext = function(p, p2)
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			updateHookTypesDev()
			return updateCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			updateHookTypesDev()
			return readContext(p, p2)
		end,
		useEffect = function(callback, p)
			v8 = "useEffect"
			updateHookTypesDev()
			return updateEffect(callback, p)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			updateHookTypesDev()
			return updateImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(callback, p)
			v8 = "useLayoutEffect"
			updateHookTypesDev()
			return updateLayoutEffect(callback, p)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current7

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(updateMemo, callback, p))
			end

			local v15 = { pcall(updateMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current7

			local success, result, v15 = pcall(rerenderReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			updateHookTypesDev()
			return updateRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			updateHookTypesDev()
			return updateBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current7

			local success, result, v15 = pcall(rerenderState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			updateHookTypesDev()
			return mountDebugValue2(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			updateHookTypesDev()
			return updateMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			updateHookTypesDev()
			return rerenderOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	current5 = {
		readContext = function(p, p2)
			fn() -- inferred equivalent call
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return readContext(p, p2)
		end,
		useEffect = function(create, deps)
			v8 = "useEffect"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountEffect(create, deps)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(create, deps)
			v8 = "useLayoutEffect"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountLayoutEffect(create, deps)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(mountMemo, callback, p))
			end

			local v15 = { pcall(mountMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5
			local success, result, v15 = pcall(mountReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current5

			local success, result, v15 = pcall(mountState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountDebugValue(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			fn2() -- inferred equivalent call
			mountHookTypesDev() -- inferred equivalent call
			return mountOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	current6 = {
		readContext = function(p, p2)
			fn() -- inferred equivalent call
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return mountCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return readContext(p, p2)
		end,
		useEffect = function(callback, p)
			v8 = "useEffect"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateEffect(callback, p)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(callback, p)
			v8 = "useLayoutEffect"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateLayoutEffect(callback, p)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(updateMemo, callback, p))
			end

			local v15 = { pcall(updateMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6
			local success, result, v15 = pcall(updateReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			local success, result, v15 = pcall(updateState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return mountDebugValue2(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}

	current7 = {
		readContext = function(p, p2)
			fn() -- inferred equivalent call
			return readContext(p, p2)
		end,
		useCallback = function(p, p2)
			v8 = "useCallback"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateCallback(p, p2)
		end,
		useContext = function(p, p2)
			v8 = "useContext"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return readContext(p, p2)
		end,
		useEffect = function(callback, p)
			v8 = "useEffect"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateEffect(callback, p)
		end,
		useImperativeHandle = function(p, callback, p2)
			v8 = "useImperativeHandle"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateImperativeHandle(p, callback, p2)
		end,
		useLayoutEffect = function(callback, p)
			v8 = "useLayoutEffect"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateLayoutEffect(callback, p)
		end,
		useMemo = function(callback, p)
			v8 = "useMemo"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			if enableAllocationTrims then
				return restoreDispatcherAndReturn(current, pcall(updateMemo, callback, p))
			end

			local v15 = { pcall(updateMemo, callback, p) }
			ReactCurrentDispatcher.current = current

			if not v15[1] then
				error(v15[2])
			end

			return unpack(v15, 2)
		end,
		useReducer = function(callback, p, callback2)
			v8 = "useReducer"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			local success, result, v15 = pcall(rerenderReducer, callback, p, callback2)

			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useRef = function(p)
			v8 = "useRef"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateRef(p)
		end,
		useBinding = function(p)
			v8 = "useBinding"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateBinding(p)
		end,
		useState = function(p)
			v8 = "useState"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			local current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = current6

			local success, result, v15 = pcall(rerenderState, p)
			ReactCurrentDispatcher.current = current

			if not success then
				error(result)
			end

			return result, v15
		end,
		useDebugValue = function(p, callback)
			v8 = "useDebugValue"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return mountDebugValue2(p, callback)
		end,
		useMutableSource = function(p, p2, p3)
			v8 = "useMutableSource"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return updateMutableSource(p, p2, p3)
		end,
		useOpaqueIdentifier = function()
			v8 = "useOpaqueIdentifier"
			fn2() -- inferred equivalent call
			updateHookTypesDev()
			return rerenderOpaqueIdentifier()
		end,
		unstable_isNewReconciler = enableNewReconciler
	}
end

function New:renderWithHooks(state, callback, p, p2, p3)
	v3 = p3
	v4 = state

	if __DEV__ then
		local v15

		if self ~= nil then
			v15 = self._debugHookTypes
		end

		debugHookTypes = v15

		count = 0
	end

	if ReactFeatureFlags.enableWorkLoopTrims then
		if state.memoizedState ~= nil then
			state.memoizedState = nil
		end

		if state.updateQueue ~= nil then
			state.updateQueue = nil
		end
	else
		state.memoizedState = nil

		state.updateQueue = nil
	end

	state.lanes = NoLanes

	if __DEV__ then
		if self == nil or self.memoizedState == nil then
			if debugHookTypes == nil then
				ReactCurrentDispatcher.current = current2
			else
				ReactCurrentDispatcher.current = current3
			end
		else
			ReactCurrentDispatcher.current = current4
		end
	else
		ReactCurrentDispatcher.current = (self == nil or self.memoizedState == nil) and v12 or v13
	end

	local v15 = callback(p, p2)

	if flag2 then
		local count2 = 0

		repeat
			flag2 = false

			if count2 >= 25 then
				error(Error.new("Too many re-renders. React limits the number of renders to prevent an infinite loop."))
			end

			count2 += 1

			alternate3 = nil
			v5 = nil

			state.updateQueue = nil

			if __DEV__ then
				count = 0
			end

			ReactCurrentDispatcher.current = __DEV__ and v9 or v14

			v15 = callback(p, p2)
		until not flag2
	end

	ReactCurrentDispatcher.current = v11

	if __DEV__ then
		state._debugHookTypes = debugHookTypes
	end

	local v16

	if alternate3 == nil then
		v16 = false
	else
		v16 = alternate3.next ~= nil
	end

	v3 = NoLanes
	v4 = nil

	alternate3 = nil
	v5 = nil

	if enableHookDoubleBuffering then
		v6 = nil
		v7 = nil
	end

	if __DEV__ then
		v8 = nil
		debugHookTypes = nil
		count = 0
	end

	flag = false

	if v16 then
		local v17 = "unknown"
		v17 = v15 and v15.type and getComponentName(v15.type) or v17

		error(Error.new("Rendered fewer hooks than expected. This may be caused by an accidental " .. "early return statement. Inside '" .. v17 .. "'"))
	end

	return v15
end

return New
