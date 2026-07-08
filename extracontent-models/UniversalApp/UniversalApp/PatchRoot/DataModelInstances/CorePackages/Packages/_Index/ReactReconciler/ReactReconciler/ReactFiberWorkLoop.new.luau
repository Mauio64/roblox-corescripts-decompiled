local ReactGlobals, console, Set, __DEV__, __YOLO__, t1, ReactFiberLane, Scheduler, ReactFeatureFlags, enableDebugTracing, enableSchedulingProfiler, skipUnmountedBoundaries, enableDoubleInvokingEffects, deletedTreeCleanUpLevel, enableNewTreeCleanupPath, describeError, invariant, scheduleCallback, getCurrentPriorityLevel, runWithPriority, shouldYield, requestPaint, now, NoPriority, ImmediatePriority, UserBlockingPriority, NormalPriority, flushSyncCallbackQueue, DebugTracing, SchedulingProfiler, __interactionsRef, __subscriberRef, ReactFiberHostConfig, lib, ReactTypeOfMode, ReactWorkTags, LegacyRoot, ReactFiberFlags, SyncLane, NoTimestamp, includesSomeLane, isSubsetOfLanes, mergeLanes, removeLanes, hasDiscreteLanes, includesNonIdleWork, includesOnlyRetries, includesOnlyTransitions, getNextLanes, setCurrentUpdateLanePriority, getCurrentUpdateLanePriority, getLanesToRetrySynchronouslyOnError, markRootUpdated, markRootPinged, markRootExpired, markDiscreteUpdatesExpired, markRootFinished, schedulerPriorityToLanePriority, unwindWork, unwindInterruptedWork, throwException, createRootErrorUpdate, createClassErrorUpdate, lib2, commitBeforeMutationLifeCycles, commitPlacement, commitWork, commitDeletion, commitPassiveUnmount, commitPassiveUnmountInsideDeletedTree, commitPassiveMount, commitDetachRef, invokeLayoutEffectMountInDEV, invokePassiveEffectMountInDEV, invokeLayoutEffectUnmountInDEV, invokePassiveEffectUnmountInDEV, recursivelyCommitLayoutEffects, Promise, enqueueUpdate, resetContextDependencies, RobloxReactProfiling, u101, t2, v103, u104, createCapturedValue, push, pop, lib3, getComponentName, lib4, ReactCurrentFiber, current, resetCurrentFiber, setCurrentFiber, invokeGuardedCallback, hasCaughtError, clearCaughtError, onCommitRoot, onCommitRoot2, enqueueTask, doesFiberContain, ReactCurrentDispatcher, ReactCurrentOwner, IsSomeRendererActing, u128, t3, n1, u132, u133, NoLanes, v135, n2, u137, NoLanes2, ReactFiberWorkInProgress, workInProgressRootSkippedLanes, NoLanes3, NoLanes4, u143, n3, n4, u146, u148, u149, u150, u151, u152, u153, NoLanes5, u155, n5, u157, n6, u159, u160, NoLanes6, NoLanes7, u163, u164

do
	local ParentParent = script.Parent.Parent

	ReactGlobals = require(ParentParent.ReactGlobals)
	console = require(ParentParent.Shared).console
	Set = require(ParentParent.LuauPolyfill).Set
	__DEV__ = ReactGlobals.__DEV__
	__YOLO__ = ReactGlobals.__YOLO__
	t1 = {}
	require(ParentParent.Shared)
	require(script.Parent.ReactInternalTypes)
	ReactFiberLane = require(script.Parent.ReactFiberLane)
	Scheduler = require(ParentParent.Scheduler)
	require(script.Parent["ReactFiberSuspenseComponent.new"])

	local ReactSharedInternals, cancelCallback, scheduleSyncCallback, SyncBatchedLane, findUpdateLane, findTransitionLane, findRetryLane, pickArbitraryLane, returnNextLanesPriority, markStarvedLanesAsExpired, lanePriorityToSchedulerPriority, ReactFiberTransition, createCursor

	do
		local lib5 = require(script.Parent["ReactFiberStack.new"])

		ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
		enableDebugTracing = ReactFeatureFlags.enableDebugTracing
		enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
		skipUnmountedBoundaries = ReactFeatureFlags.skipUnmountedBoundaries
		enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
		deletedTreeCleanUpLevel = ReactFeatureFlags.deletedTreeCleanUpLevel
		enableNewTreeCleanupPath = ReactFeatureFlags.enableNewTreeCleanupPath

		do
			local Shared = require(ParentParent.Shared)

			describeError = require(ParentParent.Shared).describeError
			ReactSharedInternals = Shared.ReactSharedInternals
			invariant = Shared.invariant
		end

		do
			local lib6 = require(script.Parent["SchedulerWithReactIntegration.new"])

			scheduleCallback = lib6.scheduleCallback
			cancelCallback = lib6.cancelCallback
			getCurrentPriorityLevel = lib6.getCurrentPriorityLevel
			runWithPriority = lib6.runWithPriority
			shouldYield = lib6.shouldYield
			requestPaint = lib6.requestPaint
			now = lib6.now
			NoPriority = lib6.NoPriority
			ImmediatePriority = lib6.ImmediatePriority
			UserBlockingPriority = lib6.UserBlockingPriority
			NormalPriority = lib6.NormalPriority
			flushSyncCallbackQueue = lib6.flushSyncCallbackQueue
			scheduleSyncCallback = lib6.scheduleSyncCallback
		end

		DebugTracing = require(script.Parent.DebugTracing)
		SchedulingProfiler = require(script.Parent.SchedulingProfiler)

		do
			local tracing = require(ParentParent.Scheduler).tracing

			__interactionsRef = tracing.__interactionsRef
			__subscriberRef = tracing.__subscriberRef
		end

		ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
		lib = require(script.Parent["ReactFiber.new"])
		ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
		ReactWorkTags = require(script.Parent.ReactWorkTags)
		LegacyRoot = require(script.Parent.ReactRootTags).LegacyRoot
		ReactFiberFlags = require(script.Parent.ReactFiberFlags)
		SyncLane = ReactFiberLane.SyncLane
		SyncBatchedLane = ReactFiberLane.SyncBatchedLane
		NoTimestamp = ReactFiberLane.NoTimestamp
		findUpdateLane = ReactFiberLane.findUpdateLane
		findTransitionLane = ReactFiberLane.findTransitionLane
		findRetryLane = ReactFiberLane.findRetryLane
		includesSomeLane = ReactFiberLane.includesSomeLane
		isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
		mergeLanes = ReactFiberLane.mergeLanes
		removeLanes = ReactFiberLane.removeLanes
		pickArbitraryLane = ReactFiberLane.pickArbitraryLane
		hasDiscreteLanes = ReactFiberLane.hasDiscreteLanes
		includesNonIdleWork = ReactFiberLane.includesNonIdleWork
		includesOnlyRetries = ReactFiberLane.includesOnlyRetries
		includesOnlyTransitions = ReactFiberLane.includesOnlyTransitions
		getNextLanes = ReactFiberLane.getNextLanes
		returnNextLanesPriority = ReactFiberLane.returnNextLanesPriority
		setCurrentUpdateLanePriority = ReactFiberLane.setCurrentUpdateLanePriority
		getCurrentUpdateLanePriority = ReactFiberLane.getCurrentUpdateLanePriority
		markStarvedLanesAsExpired = ReactFiberLane.markStarvedLanesAsExpired
		getLanesToRetrySynchronouslyOnError = ReactFiberLane.getLanesToRetrySynchronouslyOnError
		markRootUpdated = ReactFiberLane.markRootUpdated
		markRootPinged = ReactFiberLane.markRootPinged
		markRootExpired = ReactFiberLane.markRootExpired
		markDiscreteUpdatesExpired = ReactFiberLane.markDiscreteUpdatesExpired
		markRootFinished = ReactFiberLane.markRootFinished
		schedulerPriorityToLanePriority = ReactFiberLane.schedulerPriorityToLanePriority
		lanePriorityToSchedulerPriority = ReactFiberLane.lanePriorityToSchedulerPriority
		ReactFiberTransition = require(script.Parent.ReactFiberTransition)

		do
			local lib7 = require(script.Parent["ReactFiberUnwindWork.new"])

			unwindWork = lib7.unwindWork
			unwindInterruptedWork = lib7.unwindInterruptedWork
		end

		do
			local lib8 = require(script.Parent["ReactFiberThrow.new"])

			throwException = lib8.throwException
			createRootErrorUpdate = lib8.createRootErrorUpdate
			createClassErrorUpdate = lib8.createClassErrorUpdate
		end

		lib2 = require(script.Parent["ReactFiberCommitWork.new"])
		commitBeforeMutationLifeCycles = lib2.commitBeforeMutationLifeCycles
		commitPlacement = lib2.commitPlacement
		commitWork = lib2.commitWork
		commitDeletion = lib2.commitDeletion
		commitPassiveUnmount = lib2.commitPassiveUnmount
		commitPassiveUnmountInsideDeletedTree = lib2.commitPassiveUnmountInsideDeletedTree
		commitPassiveMount = lib2.commitPassiveMount
		commitDetachRef = lib2.commitDetachRef
		invokeLayoutEffectMountInDEV = lib2.invokeLayoutEffectMountInDEV
		invokePassiveEffectMountInDEV = lib2.invokePassiveEffectMountInDEV
		invokeLayoutEffectUnmountInDEV = lib2.invokeLayoutEffectUnmountInDEV
		invokePassiveEffectUnmountInDEV = lib2.invokePassiveEffectUnmountInDEV
		recursivelyCommitLayoutEffects = lib2.recursivelyCommitLayoutEffects
		Promise = require(ParentParent.Promise)
		enqueueUpdate = require(script.Parent["ReactUpdateQueue.new"]).enqueueUpdate
		resetContextDependencies = require(script.Parent["ReactFiberNewContext.new"]).resetContextDependencies
		RobloxReactProfiling = require(script.Parent.RobloxReactProfiling)
		u101 = nil
		t2 = {
			resetHooksAfterThrowRef = nil,
			ContextOnlyDispatcherRef = nil,
			getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = nil,
			originalBeginWorkRef = nil,
			completeWorkRef = nil
		}

		function v103(p1, p2, p3) -- line: 246
			-- upvalues: t2 (copy)
			if not t2.originalBeginWorkRef then
				t2.originalBeginWorkRef = require(script.Parent["ReactFiberBeginWork.new"]).beginWork
			end

			return t2.originalBeginWorkRef(p1, p2, p3)
		end

		u104 = nil

		do
			local function initReactFiberHooks() -- line: 272
				-- upvalues: u104 (ref), t2 (copy)
				u104 = require(script.Parent["ReactFiberHooks.new"])
				t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
				t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
				t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
			end
		end

		createCapturedValue = require(script.Parent.ReactCapturedValue).createCapturedValue
		push = lib5.push
		pop = lib5.pop
		createCursor = lib5.createCursor
		lib3 = require(script.Parent["ReactProfilerTimer.new"])
		getComponentName = require(ParentParent.Shared).getComponentName
		lib4 = require(script.Parent["ReactStrictModeWarnings.new"])
		ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)
		current = ReactCurrentFiber.current
		resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
		setCurrentFiber = ReactCurrentFiber.setCurrentFiber

		local ReactErrorUtils = require(ParentParent.Shared).ReactErrorUtils

		invokeGuardedCallback = ReactErrorUtils.invokeGuardedCallback
		hasCaughtError = ReactErrorUtils.hasCaughtError
		clearCaughtError = ReactErrorUtils.clearCaughtError
	end

	onCommitRoot = require(script.Parent["ReactFiberDevToolsHook.new"]).onCommitRoot
	onCommitRoot2 = require(script.Parent.ReactTestSelectors).onCommitRoot
	enqueueTask = require(ParentParent.Shared).enqueueTask
	doesFiberContain = require(script.Parent.ReactFiberTreeReflection).doesFiberContain
	ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
	ReactCurrentOwner = ReactSharedInternals.ReactCurrentOwner
	IsSomeRendererActing = ReactSharedInternals.IsSomeRendererActing
	u128 = nil
	t3 = {}
	t1.NoContext = 0
	t1.RetryAfterError = 64

	local _ = {
		Incomplete = 0,
		FatalErrored = 1,
		Errored = 2,
		Suspended = 3,
		SuspendedWithDelay = 4,
		Completed = 5
	}

	n1 = 0
	u132 = nil
	u133 = nil
	NoLanes = ReactFiberLane.NoLanes
	t1.subtreeRenderLanes = ReactFiberLane.NoLanes
	v135 = createCursor(ReactFiberLane.NoLanes)
	n2 = 0
	u137 = nil
	NoLanes2 = ReactFiberLane.NoLanes
	ReactFiberWorkInProgress = require(script.Parent.ReactFiberWorkInProgress)
	workInProgressRootSkippedLanes = ReactFiberWorkInProgress.workInProgressRootSkippedLanes
	NoLanes3 = ReactFiberLane.NoLanes
	NoLanes4 = ReactFiberLane.NoLanes
	u143 = nil
	n3 = 0
	n4 = 1e999
	u146 = nil

	local function resetRenderTimer() -- line: 433
		-- upvalues: n4 (ref), now (copy)
		n4 = now() + 500
	end

	function t1.getRenderTargetTime() -- line: 437
		-- upvalues: n4 (ref)
		return n4
	end

	u148 = false
	u149 = nil
	u150 = nil
	u151 = false
	u152 = nil
	u153 = NoPriority
	NoLanes5 = ReactFiberLane.NoLanes
	u155 = nil
	n5 = 0
	u157 = nil
	n6 = 0
	u159 = nil
	u160 = NoTimestamp
	NoLanes6 = ReactFiberLane.NoLanes
	NoLanes7 = ReactFiberLane.NoLanes
	u163 = nil
	u164 = false

	function t1.getWorkInProgressRoot() -- line: 477
		-- upvalues: u132 (ref)
		return u132
	end
	function t1.requestEventTime() -- line: 481
		-- upvalues: n1 (ref), now (copy), u160 (ref), NoTimestamp (copy)
		if bit32.band(n1, 48) ~= 0 then
			return now()
		end

		if u160 ~= NoTimestamp then
			return u160
		end

		u160 = now()

		return u160
	end
	function t1.requestUpdateLane(p4) -- line: 503
		-- upvalues: ReactTypeOfMode (copy), SyncLane (copy), getCurrentPriorityLevel (copy), ImmediatePriority (copy), SyncBatchedLane (copy), ReactFeatureFlags (copy), n1 (ref), NoLanes (ref), ReactFiberLane (copy), pickArbitraryLane (copy), NoLanes6 (ref), NoLanes2 (ref), ReactFiberTransition (copy), NoLanes7 (ref), u143 (ref), findTransitionLane (copy), UserBlockingPriority (copy), findUpdateLane (copy), schedulerPriorityToLanePriority (copy), getCurrentUpdateLanePriority (copy), __DEV__ (copy), console (copy)
		local mode = p4.mode

		if bit32.band(mode, ReactTypeOfMode.BlockingMode) == ReactTypeOfMode.NoMode then
			return SyncLane
		end

		if bit32.band(mode, ReactTypeOfMode.ConcurrentMode) == ReactTypeOfMode.NoMode then
			if getCurrentPriorityLevel() == ImmediatePriority then
				return SyncLane
			end

			return SyncBatchedLane
		end

		if not ReactFeatureFlags.deferRenderPhaseUpdateToNextBatch and bit32.band(n1, 16) ~= 0 and NoLanes ~= ReactFiberLane.NoLanes then
			return pickArbitraryLane(NoLanes)
		end

		if NoLanes6 == ReactFiberLane.NoLanes then
			NoLanes6 = NoLanes2
		end

		if ReactFiberTransition.requestCurrentTransition() ~= ReactFiberTransition.NoTransition then
			if NoLanes7 ~= ReactFiberLane.NoLanes then
				if u143 ~= nil then
					NoLanes7 = u143.pendingLanes
				else
					NoLanes7 = ReactFiberLane.NoLanes
				end
			end

			return findTransitionLane(NoLanes6, NoLanes7)
		end

		local v189 = getCurrentPriorityLevel()

		if bit32.band(n1, 4) ~= 0 and v189 == UserBlockingPriority then
			return (findUpdateLane(ReactFiberLane.InputDiscreteLanePriority, NoLanes6))
		end

		local v190 = schedulerPriorityToLanePriority(v189)

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
			local v191 = getCurrentUpdateLanePriority()

			if v190 ~= v191 and v191 ~= ReactFiberLane.NoLanePriority and __DEV__ then
				console.error("Expected current scheduler lane priority %s to match current update lane priority %s", tostring(v190), (tostring(v191)))
			end
		end

		return (findUpdateLane(v190, NoLanes6))
	end
	function requestRetryLane(p5) -- line: 607
		-- upvalues: ReactTypeOfMode (copy), SyncLane (copy), getCurrentPriorityLevel (copy), ImmediatePriority (copy), SyncBatchedLane (copy), NoLanes6 (ref), ReactFiberLane (copy), NoLanes2 (ref), findRetryLane (copy)
		local mode = p5.mode

		if bit32.band(mode, ReactTypeOfMode.BlockingMode) == ReactTypeOfMode.NoMode then
			return SyncLane
		end

		if bit32.band(mode, ReactTypeOfMode.ConcurrentMode) == ReactTypeOfMode.NoMode then
			if getCurrentPriorityLevel() == ImmediatePriority then
				return SyncLane
			end

			return SyncBatchedLane
		end

		if NoLanes6 == ReactFiberLane.NoLanes then
			NoLanes6 = NoLanes2
		end

		return findRetryLane(NoLanes6)
	end
	function t1.scheduleUpdateOnFiber(p6, p7, n7: number) -- line: 629
		-- upvalues: t3 (copy), markRootUpdated (copy), u132 (ref), ReactFeatureFlags (copy), n1 (ref), NoLanes3 (ref), mergeLanes (copy), n2 (ref), NoLanes (ref), getCurrentPriorityLevel (copy), SyncLane (copy), u101 (ref), n4 (ref), now (copy), flushSyncCallbackQueue (copy), UserBlockingPriority (copy), ImmediatePriority (copy), u155 (ref), Set (copy), u143 (ref)
		t3.checkForNestedUpdates()

		local v197 = t3.markUpdateLaneFromFiberToRoot(p6, p7)

		if v197 == nil then
			return nil
		end

		markRootUpdated(v197, p7, n7)

		if v197 == u132 then
			t3.warnAboutRenderPhaseUpdatesInDEV(p6)

			if ReactFeatureFlags.deferRenderPhaseUpdateToNextBatch or bit32.band(n1, 16) == 0 then
				NoLanes3 = mergeLanes(NoLanes3, p7)
			end

			if n2 == 4 then
				t3.markRootSuspended(v197, NoLanes)
			end
		end

		local v198 = getCurrentPriorityLevel()

		if p7 == SyncLane then
			if bit32.band(n1, 8) ~= 0 and bit32.band(n1, 48) == 0 then
				t3.schedulePendingInteractions(v197, p7)
				t3.performSyncWorkOnRoot(v197)
			else
				u101(v197, n7)
				t3.schedulePendingInteractions(v197, p7)

				if n1 == 0 then
					n4 = now() + 500
					flushSyncCallbackQueue()
				end
			end
		else
			if bit32.band(n1, 4) ~= 0 and (v198 == UserBlockingPriority or v198 == ImmediatePriority) then
				if u155 == nil then
					u155 = Set.new({ v197 })
				else
					u155:add(v197)
				end
			end

			u101(v197, n7)
			t3.schedulePendingInteractions(v197, p7)
		end

		u143 = v197

		return v197
	end
	function t3.markUpdateLaneFromFiberToRoot(p8, p9) -- line: 739
		-- upvalues: mergeLanes (copy), __DEV__ (copy), ReactFiberFlags (copy), t3 (copy), ReactWorkTags (copy)
		p8.lanes = mergeLanes(p8.lanes, p9)

		local alternate = p8.alternate

		if alternate ~= nil then
			alternate.lanes = mergeLanes(alternate.lanes, p9)
		end

		if __DEV__ and alternate == nil and bit32.band(p8.flags, (bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Hydrating))) ~= ReactFiberFlags.NoFlags then
			t3.warnAboutUpdateOnNotYetMountedFiberInDEV(p8)
		end

		local v202 = p8
		local return_ = p8.return_

		while return_ ~= nil do
			return_.childLanes = mergeLanes(return_.childLanes, p9)

			local alternate2 = return_.alternate

			if alternate2 ~= nil then
				alternate2.childLanes = mergeLanes(alternate2.childLanes, p9)
			elseif __DEV__ and bit32.band(return_.flags, (bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Hydrating))) ~= ReactFiberFlags.NoFlags then
				t3.warnAboutUpdateOnNotYetMountedFiberInDEV(p8)
			end

			v202 = return_
			return_ = return_.return_
		end

		if v202.tag == ReactWorkTags.HostRoot then
			return v202.stateNode
		end

		return nil
	end
	function u101(p10, n8: number) -- line: 794
		-- upvalues: markStarvedLanesAsExpired (copy), u132 (ref), NoLanes (ref), ReactFiberLane (copy), getNextLanes (copy), returnNextLanesPriority (copy), cancelCallback (copy), scheduleSyncCallback (copy), RobloxReactProfiling (copy), t3 (copy), scheduleCallback (copy), ImmediatePriority (copy), lanePriorityToSchedulerPriority (copy)
		local callbackNode = p10.callbackNode

		markStarvedLanesAsExpired(p10, n8)

		local v208 = if p10 ~= u132 then ReactFiberLane.NoLanes else NoLanes
		local v209 = getNextLanes(p10, v208)
		local v210 = returnNextLanesPriority()

		if v209 == ReactFiberLane.NoLanes then
			if callbackNode ~= nil then
				cancelCallback(callbackNode)
				p10.callbackNode = nil
				p10.callbackPriority = ReactFiberLane.NoLanePriority
			end

			return
		end

		if callbackNode ~= nil then
			if v210 == p10.callbackPriority then
				return
			end

			cancelCallback(callbackNode)
		end

		local v211

		if v210 == ReactFiberLane.SyncLanePriority then
			v211 = scheduleSyncCallback(function() -- line: 839
				-- upvalues: RobloxReactProfiling (copy), p10 (copy), t3 (copy)
				local v533 = RobloxReactProfiling.profileRootBeforeUnitOfWork(p10)
				local v534 = t3.performSyncWorkOnRoot(p10)

				RobloxReactProfiling.profileRootAfterYielding(v533)

				return v534
			end)
		elseif v210 == ReactFiberLane.SyncBatchedLanePriority then
			v211 = scheduleCallback(ImmediatePriority, function() -- line: 847
				-- upvalues: RobloxReactProfiling (copy), p10 (copy), t3 (copy)
				local v535 = RobloxReactProfiling.profileRootBeforeUnitOfWork(p10)
				local v536 = t3.performSyncWorkOnRoot(p10)

				RobloxReactProfiling.profileRootAfterYielding(v535)

				return v536
			end)
		else
			local v212 = lanePriorityToSchedulerPriority(v210)

			v211 = scheduleCallback(v212, function() -- line: 857
				-- upvalues: RobloxReactProfiling (copy), p10 (copy), t3 (copy)
				local v537 = RobloxReactProfiling.profileRootBeforeUnitOfWork(p10)
				local v538 = t3.performConcurrentWorkOnRoot(p10)

				RobloxReactProfiling.profileRootAfterYielding(v537)

				return v538
			end)
		end

		p10.callbackPriority = v210
		p10.callbackNode = v211
	end
