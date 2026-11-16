local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local Components = SocialLibraries.Components
local buttonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)

local extended = roact.Component:extend("InfoAlertView")
extended.defaultProps = {
	titleText = "TestTitle",
	bodyText = "TestBody",
	confirmText = "TestConfirm",
	width = UDim.new(0.5, 0),
	screenSize = Vector2.new(0, 0),
	onModalClose = function() end,
	soakAreaColor3 = Color3.fromRGB(0, 0, 255),
	soakAreaTransparency = 0.9
}

function extended.render(p)
	local props = p.props

	return roact.createElement(AlertViewBuilder, {
		title = props.titleText,
		bodyText = props.bodyText,
		width = props.width,
		screenSize = props.screenSize,
		onModalClose = props.onModalClose,
		buttons = {
			{
				buttonType = buttonType.PrimarySystem,
				props = { text = props.confirmText, onActivated = props.onModalClose }
			}
		},
		soakAreaColor3 = props.soakAreaColor3,
		soakAreaTransparency = props.soakAreaTransparency
	})
end

return extended
