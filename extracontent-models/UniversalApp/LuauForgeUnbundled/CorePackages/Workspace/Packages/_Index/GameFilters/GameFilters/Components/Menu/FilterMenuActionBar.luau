local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Localization").Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function FilterMenuActionBar(props)
	local v5 = useTokens()

	local surface_100 = v5.Color.Surface.Surface_100

	local v6 = useLocalization({ apply = "CommonUI.Messages.Action.Apply" })

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = surface_100.Transparency,
		BackgroundColor3 = surface_100.Color3,
		BorderSizePixel = 0,
		Size = props.Size
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v5.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v5.Padding.XXLarge),
			PaddingRight = UDim.new(0, v5.Padding.XXLarge)
		}),
		ApplyButton = React.createElement(button, {
			buttonType = buttonType.PrimaryContextual,
			size = UDim2.fromScale(1, 1),
			text = v6.apply,
			isDisabled = not props.applyEnabled,
			onActivated = props.onApply
		})
	})
end

return FilterMenuActionBar
