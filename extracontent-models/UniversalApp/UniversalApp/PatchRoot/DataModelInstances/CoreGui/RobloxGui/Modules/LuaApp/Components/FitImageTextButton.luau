local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(Modules.Common.Roact)
local Text = require(Modules.Common.Text)
local Constants = require(Modules.LuaApp.Constants)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local FFlagPeopleListContextualMenuFixFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPeopleListContextualMenuFixFocusNavigation
local WHITE = Constants.Color.WHITE
local SourceSans = Enum.Font.SourceSans
local GREEN_PRIMARY = Constants.Color.GREEN_PRIMARY
local Center = Enum.HorizontalAlignment.Center
local rect = Rect.new(3, 3, 4, 4)
local Slice = Enum.ScaleType.Slice
local v16 = Roact.PureComponent:extend("FitImageTextButton")

v16.defaultProps = {
	height = 32,
	iconRightPadding = 3,
	iconSize = 16,
	layoutOrder = 0,
	text = "",
	textSize = 20,
	horizontalPadding = 7,
	verticalPadding = 0,
	maxWidth = 0,
	minWidth = 1000,
	backgroundColor = GREEN_PRIMARY,
	textColor = WHITE,
	textFont = SourceSans,
	scaleType = Slice,
	sliceCenter = rect,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0)
}

function v16.getImageButtonAndTextWidth(p1) -- line: 62
	-- upvalues: Text (copy), Center (copy)
	local maxWidth = p1.props.maxWidth
	local minWidth = p1.props.minWidth
	local text = p1.props.text
	local textFont = p1.props.textFont
	local textSize = p1.props.textSize
	local horizontalPadding = p1.props.horizontalPadding
	local v24 = p1.props.leftIcon and true
	local v25 = Text.GetTextWidth(text, textFont, textSize)
	local v26 = Center
	local v27 = v25 - 2
	local v28 = v27 + 2 * horizontalPadding

	if v24 then
		v28 = v28 + p1.props.iconRightPadding + p1.props.iconSize
	end

	if maxWidth < v28 then
		v26 = Enum.HorizontalAlignment.Left
	end

	return math.max(minWidth, (math.min(v28, maxWidth))), v27, v26
end
function v16.render(p2) -- line: 91
	-- upvalues: FFlagPeopleListContextualMenuFixFocusNavigation (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DEPRECATED_ImageSetLabel (copy)
	local backgroundImage = p2.props.backgroundImage
	local backgroundColor = p2.props.backgroundColor
	local backgroundTransparency = p2.props.backgroundTransparency
	local height = p2.props.height
	local horizontalPadding = p2.props.horizontalPadding
	local verticalPadding = p2.props.verticalPadding
	local iconRightPadding = p2.props.iconRightPadding
	local iconSize = p2.props.iconSize
	local iconColor = p2.props.iconColor
	local layoutOrder = p2.props.layoutOrder
	local leftIcon = p2.props.leftIcon
	local onActivated = p2.props.onActivated
	local text = p2.props.text
	local textColor = p2.props.textColor
	local textTransparency = p2.props.textTransparency
	local textFont = p2.props.textFont
	local textSize = p2.props.textSize
	local sliceCenter = p2.props.sliceCenter
	local scaleType = p2.props.scaleType
	local v49 = leftIcon and true
	local anchorPoint = p2.props.anchorPoint
	local position = p2.props.position
	local v52 = if not FFlagPeopleListContextualMenuFixFocusNavigation then nil else p2.props.selectionOrder
	local v53, v54, v55 = p2:getImageButtonAndTextWidth()
	local forwardRef = p2.props.forwardRef

	return Roact.createElement(DEPRECATED_ImageSetButton, {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = backgroundImage,
		ImageColor3 = backgroundColor,
		ImageTransparency = backgroundTransparency,
		LayoutOrder = layoutOrder,
		ScaleType = scaleType,
		SliceCenter = sliceCenter,
		Size = UDim2.new(0, v53, 0, height),
		AnchorPoint = anchorPoint,
		Position = position,
		SelectionOrder = if not FFlagPeopleListContextualMenuFixFocusNavigation then nil else v52,
		[Roact.Event.Activated] = onActivated,
		[Roact.Ref] = forwardRef
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding),
			PaddingTop = UDim.new(0, verticalPadding),
			PaddingBottom = UDim.new(0, verticalPadding)
		}),
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = v55,
			Padding = UDim.new(0, v49 and iconRightPadding or 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LeftIcon = v49 and Roact.createElement(DEPRECATED_ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Image = leftIcon,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, iconSize, 0, iconSize),
			ImageColor3 = iconColor
		}),
		Text = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Font = textFont,
			Size = UDim2.new(0, v54, 1, 0),
			Text = text,
			TextColor3 = textColor,
			TextTransparency = textTransparency,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return Roact.forwardRef(function(p3, p4) -- line: 177
	-- upvalues: Roact (copy), v16 (copy), Cryo (copy)
	return Roact.createElement(v16, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
