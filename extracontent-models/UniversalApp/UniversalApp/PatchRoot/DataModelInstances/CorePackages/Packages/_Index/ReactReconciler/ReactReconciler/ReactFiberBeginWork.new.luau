do
	local function unimplemented(s1: string) -- line: 14
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring(s1))
		error("FIXME (roblox): " .. s1 .. " is unimplemented", 2)
	end
end

local ParentParent = script.Parent.Parent
local console = require(ParentParent.Shared).console
local Array, Object, inspect

do
	local LuauPolyfill = require(ParentParent.LuauPolyfill)

	Array = LuauPolyfill.Array
	Object = LuauPolyfill.Object
	inspect = LuauPolyfill.util.inspect
end

local __DEV__ = require(ParentParent.ReactGlobals).__DEV__
local __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = require(ParentParent.ReactGlobals).__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__
local __COMPAT_WARNINGS__ = require(ParentParent.ReactGlobals).__COMPAT_WARNINGS__

require(ParentParent.Shared)
require(ParentParent.React)
require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local checkPropTypes, ReactWorkTags, FunctionComponent, ClassComponent, HostRoot, HostComponent, HostText, HostPortal, ForwardRef, Fragment, ReactWorkTagsMode, ContextProvider, ContextConsumer, Profiler, SuspenseComponent, SuspenseListComponent, MemoComponent, SimpleMemoComponent, LazyComponent, IncompleteClassComponent, OffscreenComponent, LegacyHiddenComponent, NoFlags, StaticMask, PerformedWork, Placement, Hydrating, DidCapture, Deletion, ForceUpdateForLegacySuspense, debugRenderPhaseSideEffectsForStrictMode, disableLegacyContext, disableModulePatternComponents, enableProfilerTimer, enableSchedulerTracing, enableSuspenseServerRenderer, warnAboutDefaultPropsOnFunctionComponents, invariant, describeError, getComponentName, REACT_LAZY_TYPE, lib, getCurrentFiberOwnerNameInDevOrNull, setIsRendering, resolveFunctionForHotReloading, resolveForwardRefForHotReloading, resolveClassForHotReloading, mountChildFibers, reconcileChildFibers, cloneChildFibers, initializeUpdateQueue, NoMode, ProfileMode, StrictMode, BlockingMode, isSuspenseInstancePending, isSuspenseInstanceFallback, registerSuspenseInstanceRetry, pushHostContext, pushHostContainer, suspenseStackCursor, hasSuspenseContext, ForceSuspenseFallback, addSubtreeSuspenseContext, InvisibleParentSuspenseContext, pushSuspenseContext, setDefaultShallowSuspenseContext, propagateContextChange, readContext, calculateChangedBits, prepareToReadContext, pushProvider, t1, renderWithHooks, stopProfilerTimerIfRunning, getMaskedContext, getUnmaskedContext, hasContextChanged, pushContextProvider, isContextProvider, pushTopLevelContextObject, resetHydrationState, reenterHydrationStateFromDehydratedSuspenseInstance, tryToClaimNextHydratableInstance, warnIfHydrating, adoptClassInstance, applyDerivedStateFromProps, constructClassInstance, mountClassInstance, resolveDefaultProps, resolveLazyComponentTag, createFiberFromFragment, createFiberFromOffscreen, createFiberFromTypeAndProps, createWorkInProgress, markSpawnedWork, retryDehydratedSuspenseBoundary, scheduleUpdateOnFiber, renderDidSuspendDelayIfPossible, getWorkInProgressRoot, getExecutionContext, RetryAfterError, NoContext, u151, markSkippedUpdateLanes, disableLogs, reenableLogs, ReactCurrentOwner, t2, bailoutOnAlreadyFinishedWork, updateFunctionComponent, u161, t3, updateSimpleMemoComponent, updateForwardRef, updateMemoComponent, updateOffscreenComponent, updateClassComponent, updateHostRoot, updateHostComponent

