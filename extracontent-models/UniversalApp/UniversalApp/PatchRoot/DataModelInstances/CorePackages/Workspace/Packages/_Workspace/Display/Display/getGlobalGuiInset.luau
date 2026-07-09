local GuiService = game:GetService("GuiService")

local function getGlobalGuiInset() -- line: 10
	-- upvalues: GuiService (copy)
	local v3, v4 = GuiService:GetGuiInset()

	return {
		top = v3.Y,
		left = v3.X,
		bottom = v4.Y,
		right = v4.X
	}
end

return getGlobalGuiInset
