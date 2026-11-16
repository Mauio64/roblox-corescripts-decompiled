local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent.ReactCapturedValue)

local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])

require(parent.Shared)

local ReactFiberSuspenseContextnew = require(script.Parent["ReactFiberSuspenseContext.new"])

local Shared2 = require(parent.Shared)
local getComponentName = Shared2.getComponentName

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local IncompleteClassComponent = ReactWorkTags.IncompleteClassComponent

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local DidCapture = ReactFiberFlags.DidCapture
local Incomplete = ReactFiberFlags.Incomplete
local NoFlags = ReactFiberFlags.NoFlags
local ShouldCapture = ReactFiberFlags.ShouldCapture
local LifecycleEffectMask = ReactFiberFlags.LifecycleEffectMask
local ForceUpdateForLegacySuspense = ReactFiberFlags.ForceUpdateForLegacySuspense

local ReactFiberSuspenseComponentnew = require(script.Parent["ReactFiberSuspenseComponent.new"])
local shouldCaptureSuspense = ReactFiberSuspenseComponentnew.shouldCaptureSuspense
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local NoMode = ReactTypeOfMode.NoMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local Shared3 = require(parent.Shared)
local ReactFeatureFlags = Shared3.ReactFeatureFlags
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local ReactCapturedValue = require(script.Parent.ReactCapturedValue)
local createCapturedValue = ReactCapturedValue.createCapturedValue

local enqueueCapturedUpdate = ReactUpdateQueuenew.enqueueCapturedUpdate
local createUpdate = ReactUpdateQueuenew.createUpdate
local CaptureUpdate = ReactUpdateQueuenew.CaptureUpdate
local ForceUpdate = ReactUpdateQueuenew.ForceUpdate
local enqueueUpdate = ReactUpdateQueuenew.enqueueUpdate
local ReactFiberHotReloadingnew = require(script.Parent["ReactFiberHotReloading.new"])
local markFailedErrorBoundaryForHotReloading = ReactFiberHotReloadingnew.markFailedErrorBoundaryForHotReloading

local hasSuspenseContext = ReactFiberSuspenseContextnew.hasSuspenseContext

local InvisibleParentSuspenseContext = ReactFiberSuspenseContextnew.InvisibleParentSuspenseContext
local suspenseStackCursor = ReactFiberSuspenseContextnew.suspenseStackCursor

local v = nil
local markLegacyErrorBoundaryAsFailed = nil
local isAlreadyFailedLegacyErrorBoundary = nil
local pingSuspendedRoot = nil

local function fn(...)
	if not markLegacyErrorBoundaryAsFailed then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		v = ReactFiberWorkLoopnew
		markLegacyErrorBoundaryAsFailed = v.markLegacyErrorBoundaryAsFailed
	end

	return markLegacyErrorBoundaryAsFailed(...)
end

local function fn2(...)
	if v == nil then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		v = ReactFiberWorkLoopnew
	end

	pingSuspendedRoot = v.pingSuspendedRoot
	return pingSuspendedRoot(...)
end

local function fn3(...)
	if v == nil then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		v = ReactFiberWorkLoopnew
	end

	isAlreadyFailedLegacyErrorBoundary = v.isAlreadyFailedLegacyErrorBoundary
	return isAlreadyFailedLegacyErrorBoundary(...)
end

local ReactFiberErrorLogger = require(script.Parent.ReactFiberErrorLogger)
local logCapturedError = ReactFiberErrorLogger.logCapturedError
local DebugTracing = require(script.Parent.DebugTracing)
local logComponentSuspended = DebugTracing.logComponentSuspended

local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markComponentSuspended = SchedulingProfiler.markComponentSuspended

local SyncLane = ReactFiberLane.SyncLane
local NoTimestamp = ReactFiberLane.NoTimestamp
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes
local pickArbitraryLane = ReactFiberLane.pickArbitraryLane

function createRootErrorUpdate(p, p2, p3, callback)
	local update = createUpdate(NoTimestamp, p3)

	update.tag = CaptureUpdate

	update.payload = { element = Object.None }
	local value = p2.value
	function update.callback()
		if callback ~= nil then
			callback(value)
		end

		logCapturedError(p, p2)
	end
	return update
end

function createClassErrorUpdate(data, p, p2)
	local update = createUpdate(NoTimestamp, p2)
	update.tag = CaptureUpdate
	local getDerivedStateFromError = data.type.getDerivedStateFromError

	if typeof(getDerivedStateFromError) == "function" then
		local value = p.value
		function update.payload()
			logCapturedError(data, p)
			return getDerivedStateFromError(value)
		end
	end

	local stateNode = data.stateNode

	if stateNode ~= nil and typeof(stateNode.componentDidCatch) == "function" then
		function update.callback()
			if ReactGlobals.__DEV__ then
				markFailedErrorBoundaryForHotReloading(data)
			end

			if typeof(getDerivedStateFromError) ~= "function" then
				fn(stateNode)

				logCapturedError(data, p)
			end

			stateNode:componentDidCatch(p.value, {
				componentStack = p.stack or ""
			})

			if
				ReactGlobals.__DEV__
				and typeof(getDerivedStateFromError) ~= "function"
				and not includesSomeLane(data.lanes, SyncLane)
			then
				console.error(
					"%s: Error boundaries should implement getDerivedStateFromError(). In that method, return a state update to display an error message or fallback UI.",
					getComponentName(data.type) or "Unknown"
				)
			end
		end

		return update
	end

	if ReactGlobals.__DEV__ then
		function update.callback()
			markFailedErrorBoundaryForHotReloading(data)
		end
	end

	return update
