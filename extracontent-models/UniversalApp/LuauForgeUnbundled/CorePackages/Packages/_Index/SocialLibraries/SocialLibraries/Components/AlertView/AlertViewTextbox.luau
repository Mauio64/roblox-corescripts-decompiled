local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local rect = Rect.new(7, 8, 7, 8)

local extended = Roact.PureComponent:extend("IconTextBox")

extended.defaultProps = { LayoutOrder = 0, imagePadding = 6 }

function extended.render(p2)
	return UIBlox.Style.withStyle(function(p3)
		local font = p3.Font
		local theme = p3.Theme

		local image = p2.props.Image
		local imagePadding = p2.props.imagePadding
		local layoutOrder = p2.props.LayoutOrder
		local placeholderText = p2.props.PlaceholderText
		local v5 = font.BaseSize * font.Body.RelativeSize
		local v6 = v5 + imagePadding * 2

		local forwardRef = p2.props.forwardRef

		return withSelectionCursorProvider(function(callback)
			return Roact.createElement("ImageLabel", {
				ImageRectSize = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaDiscussions/buttonStroke.png",
				ImageColor3 = theme.UIDefault.Color,
				ImageRectOffset = Vector2.new(0, 0),
				LayoutOrder = layoutOrder,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 30),
				SliceCenter = rect
			}, {
				IconImage = Roact.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0, 0.5),
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, imagePadding, 0.5, 0),
					Size = UDim2.new(0, v5, 0, v5),
					Image = image,
					ImageColor3 = theme.TextDefault.Color,
					ImageTransparency = theme.TextDefault.Transparency
				}),
				Textbox = Roact.createElement(focusable.TextBox, {
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = font.Header2.Font,
					PlaceholderText = placeholderText,
					PlaceholderColor3 = theme.PlaceHolder.Color,
					Position = UDim2.new(0, v6, 0, 0),
					Size = UDim2.new(1, -v6, 1, 0),
					TextInputType = p2.props.TextInputType,
					Text = "",
					TextColor3 = theme.TextDefault.Color,
					TextSize = v5,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					OverlayNativeInput = true,
					[Roact.Change.Text] = p2.props[Roact.Change.Text],
					[Roact.Ref] = forwardRef,
					NextSelectionLeft = p2.props.NextSelectionLeft,
					NextSelectionRight = p2.props.NextSelectionRight,
					NextSelectionUp = p2.props.NextSelectionUp,
					NextSelectionDown = p2.props.NextSelectionDown,
					SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
