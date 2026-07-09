local ParentParent = script.Parent.Parent
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

local function makeVideoCaptureStartFailedHandler(p1) -- line: 6
	-- upvalues: ToastTriggered (copy), CapturesToastType (copy)
	local function videoCaptureStartFailedHandler(p2) -- line: 7
		-- upvalues: p1 (copy), ToastTriggered (copy), CapturesToastType (copy)
		if p2 == Enum.VideoCaptureStartedResult.CapturingAlready then
			p1(ToastTriggered(CapturesToastType.VideoCaptureInitializationCapturingAlreadyError))

			return
		end

		if p2 == Enum.VideoCaptureStartedResult.NoDeviceSupport then
			p1(ToastTriggered(CapturesToastType.VideoCaptureInitializationNoDeviceSupportError))

			return
		end

		if p2 == Enum.VideoCaptureStartedResult.NoSpaceOnDevice then
			p1(ToastTriggered(CapturesToastType.VideoCaptureInitializationNoSpaceOnDeviceError))

			return
		end

		if p2 == Enum.VideoCaptureStartedResult.OtherError then
			p1(ToastTriggered(CapturesToastType.VideoCaptureInitializationOtherError))
		end
	end

	return videoCaptureStartFailedHandler
end

return makeVideoCaptureStartFailedHandler
