local parent = script:FindFirstAncestor("Moments").Parent

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Constants = require(script.Parent.Constants)
require(script.Parent.Types)
local snapMath = require(script.Parent.snapMath)
local pagerNavigation = require(script.Parent.pagerNavigation)

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

	local v = React.useMemo(function()
		local signal, set = Signals.createSignal(ref.current.getCurrentIndex(false))
		return { get = signal, set = set }
	end, {})
	local v2 = React.useMemo(function()
		local signal, set = Signals.createSignal("Idle")
		return { get = signal, set = set }
	end, {})

	local v3 = React.useCallback(function(p)
		if v2.get(false) == p then
			return
		end

		v2.set(p)
		local current = ref6.current

		if current and current.onScrollStateChanged then
			current.onScrollStateChanged(p)
		end
	end, { v2 })

	local v4 = React.useCallback(function(p: number)
		if v.get(false) == p then
			return
		end

		v.set(p)
		local current = ref6.current

		if current and current.onActiveItemChanged then
			current.onActiveItemChanged(p, ref.current.getItems(false)[p])
		end
	end, { v })

	local v5 = React.useCallback(function()
		local current = ref22.current

		if current ~= nil then
			ref22.current = nil
			ref.current.removeItem(current)
		end
	end, {})

	local v6 = React.useCallback(function()
		if ref9.current then
			ref9.current:Disconnect()
			ref9.current = nil
		end

		ref10.current = false

		v5()
	end, { v5 })

	local v7 = React.useCallback(function(current: number)
		if not scrollingFrame then
			return
		end

		v6()
		ref10.current = true
		v3("Settling")

		ref12.current = scrollingFrame.CanvasPosition.Y
		scrollingFrame:ResetScrollVelocity()

		ref9.current = RunService.Heartbeat:Connect(function(dt)
			local v7 = scrollingFrame

			if not v7 or not ref10.current or ref13.current or not ref21.current then
				v6()
				return
			end

			v7:ResetScrollVelocity()

			local v8 = math.min(dt, Constants.MAX_SPRING_DELTA)
			local current2, current3 = snapMath.advanceCriticalDampedSpring(
				ref12.current,
				ref11.current,
				current,
				v8,
				ref5.current
			)

			ref11.current = current3
			ref12.current = current2
			v7.CanvasPosition = Vector2.new(0, current2)
			local v9

			if math.abs(current - current2) < Constants.POSITION_THRESHOLD then
				v9 = math.abs(ref11.current) < Constants.VELOCITY_THRESHOLD
			else
				v9 = false
			end

			if v9 then
				v7.CanvasPosition = Vector2.new(0, current)
				ref12.current = current

				v6()
				v3("Idle")
			end
		end)
	end, { scrollingFrame, v6, v3 })

	local v8 = React.useCallback(function(p: number, current: number, flag: boolean?)
		if not scrollingFrame then
			return
		end

		local current2 = ref.current
		local clampIndex = snapMath.clampIndex(p, current2.getCount(false))
		local currentIndex = current2.getCurrentIndex(false)
		local current3 = ref6.current
		local onTargetCommitted

		if clampIndex == currentIndex or current3 == nil then
			onTargetCommitted = nil
		else
			onTargetCommitted = current3.onTargetCommitted
		end

		local onUserStep

		if flag and clampIndex ~= currentIndex and current3 ~= nil then
			onUserStep = current3.onUserStep
		else
			onUserStep = nil
		end

		local function commitTarget() -- 3 equivalent calls inferred from this helper
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
			commitTarget() -- inferred equivalent call
		else
			local offsetForIndex = snapMath.offsetForIndex(clampIndex, ref3.current)

			if ref8.current then
				commitTarget() -- inferred equivalent call
				v6()
				scrollingFrame.CanvasPosition = Vector2.new(0, offsetForIndex)

				v4(clampIndex)
				v3("Idle")
			else
				if onTargetCommitted ~= nil then
					v3("Settling")
				end

				commitTarget() -- inferred equivalent call
				ref11.current = current
				v7(offsetForIndex)
			end
		end
	end, { scrollingFrame, v7, v6, v3, v4 })

	local v9 = React.useCallback(function(velocity: number)
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

		local snapIndex = snapMath.resolveSnapIndex(y, velocity, current2, count, ref4.current)

		local current3 = ref6.current

		if current3 and current3.onSnap then
			local nearestIndexForOffset = snapMath.nearestIndexForOffset(y, current2, count)
			current3.onSnap({
				fromIndex = nearestIndexForOffset,
				toIndex = snapIndex,
				velocity = velocity
			})
		end

		v8(snapIndex, -velocity, true)
	end, { scrollingFrame, v8 })

	local scrollToIndex = React.useCallback(function(p: number)
		v8(p, 0)
	end, { v8 })

	local nextNode = React.useCallback(function()
		v8(ref.current.getCurrentIndex(false) + 1, 0, true)
	end, { v8 })

	local previous = React.useCallback(function()
		v8(ref.current.getCurrentIndex(false) - 1, 0, true)
	end, { v8 })

	local removeItem = React.useCallback(function(current: number)
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

		v7(snapMath.offsetForIndex(neighborForRemoval, ref3.current))
		ref22.current = current
	end, { scrollingFrame, v7 })

	React.useEffect(function()
		local v10 = scrollingFrame

		if not v10 then
			return
		end

		local canvasPositionChangedConnection = v10:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if ref2.current <= 0 then
				return
			end

			local count = ref.current.getCount(false)
			v4(snapMath.nearestIndexForOffset(v10.CanvasPosition.Y, ref3.current, count))

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
				local y = v10.CanvasPosition.Y
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
					v8(settleIndex, 0, true)
				end
			end

			task.delay(Constants.SETTLE_DEBOUNCE_SECONDS, runSettle)
		end)

		return function()
			canvasPositionChangedConnection:Disconnect()
			ref20.current = false
		end
	end, { scrollingFrame, active, v4, v8 })

	React.useEffect(function()
		local v10 = scrollingFrame

		if not (v10 and active) then
			return
		end

		local function isDragInput(p): boolean
			return p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1
		end

		local shouldTrackDrag = pagerNavigation.shouldTrackDrag(true, nativeScrollEnabled)

		ref14.current = {}

		local function isWithinFrame(input): boolean -- 2 equivalent calls inferred from this helper
			local position = input.Position
			local absolutePosition = v10.AbsolutePosition
			local absoluteSize = v10.AbsoluteSize
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
				and isWithinFrame(input) -- inferred equivalent call
			then
				local v11 = next(ref14.current) == nil
				ref14.current[input] = true

				if v11 then
					ref13.current = true
					ref15.current = v10.CanvasPosition.Y
					v6()
					v3("Dragging")
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

			local y = v10:GetScrollVelocity().Y

			if
				math.abs(v10.CanvasPosition.Y - ref15.current) > Constants.POSITION_THRESHOLD
				or not (math.abs(y) < Constants.VELOCITY_THRESHOLD)
			then
				v9(y)
			else
				v3("Idle")
			end
		end)

		local function onWheel(p: number) -- 2 equivalent calls inferred from this helper
			local wheelGesture, current = pagerNavigation.resolveWheelGesture(
				os.clock(),
				ref16.current,
				Constants.WHEEL_COOLDOWN_SECONDS
			)

			ref16.current = current

			if wheelGesture then
				v8(ref.current.getCurrentIndex(false) + p, 0, true)
			end
		end

		local inputChangedConnection

		if nativeScrollEnabled then
			inputChangedConnection = nil
		else
			inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseWheel and isWithinFrame(input) then -- inferred equivalent call
					local z = input.Position.Z

					if z > 0 then
						onWheel(-1) -- inferred equivalent call
					elseif z < 0 then
						onWheel(1) -- inferred equivalent call
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
		v6,
		v3,
		v9,
		v8,
		nextNode,
		previous
	})

	local v10 = SignalsReact.useSignalState(store.getCount)
	local v11 = SignalsReact.useSignalState(store.getCurrentIndex)

	React.useEffect(function()
		local v12 = scrollingFrame
		local current = itemHeight + gap

		if not v12 or itemHeight <= 0 then
			ref18.current = current
			return
		end

		local clampIndex = snapMath.clampIndex(v11, v10)

		if current ~= ref18.current or clampIndex ~= ref17.current then
			v6()
			v12.CanvasPosition = Vector2.new(0, snapMath.offsetForIndex(clampIndex, current))
			ref17.current = clampIndex

			v4(clampIndex)

			v3("Idle")
		end

		ref18.current = current
	end, { scrollingFrame, v10, v11, itemHeight, gap, v6, v4, v3 })

	React.useEffect(function()
		if not active then
			v6()
			v3("Idle")
		end
	end, { active, v6, v3 })

	React.useEffect(function()
		ref21.current = true
		return function()
			ref21.current = false
			v6()
		end
	end, { v6 })

	return React.useMemo(function()
		return {
			getActiveIndex = v.get,
			getScrollState = v2.get,
			scrollToIndex = scrollToIndex,
			next = nextNode,
			previous = previous,
			removeItem = removeItem
		}
	end, { v, v2, scrollToIndex, nextNode, previous, removeItem })
end

return usePagerController
