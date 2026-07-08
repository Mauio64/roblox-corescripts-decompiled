local function unimplemented(s1: string) -- line: 11
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(s1))
	error("FIXME (roblox): " .. s1 .. " is unimplemented", 2)
end

local ParentParent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local OffscreenLane = ReactFiberLane.OffscreenLane
local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactFiberOffscreenComponent)

local resetWorkInProgressVersions = require(script.Parent["ReactMutableSource.new"]).resetWorkInProgressVersions
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local IndeterminateComponent = ReactWorkTags.IndeterminateComponent
local FunctionComponent = ReactWorkTags.FunctionComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local ContextProvider = ReactWorkTags.ContextProvider
local ContextConsumer = ReactWorkTags.ContextConsumer
local ForwardRef = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local ReactWorkTagsMode = ReactWorkTags.Mode
local Profiler = ReactWorkTags.Profiler
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local LazyComponent = ReactWorkTags.LazyComponent
local IncompleteClassComponent = ReactWorkTags.IncompleteClassComponent
local FundamentalComponent = ReactWorkTags.FundamentalComponent
local ScopeComponent = ReactWorkTags.ScopeComponent
local Block = ReactWorkTags.Block
local OffscreenComponent = ReactWorkTags.OffscreenComponent
local LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local NoMode = ReactTypeOfMode.NoMode
local ConcurrentMode = ReactTypeOfMode.ConcurrentMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local ProfileMode = ReactTypeOfMode.ProfileMode
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Ref = ReactFiberFlags.Ref
local Update = ReactFiberFlags.Update
local Callback = ReactFiberFlags.Callback
local Passive = ReactFiberFlags.Passive
local Deletion = ReactFiberFlags.Deletion
local NoFlags = ReactFiberFlags.NoFlags
local DidCapture = ReactFiberFlags.DidCapture
local Snapshot = ReactFiberFlags.Snapshot
local MutationMask = ReactFiberFlags.MutationMask
local LayoutMask = ReactFiberFlags.LayoutMask
local PassiveMask = ReactFiberFlags.PassiveMask
local StaticMask = ReactFiberFlags.StaticMask
local PerformedWork = ReactFiberFlags.PerformedWork
local invariant = require(ParentParent.Shared).invariant
local createInstance = ReactFiberHostConfig.createInstance
local createTextInstance = ReactFiberHostConfig.createTextInstance
local appendInitialChild = ReactFiberHostConfig.appendInitialChild
local finalizeInitialChildren = ReactFiberHostConfig.finalizeInitialChildren
local prepareUpdate = ReactFiberHostConfig.prepareUpdate
local supportsMutation = ReactFiberHostConfig.supportsMutation
local supportsPersistence = ReactFiberHostConfig.supportsPersistence
local createContainerChildSet = ReactFiberHostConfig.createContainerChildSet
local finalizeContainerChildren = ReactFiberHostConfig.finalizeContainerChildren
local preparePortalMount = ReactFiberHostConfig.preparePortalMount
local lib = require(script.Parent["ReactFiberHostContext.new"])
local getRootHostContainer = lib.getRootHostContainer
local popHostContext = lib.popHostContext
local getHostContext = lib.getHostContext
local popHostContainer = lib.popHostContainer
local lib2 = require(script.Parent["ReactFiberSuspenseContext.new"])
local popSuspenseContext = lib2.popSuspenseContext
local suspenseStackCursor = lib2.suspenseStackCursor
local InvisibleParentSuspenseContext = lib2.InvisibleParentSuspenseContext
local hasSuspenseContext = lib2.hasSuspenseContext
local lib3 = require(script.Parent["ReactFiberContext.new"])
local isContextProvider = lib3.isContextProvider
local popContext = lib3.popContext
local popTopLevelContextObject = lib3.popTopLevelContextObject
local popProvider = require(script.Parent["ReactFiberNewContext.new"]).popProvider
local lib4 = require(script.Parent["ReactFiberHydrationContext.new"])
local prepareToHydrateHostSuspenseInstance = lib4.prepareToHydrateHostSuspenseInstance
local popHydrationState = lib4.popHydrationState
local resetHydrationState = lib4.resetHydrationState
local prepareToHydrateHostInstance = lib4.prepareToHydrateHostInstance
local prepareToHydrateHostTextInstance = lib4.prepareToHydrateHostTextInstance
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableSuspenseCallback = ReactFeatureFlags.enableSuspenseCallback
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
local enableFundamentalAPI = ReactFeatureFlags.enableFundamentalAPI
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local lib5 = require(script.Parent["ReactFiberWorkLoop.new"])
local popRenderLanes = lib5.popRenderLanes
local markSpawnedWork = lib5.markSpawnedWork
local renderDidSuspend = lib5.renderDidSuspend
local renderDidSuspendDelayIfPossible = lib5.renderDidSuspendDelayIfPossible
local NoLanes = ReactFiberLane.NoLanes
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes
local transferActualDuration = require(script.Parent["ReactProfilerTimer.new"]).transferActualDuration

