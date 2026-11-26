local VRService = game:GetService("VRService")

local vRSessionStateChangedConnection = nil

local vrSessionState = VRService.VRSessionState

return function()
	if not vRSessionStateChangedConnection then
		vRSessionStateChangedConnection = VRService:GetPropertyChangedSignal("VRSessionState"):Connect(function()
			if vrSessionState == VRService.VRSessionState then
				return
			end

			if
				vrSessionState == Enum.VRSessionState.Undefined
				and VRService.VRSessionState == Enum.VRSessionState.Focused
			then
				VRService:RecenterUserHeadCFrame()
			end

			vrSessionState = VRService.VRSessionState
		end)
	end
end
