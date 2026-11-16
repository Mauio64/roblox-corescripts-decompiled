local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console
local LuauPolyfill = require(parent.LuauPolyfill)
local Set = LuauPolyfill.Set

local __DEV__ = ReactGlobals.__DEV__
local __YOLO__ = ReactGlobals.__YOLO__

local New = {}

require(parent.Shared)

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

local Scheduler = require(parent.Scheduler)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactFiberStacknew = require(script.Parent["ReactFiberStack.new"])

local Shared2 = require(parent.Shared)
local ReactFeatureFlags = Shared2.ReactFeatureFlags

local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local skipUnmountedBoundaries = ReactFeatureFlags.skipUnmountedBoundaries
local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local deletedTreeCleanUpLevel = ReactFeatureFlags.deletedTreeCleanUpLevel
local enableNewTreeCleanupPath = ReactFeatureFlags.enableNewTreeCleanupPath
local Shared3 = require(parent.Shared)

local Shared4 = require(parent.Shared)
local describeError = Shared4.describeError
local ReactSharedInternals = Shared3.ReactSharedInternals
local invariant = Shared3.invariant

local SchedulerWithReactIntegrationnew = require(script.Parent["SchedulerWithReactIntegration.new"])
local scheduleCallback = SchedulerWithReactIntegrationnew.scheduleCallback
local cancelCallback = SchedulerWithReactIntegrationnew.cancelCallback
local getCurrentPriorityLevel = SchedulerWithReactIntegrationnew.getCurrentPriorityLevel
local runWithPriority = SchedulerWithReactIntegrationnew.runWithPriority
local shouldYield = SchedulerWithReactIntegrationnew.shouldYield
local requestPaint = SchedulerWithReactIntegrationnew.requestPaint
local now = SchedulerWithReactIntegrationnew.now
local NoPriority = SchedulerWithReactIntegrationnew.NoPriority
local ImmediatePriority = SchedulerWithReactIntegrationnew.ImmediatePriority
local UserBlockingPriority = SchedulerWithReactIntegrationnew.UserBlockingPriority
local NormalPriority = SchedulerWithReactIntegrationnew.NormalPriority
local flushSyncCallbackQueue = SchedulerWithReactIntegrationnew.flushSyncCallbackQueue
local scheduleSyncCallback = SchedulerWithReactIntegrationnew.scheduleSyncCallback

local DebugTracing = require(script.Parent.DebugTracing)

local SchedulingProfiler = require(script.Parent.SchedulingProfiler)

local Scheduler2 = require(parent.Scheduler)
local tracing = Scheduler2.tracing

local __interactionsRef = tracing.__interactionsRef
local __subscriberRef = tracing.__subscriberRef

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

local ReactFibernew = require(script.Parent["ReactFiber.new"])

local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)

local ReactWorkTags = require(script.Parent.ReactWorkTags)

local ReactRootTags = require(script.Parent.ReactRootTags)
local LegacyRoot = ReactRootTags.LegacyRoot
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)

local SyncLane = ReactFiberLane.SyncLane
local SyncBatchedLane = ReactFiberLane.SyncBatchedLane
local NoTimestamp = ReactFiberLane.NoTimestamp
local findUpdateLane = ReactFiberLane.findUpdateLane
local findTransitionLane = ReactFiberLane.findTransitionLane
local findRetryLane = ReactFiberLane.findRetryLane
local includesSomeLane = ReactFiberLane.includesSomeLane
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local mergeLanes = ReactFiberLane.mergeLanes
local removeLanes = ReactFiberLane.removeLanes
local pickArbitraryLane = ReactFiberLane.pickArbitraryLane
local hasDiscreteLanes = ReactFiberLane.hasDiscreteLanes
local includesNonIdleWork = ReactFiberLane.includesNonIdleWork
local includesOnlyRetries = ReactFiberLane.includesOnlyRetries
local includesOnlyTransitions = ReactFiberLane.includesOnlyTransitions
local getNextLanes = ReactFiberLane.getNextLanes
local returnNextLanesPriority = ReactFiberLane.returnNextLanesPriority
local setCurrentUpdateLanePriority = ReactFiberLane.setCurrentUpdateLanePriority
local getCurrentUpdateLanePriority = ReactFiberLane.getCurrentUpdateLanePriority
local markStarvedLanesAsExpired = ReactFiberLane.markStarvedLanesAsExpired

local getLanesToRetrySynchronouslyOnError = ReactFiberLane.getLanesToRetrySynchronouslyOnError
local markRootUpdated = ReactFiberLane.markRootUpdated
local markRootPinged = ReactFiberLane.markRootPinged
local markRootExpired = ReactFiberLane.markRootExpired
local markDiscreteUpdatesExpired = ReactFiberLane.markDiscreteUpdatesExpired
local markRootFinished = ReactFiberLane.markRootFinished
local schedulerPriorityToLanePriority = ReactFiberLane.schedulerPriorityToLanePriority
local lanePriorityToSchedulerPriority = ReactFiberLane.lanePriorityToSchedulerPriority
local ReactFiberTransition = require(script.Parent.ReactFiberTransition)

local ReactFiberUnwindWorknew = require(script.Parent["ReactFiberUnwindWork.new"])
local unwindWork = ReactFiberUnwindWorknew.unwindWork
local unwindInterruptedWork = ReactFiberUnwindWorknew.unwindInterruptedWork
local ReactFiberThrownew = require(script.Parent["ReactFiberThrow.new"])
local throwException = ReactFiberThrownew.throwException
local createRootErrorUpdate = ReactFiberThrownew.createRootErrorUpdate
local createClassErrorUpdate = ReactFiberThrownew.createClassErrorUpdate
local ReactFiberCommitWorknew = require(script.Parent["ReactFiberCommitWork.new"])

local commitBeforeMutationLifeCycles = ReactFiberCommitWorknew.commitBeforeMutationLifeCycles
local commitPlacement = ReactFiberCommitWorknew.commitPlacement
local commitWork = ReactFiberCommitWorknew.commitWork
local commitDeletion = ReactFiberCommitWorknew.commitDeletion
local commitPassiveUnmount = ReactFiberCommitWorknew.commitPassiveUnmount

local commitPassiveUnmountInsideDeletedTree = ReactFiberCommitWorknew.commitPassiveUnmountInsideDeletedTree
local commitPassiveMount = ReactFiberCommitWorknew.commitPassiveMount
local commitDetachRef = ReactFiberCommitWorknew.commitDetachRef

local invokeLayoutEffectMountInDEV = ReactFiberCommitWorknew.invokeLayoutEffectMountInDEV
local invokePassiveEffectMountInDEV = ReactFiberCommitWorknew.invokePassiveEffectMountInDEV
local invokeLayoutEffectUnmountInDEV = ReactFiberCommitWorknew.invokeLayoutEffectUnmountInDEV

local invokePassiveEffectUnmountInDEV = ReactFiberCommitWorknew.invokePassiveEffectUnmountInDEV
local recursivelyCommitLayoutEffects = ReactFiberCommitWorknew.recursivelyCommitLayoutEffects

local Promise = require(parent.Promise)

local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])
local enqueueUpdate = ReactUpdateQueuenew.enqueueUpdate

local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
local resetContextDependencies = ReactFiberNewContextnew.resetContextDependencies

local RobloxReactProfiling = require(script.Parent.RobloxReactProfiling)

local fn

local v = {
	resetHooksAfterThrowRef = nil,
	ContextOnlyDispatcherRef = nil,
	getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = nil,
	originalBeginWorkRef = nil,
	completeWorkRef = nil
}

local function fn2(p, p2, p3)
	if not v.originalBeginWorkRef then
		local v2 = v
		local ReactFiberBeginWorknew = require(script.Parent["ReactFiberBeginWork.new"])
		v2.originalBeginWorkRef = ReactFiberBeginWorknew.beginWork
	end

	return v.originalBeginWorkRef(p, p2, p3)
end

local v2 = nil

local function initReactFiberHooks() -- 5 equivalent calls inferred from this helper
	local ReactFiberHooksnew = require(script.Parent["ReactFiberHooks.new"])
	v2 = ReactFiberHooksnew
	v.resetHooksAfterThrowRef = v2.resetHooksAfterThrow
	v.ContextOnlyDispatcherRef = v2.ContextOnlyDispatcher
	v.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef = v2.getIsUpdatingOpaqueValueInRenderPhaseInDEV
end

local ReactCapturedValue = require(script.Parent.ReactCapturedValue)
local createCapturedValue = ReactCapturedValue.createCapturedValue
local push = ReactFiberStacknew.push
local pop = ReactFiberStacknew.pop
local createCursor = ReactFiberStacknew.createCursor

local ReactProfilerTimernew = require(script.Parent["ReactProfilerTimer.new"])

local Shared5 = require(parent.Shared)
local getComponentName = Shared5.getComponentName
local ReactStrictModeWarningsnew = require(script.Parent["ReactStrictModeWarnings.new"])
local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)

local current = ReactCurrentFiber.current
local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber
local Shared6 = require(parent.Shared)
local ReactErrorUtils = Shared6.ReactErrorUtils
local invokeGuardedCallback = ReactErrorUtils.invokeGuardedCallback
local hasCaughtError = ReactErrorUtils.hasCaughtError
local clearCaughtError = ReactErrorUtils.clearCaughtError

local ReactFiberDevToolsHooknew = require(script.Parent["ReactFiberDevToolsHook.new"])
local onCommitRoot = ReactFiberDevToolsHooknew.onCommitRoot
local ReactTestSelectors = require(script.Parent.ReactTestSelectors)
local onCommitRoot2 = ReactTestSelectors.onCommitRoot

local Shared7 = require(parent.Shared)
local enqueueTask = Shared7.enqueueTask
local ReactFiberTreeReflection = require(script.Parent.ReactFiberTreeReflection)
local doesFiberContain = ReactFiberTreeReflection.doesFiberContain

local ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
local ReactCurrentOwner = ReactSharedInternals.ReactCurrentOwner
local IsSomeRendererActing = ReactSharedInternals.IsSomeRendererActing
local fn3
local fn4

local v3 = {}

v3.MutationWorkFlags = bit32.bor(
	ReactFiberFlags.Placement,
	ReactFiberFlags.Update,
	ReactFiberFlags.Ref,
	ReactFiberFlags.HostUpdate
)

New.NoContext = 0
New.RetryAfterError = 64

local _ = {
	Incomplete = 0,
	FatalErrored = 1,
	Errored = 2,
	Suspended = 3,
	SuspendedWithDelay = 4,
	Completed = 5
}

local v4 = 0

local v5 = nil

local v6 = nil

local v7 = ReactFiberLane.NoLanes

New.subtreeRenderLanes = ReactFiberLane.NoLanes
local cursor = createCursor(ReactFiberLane.NoLanes)

local v8 = 0

local v9 = nil

local v10 = ReactFiberLane.NoLanes

local ReactFiberWorkInProgress = require(script.Parent.ReactFiberWorkInProgress)

