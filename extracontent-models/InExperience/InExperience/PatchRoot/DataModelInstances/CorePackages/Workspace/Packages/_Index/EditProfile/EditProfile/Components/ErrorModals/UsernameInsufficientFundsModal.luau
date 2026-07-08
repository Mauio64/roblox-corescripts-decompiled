local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local AppPage = require(EditProfileParent.RobloxAppEnums).AppPage
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local Localization = require(EditProfileParent.Localization)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v14 = utf8.char(57346)

local function EditDisplayNameErrorModal(t1: {[any]: any}) -- line: 23
	-- upvalues: useScreenSize (copy), useLocalization (copy), TextKeys (copy), v14 (copy), AppPage (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v17 = useScreenSize()
	local v18 = t1.navigation.getParam("robux")
	local v19 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		buy = TextKeys.Buy,
		insufficientFunds = TextKeys.InsufficientFunds,
		message = {
			TextKeys.InsufficientFundsMessage,
			icon = v14,
			rbx = v18
		}
	})

	local function onClose() -- line: 33
		-- upvalues: t1 (copy)
		t1.navigation.goBack()
	end
	local function v21() -- line: 37
		-- upvalues: t1 (copy), AppPage (copy)
		t1.navigation.navigate(AppPage.PurchaseRobux)
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = onClose
		}, { React.createElement(InteractiveAlert, {
			screenSize = v17,
			title = v19.insufficientFunds,
			bodyText = v19.message,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = onClose,
							text = v19.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v21,
							text = v19.buy
						}
					}
				}
			}
		}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = v17,
		title = v19.insufficientFunds,
		bodyText = v19.message,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = onClose,
						text = v19.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v21,
						text = v19.buy
					}
				}
			}
		}
	})
end

return EditDisplayNameErrorModal
