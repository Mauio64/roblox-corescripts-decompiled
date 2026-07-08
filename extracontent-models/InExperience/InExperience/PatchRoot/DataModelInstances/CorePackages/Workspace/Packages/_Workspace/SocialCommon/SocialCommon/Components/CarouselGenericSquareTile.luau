local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Dash = require(Parent.Dash)
local Text = require(Parent.AppCommonLib).Text
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local IconSize = UIBlox.App.Constant.IconSize
local Badge = UIBlox.App.Indicator.Badge
local Colors = UIBlox.App.Style.Colors
local useImpressionsTagger = require(Parent.Impressions).useImpressionsTagger
local t1 = {
	badgeValue = nil,
	icon = "",
	labelText = "",
	tileSize = 100,
	borderThickness = 0,
	onActivated = function() -- line: 62
	end,
	iconSize = IconSize.Large,
	cornerRadius = UDim.new(0, 8),
	styleProps = {
		containFooterInTileSize = false,
		textXAlignment = Enum.TextXAlignment.Center
	}
}

return function(p1) -- line: 73
	-- upvalues: Dash (copy), t1 (copy), useStyle (copy), Text (copy), React (copy), useImpressionsTagger (copy), ImageSetButton (copy), ImageSetLabel (copy), Colors (copy), Badge (copy), StyledTextLabel (copy)
	local v16 = Dash.join(t1, p1 or {})
	local v17 = useStyle()
	local Font = v17.Font
	local styleProps = v16.styleProps
	local v20 = if not styleProps.font then Font.CaptionHeader else styleProps.font
	local v21 = Font.BaseSize * v20.RelativeSize
	local v22 = Text.GetTextHeight(v16.labelText, v20.Font, v21)
	local v23 = v16.tileSize - v16.borderThickness

	if v16.styleProps.containFooterInTileSize then
		v23 = v23 - v22 * 2 - 8
	end

	local v24 = nil

	if v16.impressionsTag then
		v24 = React.useRef(nil)
		useImpressionsTagger(v24, v16.impressionsTag, v16.LayoutOrder)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = v16.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(v23, 0),
		ref = v24
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v16.borderThickness)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		Tile = React.createElement(ImageSetButton, {
			Size = UDim2.fromOffset(v23, v23),
			BackgroundColor3 = v17.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = v17.Theme.BackgroundUIDefault.Transparency,
			[React.Event.Activated] = v16.onActivated,
			LayoutOrder = 1
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = v16.cornerRadius
			}),
			UIStroke = React.createElement("UIStroke", {
				Color = v17.Theme.Divider.Color,
				Transparency = v17.Theme.Divider.Transparency,
				Thickness = v16.borderThickness
			}),
			Icon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = v17.Theme.IconEmphasis.Transparency,
				ImageColor3 = Colors.White,
				Image = v16.icon,
				Size = UDim2.fromOffset(v16.iconSize, v16.iconSize),
				Position = UDim2.fromScale(0.5, 0.5)
			}),
			Badge = v16.badgeValue and React.createElement(Badge, {
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.fromOffset(v16.tileSize - 8, 8),
				value = v16.badgeValue
			})
		}),
		Label = React.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			[React.Event.Activated] = v16.onActivated,
			LayoutOrder = 2
		}, {
			Text = React.createElement(StyledTextLabel, {
				fluidSizing = false,
				richText = false,
				lineHeight = 1,
				text = v16.labelText,
				fontStyle = v20,
				colorStyle = v17.Theme.TextEmphasis,
				size = UDim2.fromOffset(v23, v22 * 2),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = styleProps.textXAlignment,
				textYAlignment = Enum.TextYAlignment.Top
			})
		})
	})
end
