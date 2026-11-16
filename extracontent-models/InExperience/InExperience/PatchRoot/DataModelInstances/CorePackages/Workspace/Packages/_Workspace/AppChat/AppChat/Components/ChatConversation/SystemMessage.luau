local parent = script:FindFirstAncestor("AppChat").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Roact = require(parent.Roact)
local AppCommonLib2 = require(parent.AppCommonLib)
local memoize = AppCommonLib2.memoize
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("SystemMessage")
extended.defaultProps = {
	LayoutOrder = nil,
	Text = "PLACEHOLDER This message could not be displayed",
	maxWidth = 250
}

function extended:init()
	self.calculateSize = memoize(function(p, p2, p3, p4)
		if FoundationFontFaceMigration then
			return GetTextSize(p, p4, p3, Vector2.new(p2, 1000))
		end

		return Text.GetTextBounds(p, p3, p4, Vector2.new(p2, 1000))
	end)
end

function extended.render(p)
	return withStyle(function(props)
		local captionBody = props.Font.CaptionBody
		local textSize = props.Font.BaseSize * captionBody.RelativeSize
		local calculateSize = p.calculateSize
		local text = p.props.Text
		local maxWidth = p.props.maxWidth
		local v

		if FoundationFontFaceMigration then
			v = props.Tokens.Typography.BodySmall.Font
		else
			v = captionBody.Font
		end

		local v2 = calculateSize(text, maxWidth, v, textSize)

		local createElement = Roact.createElement
		local v3 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 30 + v2.Y + 8)
		}
		local v4 = {
			UiListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 20) }),
			GreyBox = 0
		}

		local createElement2 = Roact.createElement
		local v5 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/LuaChat/9-slice/system-message.png",
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(0, math.min(p.props.maxWidth, v2.X) + 12, 0, v2.Y + 8),
			SliceCenter = Rect.new(3, 3, 4, 4)
		}

		local createElement3 = Roact.createElement
		local v6 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = 0,
			FontFace = 0,
			Position = 0,
			Size = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextWrapped = true
		}
		local font

		if not FoundationFontFaceMigration then
			font = captionBody.Font
		end

		v6.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
		end

		v6.FontFace = fontFace

		v6.Position = UDim2.new(0.5, 0, 0.5, 0)
		v6.Size = UDim2.new(1, 0, 1, 0)
		v6.Text = p.props.Text
		v6.TextColor3 = props.Theme.TextDefault.Color
		v6.TextSize = textSize
		v6.TextTransparency = props.Theme.TextDefault.Transparency
		v4.GreyBox = createElement2("ImageLabel", v5, {
			SystemText = createElement3("TextLabel", v6)
		})
		return createElement("Frame", v3, v4)
	end)
end

return extended
