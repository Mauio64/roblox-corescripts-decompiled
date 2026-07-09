local SessionService = game:GetService("SessionService")
local ParentParent = script.Parent.Parent
local constants = require(ParentParent.constants)
local type = require(ParentParent.type)

return function(s1: string) -- line: 6
	-- upvalues: type (copy), SessionService (copy), constants (copy)
	if s1 == type.ToastNotificationActionsEnum.Display then
		SessionService:SetSession(constants.ToastStructuralIdentifier.Level1, constants.ToastStructuralIdentifier.ToastNotification, constants.ToastStructuralIdentifier.ToastNotification)

		return
	end

	if s1 == type.ToastNotificationActionsEnum.Dismissed or s1 == type.ToastNotificationActionsEnum.Ignored then
		SessionService:RemoveSession(constants.ToastStructuralIdentifier.ToastNotification)
	end
end
