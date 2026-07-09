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
	local richText = p1.props.richText
	local text = p1.props.text

	return withStyle(function(p2) -- line: 25
		-- upvalues: p1 (copy), contentWidth (copy), Roact (copy), FitTextLabel (copy), FitChildren (copy), layoutOrder (copy), richText (copy), text (copy)
		local BodyFont = p2.Font.Body.Font

		if p1.props.useBold == true then
			BodyFont = p2.Font.Header1.Font
		end

		local Center = Enum.TextXAlignment.Center

		if p1.props.alignLeft == true then
			Center = Enum.TextXAlignment.Left
		end

		local AutomaticSizeX = nil

		if contentWidth == 0 then
			AutomaticSizeX = Enum.AutomaticSize.X
		end

		return Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			fitAxis = FitChildren.FitAxis.Height,
			Font = BodyFont,
			LayoutOrder = layoutOrder or nil,
			RichText = richText,
			Size = UDim2.new(0, contentWidth, 0, 0),
			AutomaticSize = AutomaticSizeX,
			Text = text,
			TextColor3 = p2.Theme.TextDefault.Color,
			TextSize = p2.Font.Body.RelativeSize * p2.Font.BaseSize,
			TextTransparency = p2.Theme.TextDefault.Transparency,
			TextXAlignment = Center
		})
	end)
end

return v8
