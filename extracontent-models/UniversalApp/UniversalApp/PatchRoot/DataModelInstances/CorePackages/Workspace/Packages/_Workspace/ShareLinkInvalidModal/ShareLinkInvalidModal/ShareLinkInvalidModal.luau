local scriptParent = script.Parent
local dependencies = require(scriptParent.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local withLocalization = dependencies.withLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local v9 = Roact.Component:extend("ShareLinkInvalidModal")

v9.validateProps = t.interface({
	closeModal = t.callback,
	screenSize = t.Vector2
})

function v9.render(p1) -- line: 28
	-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local props = p1.props

	return withLocalization({
		titleText = "Feature.SocialShare.Label.InvalidLinkError",
		bodyText = "Feature.SocialShare.Description.InvalidLinkError",
		buttonText = "Feature.Friends.Label.Cancel"
	})(function(p2) -- line: 35
		-- upvalues: Roact (copy), InteractiveAlert (copy), props (copy), ButtonType (copy)
		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			title = p2.titleText,
			bodyText = p2.bodyText,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = p2.buttonText,
						onActivated = props.closeModal
					}
				}}
			}
		})
	end)
end

return v9
