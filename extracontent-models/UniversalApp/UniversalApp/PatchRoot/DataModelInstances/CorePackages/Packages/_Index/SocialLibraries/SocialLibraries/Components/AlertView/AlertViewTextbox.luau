local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Cryo = dependencies.Cryo
local Images = require(script.Parent.Images)
local color3 = Color3.fromRGB(200, 200, 200)
local rect = Rect.new(7, 8, 7, 8)
local v9 = Roact.PureComponent:extend("AlertViewTextbox")

v9.defaultProps = {
	LayoutOrder = 0,
	Text = "",
	PlaceholderText = nil
}

function v9.render(p1) -- line: 19
	-- upvalues: UIBlox (copy), rect (copy), Roact (copy), Images (copy), color3 (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 20
		-- upvalues: p1 (copy), rect (copy), Roact (copy), Images (copy), color3 (copy)
		local vector2 = Vector2.new(0, 0)
		local vector2_2 = Vector2.new(0, 0)
		local p2Font = p2.Font
		local propsLayoutOrder = p1.props.LayoutOrder
		local PlaceholderText = p1.props.PlaceholderText
		local Theme = p2.Theme
		local v20 = rect

		return Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ImageRectSize = vector2_2,
			Image = Images.buttonStroke.Image,
			ImageColor3 = Theme.UIDefault.Color,
			ImageRectOffset = vector2,
			LayoutOrder = propsLayoutOrder,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			SliceCenter = v20
		}, {
			Textbox = Roact.createElement("TextBox", {
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = p2Font.Header2.Font,
				PlaceholderText = PlaceholderText,
				PlaceholderColor3 = color3,
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 1, 0),
				Text = p1.props.Text,
				TextColor3 = Theme.TextDefault.Color,
				TextSize = p2Font.BaseSize * p2Font.CaptionBody.RelativeSize,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				[Roact.Change.Text] = function(p3) -- line: 57
					-- upvalues: p1 (copy)
					if p1.props.onTextChanged then
						p1.props.onTextChanged(p3.Text)
					end
				end,
				[Roact.Ref] = p1.props.forwardRef
			})
		})
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 69
	-- upvalues: Roact (copy), v9 (copy), Cryo (copy)
	return Roact.createElement(v9, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
