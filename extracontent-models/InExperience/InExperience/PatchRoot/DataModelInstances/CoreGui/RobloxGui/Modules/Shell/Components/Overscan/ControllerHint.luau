local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local GlobalSettings = require(Modules.Shell.GlobalSettings)
local LocalizedStrings = require(Modules.Shell.LocalizedStrings)
local FFlagAppShellMigrateLocales = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppShellMigrateLocales

return function(_) -- line: 11
	-- upvalues: Roact (copy), GlobalSettings (copy), FFlagAppShellMigrateLocales (copy), LocalizedStrings (copy)
	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/Controller@1080.png",
		Size = UDim2.new(0, 599, 0, 404),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		Line = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 240, 0, 1),
			Position = UDim2.new(0, 437, 0, 220),
			BackgroundColor3 = Color3.new(1, 1, 1)
		}, {
			InputHint = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(1, 3, 0, -1),
				Font = GlobalSettings.RegularFont,
				FontSize = GlobalSettings.ButtonSize,
				TextColor3 = GlobalSettings.WhiteTextColor,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ResizeScreenInputHint") else LocalizedStrings:LocStringUA("Xbox.Old.ResizeScreenInputHint")
			})
		})
	})
end