end

function t3.performConcurrentWorkOnRoot(p11) -- line: 873
	-- upvalues: u160 (ref), NoTimestamp (copy), NoLanes6 (ref), ReactFiberLane (copy), NoLanes7 (ref), invariant (copy), n1 (ref), t1 (copy), getNextLanes (copy), u132 (ref), NoLanes (ref), t3 (copy), includesSomeLane (copy), NoLanes2 (ref), NoLanes3 (ref), ReactFiberHostConfig (copy), getLanesToRetrySynchronouslyOnError (copy), u137 (ref), u101 (ref), now (copy), RobloxReactProfiling (copy)
	u160 = NoTimestamp
	NoLanes6 = ReactFiberLane.NoLanes
	NoLanes7 = ReactFiberLane.NoLanes
	invariant(bit32.band(n1, 48) == 0, "Should not already be working.")

	local callbackNode = p11.callbackNode

	if t1.flushPassiveEffects() and callbackNode ~= p11.callbackNode then
		return nil
	end

	local v215 = getNextLanes(p11, if p11 ~= u132 then ReactFiberLane.NoLanes else NoLanes)

	if v215 == ReactFiberLane.NoLanes then
		return nil
	end

	local v216 = t3.renderRootConcurrent(p11, v215)

	if includesSomeLane(NoLanes2, NoLanes3) then
		t3.prepareFreshStack(p11, ReactFiberLane.NoLanes)
	elseif v216 ~= 0 then
		if v216 == 2 then
			n1 = bit32.bor(n1, 64)

			if p11.hydrate then
				p11.hydrate = false
				ReactFiberHostConfig.clearContainer(p11.containerInfo)
			end

			v215 = getLanesToRetrySynchronouslyOnError(p11)

			if v215 ~= ReactFiberLane.NoLanes then
				v216 = t3.renderRootSync(p11, v215)
			end
		end

		if v216 == 1 then
			local v217 = u137

			t3.prepareFreshStack(p11, ReactFiberLane.NoLanes)
			t3.markRootSuspended(p11, v215)
			u101(p11, now())
			error(v217)
		end

		p11.finishedWork = p11.current.alternate
		p11.finishedLanes = v215
		t3.finishConcurrentRender(p11, v216, v215)
	end

	u101(p11, now())

	if callbackNode == p11.callbackNode then
		return function() -- line: 968
			-- upvalues: RobloxReactProfiling (copy), p11 (copy), t3 (copy)
			local v539 = RobloxReactProfiling.profileRootBeforeUnitOfWork(p11)
			local v540 = t3.performConcurrentWorkOnRoot(p11)

			RobloxReactProfiling.profileRootAfterYielding(v539)

			return v540
		end
	end

	return nil
end

local n9 = 0
local u166 = false

function shouldForceFlushFallbacksInDEV() -- line: 985
	-- upvalues: __DEV__ (copy), n9 (ref)
	return __DEV__ and n9 > 0
