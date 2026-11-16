local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppEnums").AppPage
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useScreenSize
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local FFlagEditProfileFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileFixFocusNavigation")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = Localization.Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType

local v5 = utf8.char(57346)

local function EditDisplayNameErrorModal(p2)
	local v6 = useScreenSize()
	local param = p2.navigation.getParam("robux")
	local v7 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		buy = TextKeys.Buy,
		insufficientFunds = TextKeys.InsufficientFunds,
		message = {
			TextKeys.InsufficientFundsMessage,
			icon = v5,
			rbx = param
		}
	})

	local function onClose()
		p2.navigation.goBack()
	end

	local function onActivated()
		p2.navigation.navigate(appPage.PurchaseRobux)
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(interactiveAlert, {
				screenSize = v6,
				title = v7.insufficientFunds,
				bodyText = v7.message,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.Secondary,
							props = {
								onActivated = onClose,
								text = v7.cancelButtonText
							}
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = onActivated, text = v7.buy }
						}
					}
				}
			}) })
	end

	return React.createElement(interactiveAlert, {
		screenSize = v6,
		title = v7.insufficientFunds,
		bodyText = v7.message,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onClose, text = v7.cancelButtonText }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated, text = v7.buy }
				}
			}
		}
	})
end

return EditDisplayNameErrorModal
