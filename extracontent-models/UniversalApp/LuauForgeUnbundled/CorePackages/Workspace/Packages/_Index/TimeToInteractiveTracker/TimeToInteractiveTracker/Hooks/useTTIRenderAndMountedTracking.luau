local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/React")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/types")

local function createUseTTIRenderAndMountedTracking(callback)
	return function(p2)
		local ref = React.useRef(false)

		if not ref.current then
			ref.current = true
			callback(p2, constants.RenderStarted)
		end

		React.useEffect(function()
			callback(p2, constants.SurfaceMounted)
		end, {})
	end
end

return createUseTTIRenderAndMountedTracking
