local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent.Parent.Parent

local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local Assets = require(parent.Resources.Assets)
local Controls = require(parent.Resources.Controls)
local React = require(CorePackages.Packages.React)

local withLocalization = require(parent.Localization.withLocalization)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local v = #Controls.gamepadLabels.right * 43 + 62

local function verticalControlsList(data)
	return withLocalization(data.controls)(function(list)
		local children = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 21)
			})
		}

		for i, item in ipairs(list) do
			children["controlLabel_" .. i] = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				TextXAlignment = data.TextXAlignment,
				Size = UDim2.new(0, 1, 0, 22),
				Text = item,
				LayoutOrder = i
			})
		end

		return Roact.createElement(
			"Frame",
			{ Position = data.Position, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1 },
			children
		)
	end)
end

local function GamepadControls(p)
	local platform = UserInputService:GetPlatform()
	local v2 = platform == Enum.Platform.XBox360 or platform == Enum.Platform.XBoxOne

	local createElement = Roact.createElement
	local v3 = {
		titleText = "CoreScripts.InGameMenu.Controls.GamepadTitle",
		closeButtonRef = p.closeButtonRef
	}

	local createElement2 = Roact.createElement
	local v4

	if FFlagCoreUiMigrateUIBloxToFoundation then
		v4 = Image
	else
		v4 = ImageSetLabel
	end

	return createElement(ControlLayoutContainer, v3, {
		GamepadImage = createElement2(v4, {
			BackgroundTransparency = not FFlagCoreUiMigrateUIBloxToFoundation and 1 or nil,
			backgroundStyle = FFlagCoreUiMigrateUIBloxToFoundation and { Transparency = 1 } or nil,
			Image = v2 and Assets.Images.GamepadXbox or Assets.Images.Gamepad,
			Size = UDim2.new(0, 473, 0, 465),
			Position = UDim2.new(0.5, 16.5, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			testId = FFlagCoreUiMigrateUIBloxToFoundation and "GamepadInstructions" or nil,
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
				Position = UDim2.new(1, 26, 0, v),
				controls = Controls.gamepadLabels.camera
			})
		})
	})
end

return GamepadControls
