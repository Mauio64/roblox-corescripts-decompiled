local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.Shared)

local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local __DEV__ = ReactGlobals.__DEV__
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)

require(script.Parent.ReactFiberHostConfig)

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local FundamentalComponent = ReactWorkTags.FundamentalComponent

require(ParentParent.Shared)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactFiberTreeReflection = require(script.Parent.ReactFiberTreeReflection)
local findCurrentHostFiber = ReactFiberTreeReflection.findCurrentHostFiber
local findCurrentHostFiberWithNoPortals = ReactFiberTreeReflection.findCurrentHostFiberWithNoPortals
local get = require(ParentParent.Shared).ReactInstanceMap.get
local HostComponent = ReactWorkTags.HostComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local getComponentName = require(ParentParent.Shared).getComponentName
local invariant = require(ParentParent.Shared).invariant
local describeError = require(ParentParent.Shared).describeError
local enableSchedulingProfiler = require(ParentParent.Shared).ReactFeatureFlags.enableSchedulingProfiler
local ReactSharedInternals = require(ParentParent.Shared).ReactSharedInternals
local getPublicInstance = require(script.Parent.ReactFiberHostConfig).getPublicInstance
local lib = require(script.Parent["ReactFiberContext.new"])
local findCurrentUnmaskedContext = lib.findCurrentUnmaskedContext
local processChildContext = lib.processChildContext
local emptyContextObject = lib.emptyContextObject
local isContextProvider = lib.isContextProvider
local createFiberRoot = require(script.Parent["ReactFiberRoot.new"]).createFiberRoot
local lib2 = require(script.Parent["ReactFiberDevToolsHook.new"])
local injectInternals = lib2.injectInternals
local onScheduleRoot = lib2.onScheduleRoot
local lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
local requestEventTime = lib3.requestEventTime
local requestUpdateLane = lib3.requestUpdateLane
local scheduleUpdateOnFiber = lib3.scheduleUpdateOnFiber
local flushRoot = lib3.flushRoot
local batchedEventUpdates = lib3.batchedEventUpdates
local batchedUpdates = lib3.batchedUpdates
local unbatchedUpdates = lib3.unbatchedUpdates
local flushSync = lib3.flushSync
local flushControlled = lib3.flushControlled
local deferredUpdates = lib3.deferredUpdates
local discreteUpdates = lib3.discreteUpdates
local flushDiscreteUpdates = lib3.flushDiscreteUpdates
local flushPassiveEffects = lib3.flushPassiveEffects
local warnIfNotScopedWithMatchingAct = lib3.warnIfNotScopedWithMatchingAct
local warnIfUnmockedScheduler = lib3.warnIfUnmockedScheduler
local IsThisRendererActing = lib3.IsThisRendererActing
local act = lib3.act
local lib4 = require(script.Parent["ReactUpdateQueue.new"])
local createUpdate = lib4.createUpdate
local enqueueUpdate = lib4.enqueueUpdate
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
local lib5 = require(script.Parent["ReactFiberHotReloading.new"])
local scheduleRefresh = lib5.scheduleRefresh
local scheduleRoot = lib5.scheduleRoot
local setRefreshHandler = lib5.setRefreshHandler
local findHostInstancesForRefresh = lib5.findHostInstancesForRefresh
local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markRenderScheduled = SchedulingProfiler.markRenderScheduled
local t1 = {
	ReactRootTags = ReactRootTags,
	ReactWorkTags = ReactWorkTags,
	ReactTypeOfMode = ReactTypeOfMode,
	ReactFiberFlags = ReactFiberFlags,
	getNearestMountedFiber = ReactFiberTreeReflection.getNearestMountedFiber,
	findCurrentFiberUsingSlowPath = ReactFiberTreeReflection.findCurrentFiberUsingSlowPath,
	createPortal = require(script.Parent.ReactPortal).createPortal
}
local u79 = nil
local t2 = nil

if __DEV__ then
	u79 = false
	t2 = {}
end

local function getContextForSubtree(p1) -- line: 181
	-- upvalues: emptyContextObject (copy), get (copy), findCurrentUnmaskedContext (copy), ClassComponent (copy), isContextProvider (copy), processChildContext (copy)
	if not p1 then
		return emptyContextObject
	end

	local v102 = get(p1)
	local v103 = findCurrentUnmaskedContext(v102)

	if v102.tag == ClassComponent then
		local type = v102.type

		if isContextProvider(type) then
			return processChildContext(v102, type, v103)
		end
	end

	return v103
