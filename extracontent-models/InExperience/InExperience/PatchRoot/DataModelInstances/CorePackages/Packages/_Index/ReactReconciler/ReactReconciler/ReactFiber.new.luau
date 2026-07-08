local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local inspect = LuauPolyfill.util.inspect
local __DEV__ = ReactGlobals.__DEV__
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)

local ReactRootTags = require(script.Parent.ReactRootTags)
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local ReactFiberLane = require(script.Parent.ReactFiberLane)

require(script.Parent.ReactFiberHostConfig)
require(script.Parent.ReactFiberOffscreenComponent)

local invariant = require(ParentParent.Shared).invariant
local enableProfilerTimer = require(ParentParent.Shared).ReactFeatureFlags.enableProfilerTimer
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
local ReactWorkTagsMode = ReactWorkTags.Mode
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
local getComponentName = require(ParentParent.Shared).getComponentName
local isDevToolsPresent = require(script.Parent["ReactFiberDevToolsHook.new"]).isDevToolsPresent
local lib = require(script.Parent["ReactFiberHotReloading.new"])
local resolveClassForHotReloading = lib.resolveClassForHotReloading
local resolveFunctionForHotReloading = lib.resolveFunctionForHotReloading
local resolveForwardRefForHotReloading = lib.resolveForwardRefForHotReloading
local NoLanes = ReactFiberLane.NoLanes
local NoMode = ReactTypeOfMode.NoMode
local ConcurrentMode = ReactTypeOfMode.ConcurrentMode
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local ProfileMode = ReactTypeOfMode.ProfileMode
local StrictMode = ReactTypeOfMode.StrictMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
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
local createFiberFromProfiler = nil
local createFiberFromFragment = nil
local createFiberFromSuspense = nil
local createFiberFromOffscreen = nil
local createFiberFromLegacyHidden = nil
local n1 = 1

