local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Localization = require(parent.Localization)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local icon = utf8.char(57346)

local function EditDisplayNameErrorModal(p)
	local screenSize = useScreenSize()
	local param = p.navigation.getParam("robux")
	local v = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		buy = TextKeys.Buy,
		insufficientFunds = TextKeys.InsufficientFunds,
		message = {
			TextKeys.InsufficientFundsMessage,
			icon = icon,
			rbx = param
		}
	})

	local function onClose()
		p.navigation.goBack()
	end

	local function onActivated()
		p.navigation.navigate(AppPage.PurchaseRobux)
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(InteractiveAlert, {
				screenSize = screenSize,
				title = v.insufficientFunds,
				bodyText = v.message,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = { onActivated = onClose, text = v.cancelButtonText }
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onActivated, text = v.buy }
						}
					}
				}
			}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v.insufficientFunds,
		bodyText = v.message,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onClose, text = v.cancelButtonText }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v.buy }
				}
			}
		}
	})
end

return EditDisplayNameErrorModal
