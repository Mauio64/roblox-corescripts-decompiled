local function unimplemented(s1: string) -- line: 11
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(s1))
	error("FIXME (roblox): " .. s1 .. " is unimplemented", 2)
end

local n1 = 0

local function isCallable(p1) -- line: 25
	if typeof(p1) == "function" then
		return true
	end

	if typeof(p1) == "table" then
		local mt = getmetatable(p1)

		if mt and rawget(mt, "__call") then
			return true
		end

		if p1._isMockFunction then
			return true
		end
	end

	return false
end

local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set
local __DEV__ = ReactGlobals.__DEV__
local __YOLO__ = ReactGlobals.__YOLO__
local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactInternalTypes)
require(script.Parent["ReactFiberSuspenseComponent.new"])

local lib = require(script.Parent["ReactUpdateQueue.new"])

require(ParentParent.Shared)
require(script.Parent.ReactFiberOffscreenComponent)

local ReactHookEffectTags = require(script.Parent.ReactHookEffectTags)
local unstable_wrap = require(ParentParent.Scheduler).tracing.unstable_wrap
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
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
local ReactErrorUtils = require(ParentParent.Shared).ReactErrorUtils
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
local getComponentName = require(ParentParent.Shared).getComponentName
local invariant = require(ParentParent.Shared).invariant
local describeError = require(ParentParent.Shared).describeError
local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)
local current = ReactCurrentFiber.current
local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber
local onCommitUnmount = require(script.Parent["ReactFiberDevToolsHook.new"]).onCommitUnmount
local resolveDefaultProps = require(script.Parent["ReactFiberLazyComponent.new"]).resolveDefaultProps
local lib2 = require(script.Parent["ReactProfilerTimer.new"])
local startLayoutEffectTimer = lib2.startLayoutEffectTimer
local recordPassiveEffectDuration = lib2.recordPassiveEffectDuration
local recordLayoutEffectDuration = lib2.recordLayoutEffectDuration
local startPassiveEffectTimer = lib2.startPassiveEffectTimer
local getCommitTime = lib2.getCommitTime
local ProfileMode = require(script.Parent.ReactTypeOfMode).ProfileMode
local commitUpdateQueue = lib.commitUpdateQueue
local getPublicInstance = ReactFiberHostConfig.getPublicInstance
local supportsMutation = ReactFiberHostConfig.supportsMutation
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
local lib3 = nil

local function resolveRetryWakeable(p2, p3) -- line: 196
	-- upvalues: lib3 (ref)
	if not lib3 then
		lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
	end

	lib3.resolveRetryWakeable(p2, p3)
end
local function markCommitTimeOfFallback() -- line: 203
	-- upvalues: lib3 (ref)
	if not lib3 then
		lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
	end

	lib3.markCommitTimeOfFallback()
end
local function schedulePassiveEffectCallback() -- line: 211
	-- upvalues: console (copy)
	console.warn("ReactFiberCommitWork: schedulePassiveEffectCallback causes a dependency cycle\n" .. debug.traceback())
end
local function captureCommitPhaseError(_, _, p6) -- line: 219
	-- upvalues: console (copy)
	console.warn("ReactFiberCommitWork: captureCommitPhaseError causes a dependency cycle")
	error(p6)
end

local NoFlags2 = ReactHookEffectTags.NoFlags
local HasEffect = ReactHookEffectTags.HasEffect
local Layout = ReactHookEffectTags.Layout
local Passive = ReactHookEffectTags.Passive
local didWarnAboutReassigningProps = nil

local function v104() -- line: 237
	-- upvalues: didWarnAboutReassigningProps (ref)
	if not didWarnAboutReassigningProps then
		didWarnAboutReassigningProps = require(script.Parent["ReactFiberBeginWork.new"]).didWarnAboutReassigningProps
	end

	return didWarnAboutReassigningProps
end

local isHostParent = nil
local insertOrAppendPlacementNode = nil
local insertOrAppendPlacementNodeIntoContainer = nil
local commitLayoutEffectsForHostRoot = nil
local commitLayoutEffectsForHostComponent = nil
local commitLayoutEffectsForClassComponent = nil
local unmountHostComponents = nil
local u112 = nil

local function callComponentWillUnmountWithTimer(p7, p8) -- line: 262
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startLayoutEffectTimer (copy), describeError (copy), recordLayoutEffectDuration (copy)
	p8.props = p7.memoizedProps
	p8.state = p7.memoizedState

	if enableProfilerTimer and (enableProfilerCommitHooks and bit32.band(p7.mode, ProfileMode) ~= 0) then
		local ok, result = xpcall(function() -- line: 271
			-- upvalues: startLayoutEffectTimer (copy), p8 (copy)
			startLayoutEffectTimer()
			p8:componentWillUnmount()
		end, describeError)

		recordLayoutEffectDuration(p7)

		if not ok then
			error(result)

			return
		end
	else
		p8:componentWillUnmount()
	end
end

function safelyCallComponentWillUnmount(p9, p10, p11) -- line: 289
	-- upvalues: callComponentWillUnmountWithTimer (copy), describeError (copy), captureCommitPhaseError (ref)
	local ok, result = xpcall(callComponentWillUnmountWithTimer, describeError, p9, p10)

	if not ok then
		captureCommitPhaseError(p9, p11, result)
	end
end

local function safelyDetachRef(p12, p13) -- line: 303
	-- upvalues: describeError (copy), captureCommitPhaseError (ref)
	local ref = p12.ref

	if ref ~= nil then
		if typeof(ref) == "function" then
			local ok, result = xpcall(ref, describeError)

			if not ok then
				captureCommitPhaseError(p12, p13, result)

				return
			end
		else
			ref.current = nil
		end
	end
end
local function commitHookEffectListUnmount(p14, p15, p16) -- line: 424
	-- upvalues: describeError (copy), captureCommitPhaseError (ref)
	local updateQueue = p15.updateQueue
	local lastEffect = nil

	if updateQueue ~= nil then
		lastEffect = updateQueue.lastEffect
	end

	if lastEffect ~= nil then
		local next = lastEffect.next
		local v164 = next

		repeat
			if p14 == bit32.band(v164.tag, p14) then
				local destroy = v164.destroy

				v164.destroy = nil

				if destroy ~= nil then
					local ok, result = xpcall(destroy, describeError)

					if not ok then
						captureCommitPhaseError(p15, p16, result)
					end
				end
			end

			v164 = v164.next
		until v164 == next
	end
