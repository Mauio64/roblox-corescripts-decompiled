local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Theme = require(CorePackages.Packages.Foundation).Enums.Theme
local ThemeOverridesBuilder = require(Modules.LuaApp.Themes.ThemeOverridesBuilder)
local RobloxPlusTheme = require(Modules.LuaApp.Themes.RobloxPlusTheme)
local t1 = {
	[RobloxPlusTheme.Green] = {
		[Theme.Dark] = {
			["Surface.Surface_0.Color3"] = Color3.fromHex("#00250D"),
			["Surface.Surface_100.Color3"] = Color3.fromHex("#003514"),
			["Surface.Surface_200.Color3"] = Color3.fromHex("#00451B"),
			["Surface.Surface_300.Color3"] = Color3.fromHex("#015723")
		},
		[Theme.Light] = {
			["Surface.Surface_0.Color3"] = "Color.Extended.Green.Green_200.Color3",
			["Surface.Surface_100.Color3"] = Color3.fromHex("#99E0B0"),
			["Surface.Surface_200.Color3"] = "Color.Extended.Green.Green_200.Color3",
			["Surface.Surface_300.Color3"] = Color3.fromHex("#99E0B0")
		}
	},
	[RobloxPlusTheme.Orange] = {
		[Theme.Dark] = {
			["Surface.Surface_0.Color3"] = Color3.fromHex("#2A1500"),
			["Surface.Surface_100.Color3"] = Color3.fromHex("#3D1F00"),
			["Surface.Surface_200.Color3"] = Color3.fromHex("#50290A"),
			["Surface.Surface_300.Color3"] = Color3.fromHex("#663618")
		},
		[Theme.Light] = {
			["Surface.Surface_0.Color3"] = "Color.Extended.Orange.Orange_200.Color3",
			["Surface.Surface_100.Color3"] = Color3.fromHex("#FFC089"),
			["Surface.Surface_200.Color3"] = "Color.Extended.Orange.Orange_200.Color3",
			["Surface.Surface_300.Color3"] = Color3.fromHex("#FFC089")
		}
	}
}
local t2 = {
	[RobloxPlusTheme.Green] = {
		[Theme.Dark] = {},
		[Theme.Light] = {}
	},
	[RobloxPlusTheme.Orange] = {
		[Theme.Dark] = {},
		[Theme.Light] = {}
	}
}

local function buildThemeMap(p1) -- line: 53
	-- upvalues: Theme (copy), ThemeOverridesBuilder (copy), t1 (copy), t2 (copy)
	return {
		[Theme.Dark] = ThemeOverridesBuilder(Theme.Dark, t1[p1][Theme.Dark], t1[p1][Theme.Light], t2[p1][Theme.Dark]),
		[Theme.Light] = ThemeOverridesBuilder(Theme.Light, t1[p1][Theme.Light], t1[p1][Theme.Dark], t2[p1][Theme.Light])
	}
end

return {
	[RobloxPlusTheme.Green] = buildThemeMap(RobloxPlusTheme.Green),
	[RobloxPlusTheme.Orange] = buildThemeMap(RobloxPlusTheme.Orange)
}