end

local function attachPingListener(p, object, lanes)
	local pingCache = p.pingCache
	local v2

	if pingCache == nil then
		v2 = {}
		p.pingCache = { [object] = v2 }

		local _pingCache = p.pingCache
	else
		v2 = pingCache[object]

		if v2 == nil then
			v2 = {}
			pingCache[object] = v2
		end
	end

	if not v2[lanes] then
		v2[lanes] = true
		local function fn4()
			return fn2(p, object, lanes)
		end

		object:andThen(fn4, fn4)
	end
end

function throwException(p, state, state2, p2, lanes, p3, callback)
	state2.flags = bit32.bor(state2.flags, Incomplete)

	if p2 ~= nil and typeof(p2) == "table" and typeof(p2.andThen) == "function" then
		if ReactGlobals.__DEV__ and enableDebugTracing and bit32.band(state2.mode, DebugTracingMode) ~= 0 then
			logComponentSuspended(getComponentName(state2.type) or "Unknown", p2)
		end

		if enableSchedulingProfiler then
			markComponentSuspended(state2, p2)
		end

		if bit32.band(state2.mode, BlockingMode) == NoMode then
			local alternate = state2.alternate

			if alternate then
				state2.updateQueue = alternate.updateQueue
				state2.memoizedState = alternate.memoizedState
				state2.lanes = alternate.lanes
			else
				state2.updateQueue = nil
				state2.memoizedState = nil
			end
		end

		local suspenseContext = hasSuspenseContext(suspenseStackCursor.current, InvisibleParentSuspenseContext)
		local v2 = state

		repeat
			if v2.tag == SuspenseComponent and shouldCaptureSuspense(v2, suspenseContext) then
				local updateQueue = v2.updateQueue

				if updateQueue == nil then
					v2.updateQueue = { [p2] = true }
				else
					updateQueue[p2] = true
				end

				if bit32.band(v2.mode, BlockingMode) == NoMode then
					v2.flags = bit32.bor(v2.flags, DidCapture)
					state2.flags = bit32.bor(state2.flags, ForceUpdateForLegacySuspense)

					state2.flags = bit32.band(state2.flags, (bit32.bnot((bit32.bor(LifecycleEffectMask, Incomplete)))))

					if state2.tag == ClassComponent then
						if state2.alternate == nil then
							state2.tag = IncompleteClassComponent
						else
							local update = createUpdate(NoTimestamp, SyncLane)
							update.tag = ForceUpdate
							enqueueUpdate(state2, update)
						end
					end

					state2.lanes = mergeLanes(state2.lanes, SyncLane)
				else
					attachPingListener(p, p2, lanes)

					v2.flags = bit32.bor(v2.flags, ShouldCapture)
					v2.lanes = lanes
				end

				return
			end

			v2 = v2.return_
		until v2 == nil

		p2 = (getComponentName(state2.type) or "A React component") .. [[
 suspended while rendering, but no fallback UI was specified.

Add a <Suspense fallback=...> component higher in the tree to provide a loading indicator or placeholder to display.]]
	end

	callback()

	local capturedValue = createCapturedValue(p2, state2)

	while state.tag ~= HostRoot do
		if state.tag == ClassComponent then
			local kind = state.type
			local stateNode = state.stateNode

			if
				bit32.band(state.flags, DidCapture) == NoFlags
				and (typeof(kind.getDerivedStateFromError) == "function" or stateNode ~= nil and typeof(stateNode.componentDidCatch) == "function" and not fn3(stateNode))
			then
				state.flags = bit32.bor(state.flags, ShouldCapture)
				local v2 = pickArbitraryLane(lanes)
				state.lanes = mergeLanes(state.lanes, v2)

				enqueueCapturedUpdate(state, (createClassErrorUpdate(state, capturedValue, v2)))
				return
			end
		end

		state = state.return_

		if state == nil then
			return
		end
	end

	state.flags = bit32.bor(state.flags, ShouldCapture)
	local v2 = pickArbitraryLane(lanes)
	state.lanes = mergeLanes(state.lanes, v2)

	enqueueCapturedUpdate(state, (createRootErrorUpdate(state, capturedValue, v2, p3)))
end

return {
	throwException = throwException,
	createRootErrorUpdate = createRootErrorUpdate,
	createClassErrorUpdate = createClassErrorUpdate
}
