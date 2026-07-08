local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map

require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)
local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local noTimeout = ReactFiberHostConfig.noTimeout
local supportsHydration = ReactFiberHostConfig.supportsHydration
local createHostRootFiber = require(script.Parent["ReactFiber.new"]).createHostRootFiber
local ReactFiberLane = require(script.Parent.ReactFiberLane)
local NoLanes = ReactFiberLane.NoLanes
local NoLanePriority = ReactFiberLane.NoLanePriority
local NoTimestamp = ReactFiberLane.NoTimestamp
local createLaneMap = ReactFiberLane.createLaneMap
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableSuspenseCallback = ReactFeatureFlags.enableSuspenseCallback
local unstable_getThreadID = require(ParentParent.Scheduler).tracing.unstable_getThreadID
local initializeUpdateQueue = require(script.Parent["ReactUpdateQueue.new"]).initializeUpdateQueue
local LegacyRoot = ReactRootTags.LegacyRoot
local BlockingRoot = ReactRootTags.BlockingRoot
local ConcurrentRoot = ReactRootTags.ConcurrentRoot
local t1 = {}

local function FiberRootNode(p1, p2, p3) -- line: 49
	-- upvalues: noTimeout (copy), NoLanePriority (copy), createLaneMap (copy), NoLanes (copy), NoTimestamp (copy), supportsHydration (copy), enableSchedulerTracing (copy), unstable_getThreadID (copy), Set (copy), Map (copy), enableSuspenseCallback (copy), ReactGlobals (copy), BlockingRoot (copy), ConcurrentRoot (copy), LegacyRoot (copy)
	local t2 = {
		pendingChildren = nil,
		current = nil,
		pingCache = nil,
		finishedWork = nil,
		context = nil,
		pendingContext = nil,
		callbackNode = nil,
		tag = p2,
		containerInfo = p1,
		timeoutHandle = noTimeout,
		hydrate = p3,
		callbackPriority = NoLanePriority,
		eventTimes = createLaneMap(NoLanes),
		expirationTimes = createLaneMap(NoTimestamp),
		pendingLanes = NoLanes,
		suspendedLanes = NoLanes,
		pingedLanes = NoLanes,
		expiredLanes = NoLanes,
		mutableReadLanes = NoLanes,
		finishedLanes = NoLanes,
		entangledLanes = NoLanes,
		entanglements = createLaneMap(NoLanes)
	}

	if supportsHydration then
		t2.mutableSourceEagerHydrationData = nil
	end

	if enableSchedulerTracing then
		t2.interactionThreadID = unstable_getThreadID()
		t2.memoizedInteractions = Set.new()
		t2.pendingInteractionMap = Map.new()
	end

	if enableSuspenseCallback then
		t2.hydrationCallbacks = nil
	end

	if ReactGlobals.__DEV__ then
		if p2 == BlockingRoot then
			t2._debugRootType = "createBlockingRoot()"

			return t2
		end

		if p2 == ConcurrentRoot then
			t2._debugRootType = "createRoot()"

			return t2
		end

		if p2 == LegacyRoot then
			t2._debugRootType = "createLegacyRoot()"
		end
	end

	return t2
end

function t1.createFiberRoot(p4, p5, b1: boolean, p6) -- line: 105
	-- upvalues: FiberRootNode (copy), enableSuspenseCallback (copy), createHostRootFiber (copy), initializeUpdateQueue (copy)
	local v34 = FiberRootNode(p4, p5, b1)

	if enableSuspenseCallback then
		v34.hydrationCallbacks = p6
	end

	local v35 = createHostRootFiber(p5)

	v34.current = v35
	v35.stateNode = v34
	initializeUpdateQueue(v35)

	return v34
end

return t1
