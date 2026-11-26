local module = require("@luauforge/deferred/gGc")

local roact = module.Roact
local uiBlox = module.UIBlox
local t = module.t
local withLocalization = module.withLocalization

local buttonType = uiBlox.App.Button.Enum.ButtonType
local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert

local extended = roact.Component:extend("ShareLinkInvalidModal")

extended.validateProps = t.interface({ closeModal = t.callback, screenSize = t.Vector2 })

function extended.render(p2)
	local props = p2.props

	return withLocalization({
		titleText = "Feature.SocialShare.Label.InvalidLinkError",
		bodyText = "Feature.SocialShare.Description.InvalidLinkError",
		buttonText = "Feature.Friends.Label.Cancel"
	})(function(props2)
		return roact.createElement(interactiveAlert, {
			screenSize = props.screenSize,
			title = props2.titleText,
			bodyText = props2.bodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							text = props2.buttonText,
							onActivated = props.closeModal
						}
					}
				}
			}
		})
	end)
end

return extended
