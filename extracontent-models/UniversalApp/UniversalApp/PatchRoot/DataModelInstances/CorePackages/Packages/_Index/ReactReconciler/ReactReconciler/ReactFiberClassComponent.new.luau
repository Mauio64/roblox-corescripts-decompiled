local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local __DEV__ = ReactGlobals.__DEV__

local Shared = require(parent.Shared)
local console = Shared.console
require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])

require(parent.Shared)

local React = require(parent.React)

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Update = ReactFiberFlags.Update
local Snapshot = ReactFiberFlags.Snapshot
local MountLayoutDev = ReactFiberFlags.MountLayoutDev

local Shared2 = require(parent.Shared)
local ReactFeatureFlags = Shared2.ReactFeatureFlags

local debugRenderPhaseSideEffectsForStrictMode = ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
local disableLegacyContext = ReactFeatureFlags.disableLegacyContext
local enableDebugTracing = ReactFeatureFlags.enableDebugTracing
local enableSchedulingProfiler = ReactFeatureFlags.enableSchedulingProfiler
local warnAboutDeprecatedLifecycles = ReactFeatureFlags.warnAboutDeprecatedLifecycles
local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local enableAllocationTrims = ReactFeatureFlags.enableAllocationTrims

local ReactStrictModeWarningsnew = require(script.Parent["ReactStrictModeWarnings.new"])
local ReactFiberTreeReflection = require(script.Parent.ReactFiberTreeReflection)
local isMounted = ReactFiberTreeReflection.isMounted
local Shared3 = require(parent.Shared)
local ReactInstanceMap = Shared3.ReactInstanceMap
local get = ReactInstanceMap.get
local set = ReactInstanceMap.set
local Shared4 = require(parent.Shared)
local shallowEqual = Shared4.shallowEqual
local Shared5 = require(parent.Shared)
local getComponentName = Shared5.getComponentName
local Shared6 = require(parent.Shared)
local UninitializedState = Shared6.UninitializedState
local Shared7 = require(parent.Shared)
local describeError = Shared7.describeError

local Shared8 = require(parent.Shared)
local ReactSymbols = Shared8.ReactSymbols
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE

local ReactFiberLazyComponentnew = require(script.Parent["ReactFiberLazyComponent.new"])
local resolveDefaultProps = ReactFiberLazyComponentnew.resolveDefaultProps
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local StrictMode = ReactTypeOfMode.StrictMode

local enqueueUpdate = ReactUpdateQueuenew.enqueueUpdate
local processUpdateQueue = ReactUpdateQueuenew.processUpdateQueue

local checkHasForceUpdateAfterProcessing = ReactUpdateQueuenew.checkHasForceUpdateAfterProcessing

local resetHasForceUpdateBeforeProcessing = ReactUpdateQueuenew.resetHasForceUpdateBeforeProcessing
local createUpdate = ReactUpdateQueuenew.createUpdate
local ReplaceState = ReactUpdateQueuenew.ReplaceState
local ForceUpdate = ReactUpdateQueuenew.ForceUpdate
local initializeUpdateQueue = ReactUpdateQueuenew.initializeUpdateQueue
local cloneUpdateQueue = ReactUpdateQueuenew.cloneUpdateQueue
local NoLanes = ReactFiberLane.NoLanes

local ReactFiberContextnew = require(script.Parent["ReactFiberContext.new"])
local cacheContext = ReactFiberContextnew.cacheContext
local getMaskedContext = ReactFiberContextnew.getMaskedContext
local getUnmaskedContext = ReactFiberContextnew.getUnmaskedContext
local hasContextChanged = ReactFiberContextnew.hasContextChanged
local emptyContextObject = ReactFiberContextnew.emptyContextObject

local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
local readContext = ReactFiberNewContextnew.readContext

local DebugTracing = require(script.Parent.DebugTracing)
local logForceUpdateScheduled = DebugTracing.logForceUpdateScheduled
local logStateUpdateScheduled = DebugTracing.logStateUpdateScheduled

local Shared9 = require(parent.Shared)
local ConsolePatchingDev = Shared9.ConsolePatchingDev
local disableLogs = ConsolePatchingDev.disableLogs
local reenableLogs = ConsolePatchingDev.reenableLogs