end
local function commitHookEffectListMount(p17, p18) -- line: 452
	-- upvalues: __DEV__ (copy), console (copy)
	local updateQueue = p18.updateQueue
	local v171 = if updateQueue == nil then nil else updateQueue.lastEffect

	if v171 ~= nil then
		local next = v171.next
		local v173 = next

		repeat
			if p17 == bit32.band(v173.tag, p17) then
				v173.destroy = v173.create()

				if __DEV__ then
					local destroy = v173.destroy

					if destroy ~= nil and typeof(destroy) ~= "function" then
						local v175 = if destroy ~= nil then if typeof(destroy.andThen) ~= "function" then " You returned: " .. destroy else "\n\nIt looks like you wrote useEffect(Promise.new(function() --[[...]] end) or returned a Promise. Instead, write the async function inside your effect and call it immediately:\n\nuseEffect(function()\n  function fetchData()\n    -- You can await here\n    local response = MyAPI.getData(someId):await()\n    -- ...\n  end\n  fetchData()\nend, {someId}) -- Or {} if effect doesn't need props or state\n\nLearn more about data fetching with Hooks: https://reactjs.org/link/hooks-data-fetching" else " You returned nil. If your effect does not require clean up, return nil (or nothing)."

						console.error("An effect function must not return anything besides a function, which is used for clean-up.%s", v175)
					end
				end
			end

			v173 = v173.next
		until v173 == next
	end
end

function commitProfilerPassiveEffect(p19, p20) -- line: 492
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), Profiler (copy), getCommitTime (copy), enableSchedulerTracing (copy)
	if enableProfilerTimer and (enableProfilerCommitHooks and p20.tag == Profiler) then
		local passiveEffectDuration = p20.stateNode.passiveEffectDuration
		local id = p20.memoizedProps.id
		local onPostCommit = p20.memoizedProps.onPostCommit
		local v181 = getCommitTime()

		if typeof(onPostCommit) == "function" then
			if enableSchedulerTracing then
				onPostCommit(id, p20.alternate ~= nil and "update" or "mount", passiveEffectDuration, v181, p19.memoizedInteractions)

				return
			end

			onPostCommit(id, p20.alternate ~= nil and "update" or "mount", passiveEffectDuration, v181)
		end
	end
end

local function recursivelyCommitLayoutEffects(p21, p22, p23: ((...any) -> ...any), p24: ((...any) -> ...any)) -- line: 525
	-- upvalues: captureCommitPhaseError (ref), schedulePassiveEffectCallback (ref), Profiler (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), u112 (ref), LayoutMask (copy), NoFlags (copy), __DEV__ (copy), current (copy), setCurrentFiber (copy), invokeGuardedCallback (copy), recursivelyCommitLayoutEffects (copy), hasCaughtError (copy), clearCaughtError (copy), resetCurrentFiber (copy), describeError (copy), Update (copy), Callback (copy), ReactCurrentFiber (copy), n1 (ref), __YOLO__ (copy), FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), ProfileMode (copy), startLayoutEffectTimer (copy), commitHookEffectListMount (copy), Layout (copy), HasEffect (copy), recordLayoutEffectDuration (copy), PassiveMask (copy), ClassComponent (copy), commitLayoutEffectsForClassComponent (ref), HostRoot (copy), commitLayoutEffectsForHostRoot (ref), HostComponent (copy), commitLayoutEffectsForHostComponent (ref), SuspenseComponent (copy), FundamentalComponent (copy), HostPortal (copy), HostText (copy), IncompleteClassComponent (copy), LegacyHiddenComponent (copy), OffscreenComponent (copy), ScopeComponent (copy), SuspenseListComponent (copy), invariant (copy), Ref (copy)
	if p23 ~= nil then
		captureCommitPhaseError = p23
	end

	if p24 ~= nil then
		schedulePassiveEffectCallback = p24
	end

	local flags = p21.flags
	local tag = p21.tag

	if tag == Profiler then
		local v188 = nil

		if enableProfilerTimer and enableProfilerCommitHooks then
			v188 = u112
			u112 = p21
		end

		local child = p21.child

		while child ~= nil do
			if bit32.band(p21.subtreeFlags, LayoutMask) ~= NoFlags then
				if __DEV__ then
					local v190 = current

					setCurrentFiber(child)
					invokeGuardedCallback(nil, recursivelyCommitLayoutEffects, nil, child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)

					if hasCaughtError() then
						local v191 = clearCaughtError()

						captureCommitPhaseError(child, p21, v191)
					end

					if v190 ~= nil then
						setCurrentFiber(v190)
					else
						resetCurrentFiber()
					end
				else
					local ok, result = xpcall(recursivelyCommitLayoutEffects, describeError, child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)

					if not ok then
						captureCommitPhaseError(child, p21, result)
					end
				end
			end

			child = child.sibling
		end

		if bit32.band(flags, (bit32.bor(Update, Callback))) ~= NoFlags and enableProfilerTimer then
			if __DEV__ then
				local v194 = current

				setCurrentFiber(p21)
				invokeGuardedCallback(nil, commitLayoutEffectsForProfiler, nil, p21, p22)

				if hasCaughtError() then
					local v195 = clearCaughtError()

					captureCommitPhaseError(p21, p21.return_, v195)
				end

				if v194 ~= nil then
					setCurrentFiber(v194)
				else
					resetCurrentFiber()
				end
			else
				local ok, result = xpcall(commitLayoutEffectsForProfiler, describeError, p21, p22)

				if not ok then
					captureCommitPhaseError(p21, p21.return_, result)
				end
			end
		end

		if enableProfilerTimer and enableProfilerCommitHooks then
			if v188 ~= nil then
				local stateNode = v188.stateNode

				stateNode.effectDuration = stateNode.effectDuration + p21.stateNode.effectDuration
			end

			u112 = v188

			return
		end
	else
		local child = p21.child

		while child ~= nil do
			if bit32.band(p21.subtreeFlags, LayoutMask) ~= NoFlags then
				if __DEV__ then
					local current2 = ReactCurrentFiber.current

					setCurrentFiber(child)

					if n1 < 20 then
						n1 += 1
						invokeGuardedCallback(nil, recursivelyCommitLayoutEffects, nil, child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)
						n1 -= 1

						if hasCaughtError() then
							local v201 = clearCaughtError()

							captureCommitPhaseError(child, p21, v201)
						end
					else
						recursivelyCommitLayoutEffects(child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)
					end

					if current2 ~= nil then
						setCurrentFiber(current2)
					else
						resetCurrentFiber()
					end
				else
					local result = nil
					local ok

					if not __YOLO__ and n1 < 20 then
						n1 += 1
						ok, result = xpcall(recursivelyCommitLayoutEffects, describeError, child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)
						n1 -= 1
					else
						ok = true
						recursivelyCommitLayoutEffects(child, p22, captureCommitPhaseError, schedulePassiveEffectCallback)
					end

					if not ok then
						captureCommitPhaseError(child, p21, result)
					end
				end
			end

			child = child.sibling
		end

		if bit32.band(flags, (bit32.bor(Update, Callback))) ~= NoFlags then
			if tag == FunctionComponent or tag == ForwardRef or tag == SimpleMemoComponent or tag == Block then
				if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p21.mode, ProfileMode) ~= 0 then
					local ok, result = xpcall(function() -- line: 747
						-- upvalues: startLayoutEffectTimer (copy), commitHookEffectListMount (copy), Layout (copy), HasEffect (copy), p21 (copy)
						startLayoutEffectTimer()
						commitHookEffectListMount(bit32.bor(Layout, HasEffect), p21)
					end, describeError)

					recordLayoutEffectDuration(p21)

					if not ok then
						error(result)
					end
				else
					commitHookEffectListMount(bit32.bor(Layout, HasEffect), p21)
				end

				if bit32.band(p21.subtreeFlags, PassiveMask) ~= NoFlags then
					schedulePassiveEffectCallback()
				end
			elseif tag == ClassComponent then
				commitLayoutEffectsForClassComponent(p21)
			elseif tag == HostRoot then
				commitLayoutEffectsForHostRoot(p21)
			elseif tag == HostComponent then
				commitLayoutEffectsForHostComponent(p21)
			elseif tag == SuspenseComponent then
				commitSuspenseHydrationCallbacks(p22, p21)
			elseif tag ~= FundamentalComponent and tag ~= HostPortal and tag ~= HostText and tag ~= IncompleteClassComponent and tag ~= LegacyHiddenComponent and tag ~= OffscreenComponent and tag ~= ScopeComponent and tag ~= SuspenseListComponent then
				invariant(false, "This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue.")
			end
		end

		if bit32.band(flags, Ref) ~= 0 then
			commitAttachRef(p21)
		end
	end
