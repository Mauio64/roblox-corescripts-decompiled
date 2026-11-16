local function unimplemented(p: string) -- 1 equivalent call inferred from this helper
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(p))
	error("FIXME (roblox): " .. p .. " is unimplemented", 2)
end

local parent = script.Parent.Parent

local Shared = require(parent.Shared)
local console = Shared.console
local v = require(parent.LuauPolyfill)
local array = v.Array
local object = v.Object
local inspect = v.util.inspect

local ReactGlobals = require(parent.ReactGlobals)
local __DEV__ = ReactGlobals.__DEV__

local ReactGlobals2 = require(parent.ReactGlobals)
local __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = ReactGlobals2.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__
local ReactGlobals3 = require(parent.ReactGlobals)
local __COMPAT_WARNINGS__ = ReactGlobals3.__COMPAT_WARNINGS__

require(parent.Shared)

require(parent.React)

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent["ReactFiberSuspenseComponent.new"])

v = require(script.Parent["ReactFiberSuspenseContext.new"])

require(script.Parent.ReactFiberOffscreenComponent)

local Shared2 = require(parent.Shared)
local checkPropTypes = Shared2.checkPropTypes

local ReactWorkTags = require(script.Parent.ReactWorkTags)

local FunctionComponent = ReactWorkTags.FunctionComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local ForwardRef = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local Mode = ReactWorkTags.Mode
local ContextProvider = ReactWorkTags.ContextProvider
local ContextConsumer = ReactWorkTags.ContextConsumer
local Profiler = ReactWorkTags.Profiler
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local LazyComponent = ReactWorkTags.LazyComponent
local IncompleteClassComponent = ReactWorkTags.IncompleteClassComponent

local OffscreenComponent = ReactWorkTags.OffscreenComponent
local LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent
local v2 = require(script.Parent.ReactFiberFlags)
local noFlags = v2.NoFlags
local staticMask = v2.StaticMask
local performedWork = v2.PerformedWork
local placement = v2.Placement
local hydrating = v2.Hydrating
local contentReset = v2.ContentReset
local didCapture = v2.DidCapture

local ref = v2.Ref
local deletion = v2.Deletion
local forceUpdateForLegacySuspense = v2.ForceUpdateForLegacySuspense
local Shared3 = require(parent.Shared)
v2 = Shared3.ReactSharedInternals
local Shared4 = require(parent.Shared)
local ReactFeatureFlags = Shared4.ReactFeatureFlags

local debugRenderPhaseSideEffectsForStrictMode = ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
local disableLegacyContext = ReactFeatureFlags.disableLegacyContext
local disableModulePatternComponents = ReactFeatureFlags.disableModulePatternComponents
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer

local warnAboutDefaultPropsOnFunctionComponents = ReactFeatureFlags.warnAboutDefaultPropsOnFunctionComponents

local Shared5 = require(parent.Shared)
local invariant = Shared5.invariant
local Shared6 = require(parent.Shared)
local describeError = Shared6.describeError
local Shared7 = require(parent.Shared)
local shallowEqual = Shared7.shallowEqual
local Shared8 = require(parent.Shared)
local getComponentName = Shared8.getComponentName
local Shared9 = require(parent.Shared)
local v3 = Shared9.ReactSymbols
local REACT_LAZY_TYPE = v3.REACT_LAZY_TYPE
local getIteratorFn = v3.getIteratorFn
local ReactStrictModeWarningsnew = require(script.Parent["ReactStrictModeWarnings.new"])
v3 = require(script.Parent.ReactCurrentFiber)

local getCurrentFiberOwnerNameInDevOrNull = v3.getCurrentFiberOwnerNameInDevOrNull
local setIsRendering = v3.setIsRendering
v3 = require(script.Parent["ReactFiberHotReloading.new"])

local resolveFunctionForHotReloading = v3.resolveFunctionForHotReloading

local resolveForwardRefForHotReloading = v3.resolveForwardRefForHotReloading

local resolveClassForHotReloading = v3.resolveClassForHotReloading

v3 = require(script.Parent["ReactChildFiber.new"])
local mountChildFibers = v3.mountChildFibers
local reconcileChildFibers = v3.reconcileChildFibers
local cloneChildFibers = v3.cloneChildFibers
v3 = require(script.Parent["ReactUpdateQueue.new"])
local processUpdateQueue = v3.processUpdateQueue
local cloneUpdateQueue = v3.cloneUpdateQueue
local initializeUpdateQueue = v3.initializeUpdateQueue
v3 = require(script.Parent.ReactTypeOfMode)
local concurrentMode = v3.ConcurrentMode
local noMode = v3.NoMode
local profileMode = v3.ProfileMode
local strictMode = v3.StrictMode
local blockingMode = v3.BlockingMode
v3 = require(script.Parent.ReactFiberHostConfig)
local shouldSetTextContent = v3.shouldSetTextContent
local isSuspenseInstancePending = v3.isSuspenseInstancePending
local isSuspenseInstanceFallback = v3.isSuspenseInstanceFallback
local registerSuspenseInstanceRetry = v3.registerSuspenseInstanceRetry
local supportsHydration = v3.supportsHydration

v3 = require(script.Parent["ReactFiberHostContext.new"])
local pushHostContext = v3.pushHostContext
local pushHostContainer = v3.pushHostContainer
local suspenseStackCursor = v.suspenseStackCursor
local hasSuspenseContext = v.hasSuspenseContext
local forceSuspenseFallback = v.ForceSuspenseFallback
local addSubtreeSuspenseContext = v.addSubtreeSuspenseContext

local invisibleParentSuspenseContext = v.InvisibleParentSuspenseContext
local pushSuspenseContext = v.pushSuspenseContext

local setDefaultShallowSuspenseContext = v.setDefaultShallowSuspenseContext

v = require(script.Parent["ReactFiberNewContext.new"])
local propagateContextChange = v.propagateContextChange
local readContext = v.readContext
local calculateChangedBits = v.calculateChangedBits

local prepareToReadContext = v.prepareToReadContext
local pushProvider = v.pushProvider

local v4 = { renderWithHooksRef = nil, bailoutHooksRef = nil, shouldSuspendRef = nil }

local function shouldSuspend(state) -- 1 equivalent call inferred from this helper
	if not v4.shouldSuspendRef then
		local ReactFiberReconciler = require(script.Parent.ReactFiberReconciler)
		v4.shouldSuspendRef = ReactFiberReconciler.shouldSuspend
	end

	return v4.shouldSuspendRef(state)
end

local function initReactFiberHooks() -- 2 equivalent calls inferred from this helper
	local ReactFiberHooksnew = require(script.Parent["ReactFiberHooks.new"])
	v4.renderWithHooksRef = ReactFiberHooksnew.renderWithHooks
	v4.bailoutHooksRef = ReactFiberHooksnew.bailoutHooks
end

local function renderWithHooks(...)
	if not v4.renderWithHooksRef then
		initReactFiberHooks() -- inferred equivalent call
	end

	return v4.renderWithHooksRef(...)
end

local function bailoutHooks(...)
	if not v4.bailoutHooksRef then
		initReactFiberHooks() -- inferred equivalent call
	end

	return v4.bailoutHooksRef(...)
end

local ReactProfilerTimernew = require(script.Parent["ReactProfilerTimer.new"])
local stopProfilerTimerIfRunning = ReactProfilerTimernew.stopProfilerTimerIfRunning
v = require(script.Parent["ReactFiberContext.new"])
local getMaskedContext = v.getMaskedContext
local getUnmaskedContext = v.getUnmaskedContext
local hasContextChanged = v.hasContextChanged
local pushContextProvider = v.pushContextProvider
local isContextProvider = v.isContextProvider
local pushTopLevelContextObject = v.pushTopLevelContextObject
local invalidateContextProvider = v.invalidateContextProvider

v = require(script.Parent["ReactFiberHydrationContext.new"])
local resetHydrationState = v.resetHydrationState
local enterHydrationState = v.enterHydrationState

