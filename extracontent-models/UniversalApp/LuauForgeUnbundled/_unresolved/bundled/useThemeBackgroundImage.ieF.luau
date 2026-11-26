local module = require("@luauforge/bundled/fBQ")
local module2 = require("@luauforge/bundled/fHL")

local v5 = {
	[module.Halloween2026] = "rbxasset://textures/ui/LuaApp/graphic/home_background_halloween2026.jpg"
}

local function useThemeBackgroundImage()
	local v6 = module2()

	if v6 then
		return v5[v6]
	end

	return nil
end

return useThemeBackgroundImage
