local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local RoactUtils = require(parent.RoactUtils)
local EditProfileImage = require(script.Parent.EditProfileImage)
local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)
local closeProfilePictureEditor = require(AvatarExperienceProfilePictureEditor.Utils.closeProfilePictureEditor)
local showEditProfileImageToast = require(AvatarExperienceProfilePictureEditor.Utils.showEditProfileImageToast)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function EditProfileImageScreen(props)
	local v = useDispatch()

	local onClose = React.useCallback(function()
		closeProfilePictureEditor(props.navigation)
	end, { props.navigation })

	local onSaveSuccess = React.useCallback(function()
		showEditProfileImageToast.showSaveSuccessToast(v)
		closeProfilePictureEditor(props.navigation)
	end, { v, props.navigation })
	local mode

	if props.navigation.getParam then
		mode = props.navigation.getParam("mode", Enums.EditProfileImageMode.Default)
	else
		mode = Enums.EditProfileImageMode.Default
	end

	return React.createElement(EditProfileImage, {
		mode = mode,
		initialFrameAssetId = props.initialFrameAssetId,
		initialFrameSelectionRequestId = props.initialFrameSelectionRequestId,
		showCloseButton = props.isFocused ~= false,
		onClose = onClose,
		onSaveSuccess = onSaveSuccess,
		onOpenEmoteDetails = props.onOpenEmoteDetails,
		onPrepareRecommendedEmotePurchase = props.onPrepareRecommendedEmotePurchase,
		onShopForMoreEmotes = props.onShopForMoreEmotes,
		onPromptR15Upgrade = props.onPromptR15Upgrade,
		accountRigType = props.accountRigType,
		renderRecommendedEmotePurchaseFooter = props.renderRecommendedEmotePurchaseFooter
	})
end

return RoactNavigation.withNavigationFocus(EditProfileImageScreen)
