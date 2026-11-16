local function unimplemented(p: string)
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(p))
	error("FIXME (roblox): " .. p .. " is unimplemented", 2)
end

local v = 0

local function isCallable(value): boolean -- 2 equivalent calls inferred from this helper
	if typeof(value) == "function" then
		return true
	end

	if typeof(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)

	if metatable and rawget(metatable, "__call") or value._isMockFunction then
		return true
	end

	return false
end

local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set

local __DEV__ = ReactGlobals.__DEV__
local __YOLO__ = ReactGlobals.__YOLO__

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactInternalTypes)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])

require(parent.Shared)

require(script.Parent.ReactFiberOffscreenComponent)

local ReactHookEffectTags = require(script.Parent.ReactHookEffectTags)

local Scheduler = require(parent.Scheduler)
local unstable_wrap = Scheduler.tracing.unstable_wrap
local Shared2 = require(parent.Shared)
local ReactFeatureFlags = Shared2.ReactFeatureFlags
local enableSchedulerTracing = ReactFeatureFlags.enableSchedulerTracing
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local enableProfilerCommitHooks = ReactFeatureFlags.enableProfilerCommitHooks

local enableSuspenseCallback = ReactFeatureFlags.enableSuspenseCallback

local enableDoubleInvokingEffects = ReactFeatureFlags.enableDoubleInvokingEffects
local enableNewTreeCleanupPath = ReactFeatureFlags.enableNewTreeCleanupPath
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local FunctionComponent = ReactWorkTags.FunctionComponent
local ForwardRef = ReactWorkTags.ForwardRef
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local Profiler = ReactWorkTags.Profiler
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local DehydratedFragment = ReactWorkTags.DehydratedFragment
local IncompleteClassComponent = ReactWorkTags.IncompleteClassComponent
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local FundamentalComponent = ReactWorkTags.FundamentalComponent
local ScopeComponent = ReactWorkTags.ScopeComponent
local Block = ReactWorkTags.Block
local OffscreenComponent = ReactWorkTags.OffscreenComponent
local LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent
local Shared3 = require(parent.Shared)
local ReactErrorUtils = Shared3.ReactErrorUtils
local invokeGuardedCallback = ReactErrorUtils.invokeGuardedCallback
local hasCaughtError = ReactErrorUtils.hasCaughtError
local clearCaughtError = ReactErrorUtils.clearCaughtError
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local NoFlags = ReactFiberFlags.NoFlags
local ContentReset = ReactFiberFlags.ContentReset
local Placement = ReactFiberFlags.Placement
local Snapshot = ReactFiberFlags.Snapshot
local Update = ReactFiberFlags.Update
local Callback = ReactFiberFlags.Callback
local LayoutMask = ReactFiberFlags.LayoutMask
local PassiveMask = ReactFiberFlags.PassiveMask
local Ref = ReactFiberFlags.Ref
local Shared4 = require(parent.Shared)
local getComponentName = Shared4.getComponentName
local Shared5 = require(parent.Shared)
local invariant = Shared5.invariant
local Shared6 = require(parent.Shared)
local describeError = Shared6.describeError
local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)

local current = ReactCurrentFiber.current
local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber

local ReactFiberDevToolsHooknew = require(script.Parent["ReactFiberDevToolsHook.new"])
local onCommitUnmount = ReactFiberDevToolsHooknew.onCommitUnmount

local ReactFiberLazyComponentnew = require(script.Parent["ReactFiberLazyComponent.new"])
local resolveDefaultProps = ReactFiberLazyComponentnew.resolveDefaultProps
local ReactProfilerTimernew = require(script.Parent["ReactProfilerTimer.new"])
local startLayoutEffectTimer = ReactProfilerTimernew.startLayoutEffectTimer
local recordPassiveEffectDuration = ReactProfilerTimernew.recordPassiveEffectDuration
local recordLayoutEffectDuration = ReactProfilerTimernew.recordLayoutEffectDuration
local startPassiveEffectTimer = ReactProfilerTimernew.startPassiveEffectTimer
local getCommitTime = ReactProfilerTimernew.getCommitTime
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local ProfileMode = ReactTypeOfMode.ProfileMode
local commitUpdateQueue = ReactUpdateQueuenew.commitUpdateQueue
local getPublicInstance = ReactFiberHostConfig.getPublicInstance
local supportsMutation = ReactFiberHostConfig.supportsMutation

local v2 = ReactFeatureFlags.enableSkipHostSiblingLookup and ReactFiberHostConfig.supportsChildOrdering == false
local supportsPersistence = ReactFiberHostConfig.supportsPersistence
local supportsHydration = ReactFiberHostConfig.supportsHydration
local commitMount = ReactFiberHostConfig.commitMount
local commitUpdate = ReactFiberHostConfig.commitUpdate
local resetTextContent = ReactFiberHostConfig.resetTextContent
local commitTextUpdate = ReactFiberHostConfig.commitTextUpdate
local appendChild = ReactFiberHostConfig.appendChild
local appendChildToContainer = ReactFiberHostConfig.appendChildToContainer
local insertBefore = ReactFiberHostConfig.insertBefore
local insertInContainerBefore = ReactFiberHostConfig.insertInContainerBefore
local removeChild = ReactFiberHostConfig.removeChild
local removeChildFromContainer = ReactFiberHostConfig.removeChildFromContainer

local hideInstance = ReactFiberHostConfig.hideInstance
local hideTextInstance = ReactFiberHostConfig.hideTextInstance
local unhideInstance = ReactFiberHostConfig.unhideInstance
local unhideTextInstance = ReactFiberHostConfig.unhideTextInstance

local commitHydratedSuspenseInstance = ReactFiberHostConfig.commitHydratedSuspenseInstance
local clearContainer = ReactFiberHostConfig.clearContainer

local v3 = nil

local function resolveRetryWakeable(state, k)
	if not v3 then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		v3 = ReactFiberWorkLoopnew
	end

	v3.resolveRetryWakeable(state, k)
end

local function markCommitTimeOfFallback() -- 1 equivalent call inferred from this helper
	if not v3 then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		v3 = ReactFiberWorkLoopnew
	end

	v3.markCommitTimeOfFallback()
end

local function schedulePassiveEffectCallback()
	console.warn("ReactFiberCommitWork: schedulePassiveEffectCallback causes a dependency cycle\n" .. debug.traceback())
end

