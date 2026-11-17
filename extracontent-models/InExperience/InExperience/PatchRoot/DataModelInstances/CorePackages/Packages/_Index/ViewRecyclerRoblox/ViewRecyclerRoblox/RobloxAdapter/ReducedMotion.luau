local GuiService = game:GetService("GuiService")

return {
	isEnabled = function()
		return GuiService.ReducedMotionEnabled
	end
}
