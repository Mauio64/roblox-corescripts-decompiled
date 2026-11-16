local function unimplemented(p: string) -- 7 equivalent calls inferred from this helper
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(p))
	error("FIXME (roblox): " .. p .. " is unimplemented", 2)
end

local parent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)

local OffscreenLane = ReactFiberLane.OffscreenLane

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactFiberOffscreenComponent)

local ReactMutableSourcenew = require(script.Parent["ReactMutableSource.new"])

local resetWorkInProgressVersions = ReactMutableSourcenew.resetWorkInProgressVersions

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
local Mode = ReactWorkTags.Mode
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
local HostUpdate = ReactFiberFlags.HostUpdate
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

local Shared = require(parent.Shared)
local invariant = Shared.invariant

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

local ReactFiberHostContextnew = require(script.Parent["ReactFiberHostContext.new"])
local getRootHostContainer = ReactFiberHostContextnew.getRootHostContainer
local popHostContext = ReactFiberHostContextnew.popHostContext
local getHostContext = ReactFiberHostContextnew.getHostContext
local popHostContainer = ReactFiberHostContextnew.popHostContainer

local ReactFiberSuspenseContextnew = require(script.Parent["ReactFiberSuspenseContext.new"])
local popSuspenseContext = ReactFiberSuspenseContextnew.popSuspenseContext
local suspenseStackCursor = ReactFiberSuspenseContextnew.suspenseStackCursor

local InvisibleParentSuspenseContext = ReactFiberSuspenseContextnew.InvisibleParentSuspenseContext
local hasSuspenseContext = ReactFiberSuspenseContextnew.hasSuspenseContext

local ReactFiberContextnew = require(script.Parent["ReactFiberContext.new"])
local isContextProvider = ReactFiberContextnew.isContextProvider
local popContext = ReactFiberContextnew.popContext
local popTopLevelContextObject = ReactFiberContextnew.popTopLevelContextObject
local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
local popProvider = ReactFiberNewContextnew.popProvider

local ReactFiberHydrationContextnew = require(script.Parent["ReactFiberHydrationContext.new"])

local prepareToHydrateHostSuspenseInstance = ReactFiberHydrationContextnew.prepareToHydrateHostSuspenseInstance
local popHydrationState = ReactFiberHydrationContextnew.popHydrationState
local resetHydrationState = ReactFiberHydrationContextnew.resetHydrationState

local prepareToHydrateHostInstance = ReactFiberHydrationContextnew.prepareToHydrateHostInstance

local prepareToHydrateHostTextInstance = ReactFiberHydrationContextnew.prepareToHydrateHostTextInstance
local Shared2 = require(parent.Shared)
local ReactFeatureFlags = Shared2.ReactFeatureFlags
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableSuspenseCallback = ReactFeatureFlags.enableSuspenseCallback
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
local enableFundamentalAPI = ReactFeatureFlags.enableFundamentalAPI

local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer

local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])

local popRenderLanes = ReactFiberWorkLoopnew.popRenderLanes

local markSpawnedWork = ReactFiberWorkLoopnew.markSpawnedWork
local renderDidSuspend = ReactFiberWorkLoopnew.renderDidSuspend
local renderDidSuspendDelayIfPossible = ReactFiberWorkLoopnew.renderDidSuspendDelayIfPossible

local NoLanes = ReactFiberLane.NoLanes
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes

local ReactProfilerTimernew = require(script.Parent["ReactProfilerTimer.new"])
local transferActualDuration = ReactProfilerTimernew.transferActualDuration

local function markUpdate(p) -- 7 equivalent calls inferred from this helper
	p.flags = bit32.bor(p.flags, Update)
end

local function markRef(state) -- 2 equivalent calls inferred from this helper
	state.flags = bit32.bor(state.flags, Ref)
end

