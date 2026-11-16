local parent = script.Parent.Parent.Parent

local Roact = require(parent.Roact)
local t = require(parent.t)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Images = require(parent.UIBlox.App.ImageSet.Images)
local ImageSetComponent = require(parent.UIBlox.Core.ImageSet.ImageSetComponent)
local withStyle = require(parent.UIBlox.Core.Style.withStyle)
local RoundedFrame = require(parent.UIBlox.App.Menu.RoundedFrame)

local extended = Roact.PureComponent:extend("ModalBottomSheetButton")
local imageRectSize = Images["component_assets/circle_17"].ImageRectSize
local imageRectOffset = Images["component_assets/circle_17"].ImageRectOffset

local v = 8 * Images.ImagesResolutionScale
local v2 = 8 * Images.ImagesResolutionScale
local rect = Rect.new(v, v2, imageRectSize.x - v, imageRectSize.y - v2)
local v3 = 8 * Images.ImagesResolutionScale

extended.validateProps = t.strictInterface({
	icon = t.optional(t.union(t.table, t.string)),
	text = t.optional(t.string),
	onActivated = t.optional(t.callback),
	renderRightElement = t.optional(t.callback),
	showImage = t.boolean,
	isFixed = t.boolean,
	onActivatedAndDismissed = t.callback,
	elementHeight = t.integer,
	hasRoundBottom = t.boolean,
	hasRoundTop = t.boolean,
	LayoutOrder = t.integer,
	stayOnActivated = t.optional(t.boolean)
})

extended.defaultProps = {
	icon = {},
	text = "",
	onActivated = function() end
}

function extended:init()
	local binding, updatePressed = Roact.createBinding(false)
	self.pressed = binding
	self.updatePressed = updatePressed
	self.ref = Roact.createRef()
	function self.onColorChange(imageColor)
		if not self.ref.current then
			return
		end

		self.ref.current.ImageColor3 = imageColor
	end

	function self.onInputBegan(p): boolean
		return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
	end

	function self.onInputEnd(p): boolean
		return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
	end
end

function extended.render(data)
	local hasRoundTop = data.props.hasRoundTop
	local hasRoundBottom = data.props.hasRoundBottom

	local sliceCenter = nil

	local x = imageRectSize.X
	local halfX = x / 2
	local imageRectSize2, imageRectOffset2

	if hasRoundTop and hasRoundBottom then
		imageRectSize2 = imageRectSize
		imageRectOffset2 = imageRectOffset
		sliceCenter = rect
	elseif hasRoundTop then
		imageRectSize2 = Vector2.new(x, halfX)
		imageRectOffset2 = imageRectOffset
		sliceCenter = Rect.new(halfX - 1, halfX - 1, halfX + 1, halfX)
	elseif hasRoundBottom then
		imageRectSize2 = Vector2.new(x, halfX)
		imageRectOffset2 = imageRectOffset + Vector2.new(0, halfX)
		sliceCenter = Rect.new(halfX - 1, 0, halfX + 1, 1)
	else
		imageRectSize2 = Vector2.new(1, 1)
		imageRectOffset2 = imageRectOffset + Vector2.new(halfX, halfX)
	end

	local elementHeight = data.props.elementHeight
	local udim

	if data.props.isFixed then
		udim = UDim2.new(0, 300, 0, elementHeight)
	else
		udim = UDim2.new(1, -32, 0, elementHeight)
	end

	local v4 = (data.props.showImage or data.props.renderRightElement) and 12 or 24

	local v5 = v4
	local v6 = elementHeight * 0.8

	if data.props.showImage then
		v5 = v5 + v6 + v4
	end

	if data.props.renderRightElement then
		v5 = v5 + v6 + v4
	end

	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local mapped = data.pressed:map(function(p2)
			if p2 then
				return theme.BackgroundOnPress.Color
			end

			return theme.BackgroundUIDefault.Color
		end)

		local mapped2 = data.pressed:map(function(p2)
			if p2 then
				return theme.BackgroundOnPress.Transparency
			end

			return theme.BackgroundUIDefault.Transparency
		end)

		local color = theme.TextEmphasis.Color
		local transparency = theme.TextEmphasis.Transparency

		local createElement = Roact.createElement
		local v7 = {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = sliceCenter,
			Image = Images["component_assets/circle_17"].Image,
			ImageColor3 = mapped,
			ImageRectSize = imageRectSize2,
			ImageRectOffset = imageRectOffset2,
			ImageTransparency = mapped2,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = data.props.LayoutOrder,
			[Roact.Ref] = data.ref,
			[Roact.Event.Activated] = data.props.onActivatedAndDismissed,
			[Roact.Event.InputBegan] = function(_, p2)
				if data.onInputBegan(p2) then
					data.updatePressed(true)
				end
			end,
			[Roact.Event.InputEnded] = function(_, p2)
				if data.onInputEnd(p2) then
					data.updatePressed(false)
				end
			end
		}

		local createElement2 = Roact.createElement
		local v8 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local v9 = {
			horizontalLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v4)
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v4),
				PaddingTop = UDim.new(0.1, 0),
				PaddingBottom = UDim.new(0.1, 0)
			}),
			icon = 0,
			textLabel = 0,
			rightContainer = 0
		}
		local icon

		if data.props.showImage then
			icon = Roact.createElement(ImageSetComponent.Label, {
				Image = data.props.icon,
				ImageColor3 = color,
				ImageTransparency = transparency,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v6, 0, v6),
				LayoutOrder = 1
			}) or nil
		end

		v9.icon = icon

		v9.textLabel = Roact.createElement("TextLabel", {
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v5, 1, 0),
			Text = data.props.text,
			TextTransparency = transparency,
			FontFace = normalizeFontFace(font.Header2.Font),
			TextColor3 = color,
			TextSize = font.Header2.RelativeSize * font.BaseSize,
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 2
		})

		v9.rightContainer = data.props.renderRightElement
			and Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(0, v6, 0, v6), LayoutOrder = 3 },
				{
					hint = data.props.renderRightElement()
				}
			)
		local element = createElement("ImageButton", v7, {
			buttonContents = createElement2("Frame", v8, v9),
			bottomBorder = not hasRoundBottom and Roact.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = theme.Divider.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0)
			})
		})

		local createElement3 = Roact.createElement
		local v10 = {
			LayoutOrder = data.props.LayoutOrder,
			Size = udim,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local createElement4 = Roact.createElement
		local v11 = {
			zIndex = -1,
			background = theme.BackgroundUIDefault,
			topCornerRadius = 0,
			bottomCornerRadius = 0
		}
		local topCornerRadius

		if hasRoundTop then
			topCornerRadius = UDim.new(0, v3)
		end

		v11.topCornerRadius = topCornerRadius
		local bottomCornerRadius

		if hasRoundBottom then
			bottomCornerRadius = UDim.new(0, v3)
		end

		v11.bottomCornerRadius = bottomCornerRadius
		return createElement3("Frame", v10, {
			Background = createElement4(RoundedFrame, v11),
			Button = element
		})
	end)
end

return extended