end
function t3.finishConcurrentRender(p12, p13, p14) -- line: 990
	-- upvalues: invariant (copy), t3 (copy), includesOnlyRetries (copy), n3 (ref), now (copy), getNextLanes (copy), ReactFiberLane (copy), isSubsetOfLanes (copy), t1 (copy), markRootPinged (copy), ReactFiberHostConfig (copy), includesOnlyTransitions (copy)
	if p13 == 0 or p13 == 1 then
		invariant(false, "Root did not complete. This is a bug in React.")

		return
	end

	if p13 == 2 then
		t3.commitRoot(p12)

		return
	end

	if p13 == 3 then
		t3.markRootSuspended(p12, p14)

		if includesOnlyRetries(p14) and not shouldForceFlushFallbacksInDEV() then
			local v221 = n3 + 500 - now()

			if v221 > 10 then
				if getNextLanes(p12, ReactFiberLane.NoLanes) ~= ReactFiberLane.NoLanes then
					return
				end

				local suspendedLanes = p12.suspendedLanes

				if not isSubsetOfLanes(suspendedLanes, p14) then
					local v223 = t1.requestEventTime()

					markRootPinged(p12, suspendedLanes, v223)

					return
				end

				p12.timeoutHandle = ReactFiberHostConfig.scheduleTimeout(function() -- line: 1039
					-- upvalues: t3 (copy), p12 (copy)
					return t3.commitRoot(p12)
				end, v221)

				return
			end
		end

		t3.commitRoot(p12)

		return
	end

	if p13 == 4 then
		t3.markRootSuspended(p12, p14)

		if includesOnlyTransitions(p14) then
			return
		end

		if not shouldForceFlushFallbacksInDEV() then
			local v224 = ReactFiberLane.getMostRecentEventTime(p12, p14)
			local v225 = now() - v224
			local v226 = jnd(v225) - v225

			if v226 > 10 then
				p12.timeoutHandle = ReactFiberHostConfig.scheduleTimeout(function() -- line: 1074
					-- upvalues: t3 (copy), p12 (copy)
					return t3.commitRoot(p12)
				end, v226)

				return
			end
		end

		t3.commitRoot(p12)

		return
	end

	if p13 == 5 then
		t3.commitRoot(p12)

		return
	end

	invariant(false, "Unknown root exit status.")
end
function t3.markRootSuspended(p15, p16) -- line: 1090
	-- upvalues: removeLanes (copy), NoLanes4 (ref), NoLanes3 (ref), ReactFiberLane (copy)
	local v229 = removeLanes(p16, NoLanes4)
	local v230 = removeLanes(v229, NoLanes3)

	ReactFiberLane.markRootSuspended(p15, v230)
end
function t3.performSyncWorkOnRoot(p17) -- line: 1102
	-- upvalues: invariant (copy), n1 (ref), t1 (copy), u132 (ref), includesSomeLane (copy), NoLanes (ref), t3 (copy), NoLanes2 (ref), NoLanes3 (ref), getNextLanes (copy), ReactFiberLane (copy), LegacyRoot (copy), ReactFiberHostConfig (copy), getLanesToRetrySynchronouslyOnError (copy), u137 (ref), u101 (ref), now (copy)
	invariant(bit32.band(n1, 48) == 0, "Should not already be working.")
	t1.flushPassiveEffects()

	local v232, v233

	if p17 == u132 and includesSomeLane(p17.expiredLanes, NoLanes) then
		v232 = NoLanes
		v233 = t3.renderRootSync(p17, v232)

		if includesSomeLane(NoLanes2, NoLanes3) then
			v232 = getNextLanes(p17, v232)
			v233 = t3.renderRootSync(p17, v232)
		end
	else
		v232 = getNextLanes(p17, ReactFiberLane.NoLanes)
		v233 = t3.renderRootSync(p17, v232)
	end

	if p17.tag ~= LegacyRoot and v233 == 2 then
		n1 = bit32.bor(n1, 64)

		if p17.hydrate then
			p17.hydrate = false
			ReactFiberHostConfig.clearContainer(p17.containerInfo)
		end

		v232 = getLanesToRetrySynchronouslyOnError(p17)

		if v232 ~= ReactFiberLane.NoLanes then
			v233 = t3.renderRootSync(p17, v232)
		end
	end

	if v233 == 1 then
		local v234 = u137

		t3.prepareFreshStack(p17, ReactFiberLane.NoLanes)
		t3.markRootSuspended(p17, v232)
		u101(p17, now())
		error(v234)
	end

	p17.finishedWork = p17.current.alternate
	p17.finishedLanes = v232
	t3.commitRoot(p17)
	u101(p17, now())

	return nil
end
function t1.flushRoot(p18, p19) -- line: 1184
	-- upvalues: markRootExpired (copy), u101 (ref), now (copy), n1 (ref), n4 (ref), flushSyncCallbackQueue (copy)
	markRootExpired(p18, p19)
	u101(p18, now())

	if bit32.band(n1, 48) == 0 then
		n4 = now() + 500
		flushSyncCallbackQueue()
	end
end
function t1.getExecutionContext() -- line: 1196
	-- upvalues: n1 (ref)
	return n1
end
function t1.flushDiscreteUpdates() -- line: 1200
	-- upvalues: n1 (ref), __DEV__ (copy), console (copy), t3 (copy), t1 (copy)
	if bit32.band(n1, 49) ~= 0 then
		if __DEV__ and bit32.band(n1, 16) ~= 0 then
			console.error("unstable_flushDiscreteUpdates: Cannot flush updates when React is already rendering.")
		end

		return
	end

	t3.flushPendingDiscreteUpdates()
	t1.flushPassiveEffects()
end
function t1.deferredUpdates(p20: ((...any) -> ...any)) -- line: 1230
	-- upvalues: ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), __YOLO__ (copy), setCurrentUpdateLanePriority (copy), ReactFiberLane (copy), runWithPriority (copy), describeError (copy), NormalPriority (copy)
	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local v238 = getCurrentUpdateLanePriority()
		local ok, result

		if not __YOLO__ then
			setCurrentUpdateLanePriority(ReactFiberLane.DefaultLanePriority)
			ok, result = xpcall(runWithPriority, describeError, NormalPriority, p20)
		else
			ok = true
			setCurrentUpdateLanePriority(ReactFiberLane.DefaultLanePriority)
			result = runWithPriority(NormalPriority, p20)
		end

		setCurrentUpdateLanePriority(v238)

		if ok then
			return result
		end

		error(result)

		return
	end

	return runWithPriority(NormalPriority, p20)
end
function t3.flushPendingDiscreteUpdates() -- line: 1259
	-- upvalues: u155 (ref), markDiscreteUpdatesExpired (copy), u101 (ref), now (copy), flushSyncCallbackQueue (copy)
	if u155 ~= nil then
		local v241 = u155

		u155 = nil
		v241:forEach(function(p21) -- line: 1265
			-- upvalues: markDiscreteUpdatesExpired (copy), u101 (ref), now (copy)
			markDiscreteUpdatesExpired(p21)
			u101(p21, now())
		end)
	end

	flushSyncCallbackQueue()
end
function t1.batchedUpdates(p22: ((...any) -> ...any), p23) -- line: 1274
	-- upvalues: n1 (ref), __YOLO__ (copy), describeError (copy), n4 (ref), now (copy), flushSyncCallbackQueue (copy)
	local v244 = n1

	n1 = bit32.bor(n1, 1)

	local ok, result

	if not __YOLO__ then
		ok, result = xpcall(p22, describeError, p23)
	else
		ok = true
		result = p22(p23)
	end

	n1 = v244

	if n1 == 0 then
		n4 = now() + 500
		flushSyncCallbackQueue()
	end

	if ok then
		return result
	end

	error(result)
end
function t1.batchedEventUpdates(p24: ((...any) -> ...any), p25) -- line: 1302
	-- upvalues: n1 (ref), __YOLO__ (copy), describeError (copy), n4 (ref), now (copy), flushSyncCallbackQueue (copy)
	local v249 = n1

	n1 = bit32.bor(n1, 2)

	local ok, result

	if not __YOLO__ then
		ok, result = xpcall(p24, describeError, p25)
	else
		ok = true
		result = p24(p25)
	end

	n1 = v249

	if n1 == 0 then
		n4 = now() + 500
		flushSyncCallbackQueue()
	end

	if ok then
		return result
	end

	error(result)
end
function t1.discreteUpdates(p26: ((...any) -> ...any), p27, p28, p29, p30) -- line: 1330
	-- upvalues: n1 (ref), ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), ReactFiberLane (copy), runWithPriority (copy), describeError (copy), UserBlockingPriority (copy), n4 (ref), now (copy), flushSyncCallbackQueue (copy)
	local v257 = n1

	n1 = bit32.bor(n1, 4)

	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local v258 = getCurrentUpdateLanePriority()

		setCurrentUpdateLanePriority(ReactFiberLane.InputDiscreteLanePriority)

		local ok, result = xpcall(runWithPriority, describeError, UserBlockingPriority, function() -- line: 1342
			-- upvalues: p26 (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy)
			return p26(p27, p28, p29, p30)
		end)

		setCurrentUpdateLanePriority(v258)
		n1 = v257

		if n1 == 0 then
			n4 = now() + 500
			flushSyncCallbackQueue()
		end

		if ok then
			return result
		end

		error(result)

		return
	end

	local ok, result = xpcall(runWithPriority, describeError, UserBlockingPriority, function() -- line: 1366
		-- upvalues: p26 (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy)
		return p26(p27, p28, p29, p30)
	end)

	n1 = v257

	if n1 == 0 then
		n4 = now() + 500
		flushSyncCallbackQueue()
	end

	if ok then
		return result
	end

	error(result)
end
function t1.unbatchedUpdates(p31: ((...any) -> ...any), p32) -- line: 1387
	-- upvalues: n1 (ref), __YOLO__ (copy), describeError (copy), n4 (ref), now (copy), flushSyncCallbackQueue (copy)
	local v265 = n1

	n1 = bit32.band(n1, 4294967294)
	n1 = bit32.bor(n1, 8)

	local ok, result

	if not __YOLO__ then
		ok, result = xpcall(p31, describeError, p32)
	else
		ok = true
		result = p31(p32)
	end

	n1 = v265

	if n1 == 0 then
		n4 = now() + 500
		flushSyncCallbackQueue()
	end

	if ok then
		return result
	end

	error(result)
end
function t1.flushSync(p33: ((...any) -> ...any), p34) -- line: 1415
	-- upvalues: n1 (ref), __DEV__ (copy), console (copy), ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), ReactFiberLane (copy), __YOLO__ (copy), runWithPriority (copy), describeError (copy), ImmediatePriority (copy), flushSyncCallbackQueue (copy)
	local v270 = n1

	if bit32.band(v270, 48) ~= 0 then
		if __DEV__ then
			console.error("flushSync was called from inside a lifecycle method. React cannot flush when React is already rendering. Consider moving this call to a scheduler task or micro task.")
		end

		return p33(p34)
	end

	n1 = bit32.bor(n1, 1)

	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local v271 = getCurrentUpdateLanePriority()

		setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)

		local ok, result

		if not __YOLO__ then
			if p33 then
				ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, function() -- line: 1445
					-- upvalues: p33 (copy), p34 (copy)
					return p33(p34)
				end)
			else
				ok = true
				result = nil
			end
		else
			ok = true
			setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)
			result = if not p33 then nil else runWithPriority(ImmediatePriority, function() -- line: 1458
				-- upvalues: p33 (copy), p34 (copy)
				return p33(p34)
			end)
		end

		setCurrentUpdateLanePriority(v271)
		n1 = v270
		flushSyncCallbackQueue()

		if not ok then
			error(result)
		end

		return result
	end

	local ok, result

	if not __YOLO__ then
		if p33 then
			ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, function() -- line: 1488
				-- upvalues: p33 (copy), p34 (copy)
				return p33(p34)
			end)
		else
			ok = true
			result = nil
		end
	else
		ok = true
		result = if not p33 then nil else runWithPriority(ImmediatePriority, function() -- line: 1500
			-- upvalues: p33 (copy), p34 (copy)
			return p33(p34)
		end)
	end

	n1 = v270
	flushSyncCallbackQueue()

	if not ok then
		error(result)
	end

	return result
end
function t1.flushControlled(p35: ((...any) -> ...any)) -- line: 1521
	-- upvalues: n1 (ref), ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), ReactFiberLane (copy), runWithPriority (copy), describeError (copy), ImmediatePriority (copy), n4 (ref), now (copy), flushSyncCallbackQueue (copy)
	local v277 = n1

	n1 = bit32.bor(n1, 1)

	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local v278 = getCurrentUpdateLanePriority()

		setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)

		local ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, p35)

		setCurrentUpdateLanePriority(v278)
		n1 = v277

		if n1 == 0 then
			n4 = now() + 500
			flushSyncCallbackQueue()
		end

		if not ok then
			error(result)

			return
		end
	else
		local ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, p35)

		n1 = v277

		if n1 == 0 then
			n4 = now() + 500
			flushSyncCallbackQueue()
		end

		if not ok then
			error(result)
		end
	end
end
function t1.pushRenderLanes(p36, p37) -- line: 1561
	-- upvalues: push (copy), v135 (copy), t1 (copy), mergeLanes (copy), NoLanes2 (ref)
	push(v135, t1.subtreeRenderLanes, p36)
	t1.subtreeRenderLanes = mergeLanes(t1.subtreeRenderLanes, p37)
	NoLanes2 = mergeLanes(NoLanes2, p37)
end
function t1.popRenderLanes(p38) -- line: 1567
	-- upvalues: t1 (copy), v135 (copy), pop (copy)
	t1.subtreeRenderLanes = v135.current
	pop(v135, p38)
