local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Object = require(ParentParent.LuauPolyfill).Object
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent.ReactCapturedValue)

local lib = require(script.Parent["ReactUpdateQueue.new"])

require(ParentParent.Shared)

local lib2 = require(script.Parent["ReactFiberSuspenseContext.new"])
local getComponentName = require(ParentParent.Shared).getComponentName
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
local shouldCaptureSuspense = require(script.Parent["ReactFiberSuspenseComponent.new"]).shouldCaptureSuspense
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local NoMode = ReactTypeOfMode.NoMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local createCapturedValue = require(script.Parent.ReactCapturedValue).createCapturedValue
local enqueueCapturedUpdate = lib.enqueueCapturedUpdate
local createUpdate = lib.createUpdate
local CaptureUpdate = lib.CaptureUpdate
local ForceUpdate = lib.ForceUpdate
local enqueueUpdate = lib.enqueueUpdate
local markFailedErrorBoundaryForHotReloading = require(script.Parent["ReactFiberHotReloading.new"]).markFailedErrorBoundaryForHotReloading
local hasSuspenseContext = lib2.hasSuspenseContext
local InvisibleParentSuspenseContext = lib2.InvisibleParentSuspenseContext
local suspenseStackCursor = lib2.suspenseStackCursor
local lib3 = nil
local markLegacyErrorBoundaryAsFailed = nil
local isAlreadyFailedLegacyErrorBoundary = nil
local pingSuspendedRoot = nil

local function v43(...) -- line: 89
	-- upvalues: markLegacyErrorBoundaryAsFailed (ref), lib3 (ref)
	if not markLegacyErrorBoundaryAsFailed then
		lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
		markLegacyErrorBoundaryAsFailed = lib3.markLegacyErrorBoundaryAsFailed
	end

	return markLegacyErrorBoundaryAsFailed(...)
end
local function v44(...) -- line: 104
	-- upvalues: lib3 (ref), pingSuspendedRoot (ref)
	if lib3 == nil then
		lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
	end

	pingSuspendedRoot = lib3.pingSuspendedRoot

	return pingSuspendedRoot(...)
end
local function v45(...) -- line: 111
	-- upvalues: lib3 (ref), isAlreadyFailedLegacyErrorBoundary (ref)
	if lib3 == nil then
		lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
	end

	isAlreadyFailedLegacyErrorBoundary = lib3.isAlreadyFailedLegacyErrorBoundary

	return isAlreadyFailedLegacyErrorBoundary(...)
end

local logCapturedError = require(script.Parent.ReactFiberErrorLogger).logCapturedError
local logComponentSuspended = require(script.Parent.DebugTracing).logComponentSuspended
local markComponentSuspended = require(script.Parent.SchedulingProfiler).markComponentSuspended
local SyncLane = ReactFiberLane.SyncLane
local NoTimestamp = ReactFiberLane.NoTimestamp
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes
local pickArbitraryLane = ReactFiberLane.pickArbitraryLane

function createRootErrorUpdate(p1, p2, p3, p4) -- line: 133
	-- upvalues: createUpdate (copy), NoTimestamp (copy), CaptureUpdate (copy), Object (copy), logCapturedError (copy)
	local v59 = createUpdate(NoTimestamp, p3)

	v59.tag = CaptureUpdate
	v59.payload = {
		element = Object.None
	}

	local value = p2.value

	function v59.callback() -- line: 147
		-- upvalues: p4 (copy), value (copy), logCapturedError (copy), p1 (copy), p2 (copy)
		if p4 ~= nil then
			p4(value)
		end

		logCapturedError(p1, p2)
	end

	return v59
end
function createClassErrorUpdate(p5, p6, p7) -- line: 156
	-- upvalues: createUpdate (copy), NoTimestamp (copy), CaptureUpdate (copy), logCapturedError (copy), ReactGlobals (copy), markFailedErrorBoundaryForHotReloading (copy), v43 (copy), includesSomeLane (copy), SyncLane (copy), console (copy), getComponentName (copy)
	local v64 = createUpdate(NoTimestamp, p7)

	v64.tag = CaptureUpdate

	local getDerivedStateFromError = p5.type.getDerivedStateFromError

	if typeof(getDerivedStateFromError) == "function" then
		local value = p6.value

		function v64.payload() -- line: 166
			-- upvalues: logCapturedError (copy), p5 (copy), p6 (copy), getDerivedStateFromError (copy), value (copy)
			logCapturedError(p5, p6)

			return getDerivedStateFromError(value)
		end
	end

	local stateNode = p5.stateNode

	if stateNode ~= nil and typeof(stateNode.componentDidCatch) == "function" then
		function v64.callback() -- line: 174
			-- upvalues: ReactGlobals (copy), markFailedErrorBoundaryForHotReloading (copy), p5 (copy), getDerivedStateFromError (copy), v43 (copy), stateNode (copy), logCapturedError (copy), p6 (copy), includesSomeLane (copy), SyncLane (copy), console (copy), getComponentName (copy)
			if ReactGlobals.__DEV__ then
				markFailedErrorBoundaryForHotReloading(p5)
			end

			if typeof(getDerivedStateFromError) ~= "function" then
				v43(stateNode)
				logCapturedError(p5, p6)
			end

			local value = p6.value
			local stack = p6.stack

			stateNode:componentDidCatch(value, {
				componentStack = stack or ""
			})

			if ReactGlobals.__DEV__ and typeof(getDerivedStateFromError) ~= "function" and not includesSomeLane(p5.lanes, SyncLane) then
				console.error("%s: Error boundaries should implement getDerivedStateFromError(). In that method, return a state update to display an error message or fallback UI.", getComponentName(p5.type) or "Unknown")
			end
		end

		return v64
	end

	if ReactGlobals.__DEV__ then
		function v64.callback() -- line: 212
			-- upvalues: markFailedErrorBoundaryForHotReloading (copy), p5 (copy)
			markFailedErrorBoundaryForHotReloading(p5)
		end
	end

	return v64
