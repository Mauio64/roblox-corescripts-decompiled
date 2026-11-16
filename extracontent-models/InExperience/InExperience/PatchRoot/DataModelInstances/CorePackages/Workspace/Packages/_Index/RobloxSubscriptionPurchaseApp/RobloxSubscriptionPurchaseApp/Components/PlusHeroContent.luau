local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local GuiService = game:GetService("GuiService")

local function PlusHeroContent(props)
	local v = useTokens()
	local v2 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small
	local v3 = v2 and 160 or 280
	local v4 = v2 and 90 or 158
	local createElement = React.createElement
	local v5 = { LayoutOrder = props.layoutOrder, tag = "col gap-xsmall size-full-0 auto-y" }
	local heroPictogram

	if props.pictogram then
		heroPictogram = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center size-full-0 auto-y"
		}, {
			PictogramImage = React.createElement(Image, {
				Image = props.pictogram.assetId,
				imageStyle = v.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(v3 * v.Config.UI.Scale, v4 * v.Config.UI.Scale)
			})
		})
	end

	local v6 = {
		HeroPictogram = heroPictogram,
		HeroTitle = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.title,
			tag = {
				["size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"] = v2,
				["size-full-0 auto-y text-heading-large text-wrap text-align-x-left content-emphasis"] = not v2
			},
			RichText = props.titleRichText
		}),
		HeroSubtitle = 0
	}
	local heroSubtitle

	if props.subtitle then
		heroSubtitle = React.createElement(Text, {
			LayoutOrder = 3,
			Text = props.subtitle,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	v6.HeroSubtitle = heroSubtitle
	return createElement(View, v5, v6)
end

return PlusHeroContent