local SchedulingProfiler = require(script.Parent.SchedulingProfiler)
local markForceUpdateScheduled = SchedulingProfiler.markForceUpdateScheduled
local markStateUpdateScheduled = SchedulingProfiler.markStateUpdateScheduled

local reactInternalInstance = {}

local __refs = React.Component:extend("").__refs
local warnOnInvalidCallback, warnOnUndefinedDerivedState, dataSet, dataSet2, dataSet3, set2, set3, set4, set5

if __DEV__ then
	local set6 = {}

	warnOnInvalidCallback = function(callback, p: string)
		if callback == nil or type(callback) == "function" then
			return
		end

		local v = p .. "_" .. tostring(callback)

		if not set6[v] then
			set6[v] = true
			console.error(
				"%s(...): Expected the last optional `callback` argument to be a function. Instead received: %s.",
				p,
				(tostring(callback))
			)
		end
	end

	warnOnUndefinedDerivedState = function(_, _) end

	dataSet = {}
	dataSet2 = {}

	dataSet3 = {}
	set2 = {}

	set3 = {}
	set4 = {}

	set5 = {}
else
	warnOnUndefinedDerivedState = nil
	warnOnInvalidCallback = nil
	dataSet = nil
	dataSet2 = nil
	dataSet3 = nil
	set2 = nil
	set3 = nil
	set4 = nil
	set5 = nil
end

local function applyDerivedStateFromProps(state, p, getDerivedStateFromProps, p2)
	local v = state.memoizedState

	if __DEV__ and debugRenderPhaseSideEffectsForStrictMode and bit32.band(state.mode, StrictMode) ~= 0 then
		disableLogs()

		local success, result = xpcall(getDerivedStateFromProps, describeError, p2, v)

		reenableLogs()

		if not success then
			error(result)
		end
	end

	local v2 = getDerivedStateFromProps(p2, v)

	if __DEV__ then
		warnOnUndefinedDerivedState(p, v2)
	end

	if enableAllocationTrims then
		if v2 ~= nil then
			if type(v) == "table" and getmetatable(v) == nil then
				v = Object.assign(table.clone(v), v2)
			else
				v = Object.assign({}, v, v2)
			end
		end
	elseif v2 ~= nil then
		v = Object.assign({}, v, v2)
	end

	state.memoizedState = v

	if state.lanes == NoLanes then
		state.updateQueue.baseState = v
	end
end

local classComponentUpdater = nil
local function initializeClassComponentUpdater()
	local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
	local requestEventTime = ReactFiberWorkLoopnew.requestEventTime
	local requestUpdateLane = ReactFiberWorkLoopnew.requestUpdateLane
	local scheduleUpdateOnFiber = ReactFiberWorkLoopnew.scheduleUpdateOnFiber

	classComponentUpdater = {
		isMounted = isMounted,
		enqueueSetState = function(p, p2, callback)
			local v = get(p)
			local v2 = requestEventTime()
			local v3 = requestUpdateLane(v)

			local update = createUpdate(v2, v3, p2, callback)

			if callback ~= nil and __DEV__ then
				warnOnInvalidCallback(callback, "setState")
			end

			enqueueUpdate(v, update)
			scheduleUpdateOnFiber(v, v3, v2)

			if __DEV__ and enableDebugTracing and bit32.band(v.mode, DebugTracingMode) ~= 0 then
				logStateUpdateScheduled(getComponentName(v.type) or "Unknown", v3, p2)
			end

			if enableSchedulingProfiler then
				markStateUpdateScheduled(v, v3)
			end
		end,
		enqueueReplaceState = function(p, p2, p3)
			local v = get(p)
			local v2 = requestEventTime()
			local v3 = requestUpdateLane(v)

			local update = createUpdate(v2, v3, p2, p3)
			update.tag = ReplaceState

			if p3 ~= nil and __DEV__ then
				warnOnInvalidCallback(p3, "replaceState")
			end

			enqueueUpdate(v, update)
			scheduleUpdateOnFiber(v, v3, v2)

			if __DEV__ and enableDebugTracing and bit32.band(v.mode, DebugTracingMode) ~= 0 then
				logStateUpdateScheduled(getComponentName(v.type) or "Unknown", v3, p2)
			end

			if enableSchedulingProfiler then
				markStateUpdateScheduled(v, v3)
			end
		end,
		enqueueForceUpdate = function(p, p2)
			local v = get(p)
			local v2 = requestEventTime()
			local v3 = requestUpdateLane(v)

			local update = createUpdate(v2, v3, nil, p2)
			update.tag = ForceUpdate

			if p2 ~= nil and __DEV__ then
				warnOnInvalidCallback(p2, "forceUpdate")
			end

			enqueueUpdate(v, update)
			scheduleUpdateOnFiber(v, v3, v2)

			if __DEV__ and enableDebugTracing and bit32.band(v.mode, DebugTracingMode) ~= 0 then
				logForceUpdateScheduled(getComponentName(v.type) or "Unknown", v3)
			end

			if enableSchedulingProfiler then
				markForceUpdateScheduled(v, v3)
			end
		end
	}
