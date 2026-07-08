local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local ReactOtter = require(AppChatParent.ReactOtter)
local Cryo = require(AppChatParent.Cryo)
local SwipeDirection = require(AppChat.Enums.SwipeDirection)
local v7 = game:DefineFastInt("AppChatSwipeStartThreshold", 10)
local v8 = game:DefineFastInt("AppChatSwipeCompleteThreshold", 50)
local v9 = game:DefineFastInt("AppChatSwipeMaxVerticalDrift", 35)
local v10 = game:DefineFastFlag("AppChatGlobalSwipeTracking", false)
local u11 = nil
local t1 = {
	frequency = 4,
	dampingRatio = 0.8
}
local t2 = {
	onSwipeComplete = function() -- line: 34
	end,
	direction = SwipeDirection.Right,
	swipeStartThreshold = v7,
	swipeCompleteThreshold = v8,
	swipeMaxVerticalDrift = v9
}

local function useSwipeGesture(t3: {[any]: any}) -- line: 47
	-- upvalues: Cryo (copy), t2 (copy), ReactOtter (copy), React (copy), v10 (copy), u11 (ref), t1 (copy), SwipeDirection (copy)
	local v16 = Cryo.Dictionary.union(t2, t3)
	local v17, v18 = ReactOtter.useAnimatedBinding(0)
	local v19 = React.useMemo(function() -- line: 51
		-- upvalues: v17 (copy), v16 (copy)
		return v17:map(function(n1: number) -- line: 52
			-- upvalues: v16 (copy)
			return (math.clamp(n1 / v16.swipeCompleteThreshold, 0, 1))
		end)
	end, {
		v17,
		v16.swipeCompleteThreshold
	})
	local v20 = React.useRef(nil)
	local v21 = React.useRef(nil)
	local v22 = React.useRef(Vector2.zero)
	local v23 = React.useRef(false)
	local v24 = React.useMemo(function() -- line: 62
		-- upvalues: v20 (copy), v10 (copy), u11 (ref), v22 (copy), v21 (copy), v23 (copy), v18 (copy), ReactOtter (copy), t1 (copy), v16 (copy)
		return {
			getActiveInput = function() -- line: 63
				-- upvalues: v20 (copy)
				return v20.current
			end,
			setOffset = function(n2: number) -- line: 94
				-- upvalues: v18 (copy), ReactOtter (copy), t1 (copy), v23 (copy), v16 (copy)
				v18(ReactOtter.spring(n2, t1))

				if not v23.current and n2 > v16.swipeCompleteThreshold then
					v23.current = true

					if v16.onSwipeThresholdReached then
						v16.onSwipeThresholdReached()

						return
					end
				elseif v23.current and n2 <= v16.swipeCompleteThreshold then
					v23.current = false
				end
			end,
			isPastCompleteThreshold = function() -- line: 91
				-- upvalues: v23 (copy)
				return v23.current
			end,
			startSwipe = function(p1, p2: ((...any) -> ...any)) -- line: 66
				-- upvalues: v10 (copy), u11 (ref), v20 (copy), v22 (copy), v21 (copy)
				if v10 then
					u11 = p1
				end

				v20.current = p1
				v22.current = Vector2.new(p1.Position.X, p1.Position.Y)
				v21.current = p1.Changed:Connect(function() -- line: 72
					-- upvalues: p2 (copy)
					p2()
				end)
			end,
			resetSwipe = function() -- line: 82
				-- upvalues: v10 (copy), u11 (ref), v20 (copy), v23 (copy), v21 (copy), v18 (copy), ReactOtter (copy), t1 (copy)
				if v10 and u11 == v20.current then
					u11 = nil
				end

				v20.current = nil
				v23.current = false

				if v21.current then
					v21.current:Disconnect()
					v21.current = nil
				end

				v18(ReactOtter.spring(0, t1))
			end,
			disconnectInputListener = function() -- line: 76
				-- upvalues: v21 (copy)
				if v21.current then
					v21.current:Disconnect()
					v21.current = nil
				end
			end
		}
	end, { v18 })
	local v25 = React.useCallback(function() -- line: 116
		-- upvalues: v24 (copy), v16 (copy), v22 (copy), SwipeDirection (copy)
		local v27 = v24.getActiveInput()

		if not v27 then
			return
		end

		if v27.UserInputState == Enum.UserInputState.End or v27.UserInputState == Enum.UserInputState.Cancel then
			if v24.isPastCompleteThreshold() then
				v16.onSwipeComplete()
			end

			v24.resetSwipe()

			return
		end

		local v28 = Vector2.new(v27.Position.X, v27.Position.Y) - v22.current
		local v29 = if v16.direction ~= SwipeDirection.Right then -v28.X else v28.X
		local v30 = math.abs(v28.Y)

		if v29 < v16.swipeStartThreshold or v30 > v16.swipeMaxVerticalDrift then
			v24.setOffset(0)

			return
		end

		local v31 = math.max(0, v29)

		v24.setOffset(v31)
	end, {
		v24,
		v16.swipeCompleteThreshold,
		v16.swipeMaxVerticalDrift,
		v16.direction,
		v18
	})

	React.useEffect(function() -- line: 159
		-- upvalues: v24 (copy)
		return v24.resetSwipe
	end, { v24.resetSwipe })

	local v26 = React.useCallback(function(_, p4) -- line: 163
		-- upvalues: v10 (copy), u11 (ref), v24 (copy), v25 (copy)
		if v10 and u11 ~= nil then
			return
		end

		if v24.getActiveInput() ~= nil then
			return
		end

		if p4.UserInputType == Enum.UserInputType.Touch or p4.UserInputType == Enum.UserInputType.MouseButton1 then
			v24.startSwipe(p4, v25)
		end
	end, {})

	return React.useMemo(function() -- line: 181
		-- upvalues: v17 (copy), v19 (copy), v26 (copy)
		return {
			swipeOffset = v17,
			swipeProgress = v19,
			onInputBegan = v26
		}
	end, {
		v17,
		v19,
		v26
	})
end

return useSwipeGesture
