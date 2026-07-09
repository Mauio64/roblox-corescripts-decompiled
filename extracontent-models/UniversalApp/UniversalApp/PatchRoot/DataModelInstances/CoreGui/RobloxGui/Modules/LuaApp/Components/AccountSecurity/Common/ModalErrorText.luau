local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local withStyle = UIBlox.Style.withStyle
local v8 = Roact.PureComponent:extend(script.Name)

v8.defaultProps = {
	contentWidth = 0
}

function v8.render(p1) -- line: 19
	-- upvalues: withStyle (copy), Roact (copy), FitTextLabel (copy), FitChildren (copy)
	local contentWidth = p1.props.contentWidth
	local layoutOrder = p1.props.layoutOrder
	local errorText = p1.props.errorText

	return withStyle(function(p2) -- line: 24
		-- upvalues: Roact (copy), FitTextLabel (copy), FitChildren (copy), layoutOrder (copy), contentWidth (copy), errorText (copy)
		return Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			fitAxis = FitChildren.FitAxis.Height,
			Font = p2.Font.Footer.Font,
			LayoutOrder = layoutOrder or nil,
			Size = UDim2.new(0, contentWidth, 0, 0),
			Text = errorText,
			TextColor3 = p2.Theme.Alert.Color,
			TextSize = p2.Font.BaseSize * p2.Font.Footer.RelativeSize,
			TextTransparency = p2.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	end)
end

return v8
