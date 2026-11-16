local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsactionseditadd = images["icons/actions/edit/add"]

local extended = Roact.PureComponent:extend("AvailableToSellRow")

extended.defaultProps = {
	horizontalPadding = 24,
	onActivated = function() end
}

function extended.render(p2)
	return withStyle(function(data)
		local font = data.Font
		local theme = data.Theme

		local position = p2.props.Position
		local layoutOrder = p2.props.LayoutOrder
		local horizontalPadding = p2.props.horizontalPadding
		local onActivated = p2.props.onActivated

		local v5 = font.BaseSize * font.Body.RelativeSize
		local text = p2.props.Text

		local forwardRef = p2.props.forwardRef

		return withSelectionCursorProvider(function(callback)
			local createElement = Roact.createElement
			local frame = focusable.Frame
			local forwardRefsByRef = {
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Position = position,
				Size = UDim2.new(1, 0, 0, 70),
				NextSelectionLeft = p2.props.NextSelectionLeft,
				NextSelectionRight = p2.props.NextSelectionRight,
				NextSelectionUp = p2.props.NextSelectionUp,
				NextSelectionDown = p2.props.NextSelectionDown,
				[Roact.Ref] = forwardRef,
				SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
			}
			local children = {
				Paddding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, horizontalPadding),
					PaddingRight = UDim.new(0, horizontalPadding)
				}),
				TextLabel = 0,
				PressableButton = 0
			}

			local createElement2 = Roact.createElement
			local v7 = {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 1,
				Position = 0,
				Size = 0,
				Text = 0,
				TextColor3 = 0,
				TextSize = 0,
				TextTransparency = 0,
				TextXAlignment = 0
			}

			local v8 = if not foundationFontFaceMigration then font.Body.Font else nil
			v7.Font = v8

			local v9 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
			v7.FontFace = v9

			v7.Position = UDim2.new(0, 0, 0.5, 0)
			v7.Size = UDim2.new(1, -50, 1, 0)
			v7.Text = text
			v7.TextColor3 = theme.TextDefault.Color
			v7.TextSize = v5
			v7.TextTransparency = theme.TextDefault.Transparency
			v7.TextXAlignment = Enum.TextXAlignment.Left
			children.TextLabel = createElement2("TextLabel", v7)

			children.PressableButton = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -50, 0.5, 0),
				Size = UDim2.new(0, 50, 0, 50),
				Text = "",
				[Roact.Event.Activated] = onActivated
			}, {
				RemoveButton = Roact.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = iconsactionseditadd,
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					LayoutOrder = 2,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 40, 0, 40)
				})
			})
			return createElement(frame, forwardRefsByRef, children)
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
