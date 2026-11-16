local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local GuiService = game:GetService("GuiService")

local function PlusHeroContent(props)
	local v5 = useTokens()
	local v6 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y"
	}

	local v12 = if props.pictogram then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "align-x-center size-full-0 auto-y" },
		{
			PictogramImage = React.createElement(image, {
				Image = props.pictogram.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(
					(v6 and 160 or 280) * v5.Config.UI.Scale,
					(v6 and 90 or 158) * v5.Config.UI.Scale
				)
			})
		}
	) else nil
	local v11 = {
		HeroPictogram = v12,
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

	local v13 = if props.subtitle then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.subtitle,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
	}) else nil
	v11.HeroSubtitle = v13
	return createElement(view, v10, v11)
end

return PlusHeroContent