end
local function findHostInstance(t3: {[any]: any}) -- line: 199
	-- upvalues: get (copy), invariant (copy), Object (copy), findCurrentHostFiber (copy)
	local v106 = get(t3)

	if v106 == nil then
		if typeof(t3.render) == "function" then
			invariant(false, "Unable to find node on an unmounted component.")
		else
			invariant(false, "Argument appears to not be a ReactComponent. Keys: %s", table.concat(Object.keys(t3)))
		end
	end

	local v107 = findCurrentHostFiber(v106)

	if v107 == nil then
		return nil
	end

	return v107.stateNode
end

function t1.createContainer(p2, p3, b1: boolean, p4) -- line: 293
	-- upvalues: createFiberRoot (copy)
	return createFiberRoot(p2, p3, b1, p4)
end
function t1.updateContainer(p5, p6, p7, p8: ((...any) -> ...any)?) -- line: 302
	-- upvalues: __DEV__ (copy), onScheduleRoot (copy), requestEventTime (copy), ReactGlobals (copy), warnIfUnmockedScheduler (copy), warnIfNotScopedWithMatchingAct (copy), requestUpdateLane (copy), enableSchedulingProfiler (copy), markRenderScheduled (copy), emptyContextObject (copy), get (copy), findCurrentUnmaskedContext (copy), ClassComponent (copy), isContextProvider (copy), processChildContext (copy), isRendering (copy), ReactCurrentFiber (copy), u79 (ref), console (copy), getComponentName (copy), createUpdate (copy), Object (copy), enqueueUpdate (copy), scheduleUpdateOnFiber (copy)
	local g128 = nil
	local v129 = nil
	local type = nil
	local v127 = nil

	if __DEV__ then
		onScheduleRoot(p6, p5)
	end

	local current = p6.current
	local v125 = requestEventTime()

	if __DEV__ and ReactGlobals.__TESTEZ_RUNNING_TEST__ then
		warnIfUnmockedScheduler(current)
		warnIfNotScopedWithMatchingAct(current)
	end

	local v126 = requestUpdateLane(current)

	if enableSchedulingProfiler then
		markRenderScheduled(v126)
	end

	if not p7 then
		v127 = emptyContextObject
		g128 = true
	end

	if not g128 then
		v129 = get(p7)
		v127 = findCurrentUnmaskedContext(v129)
	end

	repeat
		if g128 or (g128 or v129.tag == ClassComponent) then
			if not g128 then
				if not g128 then
					type = v129.type
				end
			end

			if g128 or (g128 or isContextProvider(type)) then
				if not g128 then
					if not g128 then
						v127 = processChildContext(v129, type, v127)
					end
				end

				g128 = false

				if p6.context == nil then
					p6.context = v127
				else
					p6.pendingContext = v127
				end

				if __DEV__ and isRendering and ReactCurrentFiber.current ~= nil and not u79 then
					u79 = true
					console.error("Render methods should be a pure function of props and state; triggering nested component updates from render is not allowed. If necessary, trigger nested updates in componentDidUpdate.\n\nCheck the render method of %s.", getComponentName(ReactCurrentFiber.current.type) or "Unknown")
				end

				local v131 = createUpdate(v125, v126)

				if p5 == nil then
					p5 = Object.None
				end

				v131.payload = {
					element = p5
				}

				if p8 ~= nil then
					if __DEV__ and typeof(p8) ~= "function" then
						console.error("render(...): Expected the last optional `callback` argument to be a function. Instead received: %s.", (tostring(p8)))
					end

					v131.callback = p8
				end

				enqueueUpdate(current, v131)
				scheduleUpdateOnFiber(current, v126, v125)

				return v126
			end
		end

		g128 = true
	until not g128
end

t1.batchedEventUpdates = batchedEventUpdates
t1.batchedUpdates = batchedUpdates
t1.unbatchedUpdates = unbatchedUpdates
t1.deferredUpdates = deferredUpdates
t1.discreteUpdates = discreteUpdates
t1.flushDiscreteUpdates = flushDiscreteUpdates
t1.flushControlled = flushControlled
t1.flushSync = flushSync
t1.flushPassiveEffects = flushPassiveEffects
t1.IsThisRendererActing = IsThisRendererActing
t1.act = act

