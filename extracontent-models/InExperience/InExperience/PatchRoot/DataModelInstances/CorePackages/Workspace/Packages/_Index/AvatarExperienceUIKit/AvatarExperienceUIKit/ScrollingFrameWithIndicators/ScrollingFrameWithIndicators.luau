local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant

local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local shouldShowScrollArrowsForInputType = require(AvatarExperienceUIKit.Utils.shouldShowScrollArrowsForInputType)
local getFixedTabHeight = require(AvatarExperienceUIKit.Utils.getFixedTabHeight)
local gradientTransparency = require(script.Parent.gradientTransparency)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local FFlagAXFixScrollingFrameGradientOverlap = AvatarExperienceFlags.FFlagAXFixScrollingFrameGradientOverlap

local v = { dampingRatio = 1, frequency = 5 }

local icon = { name = IconName.ChevronLargeLeft, variant = IconVariant.Filled }

local icon2 = { name = IconName.ChevronLargeRight, variant = IconVariant.Filled }

local function scrollingFrameCanScrollLeft(p): boolean -- 2 equivalent calls inferred from this helper
	return p.CanvasPosition.X > 0
end

local function scrollingFrameCanScrollRight(data): boolean -- 2 equivalent calls inferred from this helper
	return data.AbsoluteCanvasSize.X - data.CanvasPosition.X > data.AbsoluteSize.X
end

local function getCanvasPosition(p: number)
	return Vector2.new(p, 0)
end

local function gradientTransparency2(list, p: number, p2: number)
	local v2 = 1 - p2
	local v3 = v2 * list[1]
	local v4 = v2 * list[2]
	local item = list[3]

	if item < 1 then
		return nil
	end

	local v5 = item < p and 1 or p / item
	local numberSequenceKeypoints = {}

	if v3 > 0 then
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1 - v3))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v5, 1 - v3))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v5 + v5 * v3, 1))
	else
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1))
	end

	if v4 > 0 then
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v5 * v4 - v5, 1))

		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v5, 1 - v4))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1 - v4))
	else
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

local function makeGradientTransparency(p: number, backgroundTransparency: number) -- 1 equivalent call inferred from this helper
	return function(p2)
		if FFlagAXFixScrollingFrameGradientOverlap then
			return gradientTransparency.fittedGradientTransparency(p2, p, backgroundTransparency)
		end

		return gradientTransparency2(p2, p, backgroundTransparency)
	end
end

local function makeButtonTransparency(list)
	return 1 - list[1] * list[2]
end

local function isVisibleFromTransparency(p: number): boolean
	return p < 1
end