local reenterHydrationStateFromDehydratedSuspenseInstance = v.reenterHydrationStateFromDehydratedSuspenseInstance

local tryToClaimNextHydratableInstance = v.tryToClaimNextHydratableInstance
local warnIfHydrating = v.warnIfHydrating

v = require(script.Parent["ReactFiberClassComponent.new"])
local adoptClassInstance = v.adoptClassInstance
local applyDerivedStateFromProps = v.applyDerivedStateFromProps
local constructClassInstance = v.constructClassInstance
local mountClassInstance = v.mountClassInstance
local resumeMountClassInstance = v.resumeMountClassInstance
local updateClassInstance = v.updateClassInstance

local ReactFiberLazyComponentnew = require(script.Parent["ReactFiberLazyComponent.new"])
local resolveDefaultProps = ReactFiberLazyComponentnew.resolveDefaultProps
v = require(script.Parent["ReactFiber.new"])
local resolveLazyComponentTag = v.resolveLazyComponentTag
local createFiberFromFragment = v.createFiberFromFragment
local createFiberFromOffscreen = v.createFiberFromOffscreen

local createFiberFromTypeAndProps = v.createFiberFromTypeAndProps
local isSimpleFunctionComponent = v.isSimpleFunctionComponent
local createWorkInProgress = v.createWorkInProgress
v = require(script.Parent["ReactFiberWorkLoop.new"])
local pushRenderLanes = v.pushRenderLanes
local markSpawnedWork = v.markSpawnedWork
local retryDehydratedSuspenseBoundary = v.retryDehydratedSuspenseBoundary
local scheduleUpdateOnFiber = v.scheduleUpdateOnFiber
local renderDidSuspendDelayIfPossible = v.renderDidSuspendDelayIfPossible
local getWorkInProgressRoot = v.getWorkInProgressRoot
local getExecutionContext = v.getExecutionContext
local retryAfterError = v.RetryAfterError
local noContext = v.NoContext

local unstable_wrap = nil

local ReactMutableSourcenew = require(script.Parent["ReactMutableSource.new"])
local setWorkInProgressVersion = ReactMutableSourcenew.setWorkInProgressVersion

local ReactFiberWorkInProgress = require(script.Parent.ReactFiberWorkInProgress)
local markSkippedUpdateLanes = ReactFiberWorkInProgress.markSkippedUpdateLanes
local Shared10 = require(parent.Shared)
v = Shared10.ConsolePatchingDev
local disableLogs = v.disableLogs
local reenableLogs = v.reenableLogs

local reactCurrentOwner = v2.ReactCurrentOwner

local New = {}

local bailoutOnAlreadyFinishedWork
local updateFunctionComponent

local v5 = false

local v6 = {
	didWarnAboutBadClass = {},
	didWarnAboutModulePatternComponent = {},
	didWarnAboutContextTypeOnFunctionComponent = {},
	didWarnAboutGetDerivedStateOnFunctionComponent = {},
	didWarnAboutFunctionRefs = {},
	didWarnAboutDefaultPropsOnFunctionComponent = {}
}

local updateSimpleMemoComponent

if __DEV__ then
	v6.didWarnAboutBadClass = {}
	v6.didWarnAboutModulePatternComponent = {}
	v6.didWarnAboutContextTypeOnFunctionComponent = {}
	v6.didWarnAboutGetDerivedStateOnFunctionComponent = {}
	v6.didWarnAboutFunctionRefs = {}
	New.didWarnAboutReassigningProps = false

	v6.didWarnAboutDefaultPropsOnFunctionComponent = {}
end

local function reconcileChildren(p, p2, p3, p4)
	if p == nil then
		p2.child = mountChildFibers(p2, nil, p3, p4)
	elseif ReactFeatureFlags.enableWorkLoopTrims then
		local child = reconcileChildFibers(p2, p.child, p3, p4)

		if child ~= nil or p2.child ~= nil then
			p2.child = child
		end
	else
		p2.child = reconcileChildFibers(p2, p.child, p3, p4)
	end
end

local function forceUnmountCurrentAndReconcile(p, current, p2, p3) -- 1 equivalent call inferred from this helper
	current.child = reconcileChildFibers(current, p.child, nil, p3)

	current.child = reconcileChildFibers(current, nil, p2, p3)
end

local function updateForwardRef(p, current, data, p2, p3)
	if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and current.type ~= current.elementType then
		local propTypes = data.propTypes
		local validateProps = data.validateProps

		if propTypes or validateProps then
			checkPropTypes(propTypes, validateProps, p2, "prop", getComponentName(data))
		end
	end

	local render = data.render
	local ref2 = current.ref

	prepareToReadContext(current, p3, New.markWorkInProgressReceivedUpdate)
	local v7

	if __DEV__ then
		reactCurrentOwner.current = current
		setIsRendering(true)

		v7 = renderWithHooks(p, current, render, p2, ref2, p3)

		if debugRenderPhaseSideEffectsForStrictMode and bit32.band(current.mode, strictMode) ~= 0 then
			disableLogs()
			local success, result = xpcall(renderWithHooks, describeError, p, current, render, p2, ref2, p3)

			if success then
				v7 = result
			end

			reenableLogs()

			if not success then
				error(result)
			end
		end

		setIsRendering(false)
	else
		v7 = renderWithHooks(p, current, render, p2, ref2, p3)
	end

	if p ~= nil and not v5 then
		bailoutHooks(p, current, p3)
		return bailoutOnAlreadyFinishedWork(p, current, p3)
	end

	current.flags = bit32.bor(current.flags, performedWork)
	reconcileChildren(p, current, v7, p3)
	return current.child
end

local function updateMemoComponent(p, return_, data, p2, p3, p4)
	if p == nil then
		local kind = data.type

		if isSimpleFunctionComponent(kind) and data.compare == nil and data.defaultProps == nil then
			local v7

			if __DEV__ then
				v7 = resolveFunctionForHotReloading(kind)
			else
				v7 = kind
			end

			return_.tag = SimpleMemoComponent
			return_.type = v7

			if __DEV__ then
				validateFunctionComponentInDev(return_, kind)
			end

			return updateSimpleMemoComponent(nil, return_, v7, p2, p3, p4)
		else
			if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
				local propTypes, validateProps

				if type(kind) == "table" then
					propTypes = kind.propTypes
					validateProps = kind.validateProps
				end

				if propTypes or validateProps then
					checkPropTypes(propTypes, validateProps, p2, "prop", getComponentName(kind))
				end
			end

			local fiberFromTypeAndProps = createFiberFromTypeAndProps(data.type, nil, p2, return_, return_.mode, p4)

			fiberFromTypeAndProps.ref = return_.ref
			fiberFromTypeAndProps.return_ = return_
			return_.child = fiberFromTypeAndProps
			return fiberFromTypeAndProps
		end
	else
		if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
			local kind = data.type
			local propTypes, validateProps

			if type(kind) == "table" then
				propTypes = kind.propTypes
				validateProps = kind.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p2, "prop", getComponentName(kind))
			end
		end

		local child = p.child

		if not ReactFiberLane.includesSomeLane(p3, p4) then
			local memoizedProps = child.memoizedProps

			local v7 = data.compare

			if v7 == nil then
				v7 = shallowEqual
			end

			if v7(memoizedProps, p2) and p.ref == return_.ref then
				return bailoutOnAlreadyFinishedWork(p, return_, p4)
			end
		end

		return_.flags = bit32.bor(return_.flags, performedWork)
		local workInProgress = createWorkInProgress(child, p2)
		workInProgress.ref = return_.ref
		workInProgress.return_ = return_
		return_.child = workInProgress
		return workInProgress
	end
end

