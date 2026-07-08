local ParentParent = script.Parent.Parent.Parent.Parent
local v2 = require(ParentParent.UIBlox.Core.Utility.GetEngineFeatureSafe)("EnablePreferredTextSizeSetting")
local t1 = {
	ThemeName = {
		Dark = "Dark",
		Light = "Light"
	},
	FontName = {
		Gotham = "Gotham"
	},
	DeviceType = {
		Desktop = "Desktop",
		Tablet = "Tablet",
		Phone = "Phone",
		Console = "Console",
		VR = "VR",
		Unknown = "Unknown"
	},
	Layout = {
		ActionBar = {
			PositionOffset = 24
		}
	}
}

t1.DefaultThemeName = t1.ThemeName.Light
t1.DefaultFontName = t1.FontName.Gotham
t1.DefaultDeviceType = t1.DeviceType.Desktop
t1.DefaultSettings = {
	preferredTransparency = 1,
	reducedMotion = false,
	scale = 1,
	preferredTextSize = if not v2 then nil else Enum.PreferredTextSize.Medium
}

return t1
