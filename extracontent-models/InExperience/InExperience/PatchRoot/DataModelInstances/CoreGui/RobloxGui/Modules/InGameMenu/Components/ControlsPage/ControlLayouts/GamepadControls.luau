local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent.Parent.Parent
local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local Assets = require(ParentParent.Resources.Assets)
local Controls = require(ParentParent.Resources.Controls)
local React = require(CorePackages.Packages.React)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v16 = #Controls.gamepadLabels.right * 43 + 62

local function verticalControlsList(p1) -- line: 47
	-- upvalues: withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	return withLocalization(p1.controls)(function(p2) -- line: 48
		-- upvalues: Roact (copy), ThemedTextLabel (copy), p1 (copy)
		local t1 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 21)
			})
		}

		for i, v in ipairs(p2) do
			t1["controlLabel_" .. i] = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				TextXAlignment = p1.TextXAlignment,
				Size = UDim2.new(0, 1, 0, 22),
				Text = v,
				LayoutOrder = i
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = p1.Position,
			Size = UDim2.new(0, 0, 1, 0)
		}, t1)
	end)
end
local function GamepadControls(p3) -- line: 76
	-- upvalues: UserInputService (copy), Roact (copy), ControlLayoutContainer (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), ImageSetLabel (copy), Assets (copy), React (copy), verticalControlsList (copy), Controls (copy), v16 (copy)
	local Platform = UserInputService:GetPlatform()
	local v22 = Platform == Enum.Platform.XBox360 or Platform == Enum.Platform.XBoxOne

	return Roact.createElement(ControlLayoutContainer, {
		titleText = "CoreScripts.InGameMenu.Controls.GamepadTitle",
		closeButtonRef = p3.closeButtonRef
	}, {
		GamepadImage = Roact.createElement(if not FFlagCoreUiMigrateUIBloxToFoundation then ImageSetLabel else Image, {
			BackgroundTransparency = not FFlagCoreUiMigrateUIBloxToFoundation and 1 or nil,
			backgroundStyle = if not FFlagCoreUiMigrateUIBloxToFoundation then nil else {
				Transparency = 1
			},
			Image = v22 and Assets.Images.GamepadXbox or Assets.Images.Gamepad,
			Size = UDim2.new(0, 473, 0, 465),
			Position = UDim2.new(0.5, 16.5, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			testId = if not FFlagCoreUiMigrateUIBloxToFoundation then nil else "GamepadInstructions",
			[React.Tag] = not FFlagCoreUiMigrateUIBloxToFoundation and "data-testid=GamepadInstructions" or nil
		}, {
			LeftControlsList = Roact.createElement(verticalControlsList, {
				TextXAlignment = Enum.TextXAlignment.Right,
				Position = UDim2.new(0, -26, 0, 62),
				controls = Controls.gamepadLabels.left
			}),
			RightControlsList = Roact.createElement(verticalControlsList, {
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(1, -7, 0, 62),
				controls = Controls.gamepadLabels.right
			}),
			RightIconsControlslIst = Roact.createElement(verticalControlsList, {
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(1, 26, 0, v16),
				controls = Controls.gamepadLabels.camera
			})
		})
	})
end

return GamepadControls