local function markUpdate(p1) -- line: 189
	-- upvalues: Update (copy)
	p1.flags = bit32.bor(p1.flags, Update)
end
local function markRef(p2) -- line: 195
	-- upvalues: Ref (copy)
	p2.flags = bit32.bor(p2.flags, Ref)
end
local function hadNoMutationsEffects(p3, p4) -- line: 201
	-- upvalues: MutationMask (copy), NoFlags (copy)
	if p3 ~= nil and p3.child == p4.child then
		return true
	end

	local child = p4.child

	while child ~= nil do
		if bit32.band(child.flags, MutationMask) ~= NoFlags then
			return false
		end

		if bit32.band(child.subtreeFlags, MutationMask) ~= NoFlags then
			return false
		end

		child = child.sibling
	end

	return true
end

local u101 = nil
local updateHostComponent = nil
local updateHostText = nil
local updateHostContainer

if supportsMutation then
	function u101(p5, p6, _: boolean, _: boolean) -- line: 227
		-- upvalues: HostComponent (copy), HostText (copy), appendInitialChild (copy), enableFundamentalAPI (copy), FundamentalComponent (copy), HostPortal (copy)
		local child = p6.child
		local g118 = nil
		local g119 = nil

		while child ~= nil do
			if child.tag == HostComponent or child.tag == HostText then
				appendInitialChild(p5, child.stateNode)
				g118 = true
			end

			repeat
				if g118 or (g118 or enableFundamentalAPI and child.tag == FundamentalComponent) then
					if not g118 then
						if not g118 then
							appendInitialChild(p5, child.stateNode.instance)
						end
					end

					g118 = false

					if child == p6 then
						return
					end

					while child.sibling == nil do
						if child.return_ == nil or p6 == child.return_ then
							return
						end

						child = child.return_
					end

					child.sibling.return_ = child.return_
					child = child.sibling
					g119 = true

					break
				end

				if child.tag == HostPortal or child.child == nil then
					g118 = true
				end
			until not g118

			if g119 then
				g119 = false

				continue
			end

			child.child.return_ = child
			child = child.child
		end
	end
	function updateHostContainer(_, _) -- line: 265
	end
	function updateHostComponent(p9, p10, p11, p12, p13) -- line: 268
		-- upvalues: getHostContext (copy), prepareUpdate (copy), Update (copy)
		local memoizedProps = p9.memoizedProps

		if memoizedProps == p12 then
			return
		end

		local stateNode = p10.stateNode
		local v129 = getHostContext()
		local v130 = prepareUpdate(stateNode, p11, memoizedProps, p12, p13, v129)

		p10.updateQueue = v130

		if v130 then
			p10.flags = bit32.bor(p10.flags, Update)
		end
	end
	function updateHostText(_, p15, s2: string, s3: string) -- line: 309
		-- upvalues: Update (copy)
		if s2 ~= s3 then
			p15.flags = bit32.bor(p15.flags, Update)
		end
	end
