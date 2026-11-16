local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local view = Foundation.View

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local useRobuxText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useRobuxText")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

return function(p2)
	local v5 = if p2.itemPrice then p2.itemPrice.priceInRobux else p2.amount

	local v6 = useLocalization({
		Total = "Feature.Catalog.Label.TotalUnformatted",
		TotalPrice = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Label.TotalPriceV2" or nil
	})

	local v7 = React.useMemo(function()
		return utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v5 or 0)
	end, { v5, LocalizationService.RobloxLocaleId })

	if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v7 = useRobuxText(v5)
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v14 = {
		LayoutOrder = 1,
		tag = "row gap-small align-y-center align-x-start padding-y-xsmall",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local createElement4 = React.createElement

	local v18 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then v6.TotalPrice else v6.Total
	local children = {
		LeftSide = createElement3(view, v14, {
			RobuxAmount = createElement4(text, {
				LayoutOrder = 1,
				Text = v18,
				tag = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall" or "auto-xy text-label-medium content-default text-align-x-left padding-y-xsmall"
			})
		}),
		RightSide = 0
	}

	local createElement5 = React.createElement
	local v20 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local v22 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(text, {
		LayoutOrder = 2,
		Text = v7,
		tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
		RichText = true
	}) else React.createElement(text, {
		LayoutOrder = 2,
		Text = v7,
		tag = "auto-xy text-label-medium content-emphasis text-align-x-right padding-y-xsmall"
	})
	children.RightSide = createElement5(view, v20, { RobuxPrice = v22 })
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
