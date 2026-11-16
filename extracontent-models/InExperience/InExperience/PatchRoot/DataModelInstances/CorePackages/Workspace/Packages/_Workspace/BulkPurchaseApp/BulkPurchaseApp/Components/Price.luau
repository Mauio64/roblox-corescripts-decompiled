local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

local function Price(props)
	local localize = NumberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId)
	local formatted = `{getIconRichText(IconName.Robux)} {localize}`

	local element = React.createElement(Text, {
		Text = formatted,
		RichText = true,
		fontStyle = props.fontStyle,
		textStyle = props.textStyle,
		tag = "auto-xy text-align-x-right"
	})

	if props.strikethrough then
		return React.createElement(View, { LayoutOrder = props.LayoutOrder, tag = "auto-xy" }, {
			Content = element,
			Strikethrough = React.createElement(View, {
				backgroundStyle = props.textStyle,
				tag = "position-center-center anchor-center-center size-full-50"
			})
		})
	end

	return React.createElement(View, { LayoutOrder = props.LayoutOrder, tag = "auto-xy" }, {
		Content = element
	})
end

return Price
