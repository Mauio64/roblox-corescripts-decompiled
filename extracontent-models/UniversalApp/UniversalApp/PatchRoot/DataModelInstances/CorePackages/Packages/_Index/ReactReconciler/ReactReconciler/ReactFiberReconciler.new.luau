local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
require(parent.Shared)

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local __DEV__ = ReactGlobals.__DEV__

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)

require(script.Parent.ReactFiberHostConfig)

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local FundamentalComponent = ReactWorkTags.FundamentalComponent
require(parent.Shared)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactFiberTreeReflection = require(script.Parent.ReactFiberTreeReflection)
local findCurrentHostFiber = ReactFiberTreeReflection.findCurrentHostFiber

local findCurrentHostFiberWithNoPortals = ReactFiberTreeReflection.findCurrentHostFiberWithNoPortals
local Shared2 = require(parent.Shared)
local get = Shared2.ReactInstanceMap.get
local HostComponent = ReactWorkTags.HostComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local Shared3 = require(parent.Shared)
local getComponentName = Shared3.getComponentName
local Shared4 = require(parent.Shared)
local invariant = Shared4.invariant
local Shared5 = require(parent.Shared)
local describeError = Shared5.describeError

local Shared6 = require(parent.Shared)
local enableSchedulingProfiler = Shared6.ReactFeatureFlags.enableSchedulingProfiler
local Shared7 = require(parent.Shared)
local ReactSharedInternals = Shared7.ReactSharedInternals
local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local getPublicInstance = ReactFiberHostConfig.getPublicInstance
local ReactFiberContextnew = require(script.Parent["ReactFiberContext.new"])
local findCurrentUnmaskedContext = ReactFiberContextnew.findCurrentUnmaskedContext
local processChildContext = ReactFiberContextnew.processChildContext
local emptyContextObject = ReactFiberContextnew.emptyContextObject
local isContextProvider = ReactFiberContextnew.isContextProvider
local ReactFiberRootnew = require(script.Parent["ReactFiberRoot.new"])
local createFiberRoot = ReactFiberRootnew.createFiberRoot
local ReactFiberDevToolsHooknew = require(script.Parent["ReactFiberDevToolsHook.new"])
local injectInternals = ReactFiberDevToolsHooknew.injectInternals
local onScheduleRoot = ReactFiberDevToolsHooknew.onScheduleRoot
local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
local requestEventTime = ReactFiberWorkLoopnew.requestEventTime
local requestUpdateLane = ReactFiberWorkLoopnew.requestUpdateLane
local scheduleUpdateOnFiber = ReactFiberWorkLoopnew.scheduleUpdateOnFiber
local flushRoot = ReactFiberWorkLoopnew.flushRoot
local batchedEventUpdates = ReactFiberWorkLoopnew.batchedEventUpdates
local batchedUpdates = ReactFiberWorkLoopnew.batchedUpdates
local unbatchedUpdates = ReactFiberWorkLoopnew.unbatchedUpdates
local flushSync = ReactFiberWorkLoopnew.flushSync
local flushControlled = ReactFiberWorkLoopnew.flushControlled
local deferredUpdates = ReactFiberWorkLoopnew.deferredUpdates
local discreteUpdates = ReactFiberWorkLoopnew.discreteUpdates
local flushDiscreteUpdates = ReactFiberWorkLoopnew.flushDiscreteUpdates
local flushPassiveEffects = ReactFiberWorkLoopnew.flushPassiveEffects
local warnIfNotScopedWithMatchingAct = ReactFiberWorkLoopnew.warnIfNotScopedWithMatchingAct
local warnIfUnmockedScheduler = ReactFiberWorkLoopnew.warnIfUnmockedScheduler
local IsThisRendererActing = ReactFiberWorkLoopnew.IsThisRendererActing
local act = ReactFiberWorkLoopnew.act
local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])
local createUpdate = ReactUpdateQueuenew.createUpdate
local enqueueUpdate = ReactUpdateQueuenew.enqueueUpdate
local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)
local isRendering = ReactCurrentFiber.isRendering

