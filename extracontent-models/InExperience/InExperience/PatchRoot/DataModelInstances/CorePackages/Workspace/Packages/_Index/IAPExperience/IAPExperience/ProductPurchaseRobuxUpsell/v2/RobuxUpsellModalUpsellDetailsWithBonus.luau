local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local formatNumber = require(parent.Utility.formatNumber)

require(parent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
require(parent.Enums.BadgeType)
require(parent.Enums.VirtualItemBadgeType)

local function RobuxUpsellModalUpsellDetailsWithBonus(props)
	local v = useLocalization({
		MoreRobux = "IAPExperience.RobuxUpsell.Text.MoreRobux",
		Bonus = "IAPExperience.RobuxUpsell.Text.Bonus"
	})

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "flex-x-between\tflex-y-fill size-full-1700 radius-medium padding-x-large padding-y-medium row bg-surface-300 stroke-emphasis stroke-standard"
		},
		{
			LeftSide = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "auto-xy col align-y-top align-x-left gap-small" },
				{
					BonusLabel = React.createElement(Text, {
						LayoutOrder = 1,
						Text = v.MoreRobux,
						tag = "auto-xy text-label-small content-default"
					}),
					RobuxAmount = React.createElement(Text, {
						LayoutOrder = 2,
						Text = utf8.char(57346) .. " " .. formatNumber(
							LocalizationService.RobloxLocaleId,
							props.robuxAmount
						) .. " + " .. formatNumber(LocalizationService.RobloxLocaleId, props.bonusAmount) .. " " .. v.Bonus,
						tag = "auto-xy text-title-large content-emphasis text-align-x-left"
					})
				}
			),
			RightSide = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "auto-xy row align-y-center align-x-right" },
				{
					RobuxPrice = React.createElement(Text, {
						Text = props.priceString or "",
						tag = "auto-xy text-title-large content-emphasis text-align-x-right"
					})
				}
			)
		}
	)
end

return RobuxUpsellModalUpsellDetailsWithBonus