local workInProgressRootSkippedLanes = ReactFiberWorkInProgress.workInProgressRootSkippedLanes

local NoLanes = ReactFiberLane.NoLanes

local noLanes = ReactFiberLane.NoLanes

local v11 = nil

local v12 = 0

local v13 = 1e999

local v14 = nil

local function resetRenderTimer() -- 10 equivalent calls inferred from this helper
	v13 = now() + 500
end

function New.getRenderTargetTime()
	return v13
end

local flag = false
local v15 = nil
local v16 = nil

local flag2 = false
local v17 = nil
local v18 = NoPriority
local v19 = ReactFiberLane.NoLanes

local v20 = nil

local count = 0
local v21 = nil

local count2 = 0

local v22 = nil

local v23 = NoTimestamp
local v24 = ReactFiberLane.NoLanes
local v25 = ReactFiberLane.NoLanes

local v26 = nil
local flag3 = false

function New.getWorkInProgressRoot()
	return v5
end

function New.requestEventTime()
	if bit32.band(v4, 48) ~= 0 then
		return now()
	end

	if v23 ~= NoTimestamp then
		return v23
	end

	v23 = now()
	return v23
end

function New.requestUpdateLane(p)
	local mode = p.mode

	if bit32.band(mode, ReactTypeOfMode.BlockingMode) == ReactTypeOfMode.NoMode then
		return SyncLane
	end

	if bit32.band(mode, ReactTypeOfMode.ConcurrentMode) == ReactTypeOfMode.NoMode then
		if getCurrentPriorityLevel() == ImmediatePriority then
			return SyncLane
		end

		return SyncBatchedLane
	end

	if
		not ReactFeatureFlags.deferRenderPhaseUpdateToNextBatch
		and bit32.band(v4, 16) ~= 0
		and v7 ~= ReactFiberLane.NoLanes
	then
		return pickArbitraryLane(v7)
	end

	if v24 == ReactFiberLane.NoLanes then
		v24 = v10
	end

	if ReactFiberTransition.requestCurrentTransition() ~= ReactFiberTransition.NoTransition then
		if v25 ~= ReactFiberLane.NoLanes then
			if v11 == nil then
				v25 = ReactFiberLane.NoLanes
			else
				v25 = v11.pendingLanes
			end
		end

		return findTransitionLane(v24, v25)
	else
		local currentPriorityLevel = getCurrentPriorityLevel()

		if bit32.band(v4, 4) ~= 0 and currentPriorityLevel == UserBlockingPriority then
			return (findUpdateLane(ReactFiberLane.InputDiscreteLanePriority, v24))
		end

		local v27 = schedulerPriorityToLanePriority(currentPriorityLevel)

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
			local currentUpdateLanePriority = getCurrentUpdateLanePriority()

			if
				v27 ~= currentUpdateLanePriority
				and currentUpdateLanePriority ~= ReactFiberLane.NoLanePriority
				and __DEV__
			then
				console.error(
					"Expected current scheduler lane priority %s to match current update lane priority %s",
					tostring(v27),
					(tostring(currentUpdateLanePriority))
				)
			end
		end

		return (findUpdateLane(v27, v24))
	end
end

function requestRetryLane(p)
	local mode = p.mode

	if bit32.band(mode, ReactTypeOfMode.BlockingMode) == ReactTypeOfMode.NoMode then
		return SyncLane
	end

	if bit32.band(mode, ReactTypeOfMode.ConcurrentMode) == ReactTypeOfMode.NoMode then
		if getCurrentPriorityLevel() == ImmediatePriority then
			return SyncLane
		end

		return SyncBatchedLane
	end

	if v24 == ReactFiberLane.NoLanes then
		v24 = v10
	end

	return findRetryLane(v24)
end

function New.scheduleUpdateOnFiber(p, p2, p3: number)
	v3.checkForNestedUpdates()

	local v27 = v3.markUpdateLaneFromFiberToRoot(p, p2)

	if v27 == nil then
		return nil
	end

	markRootUpdated(v27, p2, p3)

	if v27 == v5 then
		v3.warnAboutRenderPhaseUpdatesInDEV(p)

		if ReactFeatureFlags.deferRenderPhaseUpdateToNextBatch or bit32.band(v4, 16) == 0 then
			NoLanes = mergeLanes(NoLanes, p2)
		end

		if v8 == 4 then
			v3.markRootSuspended(v27, v7)
		end
	end

	local currentPriorityLevel = getCurrentPriorityLevel()

	if p2 == SyncLane then
		if bit32.band(v4, 8) == 0 or bit32.band(v4, 48) ~= 0 then
			fn(v27, p3)
			v3.schedulePendingInteractions(v27, p2)

			if v4 == 0 then
				resetRenderTimer() -- inferred equivalent call
				flushSyncCallbackQueue()
			end
		else
			v3.schedulePendingInteractions(v27, p2)

			v3.performSyncWorkOnRoot(v27)
		end
	else
		if
			bit32.band(v4, 4) ~= 0
			and (currentPriorityLevel == UserBlockingPriority or currentPriorityLevel == ImmediatePriority)
		then
			if v20 == nil then
				v20 = Set.new({ v27 })
			else
				v20:add(v27)
			end
		end

		fn(v27, p3)
		v3.schedulePendingInteractions(v27, p2)
	end

	v11 = v27
	return v27
end

function v3:markUpdateLaneFromFiberToRoot(p)
	self.lanes = mergeLanes(self.lanes, p)
	local alternate = self.alternate

	if alternate ~= nil then
		alternate.lanes = mergeLanes(alternate.lanes, p)
	end

	if
		__DEV__
		and alternate == nil
		and bit32.band(self.flags, (bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Hydrating))) ~= ReactFiberFlags.NoFlags
	then
		v3.warnAboutUpdateOnNotYetMountedFiberInDEV(self)
	end

	local v27 = self.return_
	local v28 = self

	while v27 ~= nil do
		v27.childLanes = mergeLanes(v27.childLanes, p)
		local alternate2 = v27.alternate

		if alternate2 == nil then
			if
				__DEV__
				and bit32.band(v27.flags, (bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Hydrating))) ~= ReactFiberFlags.NoFlags
			then
				v3.warnAboutUpdateOnNotYetMountedFiberInDEV(self)
			end
		else
			alternate2.childLanes = mergeLanes(alternate2.childLanes, p)
		end

		v28 = v27
		v27 = v27.return_
	end

	if v28.tag == ReactWorkTags.HostRoot then
		return v28.stateNode
	end

	return nil
end

fn = function(state, p: number)
	local callbackNode = state.callbackNode

	markStarvedLanesAsExpired(state, p)

	local v27 = if state == v5 then v7 else ReactFiberLane.NoLanes

	local nextLanes = getNextLanes(state, v27)

	local callbackPriority = returnNextLanesPriority()

	if nextLanes == ReactFiberLane.NoLanes then
		if callbackNode ~= nil then
			cancelCallback(callbackNode)
			state.callbackNode = nil
			state.callbackPriority = ReactFiberLane.NoLanePriority
		end
	else
		if callbackNode ~= nil then
			if state.callbackPriority == callbackPriority then
				return
			end

			cancelCallback(callbackNode)
		end

		local callbackNode2

		if callbackPriority == ReactFiberLane.SyncLanePriority then
			callbackNode2 = scheduleSyncCallback(function()
				local profileRootBeforeUnitOfWork = RobloxReactProfiling.profileRootBeforeUnitOfWork(state)
				local v28 = v3.performSyncWorkOnRoot(state)
				RobloxReactProfiling.profileRootAfterYielding(profileRootBeforeUnitOfWork)
				return v28
			end)
		elseif callbackPriority == ReactFiberLane.SyncBatchedLanePriority then
			callbackNode2 = scheduleCallback(ImmediatePriority, function()
				local profileRootBeforeUnitOfWork = RobloxReactProfiling.profileRootBeforeUnitOfWork(state)
				local v28 = v3.performSyncWorkOnRoot(state)
				RobloxReactProfiling.profileRootAfterYielding(profileRootBeforeUnitOfWork)
				return v28
			end)
		else
			callbackNode2 = scheduleCallback(lanePriorityToSchedulerPriority(callbackPriority), function()
				local profileRootBeforeUnitOfWork = RobloxReactProfiling.profileRootBeforeUnitOfWork(state)
				local v28 = v3.performConcurrentWorkOnRoot(state)
				RobloxReactProfiling.profileRootAfterYielding(profileRootBeforeUnitOfWork)
				return v28
			end)
		end

		state.callbackPriority = callbackPriority
		state.callbackNode = callbackNode2
	end
end

function v3:performConcurrentWorkOnRoot()
	v23 = NoTimestamp
	v24 = ReactFiberLane.NoLanes
	v25 = ReactFiberLane.NoLanes

	invariant(bit32.band(v4, 48) == 0, "Should not already be working.")

	local callbackNode = self.callbackNode

	if New.flushPassiveEffects() and self.callbackNode ~= callbackNode then
		return nil
	end

	local v27 = if self == v5 then v7 else ReactFiberLane.NoLanes
	local finishedLanes = getNextLanes(self, v27)

	if finishedLanes == ReactFiberLane.NoLanes then
		return nil
	end

	local v28 = v3.renderRootConcurrent(self, finishedLanes)

	if includesSomeLane(v10, NoLanes) then
		v3.prepareFreshStack(self, ReactFiberLane.NoLanes)
	elseif v28 ~= 0 then
		if v28 == 2 then
			v4 = bit32.bor(v4, 64)

			if self.hydrate then
				self.hydrate = false
				ReactFiberHostConfig.clearContainer(self.containerInfo)
			end

			finishedLanes = getLanesToRetrySynchronouslyOnError(self)

			if finishedLanes ~= ReactFiberLane.NoLanes then
				v28 = v3.renderRootSync(self, finishedLanes)
			end
		end

		if v28 == 1 then
			local v29 = v9
			v3.prepareFreshStack(self, ReactFiberLane.NoLanes)
			v3.markRootSuspended(self, finishedLanes)
			fn(self, now())
			error(v29)
		end

		self.finishedWork = self.current.alternate
		self.finishedLanes = finishedLanes
		v3.finishConcurrentRender(self, v28, finishedLanes)
	end

	fn(self, now())

	if self.callbackNode == callbackNode then
		return function()
			local profileRootBeforeUnitOfWork = RobloxReactProfiling.profileRootBeforeUnitOfWork(self)
			local v29 = v3.performConcurrentWorkOnRoot(self)
			RobloxReactProfiling.profileRootAfterYielding(profileRootBeforeUnitOfWork)
			return v29
		end
	end

	return nil
end

local v27 = 0
local v28 = false

function shouldForceFlushFallbacksInDEV()
	return __DEV__ and v27 > 0
end

