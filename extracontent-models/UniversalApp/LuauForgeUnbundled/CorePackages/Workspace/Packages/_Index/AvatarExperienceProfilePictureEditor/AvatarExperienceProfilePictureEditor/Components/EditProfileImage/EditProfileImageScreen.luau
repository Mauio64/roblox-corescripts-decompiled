local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RoactNavigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RoactUtils")
local EditProfileImage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/EditProfileImage")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local fFlagNavigationCallbackParam = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagNavigationCallbackParam
local closeProfilePictureEditor = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/closeProfilePictureEditor")
local leaveEditProfileImage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/leaveEditProfileImage")
local showEditProfileImageToast = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/showEditProfileImageToast")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function EditProfileImageScreen(props)
	local v5 = useDispatch()

	local v6 = React.useCallback(function()
		if fFlagNavigationCallbackParam then
			leaveEditProfileImage(props.navigation, props.onReturn)
		else
			closeProfilePictureEditor(props.navigation)
		end
	end, { props.navigation, props.onReturn })

	local v7 = React.useCallback(function()
		showEditProfileImageToast.showSaveSuccessToast(v5)

		if fFlagNavigationCallbackParam then
			leaveEditProfileImage(props.navigation, props.onReturn)
		else
			closeProfilePictureEditor(props.navigation)
		end
	end, { v5, props.navigation, props.onReturn })

	local v8 = if props.navigation.getParam then props.navigation.getParam(
		"mode",
		Enums.EditProfileImageMode.Default
	) else Enums.EditProfileImageMode.Default

	return React.createElement(EditProfileImage, {
		mode = v8,
		initialFrameAssetId = props.initialFrameAssetId,
		initialFrameSelectionRequestId = props.initialFrameSelectionRequestId,
		showCloseButton = props.isFocused ~= false,
		onClose = v6,
		onSaveSuccess = v7,
		onOpenEmoteDetails = props.onOpenEmoteDetails,
		onPrepareRecommendedEmotePurchase = props.onPrepareRecommendedEmotePurchase,
		onShopForMoreEmotes = props.onShopForMoreEmotes,
		onPromptR15Upgrade = props.onPromptR15Upgrade,
		accountRigType = props.accountRigType,
		renderRecommendedEmotePurchaseFooter = props.renderRecommendedEmotePurchaseFooter
	})
end

return RoactNavigation.withNavigationFocus(EditProfileImageScreen)
