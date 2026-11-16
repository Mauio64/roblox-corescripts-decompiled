local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local view = Foundation.View

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local function RobuxUpsellModalTitle(p2)
	local v5 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		CurrentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance"
	})

	return React.createElement(view, {
		padding = { right = UDim.new(0, -12), left = UDim.new(0, -12) },
		tag = "size-full-300"
	}, {
		TitleArea = React.createElement(view, {
			tag = "col gap-xsmall size-full align-x-center"
		}, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v5.NeedMoreRobux,
				tag = "auto-xy text-heading-small content-emphasis"
			}),
			SubTitle = React.createElement(text, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v5.CurrentBalance .. " " .. utf8.char(57346) .. formatNumber(
					LocalizationService.RobloxLocaleId,
					p2.balanceAmount
				),
				tag = "auto-xy text-body-medium content-default"
			})
		}),
		CloseButton = React.createElement(iconButton, {
			size = iconSize.Medium,
			icon = "icons/navigation/close",
			onActivated = p2.cancelPurchaseActivated
		})
	})
end

return RobuxUpsellModalTitle
