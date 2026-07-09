local ParentParent = script.Parent.Parent
local Foundation = require(ParentParent.Foundation)

local function themeFromBackgroundColor(color3: Color3) -- line: 14
	-- upvalues: Foundation (copy)
	if 0.299 * color3.R + 0.587 * color3.G + 0.114 * color3.B >= 0.5 then
		return Foundation.Enums.Theme.Light
	end

	return Foundation.Enums.Theme.Dark
end

return themeFromBackgroundColor