local function captureCommitPhaseError(_, _, message)
	console.warn("ReactFiberCommitWork: captureCommitPhaseError causes a dependency cycle")

	error(message)
end

local noFlags = ReactHookEffectTags.NoFlags
local HasEffect = ReactHookEffectTags.HasEffect
local Layout = ReactHookEffectTags.Layout
local Passive = ReactHookEffectTags.Passive

local didWarnAboutReassigningProps = nil
local function fn()
	if not didWarnAboutReassigningProps then
		local ReactFiberBeginWorknew = require(script.Parent["ReactFiberBeginWork.new"])
		didWarnAboutReassigningProps = ReactFiberBeginWorknew.didWarnAboutReassigningProps
	end

	return didWarnAboutReassigningProps
end

local isHostParent
local insertOrAppendPlacementNode
local insertOrAppendPlacementNodeIntoContainer
local commitLayoutEffectsForHostRoot
local commitLayoutEffectsForHostComponent
local commitLayoutEffectsForClassComponent
local unmountHostComponents

local v4 = nil

local function callComponentWillUnmountWithTimer(data, object)
	object.props = data.memoizedProps
	object.state = data.memoizedState

	if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(data.mode, ProfileMode) ~= 0 then
		local success, result = xpcall(function()
			startLayoutEffectTimer()

			object:componentWillUnmount()
		end, describeError)

		recordLayoutEffectDuration(data)

		if not success then
			error(result)
		end
	else
		object:componentWillUnmount()
	end
end

function safelyCallComponentWillUnmount(p, p2, p3)
	local success, result = xpcall(callComponentWillUnmountWithTimer, describeError, p, p2)

	if not success then
		captureCommitPhaseError(p, p3, result)
	end
end

local function safelyDetachRef(data, p) -- 2 equivalent calls inferred from this helper
	local ref = data.ref

	if ref ~= nil then
		if typeof(ref) == "function" then
			local success, result = xpcall(ref, describeError)

			if not success then
				captureCommitPhaseError(data, p, result)
			end
		else
			ref.current = nil
		end
	end
end

local function safelyCallDestroy(p, p2, destroy) -- 3 equivalent calls inferred from this helper
	local success, result = xpcall(destroy, describeError)

	if not success then
		captureCommitPhaseError(p, p2, result)
	end
end

local function commitHookEffectListUnmount(p, p2, p3)
	local updateQueue = p2.updateQueue
	local lastEffect

	if updateQueue ~= nil then
		lastEffect = updateQueue.lastEffect
	end

	if lastEffect ~= nil then
		local nextNode = lastEffect.next
		local v5 = nextNode

		repeat
			if bit32.band(v5.tag, p) == p then
				local destroy = v5.destroy

				if ReactFeatureFlags.enableWorkLoopTrims then
					if destroy ~= nil then
						v5.destroy = nil
					end
				else
					v5.destroy = nil
				end

				if destroy ~= nil then
					safelyCallDestroy(p2, p3, destroy) -- inferred equivalent call
				end
			end

			v5 = v5.next
		until v5 == nextNode
	end
end

local function commitHookEffectListMount(p, p2)
	local updateQueue = p2.updateQueue
	local lastEffect

	if updateQueue ~= nil then
		lastEffect = updateQueue.lastEffect
	end

	if lastEffect ~= nil then
		local nextNode = lastEffect.next
		local v5 = nextNode

		repeat
			if bit32.band(v5.tag, p) == p then
				local create = v5.create

				if ReactFeatureFlags.enableWorkLoopTrims then
					local destroy = create()

					if destroy ~= nil or v5.destroy ~= nil then
						v5.destroy = destroy
					end
				else
					v5.destroy = create()
				end

				if __DEV__ then
					local destroy = v5.destroy

					if destroy ~= nil and typeof(destroy) ~= "function" then
						local v6 = destroy == nil
							and " You returned nil. If your effect does not require clean up, return nil (or nothing)."
							or typeof(destroy.andThen) == "function"
							and "\n\nIt looks like you wrote useEffect(Promise.new(function() --[[...]] end) or returned a Promise. Instead, write the async function inside your effect and call it immediately:\n\nuseEffect(function()\n  function fetchData()\n    -- You can await here\n    local response = MyAPI.getData(someId):await()\n    -- ...\n  end\n  fetchData()\nend, {someId}) -- Or {} if effect doesn't need props or state\n\nLearn more about data fetching with Hooks: https://reactjs.org/link/hooks-data-fetching"
							or " You returned: " .. destroy

						console.error(
							"An effect function must not return anything besides a function, which is used for clean-up.%s",
							v6
						)
					end
				end
			end

			v5 = v5.next
		until v5 == nextNode
	end
end

function commitProfilerPassiveEffect(p, data)
	if enableProfilerTimer and enableProfilerCommitHooks and data.tag == Profiler then
		local passiveEffectDuration = data.stateNode.passiveEffectDuration

		local id = data.memoizedProps.id
		local onPostCommit = data.memoizedProps.onPostCommit

		local commitTime = getCommitTime()

		if typeof(onPostCommit) == "function" then
			if enableSchedulerTracing then
				onPostCommit(
					id,
					data.alternate == nil and "mount" or "update",
					passiveEffectDuration,
					commitTime,
					p.memoizedInteractions
				)
			else
				onPostCommit(id, data.alternate == nil and "mount" or "update", passiveEffectDuration, commitTime)
			end
		end
	end
end

