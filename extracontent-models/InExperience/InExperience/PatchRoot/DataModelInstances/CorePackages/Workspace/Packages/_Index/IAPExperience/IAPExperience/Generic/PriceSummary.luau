local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local formatNumber = require(ParentParent.Utility.formatNumber)
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local useRobuxText = require(ParentParent.Generic.Hooks.useRobuxText)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

require(ParentParent.ProductPurchase.PricingTypes)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), React (copy), formatNumber (copy), LocalizationService (copy), useRobuxText (copy), View (copy), FoundationText (copy)
	local v13 = if not t1.itemPrice then t1.amount else t1.itemPrice.priceInRobux
	local v14 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "IAPExperience.PurchasePrompt.Label.TotalPriceV2"
	})
	local v15 = React.useMemo(function() -- line: 38
		-- upvalues: formatNumber (copy), LocalizationService (copy), v13 (copy)
		return utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v13 or 0)
	end, {
		v13,
		LocalizationService.RobloxLocaleId
	})

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v15 = useRobuxText(v13)
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
				Size = UDim2.new(0.5, 0, 1, 0)
			}, {
				RobuxAmount = React.createElement(FoundationText, {
					LayoutOrder = 1,
					Text = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then v14.Total else v14.TotalPrice,
					tag = not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall"
				})
			}),
			RightSide = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
				Size = UDim2.new(0.5, 0, 1, 0)
			}, {
				RobuxPrice = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall",
					Text = v15
				}) else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
					RichText = true,
					Text = v15
				})
			})
		})
	})
end
