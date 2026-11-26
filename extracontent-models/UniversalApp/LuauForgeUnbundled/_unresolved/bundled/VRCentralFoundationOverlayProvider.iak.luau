local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local function VRCentralFoundationOverlayProvider(p2)
	local state, setState = React.useState(nil)
	local v5 = useIsSpatial()

	React.useEffect(function()
		if v5 then
			local thread = task.spawn(function()
				local vrCentralOverlay = CoreGui:WaitForChild("VRCentralOverlay")
				local centralOverlay_SurfaceGui

				if vrCentralOverlay then
					centralOverlay_SurfaceGui = vrCentralOverlay:WaitForChild("CentralOverlay_SurfaceGui")
				end

				if centralOverlay_SurfaceGui and centralOverlay_SurfaceGui:IsA("SurfaceGui") then
					setState(centralOverlay_SurfaceGui)
				end
			end)

			return function()
				task.cancel(thread)
			end
		end

		setState(nil)
	end, { v5 })

	if not v5 then
		return React.createElement(React.Fragment, nil, p2.children)
	end

	if state then
		return (React.createElement(Foundation.OverlayProvider, { gui = state }, {
			Children = React.createElement(React.Fragment, nil, p2.children)
		}))
	end

	return (React.createElement(React.Fragment))
end

return VRCentralFoundationOverlayProvider