local function recursivelyCommitLayoutEffects(data, p, callback, callback2)
	if callback ~= nil then
		captureCommitPhaseError = callback
	end

	if callback2 ~= nil then
		schedulePassiveEffectCallback = callback2
	end

	local flags = data.flags
	local tag = data.tag

	if tag == Profiler then
		local v5

		if enableProfilerTimer and enableProfilerCommitHooks then
			v5 = v4
			v4 = data
		end

		if ReactFeatureFlags.enableCommitTraversalTrims then
			local v6

			if bit32.band(data.subtreeFlags, LayoutMask) ~= NoFlags then
				v6 = data.child
			end

			while v6 ~= nil do
				if bit32.band(bit32.bor(v6.flags, v6.subtreeFlags), LayoutMask) ~= NoFlags or v6.tag == Profiler then
					if __DEV__ then
						local current2 = current
						setCurrentFiber(v6)
						invokeGuardedCallback(
							nil,
							recursivelyCommitLayoutEffects,
							nil,
							v6,
							p,
							captureCommitPhaseError,
							schedulePassiveEffectCallback
						)

						if hasCaughtError() then
							local v7 = clearCaughtError()
							captureCommitPhaseError(v6, data, v7)
						end

						if current2 == nil then
							resetCurrentFiber()
						else
							setCurrentFiber(current2)
						end
					else
						local success, result = xpcall(
							recursivelyCommitLayoutEffects,
							describeError,
							v6,
							p,
							captureCommitPhaseError,
							schedulePassiveEffectCallback
						)

						if not success then
							captureCommitPhaseError(v6, data, result)
						end
					end
				end

				v6 = v6.sibling
			end
		else
			local v6 = data.child

			while v6 ~= nil do
				if bit32.band(data.subtreeFlags, LayoutMask) ~= NoFlags then
					if __DEV__ then
						local current2 = current
						setCurrentFiber(v6)
						invokeGuardedCallback(
							nil,
							recursivelyCommitLayoutEffects,
							nil,
							v6,
							p,
							captureCommitPhaseError,
							schedulePassiveEffectCallback
						)

						if hasCaughtError() then
							local v7 = clearCaughtError()
							captureCommitPhaseError(v6, data, v7)
						end

						if current2 == nil then
							resetCurrentFiber()
						else
							setCurrentFiber(current2)
						end
					else
						local success, result = xpcall(
							recursivelyCommitLayoutEffects,
							describeError,
							v6,
							p,
							captureCommitPhaseError,
							schedulePassiveEffectCallback
						)

						if not success then
							captureCommitPhaseError(v6, data, result)
						end
					end
				end

				v6 = v6.sibling
			end
		end

		if bit32.band(flags, (bit32.bor(Update, Callback))) ~= NoFlags and enableProfilerTimer then
			if __DEV__ then
				local current2 = current
				setCurrentFiber(data)
				invokeGuardedCallback(nil, commitLayoutEffectsForProfiler, nil, data, p)

				if hasCaughtError() then
					local v6 = clearCaughtError()
					captureCommitPhaseError(data, data.return_, v6)
				end

				if current2 == nil then
					resetCurrentFiber()
				else
					setCurrentFiber(current2)
				end
			else
				local success, result = xpcall(commitLayoutEffectsForProfiler, describeError, data, p)

				if not success then
					captureCommitPhaseError(data, data.return_, result)
				end
			end
		end

		if enableProfilerTimer and enableProfilerCommitHooks then
			if v5 ~= nil then
				v5.stateNode.effectDuration += data.stateNode.effectDuration
			end

			v4 = v5
		end
	else
		if ReactFeatureFlags.enableCommitTraversalTrims then
			local v5

			if bit32.band(data.subtreeFlags, LayoutMask) ~= NoFlags then
				v5 = data.child
			end

			while v5 ~= nil do
				if bit32.band(bit32.bor(v5.flags, v5.subtreeFlags), LayoutMask) ~= NoFlags or v5.tag == Profiler then
					if __DEV__ then
						local current2 = ReactCurrentFiber.current
						setCurrentFiber(v5)

						if v < 20 then
							v += 1
							invokeGuardedCallback(
								nil,
								recursivelyCommitLayoutEffects,
								nil,
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)

							v -= 1

							if hasCaughtError() then
								local v6 = clearCaughtError()
								captureCommitPhaseError(v5, data, v6)
							end
						else
							recursivelyCommitLayoutEffects(
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)
						end

						if current2 == nil then
							resetCurrentFiber()
						else
							setCurrentFiber(current2)
						end
					else
						local result = nil
						local success

						if __YOLO__ or not (v < 20) then
							recursivelyCommitLayoutEffects(
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)
							success = true
						else
							v += 1

							success, result = xpcall(
								recursivelyCommitLayoutEffects,
								describeError,
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)

							v -= 1
						end

						if not success then
							captureCommitPhaseError(v5, data, result)
						end
					end
				end

				v5 = v5.sibling
			end
		else
			local v5 = data.child

			while v5 ~= nil do
				if bit32.band(data.subtreeFlags, LayoutMask) ~= NoFlags then
					if __DEV__ then
						local current2 = ReactCurrentFiber.current
						setCurrentFiber(v5)

						if v < 20 then
							v += 1
							invokeGuardedCallback(
								nil,
								recursivelyCommitLayoutEffects,
								nil,
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)

							v -= 1

							if hasCaughtError() then
								local v6 = clearCaughtError()
								captureCommitPhaseError(v5, data, v6)
							end
						else
							recursivelyCommitLayoutEffects(
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)
						end

						if current2 == nil then
							resetCurrentFiber()
						else
							setCurrentFiber(current2)
						end
					else
						local result = nil
						local success

						if __YOLO__ or not (v < 20) then
							recursivelyCommitLayoutEffects(
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)
							success = true
						else
							v += 1

							success, result = xpcall(
								recursivelyCommitLayoutEffects,
								describeError,
								v5,
								p,
								captureCommitPhaseError,
								schedulePassiveEffectCallback
							)

							v -= 1
						end

						if not success then
							captureCommitPhaseError(v5, data, result)
						end
					end
				end

				v5 = v5.sibling
			end
		end

		if bit32.band(flags, (bit32.bor(Update, Callback))) ~= NoFlags then
			if tag == FunctionComponent or tag == ForwardRef or tag == SimpleMemoComponent or tag == Block then
				if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(data.mode, ProfileMode) ~= 0 then
					local success, result = xpcall(function()
						startLayoutEffectTimer()
						commitHookEffectListMount(bit32.bor(Layout, HasEffect), data)
					end, describeError)

					recordLayoutEffectDuration(data)

					if not success then
						error(result)
					end
				else
					commitHookEffectListMount(bit32.bor(Layout, HasEffect), data)
				end

				if bit32.band(data.subtreeFlags, PassiveMask) ~= NoFlags then
					schedulePassiveEffectCallback()
				end
			elseif tag == ClassComponent then
				commitLayoutEffectsForClassComponent(data)
			elseif tag == HostRoot then
				commitLayoutEffectsForHostRoot(data)
			elseif tag == HostComponent then
				commitLayoutEffectsForHostComponent(data)
			elseif tag == SuspenseComponent then
				commitSuspenseHydrationCallbacks(p, data)
			elseif
				tag ~= FundamentalComponent
				and tag ~= HostPortal
				and tag ~= HostText
				and tag ~= IncompleteClassComponent
				and tag ~= LegacyHiddenComponent
				and tag ~= OffscreenComponent
				and tag ~= ScopeComponent
				and tag ~= SuspenseListComponent
			then
				invariant(
					false,
					"This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue."
				)
			end
		end

		if bit32.band(flags, Ref) ~= 0 then
			commitAttachRef(data)
		end
	end