end

function commitLayoutEffectsForProfiler(p25, p26) -- line: 812
	-- upvalues: enableProfilerTimer (copy), getCommitTime (copy), Update (copy), Callback (copy), NoFlags (copy), enableSchedulerTracing (copy), enableProfilerCommitHooks (copy)
	if not enableProfilerTimer then
		return
	end

	local flags = p25.flags
	local alternate = p25.alternate
	local onCommit = p25.memoizedProps.onCommit
	local onRender = p25.memoizedProps.onRender
	local effectDuration = p25.stateNode.effectDuration
	local v213 = getCommitTime()
	local v214 = Update
	local v215 = Callback
	local g216 = nil
	local g218 = nil
	local mt = nil
	local v217 = nil
	local g221 = nil
	local mt2 = nil
	local v220 = nil

	repeat
		if g216 or bit32.band(flags, v214) == NoFlags then
			g216 = false

			if not enableProfilerCommitHooks or bit32.band(flags, v215) == NoFlags then
				return
			end

			if typeof(onCommit) == "function" then
				v217 = true
				g218 = true
			end

			repeat
				if g218 or (g218 or typeof(onCommit) == "table") then
					if not g218 then
						if not g218 then
							mt = getmetatable(onCommit)
						end
					end

					repeat
						if g218 or (g218 or (g218 or mt and rawget(mt, "__call"))) then
							if not g218 then
								if not g218 then
									if not g218 then
										v217 = true
									end
								end
							end

							g218 = false

							if v217 then
								if enableSchedulerTracing then
									onCommit(p25.memoizedProps.id, alternate ~= nil and "update" or "mount", effectDuration, v213, p26.memoizedInteractions)

									return
								end

								onCommit(p25.memoizedProps.id, alternate ~= nil and "update" or "mount", effectDuration, v213)
							end

							return
						end

						if onCommit._isMockFunction then
							v217 = true
							g218 = true
						end
					until not g218
				end

				v217 = false
				g218 = true
			until not g218
		end

		if typeof(onRender) == "function" then
			v220 = true
			g221 = true
		end

		repeat
			if g221 or (g221 or typeof(onRender) == "table") then
				if not g221 then
					if not g221 then
						mt2 = getmetatable(onRender)
					end
				end

				repeat
					if g221 or (g221 or (g221 or mt2 and rawget(mt2, "__call"))) then
						if not g221 then
							if not g221 then
								if not g221 then
									v220 = true
								end
							end
						end

						g221 = false

						if v220 then
							if enableSchedulerTracing then
								onRender(p25.memoizedProps.id, alternate ~= nil and "update" or "mount", p25.actualDuration, p25.treeBaseDuration, p25.actualStartTime, v213, p26.memoizedInteractions)
							else
								onRender(p25.memoizedProps.id, alternate ~= nil and "update" or "mount", p25.actualDuration, p25.treeBaseDuration, p25.actualStartTime, v213)
							end
						end

						g216 = true
					end

					if g216 then
						break
					end

					if onRender._isMockFunction then
						v220 = true
						g221 = true
					end
				until not g221
			end

			if g216 then
				break
			end

			v220 = false
			g221 = true
		until not g221
	until not g216
end
function commitLayoutEffectsForClassComponent(p27) -- line: 880
	-- upvalues: Update (copy), __DEV__ (copy), v104 (copy), console (copy), getComponentName (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startLayoutEffectTimer (copy), describeError (copy), recordLayoutEffectDuration (copy), resolveDefaultProps (copy), commitUpdateQueue (copy)
	local stateNode = p27.stateNode
	local alternate = p27.alternate

	if bit32.band(p27.flags, Update) ~= 0 then
		if alternate == nil then
			if __DEV__ and p27.type == p27.elementType and not v104 then
				if stateNode.props ~= p27.memoizedProps then
					console.error("Expected %s props to match memoized props before componentDidMount. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.", getComponentName(p27.type) or "instance")
				end

				if stateNode.state ~= p27.memoizedState then
					console.error("Expected %s state to match memoized state before componentDidMount. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.", getComponentName(p27.type) or "instance")
				end
			end

			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p27.mode, ProfileMode) ~= 0 then
				local ok, result = xpcall(function() -- line: 920
					-- upvalues: startLayoutEffectTimer (copy), stateNode (copy)
					startLayoutEffectTimer()
					stateNode:componentDidMount()
				end, describeError)

				recordLayoutEffectDuration(p27)

				if not ok then
					error(result)
				end
			else
				stateNode:componentDidMount()
			end
		else
			local v228 = p27.elementType == p27.type and alternate.memoizedProps or resolveDefaultProps(p27.type, alternate.memoizedProps)
			local memoizedState = alternate.memoizedState

			if __DEV__ and p27.type == p27.elementType and not v104 then
				if stateNode.props ~= p27.memoizedProps then
					console.error("Expected %s props to match memoized props before componentDidUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.", getComponentName(p27.type) or "instance")
				end

				if stateNode.state ~= p27.memoizedState then
					console.error("Expected %s state to match memoized state before componentDidUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.", getComponentName(p27.type) or "instance")
				end
			end

			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p27.mode, ProfileMode) ~= 0 then
				local ok, result = xpcall(function() -- line: 974
					-- upvalues: startLayoutEffectTimer (copy), stateNode (copy), v228 (copy), memoizedState (copy)
					startLayoutEffectTimer()
					stateNode:componentDidUpdate(v228, memoizedState, stateNode.__reactInternalSnapshotBeforeUpdate)
				end, describeError)

				recordLayoutEffectDuration(p27)

				if not ok then
					error(result)
				end
			else
				stateNode:componentDidUpdate(v228, memoizedState, stateNode.__reactInternalSnapshotBeforeUpdate)
			end
		end
	end

	local updateQueue = p27.updateQueue

	if updateQueue ~= nil then
		if __DEV__ and p27.type == p27.elementType and not v104 then
			if stateNode.props ~= p27.memoizedProps then
				console.error("Expected %s props to match memoized props before processing the update queue. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.", getComponentName(p27.type) or "instance")
			end

			if stateNode.state ~= p27.memoizedState then
				console.error("Expected %s state to match memoized state before processing the update queue. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.", getComponentName(p27.type) or "instance")
			end
		end

		commitUpdateQueue(p27, updateQueue, stateNode)
	end
