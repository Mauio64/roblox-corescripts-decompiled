local function isValidFocusTarget(guiBase2d)
	if not guiBase2d then
		return false, "`nil` value provided to isValidFocusTarget"
	end

	if not guiBase2d:IsA("GuiBase2d") then
		return false, string.format("provided Instance is of class %s, which is not a GuiBase2d", guiBase2d.ClassName)
	end

	if not guiBase2d:FindFirstAncestorWhichIsA("LayerCollector") then
		return false, "provided Instance is not a descendant of a LayerCollector like a ScreenGui or SurfaceGui"
	end

	if guiBase2d:FindFirstAncestorWhichIsA("BasePlayerGui") then
		return true
	end

	return false, "provided Instance is not a descendant of a BasePlayerGui like PlayerGui or CoreGui"
end

return isValidFocusTarget
