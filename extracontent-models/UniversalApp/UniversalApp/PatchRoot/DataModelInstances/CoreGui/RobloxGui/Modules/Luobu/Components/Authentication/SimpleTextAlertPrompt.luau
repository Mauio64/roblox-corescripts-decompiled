local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(Modules.LuaApp.withLocalization)
local t = require(CorePackages.Packages.t)
local InteractiveAlert = require(CorePackages.Packages.UIBlox).App.Dialog.Alert.InteractiveAlert
local v8 = Roact.PureComponent:extend("SimpleTextAlertPrompt")

v8.validateProps = t.strictInterface({
	titleKey = t.string,
	bodyTextKey = t.string,
	confirmButtonTextKey = t.string,
	confirmButtonCallback = t.callback,
	screenSize = t.Vector2
})

function v8.render(p1) -- line: 22
	-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy)
	local titleKey = p1.props.titleKey
	local bodyTextKey = p1.props.bodyTextKey
	local confirmButtonTextKey = p1.props.confirmButtonTextKey
	local confirmButtonCallback = p1.props.confirmButtonCallback
	local screenSize = p1.props.screenSize

	return withLocalization({
		title = titleKey,
		bodyText = bodyTextKey,
		confirmButtonText = confirmButtonTextKey
	})(function(p2) -- line: 32
		-- upvalues: Roact (copy), InteractiveAlert (copy), confirmButtonCallback (copy), screenSize (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p2.title,
			bodyText = p2.bodyText,
			buttonStackInfo = {
				buttons = {{
					props = {
						onActivated = confirmButtonCallback,
						text = p2.confirmButtonText
					}
				}}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = screenSize
		})
	end)
end

return RoactRodux.connect(function(p3) -- line: 52
	return {
		screenSize = p3.ScreenSize
	}
end, function(_) -- line: 56
	return {}
end)(v8)