updateSimpleMemoComponent = function(data, state, p, p2, p3, p4)
	if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and state.type ~= state.elementType then
		local elementType = state.elementType

		if elementType["$$typeof"] == REACT_LAZY_TYPE then
			local payload = elementType._payload
			local init = elementType._init
			local success, result = xpcall(init, describeError, payload)

			if not success then
				result = nil
			end

			local propTypes, validateProps

			if not (result == nil or type(result) ~= "table") then
				propTypes = result.propTypes

				validateProps = result.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p2, "prop", getComponentName(result))
			end
		end
	end

	if data ~= nil then
		local memoizedProps = data.memoizedProps

		local v7 = not __DEV__ or state.type == data.type

		if shallowEqual(memoizedProps, p2) and data.ref == state.ref and v7 then
			v5 = false

			if ReactFiberLane.includesSomeLane(p4, p3) then
				if bit32.band(data.flags, forceUpdateForLegacySuspense) ~= noFlags then
					v5 = true
				end
			else
				state.lanes = data.lanes
				return bailoutOnAlreadyFinishedWork(data, state, p4)
			end
		end
	end

	return updateFunctionComponent(data, state, p, p2, p4)
end

local function updateOffscreenComponent(data, state, baseLanes2)
	local pendingProps = state.pendingProps
	local children = pendingProps.children
	local memoizedState

	if data ~= nil then
		memoizedState = data.memoizedState
	end

	if pendingProps.mode == "hidden" or pendingProps.mode == "unstable-defer-without-hiding" then
		if bit32.band(state.mode, concurrentMode) == noMode then
			state.memoizedState = { baseLanes = ReactFiberLane.NoLanes }
			pushRenderLanes(state, baseLanes2)
		elseif ReactFiberLane.includesSomeLane(baseLanes2, ReactFiberLane.OffscreenLane) then
			state.memoizedState = { baseLanes = ReactFiberLane.NoLanes }
			local v7

			if memoizedState == nil then
				v7 = baseLanes2
			else
				v7 = memoizedState.baseLanes
			end

			pushRenderLanes(state, v7)
		else
			if memoizedState ~= nil then
				local baseLanes = memoizedState.baseLanes
				baseLanes2 = ReactFiberLane.mergeLanes(baseLanes, baseLanes2)
			end

			if enableSchedulerTracing then
				markSpawnedWork(ReactFiberLane.OffscreenLane)
			end

			state.childLanes = ReactFiberLane.laneToLanes(ReactFiberLane.OffscreenLane)
			state.lanes = state.childLanes

			state.memoizedState = { baseLanes = baseLanes2 }

			pushRenderLanes(state, baseLanes2)
			return nil
		end
	else
		local v7

		if memoizedState == nil then
			v7 = baseLanes2
		else
			v7 = ReactFiberLane.mergeLanes(memoizedState.baseLanes, baseLanes2)

			state.memoizedState = nil
		end

		pushRenderLanes(state, v7)
	end

	reconcileChildren(data, state, children, baseLanes2)
	return state.child
end

function updateFragment(p, p2, p3)
	reconcileChildren(p, p2, p2.pendingProps, p3)
	return p2.child
end

function updateMode(p, p2, p3)
	reconcileChildren(p, p2, p2.pendingProps.children, p3)
	return p2.child
end

function updateProfiler(p, data, p2)
	if enableProfilerTimer then
		local stateNode = data.stateNode
		stateNode.effectDuration = 0
		stateNode.passiveEffectDuration = 0
	end

	reconcileChildren(p, data, data.pendingProps.children, p2)
	return data.child
end

local function markRef(p, state) -- 2 equivalent calls inferred from this helper
	local ref2 = state.ref

	if p == nil and ref2 ~= nil or p ~= nil and p.ref ~= ref2 then
		state.flags = bit32.bor(state.flags, ref)
	end
end

updateFunctionComponent = function(p, current, value, p2, p3)
	if
		(__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__)
		and type(value) ~= "function"
		and current.type ~= current.elementType
	then
		local propTypes, validateProps

		if type(value) == "table" then
			propTypes = value.propTypes
			validateProps = value.validateProps
		end

		if propTypes or validateProps then
			checkPropTypes(propTypes, validateProps, p2, "prop", getComponentName(value))
		end
	end

	local v7

	if not disableLegacyContext then
		v7 = getMaskedContext(current, (getUnmaskedContext(current, value, true)))
	end

	prepareToReadContext(current, p3, New.markWorkInProgressReceivedUpdate)
	local v8

	if __DEV__ then
		reactCurrentOwner.current = current
		setIsRendering(true)
		v8 = renderWithHooks(p, current, value, p2, v7, p3)

		if debugRenderPhaseSideEffectsForStrictMode and bit32.band(current.mode, strictMode) ~= 0 then
			disableLogs()
			local success, result = xpcall(renderWithHooks, describeError, p, current, value, p2, v7, p3)

			reenableLogs()

			if success then
				v8 = result
			else
				error(result)
			end
		end

		setIsRendering(false)
	else
		v8 = renderWithHooks(p, current, value, p2, v7, p3)
	end

	if p ~= nil and not v5 then
		bailoutHooks(p, current, p3)
		return bailoutOnAlreadyFinishedWork(p, current, p3)
	end

	current.flags = bit32.bor(current.flags, performedWork)
	reconcileChildren(p, current, v8, p3)
	return current.child
end

local function updateClassComponent(p, state, p2, p3, p4)
	if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and state.type ~= state.elementType then
		local propTypes = p2.propTypes
		local validateProps = p2.validateProps

		if propTypes or validateProps then
			checkPropTypes(propTypes, validateProps, p3, "prop", getComponentName(p2))
		end
	end

	local v7

	if isContextProvider(p2) then
		pushContextProvider(state)
		v7 = true
	else
		v7 = false
	end

	prepareToReadContext(state, p4, New.markWorkInProgressReceivedUpdate)
	local v8

	if state.stateNode == nil then
		if p ~= nil then
			p.alternate = nil
			state.alternate = nil

			state.flags = bit32.bor(state.flags, placement)
		end

		constructClassInstance(state, p2, p3)
		mountClassInstance(state, p2, p3, p4)
		v8 = true
	elseif p == nil then
		v8 = resumeMountClassInstance(state, p2, p3, p4)
	else
		v8 = updateClassInstance(p, state, p2, p3, p4)
	end

	local v9 = finishClassComponent(p, state, p2, v8, v7, p4)

	if not __DEV__ then
		return v9
	end

	local stateNode = state.stateNode

	if v8 and stateNode.props ~= p3 then
		if not New.didWarnAboutReassigningProps then
			console.error(
				"It looks like %s is reassigning its own `this.props` while rendering. This is not supported and can lead to confusing bugs.",
				getComponentName(state.type) or "a component"
			)
		end

		New.didWarnAboutReassigningProps = true
	end

	return v9
end

function finishClassComponent(p, current, p2, flag: boolean, flag2: boolean, p3)
	markRef(p, current) -- inferred equivalent call
	local v7 = bit32.band(current.flags, didCapture) ~= noFlags

	if flag or v7 then
		local stateNode = current.stateNode

		reactCurrentOwner.current = current
		local v8

		if v7 and (p2.getDerivedStateFromError == nil or type(p2.getDerivedStateFromError) ~= "function") then
			if enableProfilerTimer then
				stopProfilerTimerIfRunning(current)
			end
		elseif __DEV__ then
			setIsRendering(true)

			v8 = stateNode:render()

			if debugRenderPhaseSideEffectsForStrictMode and bit32.band(current.mode, strictMode) ~= 0 then
				disableLogs()

				local success, result = xpcall(stateNode.render, describeError, stateNode)

				reenableLogs()

				if not success then
					error(result)
				end
			end

			setIsRendering(false)
		else
			v8 = stateNode:render()
		end

		current.flags = bit32.bor(current.flags, performedWork)

		if p == nil or not v7 then
			reconcileChildren(p, current, v8, p3)
		else
			forceUnmountCurrentAndReconcile(p, current, v8, p3) -- inferred equivalent call
		end

		current.memoizedState = stateNode.state

		if flag2 then
			invalidateContextProvider(current, p2, true)
		end

		return current.child
	end

	if flag2 then
		invalidateContextProvider(current, p2, false)
	end

	return bailoutOnAlreadyFinishedWork(p, current, p3)