do
	local ContentReset, Ref, shallowEqual, processUpdateQueue, cloneUpdateQueue, ConcurrentMode, shouldSetTextContent, supportsHydration, bailoutHooks, invalidateContextProvider, enterHydrationState, resumeMountClassInstance, updateClassInstance, isSimpleFunctionComponent, pushRenderLanes, setWorkInProgressVersion

	do
		local ReactSharedInternals

		do
			local lib2 = require(script.Parent["ReactFiberSuspenseContext.new"])

			require(script.Parent.ReactFiberOffscreenComponent)
			checkPropTypes = require(ParentParent.Shared).checkPropTypes
			ReactWorkTags = require(script.Parent.ReactWorkTags)
			FunctionComponent = ReactWorkTags.FunctionComponent
			ClassComponent = ReactWorkTags.ClassComponent
			HostRoot = ReactWorkTags.HostRoot
			HostComponent = ReactWorkTags.HostComponent
			HostText = ReactWorkTags.HostText
			HostPortal = ReactWorkTags.HostPortal
			ForwardRef = ReactWorkTags.ForwardRef
			Fragment = ReactWorkTags.Fragment
			ReactWorkTagsMode = ReactWorkTags.Mode
			ContextProvider = ReactWorkTags.ContextProvider
			ContextConsumer = ReactWorkTags.ContextConsumer
			Profiler = ReactWorkTags.Profiler
			SuspenseComponent = ReactWorkTags.SuspenseComponent
			SuspenseListComponent = ReactWorkTags.SuspenseListComponent
			MemoComponent = ReactWorkTags.MemoComponent
			SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
			LazyComponent = ReactWorkTags.LazyComponent
			IncompleteClassComponent = ReactWorkTags.IncompleteClassComponent
			OffscreenComponent = ReactWorkTags.OffscreenComponent
			LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent

			do
				local ReactFiberFlags = require(script.Parent.ReactFiberFlags)

				NoFlags = ReactFiberFlags.NoFlags
				StaticMask = ReactFiberFlags.StaticMask
				PerformedWork = ReactFiberFlags.PerformedWork
				Placement = ReactFiberFlags.Placement
				Hydrating = ReactFiberFlags.Hydrating
				ContentReset = ReactFiberFlags.ContentReset
				DidCapture = ReactFiberFlags.DidCapture
				Ref = ReactFiberFlags.Ref
				Deletion = ReactFiberFlags.Deletion
				ForceUpdateForLegacySuspense = ReactFiberFlags.ForceUpdateForLegacySuspense
			end

			ReactSharedInternals = require(ParentParent.Shared).ReactSharedInternals

			do
				local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags

				debugRenderPhaseSideEffectsForStrictMode = ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
				disableLegacyContext = ReactFeatureFlags.disableLegacyContext
				disableModulePatternComponents = ReactFeatureFlags.disableModulePatternComponents
				enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
				enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
				enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
				warnAboutDefaultPropsOnFunctionComponents = ReactFeatureFlags.warnAboutDefaultPropsOnFunctionComponents
			end

			invariant = require(ParentParent.Shared).invariant
			describeError = require(ParentParent.Shared).describeError
			shallowEqual = require(ParentParent.Shared).shallowEqual
			getComponentName = require(ParentParent.Shared).getComponentName

			do
				local ReactSymbols = require(ParentParent.Shared).ReactSymbols

				REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE

				local _ = ReactSymbols.getIteratorFn
			end

			lib = require(script.Parent["ReactStrictModeWarnings.new"])

			do
				local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)

				getCurrentFiberOwnerNameInDevOrNull = ReactCurrentFiber.getCurrentFiberOwnerNameInDevOrNull
				setIsRendering = ReactCurrentFiber.setIsRendering
			end

			do
				local lib3 = require(script.Parent["ReactFiberHotReloading.new"])

				resolveFunctionForHotReloading = lib3.resolveFunctionForHotReloading
				resolveForwardRefForHotReloading = lib3.resolveForwardRefForHotReloading
				resolveClassForHotReloading = lib3.resolveClassForHotReloading

				local lib4 = require(script.Parent["ReactChildFiber.new"])

				mountChildFibers = lib4.mountChildFibers
				reconcileChildFibers = lib4.reconcileChildFibers
				cloneChildFibers = lib4.cloneChildFibers
			end

			do
				local lib5 = require(script.Parent["ReactUpdateQueue.new"])

				processUpdateQueue = lib5.processUpdateQueue
				cloneUpdateQueue = lib5.cloneUpdateQueue
				initializeUpdateQueue = lib5.initializeUpdateQueue

				local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)

				ConcurrentMode = ReactTypeOfMode.ConcurrentMode
				NoMode = ReactTypeOfMode.NoMode
				ProfileMode = ReactTypeOfMode.ProfileMode
				StrictMode = ReactTypeOfMode.StrictMode
				BlockingMode = ReactTypeOfMode.BlockingMode
			end

			local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

			shouldSetTextContent = ReactFiberHostConfig.shouldSetTextContent
			isSuspenseInstancePending = ReactFiberHostConfig.isSuspenseInstancePending
			isSuspenseInstanceFallback = ReactFiberHostConfig.isSuspenseInstanceFallback
			registerSuspenseInstanceRetry = ReactFiberHostConfig.registerSuspenseInstanceRetry
			supportsHydration = ReactFiberHostConfig.supportsHydration

			local lib6 = require(script.Parent["ReactFiberHostContext.new"])

			pushHostContext = lib6.pushHostContext
			pushHostContainer = lib6.pushHostContainer
			suspenseStackCursor = lib2.suspenseStackCursor
			hasSuspenseContext = lib2.hasSuspenseContext
			ForceSuspenseFallback = lib2.ForceSuspenseFallback
			addSubtreeSuspenseContext = lib2.addSubtreeSuspenseContext
			InvisibleParentSuspenseContext = lib2.InvisibleParentSuspenseContext
			pushSuspenseContext = lib2.pushSuspenseContext
			setDefaultShallowSuspenseContext = lib2.setDefaultShallowSuspenseContext
		end

		do
			local lib7 = require(script.Parent["ReactFiberNewContext.new"])

			propagateContextChange = lib7.propagateContextChange
			readContext = lib7.readContext
			calculateChangedBits = lib7.calculateChangedBits
			prepareToReadContext = lib7.prepareToReadContext
			pushProvider = lib7.pushProvider
			t1 = {
				renderWithHooksRef = nil,
				bailoutHooksRef = nil,
				shouldSuspendRef = nil
			}

			local function shouldSuspend(p1) -- line: 189
				-- upvalues: t1 (copy)
				if not t1.shouldSuspendRef then
					t1.shouldSuspendRef = require(script.Parent.ReactFiberReconciler).shouldSuspend
				end

				return t1.shouldSuspendRef(p1)
			end
			local function initReactFiberHooks() -- line: 198
				-- upvalues: t1 (copy)
				local lib8 = require(script.Parent["ReactFiberHooks.new"])

				t1.renderWithHooksRef = lib8.renderWithHooks
				t1.bailoutHooksRef = lib8.bailoutHooks
			end
		end

		function renderWithHooks(...) -- line: 205
			-- upvalues: t1 (copy)
			if not t1.renderWithHooksRef then
				local lib9 = require(script.Parent["ReactFiberHooks.new"])

				t1.renderWithHooksRef = lib9.renderWithHooks
				t1.bailoutHooksRef = lib9.bailoutHooks
			end

			return t1.renderWithHooksRef(...)
		end
		function bailoutHooks(...) -- line: 213
			-- upvalues: t1 (copy)
			if not t1.bailoutHooksRef then
				local lib10 = require(script.Parent["ReactFiberHooks.new"])

				t1.renderWithHooksRef = lib10.renderWithHooks
				t1.bailoutHooksRef = lib10.bailoutHooks
			end

			return t1.bailoutHooksRef(...)
		end

		stopProfilerTimerIfRunning = require(script.Parent["ReactProfilerTimer.new"]).stopProfilerTimerIfRunning

		do
			local lib11 = require(script.Parent["ReactFiberContext.new"])

			getMaskedContext = lib11.getMaskedContext
			getUnmaskedContext = lib11.getUnmaskedContext
			hasContextChanged = lib11.hasContextChanged
			pushContextProvider = lib11.pushContextProvider
			isContextProvider = lib11.isContextProvider
			pushTopLevelContextObject = lib11.pushTopLevelContextObject
			invalidateContextProvider = lib11.invalidateContextProvider

			local lib12 = require(script.Parent["ReactFiberHydrationContext.new"])

			resetHydrationState = lib12.resetHydrationState
			enterHydrationState = lib12.enterHydrationState
			reenterHydrationStateFromDehydratedSuspenseInstance = lib12.reenterHydrationStateFromDehydratedSuspenseInstance
			tryToClaimNextHydratableInstance = lib12.tryToClaimNextHydratableInstance
			warnIfHydrating = lib12.warnIfHydrating

			local lib13 = require(script.Parent["ReactFiberClassComponent.new"])

			adoptClassInstance = lib13.adoptClassInstance
			applyDerivedStateFromProps = lib13.applyDerivedStateFromProps
			constructClassInstance = lib13.constructClassInstance
			mountClassInstance = lib13.mountClassInstance
			resumeMountClassInstance = lib13.resumeMountClassInstance
			updateClassInstance = lib13.updateClassInstance
		end

		resolveDefaultProps = require(script.Parent["ReactFiberLazyComponent.new"]).resolveDefaultProps

		local lib14 = require(script.Parent["ReactFiber.new"])

		resolveLazyComponentTag = lib14.resolveLazyComponentTag
		createFiberFromFragment = lib14.createFiberFromFragment
		createFiberFromOffscreen = lib14.createFiberFromOffscreen
		createFiberFromTypeAndProps = lib14.createFiberFromTypeAndProps
		isSimpleFunctionComponent = lib14.isSimpleFunctionComponent
		createWorkInProgress = lib14.createWorkInProgress

		local lib15 = require(script.Parent["ReactFiberWorkLoop.new"])

		pushRenderLanes = lib15.pushRenderLanes
		markSpawnedWork = lib15.markSpawnedWork
		retryDehydratedSuspenseBoundary = lib15.retryDehydratedSuspenseBoundary
		scheduleUpdateOnFiber = lib15.scheduleUpdateOnFiber
		renderDidSuspendDelayIfPossible = lib15.renderDidSuspendDelayIfPossible
		getWorkInProgressRoot = lib15.getWorkInProgressRoot
		getExecutionContext = lib15.getExecutionContext
		RetryAfterError = lib15.RetryAfterError
		NoContext = lib15.NoContext
		u151 = nil
		setWorkInProgressVersion = require(script.Parent["ReactMutableSource.new"]).setWorkInProgressVersion
		markSkippedUpdateLanes = require(script.Parent.ReactFiberWorkInProgress).markSkippedUpdateLanes

		local ConsolePatchingDev = require(ParentParent.Shared).ConsolePatchingDev

		disableLogs = ConsolePatchingDev.disableLogs
		reenableLogs = ConsolePatchingDev.reenableLogs
		ReactCurrentOwner = ReactSharedInternals.ReactCurrentOwner
	end

	t2 = {}
	bailoutOnAlreadyFinishedWork = nil
	updateFunctionComponent = nil
	u161 = false
	t3 = {
		didWarnAboutBadClass = {},
		didWarnAboutModulePatternComponent = {},
		didWarnAboutContextTypeOnFunctionComponent = {},
		didWarnAboutGetDerivedStateOnFunctionComponent = {},
		didWarnAboutFunctionRefs = {},
		didWarnAboutDefaultPropsOnFunctionComponent = {}
	}
	updateSimpleMemoComponent = nil

	if __DEV__ then
		t3.didWarnAboutBadClass = {}
		t3.didWarnAboutModulePatternComponent = {}
		t3.didWarnAboutContextTypeOnFunctionComponent = {}
		t3.didWarnAboutGetDerivedStateOnFunctionComponent = {}
		t3.didWarnAboutFunctionRefs = {}
		t2.didWarnAboutReassigningProps = false
		t3.didWarnAboutDefaultPropsOnFunctionComponent = {}
	end

	local function reconcileChildren(p2, p3, p4, p5) -- line: 314
		-- upvalues: mountChildFibers (copy), reconcileChildFibers (copy)
		if p2 == nil then
			p3.child = mountChildFibers(p3, nil, p4, p5)

			return
		end

		p3.child = reconcileChildFibers(p3, p2.child, p4, p5)
	end
	local function forceUnmountCurrentAndReconcile(p6, p7, p8, p9) -- line: 343
		-- upvalues: reconcileChildFibers (copy)
		p7.child = reconcileChildFibers(p7, p6.child, nil, p9)
		p7.child = reconcileChildFibers(p7, nil, p8, p9)
	end

	function updateForwardRef(p10, p11, p12, p13, p14) -- line: 367
		-- upvalues: __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), prepareToReadContext (copy), t2 (copy), ReactCurrentOwner (copy), setIsRendering (copy), renderWithHooks (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), u161 (ref), bailoutHooks (copy), bailoutOnAlreadyFinishedWork (ref), PerformedWork (copy), mountChildFibers (copy), reconcileChildFibers (copy)
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and p11.type ~= p11.elementType then
			local propTypes = p12.propTypes
			local validateProps = p12.validateProps

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p13, "prop", getComponentName(p12))
			end
		end

		local render = p12.render
		local ref = p11.ref

		prepareToReadContext(p11, p14, t2.markWorkInProgressReceivedUpdate)

		local v215

		if __DEV__ then
			ReactCurrentOwner.current = p11
			setIsRendering(true)
			v215 = renderWithHooks(p10, p11, render, p13, ref, p14)

			if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p11.mode, StrictMode) ~= 0 then
				disableLogs()

				local ok, result = xpcall(renderWithHooks, describeError, p10, p11, render, p13, ref, p14)

				if ok then
					v215 = result
				end

				reenableLogs()

				if not ok then
					error(result)
				end
			end

			setIsRendering(false)
		else
			v215 = renderWithHooks(p10, p11, render, p13, ref, p14)
		end

		if p10 ~= nil and not u161 then
			bailoutHooks(p10, p11, p14)

			return bailoutOnAlreadyFinishedWork(p10, p11, p14)
		end

		p11.flags = bit32.bor(p11.flags, PerformedWork)

		if p10 == nil then
			p11.child = mountChildFibers(p11, nil, v215, p14)
		else
			p11.child = reconcileChildFibers(p11, p10.child, v215, p14)
		end

		return p11.child
	end
	function updateMemoComponent(p15, p16, p17, p18, p19, p20) -- line: 454
		-- upvalues: isSimpleFunctionComponent (copy), __DEV__ (copy), resolveFunctionForHotReloading (copy), SimpleMemoComponent (copy), updateSimpleMemoComponent (ref), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), createFiberFromTypeAndProps (copy), ReactFiberLane (copy), shallowEqual (copy), bailoutOnAlreadyFinishedWork (ref), PerformedWork (copy), createWorkInProgress (copy)
		if p15 == nil then
			local type2 = p17.type

			if isSimpleFunctionComponent(type2) and p17.compare == nil and p17.defaultProps == nil then
				local v225 = type2

				if __DEV__ then
					v225 = resolveFunctionForHotReloading(type2)
				end

				p16.tag = SimpleMemoComponent
				p16.type = v225

				if __DEV__ then
					validateFunctionComponentInDev(p16, type2)
				end

				return updateSimpleMemoComponent(p15, p16, v225, p18, p19, p20)
			end

			if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
				local propTypes = nil
				local validateProps = nil

				if type(type2) == "table" then
					propTypes = type2.propTypes
					validateProps = type2.validateProps
				end

				if propTypes or validateProps then
					checkPropTypes(propTypes, validateProps, p18, "prop", getComponentName(type2))
				end
			end

			local v228 = createFiberFromTypeAndProps(p17.type, nil, p18, p16, p16.mode, p20)

			v228.ref = p16.ref
			v228.return_ = p16
			p16.child = v228

			return v228
		end

		if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
			local type3 = p17.type
			local propTypes = nil
			local validateProps = nil

			if type(type3) == "table" then
				propTypes = type3.propTypes
				validateProps = type3.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p18, "prop", getComponentName(type3))
			end
		end

		local child = p15.child

		if not ReactFiberLane.includesSomeLane(p19, p20) then
			local memoizedProps = child.memoizedProps
			local compare = p17.compare

			if compare == nil then
				compare = shallowEqual
			end

			if compare(memoizedProps, p18) and p15.ref == p16.ref then
				return bailoutOnAlreadyFinishedWork(p15, p16, p20)
			end
		end

		p16.flags = bit32.bor(p16.flags, PerformedWork)

		local v235 = createWorkInProgress(child, p18)

		v235.ref = p16.ref
		v235.return_ = p16
		p16.child = v235

		return v235
	end
	function updateSimpleMemoComponent(p21, p22, p23, p24, p25, p26) -- line: 575
		-- upvalues: __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), REACT_LAZY_TYPE (copy), describeError (copy), checkPropTypes (copy), getComponentName (copy), shallowEqual (copy), u161 (ref), ReactFiberLane (copy), bailoutOnAlreadyFinishedWork (ref), ForceUpdateForLegacySuspense (copy), NoFlags (copy), updateFunctionComponent (ref)
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and p22.type ~= p22.elementType then
			local elementType = p22.elementType

			if elementType["$$typeof"] == REACT_LAZY_TYPE then
				local _payload = elementType._payload
				local _init = elementType._init
				local ok, result = xpcall(_init, describeError, _payload)
				local v247 = if not ok then nil else result
				local propTypes = nil
				local validateProps = nil

				if v247 ~= nil and type(v247) == "table" then
					propTypes = v247.propTypes
					validateProps = v247.validateProps
				end

				if propTypes or validateProps then
					checkPropTypes(propTypes, validateProps, p24, "prop", getComponentName(v247))
				end
			end
		end

		if p21 ~= nil then
			local memoizedProps = p21.memoizedProps
			local v251 = true

			if __DEV__ then
				v251 = p22.type == p21.type
			end

			if shallowEqual(memoizedProps, p24) and p21.ref == p22.ref and v251 then
				u161 = false

				if not ReactFiberLane.includesSomeLane(p26, p25) then
					p22.lanes = p21.lanes

					return bailoutOnAlreadyFinishedWork(p21, p22, p26)
				end

				if bit32.band(p21.flags, ForceUpdateForLegacySuspense) ~= NoFlags then
					u161 = true
				end
			end
		end

		return updateFunctionComponent(p21, p22, p23, p24, p26)
	end
	function updateOffscreenComponent(p27, p28, p29) -- line: 677
		-- upvalues: ConcurrentMode (copy), NoMode (copy), ReactFiberLane (copy), pushRenderLanes (copy), enableSchedulerTracing (copy), markSpawnedWork (copy), mountChildFibers (copy), reconcileChildFibers (copy)
		local pendingProps = p28.pendingProps
		local children = pendingProps.children
		local memoizedState = nil

		if p27 ~= nil then
			memoizedState = p27.memoizedState
		end

		if pendingProps.mode == "hidden" or pendingProps.mode == "unstable-defer-without-hiding" then
			if bit32.band(p28.mode, ConcurrentMode) == NoMode then
				p28.memoizedState = {
					baseLanes = ReactFiberLane.NoLanes
				}
				pushRenderLanes(p28, p29)
			else
				if not ReactFiberLane.includesSomeLane(p29, ReactFiberLane.OffscreenLane) then
					if memoizedState ~= nil then
						local baseLanes = memoizedState.baseLanes

						p29 = ReactFiberLane.mergeLanes(baseLanes, p29)
					end

					if enableSchedulerTracing then
						markSpawnedWork(ReactFiberLane.OffscreenLane)
					end

					p28.childLanes = ReactFiberLane.laneToLanes(ReactFiberLane.OffscreenLane)
					p28.lanes = p28.childLanes
					p28.memoizedState = {
						baseLanes = p29
					}
					pushRenderLanes(p28, p29)

					return nil
				end

				p28.memoizedState = {
					baseLanes = ReactFiberLane.NoLanes
				}

				local v259 = p29

				if memoizedState ~= nil then
					v259 = memoizedState.baseLanes
				end

				pushRenderLanes(p28, v259)
			end
		else
			local v260

			if memoizedState ~= nil then
				v260 = ReactFiberLane.mergeLanes(memoizedState.baseLanes, p29)
				p28.memoizedState = nil
			else
				v260 = p29
			end

			pushRenderLanes(p28, v260)
		end

		if p27 == nil then
			p28.child = mountChildFibers(p28, nil, children, p29)
		else
			p28.child = reconcileChildFibers(p28, p27.child, children, p29)
		end

		return p28.child
	end
	function updateFragment(p30, p31, p32) -- line: 779
		-- upvalues: mountChildFibers (copy), reconcileChildFibers (copy)
		local pendingProps = p31.pendingProps

		if p30 == nil then
			p31.child = mountChildFibers(p31, nil, pendingProps, p32)
		else
			p31.child = reconcileChildFibers(p31, p30.child, pendingProps, p32)
		end

		return p31.child
	end
	function updateMode(p33, p34, p35) -- line: 785
		-- upvalues: mountChildFibers (copy), reconcileChildFibers (copy)
		local children = p34.pendingProps.children

		if p33 == nil then
			p34.child = mountChildFibers(p34, nil, children, p35)
		else
			p34.child = reconcileChildFibers(p34, p33.child, children, p35)
		end

		return p34.child
	end
	function updateProfiler(p36, p37, p38) -- line: 791
		-- upvalues: enableProfilerTimer (copy), mountChildFibers (copy), reconcileChildFibers (copy)
		if enableProfilerTimer then
			local stateNode = p37.stateNode

			stateNode.effectDuration = 0
			stateNode.passiveEffectDuration = 0
		end

		local children = p37.pendingProps.children

		if p36 == nil then
			p37.child = mountChildFibers(p37, nil, children, p38)
		else
			p37.child = reconcileChildFibers(p37, p36.child, children, p38)
		end

		return p37.child
	end

	local function markRef(p39, p40) -- line: 805
		-- upvalues: Ref (copy)
		local ref = p40.ref

		if p39 == nil and ref ~= nil or p39 ~= nil and ref ~= p39.ref then
			p40.flags = bit32.bor(p40.flags, Ref)
		end
	end

	function updateFunctionComponent(p41, p42, p43, p44, p45) -- line: 816
		-- upvalues: __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), disableLegacyContext (copy), getUnmaskedContext (copy), getMaskedContext (copy), prepareToReadContext (copy), t2 (copy), ReactCurrentOwner (copy), setIsRendering (copy), renderWithHooks (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), u161 (ref), bailoutHooks (copy), bailoutOnAlreadyFinishedWork (ref), PerformedWork (copy), mountChildFibers (copy), reconcileChildFibers (copy)
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and (type(p43) ~= "function" and p42.type ~= p42.elementType) then
			local propTypes = nil
			local validateProps = nil

			if type(p43) == "table" then
				propTypes = p43.propTypes
				validateProps = p43.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p44, "prop", getComponentName(p43))
			end
		end

		local v284 = nil

		if not disableLegacyContext then
			local v285 = getUnmaskedContext(p42, p43, true)

			v284 = getMaskedContext(p42, v285)
		end

		prepareToReadContext(p42, p45, t2.markWorkInProgressReceivedUpdate)

		local v286

		if __DEV__ then
			ReactCurrentOwner.current = p42
			setIsRendering(true)
			v286 = renderWithHooks(p41, p42, p43, p44, v284, p45)

			if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p42.mode, StrictMode) ~= 0 then
				disableLogs()

				local ok, result = xpcall(renderWithHooks, describeError, p41, p42, p43, p44, v284, p45)

				reenableLogs()

				if ok then
					v286 = result
				else
					error(result)
				end
			end

			setIsRendering(false)
		else
			v286 = renderWithHooks(p41, p42, p43, p44, v284, p45)
		end

		if p41 ~= nil and not u161 then
			bailoutHooks(p41, p42, p45)

			return bailoutOnAlreadyFinishedWork(p41, p42, p45)
		end

		p42.flags = bit32.bor(p42.flags, PerformedWork)

		if p41 == nil then
			p42.child = mountChildFibers(p42, nil, v286, p45)
		else
			p42.child = reconcileChildFibers(p42, p41.child, v286, p45)
		end

		return p42.child
	end
	function updateClassComponent(p46, p47, p48, p49, p50) -- line: 995
		-- upvalues: __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), isContextProvider (copy), pushContextProvider (copy), prepareToReadContext (copy), t2 (copy), Placement (copy), constructClassInstance (copy), mountClassInstance (copy), resumeMountClassInstance (copy), updateClassInstance (copy), console (copy)
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and p47.type ~= p47.elementType then
			local propTypes = p48.propTypes
			local validateProps = p48.validateProps

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, p49, "prop", getComponentName(p48))
			end
		end

		local v296

		if isContextProvider(p48) then
			v296 = true
			pushContextProvider(p47)
		else
			v296 = false
		end

		prepareToReadContext(p47, p50, t2.markWorkInProgressReceivedUpdate)

		local v297

		if p47.stateNode == nil then
			if p46 ~= nil then
				p46.alternate = nil
				p47.alternate = nil
				p47.flags = bit32.bor(p47.flags, Placement)
			end

			constructClassInstance(p47, p48, p49)
			mountClassInstance(p47, p48, p49, p50)
			v297 = true
		else
			v297 = if p46 ~= nil then updateClassInstance(p46, p47, p48, p49, p50) else resumeMountClassInstance(p47, p48, p49, p50)
		end

		local v298 = finishClassComponent(p46, p47, p48, v297, v296, p50)

		if __DEV__ then
			local stateNode = p47.stateNode

			if v297 and p49 ~= stateNode.props then
				if not t2.didWarnAboutReassigningProps then
					console.error("It looks like %s is reassigning its own `this.props` while rendering. This is not supported and can lead to confusing bugs.", getComponentName(p47.type) or "a component")
				end

				t2.didWarnAboutReassigningProps = true
			end
		end

		return v298
	end
	function finishClassComponent(p51, p52, p53, b1: boolean, b2: boolean, p54) -- line: 1092
		-- upvalues: Ref (copy), DidCapture (copy), NoFlags (copy), invalidateContextProvider (copy), bailoutOnAlreadyFinishedWork (ref), ReactCurrentOwner (copy), enableProfilerTimer (copy), stopProfilerTimerIfRunning (copy), __DEV__ (copy), setIsRendering (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), PerformedWork (copy), reconcileChildFibers (copy), mountChildFibers (copy)
		local ref = p52.ref

		if p51 == nil and ref ~= nil or p51 ~= nil and ref ~= p51.ref then
			p52.flags = bit32.bor(p52.flags, Ref)
		end

		local v307 = bit32.band(p52.flags, DidCapture) ~= NoFlags

		if not b1 and not v307 then
			if b2 then
				invalidateContextProvider(p52, p53, false)
			end

			return bailoutOnAlreadyFinishedWork(p51, p52, p54)
		end

		local stateNode = p52.stateNode

		ReactCurrentOwner.current = p52

		local v309

		if v307 and (p53.getDerivedStateFromError == nil or type(p53.getDerivedStateFromError) ~= "function") then
			v309 = nil

			if enableProfilerTimer then
				stopProfilerTimerIfRunning(p52)
			end
		elseif __DEV__ then
			setIsRendering(true)
			v309 = stateNode:render()

			if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p52.mode, StrictMode) ~= 0 then
				disableLogs()

				local ok, result = xpcall(stateNode.render, describeError, stateNode)

				reenableLogs()

				if not ok then
					error(result)
				end
			end

			setIsRendering(false)
		else
			v309 = stateNode:render()
		end

		p52.flags = bit32.bor(p52.flags, PerformedWork)

		if p51 ~= nil and v307 then
			p52.child = reconcileChildFibers(p52, p51.child, nil, p54)
			p52.child = reconcileChildFibers(p52, nil, v309, p54)
		elseif p51 == nil then
			p52.child = mountChildFibers(p52, nil, v309, p54)
		else
			p52.child = reconcileChildFibers(p52, p51.child, v309, p54)
		end

		p52.memoizedState = stateNode.state

		if b2 then
			invalidateContextProvider(p52, p53, true)
		end

		return p52.child
	end

	local function pushHostRootContext(p55) -- line: 1190
		-- upvalues: pushTopLevelContextObject (copy), pushHostContainer (copy)
		local stateNode = p55.stateNode

		if stateNode.pendingContext then
			pushTopLevelContextObject(p55, stateNode.pendingContext, stateNode.pendingContext ~= stateNode.context)
		elseif stateNode.context then
			pushTopLevelContextObject(p55, stateNode.context, false)
		end

		pushHostContainer(p55, stateNode.containerInfo)
	end

	function updateHostRoot(p56, p57, p58) -- line: 1206
		-- upvalues: pushTopLevelContextObject (copy), pushHostContainer (copy), invariant (copy), cloneUpdateQueue (copy), processUpdateQueue (copy), resetHydrationState (copy), bailoutOnAlreadyFinishedWork (ref), enterHydrationState (copy), supportsHydration (copy), setWorkInProgressVersion (copy), mountChildFibers (copy), Placement (copy), Hydrating (copy), reconcileChildFibers (copy)
		local stateNode = p57.stateNode

		if stateNode.pendingContext then
			pushTopLevelContextObject(p57, stateNode.pendingContext, stateNode.pendingContext ~= stateNode.context)
		elseif stateNode.context then
			pushTopLevelContextObject(p57, stateNode.context, false)
		end

		pushHostContainer(p57, stateNode.containerInfo)

		local updateQueue = p57.updateQueue

		invariant(p56 ~= nil and updateQueue ~= nil, "If the root does not have an updateQueue, we should have already bailed out. This error is likely caused by a bug in React. Please file an issue.")

		local pendingProps = p57.pendingProps
		local memoizedState = p57.memoizedState
		local element = nil

		if memoizedState ~= nil then
			element = memoizedState.element
		end

		cloneUpdateQueue(p56, p57)
		processUpdateQueue(p57, pendingProps, nil, p58)

		local element2 = p57.memoizedState.element

		if element2 == element then
			resetHydrationState()

			return bailoutOnAlreadyFinishedWork(p56, p57, p58)
		end

		local stateNode2 = p57.stateNode

		if stateNode2.hydrate and enterHydrationState(p57) then
			if supportsHydration then
				local mutableSourceEagerHydrationData = stateNode2.mutableSourceEagerHydrationData

				if mutableSourceEagerHydrationData ~= nil then
					for i = 1, #mutableSourceEagerHydrationData, 2 do
						local v326 = mutableSourceEagerHydrationData[i]
						local v327 = mutableSourceEagerHydrationData[i + 1]

						setWorkInProgressVersion(v326, v327)
					end
				end
			end

			local v328 = mountChildFibers(p57, nil, element2, p58)

			p57.child = v328

			while v328 do
				v328.flags = bit32.bor(bit32.band(v328.flags, (bit32.bnot(Placement))), Hydrating)
				v328 = v328.sibling
			end
		else
			if p56 == nil then
				p57.child = mountChildFibers(p57, nil, element2, p58)
			else
				p57.child = reconcileChildFibers(p57, p56.child, element2, p58)
			end

			resetHydrationState()
		end

		return p57.child
	end
	function updateHostComponent(p59, p60, p61) -- line: 1283
		-- upvalues: pushHostContext (copy), tryToClaimNextHydratableInstance (copy), shouldSetTextContent (copy), ContentReset (copy), PerformedWork (copy), Ref (copy), mountChildFibers (copy), reconcileChildFibers (copy)
		pushHostContext(p60)

		if p59 == nil then
			tryToClaimNextHydratableInstance(p60)
		end

		local type4 = p60.type
		local pendingProps = p60.pendingProps
		local memoizedProps = nil

		if p59 ~= nil then
			memoizedProps = p59.memoizedProps
		end

		local children = pendingProps.children

		if shouldSetTextContent(type4, pendingProps) then
			children = nil
		elseif memoizedProps ~= nil and shouldSetTextContent(type4, memoizedProps) then
			p60.flags = bit32.bor(p60.flags, ContentReset)
		end

		p60.flags = bit32.bor(p60.flags, PerformedWork)

		local ref = p60.ref

		if p59 == nil and ref ~= nil or p59 ~= nil and ref ~= p59.ref then
			p60.flags = bit32.bor(p60.flags, Ref)
		end

		if p59 == nil then
			p60.child = mountChildFibers(p60, nil, children, p61)
		else
			p60.child = reconcileChildFibers(p60, p59.child, children, p61)
		end

		return p60.child
	end
