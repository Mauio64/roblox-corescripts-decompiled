local parent = script.Parent.Parent

local Foundation = require(parent.Foundation)

local function themeFromBackgroundColor(color: Color3)
	if 0.299 * color.R + 0.587 * color.G + 0.114 * color.B >= 0.5 then
		return Foundation.Enums.ColorMode.Light
	end

	return Foundation.Enums.ColorMode.Dark
end

return themeFromBackgroundColor
