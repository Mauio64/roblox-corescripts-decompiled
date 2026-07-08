local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v7 = Roact.PureComponent:extend("AlertViewButton")

v7.defaultProps = {
	LayoutOrder = 0,
	secondary = false,
	Text = "",
	onActivated = function() -- line: 13
	end,
	Size = UDim2.new(1, 0, 1, 0)
}

function v7.render(p1) -- line: 18
	-- upvalues: ButtonType (copy), Roact (copy), Button (copy)
	local PrimarySystem = ButtonType.PrimarySystem

	if p1.props.secondary then
		PrimarySystem = ButtonType.Secondary
	end

	return Roact.createElement(Button, {
		buttonType = PrimarySystem,
		size = p1.props.Size,
		layoutOrder = p1.props.LayoutOrder,
		text = p1.props.Text,
		onActivated = p1.props.onActivated
	})
end

return v7
