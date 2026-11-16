local VideoCaptureService = game:GetService("VideoCaptureService")

local cameraDevices = nil
VideoCaptureService.DevicesChanged:Connect(function()
	cameraDevices = VideoCaptureService:GetCameraDevices()
end)

return {
	GetDevices = function()
		if not cameraDevices then
			cameraDevices = VideoCaptureService:GetCameraDevices()
		end

		return cameraDevices
	end
}
