local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local Images = require(ParentParentParent.App.ImageSet.Images)
local memoize = require(ParentParentParent.Utility.memoize)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local vector2 = Vector2.new(36, 36)

local function getTextHeight(p1, p2, p3, p4) -- line: 31
	-- upvalues: GetTextSize (copy)
	local vector2_2 = Vector2.new(p4, 10000)

	return GetTextSize(p1, p3, p2, vector2_2).Y
end

local v14 = Roact.PureComponent:extend("ToastContainer")

v14.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	buttonText = t.optional(t.string),
	fitHeight = t.optional(t.boolean),
	iconColorStyle = t.optional(validateColorInfo),
	iconImage = t.optional(t.union(t.table, t.string, t.callback)),
	iconSize = t.optional(t.Vector2),
	iconChildren = t.optional(t.table),
	layoutOrder = t.optional(t.integer),
	onActivated = t.optional(t.callback),
	onTouchSwipe = t.optional(t.callback),
	padding = t.numberMin(0),
	position = t.UDim2,
	pressedScale = t.optional(t.number),
	renderToast = t.callback,
	size = t.UDim2,
	sizeConstraint = t.optional(t.table),
	toastSubtitle = t.optional(t.string),
	toastTitle = t.string,
	buttonType = t.optional(ButtonType.isEnumValue)
})
v14.defaultProps = {
	fitHeight = true,
	padding = 12,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.new(1, -24, 0, 0),
	sizeConstraint = {
		MaxSize = Vector2.new(400, 1e999),
		MinSize = Vector2.new(24, 60)
	}
}

function v14.init(p5) -- line: 74
	-- upvalues: Roact (copy), Images (copy), vector2 (copy), GetTextSize (copy), memoize (copy)
	p5.containerRef = Roact.createRef()
	p5.isMounted = false
	p5.state = {
		containerWidth = 0,
		pressed = false,
		subtitleHeight = 0,
		titleHeight = 0
	}

	function p5.getIconSize() -- line: 85
		-- upvalues: p5 (copy), Images (copy), vector2 (copy)
		local iconSize = p5.props.iconSize
		local iconImage = p5.props.iconImage
		local ImagesResolutionScale = Images.ImagesResolutionScale

		if iconImage then
			if iconSize then
				return iconSize
			end

			if iconImage.ImageRectSize and ImagesResolutionScale and ImagesResolutionScale > 0 then
				return iconImage.ImageRectSize / ImagesResolutionScale
			end

			return vector2
		end

		return Vector2.new(0, 0)
	end
	function p5.onButtonInputBegan(_, p7) -- line: 101
		-- upvalues: p5 (copy)
		if p7.UserInputState == Enum.UserInputState.Begin and ((p7.UserInputType == Enum.UserInputType.Touch or p7.UserInputType == Enum.UserInputType.MouseButton1) and not p5.state.pressed) then
			p5:setState({
				pressed = true
			})
		end
	end
	function p5.onButtonInputEnded() -- line: 117
		-- upvalues: p5 (copy)
		if p5.state.pressed then
			p5:setState({
				pressed = false
			})
		end
	end
	function p5.getTextHeights(p8) -- line: 125
		-- upvalues: p5 (copy), GetTextSize (copy)
		local iconImage = p5.props.iconImage
		local v35 = p5.getIconSize()
		local buttonText = p5.props.buttonText
		local padding = p5.props.padding
		local toastSubtitle = p5.props.toastSubtitle
		local toastTitle = p5.props.toastTitle
		local p8Font = p8.Font
		local Header2 = p8Font.Header2
		local CaptionBody = p8Font.CaptionBody
		local v43 = p5.state.containerWidth - padding * 2

		if iconImage then
			v43 = v43 - v35.X - padding
		end

		if buttonText and not p5.showCompactToast() then
			v43 -= p5.getButtonDimensions(p8).X
		end

		local Header2Font = Header2.Font
		local v45 = Header2.RelativeSize * p8Font.BaseSize
		local vector2_3 = Vector2.new(v43, 10000)
		local v47 = math.max(0, GetTextSize(toastTitle, v45, Header2Font, vector2_3).Y)
		local n1 = 0

		if toastSubtitle then
			local CaptionBodyFont = CaptionBody.Font
			local v50 = CaptionBody.RelativeSize * p8Font.BaseSize
			local vector2_4 = Vector2.new(v43, 10000)

			n1 = math.max(0, GetTextSize(toastSubtitle, v50, CaptionBodyFont, vector2_4).Y)
		end

		return n1, v47
	end
	function p5.showCompactToast() -- line: 160
		-- upvalues: p5 (copy)
		return p5.state.containerWidth < 400
	end
	function p5.showPressed() -- line: 164
		-- upvalues: p5 (copy)
		if not p5.props.buttonText and p5.props.onActivated then
			return p5.state.pressed
		end

		return nil
	end

	p5.getButtonDimensions = memoize(function(p9) -- line: 172
		-- upvalues: p5 (copy), GetTextSize (copy)
		local buttonText = p5.props.buttonText
		local onActivated = p5.props.onActivated

		if not buttonText or not onActivated then
			return Vector2.new(0, 0)
		end

		local Header2Font = p9.Font.Header2.Font
		local v56 = p9.Font.Header2.RelativeSize * p9.Font.BaseSize
		local v57 = Vector2.new(30, 30) + Vector2.new(10, 10) + GetTextSize(buttonText, v56, Header2Font, Vector2.new(1000, 1000))

		if not p5.showCompactToast() then
			return v57
		end

		return Vector2.new(math.min(v57.X, 200), v57.Y)
	end)