elseif supportsPersistence then
	function u101(_, _, _: boolean, _: boolean) -- line: 322
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("appendAllChildren"))
		error("FIXME (roblox): appendAllChildren is unimplemented", 2)
	end

	local function appendAllChildrenToContainer(_, _, _: boolean, _: boolean) -- line: 417
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("appendAllChildrenToContainer"))
		error("FIXME (roblox): appendAllChildrenToContainer is unimplemented", 2)
	end

	function updateHostContainer(p20, p21) -- line: 511
		-- upvalues: hadNoMutationsEffects (copy), createContainerChildSet (copy), Update (copy), finalizeContainerChildren (copy)
		local stateNode = p21.stateNode

		if hadNoMutationsEffects(p20, p21) then
			return
		end

		local containerInfo = stateNode.containerInfo
		local v147 = createContainerChildSet(containerInfo)

		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("appendAllChildrenToContainer"))
		error("FIXME (roblox): appendAllChildrenToContainer is unimplemented", 2)
		stateNode.pendingChildren = v147
		p21.flags = bit32.bor(p21.flags, Update)
		finalizeContainerChildren(containerInfo, v147)
	end
else
	function updateHostContainer(_, _) -- line: 627
	end
end

local function bubbleProperties(p24) -- line: 720
	-- upvalues: NoLanes (copy), NoFlags (copy), enableProfilerTimer (copy), ProfileMode (copy), NoMode (copy), mergeLanes (copy), StaticMask (copy)
	local v151 = p24.alternate ~= nil and p24.alternate.child == p24.child
	local v152 = NoLanes
	local v153 = NoFlags

	if not v151 then
		if enableProfilerTimer and bit32.band(p24.mode, ProfileMode) ~= NoMode then
			local actualDuration = p24.actualDuration
			local selfBaseDuration = p24.selfBaseDuration
			local child = p24.child

			while child ~= nil do
				v152 = mergeLanes(v152, mergeLanes(child.lanes, child.childLanes))
				v153 = bit32.bor(bit32.bor(v153, child.subtreeFlags), child.flags)
				actualDuration += child.actualDuration
				selfBaseDuration += child.treeBaseDuration
				child = child.sibling
			end

			p24.actualDuration = actualDuration
			p24.treeBaseDuration = selfBaseDuration
		else
			local child = p24.child

			while child ~= nil do
				v152 = bit32.bor(v152, (bit32.bor(child.lanes, child.childLanes)))
				v153 = bit32.bor(bit32.bor(v153, child.subtreeFlags), child.flags)
				child.return_ = p24
				child = child.sibling
			end
		end

		p24.subtreeFlags = bit32.bor(p24.subtreeFlags, v153)
	else
		if enableProfilerTimer and bit32.band(p24.mode, ProfileMode) ~= NoMode then
			local selfBaseDuration = p24.selfBaseDuration
			local child = p24.child

			while child ~= nil do
				v152 = mergeLanes(v152, mergeLanes(child.lanes, child.childLanes))
				v153 = bit32.bor(bit32.bor(v153, (bit32.band(child.subtreeFlags, StaticMask))), (bit32.band(child.flags, StaticMask)))
				selfBaseDuration += child.treeBaseDuration
				child = child.sibling
			end

			p24.treeBaseDuration = selfBaseDuration
		else
			local child = p24.child

			while child ~= nil do
				v152 = bit32.bor(v152, (bit32.bor(child.lanes, child.childLanes)))
				v153 = bit32.bor(bit32.bor(v153, (bit32.band(child.subtreeFlags, StaticMask))), (bit32.band(child.flags, StaticMask)))
				child.return_ = p24
				child = child.sibling
			end
		end

		p24.subtreeFlags = bit32.bor(p24.subtreeFlags, v153)
	end

	p24.childLanes = v152

	return v151
end