end

local function getClassComponentUpdater() -- 3 equivalent calls inferred from this helper
	if classComponentUpdater == nil then
		initializeClassComponentUpdater()
	end

	return classComponentUpdater
end

function checkShouldComponentUpdate(p, p2, p3, p4, p5, p6, p7)
	local stateNode = p.stateNode

	if stateNode.shouldComponentUpdate == nil or type(stateNode.shouldComponentUpdate) ~= "function" then
		if type(p2) == "table" and p2.isPureReactComponent then
			return not (shallowEqual(p3, p4) and shallowEqual(p5, p6))
		end

		return true
	else
		if __DEV__ and debugRenderPhaseSideEffectsForStrictMode and bit32.band(p.mode, StrictMode) ~= 0 then
			disableLogs()

			local success, result = xpcall(stateNode.shouldComponentUpdate, describeError, stateNode, p4, p6, p7)

			reenableLogs()

			if not success then
				error(result)
			end
		end

		local shouldComponentUpdate = stateNode:shouldComponentUpdate(p4, p6, p7)

		if __DEV__ and shouldComponentUpdate == nil then
			console.error(
				"%s.shouldComponentUpdate(): Returned nil instead of a boolean value. Make sure to return true or false.",
				getComponentName(p2) or "Component"
			)
		end

		return shouldComponentUpdate
	end
end

