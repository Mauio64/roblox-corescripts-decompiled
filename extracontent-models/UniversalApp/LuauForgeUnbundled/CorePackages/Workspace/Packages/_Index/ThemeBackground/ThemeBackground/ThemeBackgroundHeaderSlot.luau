local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/React")

local ThemeBackgroundSlice = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundSlice")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/useThemeBackground")

local function ThemeBackgroundHeaderSlot()
	local v5 = useThemeBackground()

	if v5 then
		return React.createElement(ThemeBackgroundSlice, {
			image = v5.image,
			baseColor = v5.baseColor
		})
	end

	return nil
end

return ThemeBackgroundHeaderSlot