local function hadNoMutationsEffects(p, p2): boolean
	local v

	if p == nil then
		v = false
	else
		v = p.child == p2.child
	end

	if v then
		return true
	end

	local v2 = p2.child

	while v2 ~= nil do
		if not (bit32.band(v2.flags, MutationMask) == NoFlags and bit32.band(v2.subtreeFlags, MutationMask) == NoFlags) then
			return false
		end

		v2 = v2.sibling
	end

	return true
end

local fn

local updateHostComponent
local updateHostText
local updateHostContainer

if supportsMutation then
	updateHostComponent = function(data, state, kind, pendingProps, rootHostContainer)
		local memoizedProps = data.memoizedProps

		if memoizedProps == pendingProps then
			return
		end

		local updateQueue = prepareUpdate(
			state.stateNode,
			kind,
			memoizedProps,
			pendingProps,
			rootHostContainer,
			(getHostContext())
		)

		if ReactFeatureFlags.enableWorkLoopTrims then
			if updateQueue ~= nil or state.updateQueue ~= nil then
				state.updateQueue = updateQueue
			end
		else
			state.updateQueue = updateQueue
		end

		if updateQueue then
			if ReactFeatureFlags.enableCommitTraversalTrims then
				state.flags = bit32.bor(state.flags, HostUpdate)
			else
				markUpdate(state) -- inferred equivalent call
			end
		end
	end
	updateHostText = function(_, state, memoizedProps: string, pendingProps: string)
		if memoizedProps ~= pendingProps then
			markUpdate(state) -- inferred equivalent call
		end
	end

	updateHostContainer = function(_, _) end

	fn = function(p, p2, _: boolean, _: boolean)
		local return_ = p2.child

		while return_ ~= nil do
			if return_.tag == HostComponent or return_.tag == HostText then
				appendInitialChild(p, return_.stateNode)

				if return_ == p2 then
					break
				end

				while return_.sibling == nil do
					if return_.return_ == nil or return_.return_ == p2 then
						return
					end

					return_ = return_.return_
				end

				return_.sibling.return_ = return_.return_
				return_ = return_.sibling
			elseif enableFundamentalAPI and return_.tag == FundamentalComponent then
				appendInitialChild(p, return_.stateNode.instance)

				if return_ == p2 then
					break
				end

				while return_.sibling == nil do
					if return_.return_ == nil or return_.return_ == p2 then
						return
					end

					return_ = return_.return_
				end

				return_.sibling.return_ = return_.return_
				return_ = return_.sibling
			elseif return_.tag == HostPortal or return_.child == nil then
				if return_ == p2 then
					break
				end

				while return_.sibling == nil do
					if return_.return_ == nil or return_.return_ == p2 then
						return
					end

					return_ = return_.return_
				end

				return_.sibling.return_ = return_.return_
				return_ = return_.sibling
			else
				return_.child.return_ = return_
				return_ = return_.child
			end
		end
	end
elseif supportsPersistence then
	local function appendAllChildrenToContainer(_, _, _: boolean, _: boolean)
		unimplemented("appendAllChildrenToContainer") -- inferred equivalent call
	end

	updateHostContainer = function(p, p2)
		local stateNode = p2.stateNode

		if hadNoMutationsEffects(p, p2) then
			return
		end

		local containerInfo = stateNode.containerInfo
		local containerChildSet = createContainerChildSet(containerInfo)
		unimplemented("appendAllChildrenToContainer") -- inferred equivalent call
		stateNode.pendingChildren = containerChildSet
		markUpdate(p2) -- inferred equivalent call
		finalizeContainerChildren(containerInfo, containerChildSet)
	end

	fn = function(_, _, _: boolean, _: boolean)
		unimplemented("appendAllChildren") -- inferred equivalent call
	end
else
	updateHostContainer = function(_, _) end
end

