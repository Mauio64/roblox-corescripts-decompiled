local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

return function(p1) -- line: 6
	-- upvalues: UserInputService (copy), VRService (copy)
	if p1 then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow

		return
	end

	if VRService.VREnabled then
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		return
	end

	UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
end
