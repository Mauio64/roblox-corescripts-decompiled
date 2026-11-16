local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local Components = SocialLibraries.Components
local buttonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)

local extended = roact.Component:extend("WarningAlertView")
extended.defaultProps = {
	titleText = "TestTitle",
	bodyText = "TestBody",
	cancelText = "TestCancel",
	confirmText = "TestConfirm",
	failureTitleText = "failure title!",
	failureBodyText = "Thing failure!",
	failureButtonText = "failure Placeholder!",
	screenSize = Vector2.new(0, 0),
	width = UDim.new(0.5, 0),
	displayFailed = false,
	onActivated = function() end,
	onModalClose = function() end,
	soakAreaColor3 = Color3.fromRGB(0, 0, 255),
	soakAreaTransparency = 0.9
}

local function No_Op() end

function extended.render(p)
	local props = p.props
	local title, bodyText, buttons

	if props.displayFailed then
		title = p.props.failureTitleText
		bodyText = p.props.failureBodyText

		buttons = {
			{
				buttonType = buttonType.Alert,
				props = { text = props.failureButtonText, onActivated = No_Op }
			}
		}
	else
		title = p.props.titleText
		bodyText = p.props.bodyText

		buttons = {
			{
				buttonType = buttonType.Secondary,
				props = { text = props.cancelText, onActivated = No_Op }
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = { text = props.confirmText, onActivated = props.onActivated }
			}
		}
	end

	return roact.createElement(AlertViewBuilder, {
		title = title,
		bodyText = bodyText,
		screenSize = p.props.screenSize,
		width = p.props.width,
		onModalClose = p.props.onModalClose,
		buttons = buttons,
		soakAreaColor3 = props.soakAreaColor3,
		soakAreaTransparency = props.soakAreaTransparency
	})
end

return extended
