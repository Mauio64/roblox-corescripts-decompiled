local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local v5 = Roact.PureComponent:extend("AlertViewLabel")

v5.defaultProps = {
	BackgroundTransparency = 1,
	Text = "",
	Size = UDim2.new(1, 0, 0, 40),
	TextXAlignment = Enum.TextXAlignment.Center
}

function v5.render(p1) -- line: 14
	-- upvalues: UIBlox (copy), Roact (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 15
		-- upvalues: p1 (copy), Roact (copy)
		local propsBackgroundTransparency = p1.props.BackgroundTransparency
		local v9 = p1.props.Font or p2.Font.Body.Font
		local propsText = p1.props.Text
		local v11 = p1.props.TextColor3 or p2.Theme.TextDefault.Color
		local v12 = p1.props.TextSize or p2.Font.Body.RelativeSize * p2.Font.BaseSize
		local TextXAlignment = p1.props.TextXAlignment

		return Roact.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = propsBackgroundTransparency,
			Font = v9,
			LayoutOrder = p1.props.LayoutOrder,
			Size = p1.props.Size,
			Text = propsText,
			TextColor3 = v11,
			TextSize = v12,
			TextXAlignment = TextXAlignment
		})
	end)
end

return v5