end

local function updateHostText(p62, p63) -- line: 1324
	-- upvalues: tryToClaimNextHydratableInstance (copy)
	if p62 == nil then
		tryToClaimNextHydratableInstance(p63)
	end

	return nil
end
local function mountLazyComponent(p64, p65, p66, p67, p68) -- line: 1333
	-- upvalues: Placement (copy), resolveLazyComponentTag (copy), resolveDefaultProps (copy), FunctionComponent (copy), __DEV__ (copy), resolveFunctionForHotReloading (copy), updateFunctionComponent (ref), ClassComponent (copy), resolveClassForHotReloading (copy), updateClassComponent (copy), ForwardRef (copy), resolveForwardRefForHotReloading (copy), updateForwardRef (copy), MemoComponent (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), updateMemoComponent (copy), REACT_LAZY_TYPE (copy), inspect (copy), invariant (copy)
	if p64 ~= nil then
		p64.alternate = nil
		p65.alternate = nil
		p65.flags = bit32.bor(p65.flags, Placement)
	end

	local pendingProps = p65.pendingProps
	local _payload = p66._payload
	local v346 = p66._init(_payload)

	p65.type = v346
	p65.tag = resolveLazyComponentTag(v346)

	local tag = p65.tag
	local v348 = resolveDefaultProps(v346, pendingProps)

	if tag == FunctionComponent then
		if __DEV__ then
			validateFunctionComponentInDev(p65, v346)
			v346 = resolveFunctionForHotReloading(v346)
			p65.type = v346
		end

		return (updateFunctionComponent(nil, p65, v346, v348, p68))
	end

	if tag == ClassComponent then
		if __DEV__ then
			v346 = resolveClassForHotReloading(v346)
			p65.type = v346
		end

		return (updateClassComponent(nil, p65, v346, v348, p68))
	end

	if tag == ForwardRef then
		if __DEV__ then
			v346 = resolveForwardRefForHotReloading(v346)
			p65.type = v346
		end

		return (updateForwardRef(nil, p65, v346, v348, p68))
	end

	if tag == MemoComponent then
		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and p65.type ~= p65.elementType then
			local propTypes = v346.propTypes
			local validateProps = v346.validateProps

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, v348, "prop", getComponentName(v346))
			end
		end

		return (updateMemoComponent(nil, p65, v346, resolveDefaultProps(v346.type, v348), p67, p68))
	end

	local s2 = ""

	if __DEV__ then
		if v346 ~= nil and type(v346) == "table" and v346["$$typeof"] == REACT_LAZY_TYPE then
			s2 = " Did you wrap a component in React.lazy() more than once?"
		elseif type(v346) == "table" and v346["$$typeof"] == nil then
			s2 = "\n" .. inspect(v346)
		end
	end

	invariant(false, "Element type is invalid. Received a promise that resolves to: %s. Lazy element type must resolve to a class or function.%s", tostring(v346), s2)

	return nil
