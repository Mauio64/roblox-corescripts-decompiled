local CorePackages = game:GetService("CorePackages")
local Color = require(CorePackages.Workspace.Packages.AppCommonLib).Color
local t1 = {
	Obsidian = Color.Color3FromHex(1579291),
	Carbon = Color.Color3FromHex(2040099),
	Slate = Color.Color3FromHex(2303271),
	Flint = Color.Color3FromHex(3750717),
	Graphite = Color.Color3FromHex(6645352),
	Pumice = Color.Color3FromHex(12435134),
	Black = Color3.fromRGB(0, 0, 0),
	White = Color3.fromRGB(255, 255, 255),
	Gray1 = Color.Color3FromHex(1644825),
	Gray2 = Color.Color3FromHex(7697781),
	Gray4 = Color.Color3FromHex(14935011),
	GrayBackground = Color.Color3FromHex(14211288),
	Green = Color.Color3FromHex(45167),
	DisabledGreen = Color.Color3FromHex(10273956)
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 25
	end,
	__index = function(_, p5) -- line: 26
		error("Colors table has no value: " .. tostring(p5))
	end
})

return t1
