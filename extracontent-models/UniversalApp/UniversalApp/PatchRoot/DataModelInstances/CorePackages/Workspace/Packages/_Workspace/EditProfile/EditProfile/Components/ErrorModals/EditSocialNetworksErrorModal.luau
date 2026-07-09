local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local TextKeys = require(EditProfile.Common.TextKeys)
local Constants = require(EditProfile.Common.Constants)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useNavigationProps = require(EditProfileParent.RobloxAppNavigation).useNavigationProps
local useNavigation = require(EditProfileParent.Navigation).useNavigation
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)

local function EditSocialNetworksErrorModal() -- line: 18
	-- upvalues: useNavigationProps (copy), useNavigation (copy), useScreenSize (copy), useLocalization (copy), TextKeys (copy), Constants (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v16 = useNavigationProps(function(_, p2) -- line: 19
		return {
			errorCode = p2.errorCode
		}
	end)
	local v17 = useNavigation()
	local v18 = useScreenSize()
	local v19 = useLocalization({
		title = TextKeys.SocialNetworksError,
		InvalidFacebook = TextKeys.InvalidFacebook,
		InvalidX = TextKeys.InvalidX,
		InvalidYouTube = TextKeys.InvalidYouTube,
		InvalidTwitch = TextKeys.InvalidTwitch,
		InvalidGuilded = TextKeys.InvalidGuilded,
		OK = TextKeys.OK
	})
	local v20 = ({
		[Constants.SocialNetworksErrorCodes.Facebook] = v19.InvalidFacebook,
		[Constants.SocialNetworksErrorCodes.Twitter] = v19.InvalidX,
		[Constants.SocialNetworksErrorCodes.YouTube] = v19.InvalidYouTube,
		[Constants.SocialNetworksErrorCodes.Twitch] = v19.InvalidTwitch,
		[Constants.SocialNetworksErrorCodes.Guilded] = v19.InvalidGuilded
	})[v16.errorCode]

	local function onClose() -- line: 45
		-- upvalues: v17 (copy)
		v17.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = onClose
		}, { React.createElement(InteractiveAlert, {
			screenSize = v18,
			title = v19.title,
			bodyText = v20,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onClose,
						text = v19.OK
					}
				}}
			}
		}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = v18,
		title = v19.title,
		bodyText = v20,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = onClose,
					text = v19.OK
				}
			}}
		}
	})
end

return EditSocialNetworksErrorModal
