local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Foundation")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Otter")
local RobloxAppEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/RobloxAppEvents")
local scrollToTop = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/scrollToTop")

local view = Foundation.View
local icon = Foundation.Icon

local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags").FFlagAppPageShellScrollToTopFocus

local function PullToRefreshSpinner(props)
	local v5, v6 = React.useBinding(0)

	local v7, v8 = React.useBinding(0)

	local v9, v10 = React.useBinding(0)

	local v11, v12 = React.useBinding(0)

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

		local v13 = current:onStep(function(p2)
			v8(p2)
		end)
		local v14 = current:onComplete(function()
			if ref.current ~= "tweenBack" then
				return
			end

			ref.current = "idle"
			setState("idle")
			v8(0)
		end)

		return function()
			v13()
			v14()
			current:destroy()
		end
	end, {})

	local v13 = React.useCallback(function()
		if not props.onRefresh or ref.current ~= "idle" then
			return
		end

		ref.current = "refreshing"
		setState("refreshing")

		if ref3.current >= -52 then
			ref4.current:setGoal(Otter.spring(52, {
				dampingRatio = 0.735,
				frequency = 1.95
			}))
		else
			v8(52)
		end

		local function onSettled()
			ref.current = "tweenBack"
			setState("tweenBack")
			v12(0)

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

		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p2)
			if p2 ~= props.appEventName then
				return
			end

			local current = props.scrollingFrameRef.current

			if not current then
				return
			end

			if current.CanvasPosition.Y == 0 then
				v13()
			elseif fFlagAppPageShellScrollToTopFocus then
				scrollToTop(current)
			else
				current:ScrollToTop()
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { v13, props.appEventName, props.scrollingFrameRef })

	if fFlagAppPageShellScrollToTopFocus then
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
				v13()
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, { v13 })

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
			v6(not (y < 0) and 0 or y)
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
				v10(total * 540)
			elseif ref.current == "tweenBack" then
				v12(total)
			end
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { state })

	local v14 = React.useMemo(function()
		return React.joinBindings({ v5, v7 }):map(function(list)
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

	local v15 = React.useMemo(function()
		return React.joinBindings({ v5, v9 }):map(function(list)
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

	local v16 = React.useMemo(function()
		return React.joinBindings({ v5, v7, v11 }):map(function(list)
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

	return React.createElement(view, {
		Size = v14,
		GroupTransparency = v16,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ZIndex = 2
	}, {
		Spinner = React.createElement(icon, {
			name = "two-arrows-spin-clockwise",
			Rotation = v15,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end

return React.memo(PullToRefreshSpinner)
