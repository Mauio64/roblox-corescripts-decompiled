local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fpV")
local module3 = require("@luauforge/bundled/fqv")
local module4 = require("@luauforge/bundled/fqw")
local useTokens = require("@luauforge/bundled/fpW").Hooks.useTokens
local module5 = require("@luauforge/bundled/fpW")
local module6 = require("@luauforge/bundled/fqx")

local getIconSize = module2.App.ImageSet.getIconSize
local iconSize = module2.App.ImageSet.Enum.IconSize
local interactable = module2.Core.Control.Interactable
local imageSetLabel = module2.Core.ImageSet.ImageSetLabel

local images = module2.App.ImageSet.Images

local iconsactionscycleLeft = images["icons/actions/cycleLeft"]
local iconsactionscycleRight = images["icons/actions/cycleRight"]

local v5 = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

function LUAUFORGE_MODULE_GLOBALS_fqu_getMaxNumOfItemsVisible(data)
	local v6 = data.itemWidth + data.itemPadding
	return (math.floor((data.absoluteWidth + data.itemPadding) / v6))
end

function LUAUFORGE_MODULE_GLOBALS_fqu_CarouselScrollButton(p2)
	local v6 = useTokens()

	return React.createElement(interactable, {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v6.Color.OverMedia.OverMedia_0.Color3,
		BackgroundTransparency = v6.Color.OverMedia.OverMedia_0.Transparency,
		BorderSizePixel = 0,
		[React.Event.Activated] = p2.onActivate
	}, {
		CarouselScrollButtonIcon = React.createElement(imageSetLabel, {
			Size = UDim2.fromOffset(getIconSize(iconSize.Medium), getIconSize(iconSize.Medium)),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = p2.icon,
			ImageColor3 = v6.Color.ActionStandard.Foreground.Color3,
			ImageTransparency = v6.Color.ActionStandard.Foreground.Transparency
		})
	})
end