function t1.getPublicRootInstance(p9) -- line: 397
	-- upvalues: HostComponent (copy), getPublicInstance (copy)
	local current = p9.current

	if not current.child then
		return nil
	end

	if current.child.tag == HostComponent then
		return getPublicInstance(current.child.stateNode)
	end

	return current.child.stateNode
end

local u83 = nil

function t1.attemptSynchronousHydration(p10) -- line: 414
	-- upvalues: HostRoot (copy), getHighestPriorityPendingLanes (copy), flushRoot (copy), SuspenseComponent (copy), requestEventTime (copy), flushSync (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), InputDiscreteHydrationLane (copy), u83 (ref)
	if p10.tag == HostRoot then
		local stateNode = p10.stateNode

		if stateNode.hydrate then
			local v136 = getHighestPriorityPendingLanes(stateNode)

			flushRoot(stateNode, v136)

			return
		end
	elseif p10.tag == SuspenseComponent then
		local v137 = requestEventTime()

		flushSync(function() -- line: 424
			-- upvalues: scheduleUpdateOnFiber (copy), p10 (copy), SyncLane (copy), v137 (copy)
			return scheduleUpdateOnFiber(p10, SyncLane, v137)
		end)

		local v138 = InputDiscreteHydrationLane

		u83(p10, v138)
	end
end

local function markRetryLaneImpl(p11, p12) -- line: 435
	-- upvalues: higherPriorityLane (copy)
	local memoizedState = p11.memoizedState

	if memoizedState and (memoizedState ~= nil and memoizedState.dehydrated ~= nil) then
		memoizedState.retryLane = higherPriorityLane(memoizedState.retryLane, p12)
	end
end

function u83(p13, p14) -- line: 446
	-- upvalues: higherPriorityLane (copy)
	local memoizedState = p13.memoizedState

	if memoizedState and (memoizedState ~= nil and memoizedState.dehydrated ~= nil) then
		memoizedState.retryLane = higherPriorityLane(memoizedState.retryLane, p14)
	end

	local alternate = p13.alternate

	if alternate then
		local memoizedState2 = alternate.memoizedState

		if memoizedState2 and memoizedState2 ~= nil and memoizedState2.dehydrated ~= nil then
			memoizedState2.retryLane = higherPriorityLane(memoizedState2.retryLane, p14)
		end
	end
end
function t1.attemptUserBlockingHydration(p15) -- line: 455
	-- upvalues: SuspenseComponent (copy), requestEventTime (copy), InputDiscreteHydrationLane (copy), scheduleUpdateOnFiber (copy), u83 (ref)
	if p15.tag ~= SuspenseComponent then
		return
	end

	local v148 = requestEventTime()
	local v149 = InputDiscreteHydrationLane

	scheduleUpdateOnFiber(p15, v149, v148)
	u83(p15, v149)
end
function t1.attemptContinuousHydration(p16) -- line: 469
	-- upvalues: SuspenseComponent (copy), requestEventTime (copy), SelectiveHydrationLane (copy), scheduleUpdateOnFiber (copy), u83 (ref)
	if p16.tag ~= SuspenseComponent then
		return
	end

	local v151 = requestEventTime()
	local v152 = SelectiveHydrationLane

	scheduleUpdateOnFiber(p16, v152, v151)
	u83(p16, v152)
end
function t1.attemptHydrationAtCurrentPriority(p17) -- line: 483
	-- upvalues: SuspenseComponent (copy), requestEventTime (copy), requestUpdateLane (copy), scheduleUpdateOnFiber (copy), u83 (ref)
	if p17.tag ~= SuspenseComponent then
		return
	end

	local v154 = requestEventTime()
	local v155 = requestUpdateLane(p17)

	scheduleUpdateOnFiber(p17, v155, v154)
	u83(p17, v155)
end
function t1.runWithPriority(p18, p19: ((...any) -> ...any)) -- line: 495
	-- upvalues: getCurrentUpdateLanePriority (copy), setCurrentUpdateLanePriority (copy), describeError (copy)
	local v158 = getCurrentUpdateLanePriority()

	setCurrentUpdateLanePriority(p18)

	local ok, result = xpcall(p19, describeError)

	setCurrentUpdateLanePriority(v158)

	if not ok then
		error(result)
	end

	return result
