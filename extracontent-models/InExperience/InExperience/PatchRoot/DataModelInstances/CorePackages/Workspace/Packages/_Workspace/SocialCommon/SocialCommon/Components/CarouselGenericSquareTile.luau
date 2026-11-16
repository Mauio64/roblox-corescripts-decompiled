local parent = script:FindFirstAncestor("SocialCommon").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Dash = require(parent.Dash)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local IconSize = UIBlox.App.Constant.IconSize
local Badge = UIBlox.App.Indicator.Badge
local Colors = UIBlox.App.Style.Colors

local Impressions = require(parent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger

local v = {
	badgeValue = nil,
	icon = "",
	labelText = "",
	onActivated = function() end,
	tileSize = 100,
	iconSize = IconSize.Large,
	borderThickness = 0,
	cornerRadius = UDim.new(0, 8),
	styleProps = { textXAlignment = Enum.TextXAlignment.Center, containFooterInTileSize = false }
}

return function(options)
	local joined = Dash.join(v, options or {})
	local v2 = useStyle()
	local font = v2.Font

	local styleProps = joined.styleProps
	local fontStyle

	if styleProps.font then
		fontStyle = styleProps.font
	else
		fontStyle = font.CaptionHeader
	end

	local v3 = font.BaseSize * fontStyle.RelativeSize
	local textHeight = Text.GetTextHeight(joined.labelText, fontStyle.Font, v3)

	local v4 = joined.tileSize - joined.borderThickness

	if joined.styleProps.containFooterInTileSize then
		v4 = v4 - textHeight * 2 - 8
	end

	local ref

	if joined.impressionsTag then
		ref = React.useRef(nil)
		useImpressionsTagger(ref, joined.impressionsTag, joined.LayoutOrder)
	end

	return React.createElement("Frame", {
		LayoutOrder = joined.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(v4, 0),
		BackgroundTransparency = 1,
		ref = ref
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, joined.borderThickness)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		Tile = React.createElement(ImageSetButton, {
			Size = UDim2.fromOffset(v4, v4),
			BackgroundColor3 = v2.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = v2.Theme.BackgroundUIDefault.Transparency,
			[React.Event.Activated] = joined.onActivated,
			LayoutOrder = 1
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = joined.cornerRadius }),
			UIStroke = React.createElement("UIStroke", {
				Color = v2.Theme.Divider.Color,
				Transparency = v2.Theme.Divider.Transparency,
				Thickness = joined.borderThickness
			}),
			Icon = React.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageTransparency = v2.Theme.IconEmphasis.Transparency,
				ImageColor3 = Colors.White,
				Image = joined.icon,
				Size = UDim2.fromOffset(joined.iconSize, joined.iconSize),
				Position = UDim2.fromScale(0.5, 0.5)
			}),
			Badge = joined.badgeValue and React.createElement(Badge, {
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.fromOffset(joined.tileSize - 8, 8),
				value = joined.badgeValue
			})
		}),
		Label = React.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			[React.Event.Activated] = joined.onActivated,
			LayoutOrder = 2
		}, {
			Text = React.createElement(StyledTextLabel, {
				text = joined.labelText,
				fontStyle = fontStyle,
				colorStyle = v2.Theme.TextEmphasis,
				size = UDim2.fromOffset(v4, textHeight * 2),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = styleProps.textXAlignment,
				textYAlignment = Enum.TextYAlignment.Top,
				fluidSizing = false,
				richText = false,
				lineHeight = 1
			})
		})
	})
end
