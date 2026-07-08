local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local React = require(TimeToInteractiveTrackerParent.React)
local constants = require(TimeToInteractiveTracker.Milestones.constants)

require(TimeToInteractiveTracker.Milestones.types)

local function createUseTTIRenderAndMountedTracking(p1: ((...any) -> ...any)) -- line: 25
	-- upvalues: React (copy), constants (copy)
	return function(s1: string) -- line: 26
		-- upvalues: React (copy), p1 (copy), constants (copy)
		local v8 = React.useRef(false)

		if not v8.current then
			v8.current = true
			p1(s1, constants.RenderStarted)
		end

		React.useEffect(function() -- line: 34
			-- upvalues: p1 (copy), s1 (copy), constants (copy)
			p1(s1, constants.SurfaceMounted)
		end, {})
	end
end

return createUseTTIRenderAndMountedTracking
