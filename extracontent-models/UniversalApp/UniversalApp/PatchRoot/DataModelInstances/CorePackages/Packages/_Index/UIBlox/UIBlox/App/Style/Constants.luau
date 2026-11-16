local parent = script.Parent.Parent.Parent.Parent
local GetEngineFeatureSafe = require(parent.UIBlox.Core.Utility.GetEngineFeatureSafe)
local engineFeatureSafe = GetEngineFeatureSafe("EnablePreferredTextSizeSetting")

local Constants = {}

Constants.ThemeName = { Dark = "Dark", Light = "Light" }

Constants.FontName = { Gotham = "Gotham", Classic = "Classic" }
Constants.ComicNeueFontFamily = "rbxassetid://127896232205472"
Constants.DeviceType = {
	Desktop = "Desktop",
	Tablet = "Tablet",
	Phone = "Phone",
	Console = "Console",
	VR = "VR",
	Unknown = "Unknown"
}

Constants.Layout = {
	ActionBar = { PositionOffset = 24 }
}

Constants.DefaultThemeName = Constants.ThemeName.Light
Constants.DefaultFontName = Constants.FontName.Gotham
Constants.DefaultDeviceType = Constants.DeviceType.Desktop
local preferredTextSize

if engineFeatureSafe then
	preferredTextSize = Enum.PreferredTextSize.Medium
end

Constants.DefaultSettings = {
	preferredTransparency = 1,
	reducedMotion = false,
	preferredTextSize = preferredTextSize,
	scale = 1
}

return Constants
