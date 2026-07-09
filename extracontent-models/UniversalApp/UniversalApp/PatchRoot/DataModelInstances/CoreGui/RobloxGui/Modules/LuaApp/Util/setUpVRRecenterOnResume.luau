local VRService = game:GetService("VRService")
local connection = nil
local VRSessionState = VRService.VRSessionState

return function() -- line: 7
	-- upvalues: connection (ref), VRService (copy), VRSessionState (ref)
	if not connection then
		connection = VRService:GetPropertyChangedSignal("VRSessionState"):Connect(function() -- line: 9
			-- upvalues: VRSessionState (ref), VRService (copy)
			if VRSessionState == VRService.VRSessionState then
				return
			end

			if VRSessionState == Enum.VRSessionState.Undefined and VRService.VRSessionState == Enum.VRSessionState.Focused then
				VRService:RecenterUserHeadCFrame()
			end

			VRSessionState = VRService.VRSessionState
		end)
	end
end
