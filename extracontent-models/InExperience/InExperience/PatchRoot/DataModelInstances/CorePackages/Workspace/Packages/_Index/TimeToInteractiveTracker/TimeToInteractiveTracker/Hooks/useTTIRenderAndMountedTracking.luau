local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent
local React = require(parent.React)
local constants = require(TimeToInteractiveTracker.Milestones.constants)

require(TimeToInteractiveTracker.Milestones.types)

local function createUseTTIRenderAndMountedTracking(callback)
	return function(p: string)
		local ref = React.useRef(false)

		if not ref.current then
			ref.current = true
			callback(p, constants.RenderStarted)
		end

		React.useEffect(function()
			callback(p, constants.SurfaceMounted)
		end, {})
	end
end

return createUseTTIRenderAndMountedTracking
