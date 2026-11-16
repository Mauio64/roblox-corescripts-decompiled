local RunService = game:GetService("RunService")
local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local Cryo = require(parent4.Cryo)
local Foundation = require(parent4.Foundation)

local ReactUtils = require(parent4.ReactUtils)
local EventConnection = ReactUtils.EventConnection

local Interactable = require(parent2.Control.Interactable)

local ControlState = require(parent2.Control.Enum.ControlState)
local getContentStyle = require(script.Parent.getContentStyle)

local withStyle = require(parent3.Core.Style.withStyle)
local ImageSetComponent = require(parent2.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(parent3.App.ImageSet.Enum.IconSize)
local getClosestRadius = require(parent3.App.Loading.getClosestRadius)
local getIconSize = require(parent3.App.ImageSet.getIconSize)
local GenericTextLabel = require(parent2.Text.GenericTextLabel.GenericTextLabel)
local withAnimation = require(parent3.Core.Animation.withAnimation)
local validateFontInfo = require(parent2.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent3.Core.Style.Validator.validateTypographyInfo)
local HoverButtonBackground = require(parent2.Button.HoverButtonBackground)
local StandardButtonSize = require(parent.Enum.StandardButtonSize)

local validateImage = require(parent2.ImageSet.Validator.validateImage)

local extended = Roact.PureComponent:extend("GenericButton")

function extended:init()
	self:setState({
		controlState = ControlState.Initialize,
		absoluteSize = Vector2.new(100, 100),
		targetLoadingProgress = 1,
		isButtonUnfocused = RunService:GetRobloxGuiFocused()
	})

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end

	function self.onAbsoluteSizeChanged(p)
		self:setState({ absoluteSize = p.AbsoluteSize })

		if self.props[Roact.Change.AbsoluteSize] then
			self.props[Roact.Change.AbsoluteSize](p)
		end
	end

	function self.onRobloxGuiFocusedChanged(p)
		if p then
			self:setState({ targetLoadingProgress = 1, isButtonUnfocused = true })
		else
			self:setState({ isButtonUnfocused = false })
		end
	end
end

local buttonStateColorMap2 = t.interface({ [ControlState.Default] = t.string })

extended.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	inputIcon = t.optional(validateImage),
	buttonImage = validateImage,
	fontStyle = t.optional(t.union(t.string, validateFontInfo, validateTypographyInfo)),
	delayedInputImage = t.optional(validateImage),
	buttonStateColorMap = buttonStateColorMap2,
	contentStateColorMap = t.optional(buttonStateColorMap2),
	textStateColorMap = t.optional(buttonStateColorMap2),
	iconStateColorMap = t.optional(buttonStateColorMap2),
	inputIconStateColorMap = t.optional(buttonStateColorMap2),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	isDelayedInput = t.optional(t.boolean),
	isHoverBackgroundEnabled = t.optional(t.boolean),
	hoverImage = t.optional(validateImage),
	enableInputDelayed = t.optional(t.boolean),
	delayInputSeconds = t.optional(t.numberPositive),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	standardSize = t.optional(StandardButtonSize.isEnumValue),
	maxWidth = t.optional(t.numberPositive),
	fitContent = t.optional(t.boolean),
	buttonTextOverride = t.optional(t.strictInterface({
		RichText = t.optional(t.boolean),
		Size = t.optional(t.UDim2),
		TextSize = t.optional(t.number),
		TextWrapped = t.optional(t.boolean),
		TextTruncate = t.optional(t.enum(Enum.TextTruncate)),
		TextXAlignment = t.optional(t.enum(Enum.TextXAlignment))
	})),
	forwardedRef = t.optional(t.union(t.table, t.callback)),
	feedbackType = t.optional(t.string)
})

extended.defaultProps = {
	fontStyle = "Header2",
	isDisabled = false,
	isLoading = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	delayInputSeconds = 3,
	SliceCenter = Rect.new(8, 8, 9, 9)
}

