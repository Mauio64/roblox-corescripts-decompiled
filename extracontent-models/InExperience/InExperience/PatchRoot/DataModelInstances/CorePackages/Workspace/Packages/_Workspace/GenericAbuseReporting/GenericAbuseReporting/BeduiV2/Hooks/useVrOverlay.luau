local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local CoreGui = game:GetService("CoreGui")

local React = require(parent.React)
local Responsive = require(parent.Responsive)

local useIsSpatial = Responsive.useIsSpatial

local function getSyncVrOverlayOrNil()
	local vrCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")

	if vrCentralOverlay then
		return vrCentralOverlay:FindFirstChildWhichIsA("SurfaceGui")
	end

	return nil
end

local function useVrOverlay()
	local v = useIsSpatial()
	local state, setState = React.useState(getSyncVrOverlayOrNil)

	React.useEffect(function()
		if not v then
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
	end, { v, state })

	if v then
		return state, true
	end

	return nil, false
end

return useVrOverlay