end

function mountIncompleteClassComponent(p69, p70, p71, p72, p73) -- line: 1464
	-- upvalues: Placement (copy), ClassComponent (copy), isContextProvider (copy), pushContextProvider (copy), prepareToReadContext (copy), t2 (copy), constructClassInstance (copy), mountClassInstance (copy)
	if p69 ~= nil then
		p69.alternate = nil
		p70.alternate = nil
		p70.flags = bit32.bor(p70.flags, Placement)
	end

	p70.tag = ClassComponent

	local v357

	if isContextProvider(p71) then
		v357 = true
		pushContextProvider(p70)
	else
		v357 = false
	end

	prepareToReadContext(p70, p73, t2.markWorkInProgressReceivedUpdate)
	constructClassInstance(p70, p71, p72)
	mountClassInstance(p70, p71, p72, p73)

	return finishClassComponent(nil, p70, p71, true, v357, p73)
end

local function mountIndeterminateComponent(p74, p75, p76, p77) -- line: 1516
	-- upvalues: Placement (copy), disableLegacyContext (copy), getUnmaskedContext (copy), getMaskedContext (copy), prepareToReadContext (copy), t2 (copy), __DEV__ (copy), getComponentName (copy), t3 (copy), console (copy), StrictMode (copy), lib (copy), setIsRendering (copy), ReactCurrentOwner (copy), renderWithHooks (copy), PerformedWork (copy), disableModulePatternComponents (copy), ClassComponent (copy), isContextProvider (copy), pushContextProvider (copy), initializeUpdateQueue (copy), applyDerivedStateFromProps (copy), adoptClassInstance (copy), mountClassInstance (copy), FunctionComponent (copy), debugRenderPhaseSideEffectsForStrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), mountChildFibers (copy)
	if p74 ~= nil then
		p74.alternate = nil
		p75.alternate = nil
		p75.flags = bit32.bor(p75.flags, Placement)
	end

	local pendingProps = p75.pendingProps
	local v363 = nil

	if not disableLegacyContext then
		local v364 = getUnmaskedContext(p75, p76, false)

		v363 = getMaskedContext(p75, v364)
	end

	prepareToReadContext(p75, p77, t2.markWorkInProgressReceivedUpdate)

	local v366

	if __DEV__ then
		if type(p76) == "table" and type(p76.render) == "function" then
			local v365 = getComponentName(p76) or "Unknown"

			if not t3.didWarnAboutBadClass[v365] then
				console.error("The <%s /> component appears to have a render method, but doesn't extend React.Component. This is likely to cause errors. Change %s to extend React.Component instead.", v365, v365)
				t3.didWarnAboutBadClass[v365] = true
			end
		end

		if bit32.band(p75.mode, StrictMode) ~= 0 then
			lib.recordLegacyContextWarning(p75)
		end

		setIsRendering(true)
		ReactCurrentOwner.current = p75
		v366 = renderWithHooks(nil, p75, p76, pendingProps, v363, p77)
		setIsRendering(false)
	else
		v366 = renderWithHooks(nil, p75, p76, pendingProps, v363, p77)
	end

	p75.flags = bit32.bor(p75.flags, PerformedWork)

	local v367 = type(v366)

	if __DEV__ and v366 ~= nil and v367 == "table" and type(v366.render) == "function" and v366["$$typeof"] == nil then
		local v368 = getComponentName(p76) or "Unknown"

		if not t3.didWarnAboutModulePatternComponent[v368] then
			console.error("The <%s /> component appears to be a function component that returns a class instance. Change %s to a class that extends React.Component instead. ", v368, v368)
			t3.didWarnAboutModulePatternComponent[v368] = true
		end
	end

	if not disableModulePatternComponents and v366 ~= nil and v367 == "table" and type(v366.render) == "function" and v366["$$typeof"] == nil then
		if __DEV__ then
			local v369 = getComponentName(p76) or "Unknown"

			if not t3.didWarnAboutModulePatternComponent[v369] then
				console.error("The <%s /> component appears to be a function component that returns a class instance. " .. "Change %s to a class that extends React.Component instead. " .. v369, v369)
				t3.didWarnAboutModulePatternComponent[v369] = true
			end
		end

		p75.tag = ClassComponent
		p75.memoizedState = nil
		p75.updateQueue = nil

		local v370

		if isContextProvider(p76) then
			v370 = true
			pushContextProvider(p75)
		else
			v370 = false
		end

		p75.memoizedState = v366.state
		initializeUpdateQueue(p75)

		local getDerivedStateFromProps = nil

		if type(p76) ~= "function" then
			getDerivedStateFromProps = p76.getDerivedStateFromProps
		end

		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(p75, p76, getDerivedStateFromProps, pendingProps)
		end

		adoptClassInstance(p75, v366)
		mountClassInstance(p75, p76, pendingProps, p77)

		return finishClassComponent(nil, p75, p76, true, v370, p77)
	end

	p75.tag = FunctionComponent

	if __DEV__ then
		if disableLegacyContext and p76.contextTypes then
			console.error("%s uses the legacy contextTypes API which is no longer supported. Use React.createContext() with React.useContext() instead.", getComponentName(p76) or "Unknown")
		end

		if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p75.mode, StrictMode) ~= 0 then
			disableLogs()

			local ok, result = xpcall(renderWithHooks, describeError, nil, p75, p76, pendingProps, v363, p77)

			reenableLogs()

			if ok then
				v366 = result
			else
				error(result)
			end
		end
	end

	p75.child = mountChildFibers(p75, nil, v366, p77)

	if __DEV__ then
		validateFunctionComponentInDev(p75, p76)
	end

	return p75.child