end

local function pushHostRootContext(state) -- 2 equivalent calls inferred from this helper
	local stateNode = state.stateNode

	if stateNode.pendingContext then
		pushTopLevelContextObject(state, stateNode.pendingContext, stateNode.pendingContext ~= stateNode.context)
	elseif stateNode.context then
		pushTopLevelContextObject(state, stateNode.context, false)
	end

	pushHostContainer(state, stateNode.containerInfo)
end

local function updateHostRoot(data, state, p)
	pushHostRootContext(state) -- inferred equivalent call
	local updateQueue = state.updateQueue
	invariant(
		data ~= nil and updateQueue ~= nil,
		"If the root does not have an updateQueue, we should have already bailed out. This error is likely caused by a bug in React. Please file an issue."
	)

	local pendingProps = state.pendingProps
	local memoizedState = state.memoizedState
	local element

	if memoizedState ~= nil then
		element = memoizedState.element
	end

	cloneUpdateQueue(data, state)
	processUpdateQueue(state, pendingProps, nil, p)
	local element2 = state.memoizedState.element

	if element2 == element then
		resetHydrationState()
		return bailoutOnAlreadyFinishedWork(data, state, p)
	end

	local stateNode = state.stateNode

	if stateNode.hydrate and enterHydrationState(state) then
		if supportsHydration then
			local mutableSourceEagerHydrationData = stateNode.mutableSourceEagerHydrationData

			if mutableSourceEagerHydrationData ~= nil then
				for i = 1, #mutableSourceEagerHydrationData, 2 do
					setWorkInProgressVersion(mutableSourceEagerHydrationData[i], mutableSourceEagerHydrationData[i + 1])
				end
			end
		end

		local child = mountChildFibers(state, nil, element2, p)
		state.child = child

		while child do
			child.flags = bit32.bor(bit32.band(child.flags, (bit32.bnot(placement))), hydrating)
			child = child.sibling
		end
	else
		reconcileChildren(data, state, element2, p)
		resetHydrationState()
	end

	return state.child
end

local function updateHostComponent(data, state, p)
	pushHostContext(state)

	if data == nil then
		tryToClaimNextHydratableInstance(state)
	end

	local kind = state.type
	local pendingProps = state.pendingProps
	local memoizedProps

	if data ~= nil then
		memoizedProps = data.memoizedProps
	end

	local children = pendingProps.children

	if shouldSetTextContent(kind, pendingProps) then
		children = nil
	elseif memoizedProps ~= nil and shouldSetTextContent(kind, memoizedProps) then
		state.flags = bit32.bor(state.flags, contentReset)
	end

	state.flags = bit32.bor(state.flags, performedWork)
	markRef(data, state) -- inferred equivalent call
	reconcileChildren(data, state, children, p)
	return state.child
end

local function updateHostText(p, p2): nil
	if p == nil then
		tryToClaimNextHydratableInstance(p2)
	end

	return nil
end

local function mountLazyComponent(data, state, elementType, lanes, p)
	if data ~= nil then
		data.alternate = nil
		state.alternate = nil

		state.flags = bit32.bor(state.flags, placement)
	end

	local pendingProps = state.pendingProps

	local payload = elementType._payload
	local v7 = elementType._init(payload)

	state.type = v7
	state.tag = resolveLazyComponentTag(v7)
	local tag = state.tag
	local defaultProps = resolveDefaultProps(v7, pendingProps)

	if tag == FunctionComponent then
		if __DEV__ then
			validateFunctionComponentInDev(state, v7)
			v7 = resolveFunctionForHotReloading(v7)
			state.type = v7
		end

		return (updateFunctionComponent(nil, state, v7, defaultProps, p))
	elseif tag == ClassComponent then
		if __DEV__ then
			v7 = resolveClassForHotReloading(v7)
			state.type = v7
		end

		return updateClassComponent(nil, state, v7, defaultProps, p)
	elseif tag == ForwardRef then
		if __DEV__ then
			v7 = resolveForwardRefForHotReloading(v7)
			state.type = v7
		end

		return (updateForwardRef(nil, state, v7, defaultProps, p))
	elseif tag == MemoComponent then
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and state.type ~= state.elementType then
			local propTypes = v7.propTypes
			local validateProps = v7.validateProps

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, defaultProps, "prop", getComponentName(v7))
			end
		end

		return (updateMemoComponent(nil, state, v7, resolveDefaultProps(v7.type, defaultProps), lanes, p))
	else
		local v8 = ""

		if __DEV__ then
			if v7 == nil or type(v7) ~= "table" or v7["$$typeof"] ~= REACT_LAZY_TYPE then
				if type(v7) == "table" and v7["$$typeof"] == nil then
					v8 = "\n" .. inspect(v7)
				end
			else
				v8 = " Did you wrap a component in React.lazy() more than once?"
			end
		end

		invariant(
			false,
			"Element type is invalid. Received a promise that resolves to: %s. Lazy element type must resolve to a class or function.%s",
			tostring(v7),
			v8
		)

		return nil
	end
end

function mountIncompleteClassComponent(p, p2, p3, p4, p5)
	if p ~= nil then
		p.alternate = nil
		p2.alternate = nil

		p2.flags = bit32.bor(p2.flags, placement)
	end

	p2.tag = ClassComponent
	local v7

	if isContextProvider(p3) then
		pushContextProvider(p2)
		v7 = true
	else
		v7 = false
	end

	prepareToReadContext(p2, p5, New.markWorkInProgressReceivedUpdate)

	constructClassInstance(p2, p3, p4)
	mountClassInstance(p2, p3, p4, p5)

	return finishClassComponent(nil, p2, p3, true, v7, p5)
end

local function mountIndeterminateComponent(data, current, kind, p)
	if data ~= nil then
		data.alternate = nil
		current.alternate = nil

		current.flags = bit32.bor(current.flags, placement)
	end

	local pendingProps = current.pendingProps
	local v7

	if not disableLegacyContext then
		v7 = getMaskedContext(current, (getUnmaskedContext(current, kind, false)))
	end

	prepareToReadContext(current, p, New.markWorkInProgressReceivedUpdate)
	local v8

	if __DEV__ then
		if type(kind) == "table" and type(kind.render) == "function" then
			local v9 = getComponentName(kind) or "Unknown"

			if not v6.didWarnAboutBadClass[v9] then
				console.error(
					"The <%s /> component appears to have a render method, but doesn't extend React.Component. This is likely to cause errors. Change %s to extend React.Component instead.",
					v9,
					v9
				)

				v6.didWarnAboutBadClass[v9] = true
			end
		end

		if bit32.band(current.mode, strictMode) ~= 0 then
			ReactStrictModeWarningsnew.recordLegacyContextWarning(current)
		end

		setIsRendering(true)
		reactCurrentOwner.current = current

		v8 = renderWithHooks(nil, current, kind, pendingProps, v7, p)
		setIsRendering(false)
	else
		v8 = renderWithHooks(nil, current, kind, pendingProps, v7, p)
	end

	current.flags = bit32.bor(current.flags, performedWork)

	local typeName = type(v8)

	if __DEV__ and v8 ~= nil and typeName == "table" and type(v8.render) == "function" and v8["$$typeof"] == nil then
		local v9 = getComponentName(kind) or "Unknown"

		if not v6.didWarnAboutModulePatternComponent[v9] then
			console.error(
				"The <%s /> component appears to be a function component that returns a class instance. Change %s to a class that extends React.Component instead. ",
				v9,
				v9
			)

			v6.didWarnAboutModulePatternComponent[v9] = true
		end
	end

	if
		disableModulePatternComponents
		or v8 == nil
		or typeName ~= "table"
		or type(v8.render) ~= "function"
		or v8["$$typeof"] ~= nil
	then
		current.tag = FunctionComponent

		if __DEV__ then
			if disableLegacyContext and kind.contextTypes then
				console.error(
					"%s uses the legacy contextTypes API which is no longer supported. Use React.createContext() with React.useContext() instead.",
					getComponentName(kind) or "Unknown"
				)
			end

			if debugRenderPhaseSideEffectsForStrictMode and bit32.band(current.mode, strictMode) ~= 0 then
				disableLogs()
				local success, result = xpcall(renderWithHooks, describeError, nil, current, kind, pendingProps, v7, p)

				reenableLogs()

				if success then
					v8 = result
				else
					error(result)
				end
			end
		end

		current.child = mountChildFibers(current, nil, v8, p)

		if __DEV__ then
			validateFunctionComponentInDev(current, kind)
		end

		return current.child
	else
		if __DEV__ then
			local v9 = getComponentName(kind) or "Unknown"

			if not v6.didWarnAboutModulePatternComponent[v9] then
				console.error(
					"The <%s /> component appears to be a function component that returns a class instance. " .. "Change %s to a class that extends React.Component instead. " .. v9,
					v9
				)

				v6.didWarnAboutModulePatternComponent[v9] = true
			end
		end

		current.tag = ClassComponent

		current.memoizedState = nil
		current.updateQueue = nil
		local v9

		if isContextProvider(kind) then
			pushContextProvider(current)
			v9 = true
		else
			v9 = false
		end

		current.memoizedState = v8.state

		initializeUpdateQueue(current)
		local getDerivedStateFromProps

		if type(kind) ~= "function" then
			getDerivedStateFromProps = kind.getDerivedStateFromProps
		end

		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(current, kind, getDerivedStateFromProps, pendingProps)
		end

		adoptClassInstance(current, v8)
		mountClassInstance(current, kind, pendingProps, p)
		return finishClassComponent(nil, current, kind, true, v9, p)
	end