return {
	completeWork = function(p25, p26, p27) -- line: 859
		-- upvalues: IndeterminateComponent (copy), LazyComponent (copy), SimpleMemoComponent (copy), FunctionComponent (copy), ForwardRef (copy), Fragment (copy), ReactWorkTagsMode (copy), ContextConsumer (copy), MemoComponent (copy), bubbleProperties (copy), ClassComponent (copy), isContextProvider (copy), popContext (copy), HostRoot (copy), popHostContainer (copy), popTopLevelContextObject (copy), resetWorkInProgressVersions (copy), popHydrationState (copy), Update (copy), Snapshot (copy), updateHostContainer (ref), HostComponent (copy), popHostContext (copy), getRootHostContainer (copy), updateHostComponent (ref), Ref (copy), invariant (copy), getHostContext (copy), prepareToHydrateHostInstance (copy), createInstance (copy), u101 (ref), finalizeInitialChildren (copy), HostText (copy), updateHostText (ref), prepareToHydrateHostTextInstance (copy), createTextInstance (copy), Profiler (copy), Callback (copy), Passive (copy), PerformedWork (copy), NoFlags (copy), LayoutMask (copy), Deletion (copy), PassiveMask (copy), SuspenseComponent (copy), popSuspenseContext (copy), enableSuspenseServerRenderer (copy), prepareToHydrateHostSuspenseInstance (copy), enableSchedulerTracing (copy), markSpawnedWork (copy), OffscreenLane (copy), enableProfilerTimer (copy), ProfileMode (copy), NoMode (copy), resetHydrationState (copy), DidCapture (copy), transferActualDuration (copy), BlockingMode (copy), hasSuspenseContext (copy), suspenseStackCursor (copy), InvisibleParentSuspenseContext (copy), renderDidSuspend (copy), renderDidSuspendDelayIfPossible (copy), supportsPersistence (copy), supportsMutation (copy), enableSuspenseCallback (copy), HostPortal (copy), preparePortalMount (copy), ContextProvider (copy), popProvider (copy), IncompleteClassComponent (copy), SuspenseListComponent (copy), FundamentalComponent (copy), ScopeComponent (copy), Block (copy), OffscreenComponent (copy), LegacyHiddenComponent (copy), popRenderLanes (copy), includesSomeLane (copy), lib5 (copy), ConcurrentMode (copy)
		local pendingProps = p26.pendingProps

		if p26.tag == IndeterminateComponent or (p26.tag == LazyComponent or p26.tag == SimpleMemoComponent or p26.tag == FunctionComponent or p26.tag == ForwardRef or p26.tag == Fragment or p26.tag == ReactWorkTagsMode or p26.tag == ContextConsumer or p26.tag == MemoComponent) then
			bubbleProperties(p26)

			return nil
		end

		if p26.tag == ClassComponent then
			local type = p26.type

			if isContextProvider(type) then
				popContext(p26)
			end

			bubbleProperties(p26)

			return nil
		end

		if p26.tag == HostRoot then
			popHostContainer(p26)
			popTopLevelContextObject(p26)
			resetWorkInProgressVersions()

			local stateNode = p26.stateNode

			if stateNode.pendingContext then
				stateNode.context = stateNode.pendingContext
				stateNode.pendingContext = nil
			end

			if p25 == nil or p25.child == nil then
				if popHydrationState(p26) then
					p26.flags = bit32.bor(p26.flags, Update)
				elseif not stateNode.hydrate then
					p26.flags = bit32.bor(p26.flags, Snapshot)
				end
			end

			updateHostContainer(p25, p26)
			bubbleProperties(p26)

			return nil
		end

		if p26.tag == HostComponent then
			popHostContext(p26)

			local v167 = getRootHostContainer()
			local type = p26.type

			if p25 ~= nil and p26.stateNode ~= nil then
				updateHostComponent(p25, p26, type, pendingProps, v167)

				if p25.ref ~= p26.ref then
					p26.flags = bit32.bor(p26.flags, Ref)
				end
			else
				if not pendingProps then
					invariant(p26.stateNode ~= nil, "We must have new props for new mounts. This error is likely caused by a bug in React. Please file an issue.")
					bubbleProperties(p26)

					return nil
				end

				local v169 = getHostContext()

				if popHydrationState(p26) then
					if prepareToHydrateHostInstance(p26, v167, v169) then
						p26.flags = bit32.bor(p26.flags, Update)
					end
				else
					local v170 = createInstance(type, pendingProps, v167, v169, p26)

					u101(v170, p26, false, false)
					p26.stateNode = v170

					if finalizeInitialChildren(v170, type, pendingProps, v167, v169) then
						p26.flags = bit32.bor(p26.flags, Update)
					end
				end

				if p26.ref ~= nil then
					p26.flags = bit32.bor(p26.flags, Ref)
				end
			end

			bubbleProperties(p26)

			return nil
		end

		if p26.tag == HostText then
			if p25 and p26.stateNode ~= nil then
				local memoizedProps = p25.memoizedProps

				updateHostText(p25, p26, memoizedProps, pendingProps)
			else
				if typeof(pendingProps) ~= "string" then
					invariant(p26.stateNode ~= nil, "We must have new props for new mounts. This error is likely caused by a bug in React. Please file an issue.")
				end

				local v172 = getRootHostContainer()
				local v173 = getHostContext()

				if popHydrationState(p26) then
					if prepareToHydrateHostTextInstance(p26) then
						p26.flags = bit32.bor(p26.flags, Update)
					end
				else
					p26.stateNode = createTextInstance(pendingProps, v172, v173, p26)
				end
			end

			bubbleProperties(p26)

			return nil
		end

		if p26.tag == Profiler then
			if not bubbleProperties(p26) then
				local v174 = Update
				local v175 = Callback
				local v176 = Passive
				local subtreeFlags = p26.subtreeFlags
				local flags = p26.flags
				local v179 = flags

				if bit32.band(flags, PerformedWork) ~= NoFlags or bit32.band(subtreeFlags, PerformedWork) ~= NoFlags then
					v179 = bit32.bor(v179, v174)
				end

				if bit32.band(flags, (bit32.bor(LayoutMask, Deletion))) ~= NoFlags or bit32.band(subtreeFlags, (bit32.bor(LayoutMask, Deletion))) ~= NoFlags then
					v179 = bit32.bor(v179, v175)
				end

				if bit32.band(flags, PassiveMask) ~= NoFlags or bit32.band(subtreeFlags, PassiveMask) ~= NoFlags then
					v179 = bit32.bor(v179, v176)
				end

				p26.flags = v179
			end

			return nil
		end

		if p26.tag == SuspenseComponent then
			popSuspenseContext(p26)

			local memoizedState = p26.memoizedState

			if enableSuspenseServerRenderer and memoizedState ~= nil and memoizedState.dehydrated ~= nil then
				if p25 == nil then
					local v181 = popHydrationState(p26)

					invariant(v181, "A dehydrated suspense component was completed without a hydrated node. This is probably a bug in React.")
					prepareToHydrateHostSuspenseInstance(p26)

					if enableSchedulerTracing then
						markSpawnedWork(OffscreenLane)
					end

					bubbleProperties(p26)

					if enableProfilerTimer and bit32.band(p26.mode, ProfileMode) ~= NoMode and memoizedState ~= nil then
						local child = p26.child

						if child ~= nil then
							p26.treeBaseDuration = child.treeBaseDuration
						end
					end

					return nil
				end

				resetHydrationState()

				if bit32.band(p26.flags, DidCapture) == NoFlags then
					p26.memoizedState = nil
				end

				p26.flags = bit32.bor(p26.flags, Update)
				bubbleProperties(p26)

				if enableProfilerTimer and bit32.band(p26.mode, ProfileMode) ~= NoMode and memoizedState ~= nil then
					local child = p26.child

					if child ~= nil then
						p26.treeBaseDuration = p26.treeBaseDuration - child.treeBaseDuration
					end
				end

				return nil
			end

			if bit32.band(p26.flags, DidCapture) ~= NoFlags then
				p26.lanes = p27

				if enableProfilerTimer and bit32.band(p26.mode, ProfileMode) ~= NoMode then
					transferActualDuration(p26)
				end

				return p26
			end

			local v184 = memoizedState ~= nil
			local v185 = false

			if p25 == nil then
				if p26.memoizedProps.fallback ~= nil then
					popHydrationState(p26)
				end
			else
				v185 = p25.memoizedState ~= nil
			end

			if v184 and not v185 and bit32.band(p26.mode, BlockingMode) ~= NoMode then
				if p25 == nil and p26.memoizedProps.unstable_avoidThisFallback ~= true or hasSuspenseContext(suspenseStackCursor.current, InvisibleParentSuspenseContext) then
					renderDidSuspend()
				else
					renderDidSuspendDelayIfPossible()
				end
			end

			if supportsPersistence and v184 then
				p26.flags = bit32.bor(p26.flags, Update)
			end

			if supportsMutation and (v184 or v185) then
				p26.flags = bit32.bor(p26.flags, Update)
			end

			if enableSuspenseCallback and p26.updateQueue ~= nil and p26.memoizedProps.suspenseCallback ~= nil then
				p26.flags = bit32.bor(p26.flags, Update)
			end

			bubbleProperties(p26)

			if enableProfilerTimer and bit32.band(p26.mode, ProfileMode) ~= NoMode and v184 then
				local child = p26.child

				if child ~= nil then
					p26.treeBaseDuration = p26.treeBaseDuration - child.treeBaseDuration
				end
			end

			return nil
		end

		if p26.tag == HostPortal then
			popHostContainer(p26)
			updateHostContainer(p25, p26)

			if p25 == nil then
				preparePortalMount(p26.stateNode.containerInfo)
			end

			bubbleProperties(p26)

			return nil
		end

		if p26.tag == ContextProvider then
			popProvider(p26)
			bubbleProperties(p26)

			return nil
		end

		if p26.tag == IncompleteClassComponent then
			local type = p26.type

			if isContextProvider(type) then
				popContext(p26)
			end

			bubbleProperties(p26)

			return nil
		end

		if p26.tag == SuspenseListComponent then
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("UNIMPLEMENTED ERROR: " .. tostring("SuspenseListComponent"))
			error("FIXME (roblox): SuspenseListComponent is unimplemented", 2)
		elseif p26.tag == FundamentalComponent then
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("UNIMPLEMENTED ERROR: " .. tostring("FundamentalComponent"))
			error("FIXME (roblox): FundamentalComponent is unimplemented", 2)
		elseif p26.tag == ScopeComponent then
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("UNIMPLEMENTED ERROR: " .. tostring("ScopeComponent"))
			error("FIXME (roblox): ScopeComponent is unimplemented", 2)
		elseif p26.tag == Block then
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			print("UNIMPLEMENTED ERROR: " .. tostring("Block"))
			error("FIXME (roblox): Block is unimplemented", 2)
		elseif p26.tag == OffscreenComponent or p26.tag == LegacyHiddenComponent then
			popRenderLanes(p26)

			local v188 = p26.memoizedState ~= nil

			if p25 ~= nil and v188 ~= (p25.memoizedState ~= nil) and pendingProps.mode ~= "unstable-defer-without-hiding" then
				p26.flags = bit32.bor(p26.flags, Update)
			end

			if not v188 or includesSomeLane(lib5.subtreeRenderLanes, OffscreenLane) or bit32.band(p26.mode, ConcurrentMode) == NoMode then
				bubbleProperties(p26)
			end

			return nil
		end

		invariant(false, "Unknown unit of work tag (%s). This error is likely caused by a bug in React. Please file an issue.", (tostring(p26.tag)))

		return nil
	end
}