function v3:finishConcurrentRender(p, p2)
	if p == 0 or p == 1 then
		invariant(false, "Root did not complete. This is a bug in React.")
	elseif p == 2 then
		v3.commitRoot(self)
	elseif p == 3 then
		v3.markRootSuspended(self, p2)

		if includesOnlyRetries(p2) and not shouldForceFlushFallbacksInDEV() then
			local v29 = v12 + 500 - now()

			if v29 > 10 then
				if getNextLanes(self, ReactFiberLane.NoLanes) ~= ReactFiberLane.NoLanes then
					return
				end

				local suspendedLanes = self.suspendedLanes

				if isSubsetOfLanes(suspendedLanes, p2) then
					self.timeoutHandle = ReactFiberHostConfig.scheduleTimeout(function()
						return v3.commitRoot(self)
					end, v29)
				else
					markRootPinged(self, suspendedLanes, (New.requestEventTime()))
				end

				return
			end
		end

		v3.commitRoot(self)
	elseif p == 4 then
		v3.markRootSuspended(self, p2)

		if includesOnlyTransitions(p2) then
			return
		end

		if not shouldForceFlushFallbacksInDEV() then
			local mostRecentEventTime = ReactFiberLane.getMostRecentEventTime(self, p2)

			local v29 = now() - mostRecentEventTime
			local v30 = jnd(v29) - v29

			if v30 > 10 then
				self.timeoutHandle = ReactFiberHostConfig.scheduleTimeout(function()
					return v3.commitRoot(self)
				end, v30)

				return
			end
		end

		v3.commitRoot(self)
	elseif p == 5 then
		v3.commitRoot(self)
	else
		invariant(false, "Unknown root exit status.")
	end
end

function v3.markRootSuspended(p, p2)
	local v29 = removeLanes(removeLanes(p2, noLanes), NoLanes)
	ReactFiberLane.markRootSuspended(p, v29)
end

function v3:performSyncWorkOnRoot(): nil
	invariant(bit32.band(v4, 48) == 0, "Should not already be working.")

	New.flushPassiveEffects()
	local finishedLanes, v29

	if self == v5 and includesSomeLane(self.expiredLanes, v7) then
		finishedLanes = v7
		v29 = v3.renderRootSync(self, finishedLanes)

		if includesSomeLane(v10, NoLanes) then
			finishedLanes = getNextLanes(self, finishedLanes)
			v29 = v3.renderRootSync(self, finishedLanes)
		end
	else
		finishedLanes = getNextLanes(self, ReactFiberLane.NoLanes)
		v29 = v3.renderRootSync(self, finishedLanes)
	end

	if self.tag ~= LegacyRoot and v29 == 2 then
		v4 = bit32.bor(v4, 64)

		if self.hydrate then
			self.hydrate = false
			ReactFiberHostConfig.clearContainer(self.containerInfo)
		end

		finishedLanes = getLanesToRetrySynchronouslyOnError(self)

		if finishedLanes ~= ReactFiberLane.NoLanes then
			v29 = v3.renderRootSync(self, finishedLanes)
		end
	end

	if v29 == 1 then
		local v30 = v9
		v3.prepareFreshStack(self, ReactFiberLane.NoLanes)
		v3.markRootSuspended(self, finishedLanes)
		fn(self, now())
		error(v30)
	end

	self.finishedWork = self.current.alternate
	self.finishedLanes = finishedLanes
	v3.commitRoot(self)

	fn(self, now())

	return nil
end

function New.flushRoot(p, p2)
	markRootExpired(p, p2)
	fn(p, now())

	if bit32.band(v4, 48) == 0 then
		resetRenderTimer() -- inferred equivalent call
		flushSyncCallbackQueue()
	end
end

function New.getExecutionContext()
	return v4
end

function New.flushDiscreteUpdates()
	if bit32.band(v4, 49) == 0 then
		v3.flushPendingDiscreteUpdates()

		New.flushPassiveEffects()
	elseif __DEV__ and bit32.band(v4, 16) ~= 0 then
		console.error("unstable_flushDiscreteUpdates: Cannot flush updates when React is already rendering.")
	end
end

function New.deferredUpdates(callback)
	if not ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		return runWithPriority(NormalPriority, callback)
	end

	local currentUpdateLanePriority = getCurrentUpdateLanePriority()
	local result, success

	if __YOLO__ then
		setCurrentUpdateLanePriority(ReactFiberLane.DefaultLanePriority)
		result = runWithPriority(NormalPriority, callback)
		success = true
	else
		setCurrentUpdateLanePriority(ReactFiberLane.DefaultLanePriority)

		success, result = xpcall(runWithPriority, describeError, NormalPriority, callback)
	end

	setCurrentUpdateLanePriority(currentUpdateLanePriority)

	if success then
		return result
	end

	error(result)
end

function v3.flushPendingDiscreteUpdates()
	if v20 ~= nil then
		local v29 = v20
		v20 = nil
		v29:forEach(function(p)
			markDiscreteUpdatesExpired(p)
			fn(p, now())
		end)
	end

	flushSyncCallbackQueue()
end

function New.batchedUpdates(callback, p)
	local v29 = v4
	v4 = bit32.bor(v4, 1)
	local result, success

	if __YOLO__ then
		result = callback(p)
		success = true
	else
		success, result = xpcall(callback, describeError, p)
	end

	v4 = v29

	if v4 == 0 then
		resetRenderTimer() -- inferred equivalent call
		flushSyncCallbackQueue()
	end

	if success then
		return result
	end

	error(result)
end

function New.batchedEventUpdates(callback, p)
	local v29 = v4
	v4 = bit32.bor(v4, 2)
	local result, success

	if __YOLO__ then
		result = callback(p)
		success = true
	else
		success, result = xpcall(callback, describeError, p)
	end

	v4 = v29

	if v4 == 0 then
		resetRenderTimer() -- inferred equivalent call
		flushSyncCallbackQueue()
	end

	if success then
		return result
	end

	error(result)
end

function New.discreteUpdates(callback, p, p2, p3, p4)
	local v29 = v4
	v4 = bit32.bor(v4, 4)

	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local currentUpdateLanePriority = getCurrentUpdateLanePriority()

		setCurrentUpdateLanePriority(ReactFiberLane.InputDiscreteLanePriority)
		local success, result = xpcall(runWithPriority, describeError, UserBlockingPriority, function()
			return callback(p, p2, p3, p4)
		end)

		setCurrentUpdateLanePriority(currentUpdateLanePriority)
		v4 = v29

		if v4 == 0 then
			resetRenderTimer() -- inferred equivalent call
			flushSyncCallbackQueue()
		end

		if success then
			return result
		end

		error(result)
	else
		local success, result = xpcall(runWithPriority, describeError, UserBlockingPriority, function()
			return callback(p, p2, p3, p4)
		end)

		v4 = v29

		if v4 == 0 then
			resetRenderTimer() -- inferred equivalent call
			flushSyncCallbackQueue()
		end

		if success then
			return result
		end

		error(result)
	end
end

function New.unbatchedUpdates(callback, p)
	local v29 = v4
	v4 = bit32.band(v4, 4294967294)
	v4 = bit32.bor(v4, 8)
	local result, success

	if __YOLO__ then
		result = callback(p)
		success = true
	else
		success, result = xpcall(callback, describeError, p)
	end

	v4 = v29

	if v4 == 0 then
		resetRenderTimer() -- inferred equivalent call
		flushSyncCallbackQueue()
	end

	if success then
		return result
	end

	error(result)
end

function New.flushSync(callback, p)
	local v29 = v4

	if bit32.band(v29, 48) == 0 then
		v4 = bit32.bor(v4, 1)

		if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
			local currentUpdateLanePriority = getCurrentUpdateLanePriority()

			setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)
			local success, result

			if __YOLO__ then
				success = true
				setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)

				if callback then
					result = runWithPriority(ImmediatePriority, function()
						return callback(p)
					end)
				end
			elseif callback then
				success, result = xpcall(runWithPriority, describeError, ImmediatePriority, function()
					return callback(p)
				end)
			else
				success = true
			end

			setCurrentUpdateLanePriority(currentUpdateLanePriority)
			v4 = v29

			flushSyncCallbackQueue()

			if not success then
				error(result)
			end

			return result
		else
			local success, result

			if __YOLO__ then
				success = true

				if callback then
					result = runWithPriority(ImmediatePriority, function()
						return callback(p)
					end)
				end
			elseif callback then
				success, result = xpcall(runWithPriority, describeError, ImmediatePriority, function()
					return callback(p)
				end)
			else
				success = true
			end

			v4 = v29

			flushSyncCallbackQueue()

			if not success then
				error(result)
			end

			return result
		end
	else
		if __DEV__ then
			console.error("flushSync was called from inside a lifecycle method. React cannot flush when React is already rendering. Consider moving this call to a scheduler task or micro task.")
		end

		return callback(p)
	end
end

function New.flushControlled(callback)
	local v29 = v4
	v4 = bit32.bor(v4, 1)

	if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		local currentUpdateLanePriority = getCurrentUpdateLanePriority()

		setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)

		local success, result = xpcall(runWithPriority, describeError, ImmediatePriority, callback)

		setCurrentUpdateLanePriority(currentUpdateLanePriority)

		v4 = v29

		if v4 == 0 then
			resetRenderTimer() -- inferred equivalent call
			flushSyncCallbackQueue()
		end

		if not success then
			error(result)
		end
	else
		local success, result = xpcall(runWithPriority, describeError, ImmediatePriority, callback)

		v4 = v29

		if v4 == 0 then
			resetRenderTimer() -- inferred equivalent call
			flushSyncCallbackQueue()
		end

		if not success then
			error(result)
		end
	end
end

function New.pushRenderLanes(p, p2)
	push(cursor, New.subtreeRenderLanes, p)
	New.subtreeRenderLanes = mergeLanes(New.subtreeRenderLanes, p2)
	v10 = mergeLanes(v10, p2)
end

function New.popRenderLanes(p)
	New.subtreeRenderLanes = cursor.current
	pop(cursor, p)
end

function v3:prepareFreshStack(subtreeRenderLanes)
	self.finishedWork = nil
	self.finishedLanes = ReactFiberLane.NoLanes

	local timeoutHandle = self.timeoutHandle

	if timeoutHandle ~= ReactFiberHostConfig.noTimeout then
		self.timeoutHandle = ReactFiberHostConfig.noTimeout

		ReactFiberHostConfig.cancelTimeout(timeoutHandle)
	end

	if v6 ~= nil then
		local return_ = v6.return_

		while return_ ~= nil do
			unwindInterruptedWork(return_)
			return_ = return_.return_
		end
	end

	v5 = self
	v6 = ReactFibernew.createWorkInProgress(self.current, nil)
	v7 = subtreeRenderLanes
	New.subtreeRenderLanes = subtreeRenderLanes
	v10 = subtreeRenderLanes
	v8 = 0
	v9 = nil
	workInProgressRootSkippedLanes(ReactFiberLane.NoLanes)
	NoLanes = ReactFiberLane.NoLanes
	noLanes = ReactFiberLane.NoLanes

	if ReactFeatureFlags.enableSchedulerTracing then
		v22 = nil
	end

	if __DEV__ then
		ReactStrictModeWarningsnew.discardPendingWarnings()
	end
