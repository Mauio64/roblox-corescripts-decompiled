local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local TextKeys = require(EditProfile.Common.TextKeys)
local Constants = require(EditProfile.Common.Constants)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)

local function EditSocialNetworksErrorModal()
	local v = useNavigationProps(function(_, p)
		return { errorCode = p.errorCode }
	end)

	local v2 = useNavigation()
	local screenSize = useScreenSize()
	local v3 = useLocalization({
		title = TextKeys.SocialNetworksError,
		InvalidFacebook = TextKeys.InvalidFacebook,
		InvalidX = TextKeys.InvalidX,
		InvalidYouTube = TextKeys.InvalidYouTube,
		InvalidTwitch = TextKeys.InvalidTwitch,
		InvalidGuilded = TextKeys.InvalidGuilded,
		OK = TextKeys.OK
	})

	local bodyText = ({
		[Constants.SocialNetworksErrorCodes.Facebook] = v3.InvalidFacebook,
		[Constants.SocialNetworksErrorCodes.Twitter] = v3.InvalidX,
		[Constants.SocialNetworksErrorCodes.YouTube] = v3.InvalidYouTube,
		[Constants.SocialNetworksErrorCodes.Twitch] = v3.InvalidTwitch,
		[Constants.SocialNetworksErrorCodes.Guilded] = v3.InvalidGuilded
	})[v.errorCode]

	local function onClose()
		v2.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(InteractiveAlert, {
				screenSize = screenSize,
				title = v3.title,
				bodyText = bodyText,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onClose, text = v3.OK }
						}
					}
				}
			}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v3.title,
		bodyText = bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onClose, text = v3.OK }
				}
			}
		}
	})
end

return EditSocialNetworksErrorModal