end

local function attachPingListener(p8, p9, p10) -- line: 219
	-- upvalues: v44 (copy)
	local pingCache = p8.pingCache
	local t1

	if pingCache == nil then
		t1 = {}
		p8.pingCache = {
			[p9] = t1
		}

		local _ = p8.pingCache
	else
		t1 = pingCache[p9]

		if t1 == nil then
			t1 = {}
			pingCache[p9] = t1
		end
	end

	if not t1[p10] then
		t1[p10] = true

		local function v74() -- line: 247
			-- upvalues: v44 (copy), p8 (copy), p9 (copy), p10 (copy)
			return v44(p8, p9, p10)
		end

		p9:andThen(v74, v74)
	end
end

function throwException(p11, p12, p13, p14, p15, p16, p17) -- line: 254
	-- upvalues: Incomplete (copy), ReactGlobals (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logComponentSuspended (copy), enableSchedulingProfiler (copy), markComponentSuspended (copy), BlockingMode (copy), NoMode (copy), hasSuspenseContext (copy), suspenseStackCursor (copy), InvisibleParentSuspenseContext (copy), SuspenseComponent (copy), shouldCaptureSuspense (copy), DidCapture (copy), ForceUpdateForLegacySuspense (copy), LifecycleEffectMask (copy), ClassComponent (copy), IncompleteClassComponent (copy), createUpdate (copy), NoTimestamp (copy), SyncLane (copy), ForceUpdate (copy), enqueueUpdate (copy), mergeLanes (copy), attachPingListener (copy), ShouldCapture (copy), createCapturedValue (copy), HostRoot (copy), pickArbitraryLane (copy), enqueueCapturedUpdate (copy), NoFlags (copy), v45 (copy)
	p13.flags = bit32.bor(p13.flags, Incomplete)

	if p14 ~= nil and (typeof(p14) == "table" and typeof(p14.andThen) == "function") then
		if ReactGlobals.__DEV__ and enableDebugTracing and bit32.band(p13.mode, DebugTracingMode) ~= 0 then
			local v82 = getComponentName(p13.type) or "Unknown"

			logComponentSuspended(v82, p14)
		end

		if enableSchedulingProfiler then
			markComponentSuspended(p13, p14)
		end

		if bit32.band(p13.mode, BlockingMode) == NoMode then
			local alternate = p13.alternate

			if alternate then
				p13.updateQueue = alternate.updateQueue
				p13.memoizedState = alternate.memoizedState
				p13.lanes = alternate.lanes
			else
				p13.updateQueue = nil
				p13.memoizedState = nil
			end
		end

		local v84 = hasSuspenseContext(suspenseStackCursor.current, InvisibleParentSuspenseContext)
		local v85 = p12

		repeat
			if v85.tag == SuspenseComponent and shouldCaptureSuspense(v85, v84) then
				local updateQueue = v85.updateQueue

				if updateQueue == nil then
					v85.updateQueue = {
						[p14] = true
					}
				else
					updateQueue[p14] = true
				end

				if bit32.band(v85.mode, BlockingMode) == NoMode then
					v85.flags = bit32.bor(v85.flags, DidCapture)
					p13.flags = bit32.bor(p13.flags, ForceUpdateForLegacySuspense)
					p13.flags = bit32.band(p13.flags, (bit32.bnot((bit32.bor(LifecycleEffectMask, Incomplete)))))

					if p13.tag == ClassComponent then
						if p13.alternate == nil then
							p13.tag = IncompleteClassComponent
						else
							local v87 = createUpdate(NoTimestamp, SyncLane)

							v87.tag = ForceUpdate
							enqueueUpdate(p13, v87)
						end
					end

					p13.lanes = mergeLanes(p13.lanes, SyncLane)

					return
				end

				attachPingListener(p11, p14, p15)
				v85.flags = bit32.bor(v85.flags, ShouldCapture)
				v85.lanes = p15

				return
			end

			v85 = v85.return_
		until v85 == nil

		p14 = (getComponentName(p13.type) or "A React component") .. " suspended while rendering, but no fallback UI was specified.\n" .. "\n" .. "Add a <Suspense fallback=...> component higher in the tree to " .. "provide a loading indicator or placeholder to display."
	end

	p17()

	local v88 = createCapturedValue(p14, p13)

	repeat
		if p12.tag == HostRoot then
			p12.flags = bit32.bor(p12.flags, ShouldCapture)

			local v89 = pickArbitraryLane(p15)

			p12.lanes = mergeLanes(p12.lanes, v89)

			local v90 = createRootErrorUpdate(p12, v88, v89, p16)

			enqueueCapturedUpdate(p12, v90)

			return
		end

		if p12.tag == ClassComponent then
			local type = p12.type
			local stateNode = p12.stateNode

			if bit32.band(p12.flags, DidCapture) == NoFlags and (typeof(type.getDerivedStateFromError) == "function" or stateNode ~= nil and typeof(stateNode.componentDidCatch) == "function" and not v45(stateNode)) then
				p12.flags = bit32.bor(p12.flags, ShouldCapture)

				local v93 = pickArbitraryLane(p15)

				p12.lanes = mergeLanes(p12.lanes, v93)

				local v94 = createClassErrorUpdate(p12, v88, v93)

				enqueueCapturedUpdate(p12, v94)

				return
			end
		end

		p12 = p12.return_
	until p12 == nil
end

return {
	throwException = throwException,
	createRootErrorUpdate = createRootErrorUpdate,
	createClassErrorUpdate = createClassErrorUpdate
}
