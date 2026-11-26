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
local fFlagAXTabGroupScrollOnlyWhenClipped = AvatarExperienceFlags.FFlagAXTabGroupScrollOnlyWhenClipped

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

	local v11 = v8.Size.Size_300 * 2

	local v12, v13 = useAnimatedBinding(0)
	local v14, v15 = useAnimatedBinding(0)
	local v16, v17 = React.useBinding(0)
	local v18, v19 = useAnimatedBinding(0)
	local state, setState = React.useState(false)

	local v20 = if fFlagAXCategoryMenuVisualFixes then shouldShowScrollArrowsForInputType((Responsive.useLastInput())) else nil
	local v21, v22

	if fFlagAXTabGroupScrollOnlyWhenClipped then
		local ref2 = React.useRef(nil)

		v21 = React.useCallback(function()
			ref2.current = nil
		end, {})
		v22 = ref2
	else
		v22 = nil
	end

	local v23, v24 = useAnimatedBinding(0, v21)
	local ref2 = React.useRef(nil)

	local v25 = React.useMemo(function()
		return v23:map(getCanvasPosition)
	end, {})

	local v26 = React.useMemo(function()
		local v27 = v11
		local v28 = backgroundTransparency
		return React.joinBindings({ v12, v14, v16 }):map(function(p2)
			if fFlagAXFixScrollingFrameGradientOverlap then
				return module8.fittedGradientTransparency(p2, v27, v28)
			end

			return gradientTransparency(p2, v27, v28)
		end)
	end, fFlagAXTabGroupScrollOnlyWhenClipped and { v11, backgroundTransparency } or {
		v8,
		backgroundTransparency
	})

	local v27 = React.useMemo(function()
		return React.joinBindings({ v14, v18 }):map(makeButtonTransparency)
	end, {})

	local v28 = React.useMemo(function()
		return React.joinBindings({ v12, v18 }):map(makeButtonTransparency)
	end, {})

	local v29 = React.useMemo(function()
		return v28:map(isVisibleFromTransparency)
	end, {})

	local v30 = React.useMemo(function()
		return v27:map(isVisibleFromTransparency)
	end, {})

	local v31 = React.useCallback(function()
		local current = ref2.current

		if current then
			v24(ReactOtter.instant(current.CanvasPosition.X))
			v24(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, v5))

			if fFlagAXTabGroupScrollOnlyWhenClipped and v22 then
				v22.current = current.AbsoluteCanvasSize.X - current.AbsoluteSize.X
			end
		end
	end, {})

	local v32 = React.useCallback(function()
		local current = ref2.current

		if current then
			v24(ReactOtter.instant(current.CanvasPosition.X))
			v24(makeOtterSpringValue(0, v5))

			if fFlagAXTabGroupScrollOnlyWhenClipped and v22 then
				v22.current = 0
			end
		end
	end, {})

	local function onMouseEnter()
		if fFlagAXCategoryMenuVisualFixes and not v20 then
			return
		end

		v19(makeOtterSpringValue(1, v5))
		setState(true)
	end

	local function onMouseLeave()
		if fFlagAXCategoryMenuVisualFixes and not v20 then
			return
		end

		v19(makeOtterSpringValue(0, v5))
		setState(false)
	end

	if fFlagAXCategoryMenuVisualFixes then
		React.useEffect(function()
			if not v20 then
				v19(ReactOtter.instant(0))
				setState(false)
			end
		end, { v20 })
	end

	local function onCanvasChanged(data)
		v13(makeOtterSpringValue(data.CanvasPosition.X > 0 and 1 or 0, v5))
		v15(makeOtterSpringValue(data.AbsoluteCanvasSize.X - data.CanvasPosition.X > data.AbsoluteSize.X and 1 or 0, v5))
	end

	local function onSizeChanged(p2)
		v17(p2.AbsoluteSize.X)
	end

	React.useEffect(function()
		local current = ref2.current

		if current then
			local v33 = current.CanvasPosition.X > 0 and 1 or 0

			v13(ReactOtter.instant(v33))
			local v34 = current.AbsoluteCanvasSize.X - current.CanvasPosition.X > current.AbsoluteSize.X
				and 1
				or 0

			v15(ReactOtter.instant(v34))
		end
	end, {})

	if fFlagAXCategoryMenuVisualFixes then
		local v33 = React.useCallback(function(current)
			local current2 = ref2.current

			if current2 then
				v24(ReactOtter.instant(current2.CanvasPosition.X))
				v24(makeOtterSpringValue(current, v5))

				if fFlagAXTabGroupScrollOnlyWhenClipped and v22 then
					v22.current = current
				end
			end
		end, {})

		local v34 = React.useCallback(function(p2)
			if ref2.current then
				v24(ReactOtter.instant(p2))

				if fFlagAXTabGroupScrollOnlyWhenClipped and v22 then
					v22.current = nil
				end
			end
		end, {})

		React.useImperativeHandle(props.controllerRef, function()
			return {
				scrollToOffset = v33,
				setOffset = v34,
				getScrollingFrame = function()
					return ref2.current
				end,
				getScrollTarget = function()
					if v22 then
						return v22.current
					end

					return nil
				end,
				getObscuredEdgeInset = function()
					return v11 * 2
				end
			}
		end, fFlagAXTabGroupScrollOnlyWhenClipped and { v33, v34, v11 } or { v33, v34 })
	end

	local size_1000 = v8.Size.Size_1000
	local v33 = getFixedTabHeight(v8)

	local v34 = v9 + v33 + v10

	local createElement = React.createElement
	local v37 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, size_1000) else UDim2.fromScale(1, 0)
	local v38 = if fFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	local v36 = {
		Size = v37,
		AutomaticSize = v38,
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

	local v42 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, v34) else UDim2.fromScale(1, 0)

	local v43 = if fFlagAXCategoryMenuVisualFixes then UDim2.fromOffset(0, -v9) else nil

	local v44 = if fFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	local v41 = {
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		["ClipsDescendants"] = nil,
		ClipsDescendants = true,
		Size = v42,
		Position = v43,
		AutomaticSize = v44,
		Selectable = false,
		CanvasSize = UDim2.fromScale(1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v45 = if fFlagAXCategoryMenuVisualFixes then Enum.ElasticBehavior.Never else Enum.ElasticBehavior.Always
	v41.ElasticBehavior = v45

	v41.ScrollingDirection = Enum.ScrollingDirection.X
	v41.CanvasPosition = v25

	v41[React.Change.AbsoluteSize] = onSizeChanged
	v41[React.Change.CanvasSize] = onCanvasChanged
	v41[React.Change.AbsoluteCanvasSize] = onCanvasChanged
	v41[React.Change.CanvasPosition] = onCanvasChanged
	v41[React.Event.MouseEnter] = onMouseEnter
	v41[React.Event.MouseLeave] = onMouseLeave
	v41.ref = ref2
	local v46

	if fFlagAXCategoryMenuVisualFixes then
		v46 = {
			FocusCursorInset = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v9),
				PaddingBottom = UDim.new(0, v10),
				PaddingLeft = UDim.new(0, v9),
				PaddingRight = UDim.new(0, v9)
			}),
			Content = React.createElement(React.Fragment, nil, props.children)
		}
	else
		v46 = React.createElement(React.Fragment, nil, props.children)
	end

	local children = {
		ScrollingFrame = createElement2("ScrollingFrame", v41, v46),
		OverlayFrame = 0
	}

	local createElement3 = React.createElement
	local v48 = {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundColor3
	}

	local children2 = {
		Gradient = React.createElement("UIGradient", { Transparency = v26 }),
		LeftButton = 0,
		RightButton = 0
	}

	local createElement4 = React.createElement

	local v51 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(0, 0, 0, v33 / 2) else UDim2.fromScale(0, 0.5)
	children2.LeftButton = createElement4(view, {
		Position = v51,
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = v28,
		Visible = v29
	}, React.createElement(iconButton, {
		isDisabled = not state,
		size = inputSize.Small,
		icon = v6,
		onActivated = v32
	}))

	local createElement5 = React.createElement

	local v54 = if fFlagAXCategoryMenuVisualFixes then UDim2.new(1, 0, 0, v33 / 2) else UDim2.fromScale(1, 0.5)
	children2.RightButton = createElement5(view, {
		Position = v54,
		AnchorPoint = Vector2.new(1, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = v27,
		Visible = v30
	}, React.createElement(iconButton, {
		isDisabled = not state,
		size = inputSize.Small,
		icon = v7,
		onActivated = v31
	}))
	children.OverlayFrame = createElement3("Frame", v48, children2)
	return createElement("Frame", v36, children)
end

return React.forwardRef(ScrollingFrameWithIndicators)
