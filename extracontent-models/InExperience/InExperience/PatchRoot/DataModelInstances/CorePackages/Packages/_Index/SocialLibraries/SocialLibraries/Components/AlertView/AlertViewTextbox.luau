local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local cryo = dependencies.Cryo
local Images = require(script.Parent.Images)
local foundationFontFaceMigration = dependencies.Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace

local color = Color3.fromRGB(200, 200, 200)
local rect = Rect.new(7, 8, 7, 8)

local extended = roact.PureComponent:extend("AlertViewTextbox")

extended.defaultProps = { LayoutOrder = 0, Text = "", PlaceholderText = nil }

function extended.render(p)
	return uiBlox.Style.withStyle(function(p2)
		local vector2 = Vector2.new(0, 0)
		local vector2_2 = Vector2.new(0, 0)

		local font = p2.Font
		local layoutOrder = p.props.LayoutOrder
		local placeholderText = p.props.PlaceholderText
		local theme = p2.Theme

		local createElement = roact.createElement
		local v = {
			ImageRectSize = vector2_2,
			BackgroundTransparency = 1,
			Image = Images.buttonStroke.Image,
			ImageColor3 = theme.UIDefault.Color,
			ImageRectOffset = vector2,
			LayoutOrder = layoutOrder,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			SliceCenter = rect
		}

		local createElement2 = roact.createElement
		local font2

		if not foundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		local fontFace

		if foundationFontFaceMigration then
			fontFace = normalizeFontFace(font.Header2.Font)
		end

		return createElement("ImageLabel", v, {
			Textbox = createElement2("TextBox", {
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = font2,
				FontFace = fontFace,
				PlaceholderText = placeholderText,
				PlaceholderColor3 = color,
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 1, 0),
				Text = p.props.Text,
				TextColor3 = theme.TextDefault.Color,
				TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				[roact.Change.Text] = function(p3)
					if p.props.onTextChanged then
						p.props.onTextChanged(p3.Text)
					end
				end,
				[roact.Ref] = p.props.forwardRef
			})
		})
	end)
end

return roact.forwardRef(function(p, forwardRef)
	return roact.createElement(extended, cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