local function createFiber(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 167
	-- upvalues: NoFlags (copy), NoLanes (copy), enableProfilerTimer (copy), __DEV__ (copy), n1 (ref)
	local t1 = {
		index = 1,
		tag = p1,
		key = p3,
		elementType = p5,
		type = p6,
		stateNode = p7,
		pendingProps = p2,
		mode = p4,
		flags = NoFlags,
		subtreeFlags = NoFlags,
		lanes = p8 or NoLanes,
		childLanes = NoLanes
	}

	if enableProfilerTimer then
		t1.actualDuration = 0
		t1.actualStartTime = -1
		t1.selfBaseDuration = 0
		t1.treeBaseDuration = 0
	end

	if __DEV__ then
		t1._debugID = n1
		n1 += 1
		t1._debugSource = nil
		t1._debugOwner = nil
		t1._debugNeedsRemount = false
		t1._debugHookTypes = nil
	end

	return t1
end

function _shouldConstruct(p9) -- line: 267
	return type(p9) ~= "function" and not not p9.isReactComponent
end

local function createFiberFromTypeAndProps(p10, s1: string?, p11, p12, p13, p14) -- line: 505
	-- upvalues: IndeterminateComponent (copy), __DEV__ (copy), resolveFunctionForHotReloading (copy), ClassComponent (copy), resolveClassForHotReloading (copy), HostComponent (copy), REACT_FRAGMENT_TYPE (copy), createFiberFromFragment (ref), REACT_DEBUG_TRACING_MODE_TYPE (copy), ReactWorkTagsMode (copy), DebugTracingMode (copy), REACT_STRICT_MODE_TYPE (copy), StrictMode (copy), REACT_PROFILER_TYPE (copy), createFiberFromProfiler (ref), REACT_SUSPENSE_TYPE (copy), createFiberFromSuspense (ref), REACT_OFFSCREEN_TYPE (copy), createFiberFromOffscreen (ref), REACT_LEGACY_HIDDEN_TYPE (copy), createFiberFromLegacyHidden (ref), REACT_PROVIDER_TYPE (copy), ContextProvider (copy), REACT_CONTEXT_TYPE (copy), ContextConsumer (copy), REACT_FORWARD_REF_TYPE (copy), ForwardRef (copy), resolveForwardRefForHotReloading (copy), REACT_MEMO_TYPE (copy), MemoComponent (copy), REACT_LAZY_TYPE (copy), LazyComponent (copy), Object (copy), inspect (copy), getComponentName (copy), Array (copy), REACT_ELEMENT_TYPE (copy), invariant (copy), createFiber (copy)
	local v111 = IndeterminateComponent
	local v112 = p10
	local v113 = type(p10)

	if v113 == "function" then
		if __DEV__ then
			v112 = resolveFunctionForHotReloading(v112)
		end
	elseif v113 == "table" and p10.isReactComponent then
		v111 = ClassComponent

		if __DEV__ then
			v112 = resolveClassForHotReloading(v112)
		end
	elseif v113 == "string" then
		v111 = HostComponent
	else
		if p10 == REACT_FRAGMENT_TYPE then
			return createFiberFromFragment(p11.children, p13, p14, s1)
		end

		if p10 == REACT_DEBUG_TRACING_MODE_TYPE then
			v111 = ReactWorkTagsMode
			p13 = bit32.bor(p13, DebugTracingMode)
		elseif p10 == REACT_STRICT_MODE_TYPE then
			v111 = ReactWorkTagsMode
			p13 = bit32.bor(p13, StrictMode)
		else
			if p10 == REACT_PROFILER_TYPE then
				return createFiberFromProfiler(p11, p13, p14, s1)
			end

			if p10 == REACT_SUSPENSE_TYPE then
				return createFiberFromSuspense(p11, p13, p14, s1)
			end

			if p10 == REACT_OFFSCREEN_TYPE then
				return createFiberFromOffscreen(p11, p13, p14, s1)
			end

			if p10 == REACT_LEGACY_HIDDEN_TYPE then
				return createFiberFromLegacyHidden(p11, p13, p14, s1)
			end

			local v114 = false
			local v115 = nil

			if v113 == "table" then
				v115 = p10["$$typeof"]

				if v115 == REACT_PROVIDER_TYPE then
					v111 = ContextProvider
					v114 = true
				elseif v115 == REACT_CONTEXT_TYPE then
					v111 = ContextConsumer
					v114 = true
				elseif v115 == REACT_FORWARD_REF_TYPE then
					v111 = ForwardRef

					if __DEV__ then
						v112 = resolveForwardRefForHotReloading(v112)
					end

					v114 = true
				elseif v115 == REACT_MEMO_TYPE then
					v111 = MemoComponent
					v114 = true
				elseif v115 == REACT_LAZY_TYPE then
					v111 = LazyComponent
					v112 = nil
					v114 = true
				end
			end

			if not v114 then
				local s2 = ""

				if __DEV__ then
					if p10 == nil or v113 == "table" and #Object.keys(p10) == 0 then
						s2 ..= " You likely forgot to export your component from the file " .. "it's defined in, or you might have mixed up default and " .. "named imports."
					elseif p10 ~= nil and v113 == "table" then
						s2 ..= "\n" .. inspect(p10)
					end

					local v117 = nil

					if p12 then
						v117 = getComponentName(p12.type)
					end

					if v117 ~= nil and v117 ~= "" then
						s2 ..= "\n\nCheck the render method of `" .. v117 .. "`."
					elseif p12 then
						s2 ..= "\n" .. inspect(p12)
					end
				end

				if p10 == nil then
					v113 = "nil"
				elseif Array.isArray(p10) then
					v113 = "array"
				elseif v113 == "table" and v115 == REACT_ELEMENT_TYPE then
					v113 = string.format("<%s />", getComponentName(p10.type) or "Unknown")
					s2 = " Did you accidentally export a JSX literal or Element instead of a component?"
				end

				invariant(false, "Element type is invalid: expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s", v113, s2)
			end
		end
	end

	local v118 = createFiber(v111, p11, s1, p13, p10, v112, nil, p14)

	if __DEV__ then
		v118._debugOwner = p12
	end

	return v118
end

function createFiberFromFragment(p15, p16, p17, s3: string?) -- line: 687
	-- upvalues: createFiber (copy), Fragment (copy)
	return (createFiber(Fragment, p15, s3, p16, nil, nil, nil, p17))
end

local function createFiberFromScope(p18, p19, p20, p21, s4: string?) -- line: 725
	-- upvalues: createFiber (copy), ScopeComponent (copy)
	return (createFiber(ScopeComponent, p19, s4, p20, p18, p18, nil, p21))
end

function createFiberFromProfiler(p22, p23, p24, s5: string?) -- line: 742
	-- upvalues: __DEV__ (copy), console (copy), createFiber (copy), Profiler (copy), ProfileMode (copy), REACT_PROFILER_TYPE (copy), enableProfilerTimer (copy)
	if __DEV__ and typeof(p22.id) ~= "string" then
		console.error("Profiler must specify an \"id\" as a prop")
	end

	return (createFiber(Profiler, p22, s5, bit32.bor(p23, ProfileMode), REACT_PROFILER_TYPE, REACT_PROFILER_TYPE, if not enableProfilerTimer then nil else {
		effectDuration = 0,
		passiveEffectDuration = 0
	}, p24))
end
function createFiberFromSuspense(p25, p26, p27, s6: string?) -- line: 786
	-- upvalues: createFiber (copy), SuspenseComponent (copy), REACT_SUSPENSE_TYPE (copy)
	return (createFiber(SuspenseComponent, p25, s6, p26, REACT_SUSPENSE_TYPE, REACT_SUSPENSE_TYPE, nil, p27))
end
function createFiberFromOffscreen(p28, p29, p30, s7: string?) -- line: 844
	-- upvalues: createFiber (copy), OffscreenComponent (copy), REACT_OFFSCREEN_TYPE (copy), __DEV__ (copy)
	return (createFiber(OffscreenComponent, p28, s7, p29, REACT_OFFSCREEN_TYPE, if not __DEV__ then nil else REACT_OFFSCREEN_TYPE, nil, p30))
end
function createFiberFromLegacyHidden(p31, p32, p33, s8: string?) -- line: 873
	-- upvalues: createFiber (copy), LegacyHiddenComponent (copy), REACT_LEGACY_HIDDEN_TYPE (copy), __DEV__ (copy)
	return (createFiber(LegacyHiddenComponent, p31, s8, p32, REACT_LEGACY_HIDDEN_TYPE, if not __DEV__ then nil else REACT_LEGACY_HIDDEN_TYPE, nil, p33))
end

return {
	isSimpleFunctionComponent = function(p34) -- line: 274
		return type(p34) == "function"
	end,
	resolveLazyComponentTag = function(p35) -- line: 282
		-- upvalues: FunctionComponent (copy), ClassComponent (copy), REACT_FORWARD_REF_TYPE (copy), ForwardRef (copy), REACT_MEMO_TYPE (copy), MemoComponent (copy), IndeterminateComponent (copy)
		local v93 = typeof(p35)

		if v93 == "function" then
			return FunctionComponent
		end

		if v93 == "table" then
			if p35.isReactComponent then
				return ClassComponent
			end

			local v94 = p35["$$typeof"]

			if v94 == REACT_FORWARD_REF_TYPE then
				return ForwardRef
			end

			if v94 == REACT_MEMO_TYPE then
				return MemoComponent
			end
		end

		return IndeterminateComponent
	end,
	createWorkInProgress = function(p36, p37) -- line: 305
		-- upvalues: createFiber (copy), __DEV__ (copy), NoFlags (copy), enableProfilerTimer (copy), StaticMask (copy), IndeterminateComponent (copy), FunctionComponent (copy), SimpleMemoComponent (copy), resolveFunctionForHotReloading (copy), ClassComponent (copy), resolveClassForHotReloading (copy), ForwardRef (copy), resolveForwardRefForHotReloading (copy)
		local alternate = p36.alternate

		if alternate == nil then
			alternate = createFiber(p36.tag, p37, p36.key, p36.mode, p36.elementType, p36.type, p36.stateNode)

			if __DEV__ then
				alternate._debugID = p36._debugID
				alternate._debugSource = p36._debugSource
				alternate._debugOwner = p36._debugOwner
				alternate._debugHookTypes = p36._debugHookTypes
			end

			alternate.alternate = p36
			p36.alternate = alternate
		else
			alternate.pendingProps = p37
			alternate.type = p36.type
			alternate.flags = NoFlags
			alternate.subtreeFlags = NoFlags
			alternate.deletions = nil

			if enableProfilerTimer then
				alternate.actualDuration = 0
				alternate.actualStartTime = -1
			end
		end

		alternate.flags = bit32.band(p36.flags, StaticMask)
		alternate.childLanes = p36.childLanes
		alternate.lanes = p36.lanes
		alternate.child = p36.child
		alternate.memoizedProps = p36.memoizedProps
		alternate.memoizedState = p36.memoizedState
		alternate.updateQueue = p36.updateQueue

		local dependencies = p36.dependencies

		if dependencies == nil then
			alternate.dependencies = nil
		else
			alternate.dependencies = {
				lanes = dependencies.lanes,
				firstContext = dependencies.firstContext
			}
		end

		alternate.sibling = p36.sibling
		alternate.index = p36.index
		alternate.ref = p36.ref

		if enableProfilerTimer then
			alternate.selfBaseDuration = p36.selfBaseDuration
			alternate.treeBaseDuration = p36.treeBaseDuration
		end

		if __DEV__ then
			alternate._debugNeedsRemount = p36._debugNeedsRemount

			if alternate.tag == IndeterminateComponent or alternate.tag == FunctionComponent or alternate.tag == SimpleMemoComponent then
				alternate.type = resolveFunctionForHotReloading(p36.type)

				return alternate
			end

			if alternate.tag == ClassComponent then
				alternate.type = resolveClassForHotReloading(p36.type)

				return alternate
			end

			if alternate.tag == ForwardRef then
				alternate.type = resolveForwardRefForHotReloading(p36.type)
			end
		end

		return alternate
	end,
	resetWorkInProgress = function(p38, p39) -- line: 409
		-- upvalues: StaticMask (copy), Placement (copy), NoLanes (copy), NoFlags (copy), enableProfilerTimer (copy)
		p38.flags = bit32.band(p38.flags, (bit32.bor(StaticMask, Placement)))

		local alternate = p38.alternate

		if alternate == nil then
			p38.childLanes = NoLanes
			p38.lanes = p39
			p38.child = nil
			p38.subtreeFlags = NoFlags
			p38.memoizedProps = nil
			p38.memoizedState = nil
			p38.updateQueue = nil
			p38.dependencies = nil
			p38.stateNode = nil

			if enableProfilerTimer then
				p38.selfBaseDuration = 0
				p38.treeBaseDuration = 0

				return p38
			end
		else
			p38.childLanes = alternate.childLanes
			p38.lanes = alternate.lanes
			p38.child = alternate.child
			p38.subtreeFlags = alternate.subtreeFlags
			p38.deletions = nil
			p38.memoizedProps = alternate.memoizedProps
			p38.memoizedState = alternate.memoizedState
			p38.updateQueue = alternate.updateQueue
			p38.type = alternate.type

			local dependencies = alternate.dependencies

			if dependencies == nil then
				p38.dependencies = nil
			else
				p38.dependencies = {
					lanes = dependencies.lanes,
					firstContext = dependencies.firstContext
				}
			end

			if enableProfilerTimer then
				p38.selfBaseDuration = alternate.selfBaseDuration
				p38.treeBaseDuration = alternate.treeBaseDuration
			end
		end

		return p38
	end,
	createHostRootFiber = function(p40) -- line: 484
		-- upvalues: ConcurrentRoot (copy), ConcurrentMode (copy), BlockingMode (copy), StrictMode (copy), BlockingRoot (copy), NoMode (copy), enableProfilerTimer (copy), isDevToolsPresent (copy), ProfileMode (copy), createFiber (copy), HostRoot (copy)
		local v104 = if p40 ~= ConcurrentRoot then if p40 ~= BlockingRoot then NoMode else bit32.bor(BlockingMode, StrictMode) else bit32.bor(ConcurrentMode, BlockingMode, StrictMode)

		if enableProfilerTimer and isDevToolsPresent() then
			v104 = bit32.bor(v104, ProfileMode)
		end

		return (createFiber(HostRoot, nil, nil, v104))
	end,
	createFiberFromTypeAndProps = createFiberFromTypeAndProps,
	createFiberFromElement = function(p41, p42, p43) -- line: 659
		-- upvalues: __DEV__ (copy), createFiberFromTypeAndProps (copy)
		local _owner = nil

		if __DEV__ then
			_owner = p41._owner
		end

		local type2 = p41.type
		local key = p41.key
		local props = p41.props
		local v126 = createFiberFromTypeAndProps(type2, key, props, _owner, p42, p43)

		if __DEV__ then
			v126._debugSource = p41._source
			v126._debugOwner = p41._owner
		end

		return v126
	end,
	createFiberFromFragment = createFiberFromFragment,
	createFiberFromFundamental = function(p44, p45, p46, p47, s9: string?) -- line: 700
		-- upvalues: createFiber (copy), FundamentalComponent (copy)
		return (createFiber(FundamentalComponent, p45, s9, p46, p44, p44, nil, p47))
	end,
	createFiberFromSuspense = createFiberFromSuspense,
	createFiberFromSuspenseList = function(p48, p49, p50, s10: string?) -- line: 815
		-- upvalues: createFiber (copy), SuspenseListComponent (copy), REACT_SUSPENSE_LIST_TYPE (copy), __DEV__ (copy)
		return (createFiber(SuspenseListComponent, p48, s10, p49, REACT_SUSPENSE_LIST_TYPE, if not __DEV__ then nil else REACT_SUSPENSE_LIST_TYPE, nil, p50))
	end,
	createFiberFromOffscreen = createFiberFromOffscreen,
	createFiberFromLegacyHidden = createFiberFromLegacyHidden,
	createFiberFromText = function(s11: string, p51, p52) -- line: 902
		-- upvalues: createFiber (copy), HostText (copy)
		return (createFiber(HostText, s11, nil, p51, nil, nil, nil, p52))
	end,
	createFiberFromHostInstanceForDeletion = function() -- line: 910
		-- upvalues: createFiber (copy), HostComponent (copy), NoMode (copy)
		return (createFiber(HostComponent, nil, nil, NoMode, "DELETED", "DELETED"))
	end,
	createFiberFromDehydratedFragment = function(p53) -- line: 920
		-- upvalues: createFiber (copy), DehydratedFragment (copy), NoMode (copy)
		return (createFiber(DehydratedFragment, nil, nil, NoMode, nil, nil, p53))
	end,
	createFiberFromPortal = function(p54, p55, p56) -- line: 929
		-- upvalues: createFiber (copy), HostPortal (copy)
		local v168 = if p54.children == nil then {} else p54.children

		return (createFiber(HostPortal, v168, p54.key, p55, nil, nil, {
			pendingChildren = nil,
			containerInfo = p54.containerInfo,
			implementation = p54.implementation
		}, p56))
	end,
	assignFiberPropertiesInDEV = function(p57, p58) -- line: 953
		-- upvalues: createFiber (copy), IndeterminateComponent (copy), NoMode (copy), enableProfilerTimer (copy)
		if p57 == nil then
			p57 = createFiber(IndeterminateComponent, nil, nil, NoMode)
		end

		p57.tag = p58.tag
		p57.key = p58.key
		p57.elementType = p58.elementType
		p57.type = p58.type
		p57.stateNode = p58.stateNode
		p57.return_ = p58.return_
		p57.child = p58.child
		p57.sibling = p58.sibling
		p57.index = p58.index
		p57.ref = p58.ref
		p57.pendingProps = p58.pendingProps
		p57.memoizedProps = p58.memoizedProps
		p57.updateQueue = p58.updateQueue
		p57.memoizedState = p58.memoizedState
		p57.dependencies = p58.dependencies
		p57.mode = p58.mode
		p57.flags = p58.flags
		p57.subtreeFlags = p58.subtreeFlags
		p57.deletions = p58.deletions
		p57.lanes = p58.lanes
		p57.childLanes = p58.childLanes
		p57.alternate = p58.alternate

		if enableProfilerTimer then
			p57.actualDuration = p58.actualDuration
			p57.actualStartTime = p58.actualStartTime
			p57.selfBaseDuration = p58.selfBaseDuration
			p57.treeBaseDuration = p58.treeBaseDuration
		end

		p57._debugID = p58._debugID
		p57._debugSource = p58._debugSource
		p57._debugOwner = p58._debugOwner
		p57._debugNeedsRemount = p58._debugNeedsRemount
		p57._debugHookTypes = p58._debugHookTypes

		return p57
	end
}
