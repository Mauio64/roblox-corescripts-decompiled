local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Divider = Foundation.Divider

local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useRobuxText = require(parent.Generic.Hooks.useRobuxText)
local usePlaceholderLocalization = require(parent.Generic.Hooks.usePlaceholderLocalization)

local PriceLineItem = require(parent.Generic.PriceLineItem)
local DiscountRow = require(parent.Generic.DiscountRow)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
require(parent.ProductPurchase.PricingTypes)
local defineFastFlag = game:DefineFastFlag("PriceSummaryV2UseLocalizedBreakdown", false)

local function shouldShowPriceBreakdown(itemPrice): boolean -- 1 equivalent call inferred from this helper
	if not itemPrice then
		return false
	end

	local basePriceInRobux = itemPrice.basePriceInRobux
	local priceInRobux = itemPrice.priceInRobux

	return typeof(basePriceInRobux) == "number" and typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux
end

local function PriceSummaryV2(props)
	local itemPrice = props.itemPrice
	local v = if itemPrice then itemPrice.priceInRobux else props.amount
	local v2 = shouldShowPriceBreakdown(itemPrice) -- inferred equivalent call
	local v3 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Label.TotalPriceV2" or nil
	})

	local v4 = usePlaceholderLocalization({
		SubtotalLabel = props.subtotalItemCount and {
			"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
			itemCount = props.subtotalItemCount
		} or "IAPExperience.PurchasePrompt.Label.Subtotal",
		TotalLabel = "IAPExperience.PurchasePrompt.Label.Total"
	})

	if defineFastFlag then
		v4 = useLocalization({
			SubtotalLabel = props.subtotalItemCount and {
				"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
				itemCount = props.subtotalItemCount
			} or "IAPExperience.PurchasePrompt.Label.Subtotal",
			TotalLabel = "IAPExperience.PurchasePrompt.Label.Total"
		})
	end

	local v5 = not (v2 and itemPrice) and (v or 0) or itemPrice.basePriceInRobux
	local v6 = useRobuxText(v)
	local amount = useRobuxText(v5 or 0)

	if v2 and itemPrice then
		local layoutOrder = 1
		local children = {}

		children.SubtotalRow = React.createElement(PriceLineItem, {
			label = v4.SubtotalLabel,
			amount = amount,
			LayoutOrder = layoutOrder
		})

		local layoutOrder2 = layoutOrder + 1

		for i, discount in ipairs(itemPrice.discounts) do
			if not (discount.amountInRobux > 0) then
				continue
			end

			children["DiscountRow_" .. tostring(i)] = React.createElement(DiscountRow, {
				discount = discount,
				label = discount.localizedDiscountAttribution,
				LayoutOrder = layoutOrder2
			})

			layoutOrder2 += 1
		end

		children.BreakdownDivider = React.createElement(
			View,
			{
				LayoutOrder = layoutOrder2,
				tag = "col size-full-0 auto-y shrink-0 self-stretch padding-top-small"
			},
			{
				Line = React.createElement(Divider, { tag = "size-full-0 auto-y" })
			}
		)

		local layoutOrder3 = layoutOrder2 + 1

		children.TotalRow = React.createElement(PriceLineItem, {
			label = v4.TotalLabel,
			amount = v6,
			textStyle = "text-title-medium",
			tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-y-xsmall",
			LayoutOrder = layoutOrder3
		})

		return React.createElement(
			View,
			{
				tag = "size-full-0 auto-y padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-xsmall"
			},
			{
				BorderContainer = React.createElement(
					View,
					{
						tag = "col size-full-0 auto-y shrink-0 radius-medium padding-x-large padding-y-small stroke-default gap-xsmall"
					},
					children
				)
			}
		)
	else
		local createElement = React.createElement

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v7 = {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start padding-y-xsmall",
			Size = UDim2.new(0.5, 0, 0, 0)
		}

		local createElement4 = React.createElement
		local text

		if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			text = v3.TotalPrice
		else
			text = v3.Total
		end

		local children = {
			LeftSide = createElement3(View, v7, {
				RobuxAmount = createElement4(Text, {
					LayoutOrder = 1,
					Text = text,
					tag = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall"
				})
			}),
			RightSide = 0
		}

		local createElement5 = React.createElement
		local v8 = {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
			Size = UDim2.new(0.5, 0, 0, 0)
		}
		local robuxPrice

		if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			robuxPrice = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v6,
				tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
				RichText = true
			})
		else
			robuxPrice = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v6,
				tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall"
			})
		end

		children.RightSide = createElement5(View, v8, { RobuxPrice = robuxPrice })
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
end

return PriceSummaryV2
