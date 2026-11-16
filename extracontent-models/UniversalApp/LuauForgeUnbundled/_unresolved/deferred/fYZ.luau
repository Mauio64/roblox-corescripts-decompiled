local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local useProperties = ReactUtils.useProperties
local useForwardRef = ReactUtils.useForwardRef
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local roactRodux = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux
local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum

local v5 = {
	dampingRatio = 1,
	frequency = 3,
	restingPositionLimit = 0.1,
	restingVelocityLimit = 2
}

local function useJoinBindings(callback, p2)
	return React.useMemo(function()
		local mapped = Dash.map(p2, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return callback(unpack(list))
		end)
	end, p2)
end

local function useBackEvent(p2, callback)
	local v6 = React.useCallback(function(p3)
		if p3.eventData and p3.eventData.UserInputState == Enum.UserInputState.End and callback then
			p3.cancelled = true
			callback()
		end
	end, { callback })
	return ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v6, nil, p2)
end

local function useFocusState(p2)
	local v6 = ReactFocusNavigation.useFocusedGuiObject()
	local v7 = ReactFocusNavigation.useFocusGuiObject()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v8 = React.useCallback(function(p3)
		if p3 == 1 and ref.current then
			ref.current()
			ref.current = nil
		end

		if p3 == 0 and ref2.current then
			ref2.current()
			ref2.current = nil
		end
	end, {})
	local v9, v10 = ReactOtter.useAnimatedBinding(0, v8)
	local state, setState = React.useState(false)

	local ref3 = React.useRef(nil)
	return useForwardRef(p2, (React.useCallback(function(p3)
		function ref3.current()
			function ref.current()
				v7(p3)
			end
			function ref2.current()
				setState(false)
				v7(v6)
			end
		end
	end, { v6, v7 }))), state, v9, React.useCallback(function()
		if v9:getValue() == 0 and ref3.current then
			ref3.current()
			setState(true)
			v10(ReactOtter.spring(1, v5))
		end
	end, { v6, v9 }), (React.useCallback(function()
		if v9:getValue() == 1 then
			v10(ReactOtter.spring(0, v5))
		end
	end, { v9 }))
end

