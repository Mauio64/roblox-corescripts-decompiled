local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local AppParentParent = AppParent.Parent
local React = require(AppParentParent.React)

require(App.ImageSet.ImagesTypes)

local IconSize = require(App.ImageSet.Enum.IconSize)
local getIconSize = require(App.ImageSet.getIconSize)
local StatWidget = require(App.Indicator.StatWidget)

require(App.Style.Fonts)

local useStyle = require(AppParent.Core.Style.useStyle)
local GetTextSize = require(AppParent.Core.Text.GetTextSize)
local UIBloxConfig = require(AppParent.UIBloxConfig)

require(AppParent.App.Style.StyleTypes)

local v11 = getIconSize(IconSize.Large)

local function getTextWidth(p1, p2, p3) -- line: 32
	-- upvalues: GetTextSize (copy)
	local BaseSize = p3.Font.BaseSize
	local v19 = p2.RelativeSize * BaseSize
	local vector2 = Vector2.new(10000, 10000)

	return GetTextSize(p1, v19, p2.Font, vector2).X
end
local function getMeasuredSectionWidth(p4, p5) -- line: 39
	-- upvalues: UIBloxConfig (copy), getIconSize (copy), IconSize (copy), v11 (copy), GetTextSize (copy)
	local v23 = if not UIBloxConfig.enableScalingForSomeEdpIcons then v11 else getIconSize(IconSize.Large, p5)
	local countText = p4.countText
	local FontTitle = p5.Font.Title
	local BaseSize = p5.Font.BaseSize
	local v27 = FontTitle.RelativeSize * BaseSize
	local vector2 = Vector2.new(10000, 10000)
	local X = GetTextSize(countText, v27, FontTitle.Font, vector2).X
	local labelText = p4.labelText
	local CaptionHeader = p5.Font.CaptionHeader
	local BaseSize2 = p5.Font.BaseSize
	local v33 = CaptionHeader.RelativeSize * BaseSize2
	local vector2_2 = Vector2.new(10000, 10000)

	return math.max(X, GetTextSize(labelText, v33, CaptionHeader.Font, vector2_2).X) + v23 + 12
end
local function PlayerCount(t1: {[any]: any}) -- line: 46
	-- upvalues: useStyle (copy), UIBloxConfig (copy), getIconSize (copy), IconSize (copy), v11 (copy), GetTextSize (copy), React (copy), StatWidget (copy)
	local v36 = useStyle()
	local countLeft = t1.countLeft
	local v38 = if not UIBloxConfig.enableScalingForSomeEdpIcons then v11 else getIconSize(IconSize.Large, v36)
	local countText = countLeft.countText
	local FontTitle = v36.Font.Title
	local BaseSize = v36.Font.BaseSize
	local v42 = FontTitle.RelativeSize * BaseSize
	local vector2 = Vector2.new(10000, 10000)
	local X = GetTextSize(countText, v42, FontTitle.Font, vector2).X
	local labelText = countLeft.labelText
	local CaptionHeader = v36.Font.CaptionHeader
	local BaseSize3 = v36.Font.BaseSize
	local v48 = CaptionHeader.RelativeSize * BaseSize3
	local vector2_3 = Vector2.new(10000, 10000)
	local v50 = math.max(X, GetTextSize(labelText, v48, CaptionHeader.Font, vector2_3).X) + v38 + 12
	local countRight = t1.countRight
	local v52 = if not UIBloxConfig.enableScalingForSomeEdpIcons then v11 else getIconSize(IconSize.Large, v36)
	local countText2 = countRight.countText
	local FontTitle2 = v36.Font.Title
	local BaseSize4 = v36.Font.BaseSize
	local v56 = FontTitle2.RelativeSize * BaseSize4
	local vector2_4 = Vector2.new(10000, 10000)
	local X2 = GetTextSize(countText2, v56, FontTitle2.Font, vector2_4).X
	local labelText2 = countRight.labelText
	local CaptionHeader2 = v36.Font.CaptionHeader
	local BaseSize5 = v36.Font.BaseSize
	local v62 = CaptionHeader2.RelativeSize * BaseSize5
	local vector2_5 = Vector2.new(10000, 10000)
	local v64 = v50 / (v50 + (math.max(X2, GetTextSize(labelText2, v62, CaptionHeader2.Font, vector2_5).X) + v52 + 12))
	local v65 = 1 - v64
	local countLeft2 = t1.countLeft
	local countRight2 = t1.countRight

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		LeftSection = React.createElement(StatWidget, {
			layoutOrder = 1,
			countText = countLeft2.countText,
			labelText = countLeft2.labelText,
			icon = countLeft2.icon,
			position = UDim2.new(0, 0, 0, 0),
			anchorPoint = Vector2.new(0, 0),
			size = UDim2.new(v64, 0, 1, 0),
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			styleProps = if not UIBloxConfig.enableScalingForSomeEdpIcons then nil else {
				iconSize = math.floor((getIconSize(IconSize.Large, v36)))
			}
		}),
		RightSection = React.createElement(StatWidget, {
			layoutOrder = 2,
			countText = countRight2.countText,
			labelText = countRight2.labelText,
			icon = countRight2.icon,
			position = UDim2.new(1, 0, 0, 0),
			anchorPoint = Vector2.new(1, 0),
			size = UDim2.new(v65, 0, 1, 0),
			horizontalAlignment = Enum.HorizontalAlignment.Right,
			styleProps = if not UIBloxConfig.enableScalingForSomeEdpIcons then nil else {
				iconSize = math.floor((getIconSize(IconSize.Large, v36)))
			}
		})
	})
end

return PlayerCount