end

function commitLayoutEffectsForProfiler(data, p)
	if enableProfilerTimer then
		local flags = data.flags
		local alternate = data.alternate

		local onCommit = data.memoizedProps.onCommit
		local onRender = data.memoizedProps.onRender
		local effectDuration = data.stateNode.effectDuration

		local commitTime = getCommitTime()

		if bit32.band(flags, Update) ~= NoFlags and isCallable(onRender) then -- inferred equivalent call
			if enableSchedulerTracing then
				onRender(
					data.memoizedProps.id,
					alternate == nil and "mount" or "update",
					data.actualDuration,
					data.treeBaseDuration,
					data.actualStartTime,
					commitTime,
					p.memoizedInteractions
				)
			else
				onRender(
					data.memoizedProps.id,
					alternate == nil and "mount" or "update",
					data.actualDuration,
					data.treeBaseDuration,
					data.actualStartTime,
					commitTime
				)
			end
		end

		if enableProfilerCommitHooks and bit32.band(flags, Callback) ~= NoFlags and isCallable(onCommit) then -- inferred equivalent call
			if enableSchedulerTracing then
				onCommit(
					data.memoizedProps.id,
					alternate == nil and "mount" or "update",
					effectDuration,
					commitTime,
					p.memoizedInteractions
				)
			else
				onCommit(data.memoizedProps.id, alternate == nil and "mount" or "update", effectDuration, commitTime)
			end
		end
	end
end

