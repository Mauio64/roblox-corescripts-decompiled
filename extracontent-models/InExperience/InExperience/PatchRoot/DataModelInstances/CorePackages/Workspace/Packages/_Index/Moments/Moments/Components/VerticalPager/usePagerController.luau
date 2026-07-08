local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local Signals = require(MomentsParent.Signals)
local SignalsReact = require(MomentsParent.SignalsReact)
local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

local snapMath = require(script.Parent.snapMath)
local pagerNavigation = require(script.Parent.pagerNavigation)
local GetFFlagMomentsDesktopWheelPaging = require(Moments.Flags.GetFFlagMomentsDesktopWheelPaging)
local usePreferences = Foundation.Hooks.usePreferences

local function usePagerController(t1: {[any]: any}) -- line: 66
	-- upvalues: React (copy), usePreferences (copy), Signals (copy), RunService (copy), Constants (copy), snapMath (copy), GetFFlagMomentsDesktopWheelPaging (copy), UserInputService (copy), pagerNavigation (copy), SignalsReact (copy)
	local scrollingFrame = t1.scrollingFrame
	local store = t1.store
	local itemHeight = t1.itemHeight
	local gap = t1.gap
	local active = t1.active
	local nativeScrollEnabled = t1.nativeScrollEnabled
	local v22 = React.useRef(store)

	v22.current = store

	local v23 = React.useRef(itemHeight)

	v23.current = itemHeight

	local v24 = React.useRef(itemHeight + gap)

	v24.current = itemHeight + gap

	local v25 = React.useRef(t1.snapSensitivity)

	v25.current = t1.snapSensitivity

	local v26 = React.useRef(t1.animationSpeed)

	v26.current = t1.animationSpeed

	local v27 = React.useRef(t1.analytics)

	v27.current = t1.analytics

	local v28 = React.useRef(active)

	v28.current = active

	local reducedMotion = usePreferences().reducedMotion
	local v30 = React.useRef(reducedMotion)

	v30.current = reducedMotion

	local v31 = React.useRef(nil)
	local v32 = React.useRef(false)
	local v33 = React.useRef(0)
	local v34 = React.useRef(0)
	local v35 = React.useRef(false)
	local v36 = React.useRef({})
	local v37 = React.useRef(0)
	local v38 = React.useRef(0)
	local v39 = React.useRef(store.getCurrentIndex(false))
	local v40 = React.useRef(0)
	local v41 = React.useRef(0)
	local v42 = React.useRef(false)
	local v43 = React.useRef(true)
	local v44 = React.useRef(nil)
	local v45 = React.useMemo(function() -- line: 134
		-- upvalues: Signals (copy), v22 (copy)
		local v60, v61 = Signals.createSignal(v22.current.getCurrentIndex(false))

		return {
			get = v60,
			set = v61
		}
	end, {})
	local v46 = React.useMemo(function() -- line: 138
		-- upvalues: Signals (copy)
		local v62, v63 = Signals.createSignal("Idle")

		return {
			get = v62,
			set = v63
		}
	end, {})
	local v47 = React.useCallback(function(p1) -- line: 143
		-- upvalues: v46 (copy), v27 (copy)
		if p1 == v46.get(false) then
			return
		end

		v46.set(p1)

		local current = v27.current

		if current and current.onScrollStateChanged then
			current.onScrollStateChanged(p1)
		end
	end, { v46 })
	local v48 = React.useCallback(function(n1: number) -- line: 154
		-- upvalues: v45 (copy), v27 (copy), v22 (copy)
		if n1 == v45.get(false) then
			return
		end

		v45.set(n1)

		local current = v27.current

		if current and current.onActiveItemChanged then
			current.onActiveItemChanged(n1, v22.current.getItems(false)[n1])
		end
	end, { v45 })
	local v49 = React.useCallback(function() -- line: 167
		-- upvalues: v44 (copy), v22 (copy)
		local current = v44.current

		if current ~= nil then
			v44.current = nil
			v22.current.removeItem(current)
		end
	end, {})
	local v50 = React.useCallback(function() -- line: 175
		-- upvalues: v31 (copy), v32 (copy), v49 (copy)
		if v31.current then
			v31.current:Disconnect()
			v31.current = nil
		end

		v32.current = false
		v49()
	end, { v49 })
	local v51 = React.useCallback(function(n2: number) -- line: 186
		-- upvalues: scrollingFrame (copy), v50 (copy), v32 (copy), v47 (copy), v34 (copy), v31 (copy), RunService (copy), v35 (copy), v43 (copy), Constants (copy), snapMath (copy), v33 (copy), v26 (copy)
		if not scrollingFrame then
			return
		end

		v50()
		v32.current = true
		v47("Settling")
		v34.current = scrollingFrame.CanvasPosition.Y
		scrollingFrame:ResetScrollVelocity()
		v31.current = RunService.Heartbeat:Connect(function(dt) -- line: 202
			-- upvalues: scrollingFrame (copy), v32 (copy), v35 (copy), v43 (copy), v50 (copy), Constants (copy), snapMath (copy), v34 (copy), v33 (copy), n2 (copy), v26 (copy), v47 (copy)
			local v106 = scrollingFrame

			if not v106 or (not v32.current or v35.current or not v43.current) then
				v50()

				return
			end

			v106:ResetScrollVelocity()

			local v107 = math.min(dt, Constants.MAX_SPRING_DELTA)
			local v108, v109 = snapMath.advanceCriticalDampedSpring(v34.current, v33.current, n2, v107, v26.current)

			v33.current = v109
			v34.current = v108
			v106.CanvasPosition = Vector2.new(0, v108)

			if math.abs(n2 - v108) < Constants.POSITION_THRESHOLD and math.abs(v33.current) < Constants.VELOCITY_THRESHOLD then
				v106.CanvasPosition = Vector2.new(0, n2)
				v34.current = n2
				v50()
				v47("Idle")
			end
		end)
	end, {
		scrollingFrame,
		v50,
		v47
	})
	local v52 = React.useCallback(function(n3: number, n4: number) -- line: 243
		-- upvalues: scrollingFrame (copy), v22 (copy), snapMath (copy), v39 (copy), v23 (copy), v24 (copy), v30 (copy), v50 (copy), v48 (copy), v47 (copy), v33 (copy), v51 (copy)
		if not scrollingFrame then
			return
		end

		local current = v22.current
		local v73 = snapMath.clampIndex(n3, current.getCount(false))

		v39.current = v73
		current.goToItem(v73)

		if v23.current <= 0 then
			return
		end

		local v74 = snapMath.offsetForIndex(v73, v24.current)

		if v30.current then
			v50()
			scrollingFrame.CanvasPosition = Vector2.new(0, v74)
			v48(v73)
			v47("Idle")

			return
		end

		v33.current = n4
		v51(v74)
	end, {
		scrollingFrame,
		v51,
		v50,
		v47,
		v48
	})
	local v53 = React.useCallback(function(n5: number) -- line: 275
		-- upvalues: scrollingFrame (copy), v22 (copy), v23 (copy), v24 (copy), snapMath (copy), v25 (copy), v27 (copy), v52 (copy)
		if not scrollingFrame then
			return
		end

		local v76 = v22.current.getCount(false)
		local current = v23.current

		if v76 <= 0 or current <= 0 then
			return
		end

		local CanvasPositionY = scrollingFrame.CanvasPosition.Y
		local current2 = v24.current
		local v80 = snapMath.resolveSnapIndex(CanvasPositionY, n5, current2, v76, v25.current)
		local current3 = v27.current

		if current3 and current3.onSnap then
			local v82 = snapMath.nearestIndexForOffset(CanvasPositionY, current2, v76)

			current3.onSnap({
				fromIndex = v82,
				toIndex = v80,
				velocity = n5
			})
		end

		v52(v80, -n5)
	end, {
		scrollingFrame,
		v52
	})
	local v54 = React.useCallback(function(n6: number) -- line: 303
		-- upvalues: v52 (copy)
		v52(n6, 0)
	end, { v52 })
	local v55 = React.useCallback(function() -- line: 307
		-- upvalues: v52 (copy), v22 (copy)
		v52(v22.current.getCurrentIndex(false) + 1, 0)
	end, { v52 })
	local v56 = React.useCallback(function() -- line: 311
		-- upvalues: v52 (copy), v22 (copy)
		v52(v22.current.getCurrentIndex(false) - 1, 0)
	end, { v52 })
	local v57 = React.useCallback(function(n7: number) -- line: 318
		-- upvalues: v22 (copy), v44 (copy), snapMath (copy), v23 (copy), scrollingFrame (copy), v30 (copy), v39 (copy), v33 (copy), v51 (copy), v24 (copy)
		local current = v22.current

		if v44.current ~= nil then
			return
		end

		local v86 = current.getCurrentIndex(false)
		local v87 = current.getCount(false)

		if n7 ~= v86 then
			current.removeItem(n7)

			return
		end

		if v87 <= 1 then
			current.removeItem(n7)

			return
		end

		local v88 = snapMath.neighborForRemoval(v86, v87)
		local current4 = v23.current

		if not scrollingFrame or current4 <= 0 or v30.current then
			current.removeItem(n7)

			return
		end

		v39.current = v88
		v33.current = 0
		v51(snapMath.offsetForIndex(v88, v24.current))
		v44.current = n7
	end, {
		scrollingFrame,
		v51
	})

	React.useEffect(function() -- line: 360
		-- upvalues: scrollingFrame (copy), v23 (copy), v22 (copy), v48 (copy), snapMath (copy), v24 (copy), v35 (copy), v32 (copy), active (copy), v41 (copy), v42 (copy), v43 (copy), v28 (copy), Constants (copy), GetFFlagMomentsDesktopWheelPaging (copy), v52 (copy)
		local v90 = scrollingFrame

		if not v90 then
			return
		end

		local connection = v90:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 366
			-- upvalues: v23 (copy), v22 (copy), v48 (copy), snapMath (copy), v90 (copy), v24 (copy), v35 (copy), v32 (copy), active (copy), v41 (copy), v42 (copy), v43 (copy), v28 (copy), Constants (copy), GetFFlagMomentsDesktopWheelPaging (copy), v52 (copy)
			if v23.current <= 0 then
				return
			end

			local v110 = v22.current.getCount(false)

			v48(snapMath.nearestIndexForOffset(v90.CanvasPosition.Y, v24.current, v110))

			if v35.current or v32.current or not active then
				return
			end

			v41.current = os.clock()

			if v42.current then
				return
			end

			v42.current = true

			local function runSettle() -- line: 388
				-- upvalues: v43 (copy), v35 (copy), v32 (copy), v28 (copy), v42 (copy), v41 (copy), Constants (copy), runSettle (copy), v23 (copy), v24 (copy), v90 (copy), v22 (copy), snapMath (copy), GetFFlagMomentsDesktopWheelPaging (copy), v52 (copy)
				if not v43.current or (v35.current or v32.current or not v28.current) then
					v42.current = false

					return
				end

				if os.clock() - v41.current < Constants.SETTLE_DEBOUNCE_SECONDS then
					task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)

					return
				end

				v42.current = false

				if v23.current <= 0 then
					return
				end

				local current = v24.current
				local CanvasPositionY = v90.CanvasPosition.Y
				local v144 = v22.current.getCurrentIndex(false)
				local v145 = snapMath.resolveSettleIndex(v144, CanvasPositionY, current, v22.current.getCount(false), Constants.WHEEL_PAGE_TURN_FRACTION, if not GetFFlagMomentsDesktopWheelPaging() then nil else 1)

				if v145 ~= v144 or math.abs(CanvasPositionY - snapMath.offsetForIndex(v144, current)) > Constants.POSITION_THRESHOLD then
					v52(v145, 0)
				end
			end

			task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)
		end)

		return function() -- line: 430
			-- upvalues: connection (copy), v42 (copy)
			connection:Disconnect()
			v42.current = false
		end
	end, {
		scrollingFrame,
		active,
		v48,
		v52
	})
	React.useEffect(function() -- line: 441
		-- upvalues: scrollingFrame (copy), active (copy), v36 (copy), UserInputService (copy), v35 (copy), v37 (copy), v50 (copy), v47 (copy), Constants (copy), v53 (copy), GetFFlagMomentsDesktopWheelPaging (copy), pagerNavigation (copy), v38 (copy), v52 (copy), v22 (copy), nativeScrollEnabled (copy), v56 (copy), v55 (copy)
		local v92 = scrollingFrame

		if not v92 or not active then
			return
		end

		local function isDragInput(p2) -- line: 447
			return p2.UserInputType == Enum.UserInputType.Touch or p2.UserInputType == Enum.UserInputType.MouseButton1
		end

		v36.current = {}

		local function isWithinFrame(p3) -- line: 458
			-- upvalues: v92 (copy)
			local p3Position = p3.Position
			local AbsolutePosition = v92.AbsolutePosition
			local AbsoluteSize = v92.AbsoluteSize

			return p3Position.X >= AbsolutePosition.X and (p3Position.X <= AbsolutePosition.X + AbsoluteSize.X and (p3Position.Y >= AbsolutePosition.Y and p3Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y))
		end

		local connection = UserInputService.InputBegan:Connect(function(input) -- line: 468
			-- upvalues: v36 (copy), v92 (copy), v35 (copy), v37 (copy), v50 (copy), v47 (copy)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not v36.current[input] then
				local inputPosition = input.Position
				local AbsolutePosition = v92.AbsolutePosition
				local AbsoluteSize = v92.AbsoluteSize

				if inputPosition.X >= AbsolutePosition.X and (inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition.Y >= AbsolutePosition.Y and inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
					local v121 = next(v36.current) == nil

					v36.current[input] = true

					if v121 then
						v35.current = true
						v37.current = v92.CanvasPosition.Y
						v50()
						v47("Dragging")
					end

					return
				end
			end
		end)
		local connection2 = UserInputService.InputEnded:Connect(function(input) -- line: 482
			-- upvalues: v36 (copy), v35 (copy), v92 (copy), v37 (copy), Constants (copy), v47 (copy), v53 (copy)
			if not v36.current[input] then
				return
			end

			v36.current[input] = nil

			if next(v36.current) ~= nil then
				return
			end

			v35.current = false

			local Y = v92:GetScrollVelocity().Y

			if not (math.abs(v92.CanvasPosition.Y - v37.current) > Constants.POSITION_THRESHOLD) and math.abs(Y) < Constants.VELOCITY_THRESHOLD then
				v47("Idle")

				return
			end

			v53(Y)
		end)
		local connection3 = nil
		local connection4 = nil
		local connection5 = nil

		if GetFFlagMomentsDesktopWheelPaging() then
			local function onWheel(n8: number) -- line: 516
				-- upvalues: pagerNavigation (copy), v38 (copy), Constants (copy), v52 (copy), v22 (copy)
				local v125, v126 = pagerNavigation.resolveWheelGesture(os.clock(), v38.current, Constants.WHEEL_COOLDOWN_SECONDS)

				v38.current = v126

				if v125 then
					v52(v22.current.getCurrentIndex(false) + n8, 0)
				end
			end

			if not nativeScrollEnabled then
				connection3 = UserInputService.InputChanged:Connect(function(input) -- line: 536
					-- upvalues: v92 (copy), pagerNavigation (copy), v38 (copy), Constants (copy), v52 (copy), v22 (copy)
					if input.UserInputType == Enum.UserInputType.MouseWheel then
						local inputPosition = input.Position
						local AbsolutePosition = v92.AbsolutePosition
						local AbsoluteSize = v92.AbsoluteSize

						if inputPosition.X >= AbsolutePosition.X and (inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition.Y >= AbsolutePosition.Y and inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
							local PositionZ = input.Position.Z

							if PositionZ > 0 then
								local v132, v133 = pagerNavigation.resolveWheelGesture(os.clock(), v38.current, Constants.WHEEL_COOLDOWN_SECONDS)

								v38.current = v133

								if v132 then
									v52(v22.current.getCurrentIndex(false) + -1, 0)

									return
								end
							elseif PositionZ < 0 then
								local v134, v135 = pagerNavigation.resolveWheelGesture(os.clock(), v38.current, Constants.WHEEL_COOLDOWN_SECONDS)

								v38.current = v135

								if v134 then
									v52(v22.current.getCurrentIndex(false) + 1, 0)
								end
							end

							return
						end
					end
				end)
			end
		else
			local function onWheel(p4: ((...any) -> ...any)) -- line: 555
				-- upvalues: v38 (copy), Constants (copy)
				local elapsed = os.clock()

				if elapsed - v38.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v38.current = elapsed
				p4()
			end

			connection4 = v92.MouseWheelForward:Connect(function() -- line: 564
				-- upvalues: v56 (copy), v38 (copy), Constants (copy)
				local v138 = v56
				local elapsed = os.clock()

				if elapsed - v38.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v38.current = elapsed
				v138()
			end)
			connection5 = v92.MouseWheelBackward:Connect(function() -- line: 567
				-- upvalues: v55 (copy), v38 (copy), Constants (copy)
				local v140 = v55
				local elapsed = os.clock()

				if elapsed - v38.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v38.current = elapsed
				v140()
			end)
		end

		return function() -- line: 572
			-- upvalues: connection (copy), connection2 (copy), connection3 (ref), connection4 (ref), connection5 (ref)
			connection:Disconnect()
			connection2:Disconnect()

			if connection3 then
				connection3:Disconnect()
			end

			if connection4 then
				connection4:Disconnect()
			end

			if connection5 then
				connection5:Disconnect()
			end
		end
	end, {
		scrollingFrame,
		active,
		nativeScrollEnabled,
		v50,
		v47,
		v53,
		v52,
		v55,
		v56
	})

	local v58 = SignalsReact.useSignalState(store.getCount)
	local v59 = SignalsReact.useSignalState(store.getCurrentIndex)

	React.useEffect(function() -- line: 606
		-- upvalues: scrollingFrame (copy), itemHeight (copy), gap (copy), v40 (copy), snapMath (copy), v59 (copy), v58 (copy), v39 (copy), v50 (copy), v48 (copy), v47 (copy)
		local v102 = scrollingFrame
		local v103 = itemHeight + gap

		if not v102 or itemHeight <= 0 then
			v40.current = v103

			return
		end

		local v104 = snapMath.clampIndex(v59, v58)

		if v103 ~= v40.current or v104 ~= v39.current then
			v50()
			v102.CanvasPosition = Vector2.new(0, snapMath.offsetForIndex(v104, v103))
			v39.current = v104
			v48(v104)
			v47("Idle")
		end

		v40.current = v103
	end, {
		scrollingFrame,
		v58,
		v59,
		itemHeight,
		gap,
		v50,
		v48,
		v47
	})
	React.useEffect(function() -- line: 646
		-- upvalues: active (copy), v50 (copy), v47 (copy)
		if not active then
			v50()
			v47("Idle")
		end
	end, {
		active,
		v50,
		v47
	})
	React.useEffect(function() -- line: 655
		-- upvalues: v43 (copy), v50 (copy)
		v43.current = true

		return function() -- line: 657
			-- upvalues: v43 (copy), v50 (copy)
			v43.current = false
			v50()
		end
	end, { v50 })

	return React.useMemo(function() -- line: 664
		-- upvalues: v45 (copy), v46 (copy), v54 (copy), v55 (copy), v56 (copy), v57 (copy)
		return {
			getActiveIndex = v45.get,
			getScrollState = v46.get,
			scrollToIndex = v54,
			next = v55,
			previous = v56,
			removeItem = v57
		}
	end, {
		v45,
		v46,
		v54,
		v55,
		v56,
		v57
	})
end

return usePagerController
