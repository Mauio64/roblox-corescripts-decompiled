local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useScreenSize
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppNavigation").useNavigationProps
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Navigation").useNavigation
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")
local FFlagEditProfileFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileFixFocusNavigation")

local function EditSocialNetworksErrorModal()
	local v5 = useNavigationProps(function(p2, p3)
		return { errorCode = p3.errorCode }
	end)

	local v6 = useNavigation()
	local v7 = useScreenSize()
	local v8 = useLocalization({
		title = TextKeys.SocialNetworksError,
		InvalidFacebook = TextKeys.InvalidFacebook,
		InvalidX = TextKeys.InvalidX,
		InvalidYouTube = TextKeys.InvalidYouTube,
		InvalidTwitch = TextKeys.InvalidTwitch,
		InvalidGuilded = TextKeys.InvalidGuilded,
		OK = TextKeys.OK
	})

	local v10 = ({
		[Constants.SocialNetworksErrorCodes.Facebook] = v8.InvalidFacebook,
		[Constants.SocialNetworksErrorCodes.Twitter] = v8.InvalidX,
		[Constants.SocialNetworksErrorCodes.YouTube] = v8.InvalidYouTube,
		[Constants.SocialNetworksErrorCodes.Twitch] = v8.InvalidTwitch,
		[Constants.SocialNetworksErrorCodes.Guilded] = v8.InvalidGuilded
	})[v5.errorCode]

	local function onClose()
		v6.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(interactiveAlert, {
				screenSize = v7,
				title = v8.title,
				bodyText = v10,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = onClose, text = v8.OK }
						}
					}
				}
			}) })
	end

	return React.createElement(interactiveAlert, {
		screenSize = v7,
		title = v8.title,
		bodyText = v10,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onClose, text = v8.OK }
				}
			}
		}
	})
end

return EditSocialNetworksErrorModal
