local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Cryo = require(parent.Cryo)
local SwipeDirection = require(AppChat.Enums.SwipeDirection)
local FFlagAppChatSwipeGestureLatestConfig = require(AppChat.Flags.FFlagAppChatSwipeGestureLatestConfig)

local defineFastInt = game:DefineFastInt("AppChatSwipeStartThreshold", 10)
local defineFastInt2 = game:DefineFastInt("AppChatSwipeCompleteThreshold", 50)
local defineFastInt3 = game:DefineFastInt("AppChatSwipeMaxVerticalDrift", 35)
local defineFastFlag = game:DefineFastFlag("AppChatGlobalSwipeTracking", false)

local v = nil

local v2 = { frequency = 4, dampingRatio = 0.8 }

local v3 = {
	onSwipeComplete = function() end,
	direction = SwipeDirection.Right,
	swipeStartThreshold = defineFastInt,
	swipeCompleteThreshold = defineFastInt2,
	swipeMaxVerticalDrift = defineFastInt3
}

local function useSwipeGesture(p)
	local union = Cryo.Dictionary.union(v3, p)
	local ref = React.useRef(union)

	if FFlagAppChatSwipeGestureLatestConfig then
		ref.current = union
	end

	local swipeOffset, v4 = ReactOtter.useAnimatedBinding(0)
	local swipeProgress = React.useMemo(function()
		return swipeOffset:map(function(p2: number)
			return (math.clamp(p2 / union.swipeCompleteThreshold, 0, 1))
		end)
	end, { swipeOffset, union.swipeCompleteThreshold })

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(Vector2.zero)
	local ref5 = React.useRef(false)

	local v5 = React.useMemo(function()
		return {
			getActiveInput = function()
				return ref2.current
			end,
			setOffset = function(p2: number)
				local current = ref.current
				v4(ReactOtter.spring(p2, v2))

				if ref5.current or not (current.swipeCompleteThreshold < p2) then
					if ref5.current and p2 <= current.swipeCompleteThreshold then
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
					v = current
				end

				ref2.current = current
				ref4.current = Vector2.new(current.Position.X, current.Position.Y)
				ref3.current = current.Changed:Connect(function()
					callback()
				end)
			end,
			resetSwipe = function()
				if defineFastFlag and v == ref2.current then
					v = nil
				end

				ref2.current = nil
				ref5.current = false

				if ref3.current then
					ref3.current:Disconnect()
					ref3.current = nil
				end

				v4(ReactOtter.spring(0, v2))
			end,
			disconnectInputListener = function()
				if ref3.current then
					ref3.current:Disconnect()
					ref3.current = nil
				end
			end
		}
	end, { v4 })

	local v6 = React.useCallback(function()
		local current = ref.current
		local activeInput = v5.getActiveInput()

		if not activeInput then
			return
		end

		if
			activeInput.UserInputState == Enum.UserInputState.End
			or activeInput.UserInputState == Enum.UserInputState.Cancel
		then
			if v5.isPastCompleteThreshold() then
				current.onSwipeComplete()
			end

			v5.resetSwipe()
		else
			local v6 = Vector2.new(activeInput.Position.X, activeInput.Position.Y) - ref4.current
			local v7

			if current.direction == SwipeDirection.Right then
				v7 = v6.X
			else
				v7 = -v6.X
			end

			local y = math.abs(v6.Y)

			if v7 < current.swipeStartThreshold or current.swipeMaxVerticalDrift < y then
				v5.setOffset(0)
				return
			end

			local v8 = math.max(0, v7)
			v5.setOffset(v8)
		end
	end, { v5 })

	React.useEffect(function()
		return v5.resetSwipe
	end, { v5.resetSwipe })

	local onInputBegan = React.useCallback(function(_, p2)
		if defineFastFlag and v ~= nil or v5.getActiveInput() ~= nil then
			return
		end

		if p2.UserInputType == Enum.UserInputType.Touch or p2.UserInputType == Enum.UserInputType.MouseButton1 then
			v5.startSwipe(p2, v6)
		end
	end, { v5, v6 })

	return React.useMemo(function()
		return {
			swipeOffset = swipeOffset,
			swipeProgress = swipeProgress,
			onInputBegan = onInputBegan
		}
	end, { swipeOffset, swipeProgress, onInputBegan })
end

return useSwipeGesture
