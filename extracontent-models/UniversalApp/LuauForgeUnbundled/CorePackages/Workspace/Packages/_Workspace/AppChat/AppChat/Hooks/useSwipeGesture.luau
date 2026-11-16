local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactOtter")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local SwipeDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/SwipeDirection")
local FFlagAppChatSwipeGestureLatestConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSwipeGestureLatestConfig")

local defineFastInt = game:DefineFastInt("AppChatSwipeStartThreshold", 10)
local defineFastInt2 = game:DefineFastInt("AppChatSwipeCompleteThreshold", 50)
local defineFastInt3 = game:DefineFastInt("AppChatSwipeMaxVerticalDrift", 35)
local defineFastFlag = game:DefineFastFlag("AppChatGlobalSwipeTracking", false)

local v5 = nil

local v6 = { frequency = 4, dampingRatio = 0.8 }

local v7 = {
	onSwipeComplete = function() end,
	direction = SwipeDirection.Right,
	swipeStartThreshold = defineFastInt,
	swipeCompleteThreshold = defineFastInt2,
	swipeMaxVerticalDrift = defineFastInt3
}

local function useSwipeGesture(p2)
	local union = Cryo.Dictionary.union(v7, p2)
	local ref = React.useRef(union)

	if FFlagAppChatSwipeGestureLatestConfig then
		ref.current = union
	end

	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	local v10 = React.useMemo(function()
		return v8:map(function(p3)
			return (math.clamp(p3 / union.swipeCompleteThreshold, 0, 1))
		end)
	end, { v8, union.swipeCompleteThreshold })

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(Vector2.zero)
	local ref5 = React.useRef(false)

	local v11 = React.useMemo(function()
		return {
			getActiveInput = function()
				return ref2.current
			end,
			setOffset = function(p3)
				local current = ref.current
				v9(ReactOtter.spring(p3, v6))

				if ref5.current or not (current.swipeCompleteThreshold < p3) then
					if ref5.current and p3 <= current.swipeCompleteThreshold then
						ref5.current = false
					end
				else
					ref5.current = true

					if current.onSwipeThresholdReached then
						current.onSwipeThresholdReached()
					end
				end
			end,
			isPastCompleteThreshold = function()
				return ref5.current
			end,
			startSwipe = function(current, callback)
				if defineFastFlag then
					v5 = current
				end

				ref2.current = current
				ref4.current = Vector2.new(current.Position.X, current.Position.Y)
				ref3.current = current.Changed:Connect(function()
					callback()
				end)
			end,
			resetSwipe = function()
				if defineFastFlag and v5 == ref2.current then
					v5 = nil
				end

				ref2.current = nil
				ref5.current = false

				if ref3.current then
					ref3.current:Disconnect()
					ref3.current = nil
				end

				v9(ReactOtter.spring(0, v6))
			end,
			disconnectInputListener = function()
				if ref3.current then
					ref3.current:Disconnect()
					ref3.current = nil
				end
			end
		}
	end, { v9 })

	local v12 = React.useCallback(function()
		local current = ref.current
		local activeInput = v11.getActiveInput()

		if not activeInput then
			return
		end

		if
			activeInput.UserInputState == Enum.UserInputState.End
			or activeInput.UserInputState == Enum.UserInputState.Cancel
		then
			if v11.isPastCompleteThreshold() then
				current.onSwipeComplete()
			end

			v11.resetSwipe()
		else
			local v13 = Vector2.new(activeInput.Position.X, activeInput.Position.Y) - ref4.current
			local v14 = if current.direction == SwipeDirection.Right then v13.X else -v13.X
			local y = math.abs(v13.Y)

			if v14 < current.swipeStartThreshold or current.swipeMaxVerticalDrift < y then
				v11.setOffset(0)
				return
			end

			local v15 = math.max(0, v14)
			v11.setOffset(v15)
		end
	end, { v11 })

	React.useEffect(function()
		return v11.resetSwipe
	end, { v11.resetSwipe })

	local v13 = React.useCallback(function(p3, p4)
		if defineFastFlag and v5 ~= nil or v11.getActiveInput() ~= nil then
			return
		end

		if
			p4.UserInputType == Enum.UserInputType.Touch
			or p4.UserInputType == Enum.UserInputType.MouseButton1
		then
			v11.startSwipe(p4, v12)
		end
	end, { v11, v12 })

	return React.useMemo(function()
		return { swipeOffset = v8, swipeProgress = v10, onInputBegan = v13 }
	end, { v8, v10, v13 })
end

return useSwipeGesture