local function checkClassInstance(state, data, props)
	local stateNode = state.stateNode

	if __DEV__ then
		local v = getComponentName(data) or "Component"

		if not stateNode.render then
			if type(data.render) == "function" then
				console.error(
					"%s(...): No `render` method found on the returned component instance: did you accidentally return an object from the constructor?",
					v
				)
			else
				console.error(
					"%s(...): No `render` method found on the returned component instance: you may have forgotten to define `render`.",
					v
				)
			end
		end

		if stateNode.getInitialState and not (stateNode.getInitialState.isReactClassApproved or stateNode.state) then
			console.error(
				"getInitialState was defined on %s, a plain JavaScript class. This is only supported for classes created using React.createClass. Did you mean to define a state property instead?",
				v
			)
		end

		if stateNode.getDefaultProps and not stateNode.getDefaultProps.isReactClassApproved then
			console.error(
				"getDefaultProps was defined on %s, a plain JavaScript class. This is only supported for classes created using React.createClass. Use a static property to define defaultProps instead.",
				v
			)
		end

		if stateNode.propTypes and not data.propTypes then
			console.error(
				"propTypes was defined as an instance property on %s. Use a static property to define propTypes instead.",
				v
			)
		end

		if stateNode.contextType and not data.contextType then
			console.error(
				"contextType was defined as an instance property on %s. Use a static property to define contextType instead.",
				v
			)
		end

		if disableLegacyContext then
			if data.childContextTypes then
				console.error(
					"%s uses the legacy childContextTypes API which is no longer supported. Use React.createContext() instead.",
					v
				)
			end

			if data.contextTypes then
				console.error(
					"%s uses the legacy contextTypes API which is no longer supported. Use React.createContext() with static contextType instead.",
					v
				)
			end
		else
			if stateNode.contextTypes and not data.contextTypes then
				console.error(
					"contextTypes was defined as an instance property on %s. Use a static property to define contextTypes instead.",
					v
				)
			end

			if type(data) == "table" and data.contextType and data.contextTypes and not dataSet[data] then
				dataSet[data] = true
				console.error(
					"%s declares both contextTypes and contextType static properties. The legacy contextTypes property will be ignored.",
					v
				)
			end
		end

		if type(stateNode.componentShouldUpdate) == "function" then
			console.error(
				"%s has a method called componentShouldUpdate(). Did you mean shouldComponentUpdate()? The name is phrased as a question because the function is expected to return a value.",
				v
			)
		end

		if type(data) == "table" and data.isPureReactComponent and stateNode.shouldComponentUpdate ~= nil then
			console.error(
				"%s has a method called shouldComponentUpdate(). shouldComponentUpdate should not be used when extending React.PureComponent. Please extend React.Component if shouldComponentUpdate is used.",
				getComponentName(data) or "A pure component"
			)
		end

		if type(stateNode.componentDidUnmount) == "function" then
			console.error(
				"%s has a method called componentDidUnmount(). But there is no such lifecycle method. Did you mean componentWillUnmount()?",
				v
			)
		end

		if type(stateNode.componentDidReceiveProps) == "function" then
			console.error(
				"%s has a method called componentDidReceiveProps(). But there is no such lifecycle method. If you meant to update the state in response to changing props, use componentWillReceiveProps(). If you meant to fetch data or run side-effects or mutations after React has updated the UI, use componentDidUpdate().",
				v
			)
		end

		if type(stateNode.componentWillRecieveProps) == "function" then
			console.error(
				"%s has a method called componentWillRecieveProps(). Did you mean componentWillReceiveProps()?",
				v
			)
		end

		if type(stateNode.UNSAFE_componentWillRecieveProps) == "function" then
			console.error(
				"%s has a method called UNSAFE_componentWillRecieveProps(). Did you mean UNSAFE_componentWillReceiveProps()?",
				v
			)
		end

		local v2 = stateNode.props ~= props

		if stateNode.props ~= nil and v2 then
			console.error(
				"%s(...): When calling super() in `%s`, make sure to pass up the same props that your component's constructor was passed.",
				v,
				v
			)
		end

		if rawget(stateNode, "defaultProps") then
			console.error(
				"Setting defaultProps as an instance property on %s is not supported and will be ignored. Instead, define defaultProps as a static property on %s.",
				v,
				v
			)
		end

		if
			type(stateNode.getSnapshotBeforeUpdate) == "function"
			and type(stateNode.componentDidUpdate) ~= "function"
			and not dataSet2[data]
		then
			dataSet2[data] = true
			console.error(
				"%s: getSnapshotBeforeUpdate() should be used with componentDidUpdate(). This component defines getSnapshotBeforeUpdate() only.",
				getComponentName(data)
			)
		end

		local state2 = stateNode.state

		if state2 ~= nil and type(state2) ~= "table" then
			console.error("%s.state: must be set to an object or nil", v)
		end

		if
			type(data) == "table"
			and type(stateNode.getChildContext) == "function"
			and type(data.childContextTypes) ~= "table"
		then
			console.error(
				"%s.getChildContext(): childContextTypes must be defined in order to use getChildContext().",
				v
			)
		end
	end
end

local function adoptClassInstance(state, stateNode) -- 1 equivalent call inferred from this helper
	stateNode.__updater = getClassComponentUpdater() -- inferred equivalent call
	state.stateNode = stateNode

	set(stateNode, state)

	if __DEV__ then
		stateNode._reactInternalInstance = reactInternalInstance
	end
end

