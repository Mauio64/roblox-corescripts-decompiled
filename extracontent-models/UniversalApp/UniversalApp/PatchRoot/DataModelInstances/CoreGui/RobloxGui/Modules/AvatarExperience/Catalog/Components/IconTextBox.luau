local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local rect = Rect.new(7, 8, 7, 8)
local v10 = Roact.PureComponent:extend("IconTextBox")

v10.defaultProps = {
	LayoutOrder = 0,
	imagePadding = 6
}

function v10.render(p1) -- line: 23
	-- upvalues: UIBlox (copy), withSelectionCursorProvider (copy), Roact (copy), rect (copy), ImageSetLabel (copy), Focusable (copy), CursorKind (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 24
		-- upvalues: p1 (copy), withSelectionCursorProvider (copy), Roact (copy), rect (copy), ImageSetLabel (copy), Focusable (copy), CursorKind (copy)
		local p2Font = p2.Font
		local Theme = p2.Theme
		local propsImage = p1.props.Image
		local imagePadding = p1.props.imagePadding
		local propsLayoutOrder = p1.props.LayoutOrder
		local PlaceholderText = p1.props.PlaceholderText
		local v21 = p2Font.BaseSize * p2Font.Body.RelativeSize
		local v22 = v21 + imagePadding * 2
		local forwardRef = p1.props.forwardRef

		return withSelectionCursorProvider(function(p3) -- line: 37
			-- upvalues: Roact (copy), Theme (copy), propsLayoutOrder (copy), rect (copy), ImageSetLabel (copy), imagePadding (copy), v21 (copy), propsImage (copy), Focusable (copy), p2Font (copy), PlaceholderText (copy), v22 (copy), p1 (copy), forwardRef (copy), CursorKind (copy)
			return Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaDiscussions/buttonStroke.png",
				ImageRectSize = Vector2.new(0, 0),
				ImageColor3 = Theme.UIDefault.Color,
				ImageRectOffset = Vector2.new(0, 0),
				LayoutOrder = propsLayoutOrder,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 30),
				SliceCenter = rect
			}, {
				IconImage = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, imagePadding, 0.5, 0),
					Size = UDim2.new(0, v21, 0, v21),
					Image = propsImage,
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				Textbox = Roact.createElement(Focusable.TextBox, {
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = p2Font.Header2.Font,
					PlaceholderText = PlaceholderText,
					PlaceholderColor3 = Theme.PlaceHolder.Color,
					Position = UDim2.new(0, v22, 0, 0),
					Size = UDim2.new(1, -v22, 1, 0),
					TextInputType = p1.props.TextInputType,
					Text = "",
					TextColor3 = Theme.TextDefault.Color,
					TextSize = v21,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					OverlayNativeInput = true,
					[Roact.Change.Text] = p1.props[Roact.Change.Text],
					[Roact.Ref] = forwardRef,
					NextSelectionLeft = p1.props.NextSelectionLeft,
					NextSelectionRight = p1.props.NextSelectionRight,
					NextSelectionUp = p1.props.NextSelectionUp,
					NextSelectionDown = p1.props.NextSelectionDown,
					SelectionImageObject = p3(CursorKind.RoundedRectNoInset)
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 89
	-- upvalues: Roact (copy), v10 (copy), Cryo (copy)
	return Roact.createElement(v10, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
