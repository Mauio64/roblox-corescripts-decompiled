local function isValidFocusTarget(p1) -- line: 1
	if not p1 then
		return false, "`nil` value provided to isValidFocusTarget"
	end

	if not p1:IsA("GuiBase2d") then
		return false, string.format("provided Instance is of class %s, which is not a GuiBase2d", p1.ClassName)
	end

	if not p1:FindFirstAncestorWhichIsA("LayerCollector") then
		return false, "provided Instance is not a descendant of a LayerCollector like a ScreenGui or SurfaceGui"
	end

	if not p1:FindFirstAncestorWhichIsA("BasePlayerGui") then
		return false, "provided Instance is not a descendant of a BasePlayerGui like PlayerGui or CoreGui"
	end

	return true
end

return isValidFocusTarget