end

function validateFunctionComponentInDev(p78, p79) -- line: 1733
	-- upvalues: __DEV__ (copy), getCurrentFiberOwnerNameInDevOrNull (copy), t3 (copy), console (copy), warnAboutDefaultPropsOnFunctionComponents (copy), getComponentName (copy)
	if __DEV__ then
		if p78.ref ~= nil then
			local s3 = ""
			local v377 = getCurrentFiberOwnerNameInDevOrNull()

			if v377 then
				s3 ..= "\n\nCheck the render method of `" .. v377 .. "`."
			end

			local v378 = v377 or (p78._debugID or "")
			local _debugSource = p78._debugSource

			if _debugSource then
				v378 = _debugSource.fileName .. ":" .. _debugSource.lineNumber
			end

			if not t3.didWarnAboutFunctionRefs[v378] then
				t3.didWarnAboutFunctionRefs[v378] = true
				console.error("Function components cannot be given refs. Attempts to access this ref will fail. Did you mean to use React.forwardRef()?%s", s3)
			end
		end

		if warnAboutDefaultPropsOnFunctionComponents and type(p79) ~= "function" and p79.defaultProps ~= nil then
			local v380 = getComponentName(p79) or "Unknown"

			if not t3.didWarnAboutDefaultPropsOnFunctionComponent[v380] then
				console.error("%s: Support for defaultProps will be removed from function components in a future major release.", v380)
				t3.didWarnAboutDefaultPropsOnFunctionComponent[v380] = true
			end
		end

		if type(p79) ~= "function" and p79.getDerivedStateFromProps ~= nil and type(p79.getDerivedStateFromProps) == "function" then
			local v381 = getComponentName(p79) or "Unknown"

			if not t3.didWarnAboutGetDerivedStateOnFunctionComponent[v381] then
				console.error("%s: Function components do not support getDerivedStateFromProps.", v381)
				t3.didWarnAboutGetDerivedStateOnFunctionComponent[v381] = true
			end
		end

		if type(p79) ~= "function" and p79.contextType ~= nil and type(p79.contextType) == "table" then
			local v382 = getComponentName(p79) or "Unknown"

			if not t3.didWarnAboutContextTypeOnFunctionComponent[v382] then
				console.error("%s: Function components do not support contextType.", v382)
				t3.didWarnAboutContextTypeOnFunctionComponent[v382] = true
			end
		end
	end
end

local t4 = {
	dehydrated = nil,
	retryLane = ReactFiberLane.NoLane
}

local function mountSuspenseOffscreenState(p80) -- line: 1830
	return {
		baseLanes = p80
	}
end
local function updateSuspenseOffscreenState(p81, p82) -- line: 1836
	-- upvalues: ReactFiberLane (copy)
	return {
		baseLanes = ReactFiberLane.mergeLanes(p81.baseLanes, p82)
	}
end
local function shouldRemainOnFallback(p83, p84, _, _) -- line: 1846
	-- upvalues: hasSuspenseContext (copy), ForceSuspenseFallback (copy)
	if p84 ~= nil and p84.memoizedState == nil then
		return false
	end

	return hasSuspenseContext(p83, ForceSuspenseFallback)
end
local function getRemainingWorkInPrimaryTree(p87, p88) -- line: 1870
	-- upvalues: ReactFiberLane (copy)
	return ReactFiberLane.removeLanes(p87.childLanes, p88)
end

local updateSuspensePrimaryChildren = nil
local mountDehydratedSuspenseComponent = nil
local mountSuspensePrimaryChildren = nil
local updateSuspenseFallbackChildren = nil
local updateDehydratedSuspenseComponent = nil

