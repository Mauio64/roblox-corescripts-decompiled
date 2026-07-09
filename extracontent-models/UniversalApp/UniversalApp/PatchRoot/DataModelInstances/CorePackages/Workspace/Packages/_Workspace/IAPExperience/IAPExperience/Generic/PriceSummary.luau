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
local FFlagUnifiedPurchaseFlowLowercaseTotalPrice = require(ParentParent.Flags.FFlagUnifiedPurchaseFlowLowercaseTotalPrice)

require(ParentParent.ProductPurchase.PricingTypes)

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagUnifiedPurchaseFlowLowercaseTotalPrice (copy), React (copy), formatNumber (copy), LocalizationService (copy), useRobuxText (copy), View (copy), FoundationText (copy)
	local v14 = if not t1.itemPrice then t1.amount else t1.itemPrice.priceInRobux
	local v15 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not FFlagUnifiedPurchaseFlowLowercaseTotalPrice and "IAPExperience.PurchasePrompt.Label.TotalPrice" or "IAPExperience.PurchasePrompt.Label.TotalPriceV2"
	})
	local v16 = React.useMemo(function() -- line: 42
		-- upvalues: formatNumber (copy), LocalizationService (copy), v14 (copy)
		return utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v14 or 0)
	end, {
		v14,
		LocalizationService.RobloxLocaleId
	})

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v16 = useRobuxText(v14)
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
					Text = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then v15.Total else v15.TotalPrice,
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
					Text = v16
				}) else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
					RichText = true,
					Text = v16
				})
			})
		})
	})
end
