local parent = script.Parent.Parent

local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastTriggered = require(parent.Actions.ToastTriggered)

local function makeVideoCaptureFailedHandler(callback)
	local function videoCaptureFailedHandler(p)
		if p == Enum.VideoCaptureResult.OtherError then
			callback(ToastTriggered(CapturesToastType.VideoCaptureOtherError))
		end
	end

	return videoCaptureFailedHandler
end

return makeVideoCaptureFailedHandler