local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local StrictMode = ReactTypeOfMode.StrictMode
local SyncLane = ReactFiberLane.SyncLane
local InputDiscreteHydrationLane = ReactFiberLane.InputDiscreteHydrationLane
local SelectiveHydrationLane = ReactFiberLane.SelectiveHydrationLane
local NoTimestamp = ReactFiberLane.NoTimestamp
local getHighestPriorityPendingLanes = ReactFiberLane.getHighestPriorityPendingLanes
local higherPriorityLane = ReactFiberLane.higherPriorityLane
local getCurrentUpdateLanePriority = ReactFiberLane.getCurrentUpdateLanePriority
local setCurrentUpdateLanePriority = ReactFiberLane.setCurrentUpdateLanePriority
local ReactFiberHotReloadingnew = require(script.Parent["ReactFiberHotReloading.new"])
local scheduleRefresh = ReactFiberHotReloadingnew.scheduleRefresh
local scheduleRoot = ReactFiberHotReloadingnew.scheduleRoot
local setRefreshHandler = ReactFiberHotReloadingnew.setRefreshHandler
local findHostInstancesForRefresh = ReactFiberHotReloadingnew.findHostInstancesForRefresh
local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markRenderScheduled = SchedulingProfiler.markRenderScheduled

local New = {}
New.ReactRootTags = ReactRootTags
New.ReactWorkTags = ReactWorkTags
New.ReactTypeOfMode = ReactTypeOfMode
New.ReactFiberFlags = ReactFiberFlags
New.getNearestMountedFiber = ReactFiberTreeReflection.getNearestMountedFiber

New.findCurrentFiberUsingSlowPath = ReactFiberTreeReflection.findCurrentFiberUsingSlowPath

local ReactPortal = require(script.Parent.ReactPortal)
New.createPortal = ReactPortal.createPortal
local set, v

if __DEV__ then
	set = {}
	v = false
else
	set = nil
	v = nil
end

local function getContextForSubtree(p) -- 1 equivalent call inferred from this helper
	if not p then
		return emptyContextObject
	end

	local v2 = get(p)
	local currentUnmaskedContext = findCurrentUnmaskedContext(v2)

	if v2.tag ~= ClassComponent then
		return currentUnmaskedContext
	end

	local kind = v2.type

	if isContextProvider(kind) then
		return processChildContext(v2, kind, currentUnmaskedContext)
	end

	return currentUnmaskedContext
end

local function findHostInstance(p)
	local v2 = get(p)

	if v2 == nil then
		if typeof(p.render) == "function" then
			invariant(false, "Unable to find node on an unmounted component.")
		else
			invariant(false, "Argument appears to not be a ReactComponent. Keys: %s", table.concat(Object.keys(p)))
		end
	end

	local currentHostFiber = findCurrentHostFiber(v2)

	if currentHostFiber == nil then
		return nil
	end

	return currentHostFiber.stateNode
end

function New.createContainer(p, p2, flag: boolean, p3)
	return createFiberRoot(p, p2, flag, p3)
end

function New.updateContainer(element, state, p, callback)
	if __DEV__ then
		onScheduleRoot(state, element)
	end

	local current = state.current
	local v2 = requestEventTime()

	if __DEV__ and ReactGlobals.__TESTEZ_RUNNING_TEST__ then
		warnIfUnmockedScheduler(current)
		warnIfNotScopedWithMatchingAct(current)
	end

	local v3 = requestUpdateLane(current)

	if enableSchedulingProfiler then
		markRenderScheduled(v3)
	end

	local contextForSubtree = getContextForSubtree(p) -- inferred equivalent call

	if state.context == nil then
		state.context = contextForSubtree
	else
		state.pendingContext = contextForSubtree
	end

	if __DEV__ and isRendering and ReactCurrentFiber.current ~= nil and not v then
		v = true
		console.error(
			"Render methods should be a pure function of props and state; triggering nested component updates from render is not allowed. If necessary, trigger nested updates in componentDidUpdate.\n\nCheck the render method of %s.",
			getComponentName(ReactCurrentFiber.current.type) or "Unknown"
		)
	end

	local update = createUpdate(v2, v3)

	if element == nil then
		element = Object.None
	end

	update.payload = { element = element }

	if callback ~= nil then
		if __DEV__ and typeof(callback) ~= "function" then
			console.error(
				"render(...): Expected the last optional `callback` argument to be a function. Instead received: %s.",
				(tostring(callback))
			)
		end

		update.callback = callback
	end

	enqueueUpdate(current, update)
	scheduleUpdateOnFiber(current, v3, v2)

	return v3
end