end
function t3.prepareFreshStack(p39, p40) -- line: 1572
	-- upvalues: ReactFiberLane (copy), ReactFiberHostConfig (copy), u133 (ref), unwindInterruptedWork (copy), u132 (ref), lib (copy), NoLanes (ref), t1 (copy), NoLanes2 (ref), n2 (ref), u137 (ref), workInProgressRootSkippedLanes (copy), NoLanes3 (ref), NoLanes4 (ref), ReactFeatureFlags (copy), u159 (ref), __DEV__ (copy), lib4 (copy)
	p39.finishedWork = nil
	p39.finishedLanes = ReactFiberLane.NoLanes

	local timeoutHandle = p39.timeoutHandle

	if timeoutHandle ~= ReactFiberHostConfig.noTimeout then
		p39.timeoutHandle = ReactFiberHostConfig.noTimeout
		ReactFiberHostConfig.cancelTimeout(timeoutHandle)
	end

	if u133 ~= nil then
		local return_ = u133.return_

		while return_ ~= nil do
			unwindInterruptedWork(return_)
			return_ = return_.return_
		end
	end

	u132 = p39
	u133 = lib.createWorkInProgress(p39.current, nil)
	NoLanes = p40
	t1.subtreeRenderLanes = p40
	NoLanes2 = p40
	n2 = 0
	u137 = nil
	workInProgressRootSkippedLanes(ReactFiberLane.NoLanes)
	NoLanes3 = ReactFiberLane.NoLanes
	NoLanes4 = ReactFiberLane.NoLanes

	if ReactFeatureFlags.enableSchedulerTracing then
		u159 = nil
	end

	if __DEV__ then
		lib4.discardPendingWarnings()
	end
end
function t3.handleError(p41, p42) -- line: 1612
	-- upvalues: u133 (ref), resetContextDependencies (copy), t2 (copy), u104 (ref), resetCurrentFiber (copy), ReactCurrentOwner (copy), n2 (ref), u137 (ref), ReactFeatureFlags (copy), ReactTypeOfMode (copy), lib3 (copy), throwException (copy), NoLanes (ref), t1 (copy), t3 (copy)
	local u293 = nil

	while true do
		u293 = u133

		local ok, result = pcall(function() -- line: 1616
			-- upvalues: resetContextDependencies (copy), t2 (copy), u104 (ref), resetCurrentFiber (copy), ReactCurrentOwner (copy), u293 (ref), n2 (ref), u137 (ref), p42 (ref), u133 (ref), ReactFeatureFlags (copy), ReactTypeOfMode (copy), lib3 (copy), throwException (copy), p41 (copy), NoLanes (ref), t1 (copy), t3 (copy)
			resetContextDependencies()

			if not t2.resetHooksAfterThrowRef then
				u104 = require(script.Parent["ReactFiberHooks.new"])
				t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
				t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
				t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
			end

			t2.resetHooksAfterThrowRef()
			resetCurrentFiber()
			ReactCurrentOwner.current = nil

			if u293 == nil or u293.return_ == nil then
				n2 = 1
				u137 = p42
				u133 = nil

				return
			end

			if ReactFeatureFlags.enableProfilerTimer and bit32.band(u293.mode, ReactTypeOfMode.ProfileMode) ~= 0 then
				lib3.stopProfilerTimerIfRunningAndRecordDelta(u293, true)
			end

			throwException(p41, u293.return_, u293, p42, NoLanes, t1.onUncaughtError, t1.renderDidError)
			t3.completeUnitOfWork(u293)
		end)

		if ok then
			break
		end

		p42 = result

		if u133 == u293 and u293 ~= nil then
			u293 = u293.return_
			u133 = u293
		else
			u293 = u133
		end
	end
end
function t3.pushDispatcher() -- line: 1691
	-- upvalues: ReactCurrentDispatcher (copy), t2 (copy), u104 (ref)
	local current2 = ReactCurrentDispatcher.current
	local v297 = ReactCurrentDispatcher

	if not t2.ContextOnlyDispatcherRef then
		u104 = require(script.Parent["ReactFiberHooks.new"])
		t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
		t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
		t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
	end

	v297.current = t2.ContextOnlyDispatcherRef

	if current2 == nil then
		if not t2.ContextOnlyDispatcherRef then
			u104 = require(script.Parent["ReactFiberHooks.new"])
			t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
			t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
			t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
		end

		return t2.ContextOnlyDispatcherRef
	end

	return current2
end
function t3.popDispatcher(p43) -- line: 1708
	-- upvalues: ReactCurrentDispatcher (copy)
	ReactCurrentDispatcher.current = p43
end
function t3.pushInteractions(p44) -- line: 1712
	-- upvalues: ReactFeatureFlags (copy), __interactionsRef (copy)
	if ReactFeatureFlags.enableSchedulerTracing then
		local current3 = __interactionsRef.current

		__interactionsRef.current = p44.memoizedInteractions

		return current3
	end

	return nil
end
function t3.popInteractions(p45) -- line: 1721
	-- upvalues: ReactFeatureFlags (copy), __interactionsRef (copy)
	if ReactFeatureFlags.enableSchedulerTracing then
		__interactionsRef.current = p45
	end
end
function t1.markCommitTimeOfFallback() -- line: 1727
	-- upvalues: n3 (ref), now (copy)
	n3 = now()
end
function t1.markSkippedUpdateLanes(p46) -- line: 1731
	-- upvalues: ReactFiberWorkInProgress (copy)
	ReactFiberWorkInProgress.markSkippedUpdateLanes(p46)
end
function t1.renderDidSuspend() -- line: 1735
	-- upvalues: n2 (ref)
	if n2 == 0 then
		n2 = 3
	end
end
function t1.renderDidSuspendDelayIfPossible() -- line: 1741
	-- upvalues: n2 (ref), u132 (ref), includesNonIdleWork (copy), workInProgressRootSkippedLanes (copy), NoLanes3 (ref), t3 (copy), NoLanes (ref)
	if n2 == 0 or n2 == 3 then
		n2 = 4
	end

	if u132 ~= nil and (includesNonIdleWork(workInProgressRootSkippedLanes()) or includesNonIdleWork(NoLanes3)) then
		t3.markRootSuspended(u132, NoLanes)
	end
end
function t1.renderDidError() -- line: 1769
	-- upvalues: n2 (ref)
	if n2 ~= 5 then
		n2 = 2
	end
end
function t1.renderHasNotSuspendedYet() -- line: 1777
	-- upvalues: n2 (ref)
	return n2 == 0
end
function t3.renderRootSync(p47, p48) -- line: 1783
	-- upvalues: n1 (ref), t3 (copy), u132 (ref), NoLanes (ref), __DEV__ (copy), enableDebugTracing (copy), DebugTracing (copy), enableSchedulingProfiler (copy), SchedulingProfiler (copy), __YOLO__ (copy), describeError (copy), resetContextDependencies (copy), ReactFeatureFlags (copy), u133 (ref), invariant (copy), ReactFiberLane (copy), n2 (ref)
	local v305 = n1

	n1 = bit32.bor(n1, 16)

	local v306 = t3.pushDispatcher()

	if p47 ~= u132 or p48 ~= NoLanes then
		t3.prepareFreshStack(p47, p48)
		t3.startWorkOnPendingInteractions(p47, p48)
	end

	local v307 = t3.pushInteractions(p47)

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStarted(p48)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStarted(p48)
	end

	while true do
		local result = nil
		local ok

		if not __YOLO__ then
			ok, result = xpcall(t3.workLoopSync, describeError)
		else
			ok = true
			t3.workLoopSync()
		end

		if ok then
			break
		end

		t3.handleError(p47, result)
	end

	resetContextDependencies()

	if ReactFeatureFlags.enableSchedulerTracing then
		t3.popInteractions(v307)
	end

	n1 = v305
	t3.popDispatcher(v306)

	if u133 ~= nil then
		invariant(false, "Cannot commit an incomplete root. This error is likely caused by a bug in React. Please file an issue.")
	end

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStopped()
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStopped()
	end

	u132 = nil
	NoLanes = ReactFiberLane.NoLanes

	return n2
end
function t3.workLoopSync() -- line: 1859
	-- upvalues: u133 (ref), t3 (copy)
	while u133 ~= nil do
		t3.performUnitOfWork(u133)
	end
end
function t3.renderRootConcurrent(p49, p50) -- line: 1866
	-- upvalues: n1 (ref), t3 (copy), u132 (ref), NoLanes (ref), n4 (ref), now (copy), __DEV__ (copy), enableDebugTracing (copy), DebugTracing (copy), enableSchedulingProfiler (copy), SchedulingProfiler (copy), __YOLO__ (copy), describeError (copy), resetContextDependencies (copy), ReactFeatureFlags (copy), u133 (ref), ReactFiberLane (copy), n2 (ref)
	local v312 = n1

	n1 = bit32.bor(n1, 16)

	local v313 = t3.pushDispatcher()

	if p49 ~= u132 or p50 ~= NoLanes then
		n4 = now() + 500
		t3.prepareFreshStack(p49, p50)
		t3.startWorkOnPendingInteractions(p49, p50)
	end

	local v314 = t3.pushInteractions(p49)

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStarted(p50)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStarted(p50)
	end

	while true do
		local ok, result

		if not __YOLO__ then
			ok, result = xpcall(t3.workLoopConcurrent, describeError)

			if ok then
				result = "break"
			end
		else
			ok = true
			result = "break"
			t3.workLoopConcurrent()
		end

		if result == "break" then
			break
		end

		if not ok then
			t3.handleError(p49, result)
		end
	end

	resetContextDependencies()

	if ReactFeatureFlags.enableSchedulerTracing then
		t3.popInteractions(v314)
	end

	t3.popDispatcher(v313)
	n1 = v312

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStopped()
	end

	if u133 ~= nil then
		if enableSchedulingProfiler then
			SchedulingProfiler.markRenderYielded()
		end

		return 0
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStopped()
	end

	u132 = nil
	NoLanes = ReactFiberLane.NoLanes

	return n2
end
function t3.workLoopConcurrent() -- line: 1950
	-- upvalues: u133 (ref), shouldYield (copy), t3 (copy)
	while u133 ~= nil and not shouldYield() do
		t3.performUnitOfWork(u133)
	end
