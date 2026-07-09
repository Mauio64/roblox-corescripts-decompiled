local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local LocalizationService = game:GetService("LocalizationService")
local formatNumber = require(ParentParent.Utility.formatNumber)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local useRobuxText = require(ParentParent.Generic.Hooks.useRobuxText)

local function UnifiedPurchaseModalHeader(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), formatNumber (copy), LocalizationService (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), useRobuxText (copy), View (copy), FoundationText (copy)
	local v13 = React.useMemo(function() -- line: 29
		-- upvalues: formatNumber (copy), LocalizationService (copy), t1 (copy)
		return utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.robuxBalanceAmount or 0)
	end, {
		t1.robuxBalanceAmount,
		LocalizationService.RobloxLocaleId
	})

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v13 = useRobuxText(t1.robuxBalanceAmount or 0)
	end

	return React.createElement(View, {
		tag = "auto-xy align-y-center align-x-start row"
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-default text-align-x-left",
				Text = t1.titleText
			})
		}),
		RightSide = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements or not t1.hideUserRobuxBalance then React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-label-medium content-emphasis text-align-x-right",
				Text = v13,
				RichText = not not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements or nil
			})
		}) else nil
	})
end

return UnifiedPurchaseModalHeader