end

function validateFunctionComponentInDev(data, callback)
	if __DEV__ then
		if data.ref ~= nil then
			local v7 = ""
			local currentFiberOwnerNameInDevOrNull = getCurrentFiberOwnerNameInDevOrNull()

			if currentFiberOwnerNameInDevOrNull then
				v7 ..= "\n\nCheck the render method of `" .. currentFiberOwnerNameInDevOrNull .. "`."
			end

			local v8 = currentFiberOwnerNameInDevOrNull or data._debugID or ""
			local debugSource = data._debugSource

			if debugSource then
				v8 = debugSource.fileName .. ":" .. debugSource.lineNumber
			end

			if not v6.didWarnAboutFunctionRefs[v8] then
				v6.didWarnAboutFunctionRefs[v8] = true
				console.error(
					"Function components cannot be given refs. Attempts to access this ref will fail. Did you mean to use React.forwardRef()?%s",
					v7
				)
			end
		end

		if
			warnAboutDefaultPropsOnFunctionComponents
			and type(callback) ~= "function"
			and callback.defaultProps ~= nil
		then
			local v7 = getComponentName(callback) or "Unknown"

			if not v6.didWarnAboutDefaultPropsOnFunctionComponent[v7] then
				console.error(
					"%s: Support for defaultProps will be removed from function components in a future major release.",
					v7
				)

				v6.didWarnAboutDefaultPropsOnFunctionComponent[v7] = true
			end
		end

		if
			type(callback) ~= "function"
			and callback.getDerivedStateFromProps ~= nil
			and type(callback.getDerivedStateFromProps) == "function"
		then
			local v7 = getComponentName(callback) or "Unknown"

			if not v6.didWarnAboutGetDerivedStateOnFunctionComponent[v7] then
				console.error("%s: Function components do not support getDerivedStateFromProps.", v7)

				v6.didWarnAboutGetDerivedStateOnFunctionComponent[v7] = true
			end
		end

		if type(callback) ~= "function" and callback.contextType ~= nil and type(callback.contextType) == "table" then
			local v7 = getComponentName(callback) or "Unknown"

			if not v6.didWarnAboutContextTypeOnFunctionComponent[v7] then
				console.error("%s: Function components do not support contextType.", v7)

				v6.didWarnAboutContextTypeOnFunctionComponent[v7] = true
			end
		end
	end
end

local memoizedState3 = { dehydrated = nil, retryLane = ReactFiberLane.NoLane }

local function mountSuspenseOffscreenState(baseLanes)
	return { baseLanes = baseLanes }
end

local function updateSuspenseOffscreenState(memoizedState, p) -- 1 equivalent call inferred from this helper
	return {
		baseLanes = ReactFiberLane.mergeLanes(memoizedState.baseLanes, p)
	}
end

local function shouldRemainOnFallback(current, p, _, _) -- 1 equivalent call inferred from this helper
	if p == nil or p.memoizedState ~= nil then
		return hasSuspenseContext(current, forceSuspenseFallback)
	end

	return false
end

local function getRemainingWorkInPrimaryTree(p, p2) -- 1 equivalent call inferred from this helper
	return ReactFiberLane.removeLanes(p.childLanes, p2)
end

local updateSuspensePrimaryChildren
local mountDehydratedSuspenseComponent
local mountSuspensePrimaryChildren
local updateSuspenseFallbackChildren
local updateDehydratedSuspenseComponent

local function updateSuspenseComponent(data, state, baseLanes)
	local pendingProps = state.pendingProps

	if __DEV__ and shouldSuspend(state) then -- inferred equivalent call
		state.flags = bit32.bor(state.flags, didCapture)
	end

	local current = suspenseStackCursor.current

	local flag = false
	local v7 = bit32.band(state.flags, didCapture) ~= noFlags

	if v7 then
		state.flags = bit32.band(state.flags, (bit32.bnot(didCapture)))
		flag = true
	elseif shouldRemainOnFallback(current, data) then -- inferred equivalent call
		state.flags = bit32.band(state.flags, (bit32.bnot(didCapture)))
		flag = true
	elseif
		(data == nil or data.memoizedState ~= nil)
		and pendingProps.fallback ~= nil
		and pendingProps.unstable_avoidThisFallback ~= true
	then
		current = addSubtreeSuspenseContext(current, invisibleParentSuspenseContext)
	end

	pushSuspenseContext(state, (setDefaultShallowSuspenseContext(current)))

	if data == nil then
		if pendingProps.fallback ~= nil then
			tryToClaimNextHydratableInstance(state)

			if enableSuspenseServerRenderer then
				local memoizedState = state.memoizedState

				if memoizedState ~= nil then
					local dehydrated = memoizedState.dehydrated

					if dehydrated ~= nil then
						return mountDehydratedSuspenseComponent(state, dehydrated, baseLanes)
					end
				end
			end
		end

		local children = pendingProps.children
		local fallback = pendingProps.fallback

		if flag then
			local v8 = mountSuspenseFallbackChildren(state, children, fallback, baseLanes)
			state.child.memoizedState = { baseLanes = baseLanes }
			state.memoizedState = memoizedState3
			return v8
		else
			if
				pendingProps.unstable_expectedLoadTime == nil
				or type(pendingProps.unstable_expectedLoadTime) ~= "number"
			then
				return mountSuspensePrimaryChildren(state, children, baseLanes)
			end

			local v8 = mountSuspenseFallbackChildren(state, children, fallback, baseLanes)
			state.child.memoizedState = { baseLanes = baseLanes }
			state.memoizedState = memoizedState3

			state.lanes = ReactFiberLane.SomeRetryLane

			if enableSchedulerTracing then
				markSpawnedWork(ReactFiberLane.SomeRetryLane)
			end

			return v8
		end
	else
		local memoizedState = data.memoizedState

		if memoizedState ~= nil and enableSuspenseServerRenderer then
			local dehydrated = memoizedState.dehydrated

			if dehydrated ~= nil then
				if not v7 then
					return updateDehydratedSuspenseComponent(data, state, dehydrated, memoizedState, baseLanes)
				end

				if state.memoizedState == nil then
					local children = pendingProps.children
					local fallback = pendingProps.fallback

					local v8 = mountSuspenseFallbackAfterRetryWithoutHydrating(
						data,
						state,
						children,
						fallback,
						baseLanes
					)
					state.child.memoizedState = { baseLanes = baseLanes }

					state.memoizedState = memoizedState3
					return v8
				end

				state.child = data.child

				state.flags = bit32.bor(state.flags, didCapture)
				return nil
			end
		end

		if flag then
			local fallback = pendingProps.fallback
			local children = pendingProps.children
			local v8 = updateSuspenseFallbackChildren(data, state, children, fallback, baseLanes)

			local child = state.child
			local memoizedState2 = data.child.memoizedState

			if memoizedState2 == nil then
				child.memoizedState = { baseLanes = baseLanes }
			else
				child.memoizedState = updateSuspenseOffscreenState(memoizedState2, baseLanes) -- inferred equivalent call
			end

			child.childLanes = getRemainingWorkInPrimaryTree(data, baseLanes) -- inferred equivalent call

			state.memoizedState = memoizedState3
			return v8
		else
			local children = pendingProps.children
			local v8 = updateSuspensePrimaryChildren(data, state, children, baseLanes)

			state.memoizedState = nil
			return v8
		end
	end
