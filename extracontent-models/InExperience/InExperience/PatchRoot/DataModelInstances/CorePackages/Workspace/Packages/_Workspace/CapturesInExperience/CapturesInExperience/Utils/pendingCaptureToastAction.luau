local parent = script.Parent.Parent

require(parent.Types)

local v = nil
local PendingCaptureToastAction = {}

function PendingCaptureToastAction.set(p)
	v = p
end

function PendingCaptureToastAction.consume()
	local v2 = v
	v = nil
	return v2
end

return PendingCaptureToastAction
