local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map

require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local noTimeout = ReactFiberHostConfig.noTimeout
local supportsHydration = ReactFiberHostConfig.supportsHydration
local ReactFibernew = require(script.Parent["ReactFiber.new"])
local createHostRootFiber = ReactFibernew.createHostRootFiber
local ReactFiberLane = require(script.Parent.ReactFiberLane)
local NoLanes = ReactFiberLane.NoLanes
local NoLanePriority = ReactFiberLane.NoLanePriority
local NoTimestamp = ReactFiberLane.NoTimestamp
local createLaneMap = ReactFiberLane.createLaneMap
local Shared = require(parent.Shared)
local ReactFeatureFlags = Shared.ReactFeatureFlags
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableSuspenseCallback = ReactFeatureFlags.enableSuspenseCallback

local Scheduler = require(parent.Scheduler)
local unstable_getThreadID = Scheduler.tracing.unstable_getThreadID
local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])
local initializeUpdateQueue = ReactUpdateQueuenew.initializeUpdateQueue
local LegacyRoot = ReactRootTags.LegacyRoot
local BlockingRoot = ReactRootTags.BlockingRoot
local ConcurrentRoot = ReactRootTags.ConcurrentRoot

local function FiberRootNode(containerInfo, tag, hydrate)
	local v = {
		tag = tag,
		containerInfo = containerInfo,
		pendingChildren = nil,
		current = nil,
		pingCache = nil,
		finishedWork = nil,
		timeoutHandle = noTimeout,
		context = nil,
		pendingContext = nil,
		hydrate = hydrate,
		callbackNode = nil,
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
		v.mutableSourceEagerHydrationData = nil
	end

	if enableSchedulerTracing then
		v.interactionThreadID = unstable_getThreadID()
		v.memoizedInteractions = Set.new()
		v.pendingInteractionMap = Map.new()
	end

	if enableSuspenseCallback then
		v.hydrationCallbacks = nil
	end

	if not ReactGlobals.__DEV__ then
		return v
	end

	if tag == BlockingRoot then
		v._debugRootType = "createBlockingRoot()"
		return v
	end

	if tag == ConcurrentRoot then
		v._debugRootType = "createRoot()"
		return v
	elseif tag == LegacyRoot then
		v._debugRootType = "createLegacyRoot()"
	end

	return v
end

return {
	createFiberRoot = function(containerInfo, tag, hydrate: boolean, hydrationCallbacks)
		local stateNode = FiberRootNode(containerInfo, tag, hydrate)

		if enableSuspenseCallback then
			stateNode.hydrationCallbacks = hydrationCallbacks
		end

		local hostRootFiber = createHostRootFiber(tag)
		stateNode.current = hostRootFiber
		hostRootFiber.stateNode = stateNode

		initializeUpdateQueue(hostRootFiber)

		return stateNode
	end
}