end

mountSuspensePrimaryChildren = function(return_, children, p)
	local fiberFromOffscreen = createFiberFromOffscreen({ mode = "visible", children = children }, return_.mode, p, nil)
	fiberFromOffscreen.return_ = return_
	return_.child = fiberFromOffscreen
	return fiberFromOffscreen
end

function mountSuspenseFallbackChildren(return_, children, p, p2)
	local mode = return_.mode
	local child = return_.child

	local pendingProps = { mode = "hidden", children = children }

	if bit32.band(mode, blockingMode) == noMode and child ~= nil then
		child.childLanes = ReactFiberLane.NoLanes
		child.pendingProps = pendingProps

		if enableProfilerTimer and bit32.band(return_.mode, profileMode) ~= 0 then
			child.actualDuration = 0
			child.actualStartTime = -1
			child.selfBaseDuration = 0
			child.treeBaseDuration = 0
		end
	else
		child = createFiberFromOffscreen(pendingProps, mode, ReactFiberLane.NoLanes, nil)
	end

	local fiberFromFragment = createFiberFromFragment(p, mode, p2, nil)

	child.return_ = return_
	fiberFromFragment.return_ = return_
	child.sibling = fiberFromFragment
	return_.child = child
	return fiberFromFragment
end

local function createWorkInProgressOffscreenFiber(child, p) -- 2 equivalent calls inferred from this helper
	return createWorkInProgress(child, p)
end

updateSuspensePrimaryChildren = function(p, return_, children, lanes)
	local child = p.child
	local sibling = child.sibling

	local workInProgressOffscreenFiber = createWorkInProgressOffscreenFiber(child, { -- inferred equivalent call
		mode = "visible",
		children = children
	})

	if bit32.band(return_.mode, blockingMode) == noMode then
		workInProgressOffscreenFiber.lanes = lanes
	end

	workInProgressOffscreenFiber.return_ = return_
	workInProgressOffscreenFiber.sibling = nil

	if sibling ~= nil then
		local deletions = return_.deletions

		if deletions == nil then
			return_.deletions = { sibling }

			return_.flags = bit32.bor(return_.flags, deletion)
		else
			table.insert(deletions, sibling)
		end
	end

	return_.child = workInProgressOffscreenFiber
	return workInProgressOffscreenFiber
end

updateSuspenseFallbackChildren = function(p, return_, children, fallback, p2)
	local mode = return_.mode
	local child = p.child
	local sibling = child.sibling

	local pendingProps = { mode = "hidden", children = children }
	local child2

	if bit32.band(mode, blockingMode) == noMode and return_.child ~= child then
		child2 = return_.child

		child2.childLanes = ReactFiberLane.NoLanes
		child2.pendingProps = pendingProps

		if enableProfilerTimer and bit32.band(return_.mode, profileMode) ~= 0 then
			child2.actualDuration = 0
			child2.actualStartTime = -1
			child2.selfBaseDuration = child.selfBaseDuration
			child2.treeBaseDuration = child.treeBaseDuration
		end

		return_.deletions = nil
	else
		child2 = createWorkInProgressOffscreenFiber(child, pendingProps) -- inferred equivalent call
		child2.subtreeFlags = bit32.band(child.subtreeFlags, staticMask)
	end

	local sibling2

	if sibling == nil then
		sibling2 = createFiberFromFragment(fallback, mode, p2, nil)

		sibling2.flags = bit32.bor(sibling2.flags, placement)
	else
		sibling2 = createWorkInProgress(sibling, fallback)
	end

	sibling2.return_ = return_
	child2.return_ = return_
	child2.sibling = sibling2
	return_.child = child2

	return sibling2
end

local function retrySuspenseComponentWithoutHydrating(p, state, p2) -- 2 equivalent calls inferred from this helper
	reconcileChildFibers(state, p.child, nil, p2)

	local children = state.pendingProps.children

	local v7 = mountSuspensePrimaryChildren(state, children, p2)

	v7.flags = bit32.bor(v7.flags, placement)
	state.memoizedState = nil

	return v7
end

function mountSuspenseFallbackAfterRetryWithoutHydrating(p, return_, p2, p3, p4)
	local mode = return_.mode

	local fiberFromOffscreen = createFiberFromOffscreen(p2, mode, ReactFiberLane.NoLanes, nil)

	local fiberFromFragment = createFiberFromFragment(p3, mode, p4, nil)

	fiberFromFragment.flags = bit32.bor(fiberFromFragment.flags, placement)

	fiberFromOffscreen.return_ = return_
	fiberFromFragment.return_ = return_
	fiberFromOffscreen.sibling = fiberFromFragment
	return_.child = fiberFromOffscreen

	if bit32.band(return_.mode, blockingMode) ~= noMode then
		reconcileChildFibers(return_, p.child, nil, p4)
	end

	return fiberFromFragment
end

mountDehydratedSuspenseComponent = function(state, dehydrated, _): nil
	if bit32.band(state.mode, blockingMode) == noMode then
		if __DEV__ then
			console.error("Cannot hydrate Suspense in legacy mode. Switch fromReactDOM.hydrate(element, container) to ReactDOM.createBlockingRoot(container, { hydrate: true }).render(element) or remove the Suspense componentsthe server rendered components.")
		end

		state.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.SyncLane)
	elseif isSuspenseInstanceFallback(dehydrated) then
		if enableSchedulerTracing then
			markSpawnedWork(ReactFiberLane.DefaultHydrationLane)
		end

		state.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.DefaultHydrationLane)
	else
		state.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.OffscreenLane)

		if enableSchedulerTracing then
			markSpawnedWork(ReactFiberLane.OffscreenLane)
		end
	end

	return nil
end

updateDehydratedSuspenseComponent = function(p, state, dehydrated, memoizedState, p2)
	warnIfHydrating()

	if
		bit32.band(getExecutionContext(), retryAfterError) == noContext
		and bit32.band(state.mode, blockingMode) ~= noMode
		and not isSuspenseInstanceFallback(dehydrated)
	then
		local includesSomeLane = ReactFiberLane.includesSomeLane(p2, p.childLanes)

		if v5 or includesSomeLane then
			local workInProgressRoot = getWorkInProgressRoot()

			if workInProgressRoot ~= nil then
				local bumpedLaneForHydration = ReactFiberLane.getBumpedLaneForHydration(workInProgressRoot, p2)

				if
					bumpedLaneForHydration ~= ReactFiberLane.NoLane
					and bumpedLaneForHydration ~= memoizedState.retryLane
				then
					memoizedState.retryLane = bumpedLaneForHydration

					scheduleUpdateOnFiber(p, bumpedLaneForHydration, ReactFiberLane.NoTimestamp)
				end
			end

			renderDidSuspendDelayIfPossible()
			return retrySuspenseComponentWithoutHydrating(p, state, p2) -- inferred equivalent call
		elseif isSuspenseInstancePending(dehydrated) then
			state.flags = bit32.bor(state.flags, didCapture)

			state.child = p.child

			local function fn()
				return retryDehydratedSuspenseBoundary(p)
			end

			if enableSchedulerTracing then
				if unstable_wrap == nil then
					local Scheduler = require(parent.Scheduler)
					unstable_wrap = Scheduler.tracing.unstable_wrap
				end

				fn = unstable_wrap(fn)
			end

			registerSuspenseInstanceRetry(dehydrated, fn)
			return nil
		else
			reenterHydrationStateFromDehydratedSuspenseInstance(state, dehydrated)

			local children = state.pendingProps.children

			local v7 = mountSuspensePrimaryChildren(state, children, p2)

			v7.flags = bit32.bor(v7.flags, hydrating)
			return v7
		end
	end

	return retrySuspenseComponentWithoutHydrating(p, state, p2) -- inferred equivalent call
