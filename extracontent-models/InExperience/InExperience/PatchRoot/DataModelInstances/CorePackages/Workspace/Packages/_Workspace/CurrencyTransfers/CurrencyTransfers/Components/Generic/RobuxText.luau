local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens

local GetFFlagCurrencyTransferCenterRobuxIcon = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferCenterRobuxIcon)

local function RobuxText(p)
	local text = React.useMemo(function()
		return formatNumber(LocalizationService.RobloxLocaleId, p.amount or 0)
	end, { p.amount, LocalizationService.RobloxLocaleId })

	if not GetFFlagCurrencyTransferCenterRobuxIcon() then
		return React.createElement(
			View,
			{ tag = "row align-x-center align-y-center auto-xy", LayoutOrder = p.layoutOrder },
			{
				RobuxIcon = React.createElement(Text, {
					Text = getIconRichText("robux"),
					tag = "auto-xy text-heading-large content-emphasis text-align-x-center",
					RichText = true,
					LayoutOrder = 1
				}),
				Spacer = React.createElement(View, {
					tag = "auto-xy",
					Size = UDim2.new(0, 4, 0, 0),
					LayoutOrder = 2
				}),
				RobuxAmount = React.createElement(Text, {
					Text = text,
					tag = "auto-xy text-display-small content-emphasis text-align-x-center",
					LayoutOrder = 3
				})
			}
		)
	end

	local v = useTokens()
	local fontSize = v.Typography.HeadingLarge.FontSize
	local v2 = math.round(fontSize)
	local fontSize2 = math.round(v.Typography.DisplaySmall.FontSize)

	return (React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, fontSize2),
			BackgroundTransparency = 1,
			LayoutOrder = p.layoutOrder
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
					Size = UDim2.fromOffset(v2, fontSize2),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					RobuxIcon = React.createElement(Icon, {
						name = "robux",
						size = fontSize,
						style = v.Color.Content.Emphasis,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 4)
					})
				}
			),
			RobuxAmount = React.createElement(Text, {
				Text = text,
				fontStyle = v.Typography.DisplaySmall,
				textStyle = v.Color.Content.Emphasis,
				Size = UDim2.fromOffset(0, fontSize2),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Center,
				LayoutOrder = 2
			})
		}
	))
end

return RobuxText
