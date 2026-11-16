local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

return function(p)
	if p then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
	elseif VRService.VREnabled then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
	else
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end
end
