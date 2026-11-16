local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local PlusSubscribeBanner = require(parent.AvatarExperienceCommon.PlusSubscribeBanner)

local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local function FramesPlusUpsellBar(props)
	local v = useLocalization({
		unlockBanner = TextKeys.ProfileFramesUnlockBanner,
		subscribe = TextKeys.Subscribe
	})

	return React.createElement(PlusSubscribeBanner, {
		message = v.unlockBanner,
		actionText = props.actionText or v.subscribe,
		onActivated = props.onSubscribeActivated,
		showPlusIcon = true,
		LayoutOrder = props.layoutOrder,
		testId = "FramesPlusUpsellBar"
	})
end

return FramesPlusUpsellBar