New.batchedEventUpdates = batchedEventUpdates
New.batchedUpdates = batchedUpdates
New.unbatchedUpdates = unbatchedUpdates
New.deferredUpdates = deferredUpdates
New.discreteUpdates = discreteUpdates
New.flushDiscreteUpdates = flushDiscreteUpdates
New.flushControlled = flushControlled
New.flushSync = flushSync
New.flushPassiveEffects = flushPassiveEffects
New.IsThisRendererActing = IsThisRendererActing
New.act = act

function New.getPublicRootInstance(p)
	local current = p.current

	if not current.child then
		return nil
	end

	if current.child.tag == HostComponent then
		return getPublicInstance(current.child.stateNode)
	end

	return current.child.stateNode
end

local fn

function New.attemptSynchronousHydration(p)
	if p.tag == HostRoot then
		local stateNode = p.stateNode

		if stateNode.hydrate then
			flushRoot(stateNode, (getHighestPriorityPendingLanes(stateNode)))
		end
	elseif p.tag == SuspenseComponent then
		local v2 = requestEventTime()
		flushSync(function()
			return scheduleUpdateOnFiber(p, SyncLane, v2)
		end)

		fn(p, InputDiscreteHydrationLane)
	end
end

local function markRetryLaneImpl(p, p2) -- 2 equivalent calls inferred from this helper
	local memoizedState = p.memoizedState

	if memoizedState and memoizedState ~= nil and memoizedState.dehydrated ~= nil then
		memoizedState.retryLane = higherPriorityLane(memoizedState.retryLane, p2)
	end
end

fn = function(p, p2)
	markRetryLaneImpl(p, p2) -- inferred equivalent call
	local alternate = p.alternate

	if alternate then
		markRetryLaneImpl(alternate, p2) -- inferred equivalent call
	end
end

function New.attemptUserBlockingHydration(p)
	if p.tag ~= SuspenseComponent then
		return
	end

	local inputDiscreteHydrationLane = InputDiscreteHydrationLane
	scheduleUpdateOnFiber(p, inputDiscreteHydrationLane, (requestEventTime()))
	fn(p, inputDiscreteHydrationLane)
end

function New.attemptContinuousHydration(p)
	if p.tag ~= SuspenseComponent then
		return
	end

	local selectiveHydrationLane = SelectiveHydrationLane
	scheduleUpdateOnFiber(p, selectiveHydrationLane, (requestEventTime()))
	fn(p, selectiveHydrationLane)
end

function New.attemptHydrationAtCurrentPriority(p)
	if p.tag ~= SuspenseComponent then
		return
	end

	local v2 = requestEventTime()
	local v3 = requestUpdateLane(p)
	scheduleUpdateOnFiber(p, v3, v2)
	fn(p, v3)
end

function New.runWithPriority(p, callback)
	local currentUpdateLanePriority = getCurrentUpdateLanePriority()

	setCurrentUpdateLanePriority(p)
	local success, result = xpcall(callback, describeError)
	setCurrentUpdateLanePriority(currentUpdateLanePriority)

	if not success then
		error(result)
	end

	return result
end

New.getCurrentUpdateLanePriority = getCurrentUpdateLanePriority

New.findHostInstance = findHostInstance

function New.findHostInstanceWithWarning(p, p2: string)
	if not __DEV__ then
		return findHostInstance(p)
	end

	local v2 = get(p)

	if v2 == nil then
		if typeof(p.render) == "function" then
			invariant(false, "Unable to find node on an unmounted component.")
		else
			invariant(false, "Argument appears to not be a ReactComponent. Keys: %s", table.concat(Object.keys(p)))
		end
	end

	local currentHostFiber = findCurrentHostFiber(v2)

	if currentHostFiber == nil then
		return nil
	end

	if bit32.band(currentHostFiber.mode, StrictMode) == 0 then
		return currentHostFiber.stateNode
	end

	local v3 = getComponentName(v2.type) or "Component"

	if set[v3] then
		return currentHostFiber.stateNode
	end

	set[v3] = true

	local current = ReactCurrentFiber.current
	local success, result = xpcall(function()
		setCurrentFiber(currentHostFiber)

		if bit32.band(v2.mode, StrictMode) == 0 then
			console.error(
				"%s is deprecated in StrictMode. %s was passed an instance of %s which renders StrictMode children. Instead, add a ref directly to the element you want to reference. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-find-node",
				p2,
				p2,
				v3
			)
		else
			console.error(
				"%s is deprecated in StrictMode. %s was passed an instance of %s which is inside StrictMode. Instead, add a ref directly to the element you want to reference. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-find-node",
				p2,
				p2,
				v3
			)
		end
	end, describeError)

	if current then
		setCurrentFiber(current)
	else
		resetCurrentFiber()
	end

	if not success then
		error(result)
	end

	return currentHostFiber.stateNode