local function updateSuspenseComponent(p89, p90, p91) -- line: 1882
	-- upvalues: __DEV__ (copy), t1 (copy), DidCapture (copy), suspenseStackCursor (copy), NoFlags (copy), hasSuspenseContext (copy), ForceSuspenseFallback (copy), addSubtreeSuspenseContext (copy), InvisibleParentSuspenseContext (copy), setDefaultShallowSuspenseContext (copy), pushSuspenseContext (copy), tryToClaimNextHydratableInstance (copy), enableSuspenseServerRenderer (copy), mountDehydratedSuspenseComponent (ref), t4 (copy), ReactFiberLane (copy), enableSchedulerTracing (copy), markSpawnedWork (copy), mountSuspensePrimaryChildren (ref), updateDehydratedSuspenseComponent (ref), updateSuspenseFallbackChildren (ref), updateSuspensePrimaryChildren (ref)
	local pendingProps = p90.pendingProps

	if __DEV__ then
		if not t1.shouldSuspendRef then
			t1.shouldSuspendRef = require(script.Parent.ReactFiberReconciler).shouldSuspend
		end

		if t1.shouldSuspendRef(p90) then
			p90.flags = bit32.bor(p90.flags, DidCapture)
		end
	end

	local current = suspenseStackCursor.current
	local v397 = false
	local v398 = bit32.band(p90.flags, DidCapture) ~= NoFlags

	if v398 or (p89 == nil or p89.memoizedState ~= nil) and hasSuspenseContext(current, ForceSuspenseFallback) then
		v397 = true
		p90.flags = bit32.band(p90.flags, (bit32.bnot(DidCapture)))
	elseif (p89 == nil or p89.memoizedState ~= nil) and pendingProps.fallback ~= nil and pendingProps.unstable_avoidThisFallback ~= true then
		current = addSubtreeSuspenseContext(current, InvisibleParentSuspenseContext)
	end

	local v399 = setDefaultShallowSuspenseContext(current)

	pushSuspenseContext(p90, v399)

	if p89 == nil then
		if pendingProps.fallback ~= nil then
			tryToClaimNextHydratableInstance(p90)

			if enableSuspenseServerRenderer then
				local memoizedState = p90.memoizedState

				if memoizedState ~= nil then
					local dehydrated = memoizedState.dehydrated

					if dehydrated ~= nil then
						return mountDehydratedSuspenseComponent(p90, dehydrated, p91)
					end
				end
			end
		end

		local children = pendingProps.children
		local fallback = pendingProps.fallback

		if v397 then
			local v404 = mountSuspenseFallbackChildren(p90, children, fallback, p91)

			p90.child.memoizedState = {
				baseLanes = p91
			}
			p90.memoizedState = t4

			return v404
		end

		if pendingProps.unstable_expectedLoadTime ~= nil and type(pendingProps.unstable_expectedLoadTime) == "number" then
			local v405 = mountSuspenseFallbackChildren(p90, children, fallback, p91)

			p90.child.memoizedState = {
				baseLanes = p91
			}
			p90.memoizedState = t4
			p90.lanes = ReactFiberLane.SomeRetryLane

			if enableSchedulerTracing then
				markSpawnedWork(ReactFiberLane.SomeRetryLane)
			end

			return v405
		end

		return mountSuspensePrimaryChildren(p90, children, p91)
	end

	local memoizedState = p89.memoizedState

	if memoizedState ~= nil then
		if enableSuspenseServerRenderer then
			local dehydrated = memoizedState.dehydrated

			if dehydrated ~= nil then
				if not v398 then
					return updateDehydratedSuspenseComponent(p89, p90, dehydrated, memoizedState, p91)
				end

				if p90.memoizedState ~= nil then
					p90.child = p89.child
					p90.flags = bit32.bor(p90.flags, DidCapture)

					return nil
				end

				local children = pendingProps.children
				local fallback = pendingProps.fallback
				local v410 = mountSuspenseFallbackAfterRetryWithoutHydrating(p89, p90, children, fallback, p91)

				p90.child.memoizedState = {
					baseLanes = p91
				}
				p90.memoizedState = t4

				return v410
			end
		end

		if v397 then
			local fallback = pendingProps.fallback
			local children = pendingProps.children
			local v413 = updateSuspenseFallbackChildren(p89, p90, children, fallback, p91)
			local child = p90.child
			local memoizedState2 = p89.child.memoizedState

			if memoizedState2 == nil then
				child.memoizedState = {
					baseLanes = p91
				}
			else
				child.memoizedState = {
					baseLanes = ReactFiberLane.mergeLanes(memoizedState2.baseLanes, p91)
				}
			end

			child.childLanes = ReactFiberLane.removeLanes(p89.childLanes, p91)
			p90.memoizedState = t4

			return v413
		end

		local children = pendingProps.children
		local v417 = updateSuspensePrimaryChildren(p89, p90, children, p91)

		p90.memoizedState = nil

		return v417
	end

	if v397 then
		local fallback = pendingProps.fallback
		local children = pendingProps.children
		local v420 = updateSuspenseFallbackChildren(p89, p90, children, fallback, p91)
		local child = p90.child
		local memoizedState3 = p89.child.memoizedState

		if memoizedState3 == nil then
			child.memoizedState = {
				baseLanes = p91
			}
		else
			child.memoizedState = {
				baseLanes = ReactFiberLane.mergeLanes(memoizedState3.baseLanes, p91)
			}
		end

		child.childLanes = ReactFiberLane.removeLanes(p89.childLanes, p91)
		p90.memoizedState = t4

		return v420
	end

	local children = pendingProps.children
	local v424 = updateSuspensePrimaryChildren(p89, p90, children, p91)

	p90.memoizedState = nil

	return v424
end

function mountSuspensePrimaryChildren(p92, p93, p94) -- line: 2167
	-- upvalues: createFiberFromOffscreen (copy)
	local mode = p92.mode
	local t5 = {
		mode = "visible",
		children = p93
	}
	local v430 = createFiberFromOffscreen(t5, mode, p94, nil)

	v430.return_ = p92
	p92.child = v430

	return v430
end
function mountSuspenseFallbackChildren(p95, p96, p97, p98) -- line: 2180
	-- upvalues: BlockingMode (copy), NoMode (copy), ReactFiberLane (copy), enableProfilerTimer (copy), ProfileMode (copy), createFiberFromFragment (copy), createFiberFromOffscreen (copy)
	local mode = p95.mode
	local child = p95.child
	local t6 = {
		mode = "hidden",
		children = p96
	}
	local v438

	if bit32.band(mode, BlockingMode) == NoMode and child ~= nil then
		child.childLanes = ReactFiberLane.NoLanes
		child.pendingProps = t6

		if enableProfilerTimer and bit32.band(p95.mode, ProfileMode) ~= 0 then
			child.actualDuration = 0
			child.actualStartTime = -1
			child.selfBaseDuration = 0
			child.treeBaseDuration = 0
		end

		v438 = createFiberFromFragment(p97, mode, p98, nil)
	else
		child = createFiberFromOffscreen(t6, mode, ReactFiberLane.NoLanes, nil)
		v438 = createFiberFromFragment(p97, mode, p98, nil)
	end

	child.return_ = p95
	v438.return_ = p95
	child.sibling = v438
	p95.child = child

	return v438
end

local function createWorkInProgressOffscreenFiber(p99, p100) -- line: 2230
	-- upvalues: createWorkInProgress (copy)
	return createWorkInProgress(p99, p100)
end

function updateSuspensePrimaryChildren(p101, p102, p103, p104) -- line: 2239
	-- upvalues: createWorkInProgress (copy), BlockingMode (copy), NoMode (copy), Deletion (copy)
	local child = p101.child
	local sibling = child.sibling
	local t7 = {
		mode = "visible",
		children = p103
	}
	local v448 = createWorkInProgress(child, t7)

	if bit32.band(p102.mode, BlockingMode) == NoMode then
		v448.lanes = p104
	end

	v448.return_ = p102
	v448.sibling = nil

	if sibling ~= nil then
		local deletions = p102.deletions

		if deletions == nil then
			p102.deletions = { sibling }
			p102.flags = bit32.bor(p102.flags, Deletion)
		else
			table.insert(deletions, sibling)
		end
	end

	p102.child = v448

	return v448
end
function updateSuspenseFallbackChildren(p105, p106, p107, p108, p109) -- line: 2274
	-- upvalues: BlockingMode (copy), NoMode (copy), ReactFiberLane (copy), enableProfilerTimer (copy), ProfileMode (copy), createWorkInProgress (copy), StaticMask (copy), createFiberFromFragment (copy), Placement (copy)
	local mode = p106.mode
	local child = p105.child
	local sibling = child.sibling
	local t8 = {
		mode = "hidden",
		children = p107
	}
	local child2

	if bit32.band(mode, BlockingMode) == NoMode and child ~= p106.child then
		child2 = p106.child
		child2.childLanes = ReactFiberLane.NoLanes
		child2.pendingProps = t8

		if enableProfilerTimer and bit32.band(p106.mode, ProfileMode) ~= 0 then
			child2.actualDuration = 0
			child2.actualStartTime = -1
			child2.selfBaseDuration = child.selfBaseDuration
			child2.treeBaseDuration = child.treeBaseDuration
		end

		p106.deletions = nil
	else
		child2 = createWorkInProgress(child, t8)
		child2.subtreeFlags = bit32.band(child.subtreeFlags, StaticMask)
	end

	local v460

	if sibling ~= nil then
		v460 = createWorkInProgress(sibling, p108)
	else
		v460 = createFiberFromFragment(p108, mode, p109, nil)
		v460.flags = bit32.bor(v460.flags, Placement)
	end

	v460.return_ = p106
	child2.return_ = p106
	child2.sibling = v460
	p106.child = child2

	return v460
end

local function retrySuspenseComponentWithoutHydrating(p110, p111, p112) -- line: 2357
	-- upvalues: reconcileChildFibers (copy), mountSuspensePrimaryChildren (ref), Placement (copy)
	reconcileChildFibers(p111, p110.child, nil, p112)

	local children = p111.pendingProps.children
	local v465 = mountSuspensePrimaryChildren(p111, children, p112)

	v465.flags = bit32.bor(v465.flags, Placement)
	p111.memoizedState = nil

	return v465
end

function mountSuspenseFallbackAfterRetryWithoutHydrating(p113, p114, p115, p116, p117) -- line: 2378
	-- upvalues: createFiberFromOffscreen (copy), ReactFiberLane (copy), createFiberFromFragment (copy), Placement (copy), BlockingMode (copy), NoMode (copy), reconcileChildFibers (copy)
	local mode = p114.mode
	local v472 = createFiberFromOffscreen(p115, mode, ReactFiberLane.NoLanes, nil)
	local v473 = createFiberFromFragment(p116, mode, p117, nil)

	v473.flags = bit32.bor(v473.flags, Placement)
	v472.return_ = p114
	v473.return_ = p114
	v472.sibling = v473
	p114.child = v472

	if bit32.band(p114.mode, BlockingMode) ~= NoMode then
		reconcileChildFibers(p114, p113.child, nil, p117)
	end

	return v473
