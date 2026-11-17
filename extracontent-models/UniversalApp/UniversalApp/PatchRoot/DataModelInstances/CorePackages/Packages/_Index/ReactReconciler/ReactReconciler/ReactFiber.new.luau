local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local inspect = LuauPolyfill.util.inspect

local __DEV__ = ReactGlobals.__DEV__

local Shared = require(parent.Shared)
local console = Shared.console

require(parent.Shared)

require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)

local ReactWorkTags = require(script.Parent.ReactWorkTags)

local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactFiberOffscreenComponent)

local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant
local Shared3 = require(parent.Shared)
local ReactFeatureFlags = Shared3.ReactFeatureFlags
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local NoFlags = ReactFiberFlags.NoFlags
local Placement = ReactFiberFlags.Placement
local StaticMask = ReactFiberFlags.StaticMask
local ConcurrentRoot = ReactRootTags.ConcurrentRoot
local BlockingRoot = ReactRootTags.BlockingRoot
local IndeterminateComponent = ReactWorkTags.IndeterminateComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local ForwardRef = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local Mode = ReactWorkTags.Mode
local ContextProvider = ReactWorkTags.ContextProvider
local ContextConsumer = ReactWorkTags.ContextConsumer
local Profiler = ReactWorkTags.Profiler
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local DehydratedFragment = ReactWorkTags.DehydratedFragment
local FunctionComponent = ReactWorkTags.FunctionComponent
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local LazyComponent = ReactWorkTags.LazyComponent
local FundamentalComponent = ReactWorkTags.FundamentalComponent
local ScopeComponent = ReactWorkTags.ScopeComponent
local OffscreenComponent = ReactWorkTags.OffscreenComponent
local LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent
local Shared4 = require(parent.Shared)
local getComponentName = Shared4.getComponentName

local ReactFiberDevToolsHooknew = require(script.Parent["ReactFiberDevToolsHook.new"])
local isDevToolsPresent = ReactFiberDevToolsHooknew.isDevToolsPresent
local ReactFiberHotReloadingnew = require(script.Parent["ReactFiberHotReloading.new"])
local resolveClassForHotReloading = ReactFiberHotReloadingnew.resolveClassForHotReloading

local resolveFunctionForHotReloading = ReactFiberHotReloadingnew.resolveFunctionForHotReloading

local resolveForwardRefForHotReloading = ReactFiberHotReloadingnew.resolveForwardRefForHotReloading
local NoLanes = ReactFiberLane.NoLanes
local NoMode = ReactTypeOfMode.NoMode
local ConcurrentMode = ReactTypeOfMode.ConcurrentMode
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local ProfileMode = ReactTypeOfMode.ProfileMode
local StrictMode = ReactTypeOfMode.StrictMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local Shared5 = require(parent.Shared)
local ReactSymbols = Shared5.ReactSymbols
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE

local REACT_OFFSCREEN_TYPE = ReactSymbols.REACT_OFFSCREEN_TYPE
local REACT_LEGACY_HIDDEN_TYPE = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE

local createFiberFromProfiler
local createFiberFromFragment
local createFiberFromSuspense
local createFiberFromOffscreen
local createFiberFromLegacyHidden

local debugID = 1

local function createFiber(tag, pendingProps, p, mode, elementType, p2, stateNode, p3)
	local fiber = {
		tag = tag,
		key = p,
		elementType = elementType,
		type = p2,
		stateNode = stateNode,
		index = 1,
		pendingProps = pendingProps,
		mode = mode,
		flags = NoFlags,
		subtreeFlags = NoFlags,
		lanes = p3 or NoLanes,
		childLanes = NoLanes
	}

	if enableProfilerTimer then
		fiber.actualDuration = 0
		fiber.actualStartTime = -1
		fiber.selfBaseDuration = 0
		fiber.treeBaseDuration = 0
	end

	if not __DEV__ then
		return fiber
	end

	fiber._debugID = debugID
	debugID += 1
	fiber._debugSource = nil
	fiber._debugOwner = nil
	fiber._debugNeedsRemount = false
	fiber._debugHookTypes = nil

	return fiber
