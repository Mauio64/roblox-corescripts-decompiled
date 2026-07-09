local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial

local function VRCentralFoundationOverlayProvider(t1: {[any]: any}) -- line: 8
	-- upvalues: React (copy), useIsSpatial (copy), CoreGui (copy), Foundation (copy)
	local v8, v9 = React.useState(nil)
	local v10 = useIsSpatial()

	React.useEffect(function() -- line: 12
		-- upvalues: v10 (copy), v9 (copy), CoreGui (copy)
		if not v10 then
			v9(nil)

			return
		end

		local thread = task.spawn(function() -- line: 18
			-- upvalues: CoreGui (copy), v9 (copy)
			local VRCentralOverlay = CoreGui:WaitForChild("VRCentralOverlay")
			local v13 = if not VRCentralOverlay then nil else VRCentralOverlay:WaitForChild("CentralOverlay_SurfaceGui")

			if v13 and v13:IsA("SurfaceGui") then
				v9(v13)
			end
		end)

		return function() -- line: 28
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, { v10 })

	if not v10 then
		return React.createElement(React.Fragment, nil, t1.children)
	end

	if v8 then
		return (React.createElement(Foundation.OverlayProvider, {
			gui = v8
		}, {
			Children = React.createElement(React.Fragment, nil, t1.children)
		}))
	end

	return (React.createElement(React.Fragment))
end

return VRCentralFoundationOverlayProvider
