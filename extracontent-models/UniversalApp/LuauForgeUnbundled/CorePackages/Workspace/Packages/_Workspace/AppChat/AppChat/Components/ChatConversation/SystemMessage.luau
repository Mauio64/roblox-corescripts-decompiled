local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("SystemMessage")
extended.defaultProps = {
	LayoutOrder = nil,
	Text = "PLACEHOLDER This message could not be displayed",
	maxWidth = 250
}

function extended:init()
	self.calculateSize = memoize(function(p3, p4, p5, p6)
		if foundationFontFaceMigration then
			return getTextSize(p3, p6, p5, Vector2.new(p4, 1000))
		end

		return text.GetTextBounds(p3, p5, p6, Vector2.new(p4, 1000))
	end)
end

function extended.render(p2)
	return withStyle(function(props)
		local captionBody = props.Font.CaptionBody
		local v5 = props.Font.BaseSize * captionBody.RelativeSize
		local calculateSize = p2.calculateSize
		local text2 = p2.props.Text
		local maxWidth = p2.props.maxWidth
		local v6

		if foundationFontFaceMigration then
			v6 = props.Tokens.Typography.BodySmall.Font
		else
			v6 = captionBody.Font
		end

		local v7 = calculateSize(text2, maxWidth, v6, v5)

		local createElement = Roact.createElement
		local v9 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p2.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 30 + v7.Y + 8)
		}
		local v10 = {
			UiListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 20) }),
			GreyBox = 0
		}

		local createElement2 = Roact.createElement
		local v12 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/LuaChat/9-slice/system-message.png",
			ImageTransparency = 1,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(0, math.min(p2.props.maxWidth, v7.X) + 12, 0, v7.Y + 8),
			SliceCenter = Rect.new(3, 3, 4, 4)
		}

		local createElement3 = Roact.createElement
		local v15 = {
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

		local v16 = if not foundationFontFaceMigration then captionBody.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
		v15.FontFace = v17

		v15.Position = UDim2.new(0.5, 0, 0.5, 0)
		v15.Size = UDim2.new(1, 0, 1, 0)
		v15.Text = p2.props.Text
		v15.TextColor3 = props.Theme.TextDefault.Color
		v15.TextSize = v5
		v15.TextTransparency = props.Theme.TextDefault.Transparency
		v10.GreyBox = createElement2("ImageLabel", v12, {
			SystemText = createElement3("TextLabel", v15)
		})
		return createElement("Frame", v9, v10)
	end)
end

return extended
