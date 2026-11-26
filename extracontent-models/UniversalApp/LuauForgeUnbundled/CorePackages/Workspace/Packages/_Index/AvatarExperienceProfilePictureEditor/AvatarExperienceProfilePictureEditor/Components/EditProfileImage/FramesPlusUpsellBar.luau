local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization").Hooks.useLocalization
local PlusSubscribeBanner = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceCommon/PlusSubscribeBanner")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local function FramesPlusUpsellBar(props)
	local v5 = useLocalization({
		unlockBanner = TextKeys.ProfileFramesUnlockBanner,
		subscribe = TextKeys.Subscribe
	})

	return React.createElement(PlusSubscribeBanner, {
		message = v5.unlockBanner,
		actionText = props.actionText or v5.subscribe,
		onActivated = props.onSubscribeActivated,
		showPlusIcon = true,
		LayoutOrder = props.layoutOrder,
		testId = "FramesPlusUpsellBar"
	})
end

return FramesPlusUpsellBar
