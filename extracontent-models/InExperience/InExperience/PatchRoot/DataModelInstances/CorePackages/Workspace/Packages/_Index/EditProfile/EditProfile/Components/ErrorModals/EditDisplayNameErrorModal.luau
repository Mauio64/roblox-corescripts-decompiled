local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local TextKeys = require(EditProfile.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

local function EditDisplayNameErrorModal(p)
	local screenSize = useScreenSize()
	local v = useDisplayNameText()
	local v2 = useLocalization({ OK = TextKeys.OK })

	local function onClose()
		p.navigation.goBack()
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = onClose }, { React.createElement(InteractiveAlert, {
				screenSize = screenSize,
				title = v.displayNameEditMessage,
				bodyText = v.displayNameCoolDownMessage,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onClose, text = v2.OK }
						}
					}
				}
			}) })
	end

	return React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v.displayNameEditMessage,
		bodyText = v.displayNameCoolDownMessage,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onClose, text = v2.OK }
				}
			}
		}
	})
end

return EditDisplayNameErrorModal
