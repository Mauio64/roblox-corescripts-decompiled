local RunService = game:GetService("RunService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Roact = require(scriptParentParentParentParent.Roact)
local t = require(scriptParentParentParentParent.t)
local Cryo = require(scriptParentParentParentParent.Cryo)
local Foundation = require(scriptParentParentParentParent.Foundation)
local EventConnection = require(scriptParentParentParentParent.ReactUtils).EventConnection
local Interactable = require(scriptParentParent.Control.Interactable)
local ControlState = require(scriptParentParent.Control.Enum.ControlState)
local getContentStyle = require(script.Parent.getContentStyle)
local withStyle = require(scriptParentParentParent.Core.Style.withStyle)
local ImageSetComponent = require(scriptParentParent.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(scriptParentParentParent.App.ImageSet.Enum.IconSize)
local getClosestRadius = require(scriptParentParentParent.App.Loading.getClosestRadius)
local getIconSize = require(scriptParentParentParent.App.ImageSet.getIconSize)
local GenericTextLabel = require(scriptParentParent.Text.GenericTextLabel.GenericTextLabel)
local withAnimation = require(scriptParentParentParent.Core.Animation.withAnimation)
local validateFontInfo = require(scriptParentParent.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(scriptParentParentParent.Core.Style.Validator.validateTypographyInfo)
local HoverButtonBackground = require(scriptParentParent.Button.HoverButtonBackground)
local StandardButtonSize = require(scriptParent.Enum.StandardButtonSize)
local validateImage = require(scriptParentParent.ImageSet.Validator.validateImage)
local v27 = Roact.PureComponent:extend("GenericButton")

function v27.init(p1) -- line: 46
	-- upvalues: ControlState (copy), RunService (copy), Roact (copy)
	p1:setState({
		targetLoadingProgress = 1,
		controlState = ControlState.Initialize,
		absoluteSize = Vector2.new(100, 100),
		isButtonUnfocused = RunService:GetRobloxGuiFocused()
	})

	function p1.onStateChanged(p2, p3) -- line: 54
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p2, p3)
		end
	end
	function p1.onAbsoluteSizeChanged(p4) -- line: 63
		-- upvalues: p1 (copy), Roact (copy)
		p1:setState({
			absoluteSize = p4.AbsoluteSize
		})

		if p1.props[Roact.Change.AbsoluteSize] then
			p1.props[Roact.Change.AbsoluteSize](p4)
		end
	end
	function p1.onRobloxGuiFocusedChanged(p5) -- line: 72
		-- upvalues: p1 (copy)
		if p5 then
			p1:setState({
				targetLoadingProgress = 1,
				isButtonUnfocused = true
			})

			return
		end

		p1:setState({
			isButtonUnfocused = false
		})
	end
end

local v28 = t.interface({
	[ControlState.Default] = t.string
})

v27.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	inputIcon = t.optional(validateImage),
	buttonImage = validateImage,
	fontStyle = t.optional(t.union(t.string, validateFontInfo, validateTypographyInfo)),
	delayedInputImage = t.optional(validateImage),
	buttonStateColorMap = v28,
	contentStateColorMap = t.optional(v28),
	textStateColorMap = t.optional(v28),
	iconStateColorMap = t.optional(v28),
	inputIconStateColorMap = t.optional(v28),
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
v27.defaultProps = {
	fontStyle = "Header2",
	isDisabled = false,
	isLoading = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	delayInputSeconds = 3,
	SliceCenter = Rect.new(8, 8, 9, 9)
}

function v27.didMount(p6) -- line: 198
	p6:setState({
		targetLoadingProgress = (p6.state.isButtonUnfocused or not p6.props.enableInputDelayed) and 1 or 0
	})
end
function v27.render(p7) -- line: 206
	-- upvalues: withAnimation (copy)
	local isDelayedInput = p7.props.isDelayedInput
	local delayInputSeconds = p7.props.delayInputSeconds

	if isDelayedInput and not p7.state.isButtonUnfocused then
		local targetLoadingProgress = p7.state.targetLoadingProgress

		return withAnimation({
			loadingProgress = targetLoadingProgress
		}, function(p8) -- line: 219
			-- upvalues: p7 (copy)
			local v47 = math.clamp(p8.loadingProgress, 0, 1)

			return p7:renderButton(v47)
		end, {
			dampingRatio = 0.8,
			frequency = 1 / delayInputSeconds
		})
	end

	if p7.state.isButtonUnfocused then
		return p7:renderButton(1)
	end

	return p7:renderButton()
end
function v27.renderButton(p9, p10) -- line: 239
	-- upvalues: withStyle (copy), t (copy), v28 (copy), getContentStyle (copy), ControlState (copy), StandardButtonSize (copy), Roact (copy), Skeleton (copy), getClosestRadius (copy), getIconSize (copy), IconSize (copy), ImageSetComponent (copy), GenericTextLabel (copy), Cryo (copy), Interactable (copy), HoverButtonBackground (copy), EventConnection (copy), RunService (copy)
	return withStyle(function(p11) -- line: 240
		-- upvalues: t (copy), p9 (copy), v28 (copy), p10 (copy), getContentStyle (copy), ControlState (copy), StandardButtonSize (copy), Roact (copy), Skeleton (copy), getClosestRadius (copy), getIconSize (copy), IconSize (copy), ImageSetComponent (copy), GenericTextLabel (copy), Cryo (copy), Interactable (copy), HoverButtonBackground (copy), EventConnection (copy), RunService (copy)
		assert(t.table(p11), "Style provider is missing.")

		local controlState = p9.state.controlState
		local text = p9.props.text
		local icon = p9.props.icon
		local inputIcon = p9.props.inputIcon
		local isLoading = p9.props.isLoading
		local isDisabled = p9.props.isDisabled
		local isDelayedInput = p9.props.isDelayedInput
		local userInteractionEnabled = p9.props.userInteractionEnabled
		local buttonImage = p9.props.buttonImage
		local fontStyle = p9.props.fontStyle
		local delayedInputImage = p9.props.delayedInputImage
		local buttonStateColorMap = p9.props.buttonStateColorMap
		local contentStateColorMap = p9.props.contentStateColorMap
		local v62 = p9.props.textStateColorMap or contentStateColorMap
		local v63 = p9.props.iconStateColorMap or contentStateColorMap
		local v64 = p9.props.inputIconStateColorMap or contentStateColorMap
		local propsSize = p9.props.Size
		local standardSize = p9.props.standardSize
		local v67 = p9.props.maxWidth or 640
		local fitContent = p9.props.fitContent

		if text then
			assert(v28(v62), "textStateColorMap is missing or invalid.")
		end

		if icon then
			assert(v28(v63), "iconStateColorMap is missing or invalid.")
		end

		if inputIcon then
			assert(v28(v64), "inputIconStateColorMap is missing or invalid.")
		end

		if isDelayedInput and delayedInputImage == nil then
			isDelayedInput = false
		end

		if isLoading then
			isDisabled = true
		end

		if isDisabled then
			isDelayedInput = false
		end

		if type(fontStyle) == "string" then
			fontStyle = p11.Font[fontStyle]
		end

		if p10 == 1 then
			delayedInputImage = buttonImage
		end

		if isDelayedInput and p10 ~= 0 then
			userInteractionEnabled = false
		end

		local v69 = getContentStyle(buttonStateColorMap, controlState, p11)
		local v70 = text and getContentStyle(v62, controlState, p11)
		local v71 = icon and getContentStyle(v63, controlState, p11)
		local v72 = inputIcon and getContentStyle(v64, controlState, p11)
		local v73 = controlState == ControlState.Hover and p9.props.isHoverBackgroundEnabled == true
		local hoverImage = p9.props.hoverImage
		local n1 = 5

		if standardSize then
			local n2 = nil
			local v77 = nil

			if standardSize == StandardButtonSize.Regular then
				n2 = 48
				n1 = 12
				fontStyle = p11.Font.Header2
				v77 = false
			elseif standardSize == StandardButtonSize.Small then
				n2 = 36
				n1 = 8
				fontStyle = p11.Font.Header2
				v77 = false
			elseif standardSize == StandardButtonSize.XSmall then
				n2 = 28
				n1 = 8
				fontStyle = p11.Font.CaptionHeader
				v77 = true
			end

			if fitContent == nil then
				fitContent = v77
			end

			local v78 = not fitContent and 1 or 0

			propsSize = UDim2.new(v78, 0, 0, n2)
		end

		local t1

		if isLoading then
			t1 = {
				isLoadingShimmer = Roact.createElement(Skeleton, {
					Size = if not standardSize then UDim2.new(1, 0, 1, 0) else UDim2.new(1, n1 * 2, 1, 0),
					Position = if not standardSize then nil else UDim2.new(0, -n1, 0, 0),
					radius = getClosestRadius(p11.Tokens.Semantic.Radius, UDim.new(0, 8))
				})
			}
		else
			local absoluteSizeX = p9.state.absoluteSize.X

			if standardSize and fitContent then
				absoluteSizeX = v67
			end

			local v81 = p9.state.absoluteSize.Y - 10
			local v82 = absoluteSizeX - n1 * 2

			if icon then
				v82 -= 5 + getIconSize(IconSize.Medium)
			end

			local vector2 = Vector2.new(v82, v81)
			local v84 = p9.props[Roact.Children] or {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Icon = icon and Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
					Image = icon,
					ImageColor3 = v71.Color,
					ImageTransparency = v71.Transparency
				}) or nil,
				Text = text and Roact.createElement(GenericTextLabel, Cryo.Dictionary.join({
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Text = text,
					fontStyle = fontStyle,
					colorStyle = v70,
					maxSize = vector2,
					TextWrapped = not standardSize and nil,
					TextTruncate = if not standardSize then nil else Enum.TextTruncate.AtEnd,
					TextXAlignment = if not standardSize or not icon then nil else Enum.TextXAlignment.Left
				}, p9.props.buttonTextOverride or {})) or nil
			}

			t1 = p9.props[Roact.Children]

			if not t1 then
				t1 = {
					ButtonMiddleContent = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = if not fitContent then nil else Enum.AutomaticSize.X,
						Size = if not fitContent then UDim2.fromScale(1, 1) else UDim2.fromScale(0, 1)
					}, v84),
					ButtonIcon = inputIcon and Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -4, 0.5, 0),
						Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
						Image = inputIcon,
						ImageColor3 = v72.Color,
						ImageTransparency = v72.Transparency
					}) or nil
				}
			end
		end

		return Roact.createElement(Interactable, Cryo.Dictionary.join(p9.props, {
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
			Size = propsSize,
			AutomaticSize = if not fitContent then nil else Enum.AutomaticSize.X,
			[Roact.Ref] = p9.props.forwardedRef,
			isDisabled = isDisabled,
			onStateChanged = p9.onStateChanged,
			userInteractionEnabled = userInteractionEnabled,
			Image = buttonImage,
			ScaleType = Enum.ScaleType.Slice,
			ImageColor3 = v69.Color,
			ImageTransparency = v69.Transparency,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[Roact.Event.Activated] = p9.props.onActivated,
			[Roact.Change.AbsoluteSize] = p9.onAbsoluteSizeChanged
		}), {
			UISizeConstraint = if not standardSize or not v67 then nil else Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v67, 1e999)
			}),
			UIPadding = if not standardSize then nil else Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, n1),
				PaddingRight = UDim.new(0, n1)
			}),
			ButtonContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = if not fitContent then nil else Enum.AutomaticSize.X,
				Size = if not fitContent then UDim2.fromScale(1, 1) else UDim2.fromScale(0, 1)
			}, t1),
			LoadingImage = isDelayedInput and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				ImageTransparency = 0.5,
				Size = UDim2.new(p10, 0, 1, 0),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = delayedInputImage,
				ImageColor3 = Color3.new(0, 0, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = p9.props.SliceCenter
			}),
			HoverBackground = v73 and Roact.createElement(HoverButtonBackground, {
				sidePadding = if not standardSize then nil else UDim.new(0, n1),
				image = hoverImage,
				sliceCenter = p9.props.SliceCenter
			}) or nil,
			EventConnection = Roact.createElement(EventConnection, {
				event = RunService.RobloxGuiFocusedChanged,
				callback = p9.onRobloxGuiFocusedChanged
			})
		})
	end)
end
function v27.didUpdate(p12, p13, p14) -- line: 515
	if p12.props.enableInputDelayed ~= p13.enableInputDelayed then
		p12:setState({
			targetLoadingProgress = not p12.props.enableInputDelayed and 1 or 0
		})
	end

	if not p12.state.isButtonUnfocused and p14.isButtonUnfocused and p12.state.targetLoadingProgress == 1 and p12.props.enableInputDelayed then
		p12:setState({
			targetLoadingProgress = 0
		})
	end
end

return Roact.forwardRef(function(p15, p16) -- line: 533
	-- upvalues: Roact (copy), v27 (copy), Cryo (copy)
	return Roact.createElement(v27, Cryo.Dictionary.join(p15, {
		forwardedRef = p16
	}))
end)
