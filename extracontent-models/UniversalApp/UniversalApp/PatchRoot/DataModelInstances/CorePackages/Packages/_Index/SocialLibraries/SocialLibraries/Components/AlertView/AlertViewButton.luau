local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType

local extended = roact.PureComponent:extend("AlertViewButton")

extended.defaultProps = {
	LayoutOrder = 0,
	secondary = false,
	onActivated = function() end,
	Size = UDim2.new(1, 0, 1, 0),
	Text = ""
}

function extended.render(p)
	local buttonType2 = buttonType.PrimarySystem

	if p.props.secondary then
		buttonType2 = buttonType.Secondary
	end

	return roact.createElement(button, {
		buttonType = buttonType2,
		size = p.props.Size,
		layoutOrder = p.props.LayoutOrder,
		text = p.props.Text,
		onActivated = p.props.onActivated
	})
end

return extended
