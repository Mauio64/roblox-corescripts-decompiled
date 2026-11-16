local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Responsive").useIsSpatial

local function getSyncVrOverlayOrNil()
	local vrCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")

	if vrCentralOverlay then
		return vrCentralOverlay:FindFirstChildWhichIsA("SurfaceGui")
	end

	return nil
end

local function useVrOverlay()
	local v5 = useIsSpatial()
	local state, setState = React.useState(getSyncVrOverlayOrNil)

	React.useEffect(function()
		if not v5 then
			return function() end
		end

		if state then
			return function() end
		end

		local thread = task.spawn(function()
			local vrCentralOverlay = CoreGui:WaitForChild("VRCentralOverlay", 5)

			if not vrCentralOverlay then
				return
			end

			local centralOverlay_SurfaceGui = vrCentralOverlay:WaitForChild("CentralOverlay_SurfaceGui", 5)

			if centralOverlay_SurfaceGui then
				setState(centralOverlay_SurfaceGui)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { v5, state })

	if v5 then
		return state, true
	end

	return nil, false
end

return useVrOverlay