end

function v3.handleError(p, p2)
	while true do
		local v29 = v6

		local success, result = pcall(function()
			resetContextDependencies()

			if not v.resetHooksAfterThrowRef then
				initReactFiberHooks() -- inferred equivalent call
			end

			v.resetHooksAfterThrowRef()

			resetCurrentFiber()

			ReactCurrentOwner.current = nil

			if v29 == nil or v29.return_ == nil then
				v8 = 1
				v9 = p2

				v6 = nil
			else
				if ReactFeatureFlags.enableProfilerTimer and bit32.band(v29.mode, ReactTypeOfMode.ProfileMode) ~= 0 then
					ReactProfilerTimernew.stopProfilerTimerIfRunningAndRecordDelta(v29, true)
				end

				throwException(p, v29.return_, v29, p2, v7, New.onUncaughtError, New.renderDidError)

				v3.completeUnitOfWork(v29)
			end
		end)

		if success then
			break
		end

		p2 = result

		if v6 == v29 and v29 ~= nil then
			v29 = v29.return_
			v6 = v29
		else
			v29 = v6
		end
	end
end

function v3.pushDispatcher()
	local current2 = ReactCurrentDispatcher.current

	local reactCurrentDispatcher = ReactCurrentDispatcher

	if not v.ContextOnlyDispatcherRef then
		initReactFiberHooks() -- inferred equivalent call
	end

	reactCurrentDispatcher.current = v.ContextOnlyDispatcherRef

	if current2 ~= nil then
		return current2
	end

	if not v.ContextOnlyDispatcherRef then
		initReactFiberHooks() -- inferred equivalent call
	end

	return v.ContextOnlyDispatcherRef
end

function v3.popDispatcher(current2)
	ReactCurrentDispatcher.current = current2
end

function v3.pushInteractions(p)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return nil
	end

	local current2 = __interactionsRef.current
	__interactionsRef.current = p.memoizedInteractions
	return current2
end

function v3.popInteractions(current2)
	if ReactFeatureFlags.enableSchedulerTracing then
		__interactionsRef.current = current2
	end
end

function New.markCommitTimeOfFallback()
	v12 = now()
end

function New.markSkippedUpdateLanes(p)
	ReactFiberWorkInProgress.markSkippedUpdateLanes(p)
end

function New.renderDidSuspend()
	if v8 == 0 then
		v8 = 3
	end
end

function New.renderDidSuspendDelayIfPossible()
	if v8 == 0 or v8 == 3 then
		v8 = 4
	end

	if v5 ~= nil and (includesNonIdleWork(workInProgressRootSkippedLanes()) or includesNonIdleWork(NoLanes)) then
		v3.markRootSuspended(v5, v7)
	end
end

function New.renderDidError()
	if v8 ~= 5 then
		v8 = 2
	end
end

function New.renderHasNotSuspendedYet(): boolean
	return v8 == 0
end

