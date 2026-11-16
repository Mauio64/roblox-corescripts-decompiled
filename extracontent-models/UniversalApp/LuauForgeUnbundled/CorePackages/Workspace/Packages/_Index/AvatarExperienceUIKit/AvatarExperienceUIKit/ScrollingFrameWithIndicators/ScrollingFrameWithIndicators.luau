local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/ReactOtter")
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Responsive")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local iconButton = Foundation.IconButton
local inputSize = Foundation.Enums.InputSize
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant

local makeOtterSpringValue = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/makeOtterSpringValue")
local shouldShowScrollArrowsForInputType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/shouldShowScrollArrowsForInputType")
local getFixedTabHeight = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getFixedTabHeight")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ScrollingFrameWithIndicators/gradientTransparency")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local fFlagAXFixScrollingFrameGradientOverlap = AvatarExperienceFlags.FFlagAXFixScrollingFrameGradientOverlap

local v5 = { dampingRatio = 1, frequency = 5 }

local v6 = { name = iconName.ChevronLargeLeft, variant = iconVariant.Filled }

local v7 = { name = iconName.ChevronLargeRight, variant = iconVariant.Filled }

local function scrollingFrameCanScrollLeft(p2): boolean
	return p2.CanvasPosition.X > 0
end

local function scrollingFrameCanScrollRight(data): boolean
	return data.AbsoluteCanvasSize.X - data.CanvasPosition.X > data.AbsoluteSize.X
end

local function getCanvasPosition(p2)
	return Vector2.new(p2, 0)
end

local function gradientTransparency(list, p2, p3)
	local v8 = 1 - p3
	local v9 = v8 * list[1]
	local v10 = v8 * list[2]
	local item = list[3]

	if item < 1 then
		return nil
	end

	local v11 = item < p2 and 1 or p2 / item
	local numberSequenceKeypoints = {}

	if v9 > 0 then
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1 - v9))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v11, 1 - v9))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(v11 + v11 * v9, 1))
	else
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(0, 1))
	end

	if v10 > 0 then
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v11 * v10 - v11, 1))

		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1 - v11, 1 - v10))
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1 - v10))
	else
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

local function makeGradientTransparency(p2, p3)
	return function(p4)
		if fFlagAXFixScrollingFrameGradientOverlap then
			return module8.fittedGradientTransparency(p4, p2, p3)
		end

		return gradientTransparency(p4, p2, p3)
	end
end

local function makeButtonTransparency(list)
	return 1 - list[1] * list[2]
end

local function isVisibleFromTransparency(p2): boolean
	return p2 < 1
end

