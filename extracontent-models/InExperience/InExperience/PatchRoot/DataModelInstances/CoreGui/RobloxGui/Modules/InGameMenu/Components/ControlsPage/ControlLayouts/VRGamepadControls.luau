local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox

local InGameMenu = script:FindFirstAncestor("InGameMenu")
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local ThemedTextLabel = require(InGameMenu.Components.ThemedTextLabel)

local Assets = require(InGameMenu.Resources.Assets)
local Controls = require(InGameMenu.Resources.Controls)
local React = require(CorePackages.Packages.React)

local withLocalization = require(InGameMenu.Localization.withLocalization)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local v = {
	ResetCameraLabel = "CoreScripts.InGameMenu.Controls.ResetCameraLabel",
	MenuLabel = "CoreScripts.InGameMenu.Controls.MenuLabel",
	SelectItemLabel = "CoreScripts.InGameMenu.Controls.SelectItemLabel",
	BackExitLabel = "CoreScripts.InGameMenu.Controls.BackExitLabel",
	FirstPersonCameraLabel = "CoreScripts.InGameMenu.Controls.FirstPersonCameraLabel",
	JumpSelectLabel = "CoreScripts.InGameMenu.Controls.JumpSelectLabel"
}

local function GamepadControls(_)
	local createElement = Roact.createElement

	local createElement2 = Roact.createElement
	local v2

	if FFlagCoreUiMigrateUIBloxToFoundation then
		v2 = Image
	else
		v2 = ImageSetLabel
	end

	return createElement(ControlLayoutContainer, {
		titleText = "CoreScripts.InGameMenu.Controls.GamepadTitle"
	}, {
		GamepadImage = createElement2(v2, {
			BackgroundTransparency = not FFlagCoreUiMigrateUIBloxToFoundation and 1 or nil,
			backgroundStyle = FFlagCoreUiMigrateUIBloxToFoundation and { Transparency = 1 } or nil,
			Image = Assets.Images.GamepadQuest,
			Size = UDim2.new(1, 0, 0.6, 0),
			Position = UDim2.new(0.5, 16.5, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			testId = FFlagCoreUiMigrateUIBloxToFoundation and "VRGamepadInstructions" or nil,
			[React.Tag] = not FFlagCoreUiMigrateUIBloxToFoundation and "data-testid=VRGamepadInstructions" or nil
		}, { Array.map(Controls.questGamepadLabels, function(data, layoutOrder)
				return withLocalization({ v[data.labelKey] })(function(list)
					return Roact.createElement(ThemedTextLabel, {
						key = data.labelKey,
						fontKey = "Header2",
						themeKey = "TextEmphasis",
						TextXAlignment = data.xAlignment or Enum.TextXAlignment.Right,
						Size = UDim2.new(data.width, 0, 0.026, 0),
						Text = list[1],
						LayoutOrder = layoutOrder,
						Position = UDim2.new(data.xPosition, 0, data.yPosition, 0),
						TextScaled = true
					})
				end)
			end) })
	})
end

return GamepadControls