end
function mountDehydratedSuspenseComponent(p118, p119, _) -- line: 2408
	-- upvalues: BlockingMode (copy), NoMode (copy), __DEV__ (copy), console (copy), ReactFiberLane (copy), isSuspenseInstanceFallback (copy), enableSchedulerTracing (copy), markSpawnedWork (copy)
	if bit32.band(p118.mode, BlockingMode) == NoMode then
		if __DEV__ then
			console.error("Cannot hydrate Suspense in legacy mode. Switch fromReactDOM.hydrate(element, container) to ReactDOM.createBlockingRoot(container, { hydrate: true }).render(element) or remove the Suspense componentsthe server rendered components.")
		end

		p118.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.SyncLane)
	elseif isSuspenseInstanceFallback(p119) then
		if enableSchedulerTracing then
			markSpawnedWork(ReactFiberLane.DefaultHydrationLane)
		end

		p118.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.DefaultHydrationLane)
	else
		p118.lanes = ReactFiberLane.laneToLanes(ReactFiberLane.OffscreenLane)

		if enableSchedulerTracing then
			markSpawnedWork(ReactFiberLane.OffscreenLane)
		end
	end

	return nil
end
function updateDehydratedSuspenseComponent(p121, p122, p123, p124, p125) -- line: 2455
	-- upvalues: warnIfHydrating (copy), getExecutionContext (copy), RetryAfterError (copy), NoContext (copy), reconcileChildFibers (copy), mountSuspensePrimaryChildren (ref), Placement (copy), BlockingMode (copy), NoMode (copy), isSuspenseInstanceFallback (copy), ReactFiberLane (copy), u161 (ref), getWorkInProgressRoot (copy), scheduleUpdateOnFiber (copy), renderDidSuspendDelayIfPossible (copy), isSuspenseInstancePending (copy), DidCapture (copy), retryDehydratedSuspenseBoundary (copy), enableSchedulerTracing (copy), u151 (ref), ParentParent (copy), registerSuspenseInstanceRetry (copy), reenterHydrationStateFromDehydratedSuspenseInstance (copy), Hydrating (copy)
	warnIfHydrating()

	if bit32.band(getExecutionContext(), RetryAfterError) ~= NoContext then
		reconcileChildFibers(p122, p121.child, nil, p125)

		local children = p122.pendingProps.children
		local v483 = mountSuspensePrimaryChildren(p122, children, p125)

		v483.flags = bit32.bor(v483.flags, Placement)
		p122.memoizedState = nil

		return v483
	end

	if bit32.band(p122.mode, BlockingMode) == NoMode then
		reconcileChildFibers(p122, p121.child, nil, p125)

		local children = p122.pendingProps.children
		local v485 = mountSuspensePrimaryChildren(p122, children, p125)

		v485.flags = bit32.bor(v485.flags, Placement)
		p122.memoizedState = nil

		return v485
	end

	if isSuspenseInstanceFallback(p123) then
		reconcileChildFibers(p122, p121.child, nil, p125)

		local children = p122.pendingProps.children
		local v487 = mountSuspensePrimaryChildren(p122, children, p125)

		v487.flags = bit32.bor(v487.flags, Placement)
		p122.memoizedState = nil

		return v487
	end

	local v488 = ReactFiberLane.includesSomeLane(p125, p121.childLanes)

	if u161 or v488 then
		local v489 = getWorkInProgressRoot()

		if v489 ~= nil then
			local v490 = ReactFiberLane.getBumpedLaneForHydration(v489, p125)

			if v490 ~= ReactFiberLane.NoLane and v490 ~= p124.retryLane then
				p124.retryLane = v490

				local NoTimestamp = ReactFiberLane.NoTimestamp

				scheduleUpdateOnFiber(p121, v490, NoTimestamp)
			end
		end

		renderDidSuspendDelayIfPossible()
		reconcileChildFibers(p122, p121.child, nil, p125)

		local children = p122.pendingProps.children
		local v493 = mountSuspensePrimaryChildren(p122, children, p125)

		v493.flags = bit32.bor(v493.flags, Placement)
		p122.memoizedState = nil

		return v493
	end

	if isSuspenseInstancePending(p123) then
		p122.flags = bit32.bor(p122.flags, DidCapture)
		p122.child = p121.child

		local function v494() -- line: 2551
			-- upvalues: retryDehydratedSuspenseBoundary (copy), p121 (copy)
			return retryDehydratedSuspenseBoundary(p121)
		end

		if enableSchedulerTracing then
			if u151 == nil then
				u151 = require(ParentParent.Scheduler).tracing.unstable_wrap
			end

			v494 = u151(v494)
		end

		registerSuspenseInstanceRetry(p123, v494)

		return nil
	end

	reenterHydrationStateFromDehydratedSuspenseInstance(p122, p123)

	local children = p122.pendingProps.children
	local v496 = mountSuspensePrimaryChildren(p122, children, p125)

	v496.flags = bit32.bor(v496.flags, Hydrating)

	return v496
end
function updatePortalComponent(p126, p127, p128) -- line: 2964
	-- upvalues: pushHostContainer (copy), reconcileChildFibers (copy), mountChildFibers (copy)
	pushHostContainer(p127, p127.stateNode.containerInfo)

	local pendingProps = p127.pendingProps

	if p126 == nil then
		p127.child = reconcileChildFibers(p127, nil, pendingProps, p128)
	elseif p126 == nil then
		p127.child = mountChildFibers(p127, nil, pendingProps, p128)
	else
		p127.child = reconcileChildFibers(p127, p126.child, pendingProps, p128)
	end

	return p127.child
end

local u190 = false

local function updateContextProvider(p129, p130, p131) -- line: 2987
	-- upvalues: __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), Array (copy), Object (copy), u190 (ref), console (copy), checkPropTypes (copy), pushProvider (copy), calculateChangedBits (copy), hasContextChanged (copy), bailoutOnAlreadyFinishedWork (ref), propagateContextChange (copy), mountChildFibers (copy), reconcileChildFibers (copy)
	local _context = p130.type._context
	local pendingProps = p130.pendingProps
	local memoizedProps = p130.memoizedProps
	local value = pendingProps.value

	if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		if Array.indexOf(Object.keys(pendingProps), "value") < 1 and not u190 then
			u190 = true
			console.error("The `value` prop is required for the `<Context.Provider>`. Did you misspell it or forget to pass it?")
		end

		local propTypes = p130.type.propTypes
		local validateProps = p130.type.validateProps

		if propTypes or validateProps then
			checkPropTypes(propTypes, validateProps, pendingProps, "prop", "Context.Provider")
		end
	end

	pushProvider(p130, value)

	if memoizedProps ~= nil then
		local value2 = memoizedProps.value
		local v511 = calculateChangedBits(_context, value, value2)

		if v511 == 0 then
			if memoizedProps.children == pendingProps.children and not hasContextChanged() then
				return bailoutOnAlreadyFinishedWork(p129, p130, p131)
			end
		else
			propagateContextChange(p130, _context, v511, p131)
		end
	end

	local children = pendingProps.children

	if p129 == nil then
		p130.child = mountChildFibers(p130, nil, children, p131)
	else
		p130.child = reconcileChildFibers(p130, p129.child, children, p131)
	end

	return p130.child
end

local t9 = {
	usingContextAsConsumer = false,
	usingLegacyConsumer = false
}

function updateContextConsumer(p132, p133, p134) -- line: 3055
	-- upvalues: __DEV__ (copy), t9 (copy), console (copy), __COMPAT_WARNINGS__ (copy), prepareToReadContext (copy), t2 (copy), readContext (copy), ReactCurrentOwner (copy), setIsRendering (copy), PerformedWork (copy), mountChildFibers (copy), reconcileChildFibers (copy)
	local type5 = p133.type

	if __DEV__ then
		if type5._context == nil then
			if type5 ~= type5.Consumer and not t9.usingContextAsConsumer then
				t9.usingContextAsConsumer = true
				console.error("Rendering <Context> directly is not supported and will be removed in a future major release. Did you mean to render <Context.Consumer> instead?")
			end
		else
			type5 = type5._context
		end
	end

	local pendingProps = p133.pendingProps
	local render

	if pendingProps.render then
		if __DEV__ and __COMPAT_WARNINGS__ and not t9.usingLegacyConsumer then
			t9.usingLegacyConsumer = true
			console.warn("Your Context.Consumer component is using legacy Roact syntax, which won't be supported in future versions of Roact. \nPlease provide no props and supply the 'render' function as a child (the 3rd argument of createElement). For example: \n       createElement(ContextConsumer, {render = function(...) end})\nbecomes:\n       createElement(ContextConsumer, nil, function(...) end)\nFor more info, reference the React documentation here: \nhttps://reactjs.org/docs/context.html#contextconsumer")
		end

		render = pendingProps.render
	else
		render = pendingProps.children
	end

	if __DEV__ and type(render) ~= "function" then
		console.error("A context consumer was rendered with multiple children, or a child that isn't a function. A context consumer expects a single child that is a function. If you did pass a function, make sure there is no trailing or leading whitespace around it.")
	end

	prepareToReadContext(p133, p134, t2.markWorkInProgressReceivedUpdate)

	local v519 = readContext(type5, pendingProps.unstable_observedBits)
	local v520

	if __DEV__ then
		ReactCurrentOwner.current = p133
		setIsRendering(true)
		v520 = render(v519)
		setIsRendering(false)
	else
		v520 = render(v519)
	end

	p133.flags = bit32.bor(p133.flags, PerformedWork)

	if p132 == nil then
		p133.child = mountChildFibers(p133, nil, v520, p134)
	else
		p133.child = reconcileChildFibers(p133, p132.child, v520, p134)
	end

	return p133.child
end
function t2.markWorkInProgressReceivedUpdate() -- line: 3165
	-- upvalues: u161 (ref)
	u161 = true
end
function bailoutOnAlreadyFinishedWork(p135, p136, p137) -- line: 3169
	-- upvalues: enableProfilerTimer (copy), stopProfilerTimerIfRunning (copy), markSkippedUpdateLanes (copy), ReactFiberLane (copy), cloneChildFibers (copy)
	if p135 then
		p136.dependencies = p135.dependencies
	end

	if enableProfilerTimer then
		stopProfilerTimerIfRunning(p136)
	end

	markSkippedUpdateLanes(p136.lanes)

	if not ReactFiberLane.includesSomeLane(p137, p136.childLanes) then
		return nil
	end

	cloneChildFibers(p135, p136)

	return p136.child
