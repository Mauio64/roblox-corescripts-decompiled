local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Otter = require(Parent.Otter)
local RobloxAppEvents = require(Parent.RobloxAppEvents)
local View = Foundation.View
local Icon = Foundation.Icon

local function PullToRefreshSpinner(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), Otter (copy), RobloxAppEvents (copy), UserInputService (copy), RunService (copy), View (copy), Icon (copy)
	local v12, v13 = React.useBinding(0)
	local v14, v15 = React.useBinding(0)
	local v16, v17 = React.useBinding(0)
	local v18, v19 = React.useBinding(0)
	local v20, v21 = React.useState("idle")
	local v22 = React.useRef("idle")
	local v23 = React.useRef(0)
	local v24 = React.useRef(0)
	local v25 = React.useRef(nil)

	if v25.current == nil then
		v25.current = Otter.createSingleMotor(0)
	end

	React.useEffect(function() -- line: 61
		-- upvalues: v25 (copy), v15 (copy), v22 (copy), v21 (copy)
		local current = v25.current
		local v31 = current:onStep(function(p1) -- line: 64
			-- upvalues: v15 (copy)
			v15(p1)
		end)
		local v32 = current:onComplete(function() -- line: 67
			-- upvalues: v22 (copy), v21 (copy), v15 (copy)
			if v22.current ~= "tweenBack" then
				return
			end

			v22.current = "idle"
			v21("idle")
			v15(0)
		end)

		return function() -- line: 76
			-- upvalues: v31 (copy), v32 (copy), current (copy)
			v31()
			v32()
			current:destroy()
		end
	end, {})

	local v26 = React.useCallback(function() -- line: 84
		-- upvalues: t1 (copy), v22 (copy), v21 (copy), v24 (copy), v25 (copy), Otter (copy), v15 (copy), v19 (copy)
		if not t1.onRefresh or v22.current ~= "idle" then
			return
		end

		v22.current = "refreshing"
		v21("refreshing")

		if v24.current >= -52 then
			v25.current:setGoal(Otter.spring(52, {
				dampingRatio = 0.735,
				frequency = 1.95
			}))
		else
			v15(52)
		end

		local function onSettled() -- line: 105
			-- upvalues: v22 (copy), v21 (copy), v19 (copy), v25 (copy), Otter (copy)
			v22.current = "tweenBack"
			v21("tweenBack")
			v19(0)
			v25.current:setGoal(Otter.spring(0, {
				dampingRatio = 0.735,
				frequency = 1.95,
				startingValue = 52
			}))
		end

		local ok, result = pcall(t1.onRefresh)

		if not ok then
			onSettled()

			return
		end

		if result and typeof(result) == "table" and result.andThen then
			result:finally(onSettled)

			return
		end

		onSettled()
	end, { t1.onRefresh })

	React.useEffect(function() -- line: 131
		-- upvalues: t1 (copy), RobloxAppEvents (copy), v26 (copy)
		if not t1.appEventName then
			return nil
		end

		local v36 = RobloxAppEvents.ReloadPage:connect(function(p2) -- line: 136
			-- upvalues: t1 (copy), v26 (copy)
			if p2 ~= t1.appEventName then
				return
			end

			local current = t1.scrollingFrameRef.current

			if not current then
				return
			end

			if current.CanvasPosition.Y ~= 0 then
				current:ScrollToTop()

				return
			end

			v26()
		end)

		return function() -- line: 151
			-- upvalues: v36 (copy)
			v36:disconnect()
		end
	end, {
		v26,
		t1.appEventName,
		t1.scrollingFrameRef
	})
	React.useEffect(function() -- line: 157
		-- upvalues: UserInputService (copy), v23 (copy), v24 (copy), v22 (copy), v26 (copy)
		local connection = UserInputService.InputBegan:Connect(function(input) -- line: 158
			-- upvalues: v23 (copy)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local v47 = v23

			v47.current = v47.current + 1
		end)
		local connection2 = UserInputService.InputEnded:Connect(function(input) -- line: 165
			-- upvalues: v23 (copy), v24 (copy), v22 (copy), v26 (copy)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if v23.current > 0 then
				local v49 = v23

				v49.current = v49.current - 1
			end

			if v23.current > 0 then
				return
			end

			if v24.current < -52 and v22.current == "idle" then
				v26()
			end
		end)

		return function() -- line: 184
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v26 })
	React.useEffect(function() -- line: 191
		-- upvalues: t1 (copy), v24 (copy), v13 (copy)
		local v39 = t1.scrollingFrameRef and t1.scrollingFrameRef.current

		if not v39 then
			return nil
		end

		local connection = v39:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 197
			-- upvalues: t1 (copy), v39 (copy), v24 (copy), v13 (copy)
			if not t1.onRefresh then
				return
			end

			local CanvasPositionY = v39.CanvasPosition.Y

			v24.current = CanvasPositionY
			v13(not (CanvasPositionY < 0) and 0 or CanvasPositionY)
		end)

		return function() -- line: 206
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t1.scrollingFrameRef,
		t1.onRefresh
	})
	React.useEffect(function() -- line: 212
		-- upvalues: v20 (copy), RunService (copy), v22 (copy), v17 (copy), v19 (copy)
		if v20 == "idle" then
			return nil
		end

		local n1 = 0
		local connection = RunService.RenderStepped:Connect(function(dt) -- line: 218
			-- upvalues: n1 (ref), v22 (copy), v17 (copy), v19 (copy)
			n1 += dt

			if v22.current == "refreshing" then
				v17(n1 * 540)

				return
			end

			if v22.current == "tweenBack" then
				v19(n1)
			end
		end)

		return function() -- line: 227
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v20 })

	local v27 = React.useMemo(function() -- line: 233
		-- upvalues: React (copy), v12 (copy), v14 (copy), v22 (copy), v23 (copy)
		return React.joinBindings({
			v12,
			v14
		}):map(function(p3) -- line: 234
			-- upvalues: v22 (copy), v23 (copy)
			local v53 = p3[1]
			local v54 = p3[2]

			if v22.current == "idle" then
				if v23.current == 0 or v53 >= 0 then
					return UDim2.new(1, 0, 0, 0)
				end

				return UDim2.new(1, 0, 0, (math.min(52, (math.abs(v53)))))
			end

			if v22.current == "refreshing" then
				return UDim2.new(1, 0, 0, (math.max(v54, 0)))
			end

			return UDim2.new(1, 0, 0, v54)
		end)
	end, {})
	local v28 = React.useMemo(function() -- line: 251
		-- upvalues: React (copy), v12 (copy), v16 (copy), v22 (copy)
		return React.joinBindings({
			v12,
			v16
		}):map(function(p4) -- line: 252
			-- upvalues: v22 (copy)
			local v56 = p4[1]
			local v57 = p4[2]

			if v22.current == "idle" then
				if v56 >= 0 or v56 <= -52 then
					return 0
				end

				return math.abs(v56) * 9.6 - 240
			end

			if v22.current == "refreshing" then
				return v57
			end

			return 0
		end)
	end, {})
	local v29 = React.useMemo(function() -- line: 269
		-- upvalues: React (copy), v12 (copy), v14 (copy), v18 (copy), v22 (copy), v23 (copy)
		return React.joinBindings({
			v12,
			v14,
			v18
		}):map(function(p5) -- line: 270
			-- upvalues: v22 (copy), v23 (copy)
			local v59 = p5[1]
			local v60 = p5[2]
			local v61 = p5[3]

			if v22.current == "idle" then
				if v23.current == 0 or v59 >= 0 then
					return 1
				end

				if v59 <= -52 then
					return 0
				end

				return 1 - math.abs(v59) * 0.04
			end

			if v22.current == "refreshing" then
				if v60 < 52 then
					return (math.max(0, 1 - v60 / 52))
				end

				return 0
			end

			return (math.min(1, 2 * v61))
		end)
	end, {})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = v27,
		GroupTransparency = v29,
		LayoutOrder = t1.LayoutOrder
	}, {
		Spinner = React.createElement(Icon, {
			name = "two-arrows-spin-clockwise",
			Rotation = v28,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end

return React.memo(PullToRefreshSpinner)
