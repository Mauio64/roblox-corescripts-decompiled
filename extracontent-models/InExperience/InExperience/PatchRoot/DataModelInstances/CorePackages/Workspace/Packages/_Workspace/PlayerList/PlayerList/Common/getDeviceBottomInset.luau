local GuiService = game:GetService("GuiService")

local function getDeviceBottomInset()
	local success, result = pcall(function()
		local insetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
		return GuiService:GetInsetArea(Enum.ScreenInsets.None).Max.Y - insetArea.Max.Y
	end)

	if success and typeof(result) == "number" then
		return (math.max(0, result))
	end

	local success2, _, v = pcall(function()
		return GuiService:GetGuiInset()
	end)

	if success2 and typeof(v) == "Vector2" then
		return (math.max(0, v.Y))
	end

	return 0
end

return getDeviceBottomInset
