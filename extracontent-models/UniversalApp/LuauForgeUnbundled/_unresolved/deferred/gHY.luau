local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/ego")
local React = require(CorePackages.Packages.React)
local module2 = require("@luauforge/deferred/fFU")

local module3 = require("@luauforge/bundled/dzD")
local module4 = require("@luauforge/bundled/egM")
local module5 = require("@luauforge/bundled/egF")

local fFlagPeopleListContextualMenuFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPeopleListContextualMenuFixFocusNavigation
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId

local white = module3.Color.WHITE
local sourceSans = Enum.Font.SourceSans

local GREEN_PRIMARY = module3.Color.GREEN_PRIMARY

local center = Enum.HorizontalAlignment.Center
local rect = Rect.new(3, 3, 4, 4)
local slice = Enum.ScaleType.Slice

local extended = module.PureComponent:extend("FitImageTextButton")

extended.defaultProps = {
	backgroundColor = GREEN_PRIMARY,
	height = 32,
	iconRightPadding = 3,
	iconSize = 16,
	layoutOrder = 0,
	text = "",
	textColor = white,
	textFont = sourceSans,
	textSize = 20,
	horizontalPadding = 7,
	verticalPadding = 0,
	maxWidth = 0,
	minWidth = 1000,
	scaleType = slice,
	sliceCenter = rect,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0)
}

function extended:getImageButtonAndTextWidth()
	local maxWidth = self.props.maxWidth
	local minWidth = self.props.minWidth
	local text = self.props.text
	local textFont = self.props.textFont
	local textSize = self.props.textSize
	local horizontalPadding = self.props.horizontalPadding

	local v5 = self.props.leftIcon and true

	local v6 = center
	local v7 = module2.GetTextWidth(text, textFont, textSize) - 2

	local v8 = v7 + 2 * horizontalPadding

	if v5 then
		v8 = v8 + self.props.iconRightPadding + self.props.iconSize
	end

	if maxWidth < v8 then
		v6 = Enum.HorizontalAlignment.Left
	end

	return math.max(minWidth, (math.min(v8, maxWidth))), v7, v6
end

function extended:render()
	local backgroundImage = self.props.backgroundImage
	local backgroundColor = self.props.backgroundColor
	local backgroundTransparency = self.props.backgroundTransparency
	local height = self.props.height
	local horizontalPadding = self.props.horizontalPadding
	local verticalPadding = self.props.verticalPadding
	local iconRightPadding = self.props.iconRightPadding
	local iconSize = self.props.iconSize
	local iconColor = self.props.iconColor
	local layoutOrder = self.props.layoutOrder
	local leftIcon = self.props.leftIcon
	local onActivated = self.props.onActivated
	local text = self.props.text
	local textColor = self.props.textColor
	local textTransparency = self.props.textTransparency
	local textFont = self.props.textFont
	local textSize = self.props.textSize
	local sliceCenter = self.props.sliceCenter
	local scaleType = self.props.scaleType
	local v5 = leftIcon and true
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local selectionOrder = if fFlagPeopleListContextualMenuFixFocusNavigation then self.props.selectionOrder else nil

	local imageButtonAndTextWidth, v6, v7 = self:getImageButtonAndTextWidth()

	local forwardRef = self.props.forwardRef

	local createElement = module.createElement
	local v9 = {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		["Image"] = backgroundImage,
		ImageColor3 = backgroundColor,
		ImageTransparency = backgroundTransparency,
		LayoutOrder = layoutOrder,
		ScaleType = scaleType,
		SliceCenter = sliceCenter,
		Size = UDim2.new(0, imageButtonAndTextWidth, 0, height),
		AnchorPoint = anchorPoint,
		Position = position
	}

	if not fFlagPeopleListContextualMenuFixFocusNavigation then
		selectionOrder = nil
	end

	v9.SelectionOrder = selectionOrder

	v9[module.Event.Activated] = onActivated
	v9[module.Ref] = forwardRef
	local tag = React.Tag
	local v10 = if fFlagLuaAppAddTestIdsForArrow and self.props.testId then getTestId(self.props.testId) else nil
	v9[tag] = v10
	return createElement(module4, v9, {
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding),
			PaddingTop = UDim.new(0, verticalPadding),
			PaddingBottom = UDim.new(0, verticalPadding)
		}),
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = v7,
			Padding = UDim.new(0, v5 and iconRightPadding or 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LeftIcon = v5 and module.createElement(module5, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = leftIcon,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, iconSize, 0, iconSize),
			ImageColor3 = iconColor
		}),
		Text = module.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Font = textFont,
			LayoutOrder = 2,
			Size = UDim2.new(0, v6, 1, 0),
			Text = text,
			TextColor3 = textColor,
			TextTransparency = textTransparency,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return module.forwardRef(function(p2, p3)
	return module.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
