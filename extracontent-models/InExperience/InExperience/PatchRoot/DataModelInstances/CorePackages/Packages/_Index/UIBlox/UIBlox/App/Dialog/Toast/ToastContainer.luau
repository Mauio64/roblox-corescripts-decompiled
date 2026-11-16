local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local GetTextSize = require(parent2.Core.Text.GetTextSize)
local Images = require(parent2.App.ImageSet.Images)
local memoize = require(parent2.Utility.memoize)
local withStyle = require(parent2.Core.Style.withStyle)
local validateColorInfo = require(parent2.Core.Style.Validator.validateColorInfo)
local ButtonType = require(parent.Button.Enum.ButtonType)
local FoundationButtonUtils = require(parent.Button.FoundationButtonUtils)
local StandardButtonSize = require(parent2.Core.Button.Enum.StandardButtonSize)
local UIBloxConfig = require(parent2.UIBloxConfig)

local vector2 = Vector2.new(36, 36)

local Small = StandardButtonSize.Small

local function getTextHeight(p, font, p2, p3) -- 2 equivalent calls inferred from this helper
	return GetTextSize(p, p2, font, (Vector2.new(p3, 10000))).Y
end

local extended = Roact.PureComponent:extend("ToastContainer")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	anchorPoint = Vector2.new(0, 0),
	fitHeight = true,
	padding = 12,
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.new(1, -24, 0, 0),
	sizeConstraint = { MaxSize = Vector2.new(400, 1e999), MinSize = Vector2.new(24, 60) }
}

function extended:init()
	self.containerRef = Roact.createRef()
	self.isMounted = false

	self.state = { containerWidth = 0, pressed = false, subtitleHeight = 0, titleHeight = 0 }

	function self.getIconSize()
		local iconSize = self.props.iconSize
		local iconImage = self.props.iconImage
		local imagesResolutionScale = Images.ImagesResolutionScale

		if not iconImage then
			return Vector2.new(0, 0)
		end

		if iconSize then
			return iconSize
		end

		if iconImage.ImageRectSize and imagesResolutionScale and imagesResolutionScale > 0 then
			return iconImage.ImageRectSize / imagesResolutionScale
		end

		return vector2
	end

	function self.onButtonInputBegan(_, p)
		if
			p.UserInputState == Enum.UserInputState.Begin
			and (p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1)
			and not self.state.pressed
		then
			self:setState({ pressed = true })
		end
	end

	function self.onButtonInputEnded()
		if self.state.pressed then
			self:setState({ pressed = false })
		end
	end

	function self.getTextHeights(p)
		local iconImage = self.props.iconImage
		local iconSize = self.getIconSize()
		local buttonText = self.props.buttonText
		local onActivated = self.props.onActivated
		local padding = self.props.padding
		local toastSubtitle = self.props.toastSubtitle
		local toastTitle = self.props.toastTitle

		local font = p.Font
		local header2 = font.Header2
		local captionBody = font.CaptionBody

		local v = self.state.containerWidth - padding * 2

		if iconImage then
			v = v - iconSize.X - padding
		end

		if buttonText and onActivated and not self.showCompactToast() then
			v = v - self.getButtonDimensions(p).X - self.getButtonGap()
		end

		local v2 = math.max(0, getTextHeight(toastTitle, header2.Font, header2.RelativeSize * font.BaseSize, v)) -- inferred equivalent call
		local v3

		if toastSubtitle then
			v3 = math.max(
				0,
				getTextHeight(toastSubtitle, captionBody.Font, captionBody.RelativeSize * font.BaseSize, v) -- inferred equivalent call
			)
		else
			v3 = 0
		end

		return v3, v2
	end

	function self.showCompactToast(): boolean
		return self.state.containerWidth < 400
	end

	function self.getButtonGap()
		if UIBloxConfig.useFoundationToastButtonSizing then
			return self.props.padding
		end

		return 0
	end

	function self.showPressed()
		if self.props.buttonText or not self.props.onActivated then
			return nil
		end

		return self.state.pressed
	end

	self.getButtonDimensions = memoize(function(p)
		local buttonText = self.props.buttonText
		local onActivated = self.props.onActivated

		if not (buttonText and onActivated) then
			return Vector2.new(0, 0)
		end

		local v

		if UIBloxConfig.useFoundationToastButtonSizing and UIBloxConfig.useFoundationButton then
			v = FoundationButtonUtils.getFitContentSize(buttonText, Small, p.Tokens)
		end

		if not v then
			local font = p.Font.Header2.Font
			local v2 = p.Font.Header2.RelativeSize * p.Font.BaseSize
			local v3

			if UIBloxConfig.useFoundationToastButtonSizing then
				v3 = Vector2.new(32, 16)
			else
				v3 = Vector2.new(40, 40)
			end

			v = v3 + GetTextSize(buttonText, v2, font, Vector2.new(1000, 1000))
		end

		if self.showCompactToast() then
			return Vector2.new(math.min(v.X, 200), v.Y)
		end

		return v
	end)