end
function remountFiber(p138, p139, p140) -- line: 3200
	-- upvalues: __DEV__ (copy), Deletion (copy), Placement (copy)
	if __DEV__ then
		local return_ = p139.return_

		if return_ == nil then
			error("Cannot swap the root fiber.")
		end

		assert(return_ ~= nil, "returnFiber was nil in remountFiber")
		p138.alternate = nil
		p139.alternate = nil
		p140.index = p139.index
		p140.sibling = p139.sibling
		p140.return_ = p139.return_
		p140.ref = p139.ref

		if p139 == return_.child then
			return_.child = p140
		else
			local child = return_.child

			if child == nil then
				error("Expected parent to have a child.")
			end

			assert(child ~= nil, "prevSibling was nil in remountFiber")

			while p139 ~= child.sibling do
				child = child.sibling

				if child == nil then
					error("Expected to find the previous sibling.")
				end
			end

			child.sibling = p140
		end

		local deletions = return_.deletions

		if deletions == nil then
			return_.deletions = { p138 }
			return_.flags = bit32.bor(return_.flags, Deletion)
		else
			table.insert(deletions, p138)
		end

		p140.flags = bit32.bor(p140.flags, Placement)

		return p140
	end

	error("Did not expect this call in production. This is a bug in React. Please file an issue.")
end
function t2.beginWork(p141, p142, p143) -- line: 3269
	-- upvalues: __DEV__ (copy), createFiberFromTypeAndProps (copy), hasContextChanged (copy), u161 (ref), ReactFiberLane (copy), HostRoot (copy), pushTopLevelContextObject (copy), pushHostContainer (copy), resetHydrationState (copy), HostComponent (copy), pushHostContext (copy), ClassComponent (copy), isContextProvider (copy), pushContextProvider (copy), HostPortal (copy), ContextProvider (copy), pushProvider (copy), Profiler (copy), enableProfilerTimer (copy), SuspenseComponent (copy), enableSuspenseServerRenderer (copy), pushSuspenseContext (copy), setDefaultShallowSuspenseContext (copy), suspenseStackCursor (copy), DidCapture (copy), updateSuspenseComponent (copy), bailoutOnAlreadyFinishedWork (ref), SuspenseListComponent (copy), OffscreenComponent (copy), LegacyHiddenComponent (copy), updateOffscreenComponent (copy), ForceUpdateForLegacySuspense (copy), NoFlags (copy), ReactWorkTags (copy), mountIndeterminateComponent (copy), LazyComponent (copy), mountLazyComponent (copy), FunctionComponent (copy), resolveDefaultProps (copy), updateFunctionComponent (ref), updateClassComponent (copy), updateHostRoot (copy), updateHostComponent (copy), HostText (copy), tryToClaimNextHydratableInstance (copy), ForwardRef (copy), updateForwardRef (copy), Fragment (copy), ReactWorkTagsMode (copy), updateContextProvider (copy), ContextConsumer (copy), MemoComponent (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), getComponentName (copy), updateMemoComponent (copy), SimpleMemoComponent (copy), updateSimpleMemoComponent (ref), IncompleteClassComponent (copy), updateOffscreenComponent (copy), invariant (copy)
	local lanes = p142.lanes

	if __DEV__ and (p142._debugNeedsRemount and p141 ~= nil) then
		return remountFiber(p141, p142, createFiberFromTypeAndProps(p142.type, p142.key, p142.pendingProps, p142._debugOwner or nil, p142.mode, p142.lanes))
	end

	if p141 ~= nil then
		if p141.memoizedProps ~= p142.pendingProps or hasContextChanged() or __DEV__ and p142.type ~= p141.type then
			u161 = true
		else
			if not ReactFiberLane.includesSomeLane(p143, lanes) then
				u161 = false

				if p142.tag == HostRoot then
					local stateNode = p142.stateNode

					if stateNode.pendingContext then
						pushTopLevelContextObject(p142, stateNode.pendingContext, stateNode.pendingContext ~= stateNode.context)
					elseif stateNode.context then
						pushTopLevelContextObject(p142, stateNode.context, false)
					end

					pushHostContainer(p142, stateNode.containerInfo)
					resetHydrationState()
				elseif p142.tag == HostComponent then
					pushHostContext(p142)
				elseif p142.tag == ClassComponent then
					local type6 = p142.type

					if isContextProvider(type6) then
						pushContextProvider(p142)
					end
				elseif p142.tag == HostPortal then
					pushHostContainer(p142, p142.stateNode.containerInfo)
				elseif p142.tag == ContextProvider then
					local value = p142.memoizedProps.value

					pushProvider(p142, value)
				elseif p142.tag == Profiler then
					if enableProfilerTimer then
						local stateNode = p142.stateNode

						stateNode.effectDuration = 0
						stateNode.passiveEffectDuration = 0
					end
				elseif p142.tag == SuspenseComponent then
					local memoizedState = p142.memoizedState

					if memoizedState ~= nil then
						if enableSuspenseServerRenderer and memoizedState.dehydrated ~= nil then
							pushSuspenseContext(p142, setDefaultShallowSuspenseContext(suspenseStackCursor.current))
							p142.flags = bit32.bor(p142.flags, DidCapture)

							return nil
						end

						local childLanes = p142.child.childLanes

						if ReactFiberLane.includesSomeLane(p143, childLanes) then
							return updateSuspenseComponent(p141, p142, p143)
						end

						pushSuspenseContext(p142, setDefaultShallowSuspenseContext(suspenseStackCursor.current))

						local v540 = bailoutOnAlreadyFinishedWork(p141, p142, p143)

						if v540 ~= nil then
							return v540.sibling
						end

						return nil
					end

					pushSuspenseContext(p142, setDefaultShallowSuspenseContext(suspenseStackCursor.current))
				elseif p142.tag == SuspenseListComponent then
					print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					print("UNIMPLEMENTED ERROR: " .. tostring("beginWork: SuspenseListComponent"))
					error("FIXME (roblox): beginWork: SuspenseListComponent is unimplemented", 2)
				elseif p142.tag == OffscreenComponent or p142.tag == LegacyHiddenComponent then
					p142.lanes = ReactFiberLane.NoLanes

					return (updateOffscreenComponent(p141, p142, p143))
				end

				return bailoutOnAlreadyFinishedWork(p141, p142, p143)
			end

			if bit32.band(p141.flags, ForceUpdateForLegacySuspense) ~= NoFlags then
				u161 = true
			else
				u161 = false
			end
		end
	else
		u161 = false
	end

	p142.lanes = ReactFiberLane.NoLanes

	if p142.tag == ReactWorkTags.IndeterminateComponent then
		return mountIndeterminateComponent(p141, p142, p142.type, p143)
	end

	if p142.tag == LazyComponent then
		local elementType = p142.elementType

		return (mountLazyComponent(p141, p142, elementType, lanes, p143))
	end

	if p142.tag == FunctionComponent then
		local type7 = p142.type
		local pendingProps = p142.pendingProps
		local v544 = if type7 ~= p142.elementType then resolveDefaultProps(type7, pendingProps) else pendingProps

		return updateFunctionComponent(p141, p142, type7, v544, p143)
	end

	if p142.tag == ClassComponent then
		local type8 = p142.type
		local pendingProps = p142.pendingProps
		local v547 = type8 == p142.elementType and pendingProps or resolveDefaultProps(type8, pendingProps)

		return (updateClassComponent(p141, p142, type8, v547, p143))
	end

	if p142.tag == HostRoot then
		return updateHostRoot(p141, p142, p143)
	end

	if p142.tag == HostComponent then
		return (updateHostComponent(p141, p142, p143))
	end

	if p142.tag == HostText then
		if p141 == nil then
			tryToClaimNextHydratableInstance(p142)
		end

		return nil
	end

	if p142.tag == SuspenseComponent then
		return updateSuspenseComponent(p141, p142, p143)
	end

	if p142.tag == HostPortal then
		return updatePortalComponent(p141, p142, p143)
	end

	if p142.tag == ForwardRef then
		local type9 = p142.type
		local pendingProps = p142.pendingProps

		if type9 ~= p142.elementType then
			pendingProps = resolveDefaultProps(type9, pendingProps)
		end

		return updateForwardRef(p141, p142, type9, pendingProps, p143)
	end

	if p142.tag == Fragment then
		return updateFragment(p141, p142, p143)
	end

	if p142.tag == ReactWorkTagsMode then
		return updateMode(p141, p142, p143)
	end

	if p142.tag == Profiler then
		return updateProfiler(p141, p142, p143)
	end

	if p142.tag == ContextProvider then
		return updateContextProvider(p141, p142, p143)
	end

	if p142.tag == ContextConsumer then
		return updateContextConsumer(p141, p142, p143)
	end

	if p142.tag == MemoComponent then
		local type10 = p142.type
		local pendingProps = p142.pendingProps
		local v552 = resolveDefaultProps(type10, pendingProps)

		if (__DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__) and p142.type ~= p142.elementType then
			local propTypes = nil
			local validateProps = nil

			if type(type10) == "table" then
				propTypes = type10.propTypes
				validateProps = type10.validateProps
			end

			if propTypes or validateProps then
				checkPropTypes(propTypes, validateProps, v552, "prop", getComponentName(type10))
			end
		end

		local v555 = resolveDefaultProps(type10.type, v552)

		return updateMemoComponent(p141, p142, type10, v555, lanes, p143)
	end

	if p142.tag == SimpleMemoComponent then
		return updateSimpleMemoComponent(p141, p142, p142.type, p142.pendingProps, lanes, p143)
	end

	if p142.tag == IncompleteClassComponent then
		local type11 = p142.type
		local pendingProps = p142.pendingProps
		local v558 = type11 == p142.elementType and pendingProps or resolveDefaultProps(type11, pendingProps)

		return mountIncompleteClassComponent(p141, p142, type11, v558, p143)
	end

	if p142.tag == OffscreenComponent then
		return (updateOffscreenComponent(p141, p142, p143))
	end

	if p142.tag == LegacyHiddenComponent then
		return (updateOffscreenComponent(p141, p142, p143))
	end

	invariant(false, "Unknown unit of work tag (%s). This error is likely caused by a bug in React. Please file an issue.", (tostring(p142.tag)))

	return nil
end

return t2
