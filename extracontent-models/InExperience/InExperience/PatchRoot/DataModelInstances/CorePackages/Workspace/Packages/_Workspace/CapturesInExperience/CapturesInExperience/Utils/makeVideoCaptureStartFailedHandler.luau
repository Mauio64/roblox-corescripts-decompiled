local parent = script.Parent.Parent

local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastTriggered = require(parent.Actions.ToastTriggered)

local function makeVideoCaptureStartFailedHandler(callback)
	local function videoCaptureStartFailedHandler(p)
		if p == Enum.VideoCaptureStartedResult.CapturingAlready then
			callback(ToastTriggered(CapturesToastType.VideoCaptureInitializationCapturingAlreadyError))
		elseif p == Enum.VideoCaptureStartedResult.NoDeviceSupport then
			callback(ToastTriggered(CapturesToastType.VideoCaptureInitializationNoDeviceSupportError))
		elseif p == Enum.VideoCaptureStartedResult.NoSpaceOnDevice then
			callback(ToastTriggered(CapturesToastType.VideoCaptureInitializationNoSpaceOnDeviceError))
		elseif p == Enum.VideoCaptureStartedResult.OtherError then
			callback(ToastTriggered(CapturesToastType.VideoCaptureInitializationOtherError))
		end
	end

	return videoCaptureStartFailedHandler
end

return makeVideoCaptureStartFailedHandler
