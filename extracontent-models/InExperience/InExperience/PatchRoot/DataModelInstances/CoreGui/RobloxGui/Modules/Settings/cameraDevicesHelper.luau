local VideoCaptureService = game:GetService("VideoCaptureService")
local CameraDevices = nil

VideoCaptureService.DevicesChanged:Connect(function() -- line: 4
	-- upvalues: CameraDevices (ref), VideoCaptureService (copy)
	CameraDevices = VideoCaptureService:GetCameraDevices()
end)

return {
	GetDevices = function() -- line: 8
		-- upvalues: CameraDevices (ref), VideoCaptureService (copy)
		if not CameraDevices then
			CameraDevices = VideoCaptureService:GetCameraDevices()
		end

		return CameraDevices
	end
}
