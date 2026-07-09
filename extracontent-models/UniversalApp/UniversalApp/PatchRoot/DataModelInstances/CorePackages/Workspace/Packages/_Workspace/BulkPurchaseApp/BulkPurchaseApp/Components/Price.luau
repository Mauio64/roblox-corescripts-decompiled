local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local NumberLocalization = require(Parent.Localization).NumberLocalization
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

local function Price(t1: {[any]: any}) -- line: 22
	-- upvalues: NumberLocalization (copy), LocalizationService (copy), getIconRichText (copy), IconName (copy), React (copy), FoundationText (copy), View (copy)
	local v12 = NumberLocalization.localize(t1.amount, LocalizationService.RobloxLocaleId)
	local v13 = `{ getIconRichText(IconName.Robux) } { v12 }`
	local v14 = React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy text-align-x-right",
		Text = v13,
		fontStyle = t1.fontStyle,
		textStyle = t1.textStyle
	})

	if t1.strikethrough then
		return React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = t1.LayoutOrder
		}, {
			Content = v14,
			Strikethrough = React.createElement(View, {
				tag = "position-center-center anchor-center-center size-full-50",
				backgroundStyle = t1.textStyle
			})
		})
	end

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.LayoutOrder
	}, {
		Content = v14
	})
end

return Price
