local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local SharedFlags = require(Parent.SharedFlags)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local getIconRichText = Foundation.Utility.getIconRichText
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function CheckoutTotalLines(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy), FFlagAXMISWithBlackbird (copy), getIconRichText (copy)
	local v10 = useLocalization({
		totalItemsLabel = {
			"Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = t1.itemCount
		}
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = if not FFlagAXMISWithBlackbird then nil else t1.LayoutOrder
	}, {
		TotalLine = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y fill flex-between items-center row gap-small"
		}, {
			ItemCount = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium content-emphasis",
				LayoutOrder = 1,
				Text = v10.totalItemsLabel
			}),
			TotalPrice = React.createElement(Foundation.View, {
				tag = "auto-xy row items-center gap-small",
				LayoutOrder = 2
			}, {
				OriginalPrice = if not t1.totalPrice or (not t1.totalOriginalPrice or not (t1.totalPrice < t1.totalOriginalPrice)) then nil else React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-small content-muted",
					LayoutOrder = 1,
					RichText = true,
					Text = "<s>" .. `{ getIconRichText(Foundation.Enums.IconName.Robux) } { t1.totalOriginalPrice }` .. "</s>"
				}),
				TotalPriceText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-medium content-emphasis",
					LayoutOrder = 2,
					RichText = true,
					Text = `{ getIconRichText(Foundation.Enums.IconName.Robux) } { t1.totalPrice }`
				})
			})
		})
	})
end

return CheckoutTotalLines
