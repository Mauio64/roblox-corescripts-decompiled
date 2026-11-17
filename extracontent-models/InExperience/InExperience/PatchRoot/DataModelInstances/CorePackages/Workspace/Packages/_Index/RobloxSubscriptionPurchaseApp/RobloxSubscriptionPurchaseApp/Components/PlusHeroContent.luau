local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local GuiService = game:GetService("GuiService")
local FFlagTTOnboardingSheet = require(RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet)

local udim = UDim2.fromScale(0.344, 0.574)

local udim2 = UDim2.fromScale(0.626, 0.405)

local vector2 = Vector2.new(280, 158)

local function PlusHeroContent(props)
	local v = useTokens()
	local v2 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small

	local udim3 = UDim2.fromOffset((v2 and 160 or 280) * v.Config.UI.Scale, (v2 and 90 or 158) * v.Config.UI.Scale)
	local accentPictogram

	if FFlagTTOnboardingSheet then
		accentPictogram = props.accentPictogram
	end

	local v3 = Vector2.zero

	local udim4 = UDim2.fromOffset(0, 0)
	local udim5 = UDim.new(0, 0)
	local v4, v5

	if accentPictogram then
		v3 = vector2 * v.Config.UI.Scale
		v4 = v3.Y * 0.55
		udim4 = UDim2.fromOffset(v4, v4)
		udim5 = UDim.new(0, v4 * 0.044)
		v5 = 0.859375
	else
		v4 = 0
		v5 = 0
	end

	local createElement = React.createElement
	local v6 = { LayoutOrder = props.layoutOrder, tag = "col gap-xsmall size-full-0 auto-y" }
	local heroPictogram

	if props.pictogram then
		local createElement2 = React.createElement
		local pictogramImage

		if accentPictogram then
			pictogramImage = React.createElement(View, { Size = UDim2.fromOffset(v3.X, v3.Y) }, {
				AccentCard = React.createElement(View, {
					tag = "anchor-center-center",
					Position = udim2,
					Size = udim4,
					Rotation = 15,
					cornerRadius = udim5,
					stroke = {
						Color = v.Color.Content.Emphasis.Color3,
						Transparency = 0.835,
						Thickness = v4 * 0.012
					},
					ZIndex = 1
				}, {
					Accent = React.createElement(Image, {
						Image = accentPictogram.assetId,
						imageStyle = v.Color.Content.Emphasis,
						ScaleType = Enum.ScaleType.Fit,
						tag = "position-center-center anchor-center-center",
						Size = UDim2.fromScale(0.8, 0.8)
					})
				}),
				PrimaryFill = React.createElement(View, {
					tag = "anchor-center-center bg-surface-100",
					Position = udim,
					Size = udim4,
					Rotation = -15,
					cornerRadius = udim5,
					ZIndex = 2
				}),
				Primary = React.createElement(Image, {
					Image = props.pictogram.assetId,
					imageStyle = v.Color.Content.Emphasis,
					ScaleType = Enum.ScaleType.Fit,
					tag = "anchor-center-center",
					Position = udim,
					Size = UDim2.fromScale(v5, v5),
					ZIndex = 3
				})
			})
		else
			pictogramImage = React.createElement(Image, {
				Image = props.pictogram.assetId,
				imageStyle = v.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = udim3
			})
		end

		heroPictogram = createElement2(View, {
			LayoutOrder = 1,
			tag = "align-x-center size-full-0 auto-y"
		}, {
			PictogramImage = pictogramImage
		})
	end

	local v7 = {
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

	v7.HeroSubtitle = heroSubtitle
	return createElement(View, v6, v7)
end

return PlusHeroContent
