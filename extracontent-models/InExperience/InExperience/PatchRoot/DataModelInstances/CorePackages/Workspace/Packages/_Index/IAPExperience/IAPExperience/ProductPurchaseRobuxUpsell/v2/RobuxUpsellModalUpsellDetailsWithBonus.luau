local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local formatNumber = require(ParentParent.Utility.formatNumber)

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
require(ParentParent.Enums.BadgeType)
require(ParentParent.Enums.VirtualItemBadgeType)

local function RobuxUpsellModalUpsellDetailsWithBonus(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy)
	local v12 = useLocalization({
		MoreRobux = "IAPExperience.RobuxUpsell.Text.MoreRobux",
		Bonus = "IAPExperience.RobuxUpsell.Text.Bonus"
	})

	return React.createElement(View, {
		tag = "flex-x-between\tflex-y-fill size-full-1700 radius-medium padding-x-large padding-y-medium row bg-surface-300 stroke-emphasis stroke-standard",
		LayoutOrder = t1.layoutOrder
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "auto-xy col align-y-top align-x-left gap-small"
		}, {
			BonusLabel = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-small content-default",
				Text = v12.MoreRobux
			}),
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-large content-emphasis text-align-x-left",
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.robuxAmount) .. " + " .. formatNumber(LocalizationService.RobloxLocaleId, t1.bonusAmount) .. " " .. v12.Bonus
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-xy row align-y-center align-x-right"
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				tag = "auto-xy text-title-large content-emphasis text-align-x-right",
				Text = t1.priceString or ""
			})
		})
	})
end

return RobuxUpsellModalUpsellDetailsWithBonus