end

function _shouldConstruct(callback)
	return type(callback) ~= "function" and (callback.isReactComponent and true or false)
end

local function createFiberFromTypeAndProps(kind, key: string?, props, owner, p, p2)
	local v = IndeterminateComponent

	local v2 = type(kind)
	local v3

	if v2 == "function" then
		if __DEV__ then
			v3 = resolveFunctionForHotReloading(kind)
		else
			v3 = kind
		end
	elseif v2 == "table" and kind.isReactComponent then
		v = ClassComponent

		if __DEV__ then
			v3 = resolveClassForHotReloading(kind)
		else
			v3 = kind
		end
	elseif v2 == "string" then
		v = HostComponent
		v3 = kind
	else
		if kind == REACT_FRAGMENT_TYPE then
			return createFiberFromFragment(props.children, p, p2, key)
		end

		if kind == REACT_DEBUG_TRACING_MODE_TYPE then
			v = Mode
			p = bit32.bor(p, DebugTracingMode)
			v3 = kind
		elseif kind == REACT_STRICT_MODE_TYPE then
			v = Mode
			p = bit32.bor(p, StrictMode)
			v3 = kind
		else
			if kind == REACT_PROFILER_TYPE then
				return createFiberFromProfiler(props, p, p2, key)
			end

			if kind == REACT_SUSPENSE_TYPE then
				return createFiberFromSuspense(props, p, p2, key)
			end

			if kind == REACT_OFFSCREEN_TYPE then
				return createFiberFromOffscreen(props, p, p2, key)
			end

			if kind == REACT_LEGACY_HIDDEN_TYPE then
				return createFiberFromLegacyHidden(props, p, p2, key)
			end

			local v4 = false
			local Typeof

			if v2 == "table" then
				Typeof = kind["$$typeof"]

				if Typeof == REACT_PROVIDER_TYPE then
					v = ContextProvider
					v3 = kind
					v4 = true
				elseif Typeof == REACT_CONTEXT_TYPE then
					v = ContextConsumer
					v3 = kind
					v4 = true
				elseif Typeof == REACT_FORWARD_REF_TYPE then
					v = ForwardRef

					if __DEV__ then
						v3 = resolveForwardRefForHotReloading(kind)
					else
						v3 = kind
					end

					v4 = true
				elseif Typeof == REACT_MEMO_TYPE then
					v = MemoComponent
					v3 = kind
					v4 = true
				elseif Typeof == REACT_LAZY_TYPE then
					v = LazyComponent
					v4 = true
				else
					v3 = kind
				end
			else
				v3 = kind
			end

			if not v4 then
				local v5 = ""

				if __DEV__ then
					if kind == nil or v2 == "table" and #Object.keys(kind) == 0 then
						v5 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
					elseif kind ~= nil and v2 == "table" then
						v5 ..= "\n" .. inspect(kind)
					end

					local v6

					if owner then
						v6 = getComponentName(owner.type)
					end

					if v6 == nil or v6 == "" then
						if owner then
							v5 ..= "\n" .. inspect(owner)
						end
					else
						v5 ..= "\n\nCheck the render method of `" .. v6 .. "`."
					end
				end

				if kind == nil then
					v2 = "nil"
				elseif Array.isArray(kind) then
					v2 = "array"
				elseif v2 == "table" and Typeof == REACT_ELEMENT_TYPE then
					v2 = string.format("<%s />", getComponentName(kind.type) or "Unknown")
					v5 = " Did you accidentally export a JSX literal or Element instead of a component?"
				end

				invariant(
					false,
					"Element type is invalid: expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s",
					v2,
					v5
				)
			end
		end
	end

	local fiber = createFiber(v, props, key, p, kind, v3, nil, p2)

	if __DEV__ then
		fiber._debugOwner = owner
	end

	return fiber
