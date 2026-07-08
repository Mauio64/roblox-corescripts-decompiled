local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local CoreGui = game:GetService("CoreGui")
local React = require(Parent.React)
local useIsSpatial = require(Parent.Responsive).useIsSpatial

local function getSyncVrOverlayOrNil() -- line: 10
	-- upvalues: CoreGui (copy)
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")

	if not VRCentralOverlay then
		return nil
	end

	return VRCentralOverlay:FindFirstChildWhichIsA("SurfaceGui")
end
local function useVrOverlay() -- line: 25
	-- upvalues: useIsSpatial (copy), React (copy), getSyncVrOverlayOrNil (copy), CoreGui (copy)
	local v8 = useIsSpatial()
	local v9, v10 = React.useState(getSyncVrOverlayOrNil)

	React.useEffect(function() -- line: 33
		-- upvalues: v8 (copy), v9 (copy), CoreGui (copy), v10 (copy)
		if not v8 then
			return function() -- line: 35
			end
		end

		if v9 then
			return function() -- line: 40
			end
		end

		local thread = task.spawn(function() -- line: 45
			-- upvalues: CoreGui (copy), v10 (copy)
			local VRCentralOverlay = CoreGui:WaitForChild("VRCentralOverlay", 5)

			if not VRCentralOverlay then
				return
			end

			local CentralOverlay_SurfaceGui = VRCentralOverlay:WaitForChild("CentralOverlay_SurfaceGui", 5)

			if CentralOverlay_SurfaceGui then
				v10(CentralOverlay_SurfaceGui)
			end
		end)

		return function() -- line: 56
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v8,
		v9
	})

	if not v8 then
		return nil, false
	end

	return v9, true
end

return useVrOverlay
