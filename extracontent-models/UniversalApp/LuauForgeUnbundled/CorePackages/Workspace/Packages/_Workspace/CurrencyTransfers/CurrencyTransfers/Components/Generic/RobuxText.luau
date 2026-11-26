local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local icon = Foundation.Icon
local view = Foundation.View
local text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens

local GetFFlagCurrencyTransferCenterRobuxIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferCenterRobuxIcon")

local function RobuxText(p2)
	local v5 = React.useMemo(function()
		return formatNumber(LocalizationService.RobloxLocaleId, p2.amount or 0)
	end, { p2.amount, LocalizationService.RobloxLocaleId })

	if not GetFFlagCurrencyTransferCenterRobuxIcon() then
		return React.createElement(
			view,
			{
				tag = "row align-x-center align-y-center auto-xy",
				LayoutOrder = p2.layoutOrder
			},
			{
				RobuxIcon = React.createElement(text, {
					Text = getIconRichText("robux"),
					tag = "auto-xy text-heading-large content-emphasis text-align-x-center",
					RichText = true,
					LayoutOrder = 1
				}),
				Spacer = React.createElement(view, {
					tag = "auto-xy",
					Size = UDim2.new(0, 4, 0, 0),
					LayoutOrder = 2
				}),
				RobuxAmount = React.createElement(text, {
					Text = v5,
					tag = "auto-xy text-display-small content-emphasis text-align-x-center",
					LayoutOrder = 3
				})
			}
		)
	end

	local v6 = useTokens()
	local fontSize = v6.Typography.HeadingLarge.FontSize
	local v7 = math.round(fontSize)
	local fontSize2 = math.round(v6.Typography.DisplaySmall.FontSize)

	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, fontSize2),
			BackgroundTransparency = 1,
			LayoutOrder = p2.layoutOrder
		},
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			IconWrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(v7, fontSize2),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					RobuxIcon = React.createElement(icon, {
						name = "robux",
						size = fontSize,
						style = v6.Color.Content.Emphasis,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 4)
					})
				}
			),
			RobuxAmount = React.createElement(text, {
				Text = v5,
				fontStyle = v6.Typography.DisplaySmall,
				textStyle = v6.Color.Content.Emphasis,
				Size = UDim2.fromOffset(0, fontSize2),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Center,
				LayoutOrder = 2
			})
		}
	)
end

return RobuxText
