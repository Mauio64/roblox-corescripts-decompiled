local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Dash")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/AppCommonLib").Text

local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local iconSize = UIBlox.App.Constant.IconSize
local badge = UIBlox.App.Indicator.Badge
local colors = UIBlox.App.Style.Colors

local useImpressionsTagger = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Impressions").useImpressionsTagger

local v5 = {
	badgeValue = nil,
	icon = "",
	labelText = "",
	onActivated = function() end,
	tileSize = 100,
	iconSize = iconSize.Large,
	borderThickness = 0,
	cornerRadius = UDim.new(0, 8),
	styleProps = {
		textXAlignment = Enum.TextXAlignment.Center,
		containFooterInTileSize = false
	}
}

return function(options)
	local joined = Dash.join(v5, options or {})
	local v6 = useStyle()
	local font = v6.Font

	local styleProps = joined.styleProps
	local v7 = if styleProps.font then styleProps.font else font.CaptionHeader

	local v8 = font.BaseSize * v7.RelativeSize
	local textHeight = text.GetTextHeight(joined.labelText, v7.Font, v8)

	local v9 = joined.tileSize - joined.borderThickness

	if joined.styleProps.containFooterInTileSize then
		v9 = v9 - textHeight * 2 - 8
	end

	local ref

	if joined.impressionsTag then
		ref = React.useRef(nil)
		useImpressionsTagger(ref, joined.impressionsTag, joined.LayoutOrder)
	end

	return React.createElement("Frame", {
		LayoutOrder = joined.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(v9, 0),
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
		Tile = React.createElement(imageSetButton, {
			Size = UDim2.fromOffset(v9, v9),
			BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = v6.Theme.BackgroundUIDefault.Transparency,
			[React.Event.Activated] = joined.onActivated,
			LayoutOrder = 1
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = joined.cornerRadius
			}),
			UIStroke = React.createElement("UIStroke", {
				Color = v6.Theme.Divider.Color,
				Transparency = v6.Theme.Divider.Transparency,
				Thickness = joined.borderThickness
			}),
			Icon = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageTransparency = v6.Theme.IconEmphasis.Transparency,
				ImageColor3 = colors.White,
				Image = joined.icon,
				Size = UDim2.fromOffset(joined.iconSize, joined.iconSize),
				Position = UDim2.fromScale(0.5, 0.5)
			}),
			Badge = joined.badgeValue and React.createElement(badge, {
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.fromOffset(joined.tileSize - 8, 8),
				value = joined.badgeValue
			})
		}),
		Label = React.createElement(imageSetButton, {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			[React.Event.Activated] = joined.onActivated,
			LayoutOrder = 2
		}, {
			Text = React.createElement(styledTextLabel, {
				text = joined.labelText,
				fontStyle = v7,
				colorStyle = v6.Theme.TextEmphasis,
				size = UDim2.fromOffset(v9, textHeight * 2),
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
