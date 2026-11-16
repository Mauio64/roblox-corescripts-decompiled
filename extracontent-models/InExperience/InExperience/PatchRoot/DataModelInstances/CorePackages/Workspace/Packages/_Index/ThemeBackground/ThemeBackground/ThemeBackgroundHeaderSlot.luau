local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local ThemeBackgroundSlice = require(parent.ThemeBackgroundSlice)
local useThemeBackground = require(parent.useThemeBackground)

local function ThemeBackgroundHeaderSlot()
	local v = useThemeBackground()

	if v then
		return React.createElement(ThemeBackgroundSlice, {
			image = v.image,
			baseColor = v.baseColor
		})
	end

	return nil
end

return ThemeBackgroundHeaderSlot
