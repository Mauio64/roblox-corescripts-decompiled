local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(ParentParent.Localization).Hooks.useLocalization

local function RobuxUpsellModalFooter() -- line: 16
	-- upvalues: useLocalization (copy), useTokens (copy), React (copy), FoundationText (copy)
	local v8 = useLocalization({
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTerms = "IAPExperience.RobuxUpsell.Text.DisclosureTerms"
	})
	local v9 = useTokens()

	return React.createElement(FoundationText, {
		tag = "content-muted text-caption-small size-full align-x-center padding-top-small",
		Text = v8.DisclosurePayment .. " " .. v8.DisclosureTerms
	}, {
		UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = v9.Typography.CaptionSmall.FontSize
		})
	})
end

return RobuxUpsellModalFooter
