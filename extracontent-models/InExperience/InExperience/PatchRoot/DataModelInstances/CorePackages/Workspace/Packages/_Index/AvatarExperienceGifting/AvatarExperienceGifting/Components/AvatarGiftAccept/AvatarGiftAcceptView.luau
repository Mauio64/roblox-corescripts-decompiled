local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Gifting = require(parent.Gifting)

local AvatarGiftInfoPanelView = require(script.Parent.Parent.AvatarGiftInfoPanel.AvatarGiftInfoPanelView)

local GiftAcceptView = Gifting.Components.GiftAcceptView
local useTokens = Foundation.Hooks.useTokens

local function AvatarGiftAcceptView(props)
	local v = useTokens()

	local thumbnailUrl = props.thumbnailUrl
	local itemName = props.itemName
	local captionText = props.captionText
	local size_2000 = v.Size.Size_2000

	local giftPresentation = React.useMemo(function()
		return React.createElement(AvatarGiftInfoPanelView, {
			thumbnailUrl = thumbnailUrl,
			itemName = itemName,
			captionText = captionText,
			thumbnailSize = size_2000
		})
	end, { thumbnailUrl, itemName, captionText, size_2000 })

	return React.createElement(GiftAcceptView, {
		isOpen = props.isOpen,
		titleText = props.titleText,
		userInfoProps = props.userInfoProps,
		giftPresentation = giftPresentation,
		state = props.state,
		acceptLabel = props.acceptLabel,
		isAcceptLoading = props.isAcceptLoading,
		isAcceptDisabled = props.isAcceptDisabled,
		onAccept = props.onAccept,
		rejectLabel = props.rejectLabel,
		isRejectLoading = props.isRejectLoading,
		isRejectDisabled = props.isRejectDisabled,
		onReject = props.onReject,
		disclaimerText = props.disclaimerText,
		onClose = props.onClose
	})
end

return React.memo(AvatarGiftAcceptView)
