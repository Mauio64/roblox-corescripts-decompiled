local module = require("@luauforge/deferred/eil")
local imageSetLabel = require("@luauforge/deferred/eiT").Core.ImageSet.ImageSetLabel

local module2 = require("@luauforge/deferred/eiU")
local skeleton = module2.Skeleton

local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local view = module2.View
local text = module2.Text
local icon = module2.Icon
local iconSize = module2.Enums.IconSize

local function AddFriendsGenericBanner(props)
	local layoutOrder = props.layoutOrder
	local maxWidth = props.maxWidth
	local onBannerMounted = props.onBannerMounted
	local onActivated = props.onActivated

	local v5 = props.bannerIcon and true or false
	local bannerIcon = props.bannerIcon

	local bannerTitle = props.bannerTitle
	local bannerText = props.bannerText
	local titleFont = props.titleFont
	local textFont = props.textFont

	local rightCornerButtonIcon = props.rightCornerButtonIcon
	local rightCornerButtonIcon2 = props.rightCornerButtonIcon
	local rightCornerButtonActivated = props.rightCornerButtonActivated

	local bigBottomButton = props.bigBottomButton

	module.useEffect(function()
		if onBannerMounted then
			onBannerMounted()
		end
	end, {})

	local createElement = module.createElement

	local v8 = {
		UISizeConstraint = module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(maxWidth, 1e999)
		}),
		InfoContent = 0,
		BannerButton = 0
	}

	local createElement2 = module.createElement

	local v11 = {
		BannerIconView = v5 and module.createElement(
			view,
			{ tag = "auto-xy padding-y-xsmall padding-x-xsmall", LayoutOrder = 1 },
			{
				BannerIcon = module.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 48, 0, 48),
					Image = bannerIcon
				})
			}
		) or nil,
		TextContent = 0,
		RightCornerButton = 0
	}

	local createElement3 = module.createElement

	local createElement4 = module.createElement

	local v17 = {
		BannerTitle = module.createElement(text, {
			tag = {
				["auto-y size-full-0 text-align-x-left content-emphasis"] = true,
				[titleFont or "text-label-large"] = true
			},
			Text = bannerTitle,
			LayoutOrder = 1
		}),
		BannerText = 0
	}

	local v18 = if props.isLoading then module.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = 2
	}) else module.createElement(text, {
		tag = {
			["auto-y size-full-0 text-align-x-left text-wrap"] = true,
			[textFont or "text-body-small"] = true
		},
		Text = bannerText,
		LayoutOrder = 2
	})
	v17.BannerText = v18
	v11.TextContent = createElement3(view, {
		tag = "auto-xy align-x-left",
		LayoutOrder = 2
	}, {
		TextVertical = createElement4(view, {
			tag = {
				["col size-full-0 auto-y gap-small"] = true,
				["padding-small"] = v5
			}
		}, v17)
	})

	v11.RightCornerButton = rightCornerButtonIcon
		and module.createElement(
			view,
			{
				tag = "auto-xy radius-xsmall",
				LayoutOrder = 3,
				onActivated = rightCornerButtonActivated
			},
			{
				RightCornerButtonIcon = module.createElement(icon, {
					size = iconSize.Large,
					name = rightCornerButtonIcon2
				})
			}
		)
		or nil
	v8.InfoContent = createElement2(view, {
		tag = "size-full-0 auto-y row flex-x-fill gap-medium"
	}, v11)

	local v19 = if bigBottomButton then module.createElement(button, {
		width = UDim.new(1, 0),
		variant = buttonVariant.Standard,
		size = inputSize.Medium,
		text = bigBottomButton.text,
		onActivated = bigBottomButton.onActivated
	}) else nil
	v8.BannerButton = v19
	return createElement(
		view,
		{
			tag = "col size-full-0 auto-y align-x-center radius-medium bg-surface-300 auto-y padding-medium gap-xlarge",
			onActivated = onActivated,
			LayoutOrder = layoutOrder
		},
		v8
	)
end

return AddFriendsGenericBanner
