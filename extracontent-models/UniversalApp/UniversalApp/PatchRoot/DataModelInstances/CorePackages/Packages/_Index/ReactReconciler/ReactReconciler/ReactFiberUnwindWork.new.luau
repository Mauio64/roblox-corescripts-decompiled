local ParentParent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)
require(script.Parent.ReactFiberLane)
require(script.Parent["ReactFiberSuspenseComponent.new"])

local resetWorkInProgressVersions = require(script.Parent["ReactMutableSource.new"]).resetWorkInProgressVersions
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local lib = require(script.Parent["ReactFiberHostContext.new"])
local popHostContainer = lib.popHostContainer
local popHostContext = lib.popHostContext
local popSuspenseContext = require(script.Parent["ReactFiberSuspenseContext.new"]).popSuspenseContext
local resetHydrationState = require(script.Parent["ReactFiberHydrationContext.new"]).resetHydrationState
local lib2 = require(script.Parent["ReactFiberContext.new"])
local isContextProvider = lib2.isContextProvider
local popContext = lib2.popContext
local popTopLevelContextObject = lib2.popTopLevelContextObject
local popProvider = require(script.Parent["ReactFiberNewContext.new"]).popProvider
local popRenderLanes = nil

local function v20(...) -- line: 47
	-- upvalues: popRenderLanes (ref)
	if not popRenderLanes then
		popRenderLanes = require(script.Parent["ReactFiberWorkLoop.new"]).popRenderLanes
	end

	return popRenderLanes(...)
end

local transferActualDuration = require(script.Parent["ReactProfilerTimer.new"]).transferActualDuration
local invariant = require(ParentParent.Shared).invariant

function unwindInterruptedWork(p1) -- line: 154
	-- upvalues: ReactWorkTags (copy), popContext (copy), popHostContainer (copy), popTopLevelContextObject (copy), resetWorkInProgressVersions (copy), popHostContext (copy), popSuspenseContext (copy), popProvider (copy), v20 (copy)
	if p1.tag == ReactWorkTags.ClassComponent then
		local childContextTypes = nil

		if typeof(p1.type) == "table" then
			childContextTypes = p1.type.childContextTypes
		end

		if childContextTypes ~= nil then
			popContext(p1)

			return
		end

		return
	end

	if p1.tag == ReactWorkTags.HostRoot then
		popHostContainer(p1)
		popTopLevelContextObject(p1)
		resetWorkInProgressVersions()

		return
	end

	if p1.tag == ReactWorkTags.HostComponent then
		popHostContext(p1)

		return
	end

	if p1.tag == ReactWorkTags.HostPortal then
		popHostContainer(p1)

		return
	end

	if p1.tag == ReactWorkTags.SuspenseComponent then
		popSuspenseContext(p1)

		return
	end

	if p1.tag == ReactWorkTags.SuspenseListComponent then
		popSuspenseContext(p1)

		return
	end

	if p1.tag == ReactWorkTags.ContextProvider then
		popProvider(p1)

		return
	end

	if p1.tag == ReactWorkTags.OffscreenComponent or p1.tag == ReactWorkTags.LegacyHiddenComponent then
		v20(p1)

		return
	end
end

return {
	unwindWork = function(p2, _) -- line: 59
		-- upvalues: ReactWorkTags (copy), isContextProvider (copy), popContext (copy), ReactFiberFlags (copy), enableProfilerTimer (copy), ReactTypeOfMode (copy), transferActualDuration (copy), popHostContainer (copy), popTopLevelContextObject (copy), resetWorkInProgressVersions (copy), invariant (copy), popHostContext (copy), popSuspenseContext (copy), enableSuspenseServerRenderer (copy), resetHydrationState (copy), popProvider (copy), v20 (copy)
		if p2.tag == ReactWorkTags.ClassComponent then
			local type = p2.type

			if isContextProvider(type) then
				popContext(p2)
			end

			local flags = p2.flags

			if bit32.band(flags, ReactFiberFlags.ShouldCapture) ~= 0 then
				p2.flags = bit32.bor(bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))), ReactFiberFlags.DidCapture)

				if enableProfilerTimer and bit32.band(p2.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode then
					transferActualDuration(p2)
				end

				return p2
			end

			return nil
		end

		if p2.tag == ReactWorkTags.HostRoot then
			popHostContainer(p2)
			popTopLevelContextObject(p2)
			resetWorkInProgressVersions()

			local flags = p2.flags

			invariant(bit32.band(flags, ReactFiberFlags.DidCapture) == ReactFiberFlags.NoFlags, "The root failed to unmount after an error. This is likely a bug in React. Please file an issue.")
			p2.flags = bit32.bor(bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))), ReactFiberFlags.DidCapture)

			return p2
		end

		if p2.tag == ReactWorkTags.HostComponent then
			popHostContext(p2)

			return nil
		end

		if p2.tag == ReactWorkTags.SuspenseComponent then
			popSuspenseContext(p2)

			if enableSuspenseServerRenderer then
				local memoizedState = p2.memoizedState

				if memoizedState ~= nil and memoizedState.dehydrated ~= nil then
					invariant(p2.alternate ~= nil, "Threw in newly mounted dehydrated component. This is likely a bug in React. Please file an issue.")
					resetHydrationState()
				end
			end

			local flags = p2.flags

			if bit32.band(flags, ReactFiberFlags.ShouldCapture) ~= 0 then
				p2.flags = bit32.bor(bit32.band(flags, (bit32.bnot(ReactFiberFlags.ShouldCapture))), ReactFiberFlags.DidCapture)

				if enableProfilerTimer and bit32.band(p2.mode, ReactTypeOfMode.ProfileMode) ~= ReactTypeOfMode.NoMode then
					transferActualDuration(p2)
				end

				return p2
			end

			return nil
		end

		if p2.tag == ReactWorkTags.SuspenseListComponent then
			popSuspenseContext(p2)

			return nil
		end

		if p2.tag == ReactWorkTags.HostPortal then
			popHostContainer(p2)

			return nil
		end

		if p2.tag == ReactWorkTags.ContextProvider then
			popProvider(p2)

			return nil
		end

		if p2.tag == ReactWorkTags.OffscreenComponent or p2.tag == ReactWorkTags.LegacyHiddenComponent then
			v20(p2)

			return nil
		end

		return nil
	end,
	unwindInterruptedWork = unwindInterruptedWork
}
