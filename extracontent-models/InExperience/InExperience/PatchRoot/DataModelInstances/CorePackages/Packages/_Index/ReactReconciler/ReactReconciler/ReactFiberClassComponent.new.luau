local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Object = require(ParentParent.LuauPolyfill).Object
local __DEV__ = ReactGlobals.__DEV__
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local lib = require(script.Parent["ReactUpdateQueue.new"])

require(ParentParent.Shared)

local React = require(ParentParent.React)
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Update = ReactFiberFlags.Update
local Snapshot = ReactFiberFlags.Snapshot
local MountLayoutDev = ReactFiberFlags.MountLayoutDev
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local debugRenderPhaseSideEffectsForStrictMode = ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
local disableLegacyContext = ReactFeatureFlags.disableLegacyContext
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local warnAboutDeprecatedLifecycles = ReactFeatureFlags.warnAboutDeprecatedLifecycles
local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local lib2 = require(script.Parent["ReactStrictModeWarnings.new"])
local isMounted = require(script.Parent.ReactFiberTreeReflection).isMounted
local ReactInstanceMap = require(ParentParent.Shared).ReactInstanceMap
local get = ReactInstanceMap.get
local set = ReactInstanceMap.set
local shallowEqual = require(ParentParent.Shared).shallowEqual
local getComponentName = require(ParentParent.Shared).getComponentName
local UninitializedState = require(ParentParent.Shared).UninitializedState
local describeError = require(ParentParent.Shared).describeError
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local resolveDefaultProps = require(script.Parent["ReactFiberLazyComponent.new"]).resolveDefaultProps
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local StrictMode = ReactTypeOfMode.StrictMode
local enqueueUpdate = lib.enqueueUpdate
local processUpdateQueue = lib.processUpdateQueue
local checkHasForceUpdateAfterProcessing = lib.checkHasForceUpdateAfterProcessing
local resetHasForceUpdateBeforeProcessing = lib.resetHasForceUpdateBeforeProcessing
local createUpdate = lib.createUpdate
local ReplaceState = lib.ReplaceState
local ForceUpdate = lib.ForceUpdate
local initializeUpdateQueue = lib.initializeUpdateQueue
local cloneUpdateQueue = lib.cloneUpdateQueue
local NoLanes = ReactFiberLane.NoLanes
local lib3 = require(script.Parent["ReactFiberContext.new"])
local cacheContext = lib3.cacheContext
local getMaskedContext = lib3.getMaskedContext
local getUnmaskedContext = lib3.getUnmaskedContext
local hasContextChanged = lib3.hasContextChanged
local emptyContextObject = lib3.emptyContextObject
local readContext = require(script.Parent["ReactFiberNewContext.new"]).readContext
local DebugTracing = require(script.Parent.DebugTracing)
local logForceUpdateScheduled = DebugTracing.logForceUpdateScheduled
local logStateUpdateScheduled = DebugTracing.logStateUpdateScheduled
local ConsolePatchingDev = require(ParentParent.Shared).ConsolePatchingDev
local disableLogs = ConsolePatchingDev.disableLogs
local reenableLogs = ConsolePatchingDev.reenableLogs
local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markForceUpdateScheduled = SchedulingProfiler.markForceUpdateScheduled
local markStateUpdateScheduled = SchedulingProfiler.markStateUpdateScheduled
local t1 = {}
local __refs = React.Component:extend("").__refs
local t2 = nil
local t3 = nil
local t4 = nil
local t5 = nil
local warnOnUndefinedDerivedState = nil
local warnOnInvalidCallback = nil
local t6 = nil
local t7 = nil
local t8 = nil

if __DEV__ then
	t2 = {}
	t3 = {}
	t4 = {}
	t5 = {}
	t6 = {}
	t7 = {}
	t8 = {}

	local t9 = {}

	function warnOnInvalidCallback(p1, s1: string) -- line: 140
		-- upvalues: t9 (copy), console (copy)
		if p1 == nil or type(p1) == "function" then
			return
		end

		local v82 = s1 .. "_" .. tostring(p1)

		if not t9[v82] then
			t9[v82] = true
			console.error("%s(...): Expected the last optional `callback` argument to be a function. Instead received: %s.", s1, (tostring(p1)))
		end
	end
	function warnOnUndefinedDerivedState(_, _) -- line: 156
	end
end