end
function commitLayoutEffectsForHostRoot(p28) -- line: 1037
	-- upvalues: HostComponent (copy), getPublicInstance (copy), ClassComponent (copy), commitUpdateQueue (copy)
	local updateQueue = p28.updateQueue

	if updateQueue ~= nil then
		local v235 = nil

		if p28.child ~= nil then
			local child = p28.child

			if child.tag == HostComponent then
				v235 = getPublicInstance(child.stateNode)
			elseif child.tag == ClassComponent then
				v235 = child.stateNode
			end
		end

		commitUpdateQueue(p28, updateQueue, v235)
	end
end
function commitLayoutEffectsForHostComponent(p29) -- line: 1056
	-- upvalues: Update (copy), commitMount (copy)
	local stateNode = p29.stateNode

	if p29.alternate == nil and bit32.band(p29.flags, Update) ~= 0 then
		local type = p29.type
		local memoizedProps = p29.memoizedProps

		commitMount(stateNode, type, memoizedProps, p29)
	end
end

local function hideOrUnhideAllChildren(p30, p31) -- line: 1071
	-- upvalues: supportsMutation (copy), HostComponent (copy), hideInstance (copy), unhideInstance (copy), HostText (copy), hideTextInstance (copy), unhideTextInstance (copy), OffscreenComponent (copy), LegacyHiddenComponent (copy)
	if not supportsMutation then
		return
	end

	local v243 = p30
	local g246 = nil

	repeat
		local g244 = false

		while v243.tag ~= HostComponent do
			if v243.tag == HostText then
				local stateNode = v243.stateNode

				if p31 then
					hideTextInstance(stateNode)
				else
					unhideTextInstance(stateNode, v243.memoizedProps)
				end

				g246 = true
			end

			if g246 then
				break
			end

			if (v243.tag == OffscreenComponent or v243.tag == LegacyHiddenComponent) and v243.memoizedState ~= nil and v243 ~= p30 or v243.child == nil then
				g246 = true
			end

			if g246 then
				break
			end

			v243.child.return_ = v243
			v243 = v243.child
		end

		if not g246 then
			if not g246 then
				local stateNode = v243.stateNode

				if p31 then
					hideInstance(stateNode)
				else
					unhideInstance(v243.stateNode, v243.memoizedProps)
				end
			end
		end

		g246 = false

		if v243 == p30 then
			return
		end

		while v243.sibling == nil do
			if v243.return_ == nil or p30 == v243.return_ then
				return
			end

			v243 = v243.return_
		end

		v243.sibling.return_ = v243.return_
		v243 = v243.sibling
		g244 = true
	until not g244
end

function commitAttachRef(p32) -- line: 1121
	-- upvalues: HostComponent (copy), getPublicInstance (copy), __DEV__ (copy), console (copy), getComponentName (copy)
	local ref = p32.ref

	if ref ~= nil then
		local stateNode = p32.stateNode
		local v251 = if p32.tag ~= HostComponent then stateNode else getPublicInstance(stateNode)

		if typeof(ref) == "function" then
			ref(v251)

			return
		end

		if __DEV__ and typeof(ref) ~= "table" then
			console.error("Unexpected ref object provided for %s. Use either a ref-setter function or React.createRef().", getComponentName(p32.type) or "instance")

			return
		end

		ref.current = v251
	end
end
function commitDetachRef(p33) -- line: 1160
	local ref = p33.ref

	if ref ~= nil then
		if typeof(ref) == "function" then
			ref(nil)

			return
		end

		ref.current = nil
	end
end

local function commitUnmount(p34, p35, p36, p37) -- line: 1174
	-- upvalues: onCommitUnmount (copy), FunctionComponent (copy), ForwardRef (copy), MemoComponent (copy), SimpleMemoComponent (copy), Block (copy), Layout (copy), NoFlags2 (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startLayoutEffectTimer (copy), describeError (copy), captureCommitPhaseError (ref), recordLayoutEffectDuration (copy), ClassComponent (copy), HostComponent (copy), HostPortal (copy), supportsMutation (copy), unmountHostComponents (ref), supportsPersistence (copy), unimplemented (copy)
	onCommitUnmount(p35)

	if p35.tag == FunctionComponent or (p35.tag == ForwardRef or p35.tag == MemoComponent or p35.tag == SimpleMemoComponent or p35.tag == Block) then
		local updateQueue = p35.updateQueue

		if updateQueue ~= nil then
			local lastEffect = updateQueue.lastEffect

			if lastEffect ~= nil then
				local next = lastEffect.next
				local v261 = next

				repeat
					if v261.destroy ~= nil and bit32.band(v261.tag, Layout) ~= NoFlags2 then
						if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p35.mode, ProfileMode) ~= 0 then
							startLayoutEffectTimer()

							local destroy = v261.destroy
							local ok, result = xpcall(destroy, describeError)

							if not ok then
								captureCommitPhaseError(p35, p36, result)
							end

							recordLayoutEffectDuration(p35)
						else
							local destroy = v261.destroy
							local ok, result = xpcall(destroy, describeError)

							if not ok then
								captureCommitPhaseError(p35, p36, result)
							end
						end
					end

					v261 = v261.next
				until v261 == next
			end
		end

		return
	end

	if p35.tag == ClassComponent then
		local ref = p35.ref

		if ref ~= nil then
			if typeof(ref) == "function" then
				local ok, result = xpcall(ref, describeError)

				if not ok then
					captureCommitPhaseError(p35, p36, result)
				end
			else
				ref.current = nil
			end
		end

		local stateNode = p35.stateNode

		if typeof(stateNode.componentWillUnmount) == "function" then
			safelyCallComponentWillUnmount(p35, stateNode, p36)
		end

		return
	end

	if p35.tag == HostComponent then
		local ref = p35.ref

		if ref ~= nil then
			if typeof(ref) == "function" then
				local ok, result = xpcall(ref, describeError)

				if not ok then
					captureCommitPhaseError(p35, p36, result)

					return
				end
			else
				ref.current = nil
			end
		end

		return
	end

	if p35.tag == HostPortal then
		if supportsMutation then
			unmountHostComponents(p34, p35, p36, p37)

			return
		end

		if supportsPersistence then
			unimplemented("emptyPortalContainer")
		end

		return
	end
