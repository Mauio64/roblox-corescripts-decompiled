local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

return function()
	local v = useStyle()
	local v2 = useTokens()
	local fontFace = normalizeFontFace(v2.Typography.TitleLarge.Font)
	local fontSize = v2.Typography.TitleLarge.FontSize
	local v3 = useLocalization({ emptyText = constants.Text.EmptyKey })

	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, constants.DefaultPadding)
			}),
			React.createElement("TextLabel", {
				Text = v3 and v3.emptyText,
				LayoutOrder = 2,
				FontFace = fontFace,
				TextSize = fontSize,
				BackgroundTransparency = 1,
				TextColor3 = v.Theme.TextDefault.Color,
				Size = UDim2.new(1, 0, 0, constants.EmptyNotifications.LabelHeight)
			})
		}
	)
end
