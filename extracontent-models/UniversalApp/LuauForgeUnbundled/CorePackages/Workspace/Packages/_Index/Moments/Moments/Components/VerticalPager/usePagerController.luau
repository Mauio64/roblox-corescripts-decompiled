local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Types")
local snapMath = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/snapMath")
local pagerNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/pagerNavigation")

local usePreferences = Foundation.Hooks.usePreferences

local function usePagerController(data)
	local scrollingFrame = data.scrollingFrame
	local store = data.store
	local itemHeight = data.itemHeight
	local gap = data.gap
	local active = data.active
	local nativeScrollEnabled = data.nativeScrollEnabled

	local ref = React.useRef(store)
	ref.current = store
	local ref2 = React.useRef(itemHeight)
	ref2.current = itemHeight

	local ref3 = React.useRef(itemHeight + gap)
	ref3.current = itemHeight + gap
	local ref4 = React.useRef(data.snapSensitivity)
	ref4.current = data.snapSensitivity
	local ref5 = React.useRef(data.animationSpeed)
	ref5.current = data.animationSpeed
	local ref6 = React.useRef(data.analytics)
	ref6.current = data.analytics

	local ref7 = React.useRef(active)
	ref7.current = active

	local reducedMotion = usePreferences().reducedMotion
	local ref8 = React.useRef(reducedMotion)
	ref8.current = reducedMotion

	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(false)
	local ref11 = React.useRef(0)

	local ref12 = React.useRef(0)
	local ref13 = React.useRef(false)

	local ref14 = React.useRef({})

	local ref15 = React.useRef(0)

	local ref16 = React.useRef(0)

	local ref17 = React.useRef(store.getCurrentIndex(false))
	local ref18 = React.useRef(0)

	local ref19 = React.useRef(0)
	local ref20 = React.useRef(false)

	local ref21 = React.useRef(true)

	local ref22 = React.useRef(nil)

	local v5 = React.useMemo(function()
		local signal, v6 = Signals.createSignal(ref.current.getCurrentIndex(false))
		return { get = signal, set = v6 }
	end, {})
	local v6 = React.useMemo(function()
		local signal, v7 = Signals.createSignal("Idle")
		return { get = signal, set = v7 }
	end, {})

	local v7 = React.useCallback(function(p2)
		if v6.get(false) == p2 then
			return
		end

		v6.set(p2)
		local current = ref6.current

		if current and current.onScrollStateChanged then
			current.onScrollStateChanged(p2)
		end
	end, { v6 })

	local v8 = React.useCallback(function(p2)
		if v5.get(false) == p2 then
			return
		end

		v5.set(p2)
		local current = ref6.current

		if current and current.onActiveItemChanged then
			current.onActiveItemChanged(p2, ref.current.getItems(false)[p2])
		end
	end, { v5 })

	local v9 = React.useCallback(function()
		local current = ref22.current

		if current ~= nil then
			ref22.current = nil
			ref.current.removeItem(current)
		end
	end, {})

	local v10 = React.useCallback(function()
		if ref9.current then
			ref9.current:Disconnect()
			ref9.current = nil
		end

		ref10.current = false

		v9()
	end, { v9 })

	local v11 = React.useCallback(function(current)
		if not scrollingFrame then
			return
		end

		v10()
		ref10.current = true
		v7("Settling")

		ref12.current = scrollingFrame.CanvasPosition.Y
		scrollingFrame:ResetScrollVelocity()

		ref9.current = RunService.Heartbeat:Connect(function(dt)
			local v12 = scrollingFrame

			if not v12 or not ref10.current or ref13.current or not ref21.current then
				v10()
				return
			end

			v12:ResetScrollVelocity()

			local v13 = math.min(dt, Constants.MAX_SPRING_DELTA)
			local v14, v15 = snapMath.advanceCriticalDampedSpring(
				ref12.current,
				ref11.current,
				current,
				v13,
				ref5.current
			)

			ref11.current = v15
			ref12.current = v14
			v12.CanvasPosition = Vector2.new(0, v14)
			local v16

			if math.abs(current - v14) < Constants.POSITION_THRESHOLD then
				v16 = math.abs(ref11.current) < Constants.VELOCITY_THRESHOLD
			else
				v16 = false
			end

			if v16 then
				v12.CanvasPosition = Vector2.new(0, current)
				ref12.current = current

				v10()
				v7("Idle")
			end
		end)
	end, { scrollingFrame, v10, v7 })

	local v12 = React.useCallback(function(p2, current, p3)
		if not scrollingFrame then
			return
		end

		local current2 = ref.current
		local clampIndex = snapMath.clampIndex(p2, current2.getCount(false))
		local currentIndex = current2.getCurrentIndex(false)
		local current3 = ref6.current
		local onTargetCommitted

		if clampIndex == currentIndex or current3 == nil then
			onTargetCommitted = nil
		else
			onTargetCommitted = current3.onTargetCommitted
		end

		local onUserStep = if p3 and clampIndex ~= currentIndex and current3 ~= nil then current3.onUserStep else nil

		local function commitTarget()
			if onTargetCommitted ~= nil then
				onTargetCommitted(currentIndex, clampIndex, current2.getItems(false)[clampIndex])
			end

			if onUserStep ~= nil then
				onUserStep(currentIndex, clampIndex)
			end

			current2.goToItem(clampIndex)
		end

		ref17.current = clampIndex

		if ref2.current <= 0 then
			if onTargetCommitted ~= nil then
				onTargetCommitted(currentIndex, clampIndex, current2.getItems(false)[clampIndex])
			end

			if onUserStep ~= nil then
				onUserStep(currentIndex, clampIndex)
			end

			current2.goToItem(clampIndex)
		else
			local offsetForIndex = snapMath.offsetForIndex(clampIndex, ref3.current)

			if ref8.current then
				if onTargetCommitted ~= nil then
					onTargetCommitted(currentIndex, clampIndex, current2.getItems(false)[clampIndex])
				end

				if onUserStep ~= nil then
					onUserStep(currentIndex, clampIndex)
				end

				current2.goToItem(clampIndex)

				v10()
				scrollingFrame.CanvasPosition = Vector2.new(0, offsetForIndex)

				v8(clampIndex)
				v7("Idle")
			else
				if onTargetCommitted ~= nil then
					v7("Settling")
				end

				if onTargetCommitted ~= nil then
					onTargetCommitted(currentIndex, clampIndex, current2.getItems(false)[clampIndex])
				end

				if onUserStep ~= nil then
					onUserStep(currentIndex, clampIndex)
				end

				current2.goToItem(clampIndex)

				ref11.current = current
				v11(offsetForIndex)
			end
		end
	end, { scrollingFrame, v11, v10, v7, v8 })

	local v13 = React.useCallback(function(p2)
		if not scrollingFrame then
			return
		end

		local count = ref.current.getCount(false)
		local current = ref2.current

		if count <= 0 or current <= 0 then
			return
		end

		local y = scrollingFrame.CanvasPosition.Y
		local current2 = ref3.current

		local snapIndex = snapMath.resolveSnapIndex(y, p2, current2, count, ref4.current)

		local current3 = ref6.current

		if current3 and current3.onSnap then
			local nearestIndexForOffset = snapMath.nearestIndexForOffset(y, current2, count)
			current3.onSnap({
				fromIndex = nearestIndexForOffset,
				toIndex = snapIndex,
				velocity = p2
			})
		end

		v12(snapIndex, -p2, true)
	end, { scrollingFrame, v12 })

	local v14 = React.useCallback(function(p2)
		v12(p2, 0)
	end, { v12 })

	local v15 = React.useCallback(function()
		v12(ref.current.getCurrentIndex(false) + 1, 0, true)
	end, { v12 })

	local v16 = React.useCallback(function()
		v12(ref.current.getCurrentIndex(false) - 1, 0, true)
	end, { v12 })

	local v17 = React.useCallback(function(current)
		local current2 = ref.current

		if ref22.current ~= nil then
			return
		end

		local currentIndex = current2.getCurrentIndex(false)
		local count = current2.getCount(false)

		if current ~= currentIndex then
			current2.removeItem(current)
			return
		end

		if count <= 1 then
			current2.removeItem(current)
			return
		end

		local neighborForRemoval = snapMath.neighborForRemoval(currentIndex, count)
		local current3 = ref2.current

		if not scrollingFrame or current3 <= 0 or ref8.current then
			current2.removeItem(current)
			return
		end

		ref17.current = neighborForRemoval
		ref11.current = 0

		v11(snapMath.offsetForIndex(neighborForRemoval, ref3.current))
		ref22.current = current
	end, { scrollingFrame, v11 })

	React.useEffect(function()
		local v18 = scrollingFrame

		if not v18 then
			return
		end

		local canvasPositionChangedConnection = v18:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if ref2.current <= 0 then
				return
			end

			local count = ref.current.getCount(false)
			v8(snapMath.nearestIndexForOffset(v18.CanvasPosition.Y, ref3.current, count))

			if ref13.current or ref10.current or not active then
				return
			end

			ref19.current = os.clock()

			if ref20.current then
				return
			end

			ref20.current = true
			local function runSettle()
				if not ref21.current or ref13.current or ref10.current or not ref7.current then
					ref20.current = false
					return
				end

				if os.clock() - ref19.current < Constants.SETTLE_DEBOUNCE_SECONDS then
					task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)
					return
				end

				ref20.current = false

				if ref2.current <= 0 then
					return
				end

				local current = ref3.current
				local y = v18.CanvasPosition.Y
				local currentIndex = ref.current.getCurrentIndex(false)
				local settleIndex = snapMath.resolveSettleIndex(
					currentIndex,
					y,
					current,
					ref.current.getCount(false),
					Constants.WHEEL_PAGE_TURN_FRACTION,
					1
				)

				if
					settleIndex ~= currentIndex
					or math.abs(y - snapMath.offsetForIndex(currentIndex, current)) > Constants.POSITION_THRESHOLD
				then
					v12(settleIndex, 0, true)
				end
			end

			task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)
		end)

		return function()
			canvasPositionChangedConnection:Disconnect()
			ref20.current = false
		end
	end, { scrollingFrame, active, v8, v12 })

	React.useEffect(function()
		local v18 = scrollingFrame

		if not (v18 and active) then
			return
		end

		local function isDragInput(p2): boolean
			return p2.UserInputType == Enum.UserInputType.Touch
				or p2.UserInputType == Enum.UserInputType.MouseButton1
		end

		local shouldTrackDrag = pagerNavigation.shouldTrackDrag(true, nativeScrollEnabled)

		ref14.current = {}

		local function isWithinFrame(p2): boolean
			local position = p2.Position
			local absolutePosition = v18.AbsolutePosition
			local absoluteSize = v18.AbsoluteSize
			return position.X >= absolutePosition.X
				and position.X <= absolutePosition.X + absoluteSize.X
				and position.Y >= absolutePosition.Y
				and position.Y <= absolutePosition.Y + absoluteSize.Y
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			if
				shouldTrackDrag
				and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
				and not ref14.current[input]
			then
				local position = input.Position
				local absolutePosition = v18.AbsolutePosition
				local absoluteSize = v18.AbsoluteSize
				local v19

				if
					position.X >= absolutePosition.X
					and position.X <= absolutePosition.X + absoluteSize.X
					and position.Y >= absolutePosition.Y
				then
					v19 = position.Y <= absolutePosition.Y + absoluteSize.Y
				else
					v19 = false
				end

				if v19 then
					local v20 = next(ref14.current) == nil
					ref14.current[input] = true

					if v20 then
						ref13.current = true
						ref15.current = v18.CanvasPosition.Y
						v10()
						v7("Dragging")
					end
				end
			end
		end)

		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if not ref14.current[input] then
				return
			end

			ref14.current[input] = nil

			if next(ref14.current) ~= nil then
				return
			end

			ref13.current = false

			local y = v18:GetScrollVelocity().Y

			if
				math.abs(v18.CanvasPosition.Y - ref15.current) > Constants.POSITION_THRESHOLD
				or not (math.abs(y) < Constants.VELOCITY_THRESHOLD)
			then
				v13(y)
			else
				v7("Idle")
			end
		end)

		local function onWheel(p2)
			local wheelGesture, v19 = pagerNavigation.resolveWheelGesture(
				os.clock(),
				ref16.current,
				Constants.WHEEL_COOLDOWN_SECONDS
			)

			ref16.current = v19

			if wheelGesture then
				v12(ref.current.getCurrentIndex(false) + p2, 0, true)
			end
		end

		local inputChangedConnection

		if nativeScrollEnabled then
			inputChangedConnection = nil
		else
			inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseWheel then
					local position = input.Position
					local absolutePosition = v18.AbsolutePosition
					local absoluteSize = v18.AbsoluteSize
					local v19

					if
						position.X >= absolutePosition.X
						and position.X <= absolutePosition.X + absoluteSize.X
						and position.Y >= absolutePosition.Y
					then
						v19 = position.Y <= absolutePosition.Y + absoluteSize.Y
					else
						v19 = false
					end

					if v19 then
						local z = input.Position.Z

						if z > 0 then
							local wheelGesture, v20 = pagerNavigation.resolveWheelGesture(
								os.clock(),
								ref16.current,
								Constants.WHEEL_COOLDOWN_SECONDS
							)

							ref16.current = v20

							if wheelGesture then
								v12(ref.current.getCurrentIndex(false) + -1, 0, true)
							end
						elseif z < 0 then
							local wheelGesture, v20 = pagerNavigation.resolveWheelGesture(
								os.clock(),
								ref16.current,
								Constants.WHEEL_COOLDOWN_SECONDS
							)

							ref16.current = v20

							if wheelGesture then
								v12(ref.current.getCurrentIndex(false) + 1, 0, true)
							end
						end
					end
				end
			end)
		end

		return function()
			inputBeganConnection:Disconnect()
			inputEndedConnection:Disconnect()

			if inputChangedConnection then
				inputChangedConnection:Disconnect()
			end
		end
	end, {
		scrollingFrame,
		active,
		nativeScrollEnabled,
		v10,
		v7,
		v13,
		v12,
		v15,
		v16
	})

	local v18 = SignalsReact.useSignalState(store.getCount)
	local v19 = SignalsReact.useSignalState(store.getCurrentIndex)

	React.useEffect(function()
		local v20 = scrollingFrame
		local v21 = itemHeight + gap

		if not v20 or itemHeight <= 0 then
			ref18.current = v21
			return
		end

		local clampIndex = snapMath.clampIndex(v19, v18)

		if v21 ~= ref18.current or clampIndex ~= ref17.current then
			v10()
			v20.CanvasPosition = Vector2.new(0, snapMath.offsetForIndex(clampIndex, v21))
			ref17.current = clampIndex

			v8(clampIndex)

			v7("Idle")
		end

		ref18.current = v21
	end, { scrollingFrame, v18, v19, itemHeight, gap, v10, v8, v7 })

	React.useEffect(function()
		if not active then
			v10()
			v7("Idle")
		end
	end, { active, v10, v7 })

	React.useEffect(function()
		ref21.current = true
		return function()
			ref21.current = false
			v10()
		end
	end, { v10 })

	return React.useMemo(function()
		return {
			getActiveIndex = v5.get,
			getScrollState = v6.get,
			scrollToIndex = v14,
			next = v15,
			previous = v16,
			removeItem = v17
		}
	end, { v5, v6, v14, v15, v16, v17 })
end

return usePagerController