end

createFiberFromFragment = function(children, mode, p, p2: string?)
	return createFiber(Fragment, children, p2, mode, nil, nil, nil, p)
end

local function createFiberFromScope(elementType, pendingProps, mode, p, p2: string?)
	return createFiber(ScopeComponent, pendingProps, p2, mode, elementType, elementType, nil, p)
end

createFiberFromProfiler = function(pendingProps, p, p2, p3: string?)
	if __DEV__ and typeof(pendingProps.id) ~= "string" then
		console.error("Profiler must specify an \"id\" as a prop")
	end

	return createFiber(
		Profiler,
		pendingProps,
		p3,
		bit32.bor(p, ProfileMode),
		REACT_PROFILER_TYPE,
		REACT_PROFILER_TYPE,
		enableProfilerTimer and { effectDuration = 0, passiveEffectDuration = 0 } or nil,
		p2
	)
end

createFiberFromSuspense = function(pendingProps, mode, p, p2: string?)
	return createFiber(SuspenseComponent, pendingProps, p2, mode, REACT_SUSPENSE_TYPE, REACT_SUSPENSE_TYPE, nil, p)
end

createFiberFromOffscreen = function(pendingProps, mode, p, p2: string?)
	local v

	if __DEV__ then
		v = REACT_OFFSCREEN_TYPE
	end

	return createFiber(OffscreenComponent, pendingProps, p2, mode, REACT_OFFSCREEN_TYPE, v, nil, p)
end

createFiberFromLegacyHidden = function(pendingProps, mode, p, p2: string?)
	local v

	if __DEV__ then
		v = REACT_LEGACY_HIDDEN_TYPE
	end

	return createFiber(LegacyHiddenComponent, pendingProps, p2, mode, REACT_LEGACY_HIDDEN_TYPE, v, nil, p)
end

local New = {}

function New.isSimpleFunctionComponent(callback): boolean
	return type(callback) == "function"
end

function New.resolveLazyComponentTag(p)
	local typeName = typeof(p)

	if typeName == "function" then
		return FunctionComponent
	end

	if typeName ~= "table" then
		return IndeterminateComponent
	end

	if p.isReactComponent then
		return ClassComponent
	end

	local Typeof = p["$$typeof"]

	if Typeof == REACT_FORWARD_REF_TYPE then
		return ForwardRef
	end

	if Typeof == REACT_MEMO_TYPE then
		return MemoComponent
	end

	return IndeterminateComponent
end