commitLayoutEffectsForClassComponent = function(data)
	local stateNode = data.stateNode
	local alternate = data.alternate

	if bit32.band(data.flags, Update) ~= 0 then
		if alternate == nil then
			if __DEV__ and data.type == data.elementType and not fn then
				if stateNode.props ~= data.memoizedProps then
					console.error(
						"Expected %s props to match memoized props before componentDidMount. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end

				if stateNode.state ~= data.memoizedState then
					console.error(
						"Expected %s state to match memoized state before componentDidMount. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end
			end

			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(data.mode, ProfileMode) ~= 0 then
				local success, result = xpcall(function()
					startLayoutEffectTimer()

					stateNode:componentDidMount()
				end, describeError)

				recordLayoutEffectDuration(data)

				if not success then
					error(result)
				end
			else
				stateNode:componentDidMount()
			end
		else
			local memoizedProps = data.elementType == data.type and alternate.memoizedProps
				or resolveDefaultProps(data.type, alternate.memoizedProps)
			local memoizedState = alternate.memoizedState

			if __DEV__ and data.type == data.elementType and not fn then
				if stateNode.props ~= data.memoizedProps then
					console.error(
						"Expected %s props to match memoized props before componentDidUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end

				if stateNode.state ~= data.memoizedState then
					console.error(
						"Expected %s state to match memoized state before componentDidUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end
			end

			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(data.mode, ProfileMode) ~= 0 then
				local success, result = xpcall(function()
					startLayoutEffectTimer()

					stateNode:componentDidUpdate(
						memoizedProps,
						memoizedState,
						stateNode.__reactInternalSnapshotBeforeUpdate
					)
				end, describeError)

				recordLayoutEffectDuration(data)

				if not success then
					error(result)
				end
			else
				stateNode:componentDidUpdate(
					memoizedProps,
					memoizedState,
					stateNode.__reactInternalSnapshotBeforeUpdate
				)
			end
		end
	end

	local updateQueue = data.updateQueue

	if updateQueue ~= nil then
		if __DEV__ and data.type == data.elementType and not fn then
			if stateNode.props ~= data.memoizedProps then
				console.error(
					"Expected %s props to match memoized props before processing the update queue. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.",
					getComponentName(data.type) or "instance"
				)
			end

			if stateNode.state ~= data.memoizedState then
				console.error(
					"Expected %s state to match memoized state before processing the update queue. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.",
					getComponentName(data.type) or "instance"
				)
			end
		end

		commitUpdateQueue(data, updateQueue, stateNode)
	end
end

commitLayoutEffectsForHostRoot = function(data)
	local updateQueue = data.updateQueue

	if updateQueue ~= nil then
		local v5 = nil

		if data.child ~= nil then
			local child = data.child

			if child.tag == HostComponent then
				v5 = getPublicInstance(child.stateNode)
			elseif child.tag == ClassComponent then
				v5 = child.stateNode
			end
		end

		commitUpdateQueue(data, updateQueue, v5)
	end
end

commitLayoutEffectsForHostComponent = function(data)
	local stateNode = data.stateNode

	if data.alternate == nil and bit32.band(data.flags, Update) ~= 0 then
		commitMount(stateNode, data.type, data.memoizedProps, data)
	end
end

local function hideOrUnhideAllChildren(p, p2)
	-- [TOVEK] Lenient mode required for this code
	-- The code below is rebuilt as a state machine
	-- due to not being representable otherwise
	local stateNode, stateNode2, return_
	local controlFlowState = 21

	while controlFlowState ~= 0 do
		if controlFlowState == 1 then
			stateNode = return_.stateNode
			controlFlowState = if p2 then 3 else 4
		elseif controlFlowState == 2 then
			if return_.tag == HostText then
				controlFlowState = 6
			else
				controlFlowState = 7
			end
		elseif controlFlowState == 3 then
			hideInstance(stateNode)
			controlFlowState = 5
		elseif controlFlowState == 4 then
			unhideInstance(return_.stateNode, return_.memoizedProps)
			controlFlowState = 5
		elseif controlFlowState == 5 then
			if return_ == p then
				controlFlowState = 14
			else
				controlFlowState = 11
			end
		elseif controlFlowState == 6 then
			stateNode2 = return_.stateNode
			controlFlowState = if p2 then 8 else 9
		elseif controlFlowState == 7 then
			if
				(return_.tag == OffscreenComponent or return_.tag == LegacyHiddenComponent)
				and return_.memoizedState ~= nil
				and return_ ~= p
				or return_.child == nil
			then
				controlFlowState = 5
			else
				controlFlowState = 12
			end
		elseif controlFlowState == 8 then
			hideTextInstance(stateNode2)
			controlFlowState = 5
		elseif controlFlowState == 9 then
			unhideTextInstance(stateNode2, return_.memoizedProps)
			controlFlowState = 5
		elseif controlFlowState == 10 then
			return_ = p
			controlFlowState = 20
		else
			if controlFlowState == 11 then
				controlFlowState = 15
				continue
			end

			if controlFlowState == 12 then
				return_.child.return_ = return_
				return_ = return_.child
				controlFlowState = 13
			else
				if controlFlowState == 13 then
					controlFlowState = 20
					continue
				end

				if controlFlowState == 14 then
					break
				end

				if controlFlowState == 15 then
					if return_.sibling == nil then
						controlFlowState = 16
					else
						controlFlowState = 17
					end
				elseif controlFlowState == 16 then
					if return_.return_ == nil or return_.return_ == p then
						controlFlowState = 18
					else
						controlFlowState = 19
					end
				elseif controlFlowState == 17 then
					return_.sibling.return_ = return_.return_

					return_ = return_.sibling
					controlFlowState = 13
				else
					if controlFlowState == 18 then
						break
					end

					if controlFlowState == 19 then
						return_ = return_.return_
						controlFlowState = 15
					elseif controlFlowState == 20 then
						if return_.tag == HostComponent then
							controlFlowState = 1
						else
							controlFlowState = 2
						end
					else
						if controlFlowState ~= 21 then
							break
						end

						if supportsMutation then
							controlFlowState = 10
						else
							controlFlowState = 0
						end
					end
				end
			end
		end

		continue
	end
end

function commitAttachRef(data)
	local ref = data.ref

	if ref ~= nil then
		local stateNode = data.stateNode

		if data.tag == HostComponent then
			stateNode = getPublicInstance(stateNode)
		end

		if typeof(ref) == "function" then
			ref(stateNode)
		elseif __DEV__ and typeof(ref) ~= "table" then
			console.error(
				"Unexpected ref object provided for %s. Use either a ref-setter function or React.createRef().",
				getComponentName(data.type) or "instance"
			)
		else
			ref.current = stateNode
		end
	end
end

function commitDetachRef(p)
	local ref = p.ref

	if ref ~= nil then
		if typeof(ref) == "function" then
			ref(nil)
		else
			ref.current = nil
		end
	end
end

local function commitUnmount(p, data, p2, p3)
	onCommitUnmount(data)

	if
		data.tag == FunctionComponent
		or data.tag == ForwardRef
		or data.tag == MemoComponent
		or data.tag == SimpleMemoComponent
		or data.tag == Block
	then
		local updateQueue = data.updateQueue

		if updateQueue ~= nil then
			local lastEffect = updateQueue.lastEffect

			if lastEffect ~= nil then
				local nextNode = lastEffect.next
				local v5 = nextNode

				repeat
					if v5.destroy ~= nil and bit32.band(v5.tag, Layout) ~= noFlags then
						if
							enableProfilerTimer
							and enableProfilerCommitHooks
							and bit32.band(data.mode, ProfileMode) ~= 0
						then
							startLayoutEffectTimer()

							safelyCallDestroy(data, p2, v5.destroy) -- inferred equivalent call

							recordLayoutEffectDuration(data)
						else
							safelyCallDestroy(data, p2, v5.destroy) -- inferred equivalent call
						end
					end

					v5 = v5.next
				until v5 == nextNode
			end
		end
	elseif data.tag == ClassComponent then
		safelyDetachRef(data, p2) -- inferred equivalent call
		local stateNode = data.stateNode

		if typeof(stateNode.componentWillUnmount) == "function" then
			safelyCallComponentWillUnmount(data, stateNode, p2)
		end
	elseif data.tag == HostComponent then
		safelyDetachRef(data, p2) -- inferred equivalent call
	else
		if data.tag ~= HostPortal then
			return
		end

		if supportsMutation then
			unmountHostComponents(p, data, p2, p3)
		elseif supportsPersistence then
			unimplemented("emptyPortalContainer")
		end
	end
end

local function commitNestedUnmounts(p, p2, p3, p4)
	local return_ = p2

	while true do
		commitUnmount(p, return_, p3, p4)

		if return_.child == nil or supportsMutation and return_.tag == HostPortal then
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

local function detachFiberMutation(p) -- 2 equivalent calls inferred from this helper
	local alternate = p.alternate

	if alternate ~= nil then
		alternate.return_ = nil

		if not enableNewTreeCleanupPath then
			p.alternate = nil
		end
	end

	p.return_ = nil
end

local function getHostParentFiber(p)
	local return_ = p.return_

	while return_ ~= nil do
		if isHostParent(return_) then
			return return_
		end

		return_ = return_.return_
	end

	error(Error.new("Expected to find a host parent. This error is likely caused by a bug in React. Please file an issue."))
end

isHostParent = function(return_): boolean
	return return_.tag == HostComponent or return_.tag == HostRoot or return_.tag == HostPortal
end

local function getHostSibling(return_)
	while true do
		local v5 = false

		while return_.sibling == nil do
			if return_.return_ == nil or isHostParent(return_.return_) then
				return nil
			end

			return_ = return_.return_
		end

		return_.sibling.return_ = return_.return_
		return_ = return_.sibling

		while return_.tag ~= HostComponent and return_.tag ~= HostText and return_.tag ~= DehydratedFragment do
			if bit32.band(return_.flags, Placement) == 0 and return_.child ~= nil and return_.tag ~= HostPortal then
				return_.child.return_ = return_
				return_ = return_.child
			else
				v5 = true
				break
			end
		end

		if not v5 and bit32.band(return_.flags, Placement) == 0 then
			return return_.stateNode
		end
	end
end

local function commitPlacement(p)
	if not supportsMutation then
		return
	end

	local hostParentFiber = getHostParentFiber(p)

	local v5 = nil
	local flag = nil
	local stateNode = hostParentFiber.stateNode

	if hostParentFiber.tag == HostComponent then
		v5 = stateNode
		flag = false
	elseif hostParentFiber.tag == HostRoot then
		v5 = stateNode.containerInfo
		flag = true
	elseif hostParentFiber.tag == HostPortal then
		v5 = stateNode.containerInfo
		flag = true
	else
		invariant(
			false,
			"Invalid host parent fiber. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	if bit32.band(hostParentFiber.flags, ContentReset) ~= 0 then
		resetTextContent(v5)

		hostParentFiber.flags = bit32.band(hostParentFiber.flags, (bit32.bnot(ContentReset)))
	end

	local v6

	if not v2 then
		v6 = getHostSibling(p)
	end

	if flag then
		insertOrAppendPlacementNodeIntoContainer(p, v6, v5)
	else
		insertOrAppendPlacementNode(p, v6, v5)
	end
end

insertOrAppendPlacementNodeIntoContainer = function(data, p, p2)
	local tag = data.tag

	if tag == HostComponent or tag == HostText then
		local stateNode = data.stateNode

		if p then
			insertInContainerBefore(p2, stateNode, p)
		else
			appendChildToContainer(p2, stateNode)
		end
	else
		if tag == HostPortal then
			return
		end

		local child = data.child

		if child ~= nil then
			insertOrAppendPlacementNodeIntoContainer(child, p, p2)
			local sibling = child.sibling

			while sibling ~= nil do
				insertOrAppendPlacementNodeIntoContainer(sibling, p, p2)
				sibling = sibling.sibling
			end
		end
	end
end

insertOrAppendPlacementNode = function(data, p, p2)
	local tag = data.tag

	if tag == HostComponent or tag == HostText then
		local stateNode = data.stateNode

		if p then
			insertBefore(p2, stateNode, p)
		else
			appendChild(p2, stateNode)
		end
	else
		if tag == HostPortal then
			return
		end

		local child = data.child

		if child ~= nil then
			insertOrAppendPlacementNode(child, p, p2)
			local sibling = child.sibling

			while sibling ~= nil do
				insertOrAppendPlacementNode(sibling, p, p2)
				sibling = sibling.sibling
			end
		end
	end
end

unmountHostComponents = function(p, p2, p3, p4)
	-- [TOVEK] Lenient mode required for this code
	-- The code below is rebuilt as a state machine
	-- due to not being representable otherwise
	local return_, flag, return_2, flag2, v5
	local controlFlowState = 34

	while true do
		if controlFlowState == 0 then
			controlFlowState = 32
			continue
		end

		if controlFlowState == 1 then
			return_ = return_2.return_
			controlFlowState = 12
		elseif controlFlowState == 2 then
			if return_2.tag == HostComponent or return_2.tag == HostText then
				controlFlowState = 14
			else
				controlFlowState = 15
			end
		elseif controlFlowState == 3 then
			error(Error.new("Expected to find a host parent. This error is likely caused by a bug in React. Please file an issue."))
			controlFlowState = 4
		elseif controlFlowState == 4 then
			v5 = return_.stateNode

			if return_.tag == HostComponent then
				controlFlowState = 5
			else
				controlFlowState = 6
			end
		elseif controlFlowState == 5 then
			flag2 = false
			controlFlowState = 7
		elseif controlFlowState == 6 then
			if return_.tag == HostRoot then
				controlFlowState = 8
			else
				controlFlowState = 9
			end
		elseif controlFlowState == 7 then
			flag = true
			controlFlowState = 2
		elseif controlFlowState == 8 then
			v5 = v5.containerInfo
			flag2 = true
			controlFlowState = 7
		elseif controlFlowState == 9 then
			if return_.tag == HostPortal then
				controlFlowState = 10
			else
				controlFlowState = 11
			end
		elseif controlFlowState == 10 then
			v5 = v5.containerInfo
			flag2 = true
			controlFlowState = 7
		elseif controlFlowState == 11 then
			return_ = return_.return_
			controlFlowState = 12
		elseif controlFlowState == 12 then
			if return_ == nil then
				controlFlowState = 3
			else
				controlFlowState = 4
			end
		else
			if controlFlowState == 13 then
				controlFlowState = 25
				continue
			end

			if controlFlowState == 14 then
				commitNestedUnmounts(p, return_2, p3, p4)

				if flag2 then
					controlFlowState = 16
				else
					controlFlowState = 17
				end
			elseif controlFlowState == 15 then
				if return_2.tag == HostPortal then
					controlFlowState = 19
				else
					controlFlowState = 20
				end
			elseif controlFlowState == 16 then
				removeChildFromContainer(v5, return_2.stateNode)
				controlFlowState = 18
			elseif controlFlowState == 17 then
				removeChild(v5, return_2.stateNode)
				controlFlowState = 18
			elseif controlFlowState == 18 then
				if return_2 == p2 then
					controlFlowState = 24
				else
					controlFlowState = 13
				end
			elseif controlFlowState == 19 then
				if return_2.child == nil then
					controlFlowState = 18
				else
					controlFlowState = 21
				end
			elseif controlFlowState == 20 then
				commitUnmount(p, return_2, p3, p4)

				if return_2.child == nil then
					controlFlowState = 18
				else
					controlFlowState = 23
				end
			elseif controlFlowState == 21 then
				v5 = return_2.stateNode.containerInfo

				return_2.child.return_ = return_2
				return_2 = return_2.child
				flag2 = true
				controlFlowState = 22
			else
				if controlFlowState == 22 then
					controlFlowState = 33
					continue
				end

				if controlFlowState == 23 then
					return_2.child.return_ = return_2
					return_2 = return_2.child
					controlFlowState = 22
				else
					if controlFlowState == 24 then
						break
					end

					if controlFlowState == 25 then
						if return_2.sibling == nil then
							controlFlowState = 26
						else
							controlFlowState = 27
						end
					elseif controlFlowState == 26 then
						if return_2.return_ == nil or return_2.return_ == p2 then
							controlFlowState = 29
						else
							controlFlowState = 30
						end
					elseif controlFlowState == 27 then
						return_2.sibling.return_ = return_2.return_
						return_2 = return_2.sibling
						controlFlowState = 22
					elseif controlFlowState == 28 then
						flag = false
						controlFlowState = 32
					else
						if controlFlowState == 29 then
							break
						end

						if controlFlowState == 30 then
							return_2 = return_2.return_

							if return_2.tag == HostPortal then
								controlFlowState = 28
							else
								controlFlowState = 0
							end
						else
							if controlFlowState == 31 then
								controlFlowState = 2
								continue
							end

							if controlFlowState == 32 then
								controlFlowState = 25
								continue
							end

							if controlFlowState == 33 then
								if flag then
									controlFlowState = 31
								else
									controlFlowState = 1
								end
							else
								if controlFlowState ~= 34 then
									break
								end

								return_2 = p2
								flag = false
								flag2 = nil
								v5 = nil
								controlFlowState = 33
							end
						end
					end
				end
			end
		end

		continue
	end
end

local function commitDeletion(p, p2, p3, p4)
	unmountHostComponents(p, p2, p3, p4)
	local alternate

	if not enableNewTreeCleanupPath then
		alternate = p2.alternate
	end

	detachFiberMutation(p2) -- inferred equivalent call

	if not enableNewTreeCleanupPath and alternate ~= nil then
		detachFiberMutation(alternate) -- inferred equivalent call
	end
end

function commitSuspenseComponent(data)
	local memoizedState = data.memoizedState

	if memoizedState ~= nil then
		markCommitTimeOfFallback() -- inferred equivalent call

		if supportsMutation then
			hideOrUnhideAllChildren(data.child, true)
		end
	end

	if enableSuspenseCallback and memoizedState ~= nil then
		local suspenseCallback = data.memoizedProps.suspenseCallback

		if typeof(suspenseCallback) == "function" then
			local updateQueue = data.updateQueue

			if updateQueue ~= nil then
				suspenseCallback(table.clone(updateQueue))
			end
		elseif __DEV__ and suspenseCallback ~= nil then
			console.error("Unexpected type for suspenseCallback: %s", (tostring(suspenseCallback)))
		end
	end
end

function commitSuspenseHydrationCallbacks(p, p2)
	if not supportsHydration then
		return
	end

	if p2.memoizedState == nil then
		local alternate = p2.alternate

		if alternate ~= nil then
			local memoizedState = alternate.memoizedState

			if memoizedState ~= nil then
				local dehydrated = memoizedState.dehydrated

				if dehydrated ~= nil then
					commitHydratedSuspenseInstance(dehydrated)

					if enableSuspenseCallback then
						local hydrationCallbacks = p.hydrationCallbacks

						local onHydrated = hydrationCallbacks ~= nil and hydrationCallbacks.onHydrated

						if onHydrated then
							onHydrated(dehydrated)
						end
					end
				end
			end
		end
	end
end

function attachSuspenseRetryListeners(state)
	local updateQueue = state.updateQueue

	if updateQueue ~= nil then
		state.updateQueue = nil
		local stateNode = state.stateNode

		if stateNode == nil then
			state.stateNode = Set.new()
			stateNode = state.stateNode
		end

		for k, _ in updateQueue do
			local function fn2()
				return resolveRetryWakeable(state, k)
			end

			if stateNode:has(k) then
				continue
			end

			if enableSchedulerTracing and k.__reactDoNotTraceInteractions ~= true then
				fn2 = unstable_wrap(fn2)
			end

			stateNode:add(k)
			k:andThen(function()
				return fn2()
			end, function()
				return fn2()
			end)
		end
	end
end

function isSuspenseBoundaryBeingHidden(p, p2): boolean
	if p == nil then
		return false
	end

	local memoizedState = p.memoizedState

	if memoizedState == nil or memoizedState.dehydrated ~= nil then
		local memoizedState2 = p2.memoizedState
		return memoizedState2 ~= nil and memoizedState2.dehydrated == nil
	end

	return false
end

function commitResetTextContent(p)
	if not supportsMutation then
		return
	end

	resetTextContent(p.stateNode)
end

function invokeLayoutEffectMountInDEV(data)
	if __DEV__ and enableDoubleInvokingEffects then
		if
			data.tag == FunctionComponent
			or data.tag == ForwardRef
			or data.tag == SimpleMemoComponent
			or data.tag == Block
		then
			invokeGuardedCallback(nil, commitHookEffectListMount, nil, bit32.bor(Layout, HasEffect), data)

			if hasCaughtError() then
				local v5 = clearCaughtError()
				captureCommitPhaseError(data, data.return_, v5)
			end
		end
	elseif data.tag == ClassComponent then
		local stateNode = data.stateNode
		invokeGuardedCallback(nil, stateNode.componentDidMount, stateNode)

		if hasCaughtError() then
			local v5 = clearCaughtError()
			captureCommitPhaseError(data, data.return_, v5)
		end
	end
end

function invokePassiveEffectMountInDEV(p)
	if
		not __DEV__
		or not enableDoubleInvokingEffects
		or p.tag ~= FunctionComponent and p.tag ~= ForwardRef and p.tag ~= SimpleMemoComponent and p.tag ~= Block
	then
		return
	end

	invokeGuardedCallback(nil, commitHookEffectListMount, nil, bit32.bor(Passive, HasEffect), p)

	if hasCaughtError() then
		local v5 = clearCaughtError()
		captureCommitPhaseError(p, p.return_, v5)
	end
end

function invokeLayoutEffectUnmountInDEV(data)
	if __DEV__ and enableDoubleInvokingEffects then
		if
			data.tag == FunctionComponent
			or data.tag == ForwardRef
			or data.tag == SimpleMemoComponent
			or data.tag == Block
		then
			invokeGuardedCallback(
				nil,
				commitHookEffectListUnmount,
				nil,
				bit32.bor(Layout, HasEffect),
				data,
				data.return_
			)

			if hasCaughtError() then
				local v5 = clearCaughtError()
				captureCommitPhaseError(data, data.return_, v5)
			end
		end
	elseif data.tag == ClassComponent then
		local stateNode = data.stateNode

		if typeof(stateNode.componentWillUnmount) == "function" then
			safelyCallComponentWillUnmount(data, stateNode, data.return_)
		end
	end
end

function invokePassiveEffectUnmountInDEV(p)
	if
		not __DEV__
		or not enableDoubleInvokingEffects
		or p.tag ~= FunctionComponent and p.tag ~= ForwardRef and p.tag ~= SimpleMemoComponent and p.tag ~= Block
	then
		return
	end

	invokeGuardedCallback(nil, commitHookEffectListUnmount, nil, bit32.bor(Passive, HasEffect), p, p.return_)

	if hasCaughtError() then
		local v5 = clearCaughtError()
		captureCommitPhaseError(p, p.return_, v5)
	end
end

local New = {}
New.safelyCallDestroy = safelyCallDestroy

function New.commitBeforeMutationLifeCycles(p, data)
	if
		data.tag == FunctionComponent
		or data.tag == ForwardRef
		or data.tag == SimpleMemoComponent
		or data.tag == Block
	then
		return
	end

	if data.tag == ClassComponent then
		if bit32.band(data.flags, Snapshot) ~= 0 and p ~= nil then
			local memoizedProps = p.memoizedProps
			local memoizedState = p.memoizedState
			local stateNode = data.stateNode

			if __DEV__ and data.type == data.elementType and not fn then
				if stateNode.props ~= data.memoizedProps then
					console.error(
						"Expected %s props to match memoized props before getSnapshotBeforeUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end

				if stateNode.state ~= data.memoizedState then
					console.error(
						"Expected %s state to match memoized state before getSnapshotBeforeUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.",
						getComponentName(data.type) or "instance"
					)
				end
			end

			stateNode.__reactInternalSnapshotBeforeUpdate = stateNode:getSnapshotBeforeUpdate(
				data.elementType == data.type and memoizedProps or resolveDefaultProps(data.type, memoizedProps),
				memoizedState
			)
		end
	elseif data.tag == HostRoot then
		if supportsMutation and bit32.band(data.flags, Snapshot) ~= 0 then
			clearContainer(data.stateNode.containerInfo)
		end
	else
		if
			data.tag == HostComponent
			or data.tag == HostText
			or data.tag == HostPortal
			or data.tag == IncompleteClassComponent
		then
			return
		end

		invariant(
			false,
			"This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue."
		)
	end
end

New.commitResetTextContent = commitResetTextContent
New.commitPlacement = commitPlacement
New.commitDeletion = commitDeletion

function New.commitWork(p, state)
	if
		state.tag == FunctionComponent
		or state.tag == ForwardRef
		or state.tag == MemoComponent
		or state.tag == SimpleMemoComponent
		or state.tag == Block
	then
		if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(state.mode, ProfileMode) ~= 0 then
			local success, result = xpcall(function()
				startLayoutEffectTimer()
				commitHookEffectListUnmount(bit32.bor(Layout, HasEffect), state, state.return_)
			end, describeError)

			recordLayoutEffectDuration(state)

			if not success then
				error(result)
			end
		else
			commitHookEffectListUnmount(bit32.bor(Layout, HasEffect), state, state.return_)
		end
	else
		if state.tag == ClassComponent then
			return
		end

		if state.tag == HostComponent then
			local stateNode = state.stateNode

			if stateNode ~= nil then
				local memoizedProps = state.memoizedProps

				local v5 = if p then p.memoizedProps else memoizedProps

				local kind = state.type

				local updateQueue = state.updateQueue
				state.updateQueue = nil

				if updateQueue ~= nil then
					commitUpdate(stateNode, updateQueue, kind, v5, memoizedProps, state)
				end
			end
		elseif state.tag == HostText then
			invariant(
				state.stateNode ~= nil,
				"This should have a text node initialized. This error is likely caused by a bug in React. Please file an issue."
			)

			local stateNode = state.stateNode
			local memoizedProps = state.memoizedProps
			local v5

			if p ~= nil then
				local _memoizedProps = p.memoizedProps
				v5 = memoizedProps
			end

			commitTextUpdate(stateNode, v5, memoizedProps)
		elseif state.tag == HostRoot then
			if supportsHydration then
				local stateNode = state.stateNode

				if stateNode.hydrate then
					stateNode.hydrate = false
					unimplemented("commitWork: HostRoot: commitHydratedContainer")
				end
			end
		else
			if state.tag == Profiler then
				return
			end

			if state.tag == SuspenseComponent then
				commitSuspenseComponent(state)
				attachSuspenseRetryListeners(state)
			else
				if state.tag == SuspenseListComponent then
					unimplemented("commitWork: SuspenseListComponent")
				else
					if state.tag == IncompleteClassComponent then
						return
					end

					if state.tag == OffscreenComponent or state.tag == LegacyHiddenComponent then
						hideOrUnhideAllChildren(state, state.memoizedState ~= nil)
						return
					end
				end

				invariant(
					false,
					"This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue."
				)
			end
		end
	end
end

New.commitAttachRef = commitAttachRef
New.commitDetachRef = commitDetachRef

function New.commitPassiveUnmount(data)
	if
		data.tag == FunctionComponent
		or data.tag == ForwardRef
		or data.tag == SimpleMemoComponent
		or data.tag == Block
	then
		if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(data.mode, ProfileMode) ~= 0 then
			startPassiveEffectTimer()
			commitHookEffectListUnmount(bit32.bor(Passive, HasEffect), data, data.return_)

			recordPassiveEffectDuration(data)
		else
			commitHookEffectListUnmount(bit32.bor(Passive, HasEffect), data, data.return_)
		end
	end
end

function New.commitPassiveUnmountInsideDeletedTree(p, p2)
	if p.tag == FunctionComponent or p.tag == ForwardRef or p.tag == SimpleMemoComponent or p.tag == Block then
		if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p.mode, ProfileMode) ~= 0 then
			startPassiveEffectTimer()
			commitHookEffectListUnmount(Passive, p, p2)
			recordPassiveEffectDuration(p)
		else
			commitHookEffectListUnmount(Passive, p, p2)
		end
	end
end

function New.commitPassiveMount(p, p2)
	if p2.tag == FunctionComponent or p2.tag == ForwardRef or p2.tag == SimpleMemoComponent or p2.tag == Block then
		if not enableProfilerTimer or not enableProfilerCommitHooks or bit32.band(p2.mode, ProfileMode) == 0 then
			commitHookEffectListMount(bit32.bor(Passive, HasEffect), p2)
			return
		end

		startPassiveEffectTimer()

		local success, result = xpcall(commitHookEffectListMount, describeError, bit32.bor(Passive, HasEffect), p2)

		recordPassiveEffectDuration(p2)

		if not success then
			error(result)
		end
	elseif p2.tag == Profiler then
		commitProfilerPassiveEffect(p, p2)
	end
end

New.invokeLayoutEffectMountInDEV = invokeLayoutEffectMountInDEV
New.invokeLayoutEffectUnmountInDEV = invokeLayoutEffectUnmountInDEV
New.invokePassiveEffectMountInDEV = invokePassiveEffectMountInDEV
New.invokePassiveEffectUnmountInDEV = invokePassiveEffectUnmountInDEV
New.isSuspenseBoundaryBeingHidden = isSuspenseBoundaryBeingHidden
New.recursivelyCommitLayoutEffects = recursivelyCommitLayoutEffects
return New