end
local function commitNestedUnmounts(p38, p39, p40, p41) -- line: 1281
	-- upvalues: commitUnmount (ref), supportsMutation (copy), HostPortal (copy)
	local v279 = p39

	while true do
		while true do
			commitUnmount(p38, v279, p40, p41)

			if v279.child == nil or supportsMutation and v279.tag == HostPortal then
				break
			end

			v279.child.return_ = v279
			v279 = v279.child
		end

		if v279 == p39 then
			break
		end

		while v279.sibling == nil do
			if v279.return_ == nil or p39 == v279.return_ then
				return
			end

			v279 = v279.return_
		end

		v279.sibling.return_ = v279.return_
		v279 = v279.sibling
	end
end
local function detachFiberMutation(p42) -- line: 1321
	-- upvalues: enableNewTreeCleanupPath (copy)
	local alternate = p42.alternate

	if alternate ~= nil then
		alternate.return_ = nil

		if not enableNewTreeCleanupPath then
			p42.alternate = nil
		end
	end

	p42.return_ = nil
end
local function getHostParentFiber(p43) -- line: 1390
	-- upvalues: isHostParent (ref), Error (copy)
	local return_ = p43.return_

	while return_ ~= nil do
		if isHostParent(return_) then
			return return_
		end

		return_ = return_.return_
	end

	error(Error.new("Expected to find a host parent. This error is likely caused by a bug in React. Please file an issue."))
end

function isHostParent(p44) -- line: 1408
	-- upvalues: HostComponent (copy), HostRoot (copy), HostPortal (copy)
	return p44.tag == HostComponent or (p44.tag == HostRoot or p44.tag == HostPortal)
end

local function getHostSibling(p45) -- line: 1412
	-- upvalues: isHostParent (ref), HostComponent (copy), HostText (copy), DehydratedFragment (copy), Placement (copy), HostPortal (copy)
	repeat
		local v286 = false

		while p45.sibling == nil do
			if p45.return_ == nil or isHostParent(p45.return_) then
				return nil
			end

			p45 = p45.return_
		end

		p45.sibling.return_ = p45.return_
		p45 = p45.sibling

		while p45.tag ~= HostComponent and p45.tag ~= HostText and p45.tag ~= DehydratedFragment do
			if bit32.band(p45.flags, Placement) ~= 0 then
				v286 = true

				break
			end

			if p45.child == nil or p45.tag == HostPortal then
				v286 = true

				break
			end

			p45.child.return_ = p45
			p45 = p45.child
		end
	until not v286 and bit32.band(p45.flags, Placement) == 0

	return p45.stateNode
end

function insertOrAppendPlacementNodeIntoContainer(p46, p47, p48) -- line: 1517
	-- upvalues: HostComponent (copy), HostText (copy), insertInContainerBefore (copy), appendChildToContainer (copy), HostPortal (copy), insertOrAppendPlacementNodeIntoContainer (ref)
	local tag = p46.tag

	if tag == HostComponent or tag == HostText then
		local stateNode = p46.stateNode

		if p47 then
			insertInContainerBefore(p48, stateNode, p47)

			return
		end

		appendChildToContainer(p48, stateNode)

		return
	end

	if tag == HostPortal then
		return
	end

	local child = p46.child

	if child ~= nil then
		insertOrAppendPlacementNodeIntoContainer(child, p47, p48)

		local sibling = child.sibling

		while sibling ~= nil do
			insertOrAppendPlacementNodeIntoContainer(sibling, p47, p48)
			sibling = sibling.sibling
		end
	end
end
function insertOrAppendPlacementNode(p49, p50, p51) -- line: 1549
	-- upvalues: HostComponent (copy), HostText (copy), insertBefore (copy), appendChild (copy), HostPortal (copy), insertOrAppendPlacementNode (ref)
	local tag = p49.tag

	if tag == HostComponent or tag == HostText then
		local stateNode = p49.stateNode

		if p50 then
			insertBefore(p51, stateNode, p50)

			return
		end

		appendChild(p51, stateNode)

		return
	end

	if tag == HostPortal then
		return
	end

	local child = p49.child

	if child ~= nil then
		insertOrAppendPlacementNode(child, p50, p51)

		local sibling = child.sibling

		while sibling ~= nil do
			insertOrAppendPlacementNode(sibling, p50, p51)
			sibling = sibling.sibling
		end
	end
end
function unmountHostComponents(p52, p53, p54, p55) -- line: 1577
	-- upvalues: Error (copy), HostComponent (copy), HostRoot (copy), HostPortal (copy), HostText (copy), commitNestedUnmounts (ref), removeChildFromContainer (copy), removeChild (copy), commitUnmount (ref)
	local v311 = p53
	local v312 = false
	local stateNode = nil
	local v314 = nil
	local g317 = nil
	local g318 = nil

	repeat
		local g315 = false

		while true do
			if not v312 then
				local return_ = v311.return_

				while true do
					if return_ == nil then
						error(Error.new("Expected to find a host parent. This error is likely caused by a bug in React. Please file an issue."))
					end

					stateNode = return_.stateNode

					if return_.tag == HostComponent then
						break
					end

					if return_.tag == HostRoot then
						stateNode = stateNode.containerInfo
						v314 = true
						g317 = true
					end

					if g317 then
						break
					end

					if return_.tag == HostPortal then
						stateNode = stateNode.containerInfo
						v314 = true
						g317 = true
					end

					if g317 then
						break
					end

					return_ = return_.return_
				end

				if not g317 then
					if not g317 then
						v314 = false
					end
				end

				g317 = false
				v312 = true
			end

			if v311.tag == HostComponent or v311.tag == HostText then
				break
			end

			if v311.tag ~= HostPortal then
				commitUnmount(p52, v311, p54, p55)

				if v311.child == nil then
					g318 = true
				end

				if not g318 then
					v311.child.return_ = v311
					v311 = v311.child

					continue
				end
			end

			if g318 then
				break
			end

			if v311.child == nil then
				g318 = true
			end

			if g318 then
				break
			end

			stateNode = v311.stateNode.containerInfo
			v314 = true
			v311.child.return_ = v311
			v311 = v311.child
		end

		if not g318 then
			if not g318 then
				commitNestedUnmounts(p52, v311, p54, p55)

				if v314 then
					removeChildFromContainer(stateNode, v311.stateNode)
				else
					removeChild(stateNode, v311.stateNode)
				end
			end
		end

		g318 = false

		if v311 == p53 then
			return
		end

		while v311.sibling == nil do
			if v311.return_ == nil or p53 == v311.return_ then
				return
			end

			v311 = v311.return_

			if v311.tag == HostPortal then
				v312 = false
			end
		end

		v311.sibling.return_ = v311.return_
		v311 = v311.sibling
		g315 = true
	until not g315
