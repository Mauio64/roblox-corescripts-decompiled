local ParentParent = script.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local Images = require(ParentParent.UIBlox.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent.UIBlox.Core.ImageSet.ImageSetComponent)
local withStyle = require(ParentParent.UIBlox.Core.Style.withStyle)
local RoundedFrame = require(ParentParent.UIBlox.App.Menu.RoundedFrame)
local v8 = Roact.PureComponent:extend("ModalBottomSheetButton")
local ImageRectSize = Images["component_assets/circle_17"].ImageRectSize
local ImageRectOffset = Images["component_assets/circle_17"].ImageRectOffset
local v11 = 8 * Images.ImagesResolutionScale
local v12 = 8 * Images.ImagesResolutionScale
local rect = Rect.new(v11, v12, ImageRectSize.x - v11, ImageRectSize.y - v12)
local v14 = 8 * Images.ImagesResolutionScale

v8.validateProps = t.strictInterface({
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
v8.defaultProps = {
	text = "",
	icon = {},
	onActivated = function() -- line: 45
	end
}

function v8.init(p1) -- line: 48
	-- upvalues: Roact (copy)
	local v16, v17 = Roact.createBinding(false)

	p1.pressed = v16
	p1.updatePressed = v17
	p1.ref = Roact.createRef()

	function p1.onColorChange(p2) -- line: 51
		-- upvalues: p1 (copy)
		if not p1.ref.current then
			return
		end

		p1.ref.current.ImageColor3 = p2
	end
	function p1.onInputBegan(p3) -- line: 58
		return p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch
	end
	function p1.onInputEnd(p4) -- line: 62
		return p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.Touch
	end
end
function v8.render(p5) -- line: 68
	-- upvalues: ImageRectSize (copy), ImageRectOffset (copy), rect (copy), withStyle (copy), Roact (copy), Images (copy), ImageSetComponent (copy), RoundedFrame (copy), v14 (copy)
	local hasRoundTop = p5.props.hasRoundTop
	local hasRoundBottom = p5.props.hasRoundBottom
	local u21 = nil
	local ImageRectSizeX = ImageRectSize.X
	local v23 = ImageRectSizeX / 2
	local u24, u25

	if hasRoundTop and hasRoundBottom then
		u24 = ImageRectSize
		u25 = ImageRectOffset
		u21 = rect
	elseif hasRoundTop then
		u24 = Vector2.new(ImageRectSizeX, v23)
		u25 = ImageRectOffset
		u21 = Rect.new(v23 - 1, v23 - 1, v23 + 1, v23)
	elseif hasRoundBottom then
		u24 = Vector2.new(ImageRectSizeX, v23)
		u25 = ImageRectOffset + Vector2.new(0, v23)
		u21 = Rect.new(v23 - 1, 0, v23 + 1, 1)
	else
		u24 = Vector2.new(1, 1)
		u25 = ImageRectOffset + Vector2.new(v23, v23)
	end

	local elementHeight = p5.props.elementHeight
	local u27 = if not p5.props.isFixed then UDim2.new(1, -32, 0, elementHeight) else UDim2.new(0, 300, 0, elementHeight)
	local n1 = 24

	if p5.props.showImage or p5.props.renderRightElement then
		n1 = 12
	end

	local u29 = n1
	local v30 = elementHeight * 0.8

	if p5.props.showImage then
		u29 = u29 + v30 + n1
	end

	if p5.props.renderRightElement then
		u29 = u29 + v30 + n1
	end

	return withStyle(function(p6) -- line: 120
		-- upvalues: p5 (copy), Roact (copy), u21 (ref), Images (copy), u24 (ref), u25 (ref), n1 (ref), ImageSetComponent (copy), v30 (copy), u29 (ref), hasRoundBottom (copy), u27 (ref), RoundedFrame (copy), hasRoundTop (copy), v14 (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font
		local v37 = p5.pressed:map(function(p7) -- line: 128
			-- upvalues: Theme (copy)
			if p7 then
				return Theme.BackgroundOnPress.Color
			end

			return Theme.BackgroundUIDefault.Color
		end)
		local v38 = p5.pressed:map(function(p8) -- line: 131
			-- upvalues: Theme (copy)
			if p8 then
				return Theme.BackgroundOnPress.Transparency
			end

			return Theme.BackgroundUIDefault.Transparency
		end)
		local TextEmphasisColor = Theme.TextEmphasis.Color
		local TextEmphasisTransparency = Theme.TextEmphasis.Transparency
		local v41 = Roact.createElement("ImageButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = u21,
			Image = Images["component_assets/circle_17"].Image,
			ImageColor3 = v37,
			ImageRectSize = u24,
			ImageRectOffset = u25,
			ImageTransparency = v38,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = p5.props.LayoutOrder,
			[Roact.Ref] = p5.ref,
			[Roact.Event.Activated] = p5.props.onActivatedAndDismissed,
			[Roact.Event.InputBegan] = function(_, p10) -- line: 152
				-- upvalues: p5 (copy)
				if p5.onInputBegan(p10) then
					p5.updatePressed(true)
				end
			end,
			[Roact.Event.InputEnded] = function(_, p12) -- line: 157
				-- upvalues: p5 (copy)
				if p5.onInputEnd(p12) then
					p5.updatePressed(false)
				end
			end
		}, {
			buttonContents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				horizontalLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, n1)
				}),
				padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, n1),
					PaddingTop = UDim.new(0.1, 0),
					PaddingBottom = UDim.new(0.1, 0)
				}),
				icon = p5.props.showImage and Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = p5.props.icon,
					ImageColor3 = TextEmphasisColor,
					ImageTransparency = TextEmphasisTransparency,
					Size = UDim2.new(0, v30, 0, v30)
				}) or nil,
				textLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, -u29, 1, 0),
					Text = p5.props.text,
					TextTransparency = TextEmphasisTransparency,
					Font = p6Font.Header2.Font,
					TextColor3 = TextEmphasisColor,
					TextSize = p6Font.Header2.RelativeSize * p6Font.BaseSize,
					TextTruncate = Enum.TextTruncate.AtEnd
				}),
				rightContainer = p5.props.renderRightElement and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(0, v30, 0, v30)
				}, {
					hint = p5.props.renderRightElement()
				})
			}),
			bottomBorder = not hasRoundBottom and Roact.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Divider.Color,
				Size = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0)
			})
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p5.props.LayoutOrder,
			Size = u27
		}, {
			Background = Roact.createElement(RoundedFrame, {
				zIndex = -1,
				background = Theme.BackgroundUIDefault,
				topCornerRadius = if not hasRoundTop then nil else UDim.new(0, v14),
				bottomCornerRadius = if not hasRoundBottom then nil else UDim.new(0, v14)
			}),
			Button = v41
		})
	end)
end

return v8