end

function updatePortalComponent(p, state, p2)
	pushHostContainer(state, state.stateNode.containerInfo)
	local pendingProps = state.pendingProps

	if p == nil then
		state.child = reconcileChildFibers(state, nil, pendingProps, p2)
	else
		reconcileChildren(p, state, pendingProps, p2)
	end

	return state.child
end

local v7 = false

local function updateContextProvider(data, data2, p)
	local context = data2.type._context

	local pendingProps = data2.pendingProps
	local memoizedProps = data2.memoizedProps

	local value = pendingProps.value

	if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		if array.indexOf(object.keys(pendingProps), "value") < 1 and not v7 then
			v7 = true
			console.error("The `value` prop is required for the `<Context.Provider>`. Did you misspell it or forget to pass it?")
		end

		local propTypes = data2.type.propTypes
		local validateProps = data2.type.validateProps

		if propTypes or validateProps then
			checkPropTypes(propTypes, validateProps, pendingProps, "prop", "Context.Provider")
		end
	end

	pushProvider(data2, value)

	if memoizedProps ~= nil then
		local v8 = calculateChangedBits(context, value, memoizedProps.value)

		if v8 == 0 then
			if memoizedProps.children == pendingProps.children and not hasContextChanged() then
				return bailoutOnAlreadyFinishedWork(data, data2, p)
			end
		else
			propagateContextChange(data2, context, v8, p)
		end
	end

	reconcileChildren(data, data2, pendingProps.children, p)
	return data2.child
end

local v8 = { usingContextAsConsumer = false, usingLegacyConsumer = false }

