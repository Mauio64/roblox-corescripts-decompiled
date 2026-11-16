local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function RobuxUpsellModalFooter()
	local v = useLocalization({
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTerms = "IAPExperience.RobuxUpsell.Text.DisclosureTerms"
	})

	local v2 = useTokens()
	return React.createElement(Text, {
		Text = v.DisclosurePayment .. " " .. v.DisclosureTerms,
		tag = "content-muted text-caption-small size-full align-x-center padding-top-small"
	}, {
		UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = v2.Typography.CaptionSmall.FontSize
		})
	})
end

return RobuxUpsellModalFooter