local function bubbleProperties(return_)
	local v

	if return_.alternate == nil then
		v = false
	else
		v = return_.alternate.child == return_.child
	end

	local childLanes = NoLanes
	local v2 = NoFlags

	if v then
		if enableProfilerTimer and bit32.band(return_.mode, ProfileMode) ~= NoMode then
			local selfBaseDuration = return_.selfBaseDuration

			local v3 = return_.child

			while v3 ~= nil do
				childLanes = mergeLanes(childLanes, mergeLanes(v3.lanes, v3.childLanes))

				v2 = bit32.bor(
					bit32.bor(v2, (bit32.band(v3.subtreeFlags, StaticMask))),
					(bit32.band(v3.flags, StaticMask))
				)

				selfBaseDuration += v3.treeBaseDuration
				v3 = v3.sibling
			end

			return_.treeBaseDuration = selfBaseDuration
		else
			local v3 = return_.child

			while v3 ~= nil do
				childLanes = bit32.bor(childLanes, (bit32.bor(v3.lanes, v3.childLanes)))

				v2 = bit32.bor(
					bit32.bor(v2, (bit32.band(v3.subtreeFlags, StaticMask))),
					(bit32.band(v3.flags, StaticMask))
				)

				v3.return_ = return_

				v3 = v3.sibling
			end
		end
	elseif enableProfilerTimer and bit32.band(return_.mode, ProfileMode) ~= NoMode then
		local actualDuration = return_.actualDuration
		local selfBaseDuration = return_.selfBaseDuration

		local v3 = return_.child

		while v3 ~= nil do
			childLanes = mergeLanes(childLanes, mergeLanes(v3.lanes, v3.childLanes))

			v2 = bit32.bor(bit32.bor(v2, v3.subtreeFlags), v3.flags)

			actualDuration += v3.actualDuration

			selfBaseDuration += v3.treeBaseDuration
			v3 = v3.sibling
		end

		return_.actualDuration = actualDuration
		return_.treeBaseDuration = selfBaseDuration
	else
		local v3 = return_.child

		while v3 ~= nil do
			childLanes = bit32.bor(childLanes, (bit32.bor(v3.lanes, v3.childLanes)))

			v2 = bit32.bor(bit32.bor(v2, v3.subtreeFlags), v3.flags)

			v3.return_ = return_

			v3 = v3.sibling
		end
	end

	return_.subtreeFlags = bit32.bor(return_.subtreeFlags, v2)

	return_.childLanes = childLanes

	return v
end

