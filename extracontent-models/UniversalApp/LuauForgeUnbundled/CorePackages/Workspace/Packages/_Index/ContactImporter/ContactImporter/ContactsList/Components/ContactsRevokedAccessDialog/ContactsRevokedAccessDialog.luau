local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local t = dependencies.t
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local roactRodux = dependencies.RoactRodux

local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = uiBlox.App.Button.Enum.ButtonType
local withStyle = uiBlox.Style.withStyle
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local getFFlagPassNavigationToContactsRevoked = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFFlagPassNavigationToContactsRevoked")

local extended = roact.PureComponent:extend("ContactsRevokedAccessDialog")

extended.validateProps = t.strictInterface({
	navigation = t.table,
	screenSize = t.Vector2
})

function extended.render(p2)
	return withLocalization({
		titleText = TextKeys.CONTACTS_LIST_TITLE,
		revokedFlow = TextKeys.CONTACTS_REVOKED_FLOW,
		closeModalOk = TextKeys.CLOSE_MODAL_OK
	})(function(data)
		return withStyle(function(p3)
			local props = p2.props

			local navigation = props.navigation
			local v5 = navigation.getParam(Constants.CLOSE_MODAL) or getFFlagPassNavigationToContactsRevoked() and navigation.pop
			return roact.createElement(interactiveAlert, {
				title = data.titleText,
				screenSize = props.screenSize,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.Secondary,
							props = {
								onActivated = function()
									v5()
								end,
								text = data.closeModalOk
							}
						}
					},
					buttonHeight = 48,
					forcedFillDirection = Enum.FillDirection.Vertical
				},
				bodyText = data.revokedFlow
			})
		end)
	end)
end

return roactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, nil)(extended)
