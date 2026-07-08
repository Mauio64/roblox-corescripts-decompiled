local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local RoactRodux = dependencies.RoactRodux
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local TextKeys = require(ParentParent.Common.TextKeys)
local Constants = require(ParentParent.Common.Constants)
local getFFlagPassNavigationToContactsRevoked = require(ParentParent.Flags.getFFlagPassNavigationToContactsRevoked)
local v14 = Roact.PureComponent:extend("ContactsRevokedAccessDialog")

v14.validateProps = t.strictInterface({
	navigation = t.table,
	screenSize = t.Vector2
})

function v14.render(p1) -- line: 31
	-- upvalues: withLocalization (copy), TextKeys (copy), withStyle (copy), Constants (copy), getFFlagPassNavigationToContactsRevoked (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return withLocalization({
		titleText = TextKeys.CONTACTS_LIST_TITLE,
		revokedFlow = TextKeys.CONTACTS_REVOKED_FLOW,
		closeModalOk = TextKeys.CLOSE_MODAL_OK
	})(function(p2) -- line: 36
		-- upvalues: withStyle (copy), p1 (copy), Constants (copy), getFFlagPassNavigationToContactsRevoked (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
		return withStyle(function(_) -- line: 37
			-- upvalues: p1 (copy), Constants (copy), getFFlagPassNavigationToContactsRevoked (copy), Roact (copy), InteractiveAlert (copy), p2 (copy), ButtonType (copy)
			local props = p1.props
			local navigation = props.navigation
			local v21 = navigation.getParam(Constants.CLOSE_MODAL) or getFFlagPassNavigationToContactsRevoked() and navigation.pop

			return Roact.createElement(InteractiveAlert, {
				title = p2.titleText,
				screenSize = props.screenSize,
				buttonStackInfo = {
					buttonHeight = 48,
					buttons = {{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = function() -- line: 51
								-- upvalues: v21 (copy)
								v21()
							end,
							text = p2.closeModalOk
						}
					}},
					forcedFillDirection = Enum.FillDirection.Vertical
				},
				bodyText = p2.revokedFlow
			})
		end)
	end)
end

return RoactRodux.connect(function(p4) -- line: 67
	return {
		screenSize = p4.ScreenSize
	}
end, nil)(v14)