local function ScrollingFrameWithIndicators(props, ref)
	local v8 = useTokens()

	local backgroundTransparency = props.BackgroundTransparency
		or v8.Color.Common.NavigationBar.Transparency
	local backgroundColor3 = props.BackgroundColor3 or v8.Color.Common.NavigationBar.Color3

	local v9 = if fFlagAXCategoryMenuVisualFixes then v8.Size.Size_150 else v8.Size.Size_100
	local v10 = if fFlagAXCategoryMenuVisualFixes then v9 * 2 else v9

	local v11, v12 = useAnimatedBinding(0)
	local v13, v14 = useAnimatedBinding(0)
	local v15, v16 = React.useBinding(0)
	local v17, v18 = useAnimatedBinding(0)
	local state, setState = React.useState(false)

	local v19 = if fFlagAXCategoryMenuVisualFixes then shouldShowScrollArrowsForInputType((Responsive.useLastInput())) else nil

	local v20, v21 = useAnimatedBinding(0)
	local ref2 = React.useRef(nil)

	local v22 = React.useMemo(function()
		return v20:map(getCanvasPosition)
	end, {})

	local v23 = React.useMemo(function()
		local joinBindings = React.joinBindings({ v11, v13, v15 })

		local v24 = v8.Size.Size_300 * 2
		local v25 = backgroundTransparency
		return joinBindings:map(function(p2)
			if fFlagAXFixScrollingFrameGradientOverlap then
				return module8.fittedGradientTransparency(p2, v24, v25)
			end

			return gradientTransparency(p2, v24, v25)
		end)
	end, { v8, backgroundTransparency })

	local v24 = React.useMemo(function()
		return React.joinBindings({ v13, v17 }):map(makeButtonTransparency)
	end, {})

	local v25 = React.useMemo(function()
		return React.joinBindings({ v11, v17 }):map(makeButtonTransparency)
	end, {})

	local v26 = React.useMemo(function()
		return v25:map(isVisibleFromTransparency)
	end, {})

	local v27 = React.useMemo(function()
		return v24:map(isVisibleFromTransparency)
	end, {})

	local v28 = React.useCallback(function()
		local current = ref2.current

		if current then
			v21(ReactOtter.instant(current.CanvasPosition.X))
			v21(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, v5))
		end
	end, {})

	local v29 = React.useCallback(function()
		local current = ref2.current

		if current then
			v21(ReactOtter.instant(current.CanvasPosition.X))
			v21(makeOtterSpringValue(0, v5))
		end
	end, {})

	local function onMouseEnter()
		if fFlagAXCategoryMenuVisualFixes and not v19 then
			return
		end

		v18(makeOtterSpringValue(1, v5))
		setState(true)
	end

	local function onMouseLeave()
		if fFlagAXCategoryMenuVisualFixes and not v19 then
			return
		end

		v18(makeOtterSpringValue(0, v5))
		setState(false)
	end

	if fFlagAXCategoryMenuVisualFixes then
		React.useEffect(function()
			if not v19 then
				v18(ReactOtter.instant(0))
				setState(false)
			end
		end, { v19 })
	end

	local function onCanvasChanged(data)
		v12(makeOtterSpringValue(data.CanvasPosition.X > 0 and 1 or 0, v5))
		v14(makeOtterSpringValue(data.AbsoluteCanvasSize.X - data.CanvasPosition.X > data.AbsoluteSize.X and 1 or 0, v5))
	end

	local function onSizeChanged(p2)
		v16(p2.AbsoluteSize.X)
	end

	React.useEffect(function()
		local current = ref2.current

		if current then
			local v30 = current.CanvasPosition.X > 0 and 1 or 0

			v12(ReactOtter.instant(v30))
			local v31 = current.AbsoluteCanvasSize.X - current.CanvasPosition.X > current.AbsoluteSize.X
				and 1
				or 0

			v14(ReactOtter.instant(v31))
		end
	end, {})

	if fFlagAXCategoryMenuVisualFixes then
		local v30 = React.useCallback(function(p2)
			local current = ref2.current

			if current then
				v21(ReactOtter.instant(current.CanvasPosition.X))
				v21(makeOtterSpringValue(p2, v5))
			end
		end, {})

		local v31 = React.useCallback(function(p2)
			if ref2.current then
				v21(ReactOtter.instant(p2))
			end
		end, {})

		React.useImperativeHandle(props.controllerRef, function()
			return {
				scrollToOffset = v30,
				setOffset = v31,
				getScrollingFrame = function()
					return ref2.current
				end
			}
		end, { v30, v31 })
	end

	local size_1000 = v8.Size.Size_1000
	local v30 = getFixedTabHeight(v8)

	local v31 = v9 + v30 + v10

	local createElement = React.createElement
	local v34 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, size_1000) else UDim2.fromScale(1, 0)
	local v35 = if fFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	local v33 = {
		Size = v34,
		AutomaticSize = v35,
		ClipsDescendants = if fFlagAXCategoryMenuVisualFixes then false else nil,
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = backgroundColor3,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		Position = props.Position,
		BorderSizePixel = 0,
		ref = ref
	}

	local createElement2 = React.createElement

	local v39 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, v31) else UDim2.fromScale(1, 0)

	local v40 = if fFlagAXCategoryMenuVisualFixes then UDim2.fromOffset(0, -v9) else nil

	local v41 = if fFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	local v38 = {
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		ClipsDescendants = true,
		Size = v39,
		Position = v40,
		AutomaticSize = v41,
		Selectable = false,
		CanvasSize = UDim2.fromScale(1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v42 = if fFlagAXCategoryMenuVisualFixes then Enum.ElasticBehavior.Never else Enum.ElasticBehavior.Always
	v38.ElasticBehavior = v42

	v38.ScrollingDirection = Enum.ScrollingDirection.X
	v38.CanvasPosition = v22

	v38[React.Change.AbsoluteSize] = onSizeChanged
	v38[React.Change.CanvasSize] = onCanvasChanged
	v38[React.Change.AbsoluteCanvasSize] = onCanvasChanged
	v38[React.Change.CanvasPosition] = onCanvasChanged
	v38[React.Event.MouseEnter] = onMouseEnter
	v38[React.Event.MouseLeave] = onMouseLeave
	v38.ref = ref2
	local v43

	if fFlagAXCategoryMenuVisualFixes then
		v43 = {
			FocusCursorInset = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v9),
				PaddingBottom = UDim.new(0, v10),
				PaddingLeft = UDim.new(0, v9),
				PaddingRight = UDim.new(0, v9)
			}),
			Content = React.createElement(React.Fragment, nil, props.children)
		}
	else
		v43 = React.createElement(React.Fragment, nil, props.children)
	end

	local children = {
		ScrollingFrame = createElement2("ScrollingFrame", v38, v43),
		OverlayFrame = 0
	}

	local createElement3 = React.createElement
	local v45 = {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundColor3
	}

	local children2 = {
		Gradient = React.createElement("UIGradient", { Transparency = v23 }),
		LeftButton = 0,
		RightButton = 0
	}

	local createElement4 = React.createElement

	local v48 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(0, 0, 0, v30 / 2) else UDim2.fromScale(0, 0.5)
	children2.LeftButton = createElement4(view, {
		Position = v48,
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = v25,
		Visible = v26
	}, React.createElement(iconButton, {
		isDisabled = not state,
		size = inputSize.Small,
		icon = v6,
		onActivated = v29
	}))

	local createElement5 = React.createElement

	local v51 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, v30 / 2) else UDim2.fromScale(1, 0.5)
	children2.RightButton = createElement5(view, {
		Position = v51,
		AnchorPoint = Vector2.new(1, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = v24,
		Visible = v27
	}, React.createElement(iconButton, {
		isDisabled = not state,
		size = inputSize.Small,
		icon = v7,
		onActivated = v28
	}))
	children.OverlayFrame = createElement3("Frame", v45, children2)
	return createElement("Frame", v33, children)
end

return React.forwardRef(ScrollingFrameWithIndicators)