end
function v14.render(p10) -- line: 193
	-- upvalues: withStyle (copy), Roact (copy)
	local iconImage = p10.props.iconImage
	local v23 = p10.getIconSize()
	local padding = p10.props.padding
	local toastSubtitle = p10.props.toastSubtitle
	local toastTitle = p10.props.toastTitle

	return withStyle(function(p11) -- line: 199
		-- upvalues: p10 (copy), v23 (copy), padding (copy), Roact (copy), iconImage (copy), toastSubtitle (copy), toastTitle (copy)
		local v59, v60 = p10.getTextHeights(p11)
		local v61 = v60 + v59
		local Y = p10.getButtonDimensions(p11).Y
		local size = p10.props.size

		if p10.props.fitHeight then
			local v64 = math.max(v23.Y, v61) + padding * 2 + ((not p10.showCompactToast() or not p10.props.buttonText) and 0 or Y)

			size = UDim2.new(size.X.Scale, size.X.Offset, 0, v64)
		end

		local Theme = p11.Theme
		local p11Font = p11.Font
		local Header2 = p11Font.Header2
		local CaptionBody = p11Font.CaptionBody

		return Roact.createElement("TextButton", {
			AnchorPoint = p10.props.anchorPoint,
			BackgroundTransparency = 1,
			LayoutOrder = p10.props.layoutOrder,
			Position = p10.props.position,
			Size = size,
			Text = "",
			[Roact.Change.AbsoluteSize] = function(p12) -- line: 225
				-- upvalues: p10 (copy)
				if p10.state.containerWidth ~= p12.AbsoluteSize.X then
					p10:setState({
						containerWidth = p12.AbsoluteSize.X
					})
				end
			end,
			[Roact.Event.Activated] = if p10.props.buttonText then nil else p10.props.onActivated,
			[Roact.Event.InputBegan] = p10.onButtonInputBegan,
			[Roact.Event.InputEnded] = p10.onButtonInputEnded,
			[Roact.Event.TouchSwipe] = p10.props.onTouchSwipe,
			[Roact.Ref] = p10.containerRef
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", p10.props.sizeConstraint),
			Toast = p10.props.renderToast({
				buttonProps = if not p10.props.buttonText or not p10.props.onActivated then nil else {
					buttonDimensions = p10.getButtonDimensions(p11),
					buttonText = p10.props.buttonText,
					onActivated = p10.props.onActivated,
					buttonType = p10.props.buttonType
				},
				iconProps = iconImage and {
					colorStyle = p10.props.iconColorStyle,
					Image = iconImage,
					Size = UDim2.new(0, v23.X, 0, v23.Y)
				} or nil,
				iconChildren = p10.props.iconChildren,
				isCompact = if not p10.props.buttonText or not p10.props.onActivated then nil else p10.showCompactToast(),
				padding = padding,
				pressed = p10.showPressed(),
				pressedScale = p10.props.pressedScale,
				subtitleTextProps = toastSubtitle and {
					colorStyle = Theme.TextEmphasis,
					fontStyle = CaptionBody,
					Size = UDim2.new(1, 0, 0, v59),
					Text = toastSubtitle
				} or nil,
				textFrameSize = UDim2.new(1, iconImage and -v23.X - padding or 0, 0, v61),
				titleTextProps = {
					colorStyle = Theme.TextEmphasis,
					fontStyle = Header2,
					Size = UDim2.new(1, 0, 0, v60),
					Text = toastTitle
				}
			})
		})
	end)
end
function v14.didMount(p13) -- line: 278
	p13:setState({
		containerWidth = p13.containerRef.current and p13.containerRef.current.AbsoluteSize.X or 0
	})
end

return v14
