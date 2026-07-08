local ParentParent = script.Parent.Parent

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent.ReactFiberLane)

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local NoFlags = ReactFiberFlags.NoFlags
local DidCapture = ReactFiberFlags.DidCapture
local isSuspenseInstancePending = ReactFiberHostConfig.isSuspenseInstancePending
local isSuspenseInstanceFallback = ReactFiberHostConfig.isSuspenseInstanceFallback

return {
	shouldCaptureSuspense = function(p1, b1: boolean) -- line: 84
		local memoizedState = p1.memoizedState

		if memoizedState then
			if memoizedState.dehydrated ~= nil then
				return true
			end

			return false
		end

		local memoizedProps = p1.memoizedProps

		if memoizedProps.fallback == nil then
			return false
		end

		if memoizedProps.unstable_avoidThisFallback ~= true then
			return true
		end

		if b1 then
			return false
		end

		return true
	end,
	findFirstSuspended = function(p2) -- line: 116
		-- upvalues: SuspenseComponent (copy), isSuspenseInstancePending (copy), isSuspenseInstanceFallback (copy), SuspenseListComponent (copy), DidCapture (copy), NoFlags (copy)
		local v16 = p2
		local g19 = nil
		local g20 = nil

		while v16 ~= nil do
			if v16.tag == SuspenseComponent then
				local memoizedState = v16.memoizedState

				if memoizedState then
					local dehydrated = memoizedState.dehydrated

					if dehydrated == nil or isSuspenseInstancePending(dehydrated) or isSuspenseInstanceFallback(dehydrated) then
						return v16
					end
				end

				g19 = true
			end

			repeat
				if g19 or (g19 or v16.tag == SuspenseListComponent and v16.memoizedProps.revealOrder ~= nil) then
					if not g19 then
						if not g19 then
							if bit32.band(v16.flags, DidCapture) ~= NoFlags then
								return v16
							end
						end
					end

					g19 = false

					if v16 == p2 then
						return nil
					end

					while v16.sibling == nil do
						if v16.return_ == nil or p2 == v16.return_ then
							return nil
						end

						v16 = v16.return_
					end

					v16.sibling.return_ = v16.return_
					v16 = v16.sibling
					g20 = true

					break
				end

				if v16.child == nil then
					g19 = true
				end
			until not g19

			if g20 then
				g20 = false

				continue
			end

			v16.child.return_ = v16
			v16 = v16.child
		end

		return nil
	end
}
