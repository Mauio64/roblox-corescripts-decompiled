local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local formatNumber = require(ParentParent.Utility.formatNumber)

local function RobuxUpsellModalTitle(t1: {[any]: any}) -- line: 25
	-- upvalues: useLocalization (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), IconButton (copy), IconSize (copy)
	local v14 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		CurrentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance"
	})

	return React.createElement(View, {
		tag = "size-full-300",
		padding = {
			right = UDim.new(0, -12),
			left = UDim.new(0, -12)
		}
	}, {
		TitleArea = React.createElement(View, {
			tag = "col gap-xsmall size-full align-x-center"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-emphasis",
				Size = UDim2.new(1, 0, 0, 0),
				Text = v14.NeedMoreRobux
			}),
			SubTitle = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-default",
				Size = UDim2.new(1, 0, 0, 0),
				Text = v14.CurrentBalance .. " " .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.balanceAmount)
			})
		}),
		CloseButton = React.createElement(IconButton, {
			icon = "icons/navigation/close",
			size = IconSize.Medium,
			onActivated = t1.cancelPurchaseActivated
		})
	})
end

return RobuxUpsellModalTitle
