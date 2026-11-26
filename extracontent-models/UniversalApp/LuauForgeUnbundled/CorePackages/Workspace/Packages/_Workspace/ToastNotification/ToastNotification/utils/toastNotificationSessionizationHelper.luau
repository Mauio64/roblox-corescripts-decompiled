local SessionService = game:GetService("SessionService")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")

return function(p2)
	if p2 == module2.ToastNotificationActionsEnum.Display then
		SessionService:SetSession(
			constants.ToastStructuralIdentifier.Level1,
			constants.ToastStructuralIdentifier.ToastNotification,
			constants.ToastStructuralIdentifier.ToastNotification
		)
	elseif
		p2 == module2.ToastNotificationActionsEnum.Dismissed
		or p2 == module2.ToastNotificationActionsEnum.Ignored
	then
		SessionService:RemoveSession(constants.ToastStructuralIdentifier.ToastNotification)
	end
end