function v3.renderRootSync(p, p2)
	local v29 = v4
	v4 = bit32.bor(v4, 16)
	local v30 = v3.pushDispatcher()

	if v5 ~= p or v7 ~= p2 then
		v3.prepareFreshStack(p, p2)
		v3.startWorkOnPendingInteractions(p, p2)
	end

	local v31 = v3.pushInteractions(p)

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStarted(p2)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStarted(p2)
	end

	while true do
		local result = nil
		local success

		if __YOLO__ then
			v3.workLoopSync()
			success = true
		else
			success, result = xpcall(v3.workLoopSync, describeError)
		end

		if success then
			break
		end

		v3.handleError(p, result)
	end

	resetContextDependencies()

	if ReactFeatureFlags.enableSchedulerTracing then
		v3.popInteractions(v31)
	end

	v4 = v29
	v3.popDispatcher(v30)

	if v6 ~= nil then
		invariant(
			false,
			"Cannot commit an incomplete root. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStopped()
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStopped()
	end

	v5 = nil
	v7 = ReactFiberLane.NoLanes

	return v8
end

function v3.workLoopSync()
	while v6 ~= nil do
		v3.performUnitOfWork(v6)
	end
end

function v3.renderRootConcurrent(p, p2)
	local v29 = v4
	v4 = bit32.bor(v4, 16)
	local v30 = v3.pushDispatcher()

	if v5 ~= p or v7 ~= p2 then
		resetRenderTimer() -- inferred equivalent call
		v3.prepareFreshStack(p, p2)
		v3.startWorkOnPendingInteractions(p, p2)
	end

	local v31 = v3.pushInteractions(p)

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStarted(p2)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderStarted(p2)
	end

	while true do
		local result, success

		if __YOLO__ then
			v3.workLoopConcurrent()
			result = "break"
			success = true
		else
			success, result = xpcall(v3.workLoopConcurrent, describeError)

			if success then
				result = "break"
			end
		end

		if result == "break" then
			break
		end

		if not success then
			v3.handleError(p, result)
		end
	end

	resetContextDependencies()

	if ReactFeatureFlags.enableSchedulerTracing then
		v3.popInteractions(v31)
	end

	v3.popDispatcher(v30)
	v4 = v29

	if __DEV__ and enableDebugTracing then
		DebugTracing.logRenderStopped()
	end

	if v6 == nil then
		if enableSchedulingProfiler then
			SchedulingProfiler.markRenderStopped()
		end

		v5 = nil
		v7 = ReactFiberLane.NoLanes

		return v8
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markRenderYielded()
	end

	return 0
end

function v3.workLoopConcurrent()
	while v6 ~= nil and not shouldYield() do
		v3.performUnitOfWork(v6)
	end
end

if ReactFeatureFlags.enableWorkLoopTrims then
	function v3:performUnitOfWork()
		local enableUnitOfWorkProfiling = RobloxReactProfiling.enableUnitOfWorkProfiling
		local v29

		if enableUnitOfWorkProfiling then
			v29 = RobloxReactProfiling.profileUnitOfWorkBefore(self)
		end

		local alternate = self.alternate

		if __DEV__ then
			setCurrentFiber(self)
		end

		local v30

		if
			ReactFeatureFlags.enableProfilerTimer
			and bit32.band(self.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
		then
			ReactProfilerTimernew.startProfilerTimer(self)
			v30 = v3.beginWork(alternate, self, New.subtreeRenderLanes)
			ReactProfilerTimernew.stopProfilerTimerIfRunningAndRecordDelta(self, true)
		else
			v30 = v3.beginWork(alternate, self, New.subtreeRenderLanes)
		end

		if __DEV__ then
			resetCurrentFiber()
		end

		self.memoizedProps = self.pendingProps

		if v30 == nil then
			v3.completeUnitOfWork(self)
		else
			v6 = v30
		end

		ReactCurrentOwner.current = nil

		if enableUnitOfWorkProfiling then
			RobloxReactProfiling.profileUnitOfWorkAfter(v29)
		end
	end
else
	function v3:performUnitOfWork()
		local profileUnitOfWorkBefore = RobloxReactProfiling.profileUnitOfWorkBefore(self)

		local alternate = self.alternate
		setCurrentFiber(self)
		local v29

		if
			ReactFeatureFlags.enableProfilerTimer
			and bit32.band(self.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
		then
			ReactProfilerTimernew.startProfilerTimer(self)
			v29 = v3.beginWork(alternate, self, New.subtreeRenderLanes)
			ReactProfilerTimernew.stopProfilerTimerIfRunningAndRecordDelta(self, true)
		else
			v29 = v3.beginWork(alternate, self, New.subtreeRenderLanes)
		end

		resetCurrentFiber()
		self.memoizedProps = self.pendingProps

		if v29 == nil then
			v3.completeUnitOfWork(self)
		else
			v6 = v29
		end

		ReactCurrentOwner.current = nil

		RobloxReactProfiling.profileUnitOfWorkAfter(profileUnitOfWorkBefore)
	end
end

local function fn5(alternate, state, subtreeRenderLanes) -- 2 equivalent calls inferred from this helper
	if not v.completeWorkRef then
		local v29 = v
		local ReactFiberCompleteWorknew = require(script.Parent["ReactFiberCompleteWork.new"])
		v29.completeWorkRef = ReactFiberCompleteWorknew.completeWork
	end

	return v.completeWorkRef(alternate, state, subtreeRenderLanes)
end

function v3.completeUnitOfWork(state)
	while true do
		local alternate = state.alternate
		local return_ = state.return_

		if bit32.band(state.flags, ReactFiberFlags.Incomplete) == ReactFiberFlags.NoFlags then
			if ReactFeatureFlags.enableWorkLoopTrims then
				if __DEV__ then
					setCurrentFiber(state)
				end
			else
				setCurrentFiber(state)
			end

			local v29

			if
				ReactFeatureFlags.enableProfilerTimer
				and bit32.band(state.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
			then
				ReactProfilerTimernew.startProfilerTimer(state)
				v29 = fn5(alternate, state, New.subtreeRenderLanes) -- inferred equivalent call

				ReactProfilerTimernew.stopProfilerTimerIfRunningAndRecordDelta(state, false)
			else
				v29 = fn5(alternate, state, New.subtreeRenderLanes) -- inferred equivalent call
			end

			if ReactFeatureFlags.enableWorkLoopTrims then
				if __DEV__ then
					resetCurrentFiber()
				end
			else
				resetCurrentFiber()
			end

			if v29 ~= nil then
				v6 = v29
				break
			end
		else
			local v29 = unwindWork(state, New.subtreeRenderLanes)

			if v29 == nil then
				if
					ReactFeatureFlags.enableProfilerTimer
					and bit32.band(state.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
				then
					ReactProfilerTimernew.stopProfilerTimerIfRunningAndRecordDelta(state, false)

					local actualDuration = state.actualDuration or 0
					local v30 = state.child

					while v30 ~= nil do
						actualDuration += v30.actualDuration or 0
						v30 = v30.sibling
					end

					state.actualDuration = actualDuration
				end

				if return_ ~= nil then
					return_.flags = bit32.bor(return_.flags, ReactFiberFlags.Incomplete)
					return_.subtreeFlags = ReactFiberFlags.NoFlags
					return_.deletions = nil
				end
			else
				v29.flags = bit32.band(v29.flags, ReactFiberFlags.HostEffectMask)
				v6 = v29
				break
			end
		end

		local sibling = state.sibling

		if sibling ~= nil then
			v6 = sibling
			break
		end

		v6 = return_

		if return_ == nil then
			if v8 == 0 then
				v8 = 5
			end

			break
		end

		state = return_
	end
end

function v3.commitRoot(p): nil
	local currentPriorityLevel = getCurrentPriorityLevel()
	runWithPriority(ImmediatePriority, function()
		RobloxReactProfiling.profileCommitBefore()
		local commitRootImpl = v3.commitRootImpl(p, currentPriorityLevel)
		RobloxReactProfiling.profileCommitAfter()
		return commitRootImpl
	end)

	return nil
end

function v3:commitRootImpl(p): nil
	repeat
		New.flushPassiveEffects()
	until v17 == nil

	flushRenderPhaseStrictModeWarningsInDEV()

	invariant(bit32.band(v4, 48) == 0, "Should not already be working.")

	local finishedWork = self.finishedWork
	local finishedLanes = self.finishedLanes

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
			SchedulingProfiler.markCommitStopped(self)
		end

		return nil
	else
		self.finishedWork = nil
		self.finishedLanes = ReactFiberLane.NoLanes

		invariant(
			finishedWork ~= self.current,
			"Cannot commit the same tree as before. This error is likely caused by a bug in React. Please file an issue."
		)

		self.callbackNode = nil

		local v29 = mergeLanes(finishedWork.lanes, finishedWork.childLanes)
		markRootFinished(self, v29)

		if v20 ~= nil and not hasDiscreteLanes(v29) and v20:has(self) then
			v20:delete(self)
		end

		if self == v5 then
			v5 = nil
			v6 = nil
			v7 = ReactFiberLane.NoLanes
		end

		local v30 = bit32.band(
			finishedWork.subtreeFlags,
			(bit32.bor(
				ReactFiberFlags.BeforeMutationMask,
				ReactFiberFlags.MutationMask,
				ReactFiberFlags.LayoutMask,
				ReactFiberFlags.PassiveMask
			))
		) ~= ReactFiberFlags.NoFlags
		local v31 = bit32.band(
			finishedWork.flags,
			(bit32.bor(
				ReactFiberFlags.BeforeMutationMask,
				ReactFiberFlags.MutationMask,
				ReactFiberFlags.LayoutMask,
				ReactFiberFlags.PassiveMask
			))
		) ~= ReactFiberFlags.NoFlags

		if v30 or v31 then
			local v32

			if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
				v32 = getCurrentUpdateLanePriority()
				setCurrentUpdateLanePriority(ReactFiberLane.SyncLanePriority)
			end

			local v33 = v4
			v4 = bit32.bor(v4, 32)
			local v34 = v3.pushInteractions(self)

			ReactCurrentOwner.current = nil

			if
				ReactFeatureFlags.enableCommitTraversalTrims
				and bit32.band(bit32.bor(finishedWork.subtreeFlags, finishedWork.flags), ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags
				and not flag2
			then
				flag2 = true
				scheduleCallback(NormalPriority, function(): nil
					New.flushPassiveEffects()
					return nil
				end)
			end

			v26 = ReactFiberHostConfig.prepareForCommit(self.containerInfo)
			flag3 = false

			v3.commitBeforeMutationEffects(finishedWork)

			v26 = nil

			if ReactFeatureFlags.enableProfilerTimer then
				ReactProfilerTimernew.recordCommitTime()
			end

			v3.commitMutationEffects(finishedWork, self, p)

			if flag3 then
				ReactFiberHostConfig.afterActiveInstanceBlur()
			end

			ReactFiberHostConfig.resetAfterCommit(self.containerInfo)

			self.current = finishedWork

			if __DEV__ and enableDebugTracing then
				DebugTracing.logLayoutEffectsStarted(finishedLanes)
			end

			if enableSchedulingProfiler then
				SchedulingProfiler.markLayoutEffectsStarted(finishedLanes)
			end

			if __DEV__ then
				setCurrentFiber(finishedWork)
				invokeGuardedCallback(
					nil,
					recursivelyCommitLayoutEffects,
					nil,
					finishedWork,
					self,
					New.captureCommitPhaseError,
					New.schedulePassiveEffectCallback
				)

				if hasCaughtError() then
					local v35 = clearCaughtError()
					fn3(finishedWork, finishedWork, v35)
				end

				resetCurrentFiber()
			else
				local result = nil
				local success

				if __YOLO__ then
					recursivelyCommitLayoutEffects(
						finishedWork,
						self,
						New.captureCommitPhaseError,
						New.schedulePassiveEffectCallback
					)
					success = true
				else
					success, result = xpcall(
						recursivelyCommitLayoutEffects,
						describeError,
						finishedWork,
						self,
						New.captureCommitPhaseError,
						New.schedulePassiveEffectCallback
					)
				end

				if not success then
					fn3(finishedWork, finishedWork, result)
				end
			end

			if __DEV__ and enableDebugTracing then
				DebugTracing.logLayoutEffectsStopped()
			end

			if enableSchedulingProfiler then
				SchedulingProfiler.markLayoutEffectsStopped()
			end

			if
				(bit32.band(finishedWork.subtreeFlags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags or bit32.band(finishedWork.flags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags)
				and not flag2
			then
				flag2 = true
				scheduleCallback(NormalPriority, function(): nil
					New.flushPassiveEffects()
					return nil
				end)
			end

			requestPaint()

			if ReactFeatureFlags.enableSchedulerTracing then
				v3.popInteractions(v34)
			end

			v4 = v33

			if ReactFeatureFlags.decoupleUpdatePriorityFromScheduler and v32 ~= nil then
				setCurrentUpdateLanePriority(v32)
			end
		else
			self.current = finishedWork

			if ReactFeatureFlags.enableProfilerTimer then
				ReactProfilerTimernew.recordCommitTime()
			end
		end

		local v32 = flag2

		if flag2 then
			flag2 = false
			v17 = self
			v19 = finishedLanes
			v18 = p
		end

		local pendingLanes = self.pendingLanes

		if pendingLanes == ReactFiberLane.NoLanes then
			v16 = nil
		elseif ReactFeatureFlags.enableSchedulerTracing then
			if v22 ~= nil then
				local v33 = v22
				v22 = nil

				for i = 1, #v33 do
					scheduleInteractions(self, v33[i], self.memoizedInteractions)
				end
			end

			v3.schedulePendingInteractions(self, pendingLanes)
		end

		if __DEV__ and enableDoubleInvokingEffects and not v32 then
			commitDoubleInvokeEffectsInDEV(self.current, false)
		end

		if ReactFeatureFlags.enableSchedulerTracing and not v32 then
			v3.finishPendingInteractions(self, finishedLanes)
		end

		if pendingLanes == SyncLane then
			if self == v21 then
				count += 1
			else
				count = 0
				v21 = self
			end
		else
			count = 0
		end

		onCommitRoot(finishedWork.stateNode, p)

		if __DEV__ then
			onCommitRoot2()
		end

		fn(self, now())

		if flag then
			flag = false
			local v33 = v15
			v15 = nil

			error(v33)
		end

		if bit32.band(v4, 8) == 0 then
			flushSyncCallbackQueue()
		end

		if __DEV__ and enableDebugTracing then
			DebugTracing.logCommitStopped()
		end

		if enableSchedulingProfiler then
			SchedulingProfiler.markCommitStopped(self)
		end

		return nil
	end
end

function v3.commitBeforeMutationEffects(data)
	while data ~= nil do
		if data.deletions ~= nil then
			v3.commitBeforeMutationEffectsDeletions(data.deletions)
		end

		if
			data.child ~= nil
			and bit32.band(data.subtreeFlags, ReactFiberFlags.BeforeMutationMask) ~= ReactFiberFlags.NoFlags
		then
			v3.commitBeforeMutationEffects(data.child)
		end

		if ReactFeatureFlags.enableCommitTraversalTrims then
			if v26 ~= nil or bit32.band(data.flags, ReactFiberFlags.Snapshot) ~= ReactFiberFlags.NoFlags then
				if __DEV__ then
					setCurrentFiber(data)
					invokeGuardedCallback(nil, v3.commitBeforeMutationEffectsImpl, nil, data)

					if hasCaughtError() then
						local v29 = clearCaughtError()
						New.captureCommitPhaseError(data, data.return_, v29)
					end

					resetCurrentFiber()
				else
					local result = nil
					local success

					if __YOLO__ then
						v3.commitBeforeMutationEffectsImpl(data)
						success = true
					else
						success, result = xpcall(v3.commitBeforeMutationEffectsImpl, describeError, data)
					end

					if not success then
						New.captureCommitPhaseError(data, data.return_, result)
					end
				end
			end
		elseif __DEV__ then
			setCurrentFiber(data)
			invokeGuardedCallback(nil, v3.commitBeforeMutationEffectsImpl, nil, data)

			if hasCaughtError() then
				local v29 = clearCaughtError()
				New.captureCommitPhaseError(data, data.return_, v29)
			end

			resetCurrentFiber()
		else
			local result = nil
			local success

			if __YOLO__ then
				v3.commitBeforeMutationEffectsImpl(data)
				success = true
			else
				success, result = xpcall(v3.commitBeforeMutationEffectsImpl, describeError, data)
			end

			if not success then
				New.captureCommitPhaseError(data, data.return_, result)
			end
		end

		data = data.sibling
	end
end

function v3.commitBeforeMutationEffectsImpl(data)
	local alternate = data.alternate
	local flags = data.flags

	if
		not flag3
		and v26 ~= nil
		and data.tag == ReactWorkTags.SuspenseComponent
		and ReactFiberCommitWorknew.isSuspenseBoundaryBeingHidden(alternate, data)
		and doesFiberContain(data, v26)
	then
		flag3 = true
		ReactFiberHostConfig.beforeActiveInstanceBlur()
	end

	if bit32.band(flags, ReactFiberFlags.Snapshot) ~= ReactFiberFlags.NoFlags then
		setCurrentFiber(data)
		commitBeforeMutationLifeCycles(alternate, data)
		resetCurrentFiber()
	end

	if
		not ReactFeatureFlags.enableCommitTraversalTrims
		and bit32.band(flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags
		and not flag2
	then
		flag2 = true
		scheduleCallback(NormalPriority, function(): nil
			New.flushPassiveEffects()
			return nil
		end)
	end
end

function v3.commitBeforeMutationEffectsDeletions(list)
	for i = 1, #list do
		if not doesFiberContain(list[i], v26) then
			continue
		end

		flag3 = true
		ReactFiberHostConfig.beforeActiveInstanceBlur()
	end
end

function v3.commitMutationEffects(data, p, p2)
	while data ~= nil do
		local deletions = data.deletions

		if deletions ~= nil then
			for _, deletion in deletions do
				local success, result = xpcall(commitDeletion, describeError, p, deletion, data, p2)

				if not success then
					New.captureCommitPhaseError(deletion, data, result)
				end
			end
		end

		if
			data.child ~= nil
			and bit32.band(data.subtreeFlags, ReactFiberFlags.MutationMask) ~= ReactFiberFlags.NoFlags
		then
			v3.commitMutationEffects(data.child, p, p2)
		end

		if ReactFeatureFlags.enableCommitTraversalTrims then
			if bit32.band(data.flags, v3.MutationWorkFlags) ~= ReactFiberFlags.NoFlags then
				if __DEV__ then
					setCurrentFiber(data)
					invokeGuardedCallback(nil, v3.commitMutationEffectsImpl, nil, data, p, p2)

					if hasCaughtError() then
						local v29 = clearCaughtError()
						New.captureCommitPhaseError(data, data.return_, v29)
					end

					resetCurrentFiber()
				else
					local result = nil
					local success

					if __YOLO__ then
						v3.commitMutationEffectsImpl(data, p, p2)
						success = true
					else
						success, result = xpcall(v3.commitMutationEffectsImpl, describeError, data, p, p2)
					end

					if not success then
						New.captureCommitPhaseError(data, data.return_, result)
					end
				end
			end
		elseif __DEV__ then
			setCurrentFiber(data)
			invokeGuardedCallback(nil, v3.commitMutationEffectsImpl, nil, data, p, p2)

			if hasCaughtError() then
				local v29 = clearCaughtError()
				New.captureCommitPhaseError(data, data.return_, v29)
			end

			resetCurrentFiber()
		else
			local result = nil
			local success

			if __YOLO__ then
				v3.commitMutationEffectsImpl(data, p, p2)
				success = true
			else
				success, result = xpcall(v3.commitMutationEffectsImpl, describeError, data, p, p2)
			end

			if not success then
				New.captureCommitPhaseError(data, data.return_, result)
			end
		end

		data = data.sibling
	end
end

function v3:commitMutationEffectsImpl(_, _)
	local flags = self.flags

	if bit32.band(flags, ReactFiberFlags.Ref) ~= 0 then
		local alternate = self.alternate

		if alternate ~= nil then
			commitDetachRef(alternate)
		end
	end

	local v29 = bit32.band(
		flags,
		(bit32.bor(ReactFiberFlags.Placement, ReactFiberFlags.Update, ReactFiberFlags.Hydrating))
	)

	if
		ReactFeatureFlags.enableCommitTraversalTrims
		and bit32.band(flags, ReactFiberFlags.HostUpdate) ~= ReactFiberFlags.NoFlags
	then
		v29 = bit32.bor(v29, ReactFiberFlags.Update)
	end

	if v29 == ReactFiberFlags.Placement then
		commitPlacement(self)

		self.flags = bit32.band(self.flags, (bit32.bnot(ReactFiberFlags.Placement)))
	elseif v29 == ReactFiberFlags.PlacementAndUpdate then
		commitPlacement(self)

		self.flags = bit32.band(self.flags, (bit32.bnot(ReactFiberFlags.Placement)))

		commitWork(self.alternate, self)
	elseif v29 == ReactFiberFlags.Update then
		commitWork(self.alternate, self)
	end
end

function v3.commitMutationEffectsDeletions(items, p, p2, p3)
	for _, item in items do
		local success, result = xpcall(commitDeletion, describeError, p2, item, p, p3)

		if not success then
			New.captureCommitPhaseError(item, p, result)
		end
	end
end

function New.schedulePassiveEffectCallback()
	if not flag2 then
		flag2 = true
		scheduleCallback(NormalPriority, function(): nil
			New.flushPassiveEffects()
			return nil
		end)
	end
end

local fn6
function New.flushPassiveEffects()
	if v18 == NoPriority then
		return false
	end

	local v29 = if NormalPriority < v18 then NormalPriority else v18

	v18 = NoPriority

	if not ReactFeatureFlags.decoupleUpdatePriorityFromScheduler then
		return runWithPriority(v29, fn6)
	end

	local currentUpdateLanePriority = getCurrentUpdateLanePriority()

	setCurrentUpdateLanePriority(schedulerPriorityToLanePriority(v29))
	local result, success

	if __YOLO__ then
		setCurrentUpdateLanePriority(schedulerPriorityToLanePriority(v29))

		result = runWithPriority(v29, fn6)
		success = true
	else
		success, result = xpcall(runWithPriority, describeError, v29, fn6)
	end

	setCurrentUpdateLanePriority(currentUpdateLanePriority)

	if not success then
		error(result)
	end

	return result
end

fn4 = function(p, current2)
	while current2 ~= nil do
		local v29

		if
			ReactFeatureFlags.enableProfilerTimer
			and ReactFeatureFlags.enableProfilerCommitHooks
			and current2.tag == ReactWorkTags.Profiler
		then
			v29 = v14
			v14 = current2
		end

		local v30 = bit32.band(current2.subtreeFlags, ReactFiberFlags.PassiveMask)

		if current2.child ~= nil and v30 ~= ReactFiberFlags.NoFlags then
			fn4(p, current2.child)
		end

		if bit32.band(current2.flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags then
			if __DEV__ then
				setCurrentFiber(current2)
				invokeGuardedCallback(nil, commitPassiveMount, nil, p, current2)

				if hasCaughtError() then
					local v31 = clearCaughtError()
					New.captureCommitPhaseError(current2, current2.return_, v31)
				end

				resetCurrentFiber()
			else
				local result = nil
				local success

				if __YOLO__ then
					commitPassiveMount(p, current2)
					success = true
				else
					success, result = xpcall(commitPassiveMount, describeError, p, current2)
				end

				if not success then
					New.captureCommitPhaseError(current2, current2.return_, result)
				end
			end
		end

		if
			ReactFeatureFlags.enableProfilerTimer
			and ReactFeatureFlags.enableProfilerCommitHooks
			and current2.tag == ReactWorkTags.Profiler
		then
			if v29 ~= nil then
				v29.stateNode.passiveEffectDuration += current2.stateNode.passiveEffectDuration
			end

			v14 = v29
		end

		current2 = current2.sibling
	end
end

function v3.commitPassiveMountEffectsOnFibers(p, list)
	for i = 1, #list do
		local item = list[i]

		if __DEV__ then
			setCurrentFiber(item)
			invokeGuardedCallback(nil, commitPassiveMount, nil, p, item)

			if hasCaughtError() then
				local v29 = clearCaughtError()
				New.captureCommitPhaseError(item, item.return_, v29)
			end

			resetCurrentFiber()
		else
			local result = nil
			local success

			if __YOLO__ then
				commitPassiveMount(p, item)
				success = true
			else
				success, result = xpcall(commitPassiveMount, describeError, p, item)
			end

			if not success then
				New.captureCommitPhaseError(item, item.return_, result)
			end
		end
	end
end

local function flushPassiveUnmountEffects(current2)
	while current2 ~= nil do
		local deletions = current2.deletions

		if deletions ~= nil then
			for i = 1, #deletions do
				local deletion = deletions[i]
				v3.flushPassiveUnmountEffectsInsideOfDeletedTree(deletion, current2)

				if not (enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2) then
					v3.detachFiberAfterEffects(deletion)
				end
			end

			if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 1 then
				local alternate = current2.alternate

				if alternate ~= nil then
					local v29 = alternate.child

					if v29 ~= nil then
						alternate.child = nil

						while true do
							local sibling = v29.sibling
							v29.sibling = nil

							if sibling == nil then
								break
							end

							v29 = sibling
						end
					end
				end
			end
		end

		local child = current2.child

		if
			child ~= nil
			and bit32.band(current2.subtreeFlags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags
		then
			flushPassiveUnmountEffects(child)
		end

		if bit32.band(current2.flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags then
			setCurrentFiber(current2)
			commitPassiveUnmount(current2)
			resetCurrentFiber()
		end

		current2 = current2.sibling
	end
end

function v3.flushPassiveUnmountEffectsCollecting(data, list)
	while data ~= nil do
		local deletions = data.deletions

		if deletions ~= nil then
			for i = 1, #deletions do
				local deletion = deletions[i]
				v3.flushPassiveUnmountEffectsInsideOfDeletedTree(deletion, data)

				if not (enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2) then
					v3.detachFiberAfterEffects(deletion)
				end
			end

			if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 1 then
				local alternate = data.alternate

				if alternate ~= nil then
					local v29 = alternate.child

					if v29 ~= nil then
						alternate.child = nil

						while true do
							local sibling = v29.sibling
							v29.sibling = nil

							if sibling == nil then
								break
							end

							v29 = sibling
						end
					end
				end
			end
		end

		local child = data.child

		if child ~= nil and bit32.band(data.subtreeFlags, ReactFiberFlags.PassiveMask) ~= ReactFiberFlags.NoFlags then
			v3.flushPassiveUnmountEffectsCollecting(child, list)
		end

		if bit32.band(data.flags, ReactFiberFlags.Passive) ~= ReactFiberFlags.NoFlags then
			table.insert(list, data)
			setCurrentFiber(data)
			commitPassiveUnmount(data)
			resetCurrentFiber()
		end

		data = data.sibling
	end
end

function v3.flushPassiveUnmountEffectsInsideOfDeletedTree(data, p)
	if
		bit32.band(data.subtreeFlags, ReactFiberFlags.PassiveStatic) ~= ReactFiberFlags.NoFlags
		or enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2
	then
		local v29 = data.child

		while v29 ~= nil do
			local sibling = v29.sibling
			v3.flushPassiveUnmountEffectsInsideOfDeletedTree(v29, p)
			v29 = sibling
		end
	end

	if bit32.band(data.flags, ReactFiberFlags.PassiveStatic) ~= ReactFiberFlags.NoFlags then
		setCurrentFiber(data)
		commitPassiveUnmountInsideDeletedTree(data, p)

		resetCurrentFiber()
	end

	if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2 then
		v3.detachFiberAfterEffects(data)
	end
end

fn6 = function(): boolean
	if v17 == nil then
		return false
	end

	local v29 = v17
	local v30 = v19
	v17 = nil
	v19 = ReactFiberLane.NoLanes

	invariant(bit32.band(v4, 48) == 0, "Cannot flush passive effects while already rendering.")

	if __DEV__ and enableDebugTracing then
		DebugTracing.logPassiveEffectsStarted(v30)
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markPassiveEffectsStarted(v30)
	end

	local v31 = v4
	v4 = bit32.bor(v4, 32)
	local v32 = v3.pushInteractions(v29)

	if ReactFeatureFlags.enableCommitTraversalTrims then
		if ReactFeatureFlags.enableProfilerTimer and ReactFeatureFlags.enableProfilerCommitHooks then
			flushPassiveUnmountEffects(v29.current)
			fn4(v29, v29.current)
		else
			local passiveMountFibers = v3.passiveMountFibers or {}
			v3.passiveMountFibers = nil
			v3.flushPassiveUnmountEffectsCollecting(v29.current, passiveMountFibers)
			v3.commitPassiveMountEffectsOnFibers(v29, passiveMountFibers)
			table.clear(passiveMountFibers)
			v3.passiveMountFibers = passiveMountFibers
		end
	else
		flushPassiveUnmountEffects(v29.current)
		fn4(v29, v29.current)
	end

	if __DEV__ and enableDebugTracing then
		DebugTracing.logPassiveEffectsStopped()
	end

	if enableSchedulingProfiler then
		SchedulingProfiler.markPassiveEffectsStopped(v29)
	end

	if __DEV__ and enableDoubleInvokingEffects then
		commitDoubleInvokeEffectsInDEV(v29.current, true)
	end

	if ReactFeatureFlags.enableSchedulerTracing then
		v3.popInteractions(v32)
		v3.finishPendingInteractions(v29, v30)
	end

	v4 = v31

	flushSyncCallbackQueue()

	if v17 == nil then
		count2 = 0
	else
		count2 += 1
	end

	return true
end

function New.isAlreadyFailedLegacyErrorBoundary(p)
	return v16 ~= nil and v16:has(p)
end

function New.markLegacyErrorBoundaryAsFailed(p)
	if v16 == nil then
		v16 = Set.new({ p })
	else
		v16:add(p)
	end
end

local function prepareToThrowUncaughtError(p)
	if not flag then
		flag = true
		v15 = p
	end
end
New.onUncaughtError = prepareToThrowUncaughtError

fn3 = function(p, p2, p3)
	enqueueUpdate(p, (createRootErrorUpdate(p, createCapturedValue(p3, p2), SyncLane, New.onUncaughtError)))
	local eventTime = New.requestEventTime()
	local v29 = v3.markUpdateLaneFromFiberToRoot(p, SyncLane)

	if v29 ~= nil then
		markRootUpdated(v29, SyncLane, eventTime)
		fn(v29, eventTime)
		v3.schedulePendingInteractions(v29, SyncLane)
	end
end

function New.captureCommitPhaseError(p, data, p2)
	if p.tag == ReactWorkTags.HostRoot then
		fn3(p, p, p2)
		return
	end

	if not skipUnmountedBoundaries then
		data = p.return_
	end

	while data ~= nil do
		if data.tag == ReactWorkTags.HostRoot then
			fn3(data, p, p2)
			break
		end

		if data.tag == ReactWorkTags.ClassComponent then
			local kind = data.type
			local stateNode = data.stateNode

			if
				typeof(kind.getDerivedStateFromError) == "function"
				or typeof(stateNode.componentDidCatch) == "function"
				and not New.isAlreadyFailedLegacyErrorBoundary(stateNode)
			then
				enqueueUpdate(data, (createClassErrorUpdate(data, createCapturedValue(p2, p), SyncLane)))
				local eventTime = New.requestEventTime()
				local v29 = v3.markUpdateLaneFromFiberToRoot(data, SyncLane)

				if v29 ~= nil then
					markRootUpdated(v29, SyncLane, eventTime)
					fn(v29, eventTime)
					v3.schedulePendingInteractions(v29, SyncLane)
				end

				break
			end
		end

		data = data.return_
	end
end

function New.pingSuspendedRoot(p, p2, p3)
	local pingCache = p.pingCache

	if pingCache ~= nil then
		pingCache[p2] = nil
	end

	local eventTime = New.requestEventTime()
	markRootPinged(p, p3, eventTime)

	if v5 == p and isSubsetOfLanes(v7, p3) then
		if v8 == 4 or v8 == 3 and includesOnlyRetries(v7) and now() - v12 < 500 then
			v3.prepareFreshStack(p, ReactFiberLane.NoLanes)
		else
			noLanes = mergeLanes(noLanes, p3)
		end
	end

	fn(p, eventTime)
	v3.schedulePendingInteractions(p, p3)
end

function retryTimedOutBoundary(p, p2)
	if p2 == ReactFiberLane.NoLane then
		p2 = requestRetryLane(p)
	end

	local eventTime = New.requestEventTime()
	local v29 = v3.markUpdateLaneFromFiberToRoot(p, p2)

	if v29 ~= nil then
		markRootUpdated(v29, p2, eventTime)
		fn(v29, eventTime)
		v3.schedulePendingInteractions(v29, p2)
	end
end

function New.resolveRetryWakeable(p, p2)
	local noLane = ReactFiberLane.NoLane

	local stateNode = p.stateNode

	if stateNode ~= nil then
		stateNode:delete(p2)
	end

	retryTimedOutBoundary(p, noLane)
end

function jnd(p: number)
	if p < 120 then
		return 120
	end

	if p < 480 then
		return 480
	end

	if p < 1080 then
		return 1080
	end

	if p < 1920 then
		return 1920
	end

	if p < 3000 then
		return 3000
	end

	if p < 4320 then
		return 4320
	end

	return math.ceil(p / 1960) * 1960
end

function v3.checkForNestedUpdates()
	if count > 50 then
		count = 0
		v21 = nil
		invariant(
			false,
			"Maximum update depth exceeded. This can happen when a component repeatedly calls setState inside componentWillUpdate or componentDidUpdate. React limits the number of nested updates to prevent infinite loops."
		)
	end

	if __DEV__ and count2 > 50 then
		count2 = 0
		console.error("Maximum update depth exceeded. This can happen when a component calls setState inside useEffect, but useEffect either doesn't have a dependency array, or one of the dependencies changes on every render.")
	end
end

function flushRenderPhaseStrictModeWarningsInDEV()
	if __DEV__ then
		ReactStrictModeWarningsnew.flushLegacyContextWarning()

		if ReactFeatureFlags.warnAboutDeprecatedLifecycles then
			ReactStrictModeWarningsnew.flushPendingUnsafeLifecycleWarnings()
		end
	end
end

function commitDoubleInvokeEffectsInDEV(p, flag4: boolean)
	if __DEV__ and enableDoubleInvokingEffects then
		setCurrentFiber(p)
		invokeEffectsInDev(p, ReactFiberFlags.MountLayoutDev, invokeLayoutEffectUnmountInDEV)

		if flag4 then
			invokeEffectsInDev(p, ReactFiberFlags.MountPassiveDev, invokePassiveEffectUnmountInDEV)
		end

		invokeEffectsInDev(p, ReactFiberFlags.MountLayoutDev, invokeLayoutEffectMountInDEV)

		if flag4 then
			invokeEffectsInDev(p, ReactFiberFlags.MountPassiveDev, invokePassiveEffectMountInDEV)
		end

		resetCurrentFiber()
	end
end

function invokeEffectsInDev(data, p, callback)
	if __DEV__ and enableDoubleInvokingEffects then
		while data ~= nil do
			if data.child ~= nil and bit32.band(data.subtreeFlags, p) ~= ReactFiberFlags.NoFlags then
				invokeEffectsInDev(data.child, p, callback)
			end

			if bit32.band(data.flags, p) ~= ReactFiberFlags.NoFlags then
				callback(data)
			end

			data = data.sibling
		end
	end
end

local v29 = nil
function v3.warnAboutUpdateOnNotYetMountedFiberInDEV(data)
	if __DEV__ then
		if bit32.band(v4, 16) ~= 0 then
			return
		end

		if bit32.band(data.mode, (bit32.bor(ReactTypeOfMode.BlockingMode, ReactTypeOfMode.ConcurrentMode))) == 0 then
			return
		end

		local tag = data.tag

		if
			tag ~= ReactWorkTags.IndeterminateComponent
			and tag ~= ReactWorkTags.HostRoot
			and tag ~= ReactWorkTags.ClassComponent
			and tag ~= ReactWorkTags.FunctionComponent
			and tag ~= ReactWorkTags.ForwardRef
			and tag ~= ReactWorkTags.MemoComponent
			and tag ~= ReactWorkTags.SimpleMemoComponent
			and tag ~= ReactWorkTags.Block
		then
			return
		end

		local v30 = getComponentName(data.type) or "ReactComponent"

		if v29 == nil then
			v29 = { [v30] = true }
		elseif v29[v30] then
			return
		else
			v29[v30] = true
		end

		local current2 = ReactCurrentFiber.current
		local success, result = pcall(function()
			setCurrentFiber(data)
			console.error("Can't perform a React state update on a component that hasn't mounted yet. This indicates that you have a side-effect in your render function that asynchronously later calls tries to update the component. Move this work to useEffect instead.")
		end)

		if current2 then
			setCurrentFiber(data)
		else
			resetCurrentFiber()
		end

		if not success then
			error(result)
		end
	end
end

if __DEV__ and ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback then
	function v3.beginWork(p, p2, p3)
		local v30 = ReactFibernew.assignFiberPropertiesInDEV(nil, p2)

		local success, result = xpcall(fn2, describeError, p, p2, p3)

		if success then
			return result
		end

		if result ~= nil and typeof(result) == "table" and typeof(result.andThen) == "function" then
			error(result)
		end

		resetContextDependencies()

		if not v.resetHooksAfterThrowRef then
			initReactFiberHooks() -- inferred equivalent call
		end

		v.resetHooksAfterThrowRef()

		unwindInterruptedWork(p2)

		ReactFibernew.assignFiberPropertiesInDEV(p2, v30)

		if ReactFeatureFlags.enableProfilerTimer and bit32.band(p2.mode, ReactTypeOfMode.ProfileMode) ~= 0 then
			ReactProfilerTimernew.startProfilerTimer(p2)
		end

		invokeGuardedCallback(nil, fn2, nil, p, p2, p3)

		if not hasCaughtError() then
			error(result)

			return result
		end

		local v31 = clearCaughtError()

		error(v31)
		return result
	end
else
	v3.beginWork = fn2
end

local v30 = false

local v31 = __DEV__ and {} or nil

function v3.warnAboutRenderPhaseUpdatesInDEV(p)
	if __DEV__ and ReactCurrentFiber.isRendering and bit32.band(v4, 16) ~= 0 then
		if not v.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef then
			initReactFiberHooks() -- inferred equivalent call
		end

		if not v.getIsUpdatingOpaqueValueInRenderPhaseInDEVRef() then
			if
				p.tag == ReactWorkTags.FunctionComponent
				or p.tag == ReactWorkTags.ForwardRef
				or p.tag == ReactWorkTags.SimpleMemoComponent
			then
				local v32 = v6 and getComponentName(v6.type) or "Unknown"

				if v31[v32] == nil then
					v31[v32] = true
					local v33 = getComponentName(p.type) or "Unknown"

					console.error(
						"Cannot update a component (`%s`) while rendering a different component (`%s`). To locate the bad setState() call inside `%s`, follow the stack trace as described in https://reactjs.org/link/setstate-in-render",
						v33,
						v32,
						v32
					)
				end
			elseif p.tag == ReactWorkTags.ClassComponent and not v30 then
				console.error("Cannot update during an existing state transition (such as within `render`). Render methods should be a pure function of props and state.")

				v30 = true
			end
		end
	end
end

New.IsThisRendererActing = { current = false }

function New.warnIfNotScopedWithMatchingAct(p)
	if
		__DEV__
		and ReactFiberHostConfig.warnsIfNotActing == true
		and IsSomeRendererActing.current == true
		and New.IsThisRendererActing.current ~= true
	then
		local current2 = ReactCurrentFiber.current
		local success, result = pcall(function()
			setCurrentFiber(p)

			console.error([[
It looks like you're using the wrong act() around your test interactions.
Be sure to use the matching version of act() corresponding to your renderer:

-- for react-roblox:
local React = require(Packages.React)
-- ...
React.TestUtils.act(function() ... end)

-- for react-test-renderer:
local TestRenderer = require(Packages.ReactTestRenderer)
-- ...
TestRenderer.act(function() ... end)]])
		end)

		if current2 then
			setCurrentFiber(p)
		else
			resetCurrentFiber()
		end

		if not success then
			error(result)
		end
	end
end

function New.warnIfNotCurrentlyActingEffectsInDEV(p)
	if
		__DEV__
		and ReactFiberHostConfig.warnsIfNotActing == true
		and bit32.band(p.mode, ReactTypeOfMode.StrictMode) ~= ReactTypeOfMode.NoMode
		and IsSomeRendererActing.current == false
		and New.IsThisRendererActing.current == false
	then
		console.error(
			"An update to %s ran an effect, but was not wrapped in act(...).\n\nWhen testing, code that causes React state updates should be wrapped into act(...):\n\nact(function()\n  --[[ fire events that update state ]]\nend)\n--[[ assert on the output ]]\n\nThis ensures that you're testing the behavior the user would see in the real client. Learn more at https://reactjs.org/link/wrap-tests-with-act",
			getComponentName(p.type)
		)
	end
end

function New.warnIfNotCurrentlyActingUpdatesInDEV(p)
	if
		__DEV__
		and ReactFiberHostConfig.warnsIfNotActing == true
		and v4 == 0
		and IsSomeRendererActing.current == false
		and New.IsThisRendererActing.current == false
	then
		local success, result = pcall(function()
			setCurrentFiber(p)

			console.error(
				"An update to %s inside a test was not wrapped in act(...).\n\nWhen testing, code that causes React state updates should be wrapped into act(...):\n\nact(function()\n  --[[ fire events that update state ]]\nend)\n--[[ assert on the output ]]\n\nThis ensures that you're testing the behavior the user would see in the client application. Learn more at https://reactjs.org/link/wrap-tests-with-act",
				getComponentName(p.type)
			)
		end)

		if current then
			setCurrentFiber(p)
		else
			resetCurrentFiber()
		end

		if success then
			return result
		end
	end
end

local v32 = false

function New.warnIfUnmockedScheduler(p)
	if __DEV__ and v32 == false and Scheduler.unstable_flushAllWithoutAsserting == nil then
		if
			bit32.band(p.mode, ReactTypeOfMode.BlockingMode) == 0
			and bit32.band(p.mode, ReactTypeOfMode.ConcurrentMode) == 0
		then
			if ReactFeatureFlags.warnAboutUnmockedScheduler == true then
				v32 = true

				console.error([[
Starting from React v18, the 'scheduler' module will need to be mocked to guarantee consistent behaviour across tests and client applications. For example, with Jest: 
jest.mock('scheduler', function() return require(Packages.Scheduler).unstable_mock end)

For more info, visit https://reactjs.org/link/mock-scheduler]])
			end
		else
			v32 = true

			console.error([[
In Concurrent or Sync modes, the 'scheduler' module needs to be mocked to guarantee consistent behaviour across tests and client application. For example, with Jest: 
jest.mock('scheduler', function() return require(Packages.Scheduler).unstable_mock end)

For more info, visit https://reactjs.org/link/mock-scheduler]])
		end
	end
end

function computeThreadID(p, p2)
	return p2 * 1000 + p.interactionThreadID
end

function New.markSpawnedWork(p)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	if v22 == nil then
		v22 = { p }
	else
		table.insert(v22, p)
	end
end

function scheduleInteractions(p, p2, p3)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	if p3.size > 0 then
		local pendingInteractionMap = p.pendingInteractionMap
		local v33 = pendingInteractionMap:get(p2)

		if v33 == nil then
			pendingInteractionMap:set(p2, Set.new(p3))

			for _, v34 in p3 do
				v34.__count += 1
			end
		else
			p3:forEach(function(p4)
				if not v33:has(p4) then
					p4.__count += 1
				end

				v33:add(p4)
			end)
		end

		local current2 = __subscriberRef.current

		if current2 ~= nil then
			local v34 = computeThreadID(p, p2)
			current2.onWorkScheduled(p3, v34)
		end
	end
end

function v3.schedulePendingInteractions(p, p2)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	scheduleInteractions(p, p2, __interactionsRef.current)
end

function v3:startWorkOnPendingInteractions(p)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	local memoizedInteractions = Set.new()
	self.pendingInteractionMap:forEach(function(object, p2)
		if includesSomeLane(p, p2) then
			object:forEach(function(p3)
				memoizedInteractions:add(p3)
			end)
		end
	end)

	self.memoizedInteractions = memoizedInteractions

	if memoizedInteractions.size > 0 then
		local current2 = __subscriberRef.current

		if current2 ~= nil then
			local v34 = computeThreadID(self, p)

			local success, result = xpcall(current2.onWorkStarted, describeError, memoizedInteractions, v34)

			if not success then
				scheduleCallback(ImmediatePriority, function()
					error(result)
				end)
			end
		end
	end
end

function v3.finishPendingInteractions(data, p)
	if not ReactFeatureFlags.enableSchedulerTracing then
		return
	end

	local pendingLanes = data.pendingLanes

	local current2 = nil
	local success, result

	if current2 == nil or not (data.memoizedInteractions.size > 0) then
		success = true
		result = nil
	else
		local v33 = computeThreadID(data, p)
		current2 = __subscriberRef.current

		success, result = xpcall(current2.onWorkStopped, describeError, data.memoizedInteractions, v33)
	end

	local pendingInteractionMap = data.pendingInteractionMap
	pendingInteractionMap:forEach(function(object, p2)
		if not includesSomeLane(pendingLanes, p2) then
			pendingInteractionMap:delete(p2)
			object:forEach(function(p3)
				p3.__count -= 1

				if current2 ~= nil and p3.__count == 0 then
					local success2, result2 = xpcall(current2.onInteractionScheduledWorkCompleted, describeError, p3)

					if not success2 then
						scheduleCallback(ImmediatePriority, function()
							error(result2)
						end)
					end
				end
			end)
		end
	end)

	if not success then
		scheduleCallback(ImmediatePriority, function()
			error(result)
		end)
	end
end

local v33 = false
local v34 = false

local unstable_flushAllWithoutAsserting = Scheduler.unstable_flushAllWithoutAsserting
local v35 = typeof(unstable_flushAllWithoutAsserting) == "function"

local function flushActWork()
	if unstable_flushAllWithoutAsserting == nil then
		local v36 = v33
		v33 = true

		local success, result = xpcall(function()
			local v37 = false

			while New.flushPassiveEffects() do
				v37 = true
			end

			return v37
		end, describeError)

		v33 = v36

		if success then
			return result
		end

		error(result)
	else
		local v36 = v33
		v33 = true
		local success, result = xpcall(unstable_flushAllWithoutAsserting, describeError)

		v33 = v36

		if success then
			return result
		end

		error(result)
	end
end

local function flushWorkAndMicroTasks(fn7)
	local success, result = xpcall(flushActWork, describeError)

	if success then
		success, result = xpcall(enqueueTask, describeError, function()
			if flushActWork() then
				flushWorkAndMicroTasks(fn7)
			else
				fn7()
			end
		end)
	end

	if not success then
		fn7(result)
	end
end

function New.act(callback)
	if not __DEV__ and not ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ and v28 == false then
		v28 = true

		console.error("act(...) is not supported in production builds of React, and might not behave as expected.")
	end

	local v36 = v27
	v27 += 1

	local current2 = IsSomeRendererActing.current
	local current3 = New.IsThisRendererActing.current
	local v37 = v34
	IsSomeRendererActing.current = true
	New.IsThisRendererActing.current = true
	v34 = true

	local function onDone() -- 6 equivalent calls inferred from this helper
		v27 -= 1
		IsSomeRendererActing.current = current2
		New.IsThisRendererActing.current = current3
		v34 = v37

		if __DEV__ and v36 < v27 then
			console.error("You seem to have overlapping act() calls, this is not supported. Be sure to await previous act() calls before making a new one. ")
		end
	end

	local success, result = xpcall(New.batchedUpdates, describeError, callback)

	if not success then
		onDone() -- inferred equivalent call
		error(result)
	end

	if result == nil or typeof(result) ~= "table" or typeof(result.andThen) ~= "function" then
		if __DEV__ and result ~= nil then
			console.error(
				"The callback passed to act(...) function must return nil, or a Promise. You returned %s",
				(tostring(result))
			)
		end

		local success2, result2 = xpcall(function()
			if v27 == 1 and (v35 == false or current2 == false) then
				flushActWork()
			end

			onDone() -- inferred equivalent call
		end, describeError)

		if not success2 then
			onDone() -- inferred equivalent call
			error(result2)
		end

		return {
			andThen = function(self, callback2, _)
				if __DEV__ then
					console.error("Do not await the result of calling act(...) with sync logic, it is not a Promise.")
				end

				callback2()
			end
		}
	else
		local v38 = false

		if __DEV__ and typeof(Promise) ~= nil then
			Promise.resolve():andThen(function() end):andThen(function()
				if v38 == false then
					console.error("You called act(Promise.new(function() --[[ ... ]] end)) without :await() or :expect(). This could lead to unexpected testing behaviour, interleaving multiple act calls and mixing their scopes. You should - act(function() Promise.new(function() --[[ ... ]] end):await() end);")
				end
			end)
		end

		return {
			andThen = function(self, callback2, callback3)
				v38 = true
				return result:andThen(function()
					if not (v27 > 1) and (v35 ~= true or current2 ~= true) then
						flushWorkAndMicroTasks(function(p)
							onDone() -- inferred equivalent call

							if p then
								callback3(p)
							else
								callback2()
							end
						end)
						return
					end

					onDone() -- inferred equivalent call
					callback2()
				end, function(p)
					onDone() -- inferred equivalent call
					callback3(p)
				end)
			end
		}
	end
end

function v3:detachFiberAfterEffects()
	if enableNewTreeCleanupPath then
		local alternate = self.alternate

		if alternate ~= nil then
			self.alternate = nil
			v3.detachFiberAfterEffects(alternate)
		end
	end

	if enableNewTreeCleanupPath and deletedTreeCleanUpLevel >= 2 then
		self.child = nil
		self.deletions = nil
		self.sibling = nil

		if __DEV__ then
			self._debugOwner = nil
		end

		if deletedTreeCleanUpLevel >= 3 then
			self.return_ = nil
			self.dependencies = nil
			self.memoizedProps = nil
			self.memoizedState = nil
			self.pendingProps = nil
			self.stateNode = nil

			self.updateQueue = nil
		end
	else
		self.child = nil
		self.deletions = nil
		self.dependencies = nil
		self.memoizedProps = nil
		self.memoizedState = nil
		self.pendingProps = nil
		self.sibling = nil
		self.stateNode = nil
		self.updateQueue = nil

		if __DEV__ then
			self._debugOwner = nil
		end
	end
end

return New