function updateContextConsumer(p, current, p2)
	local v9 = current.type

	if __DEV__ then
		if v9._context == nil then
			if v9 ~= v9.Consumer and not v8.usingContextAsConsumer then
				v8.usingContextAsConsumer = true
				console.error("Rendering <Context> directly is not supported and will be removed in a future major release. Did you mean to render <Context.Consumer> instead?")
			end
		else
			v9 = v9._context
		end
	end

	local pendingProps = current.pendingProps
	local v10

	if pendingProps.render then
		if __DEV__ and __COMPAT_WARNINGS__ and not v8.usingLegacyConsumer then
			v8.usingLegacyConsumer = true
			console.warn([[
Your Context.Consumer component is using legacy Roact syntax, which won't be supported in future versions of Roact. 
Please provide no props and supply the 'render' function as a child (the 3rd argument of createElement). For example: 
       createElement(ContextConsumer, {render = function(...) end})
becomes:
       createElement(ContextConsumer, nil, function(...) end)
For more info, reference the React documentation here: 
https://reactjs.org/docs/context.html#contextconsumer]])
		end

		v10 = pendingProps.render
	else
		v10 = pendingProps.children
	end

	if __DEV__ and type(v10) ~= "function" then
		console.error("A context consumer was rendered with multiple children, or a child that isn't a function. A context consumer expects a single child that is a function. If you did pass a function, make sure there is no trailing or leading whitespace around it.")
	end

	prepareToReadContext(current, p2, New.markWorkInProgressReceivedUpdate)

	local v11 = readContext(v9, pendingProps.unstable_observedBits)
	local v12

	if __DEV__ then
		reactCurrentOwner.current = current
		setIsRendering(true)
		v12 = v10(v11)
		setIsRendering(false)
	else
		v12 = v10(v11)
	end

	current.flags = bit32.bor(current.flags, performedWork)
	reconcileChildren(p, current, v12, p2)
	return current.child
end

function New.markWorkInProgressReceivedUpdate()
	v5 = true
end

bailoutOnAlreadyFinishedWork = function(p, state, p2)
	if p then
		state.dependencies = p.dependencies
	end

	if enableProfilerTimer then
		stopProfilerTimerIfRunning(state)
	end

	markSkippedUpdateLanes(state.lanes)

	if not ReactFiberLane.includesSomeLane(p2, state.childLanes) then
		return nil
	end

	cloneChildFibers(p, state)
	return state.child
end

function remountFiber(p, state, p2)
	if not __DEV__ then
		error("Did not expect this call in production. This is a bug in React. Please file an issue.")

		return
	end

	local return_ = state.return_

	if return_ == nil then
		error("Cannot swap the root fiber.")
	end

	assert(return_ ~= nil, "returnFiber was nil in remountFiber")

	p.alternate = nil
	state.alternate = nil

	p2.index = state.index
	p2.sibling = state.sibling
	p2.return_ = state.return_
	p2.ref = state.ref

	if state == return_.child then
		return_.child = p2
	else
		local v9 = return_.child

		if v9 == nil then
			error("Expected parent to have a child.")
		end

		assert(v9 ~= nil, "prevSibling was nil in remountFiber")

		while v9.sibling ~= state do
			v9 = v9.sibling

			if v9 == nil then
				error("Expected to find the previous sibling.")
			end
		end

		v9.sibling = p2
	end

	local deletions = return_.deletions

	if deletions == nil then
		return_.deletions = { p }

		return_.flags = bit32.bor(return_.flags, deletion)
	else
		table.insert(deletions, p)
	end

	p2.flags = bit32.bor(p2.flags, placement)

	return p2
end

function New.beginWork(data, state, p)
	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail2()
		if not (state.tag ~= OffscreenComponent and state.tag ~= LegacyHiddenComponent) then
			return updateOffscreenComponent(data, state, p)
		end

		invariant(
			false,
			"Unknown unit of work tag (%s). This error is likely caused by a bug in React. Please file an issue.",
			(tostring(state.tag))
		)

		return nil
	end

	local lanes = state.lanes

	if __DEV__ and state._debugNeedsRemount and data ~= nil then
		return remountFiber(
			data,
			state,
			createFiberFromTypeAndProps(
				state.type,
				state.key,
				state.pendingProps,
				state._debugOwner or nil,
				state.mode,
				state.lanes
			)
		)
	end

	local kind, pendingProps, kind2, pendingProps2, kind3, pendingProps3, kind4, v9, _, _, kind5, pendingProps4, v10

	-- [DEDUP] synthesized from 2 duplicated terminal regions
	local function deduplicatedTail()
		local propTypes, validateProps

		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and state.type ~= state.elementType then
			if type(kind4) == "table" then
				propTypes = kind4.propTypes
				validateProps = kind4.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, v9, "prop", getComponentName(kind4))
			end
		end

		return updateMemoComponent(data, state, kind4, resolveDefaultProps(kind4.type, v9), lanes, p)
	end

	if data == nil then
		v5 = false
	else
		if data.memoizedProps == state.pendingProps and not hasContextChanged() then
			local v11

			if __DEV__ then
				v11 = state.type ~= data.type
			else
				v11 = false
			end

			if not v11 then
				if ReactFiberLane.includesSomeLane(p, lanes) then
					if bit32.band(data.flags, forceUpdateForLegacySuspense) == noFlags then
						v5 = false
					else
						v5 = true
					end

					state.lanes = ReactFiberLane.NoLanes

					if state.tag == ReactWorkTags.IndeterminateComponent then
						return mountIndeterminateComponent(data, state, state.type, p)
					end

					if state.tag == LazyComponent then
						return mountLazyComponent(data, state, state.elementType, lanes, p)
					end

					if state.tag == FunctionComponent then
						kind = state.type
						pendingProps = state.pendingProps

						if state.elementType ~= kind then
							pendingProps = resolveDefaultProps(kind, pendingProps)
						end

						return updateFunctionComponent(data, state, kind, pendingProps, p)
					elseif state.tag == ClassComponent then
						kind2 = state.type
						pendingProps2 = state.pendingProps
						return updateClassComponent(
							data,
							state,
							kind2,
							state.elementType == kind2 and pendingProps2 or resolveDefaultProps(kind2, pendingProps2),
							p
						)
					else
						if state.tag == HostRoot then
							return updateHostRoot(data, state, p)
						end

						if state.tag == HostComponent then
							return updateHostComponent(data, state, p)
						end

						if state.tag == HostText then
							if data == nil then
								tryToClaimNextHydratableInstance(state)
							end

							return nil
						end

						if state.tag == SuspenseComponent then
							return updateSuspenseComponent(data, state, p)
						end

						if state.tag == HostPortal then
							return updatePortalComponent(data, state, p)
						end

						if state.tag == ForwardRef then
							kind3 = state.type
							pendingProps3 = state.pendingProps

							if state.elementType ~= kind3 then
								pendingProps3 = resolveDefaultProps(kind3, pendingProps3)
							end

							return updateForwardRef(data, state, kind3, pendingProps3, p)
						end

						if state.tag == Fragment then
							return updateFragment(data, state, p)
						end

						if state.tag == Mode then
							return updateMode(data, state, p)
						end

						if state.tag == Profiler then
							return updateProfiler(data, state, p)
						end

						if state.tag == ContextProvider then
							return updateContextProvider(data, state, p)
						end

						if state.tag == ContextConsumer then
							return updateContextConsumer(data, state, p)
						end

						if state.tag == MemoComponent then
							kind4 = state.type
							v9 = resolveDefaultProps(kind4, state.pendingProps)
							return deduplicatedTail()
						end

						if state.tag == SimpleMemoComponent then
							return updateSimpleMemoComponent(data, state, state.type, state.pendingProps, lanes, p)
						end

						if state.tag == IncompleteClassComponent then
							kind5 = state.type
							pendingProps4 = state.pendingProps
							v10 = state.elementType == kind5 and pendingProps4
								or resolveDefaultProps(kind5, pendingProps4)
							return mountIncompleteClassComponent(data, state, kind5, v10, p)
						end

						return deduplicatedTail2()
					end
				else
					v5 = false

					if state.tag == HostRoot then
						pushHostRootContext(state) -- inferred equivalent call
						resetHydrationState()

						return bailoutOnAlreadyFinishedWork(data, state, p)
					end

					if state.tag == HostComponent then
						pushHostContext(state)

						return bailoutOnAlreadyFinishedWork(data, state, p)
					end

					if state.tag == ClassComponent then
						if isContextProvider(state.type) then
							pushContextProvider(state)
						end

						return bailoutOnAlreadyFinishedWork(data, state, p)
					end

					if state.tag == HostPortal then
						pushHostContainer(state, state.stateNode.containerInfo)

						return bailoutOnAlreadyFinishedWork(data, state, p)
					end

					if state.tag == ContextProvider then
						pushProvider(state, state.memoizedProps.value)

						return bailoutOnAlreadyFinishedWork(data, state, p)
					end

					if state.tag == Profiler then
						if enableProfilerTimer then
							local stateNode = state.stateNode
							stateNode.effectDuration = 0
							stateNode.passiveEffectDuration = 0
						end

						return bailoutOnAlreadyFinishedWork(data, state, p)
					elseif state.tag == SuspenseComponent then
						local memoizedState = state.memoizedState

						if memoizedState == nil then
							pushSuspenseContext(state, setDefaultShallowSuspenseContext(suspenseStackCursor.current))

							return bailoutOnAlreadyFinishedWork(data, state, p)
						end

						if enableSuspenseServerRenderer and memoizedState.dehydrated ~= nil then
							pushSuspenseContext(state, setDefaultShallowSuspenseContext(suspenseStackCursor.current))

							state.flags = bit32.bor(state.flags, didCapture)

							return nil
						else
							local childLanes = state.child.childLanes

							if ReactFiberLane.includesSomeLane(p, childLanes) then
								return updateSuspenseComponent(data, state, p)
							end

							pushSuspenseContext(state, setDefaultShallowSuspenseContext(suspenseStackCursor.current))

							local v12 = bailoutOnAlreadyFinishedWork(data, state, p)

							if v12 == nil then
								return nil
							end

							return v12.sibling
						end
					elseif state.tag == SuspenseListComponent then
						unimplemented("beginWork: SuspenseListComponent") -- inferred equivalent call
						return bailoutOnAlreadyFinishedWork(data, state, p)
					else
						if state.tag ~= OffscreenComponent and state.tag ~= LegacyHiddenComponent then
							return bailoutOnAlreadyFinishedWork(data, state, p)
						end

						state.lanes = ReactFiberLane.NoLanes
						return updateOffscreenComponent(data, state, p)
					end
				end
			end
		end

		v5 = true
	end

	state.lanes = ReactFiberLane.NoLanes

	if state.tag == ReactWorkTags.IndeterminateComponent then
		return mountIndeterminateComponent(data, state, state.type, p)
	end

	if state.tag == LazyComponent then
		return mountLazyComponent(data, state, state.elementType, lanes, p)
	end

	if state.tag == FunctionComponent then
		kind = state.type
		pendingProps = state.pendingProps

		if state.elementType ~= kind then
			pendingProps = resolveDefaultProps(kind, pendingProps)
		end

		return updateFunctionComponent(data, state, kind, pendingProps, p)
	elseif state.tag == ClassComponent then
		kind2 = state.type
		pendingProps2 = state.pendingProps
		return updateClassComponent(
			data,
			state,
			kind2,
			state.elementType == kind2 and pendingProps2 or resolveDefaultProps(kind2, pendingProps2),
			p
		)
	else
		if state.tag == HostRoot then
			return updateHostRoot(data, state, p)
		end

		if state.tag == HostComponent then
			return updateHostComponent(data, state, p)
		end

		if state.tag == HostText then
			if data == nil then
				tryToClaimNextHydratableInstance(state)
			end

			return nil
		end

		if state.tag == SuspenseComponent then
			return updateSuspenseComponent(data, state, p)
		end

		if state.tag == HostPortal then
			return updatePortalComponent(data, state, p)
		end

		if state.tag == ForwardRef then
			kind3 = state.type
			pendingProps3 = state.pendingProps

			if state.elementType ~= kind3 then
				pendingProps3 = resolveDefaultProps(kind3, pendingProps3)
			end

			return updateForwardRef(data, state, kind3, pendingProps3, p)
		end

		if state.tag == Fragment then
			return updateFragment(data, state, p)
		end

		if state.tag == Mode then
			return updateMode(data, state, p)
		end

		if state.tag == Profiler then
			return updateProfiler(data, state, p)
		end

		if state.tag == ContextProvider then
			return updateContextProvider(data, state, p)
		end

		if state.tag == ContextConsumer then
			return updateContextConsumer(data, state, p)
		end

		if state.tag == MemoComponent then
			kind4 = state.type
			v9 = resolveDefaultProps(kind4, state.pendingProps)
			return deduplicatedTail()
		end

		if state.tag == SimpleMemoComponent then
			return updateSimpleMemoComponent(data, state, state.type, state.pendingProps, lanes, p)
		end

		if state.tag == IncompleteClassComponent then
			kind5 = state.type
			pendingProps4 = state.pendingProps
			v10 = state.elementType == kind5 and pendingProps4 or resolveDefaultProps(kind5, pendingProps4)
			return mountIncompleteClassComponent(data, state, kind5, v10, p)
		end

		return deduplicatedTail2()
	end
end

return New