local function applyDerivedStateFromProps(p4, p5, p6: ((...any) -> ...any), p7) -- line: 199
	-- upvalues: __DEV__ (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), warnOnUndefinedDerivedState (ref), Object (copy), NoLanes (copy)
	local memoizedState = p4.memoizedState

	if __DEV__ and (debugRenderPhaseSideEffectsForStrictMode and bit32.band(p4.mode, StrictMode) ~= 0) then
		disableLogs()

		local ok, result = xpcall(p6, describeError, p7, memoizedState)

		reenableLogs()

		if not ok then
			error(result)
		end
	end

	local v92 = p6(p7, memoizedState)

	if __DEV__ then
		warnOnUndefinedDerivedState(p5, v92)
	end

	local v93 = if v92 ~= nil then Object.assign({}, memoizedState, v92) else memoizedState

	p4.memoizedState = v93

	if p4.lanes == NoLanes then
		p4.updateQueue.baseState = v93
	end
end

local t10 = nil

local function initializeClassComponentUpdater() -- line: 247
	-- upvalues: t10 (ref), isMounted (copy), get (copy), createUpdate (copy), __DEV__ (copy), warnOnInvalidCallback (ref), enqueueUpdate (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logStateUpdateScheduled (copy), enableSchedulingProfiler (copy), markStateUpdateScheduled (copy), ReplaceState (copy), ForceUpdate (copy), logForceUpdateScheduled (copy), markForceUpdateScheduled (copy)
	local lib4 = require(script.Parent["ReactFiberWorkLoop.new"])
	local requestEventTime = lib4.requestEventTime
	local requestUpdateLane = lib4.requestUpdateLane
	local scheduleUpdateOnFiber = lib4.scheduleUpdateOnFiber

	t10 = {
		isMounted = isMounted,
		enqueueSetState = function(p8, p9, p10: ((...any) -> ...any)?) -- line: 255
			-- upvalues: get (copy), requestEventTime (copy), requestUpdateLane (copy), createUpdate (copy), __DEV__ (copy), warnOnInvalidCallback (ref), enqueueUpdate (copy), scheduleUpdateOnFiber (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logStateUpdateScheduled (copy), enableSchedulingProfiler (copy), markStateUpdateScheduled (copy)
			local v198 = get(p8)
			local v199 = requestEventTime()
			local v200 = requestUpdateLane(v198)
			local v201 = createUpdate(v199, v200, p9, p10)

			if p10 ~= nil and __DEV__ then
				warnOnInvalidCallback(p10, "setState")
			end

			enqueueUpdate(v198, v201)
			scheduleUpdateOnFiber(v198, v200, v199)

			if __DEV__ and enableDebugTracing and bit32.band(v198.mode, DebugTracingMode) ~= 0 then
				local v202 = getComponentName(v198.type) or "Unknown"

				logStateUpdateScheduled(v202, v200, p9)
			end

			if enableSchedulingProfiler then
				markStateUpdateScheduled(v198, v200)
			end
		end,
		enqueueReplaceState = function(p11, p12, p13) -- line: 285
			-- upvalues: get (copy), requestEventTime (copy), requestUpdateLane (copy), createUpdate (copy), ReplaceState (copy), __DEV__ (copy), warnOnInvalidCallback (ref), enqueueUpdate (copy), scheduleUpdateOnFiber (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logStateUpdateScheduled (copy), enableSchedulingProfiler (copy), markStateUpdateScheduled (copy)
			local v206 = get(p11)
			local v207 = requestEventTime()
			local v208 = requestUpdateLane(v206)
			local v209 = createUpdate(v207, v208, p12, p13)

			v209.tag = ReplaceState

			if p13 ~= nil and __DEV__ then
				warnOnInvalidCallback(p13, "replaceState")
			end

			enqueueUpdate(v206, v209)
			scheduleUpdateOnFiber(v206, v208, v207)

			if __DEV__ and enableDebugTracing and bit32.band(v206.mode, DebugTracingMode) ~= 0 then
				local v210 = getComponentName(v206.type) or "Unknown"

				logStateUpdateScheduled(v210, v208, p12)
			end

			if enableSchedulingProfiler then
				markStateUpdateScheduled(v206, v208)
			end
		end,
		enqueueForceUpdate = function(p14, p15) -- line: 317
			-- upvalues: get (copy), requestEventTime (copy), requestUpdateLane (copy), createUpdate (copy), ForceUpdate (copy), __DEV__ (copy), warnOnInvalidCallback (ref), enqueueUpdate (copy), scheduleUpdateOnFiber (copy), enableDebugTracing (copy), DebugTracingMode (copy), getComponentName (copy), logForceUpdateScheduled (copy), enableSchedulingProfiler (copy), markForceUpdateScheduled (copy)
			local v213 = get(p14)
			local v214 = requestEventTime()
			local v215 = requestUpdateLane(v213)
			local v216 = createUpdate(v214, v215, nil, p15)

			v216.tag = ForceUpdate

			if p15 ~= nil and __DEV__ then
				warnOnInvalidCallback(p15, "forceUpdate")
			end

			enqueueUpdate(v213, v216)
			scheduleUpdateOnFiber(v213, v215, v214)

			if __DEV__ and enableDebugTracing and bit32.band(v213.mode, DebugTracingMode) ~= 0 then
				local v217 = getComponentName(v213.type) or "Unknown"

				logForceUpdateScheduled(v217, v215)
			end

			if enableSchedulingProfiler then
				markForceUpdateScheduled(v213, v215)
			end
		end
	}
end
local function getClassComponentUpdater() -- line: 351
	-- upvalues: t10 (ref), initializeClassComponentUpdater (copy)
	if t10 == nil then
		initializeClassComponentUpdater()
	end

	return t10
end

function checkShouldComponentUpdate(p16, p17, p18, p19, p20, p21, p22) -- line: 358
	-- upvalues: __DEV__ (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), console (copy), getComponentName (copy), shallowEqual (copy)
	local stateNode = p16.stateNode

	if stateNode.shouldComponentUpdate ~= nil and type(stateNode.shouldComponentUpdate) == "function" then
		if __DEV__ and debugRenderPhaseSideEffectsForStrictMode and bit32.band(p16.mode, StrictMode) ~= 0 then
			disableLogs()

			local ok, result = xpcall(stateNode.shouldComponentUpdate, describeError, stateNode, p19, p21, p22)

			reenableLogs()

			if not ok then
				error(result)
			end
		end

		local v108 = stateNode:shouldComponentUpdate(p19, p21, p22)

		if __DEV__ and v108 == nil then
			console.error("%s.shouldComponentUpdate(): Returned nil instead of a boolean value. Make sure to return true or false.", getComponentName(p17) or "Component")
		end

		return v108
	end

	if type(p17) == "table" and p17.isPureReactComponent then
		return not shallowEqual(p18, p19) or not shallowEqual(p20, p21)
	end

	return true
end

local function checkClassInstance(p23, p24, p25) -- line: 423
	-- upvalues: __DEV__ (copy), getComponentName (copy), console (copy), disableLegacyContext (copy), t7 (ref), t4 (ref)
	local stateNode = p23.stateNode

	if __DEV__ then
		local v113 = getComponentName(p24) or "Component"

		if not stateNode.render then
			if type(p24.render) == "function" then
				console.error("%s(...): No `render` method found on the returned component instance: did you accidentally return an object from the constructor?", v113)
			else
				console.error("%s(...): No `render` method found on the returned component instance: you may have forgotten to define `render`.", v113)
			end
		end

		if stateNode.getInitialState and not stateNode.getInitialState.isReactClassApproved and not stateNode.state then
			console.error("getInitialState was defined on %s, a plain JavaScript class. This is only supported for classes created using React.createClass. Did you mean to define a state property instead?", v113)
		end

		if stateNode.getDefaultProps and not stateNode.getDefaultProps.isReactClassApproved then
			console.error("getDefaultProps was defined on %s, a plain JavaScript class. This is only supported for classes created using React.createClass. Use a static property to define defaultProps instead.", v113)
		end

		if stateNode.propTypes and not p24.propTypes then
			console.error("propTypes was defined as an instance property on %s. Use a static property to define propTypes instead.", v113)
		end

		if stateNode.contextType and not p24.contextType then
			console.error("contextType was defined as an instance property on %s. Use a static property to define contextType instead.", v113)
		end

		if disableLegacyContext then
			if p24.childContextTypes then
				console.error("%s uses the legacy childContextTypes API which is no longer supported. Use React.createContext() instead.", v113)
			end

			if p24.contextTypes then
				console.error("%s uses the legacy contextTypes API which is no longer supported. Use React.createContext() with static contextType instead.", v113)
			end
		else
			if stateNode.contextTypes and not p24.contextTypes then
				console.error("contextTypes was defined as an instance property on %s. Use a static property to define contextTypes instead.", v113)
			end

			if type(p24) == "table" and p24.contextType and p24.contextTypes and not t7[p24] then
				t7[p24] = true
				console.error("%s declares both contextTypes and contextType static properties. The legacy contextTypes property will be ignored.", v113)
			end
		end

		if type(stateNode.componentShouldUpdate) == "function" then
			console.error("%s has a method called componentShouldUpdate(). Did you mean shouldComponentUpdate()? The name is phrased as a question because the function is expected to return a value.", v113)
		end

		if type(p24) == "table" and p24.isPureReactComponent and stateNode.shouldComponentUpdate ~= nil then
			console.error("%s has a method called shouldComponentUpdate(). shouldComponentUpdate should not be used when extending React.PureComponent. Please extend React.Component if shouldComponentUpdate is used.", getComponentName(p24) or "A pure component")
		end

		if type(stateNode.componentDidUnmount) == "function" then
			console.error("%s has a method called componentDidUnmount(). But there is no such lifecycle method. Did you mean componentWillUnmount()?", v113)
		end

		if type(stateNode.componentDidReceiveProps) == "function" then
			console.error("%s has a method called componentDidReceiveProps(). But there is no such lifecycle method. If you meant to update the state in response to changing props, use componentWillReceiveProps(). If you meant to fetch data or run side-effects or mutations after React has updated the UI, use componentDidUpdate().", v113)
		end

		if type(stateNode.componentWillRecieveProps) == "function" then
			console.error("%s has a method called componentWillRecieveProps(). Did you mean componentWillReceiveProps()?", v113)
		end

		if type(stateNode.UNSAFE_componentWillRecieveProps) == "function" then
			console.error("%s has a method called UNSAFE_componentWillRecieveProps(). Did you mean UNSAFE_componentWillReceiveProps()?", v113)
		end

		local v114 = p25 ~= stateNode.props

		if stateNode.props ~= nil and v114 then
			console.error("%s(...): When calling super() in `%s`, make sure to pass up the same props that your component's constructor was passed.", v113, v113)
		end

		if rawget(stateNode, "defaultProps") then
			console.error("Setting defaultProps as an instance property on %s is not supported and will be ignored. Instead, define defaultProps as a static property on %s.", v113, v113)
		end

		if type(stateNode.getSnapshotBeforeUpdate) == "function" and type(stateNode.componentDidUpdate) ~= "function" and not t4[p24] then
			t4[p24] = true
			console.error("%s: getSnapshotBeforeUpdate() should be used with componentDidUpdate(). This component defines getSnapshotBeforeUpdate() only.", getComponentName(p24))
		end

		local state = stateNode.state

		if state ~= nil and type(state) ~= "table" then
			console.error("%s.state: must be set to an object or nil", v113)
		end

		if type(p24) == "table" and type(stateNode.getChildContext) == "function" and type(p24.childContextTypes) ~= "table" then
			console.error("%s.getChildContext(): childContextTypes must be defined in order to use getChildContext().", v113)
		end
	end
end
local function callComponentWillMount(p26, p27) -- line: 881
	-- upvalues: __DEV__ (copy), console (copy), getComponentName (copy), t10 (ref), initializeClassComponentUpdater (copy)
	local state = p27.state

	if p27.componentWillMount ~= nil and type(p27.componentWillMount) == "function" then
		p27:componentWillMount()
	end

	if p27.UNSAFE_componentWillMount ~= nil and type(p27.UNSAFE_componentWillMount) == "function" then
		p27:UNSAFE_componentWillMount()
	end

	if state ~= p27.state then
		if __DEV__ then
			console.error("%s.componentWillMount(): Assigning directly to this.state is deprecated (except inside a component's constructor). Use setState instead.", getComponentName(p26.type) or "Component")
		end

		if t10 == nil then
			initializeClassComponentUpdater()
		end

		t10.enqueueReplaceState(p27, p27.state)
	end
end

function callComponentWillReceiveProps(p28, p29, p30, p31) -- line: 913
	-- upvalues: __DEV__ (copy), getComponentName (copy), t2 (ref), console (copy), t10 (ref), initializeClassComponentUpdater (copy)
	local state = p29.state

	if p29.componentWillReceiveProps ~= nil and type(p29.componentWillReceiveProps) == "function" then
		p29:componentWillReceiveProps(p30, p31)
	end

	if p29.UNSAFE_componentWillReceiveProps ~= nil and type(p29.UNSAFE_componentWillReceiveProps) == "function" then
		p29:UNSAFE_componentWillReceiveProps(p30, p31)
	end

	if state ~= p29.state then
		if __DEV__ then
			local v150 = getComponentName(p28.type) or "Component"

			if not t2[v150] then
				t2[v150] = true
				console.error("%s.componentWillReceiveProps(): Assigning directly to this.state is deprecated (except inside a component's constructor). Use setState instead.", v150)
			end
		end

		if t10 == nil then
			initializeClassComponentUpdater()
		end

		t10.enqueueReplaceState(p29, p29.state)
	end
end
function resumeMountClassInstance(p32, p33, p34, p35) -- line: 1059
	-- upvalues: emptyContextObject (copy), readContext (copy), disableLegacyContext (copy), getUnmaskedContext (copy), getMaskedContext (copy), resetHasForceUpdateBeforeProcessing (copy), processUpdateQueue (copy), hasContextChanged (copy), checkHasForceUpdateAfterProcessing (copy), __DEV__ (copy), enableDoubleInvokingEffects (copy), MountLayoutDev (copy), Update (copy), applyDerivedStateFromProps (copy)
	local stateNode = p32.stateNode
	local memoizedProps = p32.memoizedProps

	stateNode.props = memoizedProps

	local context = stateNode.context
	local contextType = p33.contextType
	local v169 = emptyContextObject

	if contextType ~= nil and type(contextType) == "table" then
		v169 = readContext(contextType)
	elseif not disableLegacyContext then
		local v170 = getUnmaskedContext(p32, p33, true)

		v169 = getMaskedContext(p32, v170)
	end

	local getDerivedStateFromProps = p33.getDerivedStateFromProps
	local v172 = type(getDerivedStateFromProps) == "function" or type(stateNode.getSnapshotBeforeUpdate) == "function"

	if not v172 and (type(stateNode.UNSAFE_componentWillReceiveProps) == "function" or type(stateNode.componentWillReceiveProps) == "function") and (memoizedProps ~= p34 or context ~= v169) then
		callComponentWillReceiveProps(p32, stateNode, p34, v169)
	end

	resetHasForceUpdateBeforeProcessing()

	local memoizedState = p32.memoizedState

	stateNode.state = memoizedState
	processUpdateQueue(p32, p34, stateNode, p35)

	local memoizedState2 = p32.memoizedState

	if memoizedProps == p34 and memoizedState == memoizedState2 and not hasContextChanged() and not checkHasForceUpdateAfterProcessing() then
		if type(stateNode.componentDidMount) == "function" then
			if __DEV__ and enableDoubleInvokingEffects then
				p32.flags = bit32.bor(p32.flags, MountLayoutDev, Update)
			else
				p32.flags = bit32.bor(p32.flags, Update)
			end
		end

		return false
	end

	if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
		applyDerivedStateFromProps(p32, p33, getDerivedStateFromProps, p34)
		memoizedState2 = p32.memoizedState
	end

	local v175 = checkHasForceUpdateAfterProcessing() or checkShouldComponentUpdate(p32, p33, memoizedProps, p34, memoizedState, memoizedState2, v169)

	if v175 then
		if not v172 and (type(stateNode.UNSAFE_componentWillMount) == "function" or type(stateNode.componentWillMount) == "function") then
			if type(stateNode.componentWillMount) == "function" then
				stateNode:componentWillMount()
			end

			if type(stateNode.UNSAFE_componentWillMount) == "function" then
				stateNode:UNSAFE_componentWillMount()
			end
		end

		if type(stateNode.componentDidMount) == "function" then
			if __DEV__ and enableDoubleInvokingEffects then
				p32.flags = bit32.bor(p32.flags, MountLayoutDev, Update)
			else
				p32.flags = bit32.bor(p32.flags, Update)
			end
		end
	else
		if type(stateNode.componentDidMount) == "function" then
			if __DEV__ and enableDoubleInvokingEffects then
				p32.flags = bit32.bor(p32.flags, MountLayoutDev, Update)
			else
				p32.flags = bit32.bor(p32.flags, Update)
			end
		end

		p32.memoizedProps = p34
		p32.memoizedState = memoizedState2
	end

	stateNode.props = p34
	stateNode.state = memoizedState2
	stateNode.context = v169

	return v175
end

return {
	adoptClassInstance = function(p36, p37) -- line: 657
		-- upvalues: t10 (ref), initializeClassComponentUpdater (copy), set (copy), __DEV__ (copy), t1 (copy)
		if t10 == nil then
			initializeClassComponentUpdater()
		end

		p37.__updater = t10
		p36.stateNode = p37
		set(p37, p36)

		if __DEV__ then
			p37._reactInternalInstance = t1
		end
	end,
	constructClassInstance = function(p38, p39, p40) -- line: 668
		-- upvalues: emptyContextObject (copy), __DEV__ (copy), REACT_CONTEXT_TYPE (copy), t8 (ref), REACT_PROVIDER_TYPE (copy), console (copy), getComponentName (copy), readContext (copy), disableLegacyContext (copy), getUnmaskedContext (copy), getMaskedContext (copy), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), describeError (copy), reenableLogs (copy), t10 (ref), initializeClassComponentUpdater (copy), set (copy), t1 (copy), UninitializedState (copy), t3 (ref), t5 (ref), cacheContext (copy)
		local v121 = false
		local v122 = emptyContextObject
		local v123 = emptyContextObject
		local contextType = p39.contextType

		if __DEV__ and (p39.contextType ~= nil and (contextType ~= nil and (contextType["$$typeof"] ~= REACT_CONTEXT_TYPE or contextType._context ~= nil)) and not t8[p39]) then
			t8[p39] = true

			local s2

			if contextType == nil then
				s2 = " However, it is set to nil. This can be caused by a typo or by mixing up named and default imports. This can also happen due to a circular dependency, so try moving the createContext() call to a separate file."
			elseif type(contextType) ~= "table" then
				s2 = " However, it is set to a " .. type(contextType) .. "."
			elseif contextType["$$typeof"] == REACT_PROVIDER_TYPE then
				s2 = " Did you accidentally pass the Context.Provider instead?"
			elseif contextType._context ~= nil then
				s2 = " Did you accidentally pass the Context.Consumer instead?"
			else
				local v126 = "" .. " However, it is set to an object with keys {"

				for v127, _ in contextType do
					v126 ..= v127 .. ", "
				end

				s2 = v126 .. "}."
			end

			console.error("%s defines an invalid contextType. contextType should point to the Context object returned by React.createContext().%s", getComponentName(p39) or "Component", s2)
		end

		if contextType ~= nil and type(contextType) == "table" then
			v123 = readContext(contextType)
		elseif not disableLegacyContext then
			v122 = getUnmaskedContext(p38, p39, true)
			v121 = p39.contextTypes ~= nil
			v123 = v121 and getMaskedContext(p38, v122) or emptyContextObject
		end

		if __DEV__ and debugRenderPhaseSideEffectsForStrictMode and bit32.band(p38.mode, StrictMode) ~= 0 then
			disableLogs()

			local ok, result = xpcall(p39.__ctor, describeError, p40, v123)

			reenableLogs()

			if not ok then
				error(result)
			end
		end

		local v131 = p39.__ctor(p40, v123)

		p38.memoizedState = v131.state

		local memoizedState = p38.memoizedState

		if t10 == nil then
			initializeClassComponentUpdater()
		end

		v131.__updater = t10
		p38.stateNode = v131
		set(v131, p38)

		if __DEV__ then
			v131._reactInternalInstance = t1
		end

		if __DEV__ then
			if type(p39.getDerivedStateFromProps) == "function" and memoizedState == UninitializedState then
				local v133 = getComponentName(p39) or "Component"

				if not t3[v133] then
					t3[v133] = true
					console.error("`%s` uses `getDerivedStateFromProps` but its initial state has not been initialized. This is not recommended. Instead, define the initial state by passing an object to `self:setState` in the `init` method of `%s`. This ensures that `getDerivedStateFromProps` arguments have a consistent shape.", v133, v133)
				end
			end

			if type(p39.getDerivedStateFromProps) == "function" or type(v131.getSnapshotBeforeUpdate) == "function" then
				local s3 = nil
				local s4 = nil
				local s5 = nil

				if type(v131.componentWillMount) == "function" then
					s3 = "componentWillMount"
				elseif type(v131.UNSAFE_componentWillMount) == "function" then
					s3 = "UNSAFE_componentWillMount"
				end

				if type(v131.componentWillReceiveProps) == "function" then
					s4 = "componentWillReceiveProps"
				elseif type(v131.UNSAFE_componentWillReceiveProps) == "function" then
					s4 = "UNSAFE_componentWillReceiveProps"
				end

				if type(v131.componentWillUpdate) == "function" then
					s5 = "componentWillUpdate"
				elseif type(v131.UNSAFE_componentWillUpdate) == "function" then
					s5 = "UNSAFE_componentWillUpdate"
				end

				if s3 ~= nil or s4 ~= nil or s5 ~= nil then
					local v137 = getComponentName(p39) or "Component"
					local v138 = type(p39.getDerivedStateFromProps) ~= "function" and "getSnapshotBeforeUpdate()" or "getDerivedStateFromProps()"
					local v139 = s3 == nil and "" or "\n  " .. tostring(s3)
					local v140 = s4 == nil and "" or "\n  " .. tostring(s4)
					local v141 = s5 == nil and "" or "\n  " .. tostring(s5)

					if not t5[v137] then
						t5[v137] = true
						console.error("Unsafe legacy lifecycles will not be called for components using new component APIs.\n\n%s uses %s but also contains the following legacy lifecycles:%s%s%s\n\nThe above lifecycles should be removed. Learn more about this warning here:\nhttps://reactjs.org/link/unsafe-component-lifecycles", v137, v138, v139, v140, v141)
					end
				end
			end
		end

		if v121 then
			cacheContext(p38, v122, v123)
		end

		return v131
	end,
	mountClassInstance = function(p41, p42, p43, p44) -- line: 948
		-- upvalues: __DEV__ (copy), checkClassInstance (copy), __refs (copy), initializeUpdateQueue (copy), readContext (copy), disableLegacyContext (copy), emptyContextObject (copy), getUnmaskedContext (copy), getMaskedContext (copy), getComponentName (copy), t6 (ref), console (copy), StrictMode (copy), lib2 (copy), warnAboutDeprecatedLifecycles (copy), processUpdateQueue (copy), applyDerivedStateFromProps (copy), callComponentWillMount (copy), enableDoubleInvokingEffects (copy), MountLayoutDev (copy), Update (copy)
		if __DEV__ then
			checkClassInstance(p41, p42, p43)
		end

		local stateNode = p41.stateNode

		stateNode.props = p43
		stateNode.state = p41.memoizedState
		stateNode.__refs = __refs
		initializeUpdateQueue(p41)

		local contextType = nil

		if type(p42) == "table" then
			contextType = p42.contextType
		end

		if contextType ~= nil and type(contextType) == "table" then
			stateNode.context = readContext(contextType)
		elseif disableLegacyContext then
			stateNode.context = emptyContextObject
		else
			local v157 = getUnmaskedContext(p41, p42, true)

			stateNode.context = getMaskedContext(p41, v157)
		end

		if __DEV__ then
			if p43 == stateNode.state then
				local v158 = getComponentName(p42) or "Component"

				if not t6[v158] then
					t6[v158] = true
					console.error("%s: It is not recommended to assign props directly to state because updates to props won't be reflected in state. In most cases, it is better to use props directly.", v158)
				end
			end

			if bit32.band(p41.mode, StrictMode) ~= 0 then
				lib2.recordLegacyContextWarning(p41, stateNode)
			end

			if warnAboutDeprecatedLifecycles then
				lib2.recordUnsafeLifecycleWarnings(p41, stateNode)
			end
		end

		processUpdateQueue(p41, p43, stateNode, p44)
		stateNode.state = p41.memoizedState

		local v159 = type(p42)
		local getDerivedStateFromProps = nil

		if type(p42) == "table" then
			getDerivedStateFromProps = p42.getDerivedStateFromProps
		end

		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(p41, p42, getDerivedStateFromProps, p43)
			stateNode.state = p41.memoizedState
		end

		if v159 == "table" and type(p42.getDerivedStateFromProps) ~= "function" and type(stateNode.getSnapshotBeforeUpdate) ~= "function" and (type(stateNode.UNSAFE_componentWillMount) == "function" or type(stateNode.componentWillMount) == "function") then
			callComponentWillMount(p41, stateNode)
			processUpdateQueue(p41, p43, stateNode, p44)
			stateNode.state = p41.memoizedState
		end

		if type(stateNode.componentDidMount) == "function" then
			if __DEV__ and enableDoubleInvokingEffects then
				p41.flags = bit32.bor(p41.flags, (bit32.bor(MountLayoutDev, Update)))

				return
			end

			p41.flags = bit32.bor(p41.flags, Update)
		end
	end,
	resumeMountClassInstance = resumeMountClassInstance,
	updateClassInstance = function(p45, p46, p47, p48, p49) -- line: 1207
		-- upvalues: cloneUpdateQueue (copy), resolveDefaultProps (copy), emptyContextObject (copy), readContext (copy), disableLegacyContext (copy), getUnmaskedContext (copy), getMaskedContext (copy), resetHasForceUpdateBeforeProcessing (copy), processUpdateQueue (copy), hasContextChanged (copy), checkHasForceUpdateAfterProcessing (copy), Update (copy), Snapshot (copy), applyDerivedStateFromProps (copy)
		local stateNode = p46.stateNode

		cloneUpdateQueue(p45, p46)

		local memoizedProps = p46.memoizedProps
		local v183 = if p46.type ~= p46.elementType then resolveDefaultProps(p46.type, memoizedProps) else memoizedProps

		stateNode.props = v183

		local pendingProps = p46.pendingProps
		local context = stateNode.context
		local contextType = nil
		local getDerivedStateFromProps = nil

		if type(p47) == "table" then
			contextType = p47.contextType
			getDerivedStateFromProps = p47.getDerivedStateFromProps
		end

		local v188 = emptyContextObject

		if type(contextType) == "table" then
			v188 = readContext(contextType)
		elseif not disableLegacyContext then
			local v189 = getUnmaskedContext(p46, p47, true)

			v188 = getMaskedContext(p46, v189)
		end

		local v190 = getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" or stateNode.getSnapshotBeforeUpdate ~= nil and type(stateNode.getSnapshotBeforeUpdate) == "function"

		if not v190 and ((stateNode.UNSAFE_componentWillReceiveProps ~= nil and type(stateNode.UNSAFE_componentWillReceiveProps) == "function" or stateNode.componentWillReceiveProps ~= nil and type(stateNode.componentWillReceiveProps) == "function") and (memoizedProps ~= pendingProps or context ~= v188)) then
			callComponentWillReceiveProps(p46, stateNode, p48, v188)
		end

		resetHasForceUpdateBeforeProcessing()

		local memoizedState = p46.memoizedState

		stateNode.state = memoizedState

		local _ = stateNode.state

		processUpdateQueue(p46, p48, stateNode, p49)

		local memoizedState3 = p46.memoizedState

		if memoizedProps == pendingProps and memoizedState == memoizedState3 and not hasContextChanged() and not checkHasForceUpdateAfterProcessing() then
			if stateNode.componentDidUpdate ~= nil and type(stateNode.componentDidUpdate) == "function" and (memoizedProps ~= p45.memoizedProps or memoizedState ~= p45.memoizedState) then
				p46.flags = bit32.bor(p46.flags, Update)
			end

			if stateNode.getSnapshotBeforeUpdate ~= nil and type(stateNode.getSnapshotBeforeUpdate) == "function" and (memoizedProps ~= p45.memoizedProps or memoizedState ~= p45.memoizedState) then
				p46.flags = bit32.bor(p46.flags, Snapshot)
			end

			return false
		end

		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(p46, p47, getDerivedStateFromProps, p48)
			memoizedState3 = p46.memoizedState
		end

		local v194 = checkHasForceUpdateAfterProcessing() or checkShouldComponentUpdate(p46, p47, v183, p48, memoizedState, memoizedState3, v188)

		if v194 then
			if not v190 and (stateNode.UNSAFE_componentWillUpdate ~= nil and type(stateNode.UNSAFE_componentWillUpdate) == "function" or stateNode.componentWillUpdate ~= nil and type(stateNode.componentWillUpdate) == "function") then
				if stateNode.componentWillUpdate ~= nil and type(stateNode.componentWillUpdate) == "function" then
					stateNode:componentWillUpdate(p48, memoizedState3, v188)
				end

				if stateNode.UNSAFE_componentWillUpdate ~= nil and type(stateNode.UNSAFE_componentWillUpdate) == "function" then
					stateNode:UNSAFE_componentWillUpdate(p48, memoizedState3, v188)
				end
			end

			if stateNode.componentDidUpdate ~= nil and type(stateNode.componentDidUpdate) == "function" then
				p46.flags = bit32.bor(p46.flags, Update)
			end

			if stateNode.getSnapshotBeforeUpdate ~= nil and type(stateNode.getSnapshotBeforeUpdate) == "function" then
				p46.flags = bit32.bor(p46.flags, Snapshot)
			end
		else
			if stateNode.componentDidUpdate ~= nil and type(stateNode.componentDidUpdate) == "function" and (memoizedProps ~= p45.memoizedProps or memoizedState ~= p45.memoizedState) then
				p46.flags = bit32.bor(p46.flags, Update)
			end

			if stateNode.getSnapshotBeforeUpdate ~= nil and type(stateNode.getSnapshotBeforeUpdate) == "function" and (memoizedProps ~= p45.memoizedProps or memoizedState ~= p45.memoizedState) then
				p46.flags = bit32.bor(p46.flags, Snapshot)
			end

			p46.memoizedProps = p48
			p46.memoizedState = memoizedState3
		end

		stateNode.props = p48
		stateNode.state = memoizedState3
		stateNode.context = v188

		return v194
	end,
	applyDerivedStateFromProps = applyDerivedStateFromProps,
	emptyRefsObject = __refs
}
