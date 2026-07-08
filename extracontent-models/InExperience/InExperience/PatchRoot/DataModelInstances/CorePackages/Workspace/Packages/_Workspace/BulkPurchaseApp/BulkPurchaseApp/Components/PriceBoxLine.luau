local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local Foundation = require(BulkPurchaseAppParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local PriceBoxLineLayout = require(script.Parent.PriceBoxLineLayout)
local Price = require(script.Parent.Price)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)

local function PriceBoxLine(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), PriceBoxLineVariantEnum (copy), React (copy), PriceBoxLineLayout (copy), FoundationText (copy), View (copy), Price (copy)
	local v13 = useTokens()
	local t2 = {
		LineHeight = v13.Typography.BodyLarge.LineHeight,
		FontSize = v13.Typography.BodyLarge.FontSize,
		Font = if t1.variant ~= PriceBoxLineVariantEnum.Danger then v13.Typography.BodyLarge.Font else v13.Typography.TitleLarge.Font
	}
	local Default = v13.Color.Content.Default

	if t1.variant == PriceBoxLineVariantEnum.Highlight then
		Default = v13.Color.Content.Emphasis
	elseif t1.variant == PriceBoxLineVariantEnum.Danger then
		Default = v13.Color.System.Alert
	end

	return React.createElement(PriceBoxLineLayout, {
		LayoutOrder = t1.LayoutOrder,
		startSlot = React.createElement(FoundationText, {
			tag = "auto-xy",
			fontStyle = t2,
			textStyle = Default,
			Text = t1.text
		}),
		endSlot = if not t1.originalPrice then React.createElement(Price, {
			textStyle = Default,
			fontStyle = t2,
			amount = t1.amount
		}) else React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy"
		}, {
			OriginalPrice = React.createElement(Price, {
				strikethrough = true,
				LayoutOrder = 1,
				textStyle = Default,
				fontStyle = t2,
				amount = t1.originalPrice
			}),
			CurrentPrice = React.createElement(Price, {
				LayoutOrder = 2,
				textStyle = Default,
				fontStyle = t2,
				amount = t1.amount
			})
		})
	})
end

return PriceBoxLine
