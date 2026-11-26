local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Localization").Hooks.useLocalization

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox").Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

return function()
	local v5 = useStyle()
	local v6 = useTokens()
	local fontFace = normalizeFontFace(v6.Typography.TitleLarge.Font)
	local fontSize = v6.Typography.TitleLarge.FontSize
	local v7 = useLocalization({ emptyText = constants.Text.EmptyKey })

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
				Text = v7 and v7.emptyText,
				LayoutOrder = 2,
				FontFace = fontFace,
				TextSize = fontSize,
				BackgroundTransparency = 1,
				TextColor3 = v5.Theme.TextDefault.Color,
				Size = UDim2.new(1, 0, 0, constants.EmptyNotifications.LabelHeight)
			})
		}
	)
end
