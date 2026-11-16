local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local formatNumber = require(parent.Utility.formatNumber)

local function RobuxUpsellModalTitle(p)
	local v = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		CurrentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance"
	})

	return React.createElement(View, {
		padding = { right = UDim.new(0, -12), left = UDim.new(0, -12) },
		tag = "size-full-300"
	}, {
		TitleArea = React.createElement(View, { tag = "col gap-xsmall size-full align-x-center" }, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v.NeedMoreRobux,
				tag = "auto-xy text-heading-small content-emphasis"
			}),
			SubTitle = React.createElement(Text, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v.CurrentBalance .. " " .. utf8.char(57346) .. formatNumber(
					LocalizationService.RobloxLocaleId,
					p.balanceAmount
				),
				tag = "auto-xy text-body-medium content-default"
			})
		}),
		CloseButton = React.createElement(IconButton, {
			size = IconSize.Medium,
			icon = "icons/navigation/close",
			onActivated = p.cancelPurchaseActivated
		})
	})
end

return RobuxUpsellModalTitle