end
function t3.performUnitOfWork(p51) -- line: 1957
	-- upvalues: RobloxReactProfiling (copy), setCurrentFiber (copy), ReactFeatureFlags (copy), ReactTypeOfMode (copy), lib3 (copy), t3 (copy), t1 (copy), resetCurrentFiber (copy), u133 (ref), ReactCurrentOwner (copy)
	local v318 = RobloxReactProfiling.profileUnitOfWorkBefore(p51)
	local alternate = p51.alternate

	setCurrentFiber(p51)

	local v320

	if ReactFeatureFlags.enableProfilerTimer and bit32.band(p51.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode then
		lib3.startProfilerTimer(p51)
		v320 = t3.beginWork(alternate, p51, t1.subtreeRenderLanes)
		lib3.stopProfilerTimerIfRunningAndRecordDelta(p51, true)
	else
		v320 = t3.beginWork(alternate, p51, t1.subtreeRenderLanes)
	end

	resetCurrentFiber()
	p51.memoizedProps = p51.pendingProps

	if v320 == nil then
		t3.completeUnitOfWork(p51)
	else
		u133 = v320
	end

	ReactCurrentOwner.current = nil
	RobloxReactProfiling.profileUnitOfWorkAfter(v318)
end
function t3.completeUnitOfWork(p52) -- line: 1995
	-- upvalues: ReactFiberFlags (copy), setCurrentFiber (copy), ReactFeatureFlags (copy), ReactTypeOfMode (copy), t1 (copy), t2 (copy), lib3 (copy), resetCurrentFiber (copy), u133 (ref), unwindWork (copy), n2 (ref)
	repeat
		local alternate = p52.alternate
		local return_ = p52.return_

		if bit32.band(p52.flags, ReactFiberFlags.Incomplete) == ReactFiberFlags.NoFlags then
			setCurrentFiber(p52)

			local v325

			if not ReactFeatureFlags.enableProfilerTimer or bit32.band(p52.mode, ReactTypeOfMode.ProfileMode) == ReactTypeOfMode.NoMode then
				local subtreeRenderLanes = t1.subtreeRenderLanes

				if not t2.completeWorkRef then
					t2.completeWorkRef = require(script.Parent["ReactFiberCompleteWork.new"]).completeWork
				end

				v325 = t2.completeWorkRef(alternate, p52, subtreeRenderLanes)
			else
				lib3.startProfilerTimer(p52)

				local subtreeRenderLanes = t1.subtreeRenderLanes

				if not t2.completeWorkRef then
					t2.completeWorkRef = require(script.Parent["ReactFiberCompleteWork.new"]).completeWork
				end

				v325 = t2.completeWorkRef(alternate, p52, subtreeRenderLanes)
				lib3.stopProfilerTimerIfRunningAndRecordDelta(p52, false)
			end

			resetCurrentFiber()

			if v325 ~= nil then
				u133 = v325

				return
			end
		else
			local v327 = unwindWork(p52, t1.subtreeRenderLanes)

			if v327 ~= nil then
				v327.flags = bit32.band(v327.flags, ReactFiberFlags.HostEffectMask)
				u133 = v327

				return
			end

			if ReactFeatureFlags.enableProfilerTimer and bit32.band(p52.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode then
				lib3.stopProfilerTimerIfRunningAndRecordDelta(p52, false)

				local v328 = p52.actualDuration or 0
				local child = p52.child

				while child ~= nil do
					v328 += child.actualDuration or 0
					child = child.sibling
				end

				p52.actualDuration = v328
			end

			if return_ ~= nil then
				return_.flags = bit32.bor(return_.flags, ReactFiberFlags.Incomplete)
				return_.subtreeFlags = ReactFiberFlags.NoFlags
				return_.deletions = nil
			end
		end

		local sibling = p52.sibling

		if sibling ~= nil then
			u133 = sibling

			return
		end

		p52 = return_
		u133 = p52
	until p52 == nil

	if n2 == 0 then
		n2 = 5
	end
end
function t3.commitRoot(p53) -- line: 2103
	-- upvalues: getCurrentPriorityLevel (copy), runWithPriority (copy), ImmediatePriority (copy), RobloxReactProfiling (copy), t3 (copy)
	local v332 = getCurrentPriorityLevel()

	runWithPriority(ImmediatePriority, function() -- line: 2105
		-- upvalues: RobloxReactProfiling (copy), t3 (copy), p53 (copy), v332 (copy)
		RobloxReactProfiling.profileCommitBefore()

		local v542 = t3.commitRootImpl(p53, v332)

		RobloxReactProfiling.profileCommitAfter()

		return v542
	end)

	return nil
end
function t3.commitRootImpl(p54, p55) -- line: 2116
	-- upvalues: t1 (copy), u152 (ref), invariant (copy), n1 (ref), __DEV__ (copy), enableDebugTracing (copy), DebugTracing (copy), enableSchedulingProfiler (copy), SchedulingProfiler (copy), ReactFiberLane (copy), mergeLanes (copy), markRootFinished (copy), u155 (ref), hasDiscreteLanes (copy), u132 (ref), u133 (ref), NoLanes (ref), ReactFiberFlags (copy), ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), t3 (copy), ReactCurrentOwner (copy), u163 (ref), ReactFiberHostConfig (copy), u164 (ref), lib3 (copy), setCurrentFiber (copy), invokeGuardedCallback (copy), recursivelyCommitLayoutEffects (copy), hasCaughtError (copy), clearCaughtError (copy), u128 (ref), resetCurrentFiber (copy), __YOLO__ (copy), describeError (copy), u151 (ref), scheduleCallback (copy), NormalPriority (copy), requestPaint (copy), NoLanes5 (ref), u153 (ref), u159 (ref), u150 (ref), enableDoubleInvokingEffects (copy), SyncLane (copy), u157 (ref), n5 (ref), onCommitRoot (copy), onCommitRoot2 (copy), u101 (ref), now (copy), u148 (ref), u149 (ref), flushSyncCallbackQueue (copy)
	repeat
		t1.flushPassiveEffects()
	until u152 == nil

	flushRenderPhaseStrictModeWarningsInDEV()
	invariant(bit32.band(n1, 48) == 0, "Should not already be working.")

	local finishedWork = p54.finishedWork
	local finishedLanes = p54.finishedLanes

	if __DEV__ and enableDebugTracing then
		DebugTracing.logCommitStarted(finishedLanes)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markCommitStarted(finishedLanes)
	end

	if finishedWork == nil then
		if __DEV__ and enableDebugTracing then
			DebugTracing.logCommitStopped()
		end

		if enableSchedulingProfiler then
			SchedulingProfiler.markCommitStopped(p54)
		end

		return nil
	end

	p54.finishedWork = nil
	p54.finishedLanes = ReactFiberLane.NoLanes
	invariant(finishedWork ~= p54.current, "Cannot commit the same tree as before. This error is likely caused by a bug in React. Please file an issue.")
	p54.callbackNode = nil

	local v337 = mergeLanes(finishedWork.lanes, finishedWork.childLanes)

	markRootFinished(p54, v337)

	if u155 ~= nil and not hasDiscreteLanes(v337) and u155:has(p54) then
		u155:delete(p54)
	end

	if p54 == u132 then
		u132 = nil
		u133 = nil
		NoLanes = ReactFiberLane.NoLanes
	end

	local v338 = bit32.band(finishedWork.subtreeFlags, (bit32.bor(ReactFiberFlags.BeforeMutationMask, ReactFiberFlags.MutationMask, ReactFiberFlags.LayoutMask, ReactFiberFlags.PassiveMask))) ~= ReactFiberFlags.NoFlags
	local v339 = bit32.band(finishedWork.flags, (bit32.bor(ReactFiberFlags.BeforeMutationMask, ReactFiberFlags.MutationMask, ReactFiberFlags.LayoutMask, ReactFiberFlags.PassiveMask))) ~= ReactFiberFlags.NoFlags

	if v338 or v339 then
		local v340 = nil

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
			v340 = getCurrentUpdateLanePriority()
			setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)
		end

		local v341 = n1

		n1 = bit32.bor(n1, 32)

		local v342 = t3.pushInteractions(p54)

		ReactCurrentOwner.current = nil
		u163 = ReactFiberHostConfig.prepareForCommit(p54.containerInfo)
		u164 = false
		t3.commitBeforeMutationEffects(finishedWork)
		u163 = nil

		if ReactFeatureFlags.enableProfilerTimer then
			lib3.recordCommitTime()
		end

		t3.commitMutationEffects(finishedWork, p54, p55)

		if u164 then
			ReactFiberHostConfig.afterActiveInstanceBlur()
		end

		ReactFiberHostConfig.resetAfterCommit(p54.containerInfo)
		p54.current = finishedWork

		if __DEV__ and enableDebugTracing then
			DebugTracing.logLayoutEffectsStarted(finishedLanes)
		end

		if enableSchedulingProfiler then
			SchedulingProfiler.markLayoutEffectsStarted(finishedLanes)
		end

		if __DEV__ then
			setCurrentFiber(finishedWork)
			invokeGuardedCallback(nil, recursivelyCommitLayoutEffects, nil, finishedWork, p54, t1.captureCommitPhaseError, t1.schedulePassiveEffectCallback)

			if hasCaughtError() then
				local v343 = clearCaughtError()

				u128(finishedWork, finishedWork, v343)
			end

			resetCurrentFiber()
		else
			local result = nil
			local ok

			if not __YOLO__ then
				ok, result = xpcall(recursivelyCommitLayoutEffects, describeError, finishedWork, p54, t1.captureCommitPhaseError, t1.schedulePassiveEffectCallback)
			else
				ok = true
				recursivelyCommitLayoutEffects(finishedWork, p54, t1.captureCommitPhaseError, t1.schedulePassiveEffectCallback)
			end

			if not ok then
				u128(finishedWork, finishedWork, result)
			end
		end

		if __DEV__ and enableDebugTracing then
			DebugTracing.logLayoutEffectsStopped()
		end

		if enableSchedulingProfiler then
			SchedulingProfiler.markLayoutEffectsStopped()
		end

		if (bit32.band(finishedWork.subtreeFlags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags or bit32.band(finishedWork.flags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags) and not u151 then
			u151 = true
			scheduleCallback(NormalPriority, function() -- line: 2350
				-- upvalues: t1 (copy)
				t1.flushPassiveEffects()

				return nil
			end)
		end

		requestPaint()

		if ReactFeatureFlags.enableSchedulerTracing then
			t3.popInteractions(v342)
		end

		n1 = v341

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler and v340 ~= nil then
			setCurrentUpdateLanePriority(v340)
		end
	else
		p54.current = finishedWork

		if ReactFeatureFlags.enableProfilerTimer then
			lib3.recordCommitTime()
		end
	end

	local v346 = u151

	if u151 then
		u151 = false
		u152 = p54
		NoLanes5 = finishedLanes
		u153 = p55
	end

	local pendingLanes = p54.pendingLanes

	if pendingLanes ~= ReactFiberLane.NoLanes then
		if ReactFeatureFlags.enableSchedulerTracing then
			if u159 ~= nil then
				local v348 = u159

				u159 = nil

				for i = 1, #v348 do
					scheduleInteractions(p54, v348[i], p54.memoizedInteractions)
				end
			end

			t3.schedulePendingInteractions(p54, pendingLanes)
		end
	else
		u150 = nil
	end

	if __DEV__ and enableDoubleInvokingEffects and not v346 then
		commitDoubleInvokeEffectsInDEV(p54.current, false)
	end

	if ReactFeatureFlags.enableSchedulerTracing and not v346 then
		t3.finishPendingInteractions(p54, finishedLanes)
	end

	if pendingLanes == SyncLane then
		if p54 == u157 then
			n5 += 1
		else
			n5 = 0
			u157 = p54
		end
	else
		n5 = 0
	end

	onCommitRoot(finishedWork.stateNode, p55)

	if __DEV__ then
		onCommitRoot2()
	end

	u101(p54, now())

	if u148 then
		u148 = false

		local v350 = u149

		u149 = nil
		error(v350)
	end

	if bit32.band(n1, 8) ~= 0 then
		if __DEV__ and enableDebugTracing then
			DebugTracing.logCommitStopped()
		end

		if enableSchedulingProfiler then
			SchedulingProfiler.markCommitStopped(p54)
		end

		return nil
	end

	flushSyncCallbackQueue()

	if __DEV__ and enableDebugTracing then
		DebugTracing.logCommitStopped()
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markCommitStopped(p54)
	end

	return nil
end
function t3.commitBeforeMutationEffects(p56) -- line: 2503
	-- upvalues: t3 (copy), ReactFiberFlags (copy), __DEV__ (copy), setCurrentFiber (copy), invokeGuardedCallback (copy), hasCaughtError (copy), clearCaughtError (copy), t1 (copy), resetCurrentFiber (copy), __YOLO__ (copy), describeError (copy)
	while p56 ~= nil do
		if p56.deletions ~= nil then
			t3.commitBeforeMutationEffectsDeletions(p56.deletions)
		end

		if p56.child ~= nil and bit32.band(p56.subtreeFlags, ReactFiberFlags.BeforeMutationMask) ~= ReactFiberFlags.NoFlags then
			t3.commitBeforeMutationEffects(p56.child)
		end

		if __DEV__ then
			setCurrentFiber(p56)
			invokeGuardedCallback(nil, t3.commitBeforeMutationEffectsImpl, nil, p56)

			if hasCaughtError() then
				local v352 = clearCaughtError()

				t1.captureCommitPhaseError(p56, p56.return_, v352)
			end

			resetCurrentFiber()
		else
			local result = nil
			local ok

			if not __YOLO__ then
				ok, result = xpcall(t3.commitBeforeMutationEffectsImpl, describeError, p56)
			else
				ok = true
				t3.commitBeforeMutationEffectsImpl(p56)
			end

			if not ok then
				t1.captureCommitPhaseError(p56, p56.return_, result)
			end
		end

		p56 = p56.sibling
	end
end
function t3.commitBeforeMutationEffectsImpl(p57) -- line: 2546
	-- upvalues: u164 (ref), u163 (ref), ReactWorkTags (copy), lib2 (copy), doesFiberContain (copy), ReactFiberHostConfig (copy), ReactFiberFlags (copy), setCurrentFiber (copy), commitBeforeMutationLifeCycles (copy), resetCurrentFiber (copy), u151 (ref), scheduleCallback (copy), NormalPriority (copy), t1 (copy)
	local alternate = p57.alternate
	local flags = p57.flags

	if not u164 and (u163 ~= nil and p57.tag == ReactWorkTags.SuspenseComponent and lib2.isSuspenseBoundaryBeingHidden(alternate, p57) and doesFiberContain(p57, u163)) then
		u164 = true
		ReactFiberHostConfig.beforeActiveInstanceBlur()
	end

	if bit32.band(flags, ReactFiberFlags.Snapshot) ~= ReactFiberFlags.NoFlags then
		setCurrentFiber(p57)
		commitBeforeMutationLifeCycles(alternate, p57)
		resetCurrentFiber()
	end

	if bit32.band(flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags and not u151 then
		u151 = true
		scheduleCallback(NormalPriority, function() -- line: 2574
			-- upvalues: t1 (copy)
			t1.flushPassiveEffects()

			return nil
		end)
	end
end
function t3.commitBeforeMutationEffectsDeletions(p58) -- line: 2582
	-- upvalues: doesFiberContain (copy), u163 (ref), u164 (ref), ReactFiberHostConfig (copy)
	for i = 1, #p58 do
		local v360 = p58[i]

		if doesFiberContain(v360, u163) then
			u164 = true
			ReactFiberHostConfig.beforeActiveInstanceBlur()
		end
	end
end
function t3.commitMutationEffects(p59, p60, p61) -- line: 2597
	-- upvalues: commitDeletion (copy), describeError (copy), t1 (copy), ReactFiberFlags (copy), t3 (copy), __DEV__ (copy), setCurrentFiber (copy), invokeGuardedCallback (copy), hasCaughtError (copy), clearCaughtError (copy), resetCurrentFiber (copy), __YOLO__ (copy)
	while p59 ~= nil do
		local deletions = p59.deletions

		if deletions ~= nil then
			for _, v366 in deletions do
				local ok, result = xpcall(commitDeletion, describeError, p60, v366, p59, p61)

				if not ok then
					t1.captureCommitPhaseError(v366, p59, result)
				end
			end
		end

		if p59.child ~= nil and bit32.band(p59.subtreeFlags, ReactFiberFlags.MutationMask) ~= ReactFiberFlags.NoFlags then
			t3.commitMutationEffects(p59.child, p60, p61)
		end

		if __DEV__ then
			setCurrentFiber(p59)
			invokeGuardedCallback(nil, t3.commitMutationEffectsImpl, nil, p59, p60, p61)

			if hasCaughtError() then
				local v369 = clearCaughtError()

				t1.captureCommitPhaseError(p59, p59.return_, v369)
			end

			resetCurrentFiber()
		else
			local result = nil
			local ok

			if not __YOLO__ then
				ok, result = xpcall(t3.commitMutationEffectsImpl, describeError, p59, p60, p61)
			else
				ok = true
				t3.commitMutationEffectsImpl(p59, p60, p61)
			end

			if not ok then
				t1.captureCommitPhaseError(p59, p59.return_, result)
			end
		end

		p59 = p59.sibling
	end
end
function t3.commitMutationEffectsImpl(p62, _, _) -- line: 2670
	-- upvalues: ReactFiberFlags (copy), commitDetachRef (copy), commitPlacement (copy), commitWork (copy)
	local flags = p62.flags

	if bit32.band(flags, ReactFiberFlags.Ref) ~= 0 then
		local alternate = p62.alternate

		if alternate ~= nil then
			commitDetachRef(alternate)
		end
	end

	local v377 = bit32.band(flags, (bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Update, ReactFiberFlags.Hydrating)))

	if v377 == ReactFiberFlags.Placement then
		commitPlacement(p62)
		p62.flags = bit32.band(p62.flags, (bit32.bnot(ReactFiberFlags.Placement)))

		return
	end

	if v377 == ReactFiberFlags.PlacementAndUpdate then
		commitPlacement(p62)
		p62.flags = bit32.band(p62.flags, (bit32.bnot(ReactFiberFlags.Placement)))

		local alternate = p62.alternate

		commitWork(alternate, p62)

		return
	end

	if v377 == ReactFiberFlags.Update then
		local alternate = p62.alternate

		commitWork(alternate, p62)
	end
end
function t3.commitMutationEffectsDeletions(p65, p66, p67, p68) -- line: 2739
	-- upvalues: commitDeletion (copy), describeError (copy), t1 (copy)
	for _, v385 in p65 do
		local ok, result = xpcall(commitDeletion, describeError, p67, v385, p66, p68)

		if not ok then
			t1.captureCommitPhaseError(v385, p66, result)
		end
	end
end
function t1.schedulePassiveEffectCallback() -- line: 2762
	-- upvalues: u151 (ref), scheduleCallback (copy), NormalPriority (copy), t1 (copy)
	if not u151 then
		u151 = true
		scheduleCallback(NormalPriority, function() -- line: 2765
			-- upvalues: t1 (copy)
			t1.flushPassiveEffects()

			return nil
		end)
	end
end

local u167 = nil

function t1.flushPassiveEffects() -- line: 2774
	-- upvalues: u153 (ref), NoPriority (copy), NormalPriority (copy), ReactFeatureFlags (copy), getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), schedulerPriorityToLanePriority (copy), __YOLO__ (copy), runWithPriority (copy), describeError (copy), u167 (ref)
	if u153 ~= NoPriority then
		local v388 = if not (u153 > NormalPriority) then u153 else NormalPriority

		u153 = NoPriority

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
			local v389 = getCurrentUpdateLanePriority()

			setCurrentUpdateLanePriority(schedulerPriorityToLanePriority(v388))

			local ok, result

			if not __YOLO__ then
				ok, result = xpcall(runWithPriority, describeError, v388, u167)
			else
				ok = true
				setCurrentUpdateLanePriority(schedulerPriorityToLanePriority(v388))
				result = runWithPriority(v388, u167)
			end

			setCurrentUpdateLanePriority(v389)

			if not ok then
				error(result)
			end

			return result
		end

		return runWithPriority(v388, u167)
	end

	return false
end

local function u168(p69, p70) -- line: 2818
	-- upvalues: ReactFeatureFlags (copy), ReactWorkTags (copy), u146 (ref), ReactFiberFlags (copy), u168 (ref), __DEV__ (copy), setCurrentFiber (copy), invokeGuardedCallback (copy), commitPassiveMount (copy), hasCaughtError (copy), clearCaughtError (copy), t1 (copy), resetCurrentFiber (copy), __YOLO__ (copy), describeError (copy)
	while p70 ~= nil do
		local v394 = nil

		if ReactFeatureFlags.enableProfilerTimer and ReactFeatureFlags.enableProfilerCommitHooks and p70.tag == ReactWorkTags.Profiler then
			v394 = u146
			u146 = p70
		end

		local v395 = bit32.band(p70.subtreeFlags, ReactFiberFlags.PassiveMask)

		if p70.child ~= nil and v395 ~= ReactFiberFlags.NoFlags then
			u168(p69, p70.child)
		end

		if bit32.band(p70.flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags then
			if __DEV__ then
				setCurrentFiber(p70)
				invokeGuardedCallback(nil, commitPassiveMount, nil, p69, p70)

				if hasCaughtError() then
					local v396 = clearCaughtError()

					t1.captureCommitPhaseError(p70, p70.return_, v396)
				end

				resetCurrentFiber()
			else
				local result = nil
				local ok

				if not __YOLO__ then
					ok, result = xpcall(commitPassiveMount, describeError, p69, p70)
				else
					ok = true
					commitPassiveMount(p69, p70)
				end

				if not ok then
					t1.captureCommitPhaseError(p70, p70.return_, result)
				end
			end
		end

		if ReactFeatureFlags.enableProfilerTimer and ReactFeatureFlags.enableProfilerCommitHooks and p70.tag == ReactWorkTags.Profiler then
			if v394 ~= nil then
				local stateNode = v394.stateNode

				stateNode.passiveEffectDuration = stateNode.passiveEffectDuration + p70.stateNode.passiveEffectDuration
			end

			u146 = v394
		end

		p70 = p70.sibling
	end
end
local function flushPassiveUnmountEffects(p71) -- line: 2887
	-- upvalues: t3 (copy), enableNewTreeCleanupPath (copy), deletedTreeCleanUpLevel (copy), ReactFiberFlags (copy), flushPassiveUnmountEffects (copy), setCurrentFiber (copy), commitPassiveUnmount (copy), resetCurrentFiber (copy)
	while p71 ~= nil do
		local deletions = p71.deletions

		if deletions ~= nil then
			for i = 1, #deletions do
				local v403 = deletions[i]

				t3.flushPassiveUnmountEffectsInsideOfDeletedTree(v403, p71)

				if not enableNewTreeCleanupPath or not (deletedTreeCleanUpLevel >= 2) then
					t3.detachFiberAfterEffects(v403)
				end
			end

			if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 1 then
				local alternate = p71.alternate

				if alternate ~= nil then
					local child = alternate.child

					if child ~= nil then
						alternate.child = nil

						repeat
							local sibling = child.sibling

							child.sibling = nil
							child = sibling
						until child == nil
					end
				end
			end
		end

		local child = p71.child

		if child ~= nil and bit32.band(p71.subtreeFlags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags then
			flushPassiveUnmountEffects(child)
		end

		if bit32.band(p71.flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags then
			setCurrentFiber(p71)
			commitPassiveUnmount(p71)
			resetCurrentFiber()
		end

		p71 = p71.sibling
	end
end

function t3.flushPassiveUnmountEffectsInsideOfDeletedTree(p72, p73) -- line: 2956
	-- upvalues: ReactFiberFlags (copy), enableNewTreeCleanupPath (copy), deletedTreeCleanUpLevel (copy), t3 (copy), setCurrentFiber (copy), commitPassiveUnmountInsideDeletedTree (copy), resetCurrentFiber (copy)
	if bit32.band(p72.subtreeFlags, ReactFiberFlags.PassiveStatic) ~= ReactFiberFlags.NoFlags or enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2 then
		local child = p72.child

		while child ~= nil do
			local sibling = child.sibling

			t3.flushPassiveUnmountEffectsInsideOfDeletedTree(child, p73)
			child = sibling
		end
	end

	if bit32.band(p72.flags, ReactFiberFlags.PassiveStatic) ~= ReactFiberFlags.NoFlags then
		setCurrentFiber(p72)
		commitPassiveUnmountInsideDeletedTree(p72, p73)
		resetCurrentFiber()
	end

	if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2 then
		t3.detachFiberAfterEffects(p72)
	end
end
function u167() -- line: 2997
	-- upvalues: u152 (ref), NoLanes5 (ref), ReactFiberLane (copy), invariant (copy), n1 (ref), __DEV__ (copy), enableDebugTracing (copy), DebugTracing (copy), enableSchedulingProfiler (copy), SchedulingProfiler (copy), t3 (copy), flushPassiveUnmountEffects (copy), u168 (ref), enableDoubleInvokingEffects (copy), ReactFeatureFlags (copy), flushSyncCallbackQueue (copy), n6 (ref)
	if u152 == nil then
		return false
	end

	local v412 = u152
	local v413 = NoLanes5

	u152 = nil
	NoLanes5 = ReactFiberLane.NoLanes
	invariant(bit32.band(n1, 48) == 0, "Cannot flush passive effects while already rendering.")

	if __DEV__ and enableDebugTracing then
		DebugTracing.logPassiveEffectsStarted(v413)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markPassiveEffectsStarted(v413)
	end

	local v414 = n1

	n1 = bit32.bor(n1, 32)

	local v415 = t3.pushInteractions(v412)

	flushPassiveUnmountEffects(v412.current)
	u168(v412, v412.current)

	if __DEV__ and enableDebugTracing then
		DebugTracing.logPassiveEffectsStopped()
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markPassiveEffectsStopped(v412)
	end

	if __DEV__ and enableDoubleInvokingEffects then
		commitDoubleInvokeEffectsInDEV(v412.current, true)
	end

	if ReactFeatureFlags.enableSchedulerTracing then
		t3.popInteractions(v415)
		t3.finishPendingInteractions(v412, v413)
	end

	n1 = v414
	flushSyncCallbackQueue()

	if u152 == nil then
		n6 = 0
	else
		n6 += 1
	end

	return true
end
function t1.isAlreadyFailedLegacyErrorBoundary(p74) -- line: 3071
	-- upvalues: u150 (ref)
	return u150 ~= nil and u150:has(p74)
end
function t1.markLegacyErrorBoundaryAsFailed(p75) -- line: 3076
	-- upvalues: u150 (ref), Set (copy)
	if u150 == nil then
		u150 = Set.new({ p75 })

		return
	end

	u150:add(p75)
end

local function prepareToThrowUncaughtError(p76) -- line: 3085
	-- upvalues: u148 (ref), u149 (ref)
	if not u148 then
		u148 = true
		u149 = p76
	end
end

t1.onUncaughtError = prepareToThrowUncaughtError

function u128(p77, p78, p79) -- line: 3093
	-- upvalues: createCapturedValue (copy), createRootErrorUpdate (copy), SyncLane (copy), t1 (copy), enqueueUpdate (copy), t3 (copy), markRootUpdated (copy), u101 (ref)
	local v422 = createCapturedValue(p79, p78)
	local v423 = createRootErrorUpdate(p77, v422, SyncLane, t1.onUncaughtError)

	enqueueUpdate(p77, v423)

	local v424 = t1.requestEventTime()
	local v425 = t3.markUpdateLaneFromFiberToRoot(p77, SyncLane)

	if v425 ~= nil then
		markRootUpdated(v425, SyncLane, v424)
		u101(v425, v424)
		t3.schedulePendingInteractions(v425, SyncLane)
	end
end
function t1.captureCommitPhaseError(p80, p81, p82) -- line: 3113
	-- upvalues: ReactWorkTags (copy), u128 (ref), skipUnmountedBoundaries (copy), t1 (copy), createCapturedValue (copy), createClassErrorUpdate (copy), SyncLane (copy), enqueueUpdate (copy), t3 (copy), markRootUpdated (copy), u101 (ref)
	if p80.tag == ReactWorkTags.HostRoot then
		u128(p80, p80, p82)

		return
	end

	local v429 = if not skipUnmountedBoundaries then p80.return_ else p81

	while v429 ~= nil do
		if v429.tag == ReactWorkTags.HostRoot then
			u128(v429, p80, p82)

			return
		end

		if v429.tag == ReactWorkTags.ClassComponent then
			local type = v429.type
			local stateNode = v429.stateNode

			if typeof(type.getDerivedStateFromError) == "function" or typeof(stateNode.componentDidCatch) == "function" and not t1.isAlreadyFailedLegacyErrorBoundary(stateNode) then
				local v432 = createCapturedValue(p82, p80)
				local v433 = createClassErrorUpdate(v429, v432, SyncLane)

				enqueueUpdate(v429, v433)

				local v434 = t1.requestEventTime()
				local v435 = t3.markUpdateLaneFromFiberToRoot(v429, SyncLane)

				if v435 ~= nil then
					markRootUpdated(v435, SyncLane, v434)
					u101(v435, v434)
					t3.schedulePendingInteractions(v435, SyncLane)
				end

				return
			end
		end

		v429 = v429.return_
	end
end
function t1.pingSuspendedRoot(p83, p84, p85) -- line: 3165
	-- upvalues: t1 (copy), markRootPinged (copy), u132 (ref), isSubsetOfLanes (copy), NoLanes (ref), n2 (ref), includesOnlyRetries (copy), now (copy), n3 (ref), t3 (copy), ReactFiberLane (copy), NoLanes4 (ref), mergeLanes (copy), u101 (ref)
	local pingCache = p83.pingCache

	if pingCache ~= nil then
		pingCache[p84] = nil
	end

	local v440 = t1.requestEventTime()

	markRootPinged(p83, p85, v440)

	if p83 == u132 and isSubsetOfLanes(NoLanes, p85) then
		if n2 == 4 or n2 == 3 and includesOnlyRetries(NoLanes) and now() - n3 < 500 then
			t3.prepareFreshStack(p83, ReactFiberLane.NoLanes)
		else
			NoLanes4 = mergeLanes(NoLanes4, p85)
		end
	end

	u101(p83, v440)
	t3.schedulePendingInteractions(p83, p85)
end
function retryTimedOutBoundary(p86, p87) -- line: 3213
	-- upvalues: ReactFiberLane (copy), t1 (copy), t3 (copy), markRootUpdated (copy), u101 (ref)
	if p87 == ReactFiberLane.NoLane then
		p87 = requestRetryLane(p86)
	end

	local v443 = t1.requestEventTime()
	local v444 = t3.markUpdateLaneFromFiberToRoot(p86, p87)

	if v444 ~= nil then
		markRootUpdated(v444, p87, v443)
		u101(v444, v443)
		t3.schedulePendingInteractions(v444, p87)
	end
end
function t1.resolveRetryWakeable(p88, p89) -- line: 3240
	-- upvalues: ReactFiberLane (copy)
	local NoLane = ReactFiberLane.NoLane
	local stateNode = p88.stateNode

	if stateNode ~= nil then
		stateNode:delete(p89)
	end

	retryTimedOutBoundary(p88, NoLane)
end
function jnd(n10: number) -- line: 3284
	if n10 < 120 then
		return 120
	end

	if n10 < 480 then
		return 480
	end

	if n10 < 1080 then
		return 1080
	end

	if n10 < 1920 then
		return 1920
	end

	if n10 < 3000 then
		return 3000
	end

	if n10 < 4320 then
		return 4320
	end

	return math.ceil(n10 / 1960) * 1960
end
function t3.checkForNestedUpdates() -- line: 3302
	-- upvalues: n5 (ref), u157 (ref), invariant (copy), __DEV__ (copy), n6 (ref), console (copy)
	if n5 > 50 then
		n5 = 0
		u157 = nil
		invariant(false, "Maximum update depth exceeded. This can happen when a component repeatedly calls setState inside componentWillUpdate or componentDidUpdate. React limits the number of nested updates to prevent infinite loops.")
	end

	if __DEV__ and n6 > 50 then
		n6 = 0
		console.error("Maximum update depth exceeded. This can happen when a component calls setState inside useEffect, but useEffect either doesn't have a dependency array, or one of the dependencies changes on every render.")
	end
end
function flushRenderPhaseStrictModeWarningsInDEV() -- line: 3328
	-- upvalues: __DEV__ (copy), lib4 (copy), ReactFeatureFlags (copy)
	if __DEV__ then
		lib4.flushLegacyContextWarning()

		if ReactFeatureFlags.warnAboutDeprecatedLifecycles then
			lib4.flushPendingUnsafeLifecycleWarnings()
		end
	end
end
function commitDoubleInvokeEffectsInDEV(p90, b1: boolean) -- line: 3338
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), setCurrentFiber (copy), ReactFiberFlags (copy), invokeLayoutEffectUnmountInDEV (copy), invokePassiveEffectUnmountInDEV (copy), invokeLayoutEffectMountInDEV (copy), invokePassiveEffectMountInDEV (copy), resetCurrentFiber (copy)
	if __DEV__ and enableDoubleInvokingEffects then
		setCurrentFiber(p90)
		invokeEffectsInDev(p90, ReactFiberFlags.MountLayoutDev, invokeLayoutEffectUnmountInDEV)

		if b1 then
			invokeEffectsInDev(p90, ReactFiberFlags.MountPassiveDev, invokePassiveEffectUnmountInDEV)
		end

		invokeEffectsInDev(p90, ReactFiberFlags.MountLayoutDev, invokeLayoutEffectMountInDEV)

		if b1 then
			invokeEffectsInDev(p90, ReactFiberFlags.MountPassiveDev, invokePassiveEffectMountInDEV)
		end

		resetCurrentFiber()
	end
end
function invokeEffectsInDev(p91, p92, p93: ((...any) -> ...any)) -- line: 3370
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), ReactFiberFlags (copy)
	if __DEV__ and enableDoubleInvokingEffects then
		while p91 ~= nil do
			if p91.child ~= nil and bit32.band(p91.subtreeFlags, p92) ~= ReactFiberFlags.NoFlags then
				invokeEffectsInDev(p91.child, p92, p93)
			end

			if bit32.band(p91.flags, p92) ~= ReactFiberFlags.NoFlags then
				p93(p91)
			end

			p91 = p91.sibling
		end
	end
end

local t4 = nil

function t3.warnAboutUpdateOnNotYetMountedFiberInDEV(p94) -- line: 3396
	-- upvalues: __DEV__ (copy), n1 (ref), ReactTypeOfMode (copy), ReactWorkTags (copy), getComponentName (copy), t4 (ref), ReactCurrentFiber (copy), setCurrentFiber (copy), console (copy), resetCurrentFiber (copy)
	if __DEV__ then
		if bit32.band(n1, 16) ~= 0 then
			return
		end

		if bit32.band(p94.mode, (bit32.bor(ReactTypeOfMode.BlockingMode, ReactTypeOfMode.ConcurrentMode))) == 0 then
			return
		end

		local tag = p94.tag

		if tag ~= ReactWorkTags.IndeterminateComponent and tag ~= ReactWorkTags.HostRoot and tag ~= ReactWorkTags.ClassComponent and tag ~= ReactWorkTags.FunctionComponent and tag ~= ReactWorkTags.ForwardRef and tag ~= ReactWorkTags.MemoComponent and tag ~= ReactWorkTags.SimpleMemoComponent and tag ~= ReactWorkTags.Block then
			return
		end

		local v457 = getComponentName(p94.type) or "ReactComponent"

		if t4 ~= nil then
			if t4[v457] then
				return
			end

			t4[v457] = true
		else
			t4 = {
				[v457] = true
			}
		end

		local current4 = ReactCurrentFiber.current
		local ok, result = pcall(function() -- line: 3441
			-- upvalues: setCurrentFiber (copy), p94 (copy), console (copy)
			setCurrentFiber(p94)
			console.error("Can't perform a React state update on a component that hasn't mounted yet. This indicates that you have a side-effect in your render function that asynchronously later calls tries to update the component. Move this work to useEffect instead.")
		end)

		if current4 then
			setCurrentFiber(p94)
		else
			resetCurrentFiber()
		end

		if not ok then
			error(result)
		end
	end
end

if __DEV__ and ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback then
	function t3.beginWork(p95, p96, p97) -- line: 3467
		-- upvalues: lib (copy), v103 (copy), describeError (copy), resetContextDependencies (copy), t2 (copy), u104 (ref), unwindInterruptedWork (copy), ReactFeatureFlags (copy), ReactTypeOfMode (copy), lib3 (copy), invokeGuardedCallback (copy), hasCaughtError (copy), clearCaughtError (copy)
		local v464 = lib.assignFiberPropertiesInDEV(nil, p96)
		local ok, result = xpcall(v103, describeError, p95, p96, p97)

		if not ok then
			if result ~= nil and typeof(result) == "table" and typeof(result.andThen) == "function" then
				error(result)
			end

			resetContextDependencies()

			if not t2.resetHooksAfterThrowRef then
				u104 = require(script.Parent["ReactFiberHooks.new"])
				t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
				t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
				t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
			end

			t2.resetHooksAfterThrowRef()
			unwindInterruptedWork(p96)
			lib.assignFiberPropertiesInDEV(p96, v464)

			if ReactFeatureFlags.enableProfilerTimer and bit32.band(p96.mode, ReactTypeOfMode.ProfileMode) ~= 0 then
				lib3.startProfilerTimer(p96)
			end

			invokeGuardedCallback(nil, v103, nil, p95, p96, p97)

			if hasCaughtError() then
				local v467 = clearCaughtError()

				error(v467)

				return result
			end

			error(result)
		end

		return result
	end
else
	t3.beginWork = v103
end

local u172 = false
local t5 = nil

if __DEV__ then
	t5 = {}
end

function t3.warnAboutRenderPhaseUpdatesInDEV(p98) -- line: 3537
	-- upvalues: __DEV__ (copy), ReactCurrentFiber (copy), n1 (ref), t2 (copy), u104 (ref), ReactWorkTags (copy), u133 (ref), getComponentName (copy), t5 (ref), console (copy), u172 (ref)
	if __DEV__ and (ReactCurrentFiber.isRendering and bit32.band(n1, 16) ~= 0) then
		if not t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef then
			u104 = require(script.Parent["ReactFiberHooks.new"])
			t2.resetHooksAfterThrowRef = u104.resetHooksAfterThrow
			t2.ContextOnlyDispatcherRef = u104.ContextOnlyDispatcher
			t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = u104.getIsUpdatingOpaqueValueInRenderPhaseInDEV
		end

		if not t2.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef() then
			if p98.tag == ReactWorkTags.FunctionComponent or p98.tag == ReactWorkTags.ForwardRef or p98.tag == ReactWorkTags.SimpleMemoComponent then
				local v469 = u133 and getComponentName(u133.type) or "Unknown"

				if t5[v469] == nil then
					t5[v469] = true

					local v470 = getComponentName(p98.type) or "Unknown"

					console.error("Cannot update a component (`%s`) while rendering a different component (`%s`). To locate the bad setState() call inside `%s`, follow the stack trace as described in https://reactjs.org/link/setstate-in-render", v470, v469, v469)

					return
				end
			elseif p98.tag == ReactWorkTags.ClassComponent and not u172 then
				console.error("Cannot update during an existing state transition (such as within `render`). Render methods should be a pure function of props and state.")
				u172 = true
			end
		end
	end
end

t1.IsThisRendererActing = {
	current = false
}

function t1.warnIfNotScopedWithMatchingAct(p99) -- line: 3588
	-- upvalues: __DEV__ (copy), ReactFiberHostConfig (copy), IsSomeRendererActing (copy), t1 (copy), ReactCurrentFiber (copy), setCurrentFiber (copy), console (copy), resetCurrentFiber (copy)
	if __DEV__ and (ReactFiberHostConfig.warnsIfNotActing == true and IsSomeRendererActing.current == true and t1.IsThisRendererActing.current ~= true) then
		local current5 = ReactCurrentFiber.current
		local ok, result = pcall(function() -- line: 3596
			-- upvalues: setCurrentFiber (copy), p99 (copy), console (copy)
			setCurrentFiber(p99)
			console.error("It looks like you're using the wrong act() around your test interactions.\nBe sure to use the matching version of act() corresponding to your renderer:\n\n-- for react-roblox:\nlocal React = require(Packages.React)\n-- ...\nReact.TestUtils.act(function() ... end)\n\n-- for react-test-renderer:\nlocal TestRenderer = require(Packages.ReactTestRenderer)\n-- ...\nTestRenderer.act(function() ... end)")
		end)

		if current5 then
			setCurrentFiber(p99)
		else
			resetCurrentFiber()
		end

		if not ok then
			error(result)
		end
	end
end
function t1.warnIfNotCurrentlyActingEffectsInDEV(p100) -- line: 3631
	-- upvalues: __DEV__ (copy), ReactFiberHostConfig (copy), ReactTypeOfMode (copy), IsSomeRendererActing (copy), t1 (copy), console (copy), getComponentName (copy)
	if __DEV__ and (ReactFiberHostConfig.warnsIfNotActing == true and bit32.band(p100.mode, ReactTypeOfMode.StrictMode) ~= ReactTypeOfMode.NoMode and IsSomeRendererActing.current == false and t1.IsThisRendererActing.current == false) then
		console.error("An update to %s ran an effect, but was not wrapped in act(...).\n\nWhen testing, code that causes React state updates should be wrapped into act(...):\n\nact(function()\n  --[[ fire events that update state ]]\nend)\n--[[ assert on the output ]]\n\nThis ensures that you're testing the behavior the user would see in the real client. Learn more at https://reactjs.org/link/wrap-tests-with-act", getComponentName(p100.type))
	end
end
function t1.warnIfNotCurrentlyActingUpdatesInDEV(p101) -- line: 3657
	-- upvalues: __DEV__ (copy), ReactFiberHostConfig (copy), n1 (ref), IsSomeRendererActing (copy), t1 (copy), current (copy), setCurrentFiber (copy), console (copy), getComponentName (copy), resetCurrentFiber (copy)
	if __DEV__ and (ReactFiberHostConfig.warnsIfNotActing == true and n1 == 0 and IsSomeRendererActing.current == false and t1.IsThisRendererActing.current == false) then
		local v477 = current
		local ok, result = pcall(function() -- line: 3666
			-- upvalues: setCurrentFiber (copy), p101 (copy), console (copy), getComponentName (copy)
			setCurrentFiber(p101)
			console.error("An update to %s inside a test was not wrapped in act(...).\n\nWhen testing, code that causes React state updates should be wrapped into act(...):\n\nact(function()\n  --[[ fire events that update state ]]\nend)\n--[[ assert on the output ]]\n\nThis ensures that you're testing the behavior the user would see in the client application. Learn more at https://reactjs.org/link/wrap-tests-with-act", getComponentName(p101.type))
		end)

		if v477 then
			setCurrentFiber(p101)
		else
			resetCurrentFiber()
		end

		if ok then
			return result
		end
	end
end

local u174 = false

function t1.warnIfUnmockedScheduler(p102) -- line: 3707
	-- upvalues: __DEV__ (copy), u174 (ref), Scheduler (copy), ReactTypeOfMode (copy), console (copy), ReactFeatureFlags (copy)
	if __DEV__ and (u174 == false and Scheduler.unstable_flushAllWithoutAsserting == nil) then
		if bit32.band(p102.mode, ReactTypeOfMode.BlockingMode) ~= 0 or bit32.band(p102.mode, ReactTypeOfMode.ConcurrentMode) ~= 0 then
			u174 = true
			console.error("In Concurrent or Sync modes, the 'scheduler' module needs to be mocked to guarantee consistent behaviour across tests and client application. For example, with Jest: \njest.mock('scheduler', function() return require(Packages.Scheduler).unstable_mock end)\n\nFor more info, visit https://reactjs.org/link/mock-scheduler")

			return
		end

		if ReactFeatureFlags.warnAboutUnmockedScheduler == true then
			u174 = true
			console.error("Starting from React v18, the 'scheduler' module will need to be mocked to guarantee consistent behaviour across tests and client applications. For example, with Jest: \njest.mock('scheduler', function() return require(Packages.Scheduler).unstable_mock end)\n\nFor more info, visit https://reactjs.org/link/mock-scheduler")
		end
	end
end
function computeThreadID(p103, p104) -- line: 3751
	return p104 * 1000 + p103.interactionThreadID
end
function t1.markSpawnedWork(p105) -- line: 3759
	-- upvalues: ReactFeatureFlags (copy), u159 (ref)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	if u159 == nil then
		u159 = { p105 }

		return
	end

	table.insert(u159, p105)
end
function scheduleInteractions(p106, p107, p108) -- line: 3771
	-- upvalues: ReactFeatureFlags (copy), Set (copy), __subscriberRef (copy)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	if p108.size > 0 then
		local pendingInteractionMap = p106.pendingInteractionMap
		local v488 = pendingInteractionMap:get(p107)

		if v488 ~= nil then
			p108:forEach(function(p109) -- line: 3784
				-- upvalues: v488 (copy)
				if not v488:has(p109) then
					p109.__count = p109.__count + 1
				end

				v488:add(p109)
			end)
		else
			pendingInteractionMap:set(p107, Set.new(p108))

			for _, v490 in p108 do
				v490.__count = v490.__count + 1
			end
		end

		local current6 = __subscriberRef.current

		if current6 ~= nil then
			local v492 = computeThreadID(p106, p107)

			current6.onWorkScheduled(p108, v492)
		end
	end
end
function t3.schedulePendingInteractions(p110, p111) -- line: 3809
	-- upvalues: ReactFeatureFlags (copy), __interactionsRef (copy)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	scheduleInteractions(p110, p111, __interactionsRef.current)
end
function t3.startWorkOnPendingInteractions(p112, p113) -- line: 3820
	-- upvalues: ReactFeatureFlags (copy), Set (copy), includesSomeLane (copy), __subscriberRef (copy), describeError (copy), scheduleCallback (copy), ImmediatePriority (copy)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	local v497 = Set.new()

	p112.pendingInteractionMap:forEach(function(p114, p115) -- line: 3830
		-- upvalues: includesSomeLane (copy), p113 (copy), v497 (copy)
		if includesSomeLane(p113, p115) then
			p114:forEach(function(p116) -- line: 3832
				-- upvalues: v497 (copy)
				v497:add(p116)
			end)
		end
	end)
	p112.memoizedInteractions = v497

	if v497.size > 0 then
		local current7 = __subscriberRef.current

		if current7 ~= nil then
			local v499 = computeThreadID(p112, p113)
			local ok, result = xpcall(current7.onWorkStarted, describeError, v497, v499)

			if not ok then
				scheduleCallback(ImmediatePriority, function() -- line: 3854
					-- upvalues: result (copy)
					error(result)
				end)
			end
		end
	end
end
function t3.finishPendingInteractions(p117, p118) -- line: 3862
	-- upvalues: ReactFeatureFlags (copy), __subscriberRef (copy), describeError (copy), includesSomeLane (copy), scheduleCallback (copy), ImmediatePriority (copy)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	local pendingLanes = p117.pendingLanes
	local current8 = nil
	local v506 = true
	local u507 = nil

	if current8 ~= nil and p117.memoizedInteractions.size > 0 then
		local v508 = computeThreadID(p117, p118)

		current8 = __subscriberRef.current

		local result

		v506, result = xpcall(current8.onWorkStopped, describeError, p117.memoizedInteractions, v508)
		u507 = result
	end

	local pendingInteractionMap = p117.pendingInteractionMap

	pendingInteractionMap:forEach(function(p119, p120) -- line: 3893
		-- upvalues: includesSomeLane (copy), pendingLanes (copy), pendingInteractionMap (copy), current8 (ref), describeError (copy), scheduleCallback (copy), ImmediatePriority (copy)
		if not includesSomeLane(pendingLanes, p120) then
			pendingInteractionMap:delete(p120)
			p119:forEach(function(p121) -- line: 3899
				-- upvalues: current8 (ref), describeError (copy), scheduleCallback (copy), ImmediatePriority (copy)
				p121.__count = p121.__count - 1

				if current8 ~= nil and p121.__count == 0 then
					local ok, result = xpcall(current8.onInteractionScheduledWorkCompleted, describeError, p121)

					if not ok then
						scheduleCallback(ImmediatePriority, function() -- line: 3910
							-- upvalues: result (copy)
							error(result)
						end)
					end
				end
			end)
		end
	end)

	if not v506 then
		scheduleCallback(ImmediatePriority, function() -- line: 3922
			-- upvalues: u507 (ref)
			error(u507)
		end)
	end
end

local u175 = false
local u176 = false
local unstable_flushAllWithoutAsserting = Scheduler.unstable_flushAllWithoutAsserting
local v178 = typeof(unstable_flushAllWithoutAsserting) == "function"

local function flushActWork() -- line: 3941
	-- upvalues: unstable_flushAllWithoutAsserting (copy), u175 (ref), describeError (copy), t1 (copy)
	if unstable_flushAllWithoutAsserting ~= nil then
		local v511 = u175

		u175 = true

		local ok, result = xpcall(unstable_flushAllWithoutAsserting, describeError)

		u175 = v511

		if not ok then
			error(result)

			return
		end

		return result
	end

	local v514 = u175

	u175 = true

	local ok, result = xpcall(function() -- line: 3961
		-- upvalues: t1 (copy)
		local v548 = false

		while t1.flushPassiveEffects() do
			v548 = true
		end

		return v548
	end, describeError)

	u175 = v514

	if not ok then
		error(result)

		return
	end

	return result
end
local function flushWorkAndMicroTasks(p122: ((...any) -> ...any)) -- line: 3980
	-- upvalues: flushActWork (copy), describeError (copy), enqueueTask (copy), flushWorkAndMicroTasks (copy)
	local ok, result = xpcall(flushActWork, describeError)

	if ok then
		ok, result = xpcall(enqueueTask, describeError, function() -- line: 3984
			-- upvalues: flushActWork (copy), flushWorkAndMicroTasks (copy), p122 (copy)
			if flushActWork() then
				flushWorkAndMicroTasks(p122)

				return
			end

			p122()
		end)
	end

	if not ok then
		p122(result)
	end
end

function t1.act(p123: ((...any) -> ...any)) -- line: 3998
	-- upvalues: __DEV__ (copy), ReactGlobals (copy), u166 (ref), console (copy), n9 (ref), IsSomeRendererActing (copy), t1 (copy), u176 (ref), describeError (copy), Promise (copy), v178 (copy), flushWorkAndMicroTasks (copy), flushActWork (copy)
	if not __DEV__ and (not ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ and u166 == false) then
		u166 = true
		console.error("act(...) is not supported in production builds of React, and might not behave as expected.")
	end

	local v521 = n9

	n9 += 1

	local current9 = IsSomeRendererActing.current
	local current10 = t1.IsThisRendererActing.current
	local v524 = u176

	IsSomeRendererActing.current = true
	t1.IsThisRendererActing.current = true
	u176 = true

	local function onDone() -- line: 4023
		-- upvalues: n9 (ref), IsSomeRendererActing (copy), current9 (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy)
		n9 -= 1
		IsSomeRendererActing.current = current9
		t1.IsThisRendererActing.current = current10
		u176 = v524

		if __DEV__ and n9 > v521 then
			console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
		end
	end

	local ok, result = xpcall(t1.batchedUpdates, describeError, p123)

	if not ok then
		n9 -= 1
		IsSomeRendererActing.current = current9
		t1.IsThisRendererActing.current = current10
		u176 = v524

		if __DEV__ and v521 < n9 then
			console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
		end

		error(result)
	end

	if result ~= nil and typeof(result) == "table" and typeof(result.andThen) == "function" then
		local u528 = false

		if __DEV__ and typeof(Promise) ~= nil then
			Promise.resolve():andThen(function() -- line: 4056
			end):andThen(function() -- line: 4056
				-- upvalues: u528 (ref), console (copy)
				if u528 == false then
					console.error("You called act(Promise.new(function() --[[ ... ]] end)) without :await() or :expect(). This could lead to unexpected testing behaviour, interleaving multiple act calls and mixing their scopes. You should - act(function() Promise.new(function() --[[ ... ]] end):await() end);")
				end
			end)
		end

		return {
			andThen = function(_, p125, p126) -- line: 4075
				-- upvalues: u528 (ref), result (copy), n9 (ref), v178 (copy), current9 (copy), IsSomeRendererActing (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy), flushWorkAndMicroTasks (copy)
				u528 = true

				return result:andThen(function() -- line: 4077
					-- upvalues: n9 (ref), v178 (copy), current9 (copy), IsSomeRendererActing (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy), p125 (copy), flushWorkAndMicroTasks (copy), p126 (copy)
					if n9 > 1 or v178 == true and current9 == true then
						n9 -= 1
						IsSomeRendererActing.current = current9
						t1.IsThisRendererActing.current = current10
						u176 = v524

						if __DEV__ and n9 > v521 then
							console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
						end

						p125()

						return
					end

					flushWorkAndMicroTasks(function(p127) -- line: 4091
						-- upvalues: n9 (ref), IsSomeRendererActing (copy), current9 (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy), p126 (copy), p125 (copy)
						n9 -= 1
						IsSomeRendererActing.current = current9
						t1.IsThisRendererActing.current = current10
						u176 = v524

						if __DEV__ and n9 > v521 then
							console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
						end

						if p127 then
							p126(p127)

							return
						end

						p125()
					end)
				end, function(p128) -- line: 4099
					-- upvalues: n9 (ref), IsSomeRendererActing (copy), current9 (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy), p126 (copy)
					n9 -= 1
					IsSomeRendererActing.current = current9
					t1.IsThisRendererActing.current = current10
					u176 = v524

					if __DEV__ and n9 > v521 then
						console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
					end

					p126(p128)
				end)
			end
		}
	end

	if __DEV__ and result ~= nil then
		console.error("The callback passed to act(...) function must return nil, or a Promise. You returned %s", (tostring(result)))
	end

	local ok2, result2 = xpcall(function() -- line: 4118
		-- upvalues: n9 (ref), v178 (copy), current9 (copy), flushActWork (copy), IsSomeRendererActing (copy), t1 (copy), current10 (copy), u176 (ref), v524 (copy), __DEV__ (copy), v521 (copy), console (copy)
		if n9 == 1 and (v178 == false or current9 == false) then
			flushActWork()
		end

		n9 -= 1
		IsSomeRendererActing.current = current9
		t1.IsThisRendererActing.current = current10
		u176 = v524

		if __DEV__ and n9 > v521 then
			console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
		end
	end, describeError)

	if not ok2 then
		n9 -= 1
		IsSomeRendererActing.current = current9
		t1.IsThisRendererActing.current = current10
		u176 = v524

		if __DEV__ and v521 < n9 then
			console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
		end

		error(result2)
	end

	return {
		andThen = function(_, p130, _) -- line: 4138
			-- upvalues: __DEV__ (copy), console (copy)
			if __DEV__ then
				console.error("Do not await the result of calling act(...) with sync logic, it is not a Promise.")
			end

			p130()
		end
	}
end
function t3.detachFiberAfterEffects(p132) -- line: 4150
	-- upvalues: enableNewTreeCleanupPath (copy), t3 (copy), deletedTreeCleanUpLevel (copy), __DEV__ (copy)
	if enableNewTreeCleanupPath then
		local alternate = p132.alternate

		if alternate ~= nil then
			p132.alternate = nil
			t3.detachFiberAfterEffects(alternate)
		end
	end

	if not enableNewTreeCleanupPath or not (deletedTreeCleanUpLevel >= 2) then
		p132.child = nil
		p132.deletions = nil
		p132.dependencies = nil
		p132.memoizedProps = nil
		p132.memoizedState = nil
		p132.pendingProps = nil
		p132.sibling = nil
		p132.stateNode = nil
		p132.updateQueue = nil

		if __DEV__ then
			p132._debugOwner = nil

			return
		end
	else
		p132.child = nil
		p132.deletions = nil
		p132.sibling = nil

		if __DEV__ then
			p132._debugOwner = nil
		end

		if deletedTreeCleanUpLevel >= 3 then
			p132.return_ = nil
			p132.dependencies = nil
			p132.memoizedProps = nil
			p132.memoizedState = nil
			p132.pendingProps = nil
			p132.stateNode = nil
			p132.updateQueue = nil
		end
	end
end

return t1
