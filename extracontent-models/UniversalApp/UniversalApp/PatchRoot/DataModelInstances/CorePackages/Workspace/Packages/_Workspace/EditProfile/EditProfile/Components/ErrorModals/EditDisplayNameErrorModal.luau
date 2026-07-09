local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local TextKeys = require(EditProfile.Common.TextKeys)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

local function EditDisplayNameErrorModal(t1: {[any]: any}) -- line: 19
	-- upvalues: useScreenSize (copy), useDisplayNameText (copy), useLocalization (copy), TextKeys (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v15 = useScreenSize()
	local v16 = useDisplayNameText()
	local v17 = useLocalization({
		OK = TextKeys.OK
	})

	local function onClose() -- line: 26
		-- upvalues: t1 (copy)
		t1.navigation.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = onClose
		}, { React.createElement(InteractiveAlert, {
			screenSize = v15,
			title = v16.displayNameEditMessage,
			bodyText = v16.displayNameCoolDownMessage,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onClose,
						text = v17.OK
					}
				}}
			}
		}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = v15,
		title = v16.displayNameEditMessage,
		bodyText = v16.displayNameCoolDownMessage,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = onClose,
					text = v17.OK
				}
			}}
		}
	})
end

return EditDisplayNameErrorModal
