local GuiService = game:GetService("GuiService")

return function() -- line: 4
	-- upvalues: GuiService (copy)
	return GuiService:FindFirstChildWhichIsA("ScreenshotHud")
end