end

function New.findHostInstanceWithNoPortals(p)
	local currentHostFiberWithNoPortals = findCurrentHostFiberWithNoPortals(p)

	if currentHostFiberWithNoPortals == nil then
		return nil
	end

	if currentHostFiberWithNoPortals.tag == FundamentalComponent then
		return currentHostFiberWithNoPortals.stateNode.instance
	end

	return currentHostFiberWithNoPortals.stateNode
end

local function shouldSuspendImpl(_): boolean
	return false
end

function New.shouldSuspend(p)
	return shouldSuspendImpl(p)
end

local setSuspenseHandler, fn2, fn3, fn4, fn5, fn6, fn7, fn8

if __DEV__ then
	local function copyWithDeleteImpl(p, list, p2: number)
		local item = list[p2]
		local selected

		if Array.isArray(p) then
			selected = Array.slice(p)
		else
			selected = table.clone(p)
		end

		if p2 + 1 ~= #list then
			selected[item] = copyWithDeleteImpl(p[item], list, p2 + 1)
			return selected
		end

		if Array.isArray(selected) then
			Array.splice(selected, item, 1)
			return selected
		end

		selected[item] = nil

		return selected
	end

	local function copyWithDelete(p, p2) -- 2 equivalent calls inferred from this helper
		return (copyWithDeleteImpl(p, p2, 0))
	end

	local function copyWithRenameImpl(p, list, list2, p2: number)
		local item = list[p2]
		local selected

		if Array.isArray(p) then
			selected = Array.slice(p)
		else
			selected = table.clone(p)
		end

		if p2 + 1 ~= #list then
			selected[item] = copyWithRenameImpl(p[item], list, list2, p2 + 1)

			return selected
		end

		selected[list2[p2]] = selected[item]

		if Array.isArray(selected) then
			Array.splice(selected, item, 1)
			return selected
		end

		selected[item] = nil
		return selected
	end

	local function copyWithRename(p, list, list2)
		if #list ~= #list2 then
			console.warn("copyWithRename() expects paths of the same length")
			return nil
		end

		for i = 1, #list2 do
			if list[i] ~= list2[i] then
				console.warn("copyWithRename() expects paths to be the same except for the deepest key")

				return nil
			end
		end

		return (copyWithRenameImpl(p, list, list2, 0))
	end

	local function copyWithSetImpl(p, list, p2: number, p3)
		if #list + 1 <= p2 then
			return p3
		end

		local item = list[p2]
		local selected

		if Array.isArray(p) then
			selected = Array.slice(p)
		else
			selected = table.clone(p)
		end

		selected[item] = copyWithSetImpl(p[item], list, p2 + 2, p3)
		return selected
	end

	local function copyWithSet(p, p2, p3) -- 2 equivalent calls inferred from this helper
		return (copyWithSetImpl(p, p2, 1, p3))
	end

	local function findHook(p, p2: number) -- 3 equivalent calls inferred from this helper
		local hook = p.memoizedState

		while hook ~= nil and p2 > 1 do
			hook = hook.next
			p2 -= 1
		end

		return hook
	end

	setSuspenseHandler = function(callback)
		shouldSuspendImpl = callback
	end

	fn2 = function(p, p2: number, p3, p4)
		local hook = findHook(p, p2) -- inferred equivalent call

		if hook ~= nil then
			local v2 = copyWithSet(hook.memoizedState, p3, p4) -- inferred equivalent call
			hook.memoizedState = v2
			hook.baseState = v2

			p.memoizedProps = table.clone(p.memoizedProps)

			scheduleUpdateOnFiber(p, SyncLane, NoTimestamp)
		end
	end
	fn3 = function(p, p2: number, p3)
		local hook = findHook(p, p2) -- inferred equivalent call

		if hook ~= nil then
			local v2 = copyWithDelete(hook.memoizedState, p3) -- inferred equivalent call
			hook.memoizedState = v2
			hook.baseState = v2

			p.memoizedProps = table.clone(p.memoizedProps)

			scheduleUpdateOnFiber(p, SyncLane, NoTimestamp)
		end
	end
	fn4 = function(p, p2: number, p3, p4)
		local hook = findHook(p, p2) -- inferred equivalent call

		if hook ~= nil then
			local v2 = copyWithRename(hook.memoizedState, p3, p4)
			hook.memoizedState = v2
			hook.baseState = v2

			p.memoizedProps = table.clone(p.memoizedProps)

			scheduleUpdateOnFiber(p, SyncLane, NoTimestamp)
		end
	end

	fn5 = function(state, p, p2)
		state.pendingProps = copyWithSet(state.memoizedProps, p, p2) -- inferred equivalent call

		local alternate = state.alternate

		if alternate then
			alternate.pendingProps = state.pendingProps
		end

		scheduleUpdateOnFiber(state, SyncLane, NoTimestamp)
	end
	fn6 = function(state, p)
		state.pendingProps = copyWithDelete(state.memoizedProps, p) -- inferred equivalent call

		local alternate = state.alternate

		if alternate then
			alternate.pendingProps = state.pendingProps
		end

		scheduleUpdateOnFiber(state, SyncLane, NoTimestamp)
	end
	fn7 = function(state, p, p2)
		state.pendingProps = copyWithRename(state.memoizedProps, p, p2)

		local alternate = state.alternate

		if alternate then
			alternate.pendingProps = state.pendingProps
		end

		scheduleUpdateOnFiber(state, SyncLane, NoTimestamp)
	end

	fn8 = function(p)
		scheduleUpdateOnFiber(p, SyncLane, NoTimestamp)
	end
