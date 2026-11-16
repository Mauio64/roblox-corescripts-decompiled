local parent = script.Parent.Parent

local CapturesActivated = require(parent.Actions.CapturesActivated)
local CapturesDeactivated = require(parent.Actions.CapturesDeactivated)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local ToastDismissed = require(parent.Actions.ToastDismissed)
local ToastTriggered = require(parent.Actions.ToastTriggered)

return function(flag: boolean, p: number?, callback, callback2, p2, p3)
	if p and p ~= 1 or flag then
		if flag then
			callback(p3)
			callback2(CapturesDeactivated())
			callback2(ToastDismissed())
		end
	else
		callback(p2)
		callback2(CapturesActivated())
		callback2(ToastTriggered(CapturesToastType.CapturesActivated))
	end
end
