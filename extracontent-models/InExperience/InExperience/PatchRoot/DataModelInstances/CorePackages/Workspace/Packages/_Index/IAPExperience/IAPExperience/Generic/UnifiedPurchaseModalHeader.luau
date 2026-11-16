local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")

local formatNumber = require(parent.Utility.formatNumber)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local useRobuxText = require(parent.Generic.Hooks.useRobuxText)

local function UnifiedPurchaseModalHeader(props)
	local text = React.useMemo(function()
		return utf8.char(57346) .. " " .. formatNumber(
			LocalizationService.RobloxLocaleId,
			props.robuxBalanceAmount or 0
		)
	end, { props.robuxBalanceAmount, LocalizationService.RobloxLocaleId })

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		text = useRobuxText(props.robuxBalanceAmount or 0)
	end

	local createElement = React.createElement

	local v = {
		LeftSide = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxAmount = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.titleText,
					tag = "auto-xy text-heading-small content-default text-align-x-left"
				})
			}
		),
		RightSide = 0
	}
	local rightSide

	if not (FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and props.hideUserRobuxBalance) then
		rightSide = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxPrice = React.createElement(Text, {
					LayoutOrder = 2,
					Text = text,
					tag = "auto-xy text-label-medium content-emphasis text-align-x-right",
					RichText = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and true or nil
				})
			}
		)
	end

	v.RightSide = rightSide
	return createElement(View, { tag = "auto-xy align-y-center align-x-start row" }, v)
end

return UnifiedPurchaseModalHeader