local function constructClassInstance(state, data, p)
	local v = false
	local v2 = emptyContextObject
	local v3 = emptyContextObject
	local contextType = data.contextType

	if __DEV__ and data.contextType ~= nil then
		local v4

		if contextType == nil then
			v4 = true
		elseif contextType["$$typeof"] == REACT_CONTEXT_TYPE then
			v4 = contextType._context == nil
		else
			v4 = false
		end

		if not (v4 or dataSet3[data]) then
			dataSet3[data] = true

			local v5 = ""
			local v6

			if contextType == nil then
				v6 = " However, it is set to nil. This can be caused by a typo or by mixing up named and default imports. This can also happen due to a circular dependency, so try moving the createContext() call to a separate file."
			elseif type(contextType) == "table" then
				if contextType["$$typeof"] == REACT_PROVIDER_TYPE then
					v6 = " Did you accidentally pass the Context.Provider instead?"
				elseif contextType._context == nil then
					local v7 = v5 .. " However, it is set to an object with keys {"

					for k, _ in contextType do
						v7 ..= k .. ", "
					end

					v6 = v7 .. "}."
				else
					v6 = " Did you accidentally pass the Context.Consumer instead?"
				end
			else
				v6 = " However, it is set to a " .. type(contextType) .. "."
			end

			console.error(
				"%s defines an invalid contextType. contextType should point to the Context object returned by React.createContext().%s",
				getComponentName(data) or "Component",
				v6
			)
		end
	end

	if contextType == nil or type(contextType) ~= "table" then
		if not disableLegacyContext then
			v2 = getUnmaskedContext(state, data, true)
			v = data.contextTypes ~= nil

			v3 = v and getMaskedContext(state, v2) or emptyContextObject
		end
	else
		v3 = readContext(contextType)
	end

	if __DEV__ and debugRenderPhaseSideEffectsForStrictMode and bit32.band(state.mode, StrictMode) ~= 0 then
		disableLogs()

		local success, result = xpcall(data.__ctor, describeError, p, v3)

		reenableLogs()

		if not success then
			error(result)
		end
	end

	local __ctor = data.__ctor(p, v3)

	state.memoizedState = __ctor.state
	local memoizedState = state.memoizedState
	adoptClassInstance(state, __ctor) -- inferred equivalent call

	if __DEV__ then
		if type(data.getDerivedStateFromProps) == "function" and memoizedState == UninitializedState then
			local v4 = getComponentName(data) or "Component"

			if not set2[v4] then
				set2[v4] = true

				console.error(
					"`%s` uses `getDerivedStateFromProps` but its initial state has not been initialized. This is not recommended. Instead, define the initial state by passing an object to `self:setState` in the `init` method of `%s`. This ensures that `getDerivedStateFromProps` arguments have a consistent shape.",
					v4,
					v4
				)
			end
		end

		if type(data.getDerivedStateFromProps) == "function" or type(__ctor.getSnapshotBeforeUpdate) == "function" then
			local v4 = type(__ctor.componentWillMount) == "function" and "componentWillMount"
				or type(__ctor.UNSAFE_componentWillMount) == "function" and "UNSAFE_componentWillMount"
				or nil

			local v5 = type(__ctor.componentWillReceiveProps) == "function" and "componentWillReceiveProps"
				or type(__ctor.UNSAFE_componentWillReceiveProps) == "function" and "UNSAFE_componentWillReceiveProps"
				or nil

			local v6 = type(__ctor.componentWillUpdate) == "function" and "componentWillUpdate"
				or type(__ctor.UNSAFE_componentWillUpdate) == "function" and "UNSAFE_componentWillUpdate"
				or nil

			if v4 ~= nil or v5 ~= nil or v6 ~= nil then
				local v7 = getComponentName(data) or "Component"

				local v8 = type(data.getDerivedStateFromProps) == "function" and "getDerivedStateFromProps()"
					or "getSnapshotBeforeUpdate()"

				local v9 = v4 == nil and "" or "\n  " .. tostring(v4)

				local v10 = v5 == nil and "" or "\n  " .. tostring(v5)

				local v11 = v6 == nil and "" or "\n  " .. tostring(v6)

				if not set3[v7] then
					set3[v7] = true
					console.error(
						"Unsafe legacy lifecycles will not be called for components using new component APIs.\n\n%s uses %s but also contains the following legacy lifecycles:%s%s%s\n\nThe above lifecycles should be removed. Learn more about this warning here:\nhttps://reactjs.org/link/unsafe-component-lifecycles",
						v7,
						v8,
						v9,
						v10,
						v11
					)
				end
			end
		end
	end

	if v then
		cacheContext(state, v2, v3)
	end

	return __ctor
end

