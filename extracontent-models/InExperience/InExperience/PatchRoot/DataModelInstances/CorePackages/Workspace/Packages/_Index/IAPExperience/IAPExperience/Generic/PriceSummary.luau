local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local Text = Foundation.Text
local View = Foundation.View

local formatNumber = require(parent.Utility.formatNumber)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useRobuxText = require(parent.Generic.Hooks.useRobuxText)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

require(parent.ProductPurchase.PricingTypes)

return function(p)
	local v

	if p.itemPrice then
		v = p.itemPrice.priceInRobux
	else
		v = p.amount
	end

	local v2 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Label.TotalPriceV2" or nil
	})

	local text = React.useMemo(function()
		return utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v or 0)
	end, { v, LocalizationService.RobloxLocaleId })

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		text = useRobuxText(v)
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = "row gap-small align-y-center align-x-start padding-y-xsmall",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local createElement4 = React.createElement
	local text2

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		text2 = v2.TotalPrice
	else
		text2 = v2.Total
	end

	local children = {
		LeftSide = createElement3(View, v3, {
			RobuxAmount = createElement4(Text, {
				LayoutOrder = 1,
				Text = text2,
				tag = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall"
			})
		}),
		RightSide = 0
	}

	local createElement5 = React.createElement
	local v4 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local robuxPrice

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		robuxPrice = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
			RichText = true
		})
	else
		robuxPrice = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall"
		})
	end

	children.RightSide = createElement5(View, v4, { RobuxPrice = robuxPrice })
	return createElement(
		View,
		{
			tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
		},
		{
			BorderContainer = createElement2(
				View,
				{
					tag = "auto-xy align-y-center align-x-center radius-medium padding-x-large row stroke-default padding-y-xsmall"
				},
				children
			)
		}
	)
end