end
function commitSuspenseComponent(p56) -- line: 2005
	-- upvalues: lib3 (ref), supportsMutation (copy), hideOrUnhideAllChildren (copy), enableSuspenseCallback (copy), __DEV__ (copy), console (copy)
	local memoizedState = p56.memoizedState

	if memoizedState ~= nil then
		if not lib3 then
			lib3 = require(script.Parent["ReactFiberWorkLoop.new"])
		end

		lib3.markCommitTimeOfFallback()

		if supportsMutation then
			local child = p56.child

			hideOrUnhideAllChildren(child, true)
		end
	end

	if enableSuspenseCallback and memoizedState ~= nil then
		local suspenseCallback = p56.memoizedProps.suspenseCallback

		if typeof(suspenseCallback) == "function" then
			local updateQueue = p56.updateQueue

			if updateQueue ~= nil then
				suspenseCallback(table.clone(updateQueue))

				return
			end
		elseif __DEV__ and suspenseCallback ~= nil then
			console.error("Unexpected type for suspenseCallback: %s", (tostring(suspenseCallback)))
		end
	end
end
function commitSuspenseHydrationCallbacks(p57, p58) -- line: 2044
	-- upvalues: supportsHydration (copy), commitHydratedSuspenseInstance (copy), enableSuspenseCallback (copy)
	if not supportsHydration then
		return
	end

	if p58.memoizedState == nil then
		local alternate = p58.alternate

		if alternate ~= nil then
			local memoizedState = alternate.memoizedState

			if memoizedState ~= nil then
				local dehydrated = memoizedState.dehydrated

				if dehydrated ~= nil then
					commitHydratedSuspenseInstance(dehydrated)

					if enableSuspenseCallback then
						local hydrationCallbacks = p57.hydrationCallbacks

						if hydrationCallbacks ~= nil then
							local onHydrated = hydrationCallbacks.onHydrated

							if onHydrated then
								onHydrated(dehydrated)
							end
						end
					end
				end
			end
		end
	end
end
function attachSuspenseRetryListeners(p59) -- line: 2072
	-- upvalues: Set (copy), resolveRetryWakeable (copy), enableSchedulerTracing (copy), unstable_wrap (copy)
	local updateQueue = p59.updateQueue

	if updateQueue ~= nil then
		p59.updateQueue = nil

		local stateNode = p59.stateNode

		if stateNode == nil then
			p59.stateNode = Set.new()
			stateNode = p59.stateNode
		end

		for v356, _ in updateQueue do
			local function u358() -- line: 2086
				-- upvalues: resolveRetryWakeable (copy), p59 (copy), v356 (copy)
				return resolveRetryWakeable(p59, v356)
			end

			if not stateNode:has(v356) then
				if enableSchedulerTracing and v356.__reactDoNotTraceInteractions ~= true then
					u358 = unstable_wrap(u358)
				end

				stateNode:add(v356)
				v356:andThen(function() -- line: 2097
					-- upvalues: u358 (ref)
					return u358()
				end, function() -- line: 2099
					-- upvalues: u358 (ref)
					return u358()
				end)
			end
		end
	end
end
function isSuspenseBoundaryBeingHidden(p60, p61) -- line: 2110
	if p60 ~= nil then
		local memoizedState = p60.memoizedState

		if memoizedState == nil or memoizedState.dehydrated ~= nil then
			local memoizedState2 = p61.memoizedState

			return memoizedState2 ~= nil and memoizedState2.dehydrated == nil
		end
	end

	return false
end
function commitResetTextContent(p62) -- line: 2122
	-- upvalues: supportsMutation (copy), resetTextContent (copy)
	if not supportsMutation then
		return
	end

	resetTextContent(p62.stateNode)
end
function invokeLayoutEffectMountInDEV(p63) -- line: 2215
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), invokeGuardedCallback (copy), commitHookEffectListMount (copy), Layout (copy), HasEffect (copy), hasCaughtError (copy), clearCaughtError (copy), captureCommitPhaseError (ref), ClassComponent (copy)
	if __DEV__ and enableDoubleInvokingEffects then
		if p63.tag == FunctionComponent or p63.tag == ForwardRef or p63.tag == SimpleMemoComponent or p63.tag == Block then
			invokeGuardedCallback(nil, commitHookEffectListMount, nil, bit32.bor(Layout, HasEffect), p63)

			if hasCaughtError() then
				local v372 = clearCaughtError()

				captureCommitPhaseError(p63, p63.return_, v372)
			end

			return
		end
	elseif p63.tag == ClassComponent then
		local stateNode = p63.stateNode

		invokeGuardedCallback(nil, stateNode.componentDidMount, stateNode)

		if hasCaughtError() then
			local v374 = clearCaughtError()

			captureCommitPhaseError(p63, p63.return_, v374)
		end

		return
	end
end
function invokePassiveEffectMountInDEV(p64) -- line: 2247
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), invokeGuardedCallback (copy), commitHookEffectListMount (copy), Passive (copy), HasEffect (copy), hasCaughtError (copy), clearCaughtError (copy), captureCommitPhaseError (ref)
	if __DEV__ and enableDoubleInvokingEffects and (p64.tag == FunctionComponent or p64.tag == ForwardRef or p64.tag == SimpleMemoComponent or p64.tag == Block) then
		invokeGuardedCallback(nil, commitHookEffectListMount, nil, bit32.bor(Passive, HasEffect), p64)

		if hasCaughtError() then
			local v376 = clearCaughtError()

			captureCommitPhaseError(p64, p64.return_, v376)
		end

		return
	end
