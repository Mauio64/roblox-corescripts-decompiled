local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Gifting = require(parent.Gifting)
local InfoTooltip = Gifting.Components.InfoTooltip

local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens

local function robuxText(p: string) -- 2 equivalent calls inferred from this helper
	return `{getIconRichText(IconName.Robux)} {p}`
end

local function AvatarGiftInfoPanelView(props)
	local v = useTokens()
	local priceText = props.priceText
	local originalPriceText = props.originalPriceText
	local pricingNote = props.pricingNote
	local thumbnailSize = props.thumbnailSize or v.Size.Size_1600

	local createElement = React.createElement
	local v2 = {
		tag = "col align-x-center gap-small size-full-0 auto-y padding-large radius-large bg-shift-100",
		testId = "AvatarGiftInfoPanelView",
		LayoutOrder = props.LayoutOrder
	}
	local v3 = {
		Thumbnail = React.createElement(Image, {
			Image = props.thumbnailUrl,
			Size = UDim2.fromOffset(thumbnailSize, thumbnailSize),
			tag = "aspect-1-1",
			testId = "avatar-gift-info-panel-thumbnail",
			LayoutOrder = 1
		}),
		Details = 0
	}

	local createElement2 = React.createElement

	local v4 = {
		Title = React.createElement(Text, {
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis",
			Text = props.itemName,
			testId = "avatar-gift-info-panel-title",
			LayoutOrder = 1
		}),
		Price = 0,
		PricingNote = 0,
		Caption = 0
	}
	local price

	if priceText then
		local createElement3 = React.createElement

		local v5 = {
			Current = React.createElement(Text, {
				tag = "auto-xy text-title-large text-no-wrap content-emphasis",
				Text = robuxText(priceText), -- inferred equivalent call
				RichText = true,
				testId = "avatar-gift-info-panel-price",
				LayoutOrder = 1
			}),
			Original = 0
		}
		local original

		if originalPriceText then
			original = React.createElement(Text, {
				tag = "auto-xy text-body-medium text-no-wrap content-muted",
				Text = `<s>{robuxText(originalPriceText)}</s>`,
				RichText = true,
				testId = "avatar-gift-info-panel-original-price",
				LayoutOrder = 2
			}) -- inferred equivalent call
		end

		v5.Original = original
		price = createElement3(
			View,
			{ tag = "row align-x-center align-y-center gap-small auto-xy", LayoutOrder = 2 },
			v5
		)
	end

	v4.Price = price
	local pricingNote2

	if pricingNote then
		pricingNote2 = React.createElement(InfoTooltip, {
			text = pricingNote.text,
			tooltipTitle = pricingNote.tooltipTitle,
			tooltipText = pricingNote.tooltipText,
			testId = "avatar-gift-info-panel-pricing",
			LayoutOrder = 3
		})
	end

	v4.PricingNote = pricingNote2
	local caption

	if props.captionText then
		caption = React.createElement(Text, {
			tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-center content-default",
			Text = props.captionText,
			testId = "avatar-gift-info-panel-caption",
			LayoutOrder = 4
		})
	end

	v4.Caption = caption
	v3.Details = createElement2(View, {
		tag = "col align-x-center gap-xsmall size-full-0 auto-y",
		LayoutOrder = 2
	}, v4)
	return createElement(View, v2, v3)
end

return React.memo(AvatarGiftInfoPanelView)
