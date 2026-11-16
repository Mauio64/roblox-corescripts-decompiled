local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/edC")
local t = require(CorePackages.Packages.t)

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local extended = Roact.PureComponent:extend("SimpleTextAlertPrompt")

extended.validateProps = t.strictInterface({
	titleKey = t.string,
	bodyTextKey = t.string,
	confirmButtonTextKey = t.string,
	confirmButtonCallback = t.callback,
	screenSize = t.Vector2
})

function extended.render(p2)
	local titleKey = p2.props.titleKey
	local bodyTextKey = p2.props.bodyTextKey
	local confirmButtonTextKey = p2.props.confirmButtonTextKey
	local confirmButtonCallback = p2.props.confirmButtonCallback
	local screenSize = p2.props.screenSize
	return module({
		title = titleKey,
		bodyText = bodyTextKey,
		confirmButtonText = confirmButtonTextKey
	})(function(props)
		return Roact.createElement(interactiveAlert, {
			title = props.title,
			bodyText = props.bodyText,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = confirmButtonCallback,
							text = props.confirmButtonText
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = screenSize
		})
	end)
end

return RoactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, function(p2)
	return {}
end)(extended)
