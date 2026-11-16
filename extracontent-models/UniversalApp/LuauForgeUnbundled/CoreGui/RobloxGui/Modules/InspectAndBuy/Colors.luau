local color = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Color

local v5 = {
	Obsidian = color.Color3FromHex(1447705),
	Carbon = color.Color3FromHex(1645341),
	Slate = color.Color3FromHex(2303271),
	Flint = color.Color3FromHex(3750717),
	Graphite = color.Color3FromHex(6645352),
	Pumice = color.Color3FromHex(12435134),
	Black = Color3.fromRGB(0, 0, 0),
	White = Color3.fromRGB(255, 255, 255),
	Gray1 = color.Color3FromHex(1644825),
	Gray2 = color.Color3FromHex(7697781),
	Gray3 = color.Color3FromHex(12105912),
	Gray4 = color.Color3FromHex(14935011),
	Gray5 = color.Color3FromHex(15921906),
	Gray6 = color.Color3FromHex(16119285),
	Alabaster = color.Color3FromHex(15725301),
	Smoke = color.Color3FromHex(8092797),
	Ash = color.Color3FromHex(14935528),
	BluePrimary = color.Color3FromHex(41727),
	BlueHover = color.Color3FromHex(3323391),
	BluePressed = color.Color3FromHex(29885),
	BlueDisabled = color.Color3FromHex(10083071),
	Green = color.Color3FromHex(45167),
	Red = color.Color3FromHex(16206674),
	Green2 = Color3.fromRGB(2, 183, 87),
	Orange = Color3.fromRGB(246, 136, 2),
	BrownWarning = Color3.fromRGB(162, 89, 1),
	ChatTopBarBluePressed = color.Color3FromHex(29886),
	ChatTopBarWhite = color.Color3FromHex(16777214),
	ChatTopBarSlate = color.Color3FromHex(2303272)
}

setmetatable(v5, {
	__newindex = function(p2, p3, p4) end,
	__index = function(p2, p3)
		error("Colors table has no value: " .. tostring(p3))
	end
})

return v5
