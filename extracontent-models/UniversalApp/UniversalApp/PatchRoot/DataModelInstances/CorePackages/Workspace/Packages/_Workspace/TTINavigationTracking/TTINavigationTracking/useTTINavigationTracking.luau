local Parent = script:FindFirstAncestor("TTINavigationTracking").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useNavigation = require(Parent.Navigation).useNavigation
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local v7 = TimeToInteractiveTracker.Hooks or nil
local v8 = TimeToInteractiveTracker.trackMilestone or nil

local function useTTINavigationTracking(s1: string) -- line: 40
	-- upvalues: v7 (copy), useNavigation (copy), React (copy), TimeToInteractiveTracker (copy), RoactNavigation (copy), v8 (copy), Milestone (copy)
	v7.useTTIRenderAndMountedTracking(s1)

	local v11 = useNavigation()

	React.useEffect(function() -- line: 45
		-- upvalues: TimeToInteractiveTracker (copy), s1 (copy), v11 (copy), RoactNavigation (copy), v8 (copy), Milestone (copy)
		TimeToInteractiveTracker.trackEnd(s1)

		local v12 = v11.addListener(RoactNavigation.Events.WillFocus, function() -- line: 53
			-- upvalues: TimeToInteractiveTracker (copy), s1 (copy), v8 (copy), Milestone (copy)
			local v14 = TimeToInteractiveTracker.getEvents(false)[s1]

			if v14 and v14.startTime then
				v8(s1, Milestone.RenderStarted)
			end
		end)
		local v13 = v11.addListener(RoactNavigation.Events.DidFocus, function() -- line: 59
			-- upvalues: TimeToInteractiveTracker (copy), s1 (copy), v8 (copy), Milestone (copy)
			local v15 = TimeToInteractiveTracker.getEvents(false)[s1]

			if not v15 or not v15.startTime then
				return
			end

			v8(s1, Milestone.SurfaceMounted)
			TimeToInteractiveTracker.trackEnd(s1)
		end)

		return function() -- line: 67
			-- upvalues: v12 (copy), v13 (copy)
			v12.remove()
			v13.remove()
		end
	end, {})
end

return useTTINavigationTracking
