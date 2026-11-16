local parent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)

require(script.Parent.ReactFiberLane)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactMutableSourcenew = require(script.Parent["ReactMutableSource.new"])
local resetWorkInProgressVersions = ReactMutableSourcenew.resetWorkInProgressVersions
local ReactWorkTags = require(script.Parent.ReactWorkTags)

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)

local Shared = require(parent.Shared)
local ReactFeatureFlags = Shared.ReactFeatureFlags
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer

local ReactFiberHostContextnew = require(script.Parent["ReactFiberHostContext.new"])
local popHostContainer = ReactFiberHostContextnew.popHostContainer
local popHostContext = ReactFiberHostContextnew.popHostContext

local ReactFiberSuspenseContextnew = require(script.Parent["ReactFiberSuspenseContext.new"])
local popSuspenseContext = ReactFiberSuspenseContextnew.popSuspenseContext

local ReactFiberHydrationContextnew = require(script.Parent["ReactFiberHydrationContext.new"])
local resetHydrationState = ReactFiberHydrationContextnew.resetHydrationState
local ReactFiberContextnew = require(script.Parent["ReactFiberContext.new"])
local isContextProvider = ReactFiberContextnew.isContextProvider
local popContext = ReactFiberContextnew.popContext
local popTopLevelContextObject = ReactFiberContextnew.popTopLevelContextObject
local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
local popProvider = ReactFiberNewContextnew.popProvider

local popRenderLanes = nil
local function fn(...)
	if not popRenderLanes then
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		popRenderLanes = ReactFiberWorkLoopnew.popRenderLanes
	end

	return popRenderLanes(...)
end

local ReactProfilerTimernew = require(script.Parent["ReactProfilerTimer.new"])
local transferActualDuration = ReactProfilerTimernew.transferActualDuration

local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant

function unwindInterruptedWork(p)
	if p.tag == ReactWorkTags.ClassComponent then
		local v

		if typeof(p.type) == "table" then
			v = p.type.childContextTypes
		end

		if v == nil then
			return
		end

		popContext(p)
	elseif p.tag == ReactWorkTags.HostRoot then
		popHostContainer(p)
		popTopLevelContextObject(p)
		resetWorkInProgressVersions()
	else
		if p.tag == ReactWorkTags.HostComponent then
			popHostContext(p)
			return
		end

		if p.tag == ReactWorkTags.HostPortal then
			popHostContainer(p)
			return
		end

		if p.tag == ReactWorkTags.SuspenseComponent then
			popSuspenseContext(p)
			return
		end

		if p.tag == ReactWorkTags.SuspenseListComponent then
			popSuspenseContext(p)
			return
		end

		if p.tag == ReactWorkTags.ContextProvider then
			popProvider(p)
			return
		end

		if p.tag ~= ReactWorkTags.OffscreenComponent and p.tag ~= ReactWorkTags.LegacyHiddenComponent then
			return
		end

		fn(p)
	end
end

return {
	unwindWork = function(state, _)
		if state.tag == ReactWorkTags.ClassComponent then
			if isContextProvider(state.type) then
				popContext(state)
			end

			local flags = state.flags

			if bit32.band(flags, ReactFiberFlags.ShouldCapture) == 0 then
				return nil
			end

			state.flags = bit32.bor(
				bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))),
				ReactFiberFlags.DidCapture
			)

			if
				enableProfilerTimer
				and bit32.band(state.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
			then
				transferActualDuration(state)
			end

			return state
		elseif state.tag == ReactWorkTags.HostRoot then
			popHostContainer(state)
			popTopLevelContextObject(state)
			resetWorkInProgressVersions()
			local flags = state.flags
			invariant(
				bit32.band(flags, ReactFiberFlags.DidCapture) == ReactFiberFlags.NoFlags,
				"The root failed to unmount after an error. This is likely a bug in React. Please file an issue."
			)

			state.flags = bit32.bor(
				bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))),
				ReactFiberFlags.DidCapture
			)

			return state
		else
			if state.tag == ReactWorkTags.HostComponent then
				popHostContext(state)
				return nil
			end

			if state.tag == ReactWorkTags.SuspenseComponent then
				popSuspenseContext(state)

				if enableSuspenseServerRenderer then
					local memoizedState = state.memoizedState

					if memoizedState ~= nil and memoizedState.dehydrated ~= nil then
						invariant(
							state.alternate ~= nil,
							"Threw in newly mounted dehydrated component. This is likely a bug in React. Please file an issue."
						)

						resetHydrationState()
					end
				end

				local flags = state.flags

				if bit32.band(flags, ReactFiberFlags.ShouldCapture) == 0 then
					return nil
				end

				state.flags = bit32.bor(
					bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))),
					ReactFiberFlags.DidCapture
				)

				if
					enableProfilerTimer
					and bit32.band(state.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode
				then
					transferActualDuration(state)
				end

				return state
			end

			if state.tag == ReactWorkTags.SuspenseListComponent then
				popSuspenseContext(state)

				return nil
			end

			if state.tag == ReactWorkTags.HostPortal then
				popHostContainer(state)
				return nil
			end

			if state.tag == ReactWorkTags.ContextProvider then
				popProvider(state)
				return nil
			end

			if state.tag ~= ReactWorkTags.OffscreenComponent and state.tag ~= ReactWorkTags.LegacyHiddenComponent then
				return nil
			end

			fn(state)
			return nil
		end
	end,
	unwindInterruptedWork = unwindInterruptedWork
}
