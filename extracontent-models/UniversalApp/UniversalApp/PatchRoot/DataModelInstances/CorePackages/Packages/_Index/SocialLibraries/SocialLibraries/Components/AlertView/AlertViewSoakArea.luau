local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact

local defineFastFlag = game:DefineFastFlag("SocialLibrariesSelectableAlertViewShim", false)

local extended = roact.PureComponent:extend("AlertViewSoakArea")
extended.defaultProps = {
	Visible = true,
	BackgroundTransparency = 0.75,
	BackgroundColor3 = Color3.fromRGB(255, 0, 255)
}

function extended.render(p)
	return roact.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = p.props.BackgroundTransparency,
		BackgroundColor3 = p.props.BackgroundColor3,
		Active = true,
		AutoButtonColor = false,
		Selectable = not defineFastFlag and nil,
		Visible = p.props.Visible
	}, p.props[roact.Children])
end

return extended
