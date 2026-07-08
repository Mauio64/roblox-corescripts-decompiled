local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact
local v3 = game:DefineFastFlag("SocialLibrariesSelectableAlertViewShim", false)
local v4 = Roact.PureComponent:extend("AlertViewSoakArea")

v4.defaultProps = {
	Visible = true,
	BackgroundTransparency = 0.75,
	BackgroundColor3 = Color3.fromRGB(255, 0, 255)
}

function v4.render(p1) -- line: 14
	-- upvalues: Roact (copy), v3 (copy)
	return Roact.createElement("ImageButton", {
		Active = true,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = p1.props.BackgroundTransparency,
		BackgroundColor3 = p1.props.BackgroundColor3,
		Selectable = not v3 and nil,
		Visible = p1.props.Visible
	}, p1.props[Roact.Children])
end

return v4