end
function invokeLayoutEffectUnmountInDEV(p65) -- line: 2271
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), invokeGuardedCallback (copy), commitHookEffectListUnmount (copy), Layout (copy), HasEffect (copy), hasCaughtError (copy), clearCaughtError (copy), captureCommitPhaseError (ref), ClassComponent (copy)
	if __DEV__ and enableDoubleInvokingEffects then
		if p65.tag == FunctionComponent or p65.tag == ForwardRef or p65.tag == SimpleMemoComponent or p65.tag == Block then
			invokeGuardedCallback(nil, commitHookEffectListUnmount, nil, bit32.bor(Layout, HasEffect), p65, p65.return_)

			if hasCaughtError() then
				local v378 = clearCaughtError()

				captureCommitPhaseError(p65, p65.return_, v378)
			end

			return
		end
	elseif p65.tag == ClassComponent then
		local stateNode = p65.stateNode

		if typeof(stateNode.componentWillUnmount) == "function" then
			safelyCallComponentWillUnmount(p65, stateNode, p65.return_)
		end

		return
	end
end
function invokePassiveEffectUnmountInDEV(p66) -- line: 2302
	-- upvalues: __DEV__ (copy), enableDoubleInvokingEffects (copy), FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), invokeGuardedCallback (copy), commitHookEffectListUnmount (copy), Passive (copy), HasEffect (copy), hasCaughtError (copy), clearCaughtError (copy), captureCommitPhaseError (ref)
	if __DEV__ and enableDoubleInvokingEffects and (p66.tag == FunctionComponent or p66.tag == ForwardRef or p66.tag == SimpleMemoComponent or p66.tag == Block) then
		invokeGuardedCallback(nil, commitHookEffectListUnmount, nil, bit32.bor(Passive, HasEffect), p66, p66.return_)

		if hasCaughtError() then
			local v381 = clearCaughtError()

			captureCommitPhaseError(p66, p66.return_, v381)
		end

		return
	end
end