end

t1.getCurrentUpdateLanePriority = getCurrentUpdateLanePriority
t1.findHostInstance = findHostInstance

function t1.findHostInstanceWithWarning(t4: {[any]: any}, s1: string) -- line: 220
	-- upvalues: __DEV__ (copy), get (copy), invariant (copy), Object (copy), findCurrentHostFiber (copy), StrictMode (copy), getComponentName (copy), t2 (ref), ReactCurrentFiber (copy), setCurrentFiber (copy), console (copy), describeError (copy), resetCurrentFiber (copy), findHostInstance (copy)
	if __DEV__ then
		local v110 = get(t4)

		if v110 == nil then
			if typeof(t4.render) == "function" then
				invariant(false, "Unable to find node on an unmounted component.")
			else
				invariant(false, "Argument appears to not be a ReactComponent. Keys: %s", table.concat(Object.keys(t4)))
			end
		end

		local v111 = findCurrentHostFiber(v110)

		if v111 == nil then
			return nil
		end

		if bit32.band(v111.mode, StrictMode) ~= 0 then
			local v112 = getComponentName(v110.type) or "Component"

			if not t2[v112] then
				t2[v112] = true

				local current = ReactCurrentFiber.current
				local ok, result = xpcall(function() -- line: 248
					-- upvalues: setCurrentFiber (copy), v111 (copy), v110 (copy), StrictMode (copy), console (copy), s1 (copy), v112 (copy)
					setCurrentFiber(v111)

					if bit32.band(v110.mode, StrictMode) ~= 0 then
						console.error("%s is deprecated in StrictMode. %s was passed an instance of %s which is inside StrictMode. Instead, add a ref directly to the element you want to reference. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-find-node", s1, s1, v112)

						return
					end

					console.error("%s is deprecated in StrictMode. %s was passed an instance of %s which renders StrictMode children. Instead, add a ref directly to the element you want to reference. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-find-node", s1, s1, v112)
				end, describeError)

				if current then
					setCurrentFiber(current)
				else
					resetCurrentFiber()
				end

				if not ok then
					error(result)
				end
			end
		end

		return v111.stateNode
	end

	return (findHostInstance(t4))
end
function t1.findHostInstanceWithNoPortals(p20) -- line: 513
	-- upvalues: findCurrentHostFiberWithNoPortals (copy), FundamentalComponent (copy)
	local v162 = findCurrentHostFiberWithNoPortals(p20)

	if v162 == nil then
		return nil
	end

	if v162.tag == FundamentalComponent then
		return v162.stateNode.instance
	end

	return v162.stateNode
end

local function shouldSuspendImpl(_) -- line: 524
	return false
end

function t1.shouldSuspend(p22) -- line: 528
	-- upvalues: shouldSuspendImpl (ref)
	return shouldSuspendImpl(p22)
end

local u86 = nil
local u87 = nil
local u88 = nil
local u89 = nil
local u90 = nil
local u91 = nil
local u92 = nil
local u93 = nil

