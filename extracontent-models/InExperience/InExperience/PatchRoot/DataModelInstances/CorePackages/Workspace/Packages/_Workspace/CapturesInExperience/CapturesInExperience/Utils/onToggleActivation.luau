local ParentParent = script.Parent.Parent
local CapturesActivated = require(ParentParent.Actions.CapturesActivated)
local CapturesDeactivated = require(ParentParent.Actions.CapturesDeactivated)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local ToastDismissed = require(ParentParent.Actions.ToastDismissed)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

return function(b1: boolean, n1: number?, p1, p2, p3, p4) -- line: 9
	-- upvalues: CapturesActivated (copy), ToastTriggered (copy), CapturesToastType (copy), CapturesDeactivated (copy), ToastDismissed (copy)
	if (not n1 or n1 == 1) and not b1 then
		p1(p3)
		p2(CapturesActivated())
		p2(ToastTriggered(CapturesToastType.CapturesActivated))

		return
	end

	if b1 then
		p1(p4)
		p2(CapturesDeactivated())
		p2(ToastDismissed())
	end
end
