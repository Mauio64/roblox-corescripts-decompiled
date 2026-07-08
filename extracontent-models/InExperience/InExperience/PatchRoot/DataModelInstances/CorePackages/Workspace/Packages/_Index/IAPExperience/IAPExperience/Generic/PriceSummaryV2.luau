local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Divider = Foundation.Divider
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local useRobuxText = require(ParentParent.Generic.Hooks.useRobuxText)
local usePlaceholderLocalization = require(ParentParent.Generic.Hooks.usePlaceholderLocalization)
local PriceLineItem = require(ParentParent.Generic.PriceLineItem)
local DiscountRow = require(ParentParent.Generic.DiscountRow)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagUnifiedPurchaseFlowLowercaseTotalPrice = require(ParentParent.Flags.FFlagUnifiedPurchaseFlowLowercaseTotalPrice)
local FFlagPurchasePromptFetchCartPricing = require(ParentParent.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing

require(ParentParent.ProductPurchase.PricingTypes)

local v16 = game:DefineFastFlag("PriceSummaryV2UseLocalizedBreakdown", false)

local function shouldShowPriceBreakdown(p1) -- line: 47
	if not p1 then
		return false
	end

	local basePriceInRobux = p1.basePriceInRobux
	local priceInRobux = p1.priceInRobux

	return typeof(basePriceInRobux) == "number" and (typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux)
end
local function PriceSummaryV2(t1: {[any]: any}) -- line: 58
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagUnifiedPurchaseFlowLowercaseTotalPrice (copy), usePlaceholderLocalization (copy), v16 (copy), useRobuxText (copy), React (copy), PriceLineItem (copy), DiscountRow (copy), FFlagPurchasePromptFetchCartPricing (copy), View (copy), Divider (copy), FoundationText (copy)
	local itemPrice = t1.itemPrice
	local v24 = if not itemPrice then t1.amount else itemPrice.priceInRobux
	local v25

	if not itemPrice then
		v25 = false
	else
		local basePriceInRobux = itemPrice.basePriceInRobux
		local priceInRobux = itemPrice.priceInRobux

		v25 = typeof(basePriceInRobux) == "number" and (typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux)
	end

	local v28 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not FFlagUnifiedPurchaseFlowLowercaseTotalPrice and "IAPExperience.PurchasePrompt.Label.TotalPrice" or "IAPExperience.PurchasePrompt.Label.TotalPriceV2"
	})
	local v29 = usePlaceholderLocalization({
		TotalLabel = "IAPExperience.PurchasePrompt.Label.Total",
		SubtotalLabel = not t1.subtotalItemCount and "IAPExperience.PurchasePrompt.Label.Subtotal" or {
			"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
			itemCount = t1.subtotalItemCount
		}
	})

	if v16 then
		v29 = useLocalization({
			TotalLabel = "IAPExperience.PurchasePrompt.Label.Total",
			SubtotalLabel = not t1.subtotalItemCount and "IAPExperience.PurchasePrompt.Label.Subtotal" or {
				"IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount",
				itemCount = t1.subtotalItemCount
			}
		})
	end

	local v30 = if not v25 or not itemPrice then v24 or 0 else itemPrice.basePriceInRobux
	local v31 = useRobuxText(v24)
	local v32 = useRobuxText(v30 or 0)

	if v25 and itemPrice then
		local t2 = {}
		local n1 = 1

		t2.SubtotalRow = React.createElement(PriceLineItem, {
			label = v29.SubtotalLabel,
			amount = v32,
			LayoutOrder = n1
		})

		local v35 = n1 + 1

		for i, v in ipairs(itemPrice.discounts) do
			if v.amountInRobux > 0 then
				t2["DiscountRow_" .. tostring(i)] = React.createElement(DiscountRow, {
					discount = v,
					label = if not FFlagPurchasePromptFetchCartPricing then nil else v.localizedDiscountAttribution,
					LayoutOrder = v35
				})
				v35 += 1
			end
		end

		t2.BreakdownDivider = React.createElement(View, {
			tag = "col size-full-0 auto-y shrink-0 self-stretch padding-top-small",
			LayoutOrder = v35
		}, {
			Line = React.createElement(Divider, {
				tag = "size-full-0 auto-y"
			})
		})

		local v38 = v35 + 1

		t2.TotalRow = React.createElement(PriceLineItem, {
			textStyle = "text-title-medium",
			tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-y-xsmall",
			label = v29.TotalLabel,
			amount = v31,
			LayoutOrder = v38
		})

		return React.createElement(View, {
			tag = "size-full-0 auto-y padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-xsmall"
		}, {
			BorderContainer = React.createElement(View, {
				tag = "col size-full-0 auto-y shrink-0 radius-medium padding-x-large padding-y-small stroke-default gap-xsmall"
			}, t2)
		})
	end

	return React.createElement(View, {
		tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
	}, {
		BorderContainer = React.createElement(View, {
			tag = "auto-xy align-y-center align-x-center radius-medium padding-x-large row stroke-default padding-y-xsmall"
		}, {
			LeftSide = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start padding-y-xsmall",
				Size = UDim2.new(0.5, 0, 0, 0)
			}, {
				RobuxAmount = React.createElement(FoundationText, {
					LayoutOrder = 1,
					Text = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then v28.Total else v28.TotalPrice,
					tag = not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall"
				})
			}),
			RightSide = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
				Size = UDim2.new(0.5, 0, 0, 0)
			}, {
				RobuxPrice = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall",
					Text = v31
				}) else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
					RichText = true,
					Text = v31
				})
			})
		})
	})
end

return PriceSummaryV2
