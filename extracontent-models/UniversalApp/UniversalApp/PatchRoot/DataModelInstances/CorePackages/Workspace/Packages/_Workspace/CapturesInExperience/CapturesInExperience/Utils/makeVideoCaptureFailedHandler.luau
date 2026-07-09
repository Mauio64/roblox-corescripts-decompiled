local ParentParent = script.Parent.Parent
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

local function makeVideoCaptureFailedHandler(p1) -- line: 6
	-- upvalues: ToastTriggered (copy), CapturesToastType (copy)
	local function videoCaptureFailedHandler(p2) -- line: 7
		-- upvalues: p1 (copy), ToastTriggered (copy), CapturesToastType (copy)
		if p2 == Enum.VideoCaptureResult.OtherError then
			p1(ToastTriggered(CapturesToastType.VideoCaptureOtherError))
		end
	end

	return videoCaptureFailedHandler
end

return makeVideoCaptureFailedHandler