local function callComponentWillMount(state, stateNode)
	local state2 = stateNode.state

	if stateNode.componentWillMount ~= nil and type(stateNode.componentWillMount) == "function" then
		stateNode:componentWillMount()
	end

	if stateNode.UNSAFE_componentWillMount ~= nil and type(stateNode.UNSAFE_componentWillMount) == "function" then
		stateNode:UNSAFE_componentWillMount()
	end

	if state2 ~= stateNode.state then
		if __DEV__ then
			console.error(
				"%s.componentWillMount(): Assigning directly to this.state is deprecated (except inside a component's constructor). Use setState instead.",
				getComponentName(state.type) or "Component"
			)
		end

		getClassComponentUpdater().enqueueReplaceState(stateNode, stateNode.state) -- inferred equivalent call
	end
end

function callComponentWillReceiveProps(p, object, p2, p3)
	local state = object.state

	if object.componentWillReceiveProps ~= nil and type(object.componentWillReceiveProps) == "function" then
		object:componentWillReceiveProps(p2, p3)
	end

	if
		object.UNSAFE_componentWillReceiveProps ~= nil
		and type(object.UNSAFE_componentWillReceiveProps) == "function"
	then
		object:UNSAFE_componentWillReceiveProps(p2, p3)
	end

	if object.state ~= state then
		if __DEV__ then
			local v = getComponentName(p.type) or "Component"

			if not set4[v] then
				set4[v] = true
				console.error(
					"%s.componentWillReceiveProps(): Assigning directly to this.state is deprecated (except inside a component's constructor). Use setState instead.",
					v
				)
			end
		end

		getClassComponentUpdater().enqueueReplaceState(object, object.state) -- inferred equivalent call
	end
end

function resumeMountClassInstance(state, p, p2, p3)
	local stateNode = state.stateNode

	local memoizedProps = state.memoizedProps
	stateNode.props = memoizedProps

	local context = stateNode.context
	local contextType = p.contextType
	local context2 = emptyContextObject

	if contextType == nil or type(contextType) ~= "table" then
		if not disableLegacyContext then
			context2 = getMaskedContext(state, (getUnmaskedContext(state, p, true)))
		end
	else
		context2 = readContext(contextType)
	end

	local getDerivedStateFromProps = p.getDerivedStateFromProps
	local v = type(getDerivedStateFromProps) == "function" or type(stateNode.getSnapshotBeforeUpdate) == "function"

	if
		not v
		and (type(stateNode.UNSAFE_componentWillReceiveProps) == "function" or type(stateNode.componentWillReceiveProps) == "function")
		and (memoizedProps ~= p2 or context ~= context2)
	then
		callComponentWillReceiveProps(state, stateNode, p2, context2)
	end

	resetHasForceUpdateBeforeProcessing()

	local memoizedState = state.memoizedState
	stateNode.state = memoizedState

	processUpdateQueue(state, p2, stateNode, p3)
	local memoizedState2 = state.memoizedState

	if
		memoizedProps == p2
		and memoizedState == memoizedState2
		and not (hasContextChanged() or checkHasForceUpdateAfterProcessing())
	then
		if type(stateNode.componentDidMount) == "function" then
			if __DEV__ and enableDoubleInvokingEffects then
				state.flags = bit32.bor(state.flags, MountLayoutDev, Update)
			else
				state.flags = bit32.bor(state.flags, Update)
			end
		end

		return false
	else
		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(state, p, getDerivedStateFromProps, p2)

			memoizedState2 = state.memoizedState
		end

		local v2 = checkHasForceUpdateAfterProcessing()
			or checkShouldComponentUpdate(state, p, memoizedProps, p2, memoizedState, memoizedState2, context2)

		if v2 then
			if
				not v
				and (type(stateNode.UNSAFE_componentWillMount) == "function" or type(stateNode.componentWillMount) == "function")
			then
				if type(stateNode.componentWillMount) == "function" then
					stateNode:componentWillMount()
				end

				if type(stateNode.UNSAFE_componentWillMount) == "function" then
					stateNode:UNSAFE_componentWillMount()
				end
			end

			if type(stateNode.componentDidMount) == "function" then
				if __DEV__ and enableDoubleInvokingEffects then
					state.flags = bit32.bor(state.flags, MountLayoutDev, Update)
				else
					state.flags = bit32.bor(state.flags, Update)
				end
			end
		else
			if type(stateNode.componentDidMount) == "function" then
				if __DEV__ and enableDoubleInvokingEffects then
					state.flags = bit32.bor(state.flags, MountLayoutDev, Update)
				else
					state.flags = bit32.bor(state.flags, Update)
				end
			end

			state.memoizedProps = p2
			state.memoizedState = memoizedState2
		end

		stateNode.props = p2
		stateNode.state = memoizedState2
		stateNode.context = context2

		return v2
	end
