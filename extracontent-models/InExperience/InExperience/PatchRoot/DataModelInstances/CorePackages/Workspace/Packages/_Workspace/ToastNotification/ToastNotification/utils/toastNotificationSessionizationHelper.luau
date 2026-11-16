local SessionService = game:GetService("SessionService")
local parent = script.Parent.Parent
local constants = require(parent.constants)
local kind = require(parent.type)

return function(p: string)
	if p == kind.ToastNotificationActionsEnum.Display then
		SessionService:SetSession(
			constants.ToastStructuralIdentifier.Level1,
			constants.ToastStructuralIdentifier.ToastNotification,
			constants.ToastStructuralIdentifier.ToastNotification
		)
	elseif p == kind.ToastNotificationActionsEnum.Dismissed or p == kind.ToastNotificationActionsEnum.Ignored then
		SessionService:RemoveSession(constants.ToastStructuralIdentifier.ToastNotification)
	end
end
