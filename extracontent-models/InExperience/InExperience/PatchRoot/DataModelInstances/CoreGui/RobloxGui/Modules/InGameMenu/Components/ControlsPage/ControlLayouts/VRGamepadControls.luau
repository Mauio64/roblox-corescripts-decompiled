local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local InGameMenu = script:FindFirstAncestor("InGameMenu")
local Array = require(CorePackages.Packages.LuauPolyfill).Array
local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local ThemedTextLabel = require(InGameMenu.Components.ThemedTextLabel)
local Assets = require(InGameMenu.Resources.Assets)
local Controls = require(InGameMenu.Resources.Controls)
local React = require(CorePackages.Packages.React)
local withLocalization = require(InGameMenu.Localization.withLocalization)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	ResetCameraLabel = "CoreScripts.InGameMenu.Controls.ResetCameraLabel",
	MenuLabel = "CoreScripts.InGameMenu.Controls.MenuLabel",
	SelectItemLabel = "CoreScripts.InGameMenu.Controls.SelectItemLabel",
	BackExitLabel = "CoreScripts.InGameMenu.Controls.BackExitLabel",
	FirstPersonCameraLabel = "CoreScripts.InGameMenu.Controls.FirstPersonCameraLabel",
	JumpSelectLabel = "CoreScripts.InGameMenu.Controls.JumpSelectLabel"
}

local function GamepadControls(_) -- line: 38
	-- upvalues: Roact (copy), ControlLayoutContainer (copy), ImageSetLabel (copy), Assets (copy), React (copy), Array (copy), Controls (copy), t1 (copy), withLocalization (copy), ThemedTextLabel (copy)
	return Roact.createElement(ControlLayoutContainer, {
		titleText = "CoreScripts.InGameMenu.Controls.GamepadTitle"
	}, {
		GamepadImage = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Assets.Images.GamepadQuest,
			Size = UDim2.new(1, 0, 0.6, 0),
			Position = UDim2.new(0.5, 16.5, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			[React.Tag] = "data-testid=VRGamepadInstructions"
		}, { Array.map(Controls.questGamepadLabels, function(p2, p3) -- line: 51
			-- upvalues: t1 (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
			local v19 = t1[p2.labelKey]

			return withLocalization({ v19 })(function(p4) -- line: 54
				-- upvalues: Roact (copy), ThemedTextLabel (copy), p2 (copy), p3 (copy)
				return Roact.createElement(ThemedTextLabel, {
					fontKey = "Header2",
					themeKey = "TextEmphasis",
					TextScaled = true,
					key = p2.labelKey,
					TextXAlignment = p2.xAlignment or Enum.TextXAlignment.Right,
					Size = UDim2.new(p2.width, 0, 0.026, 0),
					Text = p4[1],
					LayoutOrder = p3,
					Position = UDim2.new(p2.xPosition, 0, p2.yPosition, 0)
				})
			end)
		end) })
	})
end

return GamepadControls