return React.forwardRef(function(props, p2)
	local v6 = useSelectionCursor(cursorKind.RoundedRect)
	local selectionCursor = props.selectionCursor or v6

	local v7 = roactRodux.useSelector(function(p3)
		return p3.ScreenSize or Vector2.zero
	end)

	local v8 = React.useMemo(function()
		if props.safeAreaSize then
			return Vector2.new(
				v7.X * props.safeAreaSize.X.Scale + props.safeAreaSize.X.Offset,
				v7.Y * props.safeAreaSize.Y.Scale + props.safeAreaSize.Y.Offset
			)
		end

		return v7
	end, { v7, props.safeAreaSize })

	local v9, v10 = React.useBinding(Vector2.zero)
	local v11 = useProperties(p2, v10, "AbsolutePosition")

	local v12, v13 = React.useBinding(Vector2.zero)
	local v14 = useProperties(nil, v13, "AbsoluteSize")

	local v15, v16 = React.useBinding(Vector2.zero)
	local v17 = useProperties(nil, v16, "AbsolutePosition")

	local v18, v19 = React.useBinding(Vector2.zero)
	local v20 = useProperties(nil, v19, "AbsoluteSize")

	local v21, v22, v23, v24, v25 = useFocusState(v11)
	local v28 = if v22 then v25 else nil
	local v29 = useBackEvent(v21, v28)

	local state, setState = React.useState(false)

	local v30 = React.useMemo(function()
		return (props.renderHeader or Dash.noop)(v22)
	end, { v22, props.renderHeader })

	local v31 = React.useMemo(function()
		return props.renderContents(v22)
	end, { v22, props.renderContents })

	local v32, v33 = React.useMemo(function()
		local element = React.createElement("Frame", {
			Position = UDim2.new(),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = v20,
			BackgroundTransparency = 1,
			Selectable = false,
			SelectionGroup = true,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}, v31)

		local contentWrapper, v34 = props.renderContentWrapper(state, v22, element)
		return contentWrapper, v34 or {}
	end, { v31, state, v20, props.renderContentWrapper })

	local function fn(p3, p4, p5, p6, p7)
		local top = p5.top or 0
		local bottom = p5.bottom or 0
		local v34 = p3.Y + top + p4.Y + bottom
		return UDim2.new(1, 0, 0, v34)
	end

	local v34 = { v12, v18, v33, props.limitInlineHeight, v8 }
	local v35 = React.useMemo(function()
		local mapped = Dash.map(v34, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn(unpack(list))
		end)
	end, v34)

	local function fn2(p3, p4)
		if p3 > 0 then
			return 1000000
		end

		return p4
	end
	local v36 = { v23, props.zIndex }
	local v37 = React.useMemo(function()
		local mapped = Dash.map(v36, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn2(unpack(list))
		end)
	end, v36)

	local function fn3(p3, p4)
		if p3 > 0 then
			return UDim2.fromOffset(-p4.X, -p4.Y - 200)
		end

		return UDim2.new()
	end

	local v38 = { v23, v9 }
	local v39 = React.useMemo(function()
		local mapped = Dash.map(v38, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn3(unpack(list))
		end)
	end, v38)

	local function fn4(p3, p4)
		if p3 > 0 then
			return UDim2.fromOffset(p4.X, p4.Y + 400)
		end

		return UDim2.new()
	end

	local v40 = { v23, v7 }
	local v41 = React.useMemo(function()
		local mapped = Dash.map(v40, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn4(unpack(list))
		end)
	end, v40)

	local function fn5(p3, p4)
		return 1 - p3 * (1 - p4)
	end
	local v42 = { v23, props.overlayTransparency or 1 }
	local v43 = React.useMemo(function()
		local mapped = Dash.map(v42, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn5(unpack(list))
		end)
	end, v42)

	local function fn6(p3, p4, p5)
		local offset = p4.Y.Offset
		local v44 = math.min(offset, p5.Y) - offset
		local v45 = not props.limitInlineHeight and 0 or v44
		setState(v44 < 0 and p3 == 1)
		return UDim2.new(1, 0, 0, offset + p3 * v44 + (1 - p3) * v45)
	end

	local v44 = { v23, v35, v8, state, setState }
	local v45 = React.useMemo(function()
		local mapped = Dash.map(v44, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn6(unpack(list))
		end)
	end, v44)

	local function fn7(p3, p4, p5, p6)
		local v46 = (p6.Y - p5.Y.Offset) / 2 - p4.Y
		return UDim2.fromOffset(0, p3 * v46)
	end

	local v46 = { v23, v9, v45, v7 }
	local v47 = React.useMemo(function()
		local mapped = Dash.map(v46, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn7(unpack(list))
		end)
	end, v46)

	local function fn8(p3, p4)
		return p3 + UDim2.fromOffset(0, p4.Y)
	end
	local v48 = { v47, v12 }
	local v49 = React.useMemo(function()
		local mapped = Dash.map(v48, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn8(unpack(list))
		end)
	end, v48)

	local function fn9(p3, p4)
		return p3 - UDim2.fromOffset(0, p4.Y)
	end
	local v50 = { v45, v12 }
	local v51 = React.useMemo(function()
		local mapped = Dash.map(v50, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn9(unpack(list))
		end)
	end, v50)

	local function fn10(p3): number
		if p3 < 1 then
			return 4
		end

		return 2
	end
	local v52 = { v23 }
	local v53 = React.useMemo(function()
		local mapped = Dash.map(v52, function(p3)
			if type(p3) == "table" and p3.getValue then
				return p3
			end

			return React.createBinding(p3)
		end)

		return React.joinBindings(mapped):map(function(list)
			return fn10(unpack(list))
		end)
	end, v52)

	local createElement = React.createElement

	if props.limitInlineHeight then
		v35 = v45
	end

	return createElement("Frame", {
		Size = v35,
		ref = v29,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = v37,
		Selectable = false
	}, {
		Overlay = React.createElement("TextButton", {
			Text = "",
			Position = v39,
			Size = v41,
			BackgroundColor3 = props.overlayColor3 or Color3.new(0, 0, 0),
			BackgroundTransparency = v43,
			AutoButtonColor = false,
			ZIndex = 1,
			Selectable = false,
			Active = true,
			[React.Event.Activated] = v25
		}),
		Header = React.createElement("Frame", {
			ref = v14,
			Position = v47,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Selectable = false,
			ZIndex = 3
		}, v30),
		Panel = React.createElement("Frame", {
			Position = v49,
			Size = v51,
			ref = v17,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 3
		}, v32),
		Cover = React.createElement("TextButton", {
			Text = "",
			Position = v49,
			Size = v51,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			ZIndex = v53,
			Active = true,
			Selectable = true,
			SelectionImageObject = selectionCursor,
			SelectionOrder = 1,
			SelectionGroup = v22,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			[React.Event.Activated] = v24
		})
	})
end)