return {
	completeWork = function(data, state, lanes)
		local pendingProps = state.pendingProps

		if
			state.tag == IndeterminateComponent
			or state.tag == LazyComponent
			or state.tag == SimpleMemoComponent
			or state.tag == FunctionComponent
			or state.tag == ForwardRef
			or state.tag == Fragment
			or state.tag == Mode
			or state.tag == ContextConsumer
			or state.tag == MemoComponent
		then
			bubbleProperties(state)
			return nil
		end

		if state.tag == ClassComponent then
			if isContextProvider(state.type) then
				popContext(state)
			end

			bubbleProperties(state)
			return nil
		elseif state.tag == HostRoot then
			popHostContainer(state)
			popTopLevelContextObject(state)
			resetWorkInProgressVersions()

			local stateNode = state.stateNode

			if stateNode.pendingContext then
				stateNode.context = stateNode.pendingContext
				stateNode.pendingContext = nil
			end

			if data == nil or data.child == nil then
				if popHydrationState(state) then
					markUpdate(state) -- inferred equivalent call
				elseif not stateNode.hydrate then
					state.flags = bit32.bor(state.flags, Snapshot)
				end
			end

			updateHostContainer(data, state)
			bubbleProperties(state)
			return nil
		elseif state.tag == HostComponent then
			popHostContext(state)
			local rootHostContainer = getRootHostContainer()
			local kind = state.type

			if data == nil or state.stateNode == nil then
				if pendingProps then
					local hostContext = getHostContext()

					if popHydrationState(state) then
						if prepareToHydrateHostInstance(state, rootHostContainer, hostContext) then
							markUpdate(state) -- inferred equivalent call
						end
					else
						local instance = createInstance(kind, pendingProps, rootHostContainer, hostContext, state)

						fn(instance, state, false, false)

						state.stateNode = instance

						if finalizeInitialChildren(instance, kind, pendingProps, rootHostContainer, hostContext) then
							markUpdate(state) -- inferred equivalent call
						end
					end

					if state.ref ~= nil then
						markRef(state) -- inferred equivalent call
					end
				else
					invariant(
						state.stateNode ~= nil,
						"We must have new props for new mounts. This error is likely caused by a bug in React. Please file an issue."
					)

					bubbleProperties(state)
					return nil
				end
			else
				updateHostComponent(data, state, kind, pendingProps, rootHostContainer)

				if data.ref ~= state.ref then
					markRef(state) -- inferred equivalent call
				end
			end

			bubbleProperties(state)
			return nil
		elseif state.tag == HostText then
			if data and state.stateNode ~= nil then
				updateHostText(data, state, data.memoizedProps, pendingProps)
			else
				if typeof(pendingProps) ~= "string" then
					invariant(
						state.stateNode ~= nil,
						"We must have new props for new mounts. This error is likely caused by a bug in React. Please file an issue."
					)
				end

				local rootHostContainer = getRootHostContainer()
				local hostContext = getHostContext()

				if popHydrationState(state) then
					if prepareToHydrateHostTextInstance(state) then
						markUpdate(state) -- inferred equivalent call
					end
				else
					state.stateNode = createTextInstance(pendingProps, rootHostContainer, hostContext, state)
				end
			end

			bubbleProperties(state)
			return nil
		elseif state.tag == Profiler then
			if bubbleProperties(state) then
				return nil
			end

			local callback = Callback

			local subtreeFlags = state.subtreeFlags
			local flags = state.flags
			local flags2

			if bit32.band(flags, PerformedWork) == NoFlags and bit32.band(subtreeFlags, PerformedWork) == NoFlags then
				flags2 = flags
			else
				flags2 = bit32.bor(flags, Update)
			end

			if ReactFeatureFlags.enableCommitTraversalTrims then
				if
					bit32.band(flags, (bit32.bor(LayoutMask, Deletion, HostUpdate))) ~= NoFlags
					or bit32.band(subtreeFlags, (bit32.bor(LayoutMask, Deletion, HostUpdate))) ~= NoFlags
				then
					flags2 = bit32.bor(flags2, callback)
				end
			elseif
				bit32.band(flags, (bit32.bor(LayoutMask, Deletion))) ~= NoFlags
				or bit32.band(subtreeFlags, (bit32.bor(LayoutMask, Deletion))) ~= NoFlags
			then
				flags2 = bit32.bor(flags2, callback)
			end

			if bit32.band(flags, PassiveMask) ~= NoFlags or bit32.band(subtreeFlags, PassiveMask) ~= NoFlags then
				flags2 = bit32.bor(flags2, Passive)
			end

			state.flags = flags2

			return nil
		elseif state.tag == SuspenseComponent then
			popSuspenseContext(state)
			local memoizedState = state.memoizedState

			if enableSuspenseServerRenderer and memoizedState ~= nil and memoizedState.dehydrated ~= nil then
				if data == nil then
					invariant(
						popHydrationState(state),
						"A dehydrated suspense component was completed without a hydrated node. This is probably a bug in React."
					)

					prepareToHydrateHostSuspenseInstance(state)

					if enableSchedulerTracing then
						markSpawnedWork(OffscreenLane)
					end

					bubbleProperties(state)

					if
						enableProfilerTimer
						and bit32.band(state.mode, ProfileMode) ~= NoMode
						and memoizedState ~= nil
					then
						local child = state.child

						if child ~= nil then
							state.treeBaseDuration = child.treeBaseDuration
						end
					end
				else
					resetHydrationState()

					if bit32.band(state.flags, DidCapture) == NoFlags then
						state.memoizedState = nil
					end

					state.flags = bit32.bor(state.flags, Update)
					bubbleProperties(state)

					if
						enableProfilerTimer
						and bit32.band(state.mode, ProfileMode) ~= NoMode
						and memoizedState ~= nil
					then
						local child = state.child

						if child ~= nil then
							state.treeBaseDuration -= child.treeBaseDuration
						end
					end
				end

				return nil
			elseif bit32.band(state.flags, DidCapture) == NoFlags then
				local v = memoizedState ~= nil
				local v2 = false

				if data == nil then
					if state.memoizedProps.fallback ~= nil then
						popHydrationState(state)
					end
				else
					v2 = data.memoizedState ~= nil
				end

				if v and not v2 and bit32.band(state.mode, BlockingMode) ~= NoMode then
					local v3

					if data == nil then
						v3 = state.memoizedProps.unstable_avoidThisFallback ~= true
					else
						v3 = false
					end

					if v3 or hasSuspenseContext(suspenseStackCursor.current, InvisibleParentSuspenseContext) then
						renderDidSuspend()
					else
						renderDidSuspendDelayIfPossible()
					end
				end

				if supportsPersistence and v then
					state.flags = bit32.bor(state.flags, Update)
				end

				if supportsMutation and (v or v2) then
					state.flags = bit32.bor(state.flags, Update)
				end

				if
					enableSuspenseCallback
					and state.updateQueue ~= nil
					and state.memoizedProps.suspenseCallback ~= nil
				then
					state.flags = bit32.bor(state.flags, Update)
				end

				bubbleProperties(state)

				if enableProfilerTimer and bit32.band(state.mode, ProfileMode) ~= NoMode and v then
					local child = state.child

					if child ~= nil then
						state.treeBaseDuration -= child.treeBaseDuration
					end
				end

				return nil
			else
				state.lanes = lanes

				if enableProfilerTimer and bit32.band(state.mode, ProfileMode) ~= NoMode then
					transferActualDuration(state)
				end

				return state
			end
		else
			if state.tag == HostPortal then
				popHostContainer(state)
				updateHostContainer(data, state)

				if data == nil then
					preparePortalMount(state.stateNode.containerInfo)
				end

				bubbleProperties(state)
			elseif state.tag == ContextProvider then
				popProvider(state)
				bubbleProperties(state)
			elseif state.tag == IncompleteClassComponent then
				if isContextProvider(state.type) then
					popContext(state)
				end

				bubbleProperties(state)
			else
				if state.tag == SuspenseListComponent then
					unimplemented("SuspenseListComponent") -- inferred equivalent call
				elseif state.tag == FundamentalComponent then
					unimplemented("FundamentalComponent") -- inferred equivalent call
				elseif state.tag == ScopeComponent then
					unimplemented("ScopeComponent") -- inferred equivalent call
				elseif state.tag == Block then
					unimplemented("Block") -- inferred equivalent call
				elseif state.tag == OffscreenComponent or state.tag == LegacyHiddenComponent then
					popRenderLanes(state)
					local v = state.memoizedState ~= nil

					if
						data ~= nil
						and (data.memoizedState ~= nil) ~= v
						and pendingProps.mode ~= "unstable-defer-without-hiding"
					then
						state.flags = bit32.bor(state.flags, Update)
					end

					if
						not v
						or includesSomeLane(ReactFiberWorkLoopnew.subtreeRenderLanes, OffscreenLane)
						or bit32.band(state.mode, ConcurrentMode) == NoMode
					then
						bubbleProperties(state)
					end

					return nil
				end

				invariant(
					false,
					"Unknown unit of work tag (%s). This error is likely caused by a bug in React. Please file an issue.",
					(tostring(state.tag))
				)
			end

			return nil
		end
	end
}
