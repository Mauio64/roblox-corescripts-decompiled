local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local function RobuxUpsellModalFooter()
	local v5 = useLocalization({
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTerms = "IAPExperience.RobuxUpsell.Text.DisclosureTerms"
	})

	local v6 = useTokens()
	return React.createElement(text, {
		Text = v5.DisclosurePayment .. " " .. v5.DisclosureTerms,
		tag = "content-muted text-caption-small size-full align-x-center padding-top-small"
	}, {
		UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = v6.Typography.CaptionSmall.FontSize
		})
	})
end

return RobuxUpsellModalFooter
