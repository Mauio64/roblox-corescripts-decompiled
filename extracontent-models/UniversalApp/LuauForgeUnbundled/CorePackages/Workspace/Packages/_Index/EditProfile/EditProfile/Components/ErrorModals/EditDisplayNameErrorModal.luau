local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useScreenSize
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local FFlagEditProfileFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileFixFocusNavigation")
local useDisplayNameText = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useDisplayNameText")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")

local function EditDisplayNameErrorModal(p2)
	local v5 = useScreenSize()
	local v6 = useDisplayNameText()
	local v7 = useLocalization({ OK = TextKeys.OK })

	local function onClose()
		p2.navigation.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(interactiveAlert, {
				screenSize = v5,
				title = v6.displayNameEditMessage,
				bodyText = v6.displayNameCoolDownMessage,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = onClose, text = v7.OK }
						}
					}
				}
			}) })
	end

	return React.createElement(interactiveAlert, {
		screenSize = v5,
		title = v6.displayNameEditMessage,
		bodyText = v6.displayNameCoolDownMessage,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onClose, text = v7.OK }
				}
			}
		}
	})
end

return EditDisplayNameErrorModal
