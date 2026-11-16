local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Gifting = require(parent.Gifting)

local AvatarGiftInfoPanelView = require(script.Parent.Parent.AvatarGiftInfoPanel.AvatarGiftInfoPanelView)

local GiftSendView = Gifting.Components.GiftSendView

local function AvatarGiftSendView(props)
	local thumbnailUrl = props.thumbnailUrl
	local itemName = props.itemName
	local priceText = props.priceText
	local originalPriceText = props.originalPriceText
	local pricingNote = props.pricingNote

	local giftPresentation = React.useMemo(function()
		return React.createElement(AvatarGiftInfoPanelView, {
			thumbnailUrl = thumbnailUrl,
			itemName = itemName,
			priceText = priceText,
			originalPriceText = originalPriceText,
			pricingNote = pricingNote
		})
	end, { thumbnailUrl, itemName, priceText, originalPriceText, pricingNote })

	return React.createElement(GiftSendView, {
		isOpen = props.isOpen,
		titleText = props.titleText,
		onBack = props.onBack,
		allowance = props.allowance,
		userInfoProps = props.userInfoProps,
		giftPresentation = giftPresentation,
		savingsPresentation = props.savingsPresentation,
		state = props.state,
		buyLabel = props.buyLabel,
		isBuyLoading = props.isBuyLoading,
		isBuyDisabled = props.isBuyDisabled,
		onBuy = props.onBuy,
		disclaimerText = props.disclaimerText,
		onClose = props.onClose
	})
end

return React.memo(AvatarGiftSendView)