local function ScrollingFrameWithIndicators(props, ref)
	local v2 = useTokens()

	local backgroundTransparency = props.BackgroundTransparency or v2.Color.Common.NavigationBar.Transparency
	local backgroundColor3 = props.BackgroundColor3 or v2.Color.Common.NavigationBar.Color3
	local v3

	if FFlagAXCategoryMenuVisualFixes then
		v3 = v2.Size.Size_150
	else
		v3 = v2.Size.Size_100
	end

	local v4

	if FFlagAXCategoryMenuVisualFixes then
		v4 = v3 * 2
	else
		v4 = v3
	end

	local v5, v6 = useAnimatedBinding(0)
	local v7, v8 = useAnimatedBinding(0)
	local v9, v10 = React.useBinding(0)
	local v11, v12 = useAnimatedBinding(0)
	local state, setState = React.useState(false)
	local v13

	if FFlagAXCategoryMenuVisualFixes then
		v13 = shouldShowScrollArrowsForInputType((Responsive.useLastInput()))
	else
		v13 = nil
	end

	local v14, v15 = useAnimatedBinding(0)
	local ref2 = React.useRef(nil)

	local canvasPosition = React.useMemo(function()
		return v14:map(getCanvasPosition)
	end, {})

	local transparency = React.useMemo(function()
		return React.joinBindings({ v5, v7, v9 }):map(makeGradientTransparency( -- inferred equivalent call
			v2.Size.Size_300 * 2,
			backgroundTransparency
		))
	end, { v2, backgroundTransparency })

	local groupTransparency = React.useMemo(function()
		return React.joinBindings({ v7, v11 }):map(makeButtonTransparency)
	end, {})

	local groupTransparency2 = React.useMemo(function()
		return React.joinBindings({ v5, v11 }):map(makeButtonTransparency)
	end, {})

	local visible = React.useMemo(function()
		return groupTransparency2:map(isVisibleFromTransparency)
	end, {})

	local visible2 = React.useMemo(function()
		return groupTransparency:map(isVisibleFromTransparency)
	end, {})

	local onActivated = React.useCallback(function()
		local current = ref2.current

		if current then
			v15(ReactOtter.instant(current.CanvasPosition.X))
			v15(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, v))
		end
	end, {})

	local onActivated2 = React.useCallback(function()
		local current = ref2.current

		if current then
			v15(ReactOtter.instant(current.CanvasPosition.X))
			v15(makeOtterSpringValue(0, v))
		end
	end, {})

	local function onMouseEnter()
		if FFlagAXCategoryMenuVisualFixes and not v13 then
			return
		end

		v12(makeOtterSpringValue(1, v))
		setState(true)
	end

	local function onMouseLeave()
		if FFlagAXCategoryMenuVisualFixes and not v13 then
			return
		end

		v12(makeOtterSpringValue(0, v))
		setState(false)
	end

	if FFlagAXCategoryMenuVisualFixes then
		React.useEffect(function()
			if not v13 then
				v12(ReactOtter.instant(0))
				setState(false)
			end
		end, { v13 })
	end

	local function onCanvasChanged(data)
		v6(makeOtterSpringValue(scrollingFrameCanScrollLeft(data) and 1 or 0, v)) -- inferred equivalent call

		v8(makeOtterSpringValue(scrollingFrameCanScrollRight(data) and 1 or 0, v)) -- inferred equivalent call
	end

	local function onSizeChanged(p)
		v10(p.AbsoluteSize.X)
	end

	React.useEffect(function()
		local current = ref2.current

		if current then
			local v16 = scrollingFrameCanScrollLeft(current) and 1 or 0 -- inferred equivalent call
			v6(ReactOtter.instant(v16))
			local v17 = scrollingFrameCanScrollRight(current) and 1 or 0 -- inferred equivalent call
			v8(ReactOtter.instant(v17))
		end
	end, {})

	if FFlagAXCategoryMenuVisualFixes then
		local scrollToOffset = React.useCallback(function(p: number)
			local current = ref2.current

			if current then
				v15(ReactOtter.instant(current.CanvasPosition.X))
				v15(makeOtterSpringValue(p, v))
			end
		end, {})

		local setOffset = React.useCallback(function(p: number)
			if ref2.current then
				v15(ReactOtter.instant(p))
			end
		end, {})

		React.useImperativeHandle(props.controllerRef, function()
			return {
				scrollToOffset = scrollToOffset,
				setOffset = setOffset,
				getScrollingFrame = function()
					return ref2.current
				end
			}
		end, { scrollToOffset, setOffset })
	end

	local size_1000 = v2.Size.Size_1000
	local fixedTabHeight = getFixedTabHeight(v2)

	local v16 = v3 + fixedTabHeight + v4

	local createElement = React.createElement
	local size

	if FFlagAXCategoryMenuVisualFixes then
		size = UDim2.new(1, 0, 0, size_1000)
	else
		size = UDim2.fromScale(1, 0)
	end

	local automaticSize

	if FFlagAXCategoryMenuVisualFixes then
		automaticSize = Enum.AutomaticSize.None
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	local v17 = {
		Size = size,
		AutomaticSize = automaticSize,
		ClipsDescendants = not FFlagAXCategoryMenuVisualFixes and nil,
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = backgroundColor3,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		Position = props.Position,
		BorderSizePixel = 0,
		ref = ref
	}

	local createElement2 = React.createElement
	local size2

	if FFlagAXCategoryMenuVisualFixes then
		size2 = UDim2.new(1, 0, 0, v16)
	else
		size2 = UDim2.fromScale(1, 0)
	end

	local position

	if FFlagAXCategoryMenuVisualFixes then
		position = UDim2.fromOffset(0, -v3)
	end

	local automaticSize2

	if FFlagAXCategoryMenuVisualFixes then
		automaticSize2 = Enum.AutomaticSize.None
	else
		automaticSize2 = Enum.AutomaticSize.Y
	end

	local v18 = {
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		ClipsDescendants = true,
		Size = size2,
		Position = position,
		AutomaticSize = automaticSize2,
		Selectable = false,
		CanvasSize = UDim2.fromScale(1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local elasticBehavior

	if FFlagAXCategoryMenuVisualFixes then
		elasticBehavior = Enum.ElasticBehavior.Never
	else
		elasticBehavior = Enum.ElasticBehavior.Always
	end

	v18.ElasticBehavior = elasticBehavior

	v18.ScrollingDirection = Enum.ScrollingDirection.X
	v18.CanvasPosition = canvasPosition

	v18[React.Change.AbsoluteSize] = onSizeChanged
	v18[React.Change.CanvasSize] = onCanvasChanged
	v18[React.Change.AbsoluteCanvasSize] = onCanvasChanged
	v18[React.Change.CanvasPosition] = onCanvasChanged
	v18[React.Event.MouseEnter] = onMouseEnter
	v18[React.Event.MouseLeave] = onMouseLeave
	v18.ref = ref2
	local v19

	if FFlagAXCategoryMenuVisualFixes then
		v19 = {
			FocusCursorInset = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v3),
				PaddingBottom = UDim.new(0, v4),
				PaddingLeft = UDim.new(0, v3),
				PaddingRight = UDim.new(0, v3)
			}),
			Content = React.createElement(React.Fragment, nil, props.children)
		}
	else
		v19 = React.createElement(React.Fragment, nil, props.children)
	end

	local children = {
		ScrollingFrame = createElement2("ScrollingFrame", v18, v19),
		OverlayFrame = 0
	}

	local createElement3 = React.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundColor3
	}

	local children2 = {
		Gradient = React.createElement("UIGradient", { Transparency = transparency }),
		LeftButton = 0,
		RightButton = 0
	}

	local createElement4 = React.createElement
	local position2

	if FFlagAXCategoryMenuVisualFixes then
		position2 = UDim2.new(0, 0, 0, fixedTabHeight / 2)
	else
		position2 = UDim2.fromScale(0, 0.5)
	end

	children2.LeftButton = createElement4(View, {
		Position = position2,
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = groupTransparency2,
		Visible = visible
	}, React.createElement(IconButton, {
		isDisabled = not state,
		size = InputSize.Small,
		icon = icon,
		onActivated = onActivated2
	}))

	local createElement5 = React.createElement
	local position3

	if FFlagAXCategoryMenuVisualFixes then
		position3 = UDim2.new(1, 0, 0, fixedTabHeight / 2)
	else
		position3 = UDim2.fromScale(1, 0.5)
	end

	children2.RightButton = createElement5(View, {
		Position = position3,
		AnchorPoint = Vector2.new(1, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = groupTransparency,
		Visible = visible2
	}, React.createElement(IconButton, {
		isDisabled = not state,
		size = InputSize.Small,
		icon = icon2,
		onActivated = onActivated
	}))
	children.OverlayFrame = createElement3("Frame", v20, children2)
	return createElement("Frame", v17, children)
end

return React.forwardRef(ScrollingFrameWithIndicators)