end

local New = {}
New.adoptClassInstance = adoptClassInstance
New.constructClassInstance = constructClassInstance

function New.mountClassInstance(state, p, props, p2)
	if __DEV__ then
		checkClassInstance(state, p, props)
	end

	local stateNode = state.stateNode
	stateNode.props = props
	stateNode.state = state.memoizedState

	stateNode.__refs = __refs

	initializeUpdateQueue(state)
	local contextType

	if type(p) == "table" then
		contextType = p.contextType
	end

	if contextType == nil or type(contextType) ~= "table" then
		if disableLegacyContext then
			stateNode.context = emptyContextObject
		else
			stateNode.context = getMaskedContext(state, (getUnmaskedContext(state, p, true)))
		end
	else
		stateNode.context = readContext(contextType)
	end

	if __DEV__ then
		if stateNode.state == props then
			local v = getComponentName(p) or "Component"

			if not set5[v] then
				set5[v] = true
				console.error(
					"%s: It is not recommended to assign props directly to state because updates to props won't be reflected in state. In most cases, it is better to use props directly.",
					v
				)
			end
		end

		if bit32.band(state.mode, StrictMode) ~= 0 then
			ReactStrictModeWarningsnew.recordLegacyContextWarning(state, stateNode)
		end

		if warnAboutDeprecatedLifecycles then
			ReactStrictModeWarningsnew.recordUnsafeLifecycleWarnings(state, stateNode)
		end
	end

	processUpdateQueue(state, props, stateNode, p2)
	stateNode.state = state.memoizedState

	local typeName = type(p)
	local getDerivedStateFromProps

	if type(p) == "table" then
		getDerivedStateFromProps = p.getDerivedStateFromProps
	end

	if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
		applyDerivedStateFromProps(state, p, getDerivedStateFromProps, props)

		stateNode.state = state.memoizedState
	end

	if
		typeName == "table"
		and type(p.getDerivedStateFromProps) ~= "function"
		and type(stateNode.getSnapshotBeforeUpdate) ~= "function"
		and (type(stateNode.UNSAFE_componentWillMount) == "function" or type(stateNode.componentWillMount) == "function")
	then
		callComponentWillMount(state, stateNode)

		processUpdateQueue(state, props, stateNode, p2)
		stateNode.state = state.memoizedState
	end

	if type(stateNode.componentDidMount) == "function" then
		if __DEV__ and enableDoubleInvokingEffects then
			state.flags = bit32.bor(state.flags, (bit32.bor(MountLayoutDev, Update)))
		else
			state.flags = bit32.bor(state.flags, Update)
		end
	end
end

New.resumeMountClassInstance = resumeMountClassInstance

