local Parent = script:FindFirstAncestor("GameFilters").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function FilterMenuActionBar(t1: {[any]: any}) -- line: 20
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), Button (copy), ButtonType (copy)
	local v11 = useTokens()
	local Surface_100 = v11.Color.Surface.Surface_100
	local v13 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply"
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = t1.LayoutOrder,
		BackgroundTransparency = Surface_100.Transparency,
		BackgroundColor3 = Surface_100.Color3,
		Size = t1.Size
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v11.Radius.Medium)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v11.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v11.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v11.Padding.XXLarge),
			PaddingRight = UDim.new(0, v11.Padding.XXLarge)
		}),
		ApplyButton = React.createElement(Button, {
			buttonType = ButtonType.PrimaryContextual,
			size = UDim2.fromScale(1, 1),
			text = v13.apply,
			isDisabled = not t1.applyEnabled,
			onActivated = t1.onApply
		})
	})
end

return FilterMenuActionBar