return {
	safelyCallDestroy = function(p67, p68, p69: ((...any) -> ...any)) -- line: 319
		-- upvalues: describeError (copy), captureCommitPhaseError (ref)
		local ok, result = xpcall(p69, describeError)

		if not ok then
			captureCommitPhaseError(p67, p68, result)
		end
	end,
	commitBeforeMutationLifeCycles = function(p70, p71) -- line: 331
		-- upvalues: FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), ClassComponent (copy), Snapshot (copy), __DEV__ (copy), v104 (copy), console (copy), getComponentName (copy), resolveDefaultProps (copy), HostRoot (copy), supportsMutation (copy), clearContainer (copy), HostComponent (copy), HostText (copy), HostPortal (copy), IncompleteClassComponent (copy), invariant (copy)
		if p71.tag == FunctionComponent or (p71.tag == ForwardRef or p71.tag == SimpleMemoComponent or p71.tag == Block) then
			return
		end

		if p71.tag == ClassComponent then
			if bit32.band(p71.flags, Snapshot) ~= 0 and p70 ~= nil then
				local memoizedProps = p70.memoizedProps
				local memoizedState = p70.memoizedState
				local stateNode = p71.stateNode

				if __DEV__ and p71.type == p71.elementType and not v104 then
					if stateNode.props ~= p71.memoizedProps then
						console.error("Expected %s props to match memoized props before getSnapshotBeforeUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.props`. Please file an issue.", getComponentName(p71.type) or "instance")
					end

					if stateNode.state ~= p71.memoizedState then
						console.error("Expected %s state to match memoized state before getSnapshotBeforeUpdate. This might either be because of a bug in React, or because a component reassigns its own `this.state`. Please file an issue.", getComponentName(p71.type) or "instance")
					end
				end

				local v156 = stateNode:getSnapshotBeforeUpdate(p71.elementType == p71.type and memoizedProps or resolveDefaultProps(p71.type, memoizedProps), memoizedState)

				if not __DEV__ then
				end

				stateNode.__reactInternalSnapshotBeforeUpdate = v156
			end

			return
		end

		if p71.tag == HostRoot then
			if supportsMutation and bit32.band(p71.flags, Snapshot) ~= 0 then
				local stateNode = p71.stateNode

				clearContainer(stateNode.containerInfo)
			end

			return
		end

		if p71.tag == HostComponent or p71.tag == HostText or p71.tag == HostPortal or p71.tag == IncompleteClassComponent then
			return
		end

		invariant(false, "This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue.")
	end,
	commitResetTextContent = commitResetTextContent,
	commitPlacement = function(p72) -- line: 1466
		-- upvalues: supportsMutation (copy), getHostParentFiber (copy), HostComponent (copy), HostRoot (copy), HostPortal (copy), invariant (copy), ContentReset (copy), resetTextContent (copy), getHostSibling (ref), insertOrAppendPlacementNodeIntoContainer (ref), insertOrAppendPlacementNode (ref)
		if not supportsMutation then
			return
		end

		local v288 = getHostParentFiber(p72)
		local v289 = nil
		local v290 = nil
		local stateNode = v288.stateNode

		if v288.tag == HostComponent then
			v289 = stateNode
			v290 = false
		elseif v288.tag == HostRoot then
			v289 = stateNode.containerInfo
			v290 = true
		elseif v288.tag == HostPortal then
			v289 = stateNode.containerInfo
			v290 = true
		else
			invariant(false, "Invalid host parent fiber. This error is likely caused by a bug in React. Please file an issue.")
		end

		if bit32.band(v288.flags, ContentReset) ~= 0 then
			resetTextContent(v289)
			v288.flags = bit32.band(v288.flags, (bit32.bnot(ContentReset)))
		end

		local v292 = getHostSibling(p72)

		if v290 then
			insertOrAppendPlacementNodeIntoContainer(p72, v292, v289)

			return
		end

		insertOrAppendPlacementNode(p72, v292, v289)
	end,
	commitDeletion = function(p73, p74, p75, p76) -- line: 1755
		-- upvalues: unmountHostComponents (ref), enableNewTreeCleanupPath (copy)
		unmountHostComponents(p73, p74, p75, p76)

		local alternate = nil

		if not enableNewTreeCleanupPath then
			alternate = p74.alternate
		end

		local alternate2 = p74.alternate

		if alternate2 ~= nil then
			alternate2.return_ = nil

			if not enableNewTreeCleanupPath then
				p74.alternate = nil
			end
		end

		p74.return_ = nil

		if not enableNewTreeCleanupPath and alternate ~= nil then
			local alternate3 = alternate.alternate

			if alternate3 ~= nil then
				alternate3.return_ = nil

				if not enableNewTreeCleanupPath then
					alternate.alternate = nil
				end
			end

			alternate.return_ = nil
		end
	end,
	commitWork = function(p77, p78) -- line: 1790
		-- upvalues: FunctionComponent (copy), ForwardRef (copy), MemoComponent (copy), SimpleMemoComponent (copy), Block (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startLayoutEffectTimer (copy), commitHookEffectListUnmount (copy), Layout (copy), HasEffect (copy), describeError (copy), recordLayoutEffectDuration (copy), ClassComponent (copy), HostComponent (copy), commitUpdate (copy), HostText (copy), invariant (copy), commitTextUpdate (copy), HostRoot (copy), supportsHydration (copy), unimplemented (copy), Profiler (copy), SuspenseComponent (copy), SuspenseListComponent (copy), IncompleteClassComponent (copy), OffscreenComponent (copy), LegacyHiddenComponent (copy), hideOrUnhideAllChildren (copy)
		if p78.tag == FunctionComponent or (p78.tag == ForwardRef or p78.tag == MemoComponent or p78.tag == SimpleMemoComponent or p78.tag == Block) then
			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p78.mode, ProfileMode) ~= 0 then
				local ok, result = xpcall(function() -- line: 1879
					-- upvalues: startLayoutEffectTimer (copy), commitHookEffectListUnmount (copy), Layout (copy), HasEffect (copy), p78 (copy)
					startLayoutEffectTimer()
					commitHookEffectListUnmount(bit32.bor(Layout, HasEffect), p78, p78.return_)
				end, describeError)

				recordLayoutEffectDuration(p78)

				if not ok then
					error(result)

					return
				end
			else
				commitHookEffectListUnmount(bit32.bor(Layout, HasEffect), p78, p78.return_)
			end

			return
		end

		if p78.tag == ClassComponent then
			return
		end

		if p78.tag == HostComponent then
			local stateNode = p78.stateNode

			if stateNode ~= nil then
				local memoizedProps = p78.memoizedProps
				local v332 = if not p77 then memoizedProps else p77.memoizedProps
				local type = p78.type
				local updateQueue = p78.updateQueue

				p78.updateQueue = nil

				if updateQueue ~= nil then
					commitUpdate(stateNode, updateQueue, type, v332, memoizedProps, p78)
				end
			end

			return
		end

		if p78.tag == HostText then
			invariant(p78.stateNode ~= nil, "This should have a text node initialized. This error is likely caused by a bug in React. Please file an issue.")

			local stateNode = p78.stateNode
			local memoizedProps = p78.memoizedProps
			local v337 = nil

			if p77 ~= nil then
				local _ = p77.memoizedProps

				v337 = memoizedProps
			end

			commitTextUpdate(stateNode, v337, memoizedProps)

			return
		end

		if p78.tag == HostRoot then
			if supportsHydration then
				local stateNode = p78.stateNode

				if stateNode.hydrate then
					stateNode.hydrate = false
					unimplemented("commitWork: HostRoot: commitHydratedContainer")
				end
			end

			return
		end

		if p78.tag == Profiler then
			return
		end

		if p78.tag == SuspenseComponent then
			commitSuspenseComponent(p78)
			attachSuspenseRetryListeners(p78)

			return
		end

		if p78.tag == SuspenseListComponent then
			unimplemented("commitWork: SuspenseListComponent")
		else
			if p78.tag == IncompleteClassComponent then
				return
			end

			if p78.tag == OffscreenComponent or p78.tag == LegacyHiddenComponent then
				local v340 = p78.memoizedState ~= nil

				hideOrUnhideAllChildren(p78, v340)

				return
			end
		end

		invariant(false, "This unit of work tag should not have side-effects. This error is likely caused by a bug in React. Please file an issue.")
	end,
	commitAttachRef = commitAttachRef,
	commitDetachRef = commitDetachRef,
	commitPassiveUnmount = function(p79) -- line: 2129
		-- upvalues: FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startPassiveEffectTimer (copy), commitHookEffectListUnmount (copy), Passive (copy), HasEffect (copy), recordPassiveEffectDuration (copy)
		if p79.tag == FunctionComponent or (p79.tag == ForwardRef or p79.tag == SimpleMemoComponent or p79.tag == Block) then
			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p79.mode, ProfileMode) ~= 0 then
				startPassiveEffectTimer()
				commitHookEffectListUnmount(bit32.bor(Passive, HasEffect), p79, p79.return_)
				recordPassiveEffectDuration(p79)

				return
			end

			commitHookEffectListUnmount(bit32.bor(Passive, HasEffect), p79, p79.return_)
		end
	end,
	commitPassiveUnmountInsideDeletedTree = function(p80, p81) -- line: 2158
		-- upvalues: FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startPassiveEffectTimer (copy), commitHookEffectListUnmount (copy), Passive (copy), recordPassiveEffectDuration (copy)
		if p80.tag == FunctionComponent or (p80.tag == ForwardRef or p80.tag == SimpleMemoComponent or p80.tag == Block) then
			if enableProfilerTimer and enableProfilerCommitHooks and bit32.band(p80.mode, ProfileMode) ~= 0 then
				startPassiveEffectTimer()
				commitHookEffectListUnmount(Passive, p80, p81)
				recordPassiveEffectDuration(p80)

				return
			end

			commitHookEffectListUnmount(Passive, p80, p81)
		end
	end,
	commitPassiveMount = function(p82, p83) -- line: 2182
		-- upvalues: FunctionComponent (copy), ForwardRef (copy), SimpleMemoComponent (copy), Block (copy), enableProfilerTimer (copy), enableProfilerCommitHooks (copy), ProfileMode (copy), startPassiveEffectTimer (copy), commitHookEffectListMount (copy), describeError (copy), Passive (copy), HasEffect (copy), recordPassiveEffectDuration (copy), Profiler (copy)
		if p83.tag == FunctionComponent or (p83.tag == ForwardRef or p83.tag == SimpleMemoComponent or p83.tag == Block) then
			if not enableProfilerTimer or not enableProfilerCommitHooks or bit32.band(p83.mode, ProfileMode) == 0 then
				commitHookEffectListMount(bit32.bor(Passive, HasEffect), p83)

				return
			end

			startPassiveEffectTimer()

			local ok, result = xpcall(commitHookEffectListMount, describeError, bit32.bor(Passive, HasEffect), p83)

			recordPassiveEffectDuration(p83)

			if not ok then
				error(result)

				return
			end
		elseif p83.tag == Profiler then
			commitProfilerPassiveEffect(p82, p83)
		end
	end,
	invokeLayoutEffectMountInDEV = invokeLayoutEffectMountInDEV,
	invokeLayoutEffectUnmountInDEV = invokeLayoutEffectUnmountInDEV,
	invokePassiveEffectMountInDEV = invokePassiveEffectMountInDEV,
	invokePassiveEffectUnmountInDEV = invokePassiveEffectUnmountInDEV,
	isSuspenseBoundaryBeingHidden = isSuspenseBoundaryBeingHidden,
	recursivelyCommitLayoutEffects = recursivelyCommitLayoutEffects
}
