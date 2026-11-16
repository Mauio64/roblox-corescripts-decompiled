local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local view = Foundation.View
local divider = Foundation.Divider

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local useRobuxText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useRobuxText")
local usePlaceholderLocalization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/usePlaceholderLocalization")

local PriceLineItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceLineItem")
local DiscountRow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/DiscountRow")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")
local defineFastFlag = game:DefineFastFlag("PriceSummaryV2UseLocalizedBreakdown", false)

local function shouldShowPriceBreakdown(p2): boolean
	if not p2 then
		return false
	end

	local basePriceInRobux = p2.basePriceInRobux
	local priceInRobux = p2.priceInRobux

	return typeof(basePriceInRobux) == "number"
		and typeof(priceInRobux) == "number"
		and priceInRobux < basePriceInRobux
end

local function PriceSummaryV2(props)
	local itemPrice = props.itemPrice
	local v5 = if itemPrice then itemPrice.priceInRobux else props.amount
	local v6

	if itemPrice then
		local basePriceInRobux = itemPrice.basePriceInRobux
		local priceInRobux = itemPrice.priceInRobux

		if typeof(basePriceInRobux) == "number" and typeof(priceInRobux) == "number" then
			v6 = priceInRobux < basePriceInRobux
		else
			v6 = false
		end
	else
		v6 = false
	end

	local v7 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Label.TotalPriceV2" or nil
	})

	local v8 = usePlaceholderLocalization({
		SubtotalLabel = props.subtotalItemCount and {
			"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
			itemCount = props.subtotalItemCount
		} or "IAPExperience.PurchasePrompt.Label.Subtotal",
		TotalLabel = "IAPExperience.PurchasePrompt.Label.Total"
	})

	if defineFastFlag then
		v8 = useLocalization({
			SubtotalLabel = props.subtotalItemCount and {
				"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
				itemCount = props.subtotalItemCount
			} or "IAPExperience.PurchasePrompt.Label.Subtotal",
			TotalLabel = "IAPExperience.PurchasePrompt.Label.Total"
		})
	end

	local v9 = not (v6 and itemPrice) and (v5 or 0) or itemPrice.basePriceInRobux
	local v10 = useRobuxText(v5)
	local v11 = useRobuxText(v9 or 0)

	if v6 and itemPrice then
		local v12 = 1
		local children = {}

		children.SubtotalRow = React.createElement(PriceLineItem, {
			label = v8.SubtotalLabel,
			amount = v11,
			LayoutOrder = v12
		})

		local v13 = v12 + 1

		for i, discount in ipairs(itemPrice.discounts) do
			if not (discount.amountInRobux > 0) then
				continue
			end

			children["DiscountRow_" .. tostring(i)] = React.createElement(DiscountRow, {
				discount = discount,
				label = discount.localizedDiscountAttribution,
				LayoutOrder = v13
			})

			v13 += 1
		end

		children.BreakdownDivider = React.createElement(
			view,
			{
				LayoutOrder = v13,
				tag = "col size-full-0 auto-y shrink-0 self-stretch padding-top-small"
			},
			{
				Line = React.createElement(divider, { tag = "size-full-0 auto-y" })
			}
		)

		local v14 = v13 + 1

		children.TotalRow = React.createElement(PriceLineItem, {
			label = v8.TotalLabel,
			amount = v10,
			textStyle = "text-title-medium",
			tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-y-xsmall",
			LayoutOrder = v14
		})

		return React.createElement(
			view,
			{
				tag = "size-full-0 auto-y padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-xsmall"
			},
			{
				BorderContainer = React.createElement(
					view,
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
		local v18 = {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start padding-y-xsmall",
			Size = UDim2.new(0.5, 0, 0, 0)
		}

		local createElement4 = React.createElement

		local v22 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then v7.TotalPrice else v7.Total
		local children = {
			LeftSide = createElement3(view, v18, {
				RobuxAmount = createElement4(text, {
					LayoutOrder = 1,
					Text = v22,
					tag = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall"
				})
			}),
			RightSide = 0
		}

		local createElement5 = React.createElement
		local v24 = {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
			Size = UDim2.new(0.5, 0, 0, 0)
		}

		local v26 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(text, {
			LayoutOrder = 2,
			Text = v10,
			tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
			RichText = true
		}) else React.createElement(text, {
			LayoutOrder = 2,
			Text = v10,
			tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall"
		})
		children.RightSide = createElement5(view, v24, { RobuxPrice = v26 })
		return createElement(
			view,
			{
				tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
			},
			{
				BorderContainer = createElement2(
					view,
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