function New.createWorkInProgress(alternate, pendingProps)
	local workInProgress = alternate.alternate

	if workInProgress == nil then
		workInProgress = createFiber(
			alternate.tag,
			pendingProps,
			alternate.key,
			alternate.mode,
			alternate.elementType,
			alternate.type,
			alternate.stateNode
		)

		if __DEV__ then
			workInProgress._debugID = alternate._debugID
			workInProgress._debugSource = alternate._debugSource
			workInProgress._debugOwner = alternate._debugOwner
			workInProgress._debugHookTypes = alternate._debugHookTypes
		end

		workInProgress.alternate = alternate
		alternate.alternate = workInProgress
	else
		workInProgress.pendingProps = pendingProps

		workInProgress.type = alternate.type

		if ReactFeatureFlags.enableWorkLoopTrims then
			workInProgress.subtreeFlags = NoFlags

			if workInProgress.deletions ~= nil then
				workInProgress.deletions = nil
			end
		else
			workInProgress.flags = NoFlags

			workInProgress.subtreeFlags = NoFlags
			workInProgress.deletions = nil
		end

		if enableProfilerTimer then
			workInProgress.actualDuration = 0
			workInProgress.actualStartTime = -1
		end
	end

	workInProgress.flags = bit32.band(alternate.flags, StaticMask)
	workInProgress.childLanes = alternate.childLanes
	workInProgress.lanes = alternate.lanes

	if ReactFeatureFlags.enableWorkLoopTrims then
		if alternate.child ~= nil or workInProgress.child ~= nil then
			workInProgress.child = alternate.child
		end

		workInProgress.memoizedProps = alternate.memoizedProps

		if alternate.memoizedState ~= nil or workInProgress.memoizedState ~= nil then
			workInProgress.memoizedState = alternate.memoizedState
		end

		if alternate.updateQueue ~= nil or workInProgress.updateQueue ~= nil then
			workInProgress.updateQueue = alternate.updateQueue
		end

		local dependencies = alternate.dependencies

		if dependencies == nil then
			if workInProgress.dependencies ~= nil then
				workInProgress.dependencies = nil
			end
		else
			workInProgress.dependencies = {
				lanes = dependencies.lanes,
				firstContext = dependencies.firstContext
			}
		end

		if alternate.sibling ~= nil or workInProgress.sibling ~= nil then
			workInProgress.sibling = alternate.sibling
		end

		workInProgress.index = alternate.index

		if alternate.ref ~= nil or workInProgress.ref ~= nil then
			workInProgress.ref = alternate.ref
		end
	else
		workInProgress.child = alternate.child
		workInProgress.memoizedProps = alternate.memoizedProps
		workInProgress.memoizedState = alternate.memoizedState
		workInProgress.updateQueue = alternate.updateQueue

		local dependencies = alternate.dependencies

		if dependencies == nil then
			workInProgress.dependencies = nil
		else
			workInProgress.dependencies = {
				lanes = dependencies.lanes,
				firstContext = dependencies.firstContext
			}
		end

		workInProgress.sibling = alternate.sibling
		workInProgress.index = alternate.index
		workInProgress.ref = alternate.ref
	end

	if enableProfilerTimer then
		workInProgress.selfBaseDuration = alternate.selfBaseDuration
		workInProgress.treeBaseDuration = alternate.treeBaseDuration
	end

	if not __DEV__ then
		return workInProgress
	end

	workInProgress._debugNeedsRemount = alternate._debugNeedsRemount

	if
		workInProgress.tag == IndeterminateComponent
		or workInProgress.tag == FunctionComponent
		or workInProgress.tag == SimpleMemoComponent
	then
		workInProgress.type = resolveFunctionForHotReloading(alternate.type)
		return workInProgress
	end

	if workInProgress.tag == ClassComponent then
		workInProgress.type = resolveClassForHotReloading(alternate.type)
		return workInProgress
	elseif workInProgress.tag == ForwardRef then
		workInProgress.type = resolveForwardRefForHotReloading(alternate.type)
	end

	return workInProgress
end

function New.resetWorkInProgress(state, lanes)
	state.flags = bit32.band(state.flags, (bit32.bor(StaticMask, Placement)))

	local alternate = state.alternate

	if alternate == nil then
		state.childLanes = NoLanes
		state.lanes = lanes

		state.child = nil
		state.subtreeFlags = NoFlags
		state.memoizedProps = nil
		state.memoizedState = nil
		state.updateQueue = nil

		state.dependencies = nil

		state.stateNode = nil

		if enableProfilerTimer then
			state.selfBaseDuration = 0
			state.treeBaseDuration = 0
			return state
		end
	else
		state.childLanes = alternate.childLanes
		state.lanes = alternate.lanes

		state.child = alternate.child
		state.subtreeFlags = alternate.subtreeFlags
		state.deletions = nil
		state.memoizedProps = alternate.memoizedProps
		state.memoizedState = alternate.memoizedState
		state.updateQueue = alternate.updateQueue

		state.type = alternate.type

		local dependencies = alternate.dependencies

		if dependencies == nil then
			state.dependencies = nil
		else
			state.dependencies = {
				lanes = dependencies.lanes,
				firstContext = dependencies.firstContext
			}
		end

		if enableProfilerTimer then
			state.selfBaseDuration = alternate.selfBaseDuration
			state.treeBaseDuration = alternate.treeBaseDuration
		end
	end

	return state
end

