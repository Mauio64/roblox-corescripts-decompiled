local GuiService = game:GetService("GuiService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local ReactUtils = require(parent.ReactUtils)
local Otter = require(parent.Otter)
local useDismissOnEscapeOrMenu = require(ChatUIPrimitives.Hooks.useDismissOnEscapeOrMenu)
local FFlagExpChatExpressionTrayReducedMotion = require(ChatUIPrimitives.Flags.FFlagExpChatExpressionTrayReducedMotion)

local useEventConnection = ReactUtils.useEventConnection

local v = { dampingRatio = 1, frequency = 3.5 }

local function getSafeInsets()
	local insetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
	local insetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)
	return {
		left = math.max(0, insetArea.Min.X - insetArea2.Min.X),
		right = math.max(0, insetArea2.Max.X - insetArea.Max.X),
		bottom = math.max(0, insetArea2.Max.Y - insetArea.Max.Y)
	}
end

local function insetsEqual(data, safeInsets): boolean -- 1 equivalent call inferred from this helper
	return data.left == safeInsets.left and data.right == safeInsets.right and data.bottom == safeInsets.bottom
end

local function ExpressionSheetView(props)
	local v2 = Foundation.Hooks.useOverlay()
	local v3

	if FFlagExpChatExpressionTrayReducedMotion then
		v3 = Foundation.Hooks.usePreferences().reducedMotion
	else
		v3 = false
	end

	local isOpen = props.isOpen
	local height = props.height or 240

	local state, setState = React.useState(false)
	local v4, v5 = React.useBinding(1)
	local ref = React.useRef(nil)

	local state2, setState2 = React.useState(getSafeInsets)
	local v6 = React.useCallback(function()
		setState2(function(data)
			local safeInsets = getSafeInsets()

			if insetsEqual(data, safeInsets) then -- inferred equivalent call
				return data
			end

			return safeInsets
		end)
	end, {})
	local v7

	if v2 ~= nil then
		v7 = v2:GetPropertyChangedSignal("AbsoluteSize")
	end

	useEventConnection(v7, v6)

	local v8 = height + state2.bottom

	React.useEffect(function()
		if v3 then
			if ref.current then
				ref.current:destroy()
				ref.current = nil
			end

			v5(isOpen and 0 or 1)
			setState(isOpen)
		elseif isOpen then
			setState(true)

			if ref.current then
				ref.current:destroy()
			end

			local singleMotor = Otter.createSingleMotor(v4:getValue())
			ref.current = singleMotor
			singleMotor:onStep(v5)
			singleMotor:setGoal(Otter.spring(0, v))
		elseif ref.current then
			ref.current:setGoal(Otter.spring(1, v))
			ref.current:onComplete(function()
				setState(false)
			end)
		end
	end, { isOpen, v3 })

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current:destroy()
				ref.current = nil
			end
		end
	end, {})

	useDismissOnEscapeOrMenu(isOpen, props.onPressedOutside)

	if not state or v2 == nil then
		return nil
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local view = Foundation.View
	local backdrop

	if isOpen then
		backdrop = React.createElement("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			[React.Event.Activated] = props.onPressedOutside
		})
	end

	return createPortal(createElement(view, { tag = "size-full" }, {
		Backdrop = backdrop,
		Tray = React.createElement(Foundation.View, {
			Position = v4:map(function(p: number)
				return UDim2.new(0.5, 0, 1, (math.round(p * v8)))
			end),
			Size = UDim2.new(1, 0, 0, v8),
			ZIndex = 2,
			tag = "anchor-bottom-center stroke-standard stroke-default clip bg-surface-200",
			padding = {
				bottom = UDim.new(0, state2.bottom),
				left = UDim.new(0, state2.left),
				right = UDim.new(0, state2.right)
			},
			onActivated = function() end,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
		}, { Container = props.content })
	}), v2)
end

return React.memo(ExpressionSheetView)
