local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local GuiService = game:GetService("GuiService")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")

local udim = UDim2.fromScale(0.344, 0.574)

local udim2 = UDim2.fromScale(0.626, 0.405)

local vector2 = Vector2.new(280, 158)

local function PlusHeroContent(props)
	local v5 = useTokens()
	local v6 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small

	local udim3 = UDim2.fromOffset(
		(v6 and 160 or 280) * v5.Config.UI.Scale,
		(v6 and 90 or 158) * v5.Config.UI.Scale
	)
	local accentPictogram = if FFlagTTOnboardingSheet then props.accentPictogram else nil
	local v7 = Vector2.zero

	local udim4 = UDim2.fromOffset(0, 0)
	local udim5 = UDim.new(0, 0)
	local v8, v9

	if accentPictogram then
		v7 = vector2 * v5.Config.UI.Scale
		v8 = v7.Y * 0.55
		udim4 = UDim2.fromOffset(v8, v8)
		udim5 = UDim.new(0, v8 * 0.044)
		v9 = 0.859375
	else
		v8 = 0
		v9 = 0
	end

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y"
	}
	local v13

	if props.pictogram then
		local createElement2 = React.createElement
		local v17

		if accentPictogram then
			v17 = React.createElement(view, { Size = UDim2.fromOffset(v7.X, v7.Y) }, {
				AccentCard = React.createElement(view, {
					tag = "anchor-center-center",
					Position = udim2,
					Size = udim4,
					Rotation = 15,
					cornerRadius = udim5,
					stroke = {
						Color = v5.Color.Content.Emphasis.Color3,
						Transparency = 0.835,
						Thickness = v8 * 0.012
					},
					ZIndex = 1
				}, {
					Accent = React.createElement(image, {
						Image = accentPictogram.assetId,
						imageStyle = v5.Color.Content.Emphasis,
						ScaleType = Enum.ScaleType.Fit,
						tag = "position-center-center anchor-center-center",
						Size = UDim2.fromScale(0.8, 0.8)
					})
				}),
				PrimaryFill = React.createElement(view, {
					tag = "anchor-center-center bg-surface-100",
					Position = udim,
					Size = udim4,
					Rotation = -15,
					cornerRadius = udim5,
					ZIndex = 2
				}),
				Primary = React.createElement(image, {
					Image = props.pictogram.assetId,
					imageStyle = v5.Color.Content.Emphasis,
					ScaleType = Enum.ScaleType.Fit,
					tag = "anchor-center-center",
					Position = udim,
					Size = UDim2.fromScale(v9, v9),
					ZIndex = 3
				})
			})
		else
			v17 = React.createElement(image, {
				Image = props.pictogram.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = udim3
			})
		end

		v13 = createElement2(view, {
			LayoutOrder = 1,
			tag = "align-x-center size-full-0 auto-y"
		}, {
			PictogramImage = v17
		})
	end

	local v12 = {
		HeroPictogram = v13,
		HeroTitle = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.title,
			tag = {
				["size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"] = v6,
				["size-full-0 auto-y text-heading-large text-wrap text-align-x-left content-emphasis"] = not v6
			},
			RichText = props.titleRichText
		}),
		HeroSubtitle = 0
	}

	local v14 = if props.subtitle then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.subtitle,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
	}) else nil
	v12.HeroSubtitle = v14
	return createElement(view, v11, v12)
end

return PlusHeroContent