function LUAUFORGE_MODULE_GLOBALS_fqu_Carousel(state)
	local v6 = useTokens()
	local v7 = module6.useLastInput()

	local state2, setState = React.useState(false)
	local state3, setState2 = React.useState(false)
	local state4, setState3 = React.useState(0)
	local state5, setState4 = React.useState(0)

	local state6, setState5 = React.useState(0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(module3.createSingleMotor(0))

	local v8 = React.useCallback(function(p2)
		setState5(p2.AbsoluteSize.X)
	end, {})

	local v9 = React.useMemo(function()
		local flag = false
		local children = {}

		for k, v10 in state.children or {} do
			if flag then
				children[k] = v10
			else
				children[k] = React.createElement("Frame", {
					Size = UDim2.fromOffset(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[React.Change.AbsoluteSize] = v8,
					LayoutOrder = not (v10.props and v10.props.LayoutOrder) and 1 or v10.props.LayoutOrder
				}, v10)
				flag = true
			end
		end

		return children
	end, { state.children, v8 })

	local v10 = React.useCallback(function()
		local current = ref2.current

		return not (current and current.CanvasPosition.X > 0) and 1
			or math.floor(current.CanvasPosition.X / (state6 + state.itemPadding)) + 1
	end, { state6, state.itemPadding })

	local v11 = React.useCallback(function(p2)
		return (p2 - 1) * state6 + (p2 - 1) * state.itemPadding
	end, { state6, state.itemPadding })

	local v12 = React.useCallback(function(p2)
		if state.isScrollingDisabled or state3 or not ref2.current then
			return
		end

		local current = ref2.current
		local x = current.CanvasPosition.X
		local v13 = v11(p2)

		if UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(v13, 0)
			setState2(false)
		else
			if ref3.current then
				ref3.current:destroy()
			end

			ref3.current = module3.createSingleMotor(x)
			ref3.current:onStep(function(p3)
				setState2(true)
				current.CanvasPosition = Vector2.new(p3, 0)
			end)
			ref3.current:onComplete(function()
				setState2(false)
			end)
			ref3.current:setGoal(module3.spring(v13, v5))
		end
	end, { state.isScrollingDisabled, state3, v11 })

	local v13 = React.useCallback(function(p2)
		if state3 then
			return
		end

		v12((math.max(1, (math.min(p2, (module4.fieldCount(v9)))))))
	end, { state3, v12, v9 })

	local v14 = React.useCallback(function(p2)
		setState3(p2.AbsoluteSize.X)
		setState4(LUAUFORGE_MODULE_GLOBALS_fqu_getMaxNumOfItemsVisible({
			itemWidth = state6,
			itemPadding = state.itemPadding,
			absoluteWidth = p2.AbsoluteSize.X
		}))
	end, { state6, state.itemPadding })

	local v15 = React.useCallback(function()
		v13(v10() - state5)
	end, { v13, v10, state5 })

	local v16 = React.useCallback(function()
		v13(v10() + state5)
	end, { v13, v10, state5 })

	local v17 = React.useCallback(function(p2)
		if v7 == module6.Input.Pointer then
			if p2 == module5.Enums.ControlState.Default then
				setState(false)
			elseif p2 == module5.Enums.ControlState.Hover then
				setState(true)
			end
		end
	end, { v7 })

	React.useEffect(function()
		return function()
			if ref3.current then
				ref3.current:destroy()
			end
		end
	end, {})

	React.useEffect(function()
		setState4(LUAUFORGE_MODULE_GLOBALS_fqu_getMaxNumOfItemsVisible({
			itemWidth = state6,
			itemPadding = state.itemPadding,
			absoluteWidth = state4
		}))
	end, { state4, state6, state.itemPadding })

	local v18 = React.useMemo(function()
		local current = ref2.current

		if current then
			return state2 and current.CanvasPosition.X > 0
		end

		return false
	end, { state2, state3 })

	local v19 = React.useMemo(function()
		local current = ref2.current

		if not current then
			return false
		end

		local v20 = current.CanvasPosition.X + state4 >= current.AbsoluteCanvasSize.X
		return state2 and not v20
	end, { state2, state4, state3 })

	local createElement = React.createElement
	local view = module5.View
	local v20 = {
		stateLayer = { affordance = module5.Enums.StateLayerAffordance.None },
		tag = "size-full-0 auto-y clip position-top-left",
		backgroundStyle = v6.Color.None,
		ref = ref,
		onStateChanged = v17,
		onAbsoluteSizeChanged = v14
	}

	local createElement2 = React.createElement
	local v22 = {
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(0, v6.Size.Size_1000, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local v24 = if v18 then React.createElement(LUAUFORGE_MODULE_GLOBALS_fqu_CarouselScrollButton, {
		icon = iconsactionscycleLeft,
		onActivate = v15
	}) else nil
	local children = {
		CarouselLeftMargin = createElement2("Frame", v22, { ScrollLeftButton = v24 }),
		CarouselScrollingFrame = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingEnabled = not (state.isScrollingDisabled or state3),
			ScrollingDirection = Enum.ScrollingDirection.X,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			Selectable = false,
			[React.Change.CanvasPosition] = state.onChangeCanvasPosition,
			ref = function(p2)
				if p2 then
					ref2.current = p2
					state.scrollingFrameRef = p2
				end
			end
		}, { React.createElement(React.Fragment, nil, {
				CarouselListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, state.itemPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				CarouselPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, state.carouselMargin),
					PaddingRight = UDim.new(0, state.carouselMargin)
				}),
				CarouselContent = React.createElement(React.Fragment, nil, v9)
			}) }),
		CarouselRightMargin = 0
	}

	local createElement4 = React.createElement
	local v26 = {
		Position = UDim2.fromScale(1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, v6.Size.Size_1000, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local v28 = if v19 then React.createElement(LUAUFORGE_MODULE_GLOBALS_fqu_CarouselScrollButton, {
		icon = iconsactionscycleRight,
		onActivate = v16
	}) else nil
	children.CarouselRightMargin = createElement4("Frame", v26, {
		ScrollRightButton = v28
	})
	return createElement(view, v20, children)
end

return LUAUFORGE_MODULE_GLOBALS_fqu_Carousel