function New.updateClassInstance(p, state, p2, p3, p4)
	local stateNode = state.stateNode

	cloneUpdateQueue(p, state)

	local memoizedProps = state.memoizedProps
	local props

	if state.type == state.elementType then
		props = memoizedProps
	else
		props = resolveDefaultProps(state.type, memoizedProps)
	end

	stateNode.props = props
	local pendingProps = state.pendingProps

	local context = stateNode.context
	local contextType, getDerivedStateFromProps

	if type(p2) == "table" then
		contextType = p2.contextType
		getDerivedStateFromProps = p2.getDerivedStateFromProps
	end

	local context2 = emptyContextObject

	if type(contextType) == "table" then
		context2 = readContext(contextType)
	elseif not disableLegacyContext then
		context2 = getMaskedContext(state, (getUnmaskedContext(state, p2, true)))
	end

	local v

	if getDerivedStateFromProps == nil or type(getDerivedStateFromProps) ~= "function" then
		if stateNode.getSnapshotBeforeUpdate == nil then
			v = false
		else
			v = type(stateNode.getSnapshotBeforeUpdate) == "function"
		end
	else
		v = true
	end

	if
		not v
		and (stateNode.UNSAFE_componentWillReceiveProps ~= nil and type(stateNode.UNSAFE_componentWillReceiveProps) == "function" or stateNode.componentWillReceiveProps ~= nil and type(stateNode.componentWillReceiveProps) == "function")
		and (memoizedProps ~= pendingProps or context ~= context2)
	then
		callComponentWillReceiveProps(state, stateNode, p3, context2)
	end

	resetHasForceUpdateBeforeProcessing()

	local memoizedState = state.memoizedState
	stateNode.state = memoizedState
	local _state = stateNode.state
	processUpdateQueue(state, p3, stateNode, p4)
	local memoizedState2 = state.memoizedState

	if
		memoizedProps == pendingProps
		and memoizedState == memoizedState2
		and not (hasContextChanged() or checkHasForceUpdateAfterProcessing())
	then
		if
			stateNode.componentDidUpdate ~= nil
			and type(stateNode.componentDidUpdate) == "function"
			and (memoizedProps ~= p.memoizedProps or memoizedState ~= p.memoizedState)
		then
			state.flags = bit32.bor(state.flags, Update)
		end

		if
			stateNode.getSnapshotBeforeUpdate ~= nil
			and type(stateNode.getSnapshotBeforeUpdate) == "function"
			and (memoizedProps ~= p.memoizedProps or memoizedState ~= p.memoizedState)
		then
			state.flags = bit32.bor(state.flags, Snapshot)
		end

		return false
	else
		if getDerivedStateFromProps ~= nil and type(getDerivedStateFromProps) == "function" then
			applyDerivedStateFromProps(state, p2, getDerivedStateFromProps, p3)

			memoizedState2 = state.memoizedState
		end

		local v2 = checkHasForceUpdateAfterProcessing()
			or checkShouldComponentUpdate(state, p2, props, p3, memoizedState, memoizedState2, context2)

		if v2 then
			if
				not v
				and (stateNode.UNSAFE_componentWillUpdate ~= nil and type(stateNode.UNSAFE_componentWillUpdate) == "function" or stateNode.componentWillUpdate ~= nil and type(stateNode.componentWillUpdate) == "function")
			then
				if stateNode.componentWillUpdate ~= nil and type(stateNode.componentWillUpdate) == "function" then
					stateNode:componentWillUpdate(p3, memoizedState2, context2)
				end

				if
					stateNode.UNSAFE_componentWillUpdate ~= nil
					and type(stateNode.UNSAFE_componentWillUpdate) == "function"
				then
					stateNode:UNSAFE_componentWillUpdate(p3, memoizedState2, context2)
				end
			end

			if stateNode.componentDidUpdate ~= nil and type(stateNode.componentDidUpdate) == "function" then
				state.flags = bit32.bor(state.flags, Update)
			end

			if stateNode.getSnapshotBeforeUpdate ~= nil and type(stateNode.getSnapshotBeforeUpdate) == "function" then
				state.flags = bit32.bor(state.flags, Snapshot)
			end
		else
			if
				stateNode.componentDidUpdate ~= nil
				and type(stateNode.componentDidUpdate) == "function"
				and (memoizedProps ~= p.memoizedProps or memoizedState ~= p.memoizedState)
			then
				state.flags = bit32.bor(state.flags, Update)
			end

			if
				stateNode.getSnapshotBeforeUpdate ~= nil
				and type(stateNode.getSnapshotBeforeUpdate) == "function"
				and (memoizedProps ~= p.memoizedProps or memoizedState ~= p.memoizedState)
			then
				state.flags = bit32.bor(state.flags, Snapshot)
			end

			state.memoizedProps = p3
			state.memoizedState = memoizedState2
		end

		stateNode.props = p3
		stateNode.state = memoizedState2
		stateNode.context = context2

		return v2
	end
end

New.applyDerivedStateFromProps = applyDerivedStateFromProps
New.emptyRefsObject = __refs
return New