else
	fn2 = nil
	fn3 = nil
	fn4 = nil
	fn5 = nil
	fn6 = nil
	fn7 = nil
	setSuspenseHandler = nil
	fn8 = nil
end

function findHostInstanceByFiber(p)
	local currentHostFiber = findCurrentHostFiber(p)

	if currentHostFiber == nil then
		return nil
	end

	return currentHostFiber.stateNode
end

function emptyFindFiberByHostInstance(_): nil
	return nil
end

function getCurrentFiberForDevTools()
	return ReactCurrentFiber.current
end

function New.injectIntoDevTools(data)
	local findFiberByHostInstance = data.findFiberByHostInstance
	local reactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
	local getCurrentFiberForDevTools2

	if __DEV__ then
		getCurrentFiberForDevTools2 = getCurrentFiberForDevTools
	end

	local v2 = {
		bundleType = data.bundleType,
		version = data.version,
		rendererPackageName = data.rendererPackageName,
		rendererConfig = data.rendererConfig,
		overrideHookState = fn2,
		overrideHookStateDeletePath = fn3,
		overrideHookStateRenamePath = fn4,
		overrideProps = fn5,
		overridePropsDeletePath = fn6,
		overridePropsRenamePath = fn7,
		setSuspenseHandler = setSuspenseHandler,
		scheduleUpdate = fn8,
		currentDispatcherRef = reactCurrentDispatcher,
		findHostInstanceByFiber = findHostInstanceByFiber,
		findFiberByHostInstance = findFiberByHostInstance or emptyFindFiberByHostInstance,
		findHostInstancesForRefresh = 0,
		scheduleRefresh = 0,
		scheduleRoot = 0,
		setRefreshHandler = 0,
		getCurrentFiber = 0
	}
	local findHostInstancesForRefresh2

	if __DEV__ then
		findHostInstancesForRefresh2 = findHostInstancesForRefresh
	end

	v2.findHostInstancesForRefresh = findHostInstancesForRefresh2
	local scheduleRefresh2

	if __DEV__ then
		scheduleRefresh2 = scheduleRefresh
	end

	v2.scheduleRefresh = scheduleRefresh2
	local scheduleRoot2

	if __DEV__ then
		scheduleRoot2 = scheduleRoot
	end

	v2.scheduleRoot = scheduleRoot2
	local setRefreshHandler2

	if __DEV__ then
		setRefreshHandler2 = setRefreshHandler
	end

	v2.setRefreshHandler = setRefreshHandler2

	v2.getCurrentFiber = getCurrentFiberForDevTools2
	return injectInternals(v2)
end

New.robloxReactProfiling = require(script.Parent.RobloxReactProfiling)
New.schedulingProfiler = {
	profilerEventTypes = SchedulingProfiler.profilerEventTypes,
	registerProfilerEventCallback = SchedulingProfiler.registerProfilerEventCallback
}

return New
