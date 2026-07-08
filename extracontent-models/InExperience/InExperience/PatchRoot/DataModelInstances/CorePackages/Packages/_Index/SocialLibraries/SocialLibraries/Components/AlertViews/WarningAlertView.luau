local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local Components = SocialLibraries.Components
local ButtonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)
local v7 = Roact.Component:extend("WarningAlertView")

v7.defaultProps = {
	titleText = "TestTitle",
	bodyText = "TestBody",
	cancelText = "TestCancel",
	confirmText = "TestConfirm",
	failureTitleText = "failure title!",
	failureBodyText = "Thing failure!",
	failureButtonText = "failure Placeholder!",
	displayFailed = false,
	soakAreaTransparency = 0.9,
	screenSize = Vector2.new(0, 0),
	width = UDim.new(0.5, 0),
	onActivated = function() -- line: 24
	end,
	onModalClose = function() -- line: 25
	end,
	soakAreaColor3 = Color3.fromRGB(0, 0, 255)
}

local function No_Op() -- line: 31
end

function v7.render(p1) -- line: 33
	-- upvalues: ButtonType (copy), No_Op (copy), Roact (copy), AlertViewBuilder (copy)
	local props = p1.props
	local failureTitleText, failureBodyText, t1

	if props.displayFailed then
		failureTitleText = p1.props.failureTitleText
		failureBodyText = p1.props.failureBodyText
		t1 = {{
			buttonType = ButtonType.Alert,
			props = {
				text = props.failureButtonText,
				onActivated = No_Op
			}
		}}
	else
		failureTitleText = p1.props.titleText
		failureBodyText = p1.props.bodyText
		t1 = {
			{
				buttonType = ButtonType.Secondary,
				props = {
					text = props.cancelText,
					onActivated = No_Op
				}
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					text = props.confirmText,
					onActivated = props.onActivated
				}
			}
		}
	end

	return Roact.createElement(AlertViewBuilder, {
		title = failureTitleText,
		bodyText = failureBodyText,
		screenSize = p1.props.screenSize,
		width = p1.props.width,
		onModalClose = p1.props.onModalClose,
		buttons = t1,
		soakAreaColor3 = props.soakAreaColor3,
		soakAreaTransparency = props.soakAreaTransparency
	})
end

return v7
