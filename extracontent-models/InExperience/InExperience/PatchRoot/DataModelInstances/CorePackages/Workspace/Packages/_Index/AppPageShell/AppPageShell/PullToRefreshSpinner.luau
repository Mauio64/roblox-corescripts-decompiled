local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Otter = require(parent.Otter)
local RobloxAppEvents = require(parent.RobloxAppEvents)
local scrollToTop = require(AppPageShell.scrollToTop)

local View = Foundation.View
local Icon = Foundation.Icon

local SharedFlags = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus

local function PullToRefreshSpinner(props)
	local v, v2 = React.useBinding(0)

	local v3, v4 = React.useBinding(0)

	local v5, v6 = React.useBinding(0)

	local v7, v8 = React.useBinding(0)

	local state, setState = React.useState("idle")
	local ref = React.useRef("idle")
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(0)

	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = Otter.createSingleMotor(0)
	end

	React.useEffect(function()
		local current = ref4.current

		local v9 = current:onStep(function(p)
			v4(p)
		end)
		local v10 = current:onComplete(function()
			if ref.current ~= "tweenBack" then
				return
			end

			ref.current = "idle"
			setState("idle")
			v4(0)
		end)

		return function()
			v9()
			v10()
			current:destroy()
		end
	end, {})

	local v9 = React.useCallback(function()
		if not props.onRefresh or ref.current ~= "idle" then
			return
		end

		ref.current = "refreshing"
		setState("refreshing")

		if ref3.current >= -52 then
			ref4.current:setGoal(Otter.spring(52, { dampingRatio = 0.735, frequency = 1.95 }))
		else
			v4(52)
		end

		local function onSettled()
			ref.current = "tweenBack"
			setState("tweenBack")
			v8(0)

			ref4.current:setGoal(Otter.spring(0, {
				dampingRatio = 0.735,
				frequency = 1.95,
				startingValue = 52
			}))
		end

		local success, result = pcall(props.onRefresh)

		if not success then
			onSettled()
		elseif result and typeof(result) == "table" and result.andThen then
			result:finally(onSettled)
		else
			onSettled()
		end
	end, { props.onRefresh })

	React.useEffect(function()
		if not props.appEventName then
			return nil
		end

		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p)
			if p ~= props.appEventName then
				return
			end

			local current = props.scrollingFrameRef.current

			if not current then
				return
			end

			if current.CanvasPosition.Y == 0 then
				v9()
			elseif FFlagAppPageShellScrollToTopFocus then
				scrollToTop(current)
			else
				current:ScrollToTop()
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { v9, props.appEventName, props.scrollingFrameRef })

	if FFlagAppPageShellScrollToTopFocus then
		React.useEffect(function()
			local statusBarTappedConnection = UserInputService.StatusBarTapped:Connect(function()
				local current = props.scrollingFrameRef.current

				if current then
					scrollToTop(current)
				end
			end)

			return function()
				statusBarTappedConnection:Disconnect()
			end
		end, { props.scrollingFrameRef })
	end

	React.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			ref2.current += 1
		end)

		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if ref2.current > 0 then
				ref2.current -= 1
			end

			if ref2.current > 0 then
				return
			end

			if ref3.current < -52 and ref.current == "idle" then
				v9()
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, { v9 })

	React.useEffect(function()
		local current = props.scrollingFrameRef and props.scrollingFrameRef.current

		if not current then
			return nil
		end

		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if not props.onRefresh then
				return
			end

			local y = current.CanvasPosition.Y
			ref3.current = y
			v2(not (y < 0) and 0 or y)
		end)

		return function()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { props.scrollingFrameRef, props.onRefresh })

	React.useEffect(function()
		if state == "idle" then
			return nil
		end

		local total = 0
		local renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
			total += dt

			if ref.current == "refreshing" then
				v6(total * 540)
			elseif ref.current == "tweenBack" then
				v8(total)
			end
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { state })

	local size = React.useMemo(function()
		return React.joinBindings({ v, v3 }):map(function(list)
			local item = list[1]
			local item2 = list[2]

			if ref.current == "idle" then
				if ref2.current == 0 or item >= 0 then
					return UDim2.new(1, 0, 0, 0)
				end

				return UDim2.new(1, 0, 0, (math.min(52, (math.abs(item)))))
			elseif ref.current == "refreshing" then
				return UDim2.new(1, 0, 0, (math.max(item2, 0)))
			else
				return UDim2.new(1, 0, 0, item2)
			end
		end)
	end, {})

	local rotation = React.useMemo(function()
		return React.joinBindings({ v, v5 }):map(function(list)
			local item = list[1]
			local item2 = list[2]

			if ref.current == "idle" then
				if item >= 0 or item <= -52 then
					return 0
				end

				return math.abs(item) * 9.6 - 240
			elseif ref.current == "refreshing" then
				return item2
			else
				return 0
			end
		end)
	end, {})

	local groupTransparency = React.useMemo(function()
		return React.joinBindings({ v, v3, v7 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local item3 = list[3]

			if ref.current == "idle" then
				if ref2.current == 0 or item >= 0 then
					return 1
				end

				if item <= -52 then
					return 0
				end

				return 1 - math.abs(item) * 0.04
			end

			if ref.current ~= "refreshing" then
				return (math.min(1, 2 * item3))
			end

			if item2 < 52 then
				return (math.max(0, 1 - item2 / 52))
			end

			return 0
		end)
	end, {})

	return React.createElement(View, {
		Size = size,
		GroupTransparency = groupTransparency,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ZIndex = 2
	}, {
		Spinner = React.createElement(Icon, {
			name = "two-arrows-spin-clockwise",
			Rotation = rotation,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end

return React.memo(PullToRefreshSpinner)
