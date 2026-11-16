local App = script:FindFirstAncestor("App")
local parent = App.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
require(App.ImageSet.ImagesTypes)
local IconSize = require(App.ImageSet.Enum.IconSize)
local getIconSize = require(App.ImageSet.getIconSize)
local StatWidget = require(App.Indicator.StatWidget)
require(App.Style.Fonts)
local useStyle = require(parent.Core.Style.useStyle)
local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)
local UIBloxConfig = require(parent.UIBloxConfig)
require(parent.App.Style.StyleTypes)

local iconSize = getIconSize(IconSize.Large)

local function getTextWidth(p, p2, p3) -- 2 equivalent calls inferred from this helper
	local baseSize = p3.Font.BaseSize
	local v = p2.RelativeSize * baseSize
	local vector2 = Vector2.new(10000, 10000)
	return GetTextSize(p, v, GetFontFromFontStyle(p2), vector2).X
end

local function getMeasuredSectionWidth(p, p2) -- 2 equivalent calls inferred from this helper
	local v

	if UIBloxConfig.enableScalingForSomeEdpIcons then
		v = getIconSize(IconSize.Large, p2)
	else
		v = iconSize
	end

	return math.max(getTextWidth(p.countText, p2.Font.Title, p2), getTextWidth(p.labelText, p2.Font.CaptionHeader, p2)) + v + 12 -- inferred equivalent call
end

local function PlayerCount(props)
	local v = useStyle()

	local measuredSectionWidth = getMeasuredSectionWidth(props.countLeft, v) -- inferred equivalent call
	local v2 = measuredSectionWidth / (measuredSectionWidth + getMeasuredSectionWidth(props.countRight, v)) -- inferred equivalent call
	local v3 = 1 - v2

	local countLeft = props.countLeft
	local countRight = props.countRight

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			LeftSection = React.createElement(StatWidget, {
				countText = countLeft.countText,
				labelText = countLeft.labelText,
				icon = countLeft.icon,
				layoutOrder = 1,
				position = UDim2.new(0, 0, 0, 0),
				anchorPoint = Vector2.new(0, 0),
				size = UDim2.new(v2, 0, 1, 0),
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				styleProps = UIBloxConfig.enableScalingForSomeEdpIcons and {
					iconSize = math.floor((getIconSize(IconSize.Large, v)))
				} or nil
			}),
			RightSection = React.createElement(StatWidget, {
				countText = countRight.countText,
				labelText = countRight.labelText,
				icon = countRight.icon,
				layoutOrder = 2,
				position = UDim2.new(1, 0, 0, 0),
				anchorPoint = Vector2.new(1, 0),
				size = UDim2.new(v3, 0, 1, 0),
				horizontalAlignment = Enum.HorizontalAlignment.Right,
				styleProps = UIBloxConfig.enableScalingForSomeEdpIcons and {
					iconSize = math.floor((getIconSize(IconSize.Large, v)))
				} or nil
			})
		}
	)
end

return PlayerCount