if __DEV__ then
	local function copyWithDeleteImpl(t5: {[any]: any}, t6: {[any]: any}, n1: number) -- line: 543
		-- upvalues: Array (copy), copyWithDeleteImpl (copy)
		local v168 = t6[n1]
		local v169 = if not Array.isArray(t5) then table.clone(t5) else Array.slice(t5)

		if n1 + 1 == #t6 then
			if Array.isArray(v169) then
				Array.splice(v169, v168, 1)

				return v169
			end

			v169[v168] = nil

			return v169
		end

		v169[v168] = copyWithDeleteImpl(t5[v168], t6, n1 + 1)

		return v169
	end
	local function copyWithDelete(t7: {[any]: any}, t8: {[any]: any}) -- line: 571
		-- upvalues: copyWithDeleteImpl (copy)
		return (copyWithDeleteImpl(t7, t8, 0))
	end
	local function copyWithRenameImpl(t9: {[any]: any}, t10: {[any]: any}, t11: {[any]: any}, n2: number) -- line: 579
		-- upvalues: Array (copy), copyWithRenameImpl (copy)
		local v176 = t10[n2]
		local v177 = if not Array.isArray(t9) then table.clone(t9) else Array.slice(t9)

		if n2 + 1 == #t10 then
			v177[t11[n2]] = v177[v176]

			if Array.isArray(v177) then
				Array.splice(v177, v176, 1)

				return v177
			end

			v177[v176] = nil

			return v177
		end

		v177[v176] = copyWithRenameImpl(t9[v176], t10, t11, n2 + 1)

		return v177
	end
	local function copyWithRename(t12: {[any]: any}, t13: {[any]: any}, t14: {[any]: any}) -- line: 615
		-- upvalues: console (copy), copyWithRenameImpl (copy)
		if #t13 ~= #t14 then
			console.warn("copyWithRename() expects paths of the same length")

			return nil
		end

		for i = 1, #t14 do
			if t13[i] ~= t14[i] then
				console.warn("copyWithRename() expects paths to be the same except for the deepest key")

				return nil
			end
		end

		return (copyWithRenameImpl(t12, t13, t14, 0))
	end
	local function copyWithSetImpl(t15: {[any]: any}, t16: {[any]: any}, n3: number, p23) -- line: 637
		-- upvalues: Array (copy), copyWithSetImpl (copy)
		if n3 >= #t16 + 1 then
			return p23
		end

		local v186 = t16[n3]
		local v187 = if not Array.isArray(t15) then table.clone(t15) else Array.slice(t15)

		v187[v186] = copyWithSetImpl(t15[v186], t16, n3 + 2, p23)

		return v187
	end
	local function copyWithSet(t17: {[any]: any}, t18: {[any]: any}, p24) -- line: 659
		-- upvalues: copyWithSetImpl (copy)
		return (copyWithSetImpl(t17, t18, 1, p24))
	end
	local function findHook(p25, n4: number) -- line: 667
		local memoizedState = p25.memoizedState

		while memoizedState ~= nil and n4 > 1 do
			memoizedState = memoizedState.next
			n4 -= 1
		end

		return memoizedState
	end

	function u86(p26, n5: number, t19: {[any]: any}, p27) -- line: 679
		-- upvalues: copyWithSetImpl (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		local memoizedState = p26.memoizedState

		while memoizedState ~= nil and n5 > 1 do
			memoizedState = memoizedState.next
			n5 -= 1
		end

		if memoizedState ~= nil then
			local memoizedState3 = memoizedState.memoizedState
			local v200 = copyWithSetImpl(memoizedState3, t19, 1, p27)

			memoizedState.memoizedState = v200
			memoizedState.baseState = v200
			p26.memoizedProps = table.clone(p26.memoizedProps)
			scheduleUpdateOnFiber(p26, SyncLane, NoTimestamp)
		end
	end
	function u87(p28, n6: number, t20: {[any]: any}) -- line: 701
		-- upvalues: copyWithDeleteImpl (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		local memoizedState = p28.memoizedState

		while memoizedState ~= nil and n6 > 1 do
			memoizedState = memoizedState.next
			n6 -= 1
		end

		if memoizedState ~= nil then
			local memoizedState4 = memoizedState.memoizedState
			local v206 = copyWithDeleteImpl(memoizedState4, t20, 0)

			memoizedState.memoizedState = v206
			memoizedState.baseState = v206
			p28.memoizedProps = table.clone(p28.memoizedProps)
			scheduleUpdateOnFiber(p28, SyncLane, NoTimestamp)
		end
	end
	function u88(p29, n7: number, t21: {[any]: any}, t22: {[any]: any}) -- line: 722
		-- upvalues: copyWithRename (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		local memoizedState = p29.memoizedState

		while memoizedState ~= nil and n7 > 1 do
			memoizedState = memoizedState.next
			n7 -= 1
		end

		if memoizedState ~= nil then
			local v212 = copyWithRename(memoizedState.memoizedState, t21, t22)

			memoizedState.memoizedState = v212
			memoizedState.baseState = v212
			p29.memoizedProps = table.clone(p29.memoizedProps)
			scheduleUpdateOnFiber(p29, SyncLane, NoTimestamp)
		end
	end
	function u89(p30, t23: {[any]: any}, p31) -- line: 746
		-- upvalues: copyWithSetImpl (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		local memoizedProps = p30.memoizedProps

		p30.pendingProps = copyWithSetImpl(memoizedProps, t23, 1, p31)

		local alternate = p30.alternate

		if alternate then
			alternate.pendingProps = p30.pendingProps
		end

		scheduleUpdateOnFiber(p30, SyncLane, NoTimestamp)
	end
	function u90(p32, t24: {[any]: any}) -- line: 755
		-- upvalues: copyWithDeleteImpl (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		local memoizedProps = p32.memoizedProps

		p32.pendingProps = copyWithDeleteImpl(memoizedProps, t24, 0)

		local alternate = p32.alternate

		if alternate then
			alternate.pendingProps = p32.pendingProps
		end

		scheduleUpdateOnFiber(p32, SyncLane, NoTimestamp)
	end
	function u91(p33, t25: {[any]: any}, t26: {[any]: any}) -- line: 764
		-- upvalues: copyWithRename (copy), scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		p33.pendingProps = copyWithRename(p33.memoizedProps, t25, t26)

		local alternate = p33.alternate

		if alternate then
			alternate.pendingProps = p33.pendingProps
		end

		scheduleUpdateOnFiber(p33, SyncLane, NoTimestamp)
	end
	function u92(p34) -- line: 778
		-- upvalues: scheduleUpdateOnFiber (copy), SyncLane (copy), NoTimestamp (copy)
		scheduleUpdateOnFiber(p34, SyncLane, NoTimestamp)
	end
	function u93(p35: ((...any) -> ...any)) -- line: 782
		-- upvalues: shouldSuspendImpl (ref)
		shouldSuspendImpl = p35
	end
end

function findHostInstanceByFiber(p36) -- line: 787
	-- upvalues: findCurrentHostFiber (copy)
	local v229 = findCurrentHostFiber(p36)

	if v229 == nil then
		return nil
	end

	return v229.stateNode
end
function emptyFindFiberByHostInstance(_) -- line: 795
	return nil
end
function getCurrentFiberForDevTools() -- line: 799
	-- upvalues: ReactCurrentFiber (copy)
	return ReactCurrentFiber.current
end
function t1.injectIntoDevTools(t27: {[any]: any}) -- line: 803
	-- upvalues: ReactSharedInternals (copy), __DEV__ (copy), injectInternals (copy), u86 (ref), u87 (ref), u88 (ref), u89 (ref), u90 (ref), u91 (ref), u93 (ref), u92 (ref), findHostInstancesForRefresh (copy), scheduleRefresh (copy), scheduleRoot (copy), setRefreshHandler (copy)
	local findFiberByHostInstance = t27.findFiberByHostInstance
	local ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
	local _getCurrentFiberForDevTools = nil

	if __DEV__ then
		_getCurrentFiberForDevTools = getCurrentFiberForDevTools
	end

	return injectInternals({
		bundleType = t27.bundleType,
		version = t27.version,
		rendererPackageName = t27.rendererPackageName,
		rendererConfig = t27.rendererConfig,
		overrideHookState = u86,
		overrideHookStateDeletePath = u87,
		overrideHookStateRenamePath = u88,
		overrideProps = u89,
		overridePropsDeletePath = u90,
		overridePropsRenamePath = u91,
		setSuspenseHandler = u93,
		scheduleUpdate = u92,
		currentDispatcherRef = ReactCurrentDispatcher,
		findHostInstanceByFiber = findHostInstanceByFiber,
		findFiberByHostInstance = findFiberByHostInstance or emptyFindFiberByHostInstance,
		findHostInstancesForRefresh = if not __DEV__ then nil else findHostInstancesForRefresh,
		scheduleRefresh = if not __DEV__ then nil else scheduleRefresh,
		scheduleRoot = if not __DEV__ then nil else scheduleRoot,
		setRefreshHandler = if not __DEV__ then nil else setRefreshHandler,
		getCurrentFiber = _getCurrentFiberForDevTools
	})
end

t1.robloxReactProfiling = require(script.Parent.RobloxReactProfiling)
t1.schedulingProfiler = {
	profilerEventTypes = SchedulingProfiler.profilerEventTypes,
	registerProfilerEventCallback = SchedulingProfiler.registerProfilerEventCallback
}

return t1