function extended.didMount(object)
	object:setState({
		targetLoadingProgress = (object.state.isButtonUnfocused or not object.props.enableInputDelayed) and 1 or 0
	})
end

function extended:render()
	local isDelayedInput = self.props.isDelayedInput
	local delayInputSeconds = self.props.delayInputSeconds

	if isDelayedInput and not self.state.isButtonUnfocused then
		return withAnimation({ loadingProgress = self.state.targetLoadingProgress }, function(p)
			return self:renderButton((math.clamp(p.loadingProgress, 0, 1)))
		end, {
			frequency = 1 / delayInputSeconds,
			dampingRatio = 0.8
		})
	end

	if self.state.isButtonUnfocused then
		return self:renderButton(1)
	end

	return self:renderButton()
end

function extended:renderButton(p)
	return withStyle(function(p2)
		assert(t.table(p2), "Style provider is missing.")

		local controlState = self.state.controlState

		local text = self.props.text
		local icon = self.props.icon
		local inputIcon = self.props.inputIcon
		local isLoading = self.props.isLoading
		local isDisabled = self.props.isDisabled
		local v = self.props.isDelayedInput

		local userInteractionEnabled = self.props.userInteractionEnabled

		local buttonImage = self.props.buttonImage
		local fontStyle = self.props.fontStyle
		local image = self.props.delayedInputImage
		local buttonStateColorMap = self.props.buttonStateColorMap
		local contentStateColorMap = self.props.contentStateColorMap
		local textStateColorMap = self.props.textStateColorMap or contentStateColorMap
		local iconStateColorMap = self.props.iconStateColorMap or contentStateColorMap
		local inputIconStateColorMap = self.props.inputIconStateColorMap or contentStateColorMap
		local size = self.props.Size
		local standardSize = self.props.standardSize
		local maxWidth = self.props.maxWidth or 640
		local v2 = self.props.fitContent

		if text then
			assert(buttonStateColorMap2(textStateColorMap), "textStateColorMap is missing or invalid.")
		end

		if icon then
			assert(buttonStateColorMap2(iconStateColorMap), "iconStateColorMap is missing or invalid.")
		end

		if inputIcon then
			assert(buttonStateColorMap2(inputIconStateColorMap), "inputIconStateColorMap is missing or invalid.")
		end

		if v and image == nil then
			v = false
		end

		local isDisabled2 = isLoading and true or isDisabled

		if isDisabled2 then
			v = false
		end

		if type(fontStyle) == "string" then
			fontStyle = p2.Font[fontStyle]
		end

		if p == 1 then
			image = buttonImage
		end

		if v and p ~= 0 then
			userInteractionEnabled = false
		end

		local contentStyle = getContentStyle(buttonStateColorMap, controlState, p2)
		local colorStyle = text and getContentStyle(textStateColorMap, controlState, p2)
		local v3 = icon and getContentStyle(iconStateColorMap, controlState, p2)
		local v4 = inputIcon and getContentStyle(inputIconStateColorMap, controlState, p2)
		local v5

		if controlState == ControlState.Hover then
			v5 = self.props.isHoverBackgroundEnabled == true
		else
			v5 = false
		end

		local hoverImage = self.props.hoverImage

		local v6 = 5

		if standardSize then
			local v7 = nil
			local v8 = nil

			if standardSize == StandardButtonSize.Regular then
				fontStyle = p2.Font.Header2
				v7 = 48
				v6 = 12
				v8 = false
			elseif standardSize == StandardButtonSize.Small then
				fontStyle = p2.Font.Header2
				v7 = 36
				v6 = 8
				v8 = false
			elseif standardSize == StandardButtonSize.XSmall then
				fontStyle = p2.Font.CaptionHeader
				v7 = 28
				v6 = 8
				v8 = true
			end

			if v2 == nil then
				v2 = v8
			end

			size = UDim2.new(v2 and 0 or 1, 0, 0, v7)
		end

		local children

		if isLoading then
			children = { isLoadingShimmer = 0 }
			local createElement = Roact.createElement
			local size2

			if standardSize then
				size2 = UDim2.new(1, v6 * 2, 1, 0)
			else
				size2 = UDim2.new(1, 0, 1, 0)
			end

			local position

			if standardSize then
				position = UDim2.new(0, -v6, 0, 0)
			end

			children.isLoadingShimmer = createElement(Skeleton, {
				Size = size2,
				Position = position,
				radius = getClosestRadius({
					None = p2.Tokens.Radius.None,
					Small = p2.Tokens.Radius.Small,
					Medium = p2.Tokens.Radius.Medium,
					Large = p2.Tokens.Size.Size_300,
					XLarge = p2.Tokens.Radius.Large,
					Circle = p2.Tokens.Radius.Circle
				}, UDim.new(0, 8))
			})
		else
			local v7 = self.state.absoluteSize.X

			if standardSize and v2 then
				v7 = maxWidth
			end

			local v8 = self.state.absoluteSize.Y - 10
			local v9 = v7 - v6 * 2

			if icon then
				v9 -= 5 + getIconSize(IconSize.Medium)
			end

			local vector2 = Vector2.new(v9, v8)

			local v10 = self.props[Roact.Children]

			if not v10 then
				v10 = {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5)
					}),
					Icon = 0,
					Text = 0
				}
				local icon2

				if icon then
					icon2 = Roact.createElement(ImageSetComponent.Label, {
						Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
						BackgroundTransparency = 1,
						Image = icon,
						ImageColor3 = v3.Color,
						ImageTransparency = v3.Transparency,
						LayoutOrder = 1
					}) or nil
				end

				v10.Icon = icon2
				local text2

				if text then
					local createElement = Roact.createElement

					local join = Cryo.Dictionary.join
					local v11 = {
						BackgroundTransparency = 1,
						Text = text,
						fontStyle = fontStyle,
						colorStyle = colorStyle,
						LayoutOrder = 2,
						maxSize = vector2,
						TextWrapped = not standardSize and nil,
						TextTruncate = 0,
						TextXAlignment = 0
					}
					local textTruncate

					if standardSize then
						textTruncate = Enum.TextTruncate.AtEnd
					end

					v11.TextTruncate = textTruncate
					local textXAlignment

					if standardSize and icon then
						textXAlignment = Enum.TextXAlignment.Left
					end

					v11.TextXAlignment = textXAlignment
					text2 = createElement(GenericTextLabel, join(v11, self.props.buttonTextOverride or {})) or nil
				end

				v10.Text = text2
			end

			children = self.props[Roact.Children]

			if not children then
				children = { ButtonMiddleContent = 0, ButtonIcon = 0 }
				local createElement = Roact.createElement
				local automaticSize

				if v2 then
					automaticSize = Enum.AutomaticSize.X
				end

				local size2

				if v2 then
					size2 = UDim2.fromScale(0, 1)
				else
					size2 = UDim2.fromScale(1, 1)
				end

				children.ButtonMiddleContent = createElement(
					"Frame",
					{ AutomaticSize = automaticSize, Size = size2, BackgroundTransparency = 1 },
					v10
				)

				children.ButtonIcon = inputIcon and Roact.createElement(ImageSetComponent.Label, {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -4, 0.5, 0),
					Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
					BackgroundTransparency = 1,
					Image = inputIcon,
					ImageColor3 = v4.Color,
					ImageTransparency = v4.Transparency
				}) or nil
			end
		end

		local createElement = Roact.createElement

		local join = Cryo.Dictionary.join
		local props = self.props
		local v7 = {
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			["forwardedRef"] = nil,
			forwardedRef = Cryo.None,
			icon = Cryo.None,
			text = Cryo.None,
			inputIcon = Cryo.None,
			buttonImage = Cryo.None,
			fontStyle = Cryo.None,
			delayedInputImage = Cryo.None,
			buttonStateColorMap = Cryo.None,
			contentStateColorMap = Cryo.None,
			textStateColorMap = Cryo.None,
			iconStateColorMap = Cryo.None,
			inputIconStateColorMap = Cryo.None,
			onActivated = Cryo.None,
			isLoading = Cryo.None,
			isHoverBackgroundEnabled = Cryo.None,
			hoverImage = Cryo.None,
			isDelayedInput = Cryo.None,
			enableInputDelayed = Cryo.None,
			delayInputSeconds = Cryo.None,
			standardSize = Cryo.None,
			maxWidth = Cryo.None,
			fitContent = Cryo.None,
			buttonTextOverride = Cryo.None,
			[Roact.Children] = Cryo.None,
			Size = size
		}
		local automaticSize

		if v2 then
			automaticSize = Enum.AutomaticSize.X
		end

		v7.AutomaticSize = automaticSize
		v7[Roact.Ref] = self.props.forwardedRef
		v7.isDisabled = isDisabled2
		v7.onStateChanged = self.onStateChanged
		v7.userInteractionEnabled = userInteractionEnabled
		v7.Image = buttonImage
		v7.ScaleType = Enum.ScaleType.Slice
		v7.ImageColor3 = contentStyle.Color
		v7.ImageTransparency = contentStyle.Transparency
		v7.BackgroundTransparency = 1
		v7.AutoButtonColor = false
		v7[Roact.Event.Activated] = self.props.onActivated
		v7[Roact.Change.AbsoluteSize] = self.onAbsoluteSizeChanged
		local v8 = join(props, v7)
		local uiSizeConstraint

		if standardSize and maxWidth then
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(maxWidth, 1e999)
			})
		end

		local uiPadding

		if standardSize then
			uiPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v6),
				PaddingRight = UDim.new(0, v6)
			})
		end

		local createElement2 = Roact.createElement
		local automaticSize2

		if v2 then
			automaticSize2 = Enum.AutomaticSize.X
		end

		local size2

		if v2 then
			size2 = UDim2.fromScale(0, 1)
		else
			size2 = UDim2.fromScale(1, 1)
		end

		local children2 = {
			UISizeConstraint = uiSizeConstraint,
			UIPadding = uiPadding,
			ButtonContent = createElement2(
				"Frame",
				{ AutomaticSize = automaticSize2, Size = size2, BackgroundTransparency = 1 },
				children
			),
			LoadingImage = v and Roact.createElement(ImageSetComponent.Label, {
				Size = UDim2.new(p, 0, 1, 0),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Image = image,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 0.5,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = self.props.SliceCenter
			}),
			HoverBackground = 0,
			EventConnection = 0
		}
		local hoverBackground

		if v5 then
			local createElement3 = Roact.createElement
			local sidePadding

			if standardSize then
				sidePadding = UDim.new(0, v6)
			end

			hoverBackground = createElement3(HoverButtonBackground, {
					sidePadding = sidePadding,
					image = hoverImage,
					sliceCenter = self.props.SliceCenter
				})
				or nil
		end

		children2.HoverBackground = hoverBackground

		children2.EventConnection = Roact.createElement(EventConnection, {
			event = RunService.RobloxGuiFocusedChanged,
			callback = self.onRobloxGuiFocusedChanged
		})
		return createElement(Interactable, v8, children2)
	end)
end

function extended.didUpdate(object, p, p2)
	if object.props.enableInputDelayed ~= p.enableInputDelayed then
		object:setState({
			targetLoadingProgress = object.props.enableInputDelayed and 0 or 1
		})
	end

	if
		not object.state.isButtonUnfocused
		and p2.isButtonUnfocused
		and object.state.targetLoadingProgress == 1
		and object.props.enableInputDelayed
	then
		object:setState({ targetLoadingProgress = 0 })
	end
end

return Roact.forwardRef(function(p, forwardedRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardedRef = forwardedRef }))
end)
