local parent = script:FindFirstAncestor("GameFilters").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function FilterMenuActionBar(props)
	local v = useTokens()

	local surface_100 = v.Color.Surface.Surface_100

	local v2 = useLocalization({ apply = "CommonUI.Messages.Action.Apply" })

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = surface_100.Transparency,
		BackgroundColor3 = surface_100.Color3,
		BorderSizePixel = 0,
		Size = props.Size
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) }),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v.Padding.XXLarge),
			PaddingRight = UDim.new(0, v.Padding.XXLarge)
		}),
		ApplyButton = React.createElement(Button, {
			buttonType = ButtonType.PrimaryContextual,
			size = UDim2.fromScale(1, 1),
			text = v2.apply,
			isDisabled = not props.applyEnabled,
			onActivated = props.onApply
		})
	})
end

return FilterMenuActionBar
