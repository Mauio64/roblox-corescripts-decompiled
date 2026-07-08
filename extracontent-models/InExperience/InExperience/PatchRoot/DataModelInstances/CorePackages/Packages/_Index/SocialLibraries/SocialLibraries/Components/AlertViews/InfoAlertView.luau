local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local Components = SocialLibraries.Components
local ButtonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)
local v7 = Roact.Component:extend("InfoAlertView")

v7.defaultProps = {
	titleText = "TestTitle",
	bodyText = "TestBody",
	confirmText = "TestConfirm",
	soakAreaTransparency = 0.9,
	width = UDim.new(0.5, 0),
	screenSize = Vector2.new(0, 0),
	onModalClose = function() -- line: 18
	end,
	soakAreaColor3 = Color3.fromRGB(0, 0, 255)
}

function v7.render(p1) -- line: 24
	-- upvalues: Roact (copy), AlertViewBuilder (copy), ButtonType (copy)
	local props = p1.props

	return Roact.createElement(AlertViewBuilder, {
		title = props.titleText,
		bodyText = props.bodyText,
		width = props.width,
		screenSize = props.screenSize,
		onModalClose = props.onModalClose,
		buttons = {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				text = props.confirmText,
				onActivated = props.onModalClose
			}
		}},
		soakAreaColor3 = props.soakAreaColor3,
		soakAreaTransparency = props.soakAreaTransparency
	})
end

return v7
