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
local GetFFlagMomentsFixNavButtonSnap = require(Moments.Flags.GetFFlagMomentsFixNavButtonSnap)
local usePreferences = Foundation.Hooks.usePreferences

local function usePagerController(t1: {[any]: any}) -- line: 67
	-- upvalues: React (copy), usePreferences (copy), Signals (copy), RunService (copy), Constants (copy), snapMath (copy), GetFFlagMomentsDesktopWheelPaging (copy), pagerNavigation (copy), GetFFlagMomentsFixNavButtonSnap (copy), UserInputService (copy), SignalsReact (copy)
	local scrollingFrame = t1.scrollingFrame
	local store = t1.store
	local itemHeight = t1.itemHeight
	local gap = t1.gap
	local active = t1.active
	local nativeScrollEnabled = t1.nativeScrollEnabled
	local v23 = React.useRef(store)

	v23.current = store

	local v24 = React.useRef(itemHeight)

	v24.current = itemHeight

	local v25 = React.useRef(itemHeight + gap)

	v25.current = itemHeight + gap

	local v26 = React.useRef(t1.snapSensitivity)

	v26.current = t1.snapSensitivity

	local v27 = React.useRef(t1.animationSpeed)

	v27.current = t1.animationSpeed

	local v28 = React.useRef(t1.analytics)

	v28.current = t1.analytics

	local v29 = React.useRef(active)

	v29.current = active

	local reducedMotion = usePreferences().reducedMotion
	local v31 = React.useRef(reducedMotion)

	v31.current = reducedMotion

	local v32 = React.useRef(nil)
	local v33 = React.useRef(false)
	local v34 = React.useRef(0)
	local v35 = React.useRef(0)
	local v36 = React.useRef(false)
	local v37 = React.useRef({})
	local v38 = React.useRef(0)
	local v39 = React.useRef(0)
	local v40 = React.useRef(store.getCurrentIndex(false))
	local v41 = React.useRef(0)
	local v42 = React.useRef(0)
	local v43 = React.useRef(false)
	local v44 = React.useRef(true)
	local v45 = React.useRef(nil)
	local v46 = React.useMemo(function() -- line: 135
		-- upvalues: Signals (copy), v23 (copy)
		local v61, v62 = Signals.createSignal(v23.current.getCurrentIndex(false))

		return {
			get = v61,
			set = v62
		}
	end, {})
	local v47 = React.useMemo(function() -- line: 139
		-- upvalues: Signals (copy)
		local v63, v64 = Signals.createSignal("Idle")

		return {
			get = v63,
			set = v64
		}
	end, {})
	local v48 = React.useCallback(function(p1) -- line: 144
		-- upvalues: v47 (copy), v28 (copy)
		if p1 == v47.get(false) then
			return
		end

		v47.set(p1)

		local current = v28.current

		if current and current.onScrollStateChanged then
			current.onScrollStateChanged(p1)
		end
	end, { v47 })
	local v49 = React.useCallback(function(n1: number) -- line: 155
		-- upvalues: v46 (copy), v28 (copy), v23 (copy)
		if n1 == v46.get(false) then
			return
		end

		v46.set(n1)

		local current = v28.current

		if current and current.onActiveItemChanged then
			current.onActiveItemChanged(n1, v23.current.getItems(false)[n1])
		end
	end, { v46 })
	local v50 = React.useCallback(function() -- line: 168
		-- upvalues: v45 (copy), v23 (copy)
		local current = v45.current

		if current ~= nil then
			v45.current = nil
			v23.current.removeItem(current)
		end
	end, {})
	local v51 = React.useCallback(function() -- line: 176
		-- upvalues: v32 (copy), v33 (copy), v50 (copy)
		if v32.current then
			v32.current:Disconnect()
			v32.current = nil
		end

		v33.current = false
		v50()
	end, { v50 })
	local v52 = React.useCallback(function(n2: number) -- line: 187
		-- upvalues: scrollingFrame (copy), v51 (copy), v33 (copy), v48 (copy), v35 (copy), v32 (copy), RunService (copy), v36 (copy), v44 (copy), Constants (copy), snapMath (copy), v34 (copy), v27 (copy)
		if not scrollingFrame then
			return
		end

		v51()
		v33.current = true
		v48("Settling")
		v35.current = scrollingFrame.CanvasPosition.Y
		scrollingFrame:ResetScrollVelocity()
		v32.current = RunService.Heartbeat:Connect(function(dt) -- line: 203
			-- upvalues: scrollingFrame (copy), v33 (copy), v36 (copy), v44 (copy), v51 (copy), Constants (copy), snapMath (copy), v35 (copy), v34 (copy), n2 (copy), v27 (copy), v48 (copy)
			local v108 = scrollingFrame

			if not v108 or (not v33.current or v36.current or not v44.current) then
				v51()

				return
			end

			v108:ResetScrollVelocity()

			local v109 = math.min(dt, Constants.MAX_SPRING_DELTA)
			local v110, v111 = snapMath.advanceCriticalDampedSpring(v35.current, v34.current, n2, v109, v27.current)

			v34.current = v111
			v35.current = v110
			v108.CanvasPosition = Vector2.new(0, v110)

			if math.abs(n2 - v110) < Constants.POSITION_THRESHOLD and math.abs(v34.current) < Constants.VELOCITY_THRESHOLD then
				v108.CanvasPosition = Vector2.new(0, n2)
				v35.current = n2
				v51()
				v48("Idle")
			end
		end)
	end, {
		scrollingFrame,
		v51,
		v48
	})
	local v53 = React.useCallback(function(n3: number, n4: number) -- line: 244
		-- upvalues: scrollingFrame (copy), v23 (copy), snapMath (copy), v40 (copy), v24 (copy), v25 (copy), v31 (copy), v51 (copy), v49 (copy), v48 (copy), v34 (copy), v52 (copy)
		if not scrollingFrame then
			return
		end

		local current = v23.current
		local v74 = snapMath.clampIndex(n3, current.getCount(false))

		v40.current = v74
		current.goToItem(v74)

		if v24.current <= 0 then
			return
		end

		local v75 = snapMath.offsetForIndex(v74, v25.current)

		if v31.current then
			v51()
			scrollingFrame.CanvasPosition = Vector2.new(0, v75)
			v49(v74)
			v48("Idle")

			return
		end

		v34.current = n4
		v52(v75)
	end, {
		scrollingFrame,
		v52,
		v51,
		v48,
		v49
	})
	local v54 = React.useCallback(function(n5: number) -- line: 276
		-- upvalues: scrollingFrame (copy), v23 (copy), v24 (copy), v25 (copy), snapMath (copy), v26 (copy), v28 (copy), v53 (copy)
		if not scrollingFrame then
			return
		end

		local v77 = v23.current.getCount(false)
		local current = v24.current

		if v77 <= 0 or current <= 0 then
			return
		end

		local CanvasPositionY = scrollingFrame.CanvasPosition.Y
		local current2 = v25.current
		local v81 = snapMath.resolveSnapIndex(CanvasPositionY, n5, current2, v77, v26.current)
		local current3 = v28.current

		if current3 and current3.onSnap then
			local v83 = snapMath.nearestIndexForOffset(CanvasPositionY, current2, v77)

			current3.onSnap({
				fromIndex = v83,
				toIndex = v81,
				velocity = n5
			})
		end

		v53(v81, -n5)
	end, {
		scrollingFrame,
		v53
	})
	local v55 = React.useCallback(function(n6: number) -- line: 304
		-- upvalues: v53 (copy)
		v53(n6, 0)
	end, { v53 })
	local v56 = React.useCallback(function() -- line: 308
		-- upvalues: v53 (copy), v23 (copy)
		v53(v23.current.getCurrentIndex(false) + 1, 0)
	end, { v53 })
	local v57 = React.useCallback(function() -- line: 312
		-- upvalues: v53 (copy), v23 (copy)
		v53(v23.current.getCurrentIndex(false) - 1, 0)
	end, { v53 })
	local v58 = React.useCallback(function(n7: number) -- line: 319
		-- upvalues: v23 (copy), v45 (copy), snapMath (copy), v24 (copy), scrollingFrame (copy), v31 (copy), v40 (copy), v34 (copy), v52 (copy), v25 (copy)
		local current = v23.current

		if v45.current ~= nil then
			return
		end

		local v87 = current.getCurrentIndex(false)
		local v88 = current.getCount(false)

		if n7 ~= v87 then
			current.removeItem(n7)

			return
		end

		if v88 <= 1 then
			current.removeItem(n7)

			return
		end

		local v89 = snapMath.neighborForRemoval(v87, v88)
		local current4 = v24.current

		if not scrollingFrame or current4 <= 0 or v31.current then
			current.removeItem(n7)

			return
		end

		v40.current = v89
		v34.current = 0
		v52(snapMath.offsetForIndex(v89, v25.current))
		v45.current = n7
	end, {
		scrollingFrame,
		v52
	})

	React.useEffect(function() -- line: 361
		-- upvalues: scrollingFrame (copy), v24 (copy), v23 (copy), v49 (copy), snapMath (copy), v25 (copy), v36 (copy), v33 (copy), active (copy), v42 (copy), v43 (copy), v44 (copy), v29 (copy), Constants (copy), GetFFlagMomentsDesktopWheelPaging (copy), v53 (copy)
		local v91 = scrollingFrame

		if not v91 then
			return
		end

		local connection = v91:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 367
			-- upvalues: v24 (copy), v23 (copy), v49 (copy), snapMath (copy), v91 (copy), v25 (copy), v36 (copy), v33 (copy), active (copy), v42 (copy), v43 (copy), v44 (copy), v29 (copy), Constants (copy), GetFFlagMomentsDesktopWheelPaging (copy), v53 (copy)
			if v24.current <= 0 then
				return
			end

			local v112 = v23.current.getCount(false)

			v49(snapMath.nearestIndexForOffset(v91.CanvasPosition.Y, v25.current, v112))

			if v36.current or v33.current or not active then
				return
			end

			v42.current = os.clock()

			if v43.current then
				return
			end

			v43.current = true

			local function runSettle() -- line: 389
				-- upvalues: v44 (copy), v36 (copy), v33 (copy), v29 (copy), v43 (copy), v42 (copy), Constants (copy), runSettle (copy), v24 (copy), v25 (copy), v91 (copy), v23 (copy), snapMath (copy), GetFFlagMomentsDesktopWheelPaging (copy), v53 (copy)
				if not v44.current or (v36.current or v33.current or not v29.current) then
					v43.current = false

					return
				end

				if os.clock() - v42.current < Constants.SETTLE_DEBOUNCE_SECONDS then
					task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)

					return
				end

				v43.current = false

				if v24.current <= 0 then
					return
				end

				local current = v25.current
				local CanvasPositionY = v91.CanvasPosition.Y
				local v146 = v23.current.getCurrentIndex(false)
				local v147 = snapMath.resolveSettleIndex(v146, CanvasPositionY, current, v23.current.getCount(false), Constants.WHEEL_PAGE_TURN_FRACTION, if not GetFFlagMomentsDesktopWheelPaging() then nil else 1)

				if v147 ~= v146 or math.abs(CanvasPositionY - snapMath.offsetForIndex(v146, current)) > Constants.POSITION_THRESHOLD then
					v53(v147, 0)
				end
			end

			task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)
		end)

		return function() -- line: 431
			-- upvalues: connection (copy), v43 (copy)
			connection:Disconnect()
			v43.current = false
		end
	end, {
		scrollingFrame,
		active,
		v49,
		v53
	})
	React.useEffect(function() -- line: 442
		-- upvalues: scrollingFrame (copy), active (copy), pagerNavigation (copy), GetFFlagMomentsFixNavButtonSnap (copy), nativeScrollEnabled (copy), v37 (copy), UserInputService (copy), v36 (copy), v38 (copy), v51 (copy), v48 (copy), Constants (copy), v54 (copy), GetFFlagMomentsDesktopWheelPaging (copy), v39 (copy), v53 (copy), v23 (copy), v57 (copy), v56 (copy)
		local v93 = scrollingFrame

		if not v93 or not active then
			return
		end

		local function isDragInput(p2) -- line: 448
			return p2.UserInputType == Enum.UserInputType.Touch or p2.UserInputType == Enum.UserInputType.MouseButton1
		end

		local v95 = pagerNavigation.shouldTrackDrag(GetFFlagMomentsFixNavButtonSnap(), nativeScrollEnabled)

		v37.current = {}

		local function isWithinFrame(p3) -- line: 469
			-- upvalues: v93 (copy)
			local p3Position = p3.Position
			local AbsolutePosition = v93.AbsolutePosition
			local AbsoluteSize = v93.AbsoluteSize

			return p3Position.X >= AbsolutePosition.X and (p3Position.X <= AbsolutePosition.X + AbsoluteSize.X and (p3Position.Y >= AbsolutePosition.Y and p3Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y))
		end

		local connection = UserInputService.InputBegan:Connect(function(input) -- line: 479
			-- upvalues: v95 (copy), v37 (copy), v93 (copy), v36 (copy), v38 (copy), v51 (copy), v48 (copy)
			if v95 and ((input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not v37.current[input]) then
				local inputPosition = input.Position
				local AbsolutePosition = v93.AbsolutePosition
				local AbsoluteSize = v93.AbsoluteSize

				if inputPosition.X >= AbsolutePosition.X and (inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition.Y >= AbsolutePosition.Y and inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
					local v123 = next(v37.current) == nil

					v37.current[input] = true

					if v123 then
						v36.current = true
						v38.current = v93.CanvasPosition.Y
						v51()
						v48("Dragging")
					end

					return
				end
			end
		end)
		local connection2 = UserInputService.InputEnded:Connect(function(input) -- line: 498
			-- upvalues: v37 (copy), v36 (copy), v93 (copy), v38 (copy), Constants (copy), v48 (copy), v54 (copy)
			if not v37.current[input] then
				return
			end

			v37.current[input] = nil

			if next(v37.current) ~= nil then
				return
			end

			v36.current = false

			local Y = v93:GetScrollVelocity().Y

			if not (math.abs(v93.CanvasPosition.Y - v38.current) > Constants.POSITION_THRESHOLD) and math.abs(Y) < Constants.VELOCITY_THRESHOLD then
				v48("Idle")

				return
			end

			v54(Y)
		end)
		local connection3 = nil
		local connection4 = nil
		local connection5 = nil

		if GetFFlagMomentsDesktopWheelPaging() then
			local function onWheel(n8: number) -- line: 532
				-- upvalues: pagerNavigation (copy), v39 (copy), Constants (copy), v53 (copy), v23 (copy)
				local v127, v128 = pagerNavigation.resolveWheelGesture(os.clock(), v39.current, Constants.WHEEL_COOLDOWN_SECONDS)

				v39.current = v128

				if v127 then
					v53(v23.current.getCurrentIndex(false) + n8, 0)
				end
			end

			if not nativeScrollEnabled then
				connection3 = UserInputService.InputChanged:Connect(function(input) -- line: 552
					-- upvalues: v93 (copy), pagerNavigation (copy), v39 (copy), Constants (copy), v53 (copy), v23 (copy)
					if input.UserInputType == Enum.UserInputType.MouseWheel then
						local inputPosition = input.Position
						local AbsolutePosition = v93.AbsolutePosition
						local AbsoluteSize = v93.AbsoluteSize

						if inputPosition.X >= AbsolutePosition.X and (inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition.Y >= AbsolutePosition.Y and inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
							local PositionZ = input.Position.Z

							if PositionZ > 0 then
								local v134, v135 = pagerNavigation.resolveWheelGesture(os.clock(), v39.current, Constants.WHEEL_COOLDOWN_SECONDS)

								v39.current = v135

								if v134 then
									v53(v23.current.getCurrentIndex(false) + -1, 0)

									return
								end
							elseif PositionZ < 0 then
								local v136, v137 = pagerNavigation.resolveWheelGesture(os.clock(), v39.current, Constants.WHEEL_COOLDOWN_SECONDS)

								v39.current = v137

								if v136 then
									v53(v23.current.getCurrentIndex(false) + 1, 0)
								end
							end

							return
						end
					end
				end)
			end
		else
			local function onWheel(p4: ((...any) -> ...any)) -- line: 571
				-- upvalues: v39 (copy), Constants (copy)
				local elapsed = os.clock()

				if elapsed - v39.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v39.current = elapsed
				p4()
			end

			connection4 = v93.MouseWheelForward:Connect(function() -- line: 580
				-- upvalues: v57 (copy), v39 (copy), Constants (copy)
				local v140 = v57
				local elapsed = os.clock()

				if elapsed - v39.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v39.current = elapsed
				v140()
			end)
			connection5 = v93.MouseWheelBackward:Connect(function() -- line: 583
				-- upvalues: v56 (copy), v39 (copy), Constants (copy)
				local v142 = v56
				local elapsed = os.clock()

				if elapsed - v39.current < Constants.WHEEL_COOLDOWN_SECONDS then
					return
				end

				v39.current = elapsed
				v142()
			end)
		end

		return function() -- line: 588
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
		v51,
		v48,
		v54,
		v53,
		v56,
		v57
	})

	local v59 = SignalsReact.useSignalState(store.getCount)
	local v60 = SignalsReact.useSignalState(store.getCurrentIndex)

	React.useEffect(function() -- line: 622
		-- upvalues: scrollingFrame (copy), itemHeight (copy), gap (copy), v41 (copy), snapMath (copy), v60 (copy), v59 (copy), v40 (copy), v51 (copy), v49 (copy), v48 (copy)
		local v104 = scrollingFrame
		local v105 = itemHeight + gap

		if not v104 or itemHeight <= 0 then
			v41.current = v105

			return
		end

		local v106 = snapMath.clampIndex(v60, v59)

		if v105 ~= v41.current or v106 ~= v40.current then
			v51()
			v104.CanvasPosition = Vector2.new(0, snapMath.offsetForIndex(v106, v105))
			v40.current = v106
			v49(v106)
			v48("Idle")
		end

		v41.current = v105
	end, {
		scrollingFrame,
		v59,
		v60,
		itemHeight,
		gap,
		v51,
		v49,
		v48
	})
	React.useEffect(function() -- line: 662
		-- upvalues: active (copy), v51 (copy), v48 (copy)
		if not active then
			v51()
			v48("Idle")
		end
	end, {
		active,
		v51,
		v48
	})
	React.useEffect(function() -- line: 671
		-- upvalues: v44 (copy), v51 (copy)
		v44.current = true

		return function() -- line: 673
			-- upvalues: v44 (copy), v51 (copy)
			v44.current = false
			v51()
		end
	end, { v51 })

	return React.useMemo(function() -- line: 680
		-- upvalues: v46 (copy), v47 (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy)
		return {
			getActiveIndex = v46.get,
			getScrollState = v47.get,
			scrollToIndex = v55,
			next = v56,
			previous = v57,
			removeItem = v58
		}
	end, {
		v46,
		v47,
		v55,
		v56,
		v57,
		v58
	})
end

return usePagerController