end

function extended.render(object)
	local iconImage = object.props.iconImage
	local iconSize = object.getIconSize()
	local padding = object.props.padding
	local toastSubtitle = object.props.toastSubtitle
	local toastTitle = object.props.toastTitle
	return withStyle(function(p)
		local textHeights, v = object.getTextHeights(p)
		local v2 = v + textHeights
		local y = object.getButtonDimensions(p).Y

		local size = object.props.size

		if object.props.fitHeight then
			local v3 = math.max(iconSize.Y, v2) + padding * 2 + (not (object.showCompactToast() and object.props.buttonText and object.props.onActivated) and 0 or y + object.getButtonGap())

			size = UDim2.new(size.X.Scale, size.X.Offset, 0, v3)
		end

		local theme = p.Theme
		local font = p.Font
		local header2 = font.Header2
		local captionBody = font.CaptionBody

		local createElement = Roact.createElement
		local v3 = {
			["AnchorPoint"] = nil,
			["AnchorPoint"] = nil,
			AnchorPoint = object.props.anchorPoint,
			BackgroundTransparency = 1,
			LayoutOrder = object.props.layoutOrder,
			Position = object.props.position,
			Size = size,
			Text = "",
			[Roact.Change.AbsoluteSize] = function(p2)
				if object.state.containerWidth ~= p2.AbsoluteSize.X then
					object:setState({ containerWidth = p2.AbsoluteSize.X })
				end
			end
		}
		local activated = Roact.Event.Activated
		local v4

		if not object.props.buttonText then
			v4 = object.props.onActivated
		end

		v3[activated] = v4
		v3[Roact.Event.InputBegan] = object.onButtonInputBegan
		v3[Roact.Event.InputEnded] = object.onButtonInputEnded
		v3[Roact.Event.TouchSwipe] = object.props.onTouchSwipe
		v3[Roact.Ref] = object.containerRef
		local v5 = {
			UISizeConstraint = Roact.createElement("UISizeConstraint", object.props.sizeConstraint),
			Toast = 0
		}
		local renderToast = object.props.renderToast
		local v6 = {
			buttonProps = object.props.buttonText and object.props.onActivated and {
				buttonDimensions = object.getButtonDimensions(p),
				buttonText = object.props.buttonText,
				onActivated = object.props.onActivated,
				buttonType = object.props.buttonType
			} or nil,
			iconProps = iconImage and {
				colorStyle = object.props.iconColorStyle,
				Image = iconImage,
				Size = UDim2.new(0, iconSize.X, 0, iconSize.Y)
			} or nil,
			iconChildren = object.props.iconChildren,
			isCompact = 0,
			padding = 0,
			pressed = 0,
			pressedScale = 0,
			subtitleTextProps = 0,
			textFrameSize = 0,
			titleTextProps = 0
		}
		local isCompact

		if object.props.buttonText and object.props.onActivated then
			isCompact = object.showCompactToast()
		end

		v6.isCompact = isCompact
		v6.padding = padding
		v6.pressed = object.showPressed()
		v6.pressedScale = object.props.pressedScale
		v6.subtitleTextProps = toastSubtitle
			and ({
				colorStyle = theme.TextEmphasis,
				fontStyle = captionBody,
				Size = UDim2.new(1, 0, 0, textHeights),
				Text = toastSubtitle
			} or nil)
			or nil

		v6.textFrameSize = UDim2.new(1, iconImage and -iconSize.X - padding or 0, 0, v2)
		v6.titleTextProps = {
			colorStyle = theme.TextEmphasis,
			fontStyle = header2,
			Size = UDim2.new(1, 0, 0, v),
			Text = toastTitle
		}
		v5.Toast = renderToast(v6)
		return createElement("TextButton", v3, v5)
	end)
end

function extended.didMount(object)
	object:setState({
		containerWidth = object.containerRef.current and object.containerRef.current.AbsoluteSize.X or 0
	})
end

return extended
