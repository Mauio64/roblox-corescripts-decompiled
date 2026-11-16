local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local function RobuxUpsellModalUpsellDetailsWithBonus(props)
	local v5 = useLocalization({
		MoreRobux = "IAPExperience.RobuxUpsell.Text.MoreRobux",
		Bonus = "IAPExperience.RobuxUpsell.Text.Bonus"
	})

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "flex-x-between\tflex-y-fill size-full-1700 radius-medium padding-x-large padding-y-medium row bg-surface-300 stroke-emphasis stroke-standard"
		},
		{
			LeftSide = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "auto-xy col align-y-top align-x-left gap-small"
				},
				{
					BonusLabel = React.createElement(text, {
						LayoutOrder = 1,
						Text = v5.MoreRobux,
						tag = "auto-xy text-label-small content-default"
					}),
					RobuxAmount = React.createElement(text, {
						LayoutOrder = 2,
						Text = utf8.char(57346) .. " " .. formatNumber(
							LocalizationService.RobloxLocaleId,
							props.robuxAmount
						) .. " + " .. formatNumber(LocalizationService.RobloxLocaleId, props.bonusAmount) .. " " .. v5.Bonus,
						tag = "auto-xy text-title-large content-emphasis text-align-x-left"
					})
				}
			),
			RightSide = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "auto-xy row align-y-center align-x-right" },
				{
					RobuxPrice = React.createElement(text, {
						Text = props.priceString or "",
						tag = "auto-xy text-title-large content-emphasis text-align-x-right"
					})
				}
			)
		}
	)
end

return RobuxUpsellModalUpsellDetailsWithBonus