function New.createHostRootFiber(p)
	local v

	if p == ConcurrentRoot then
		v = bit32.bor(ConcurrentMode, BlockingMode, StrictMode)
	elseif p == BlockingRoot then
		v = bit32.bor(BlockingMode, StrictMode)
	else
		v = NoMode
	end

	if enableProfilerTimer and isDevToolsPresent() then
		v = bit32.bor(v, ProfileMode)
	end

	return createFiber(HostRoot, nil, nil, v)
end

New.createFiberFromTypeAndProps = createFiberFromTypeAndProps

function New.createFiberFromElement(data, p, p2)
	local owner

	if __DEV__ then
		owner = data._owner
	end

	local fiberFromTypeAndProps = createFiberFromTypeAndProps(data.type, data.key, data.props, owner, p, p2)

	if __DEV__ then
		fiberFromTypeAndProps._debugSource = data._source
		fiberFromTypeAndProps._debugOwner = data._owner
	end

	return fiberFromTypeAndProps
end

New.createFiberFromFragment = createFiberFromFragment

function New.createFiberFromFundamental(elementType, pendingProps, mode, p, p2: string?)
	return createFiber(FundamentalComponent, pendingProps, p2, mode, elementType, elementType, nil, p)
end

New.createFiberFromSuspense = createFiberFromSuspense

function New.createFiberFromSuspenseList(pendingProps, mode, p, p2: string?)
	local v

	if __DEV__ then
		v = REACT_SUSPENSE_LIST_TYPE
	end

	return createFiber(SuspenseListComponent, pendingProps, p2, mode, REACT_SUSPENSE_LIST_TYPE, v, nil, p)
end

New.createFiberFromOffscreen = createFiberFromOffscreen
New.createFiberFromLegacyHidden = createFiberFromLegacyHidden

function New.createFiberFromText(pendingProps: string, mode, p)
	return createFiber(HostText, pendingProps, nil, mode, nil, nil, nil, p)
end

function New.createFiberFromHostInstanceForDeletion()
	return createFiber(HostComponent, nil, nil, NoMode, "DELETED", "DELETED")
end

function New.createFiberFromDehydratedFragment(p)
	return createFiber(DehydratedFragment, nil, nil, NoMode, nil, nil, p)
end

function New.createFiberFromPortal(data, mode, p)
	return createFiber(
		HostPortal,
		data.children == nil and {} or data.children,
		data.key,
		mode,
		nil,
		nil,
		{
			containerInfo = data.containerInfo,
			pendingChildren = nil,
			implementation = data.implementation
		},
		p
	)
end

function New.assignFiberPropertiesInDEV(p, data)
	if p == nil then
		p = createFiber(IndeterminateComponent, nil, nil, NoMode)
	end

	p.tag = data.tag
	p.key = data.key
	p.elementType = data.elementType
	p.type = data.type
	p.stateNode = data.stateNode
	p.return_ = data.return_
	p.child = data.child
	p.sibling = data.sibling
	p.index = data.index
	p.ref = data.ref
	p.pendingProps = data.pendingProps
	p.memoizedProps = data.memoizedProps
	p.updateQueue = data.updateQueue
	p.memoizedState = data.memoizedState
	p.dependencies = data.dependencies
	p.mode = data.mode
	p.flags = data.flags
	p.subtreeFlags = data.subtreeFlags
	p.deletions = data.deletions
	p.lanes = data.lanes
	p.childLanes = data.childLanes
	p.alternate = data.alternate

	if enableProfilerTimer then
		p.actualDuration = data.actualDuration
		p.actualStartTime = data.actualStartTime
		p.selfBaseDuration = data.selfBaseDuration
		p.treeBaseDuration = data.treeBaseDuration
	end

	p._debugID = data._debugID
	p._debugSource = data._debugSource
	p._debugOwner = data._debugOwner
	p._debugNeedsRemount = data._debugNeedsRemount
	p._debugHookTypes = data._debugHookTypes
	return p
end

return New
