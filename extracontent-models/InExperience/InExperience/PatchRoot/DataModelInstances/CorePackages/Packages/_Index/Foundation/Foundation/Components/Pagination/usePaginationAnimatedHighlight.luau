local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

require(Foundation.Enums.PaginationSize)

local useTokens = require(Foundation.Providers.Style.useTokens)

local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local instance = Wrappers.Instance
local Signal = Wrappers.Signal

require(script.Parent.paginationSlotsUtils)

local function usePaginationAnimatedHighlight(current: string?, p, p2, p3, p4)
	local time_100 = useTokens().Time.Time_100

	local highlightPosition, v = ReactOtter.useAnimatedBinding(0)

	local highlightWidth, v2 = ReactOtter.useAnimatedBinding(0)

	local activeItemHeight, v3 = React.useBinding(0)
	local isVisible, v4 = React.useBinding(false)

	local ref = React.useRef(current)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local function resetTransitionState(flag: boolean)
		if ref4.current then
			task.cancel(ref4.current)
			ref4.current = nil
		end

		ref2.current = false

		if flag then
			ref3.current = false
		end
	end

	local v5 = React.useCallback(function()
		if ref4.current then
			task.cancel(ref4.current)
		end

		ref2.current = true
		ref4.current = task.delay(time_100, function()
			ref4.current = nil
			ref2.current = false

			if ref3.current then
				ref3.current = false
				local current2 = ref5.current

				if current2 then
					current2()
				end
			end
		end)
	end, { time_100 })

	local updateHighlight = React.useCallback(function(p5, flag: boolean?): boolean
		if not (p5.current and p.current) then
			v4(false)
			return false
		end

		local v6 = p5.current.AbsolutePosition.X - p.current.AbsolutePosition.X
		local x = p5.current.AbsoluteSize.X
		local y = p5.current.AbsoluteSize.Y

		if x <= 0 or y <= 0 then
			v4(false)
			return false
		end

		if flag and ref2.current then
			ref3.current = true
			return false
		end

		if flag then
			v2(ReactOtter.instant(x))
			v(ReactOtter.instant(v6))
		else
			ref3.current = false
			v5()
			local v7 = { easingStyle = Enum.EasingStyle.Linear, duration = time_100 }

			v(ReactOtter.ease(v6, v7))
			v2(ReactOtter.ease(x, v7))
		end

		v3(y)
		v4(true)
		return true
	end, { time_100, p, v5 })

	local current2 = React.useCallback(function()
		local v6 = current and p2[current]

		if v6 then
			updateHighlight(v6, true)
		end
	end, { current, p2, updateHighlight })

	React.useLayoutEffect(function()
		if current then
			local v6 = p2[current]
			local v7 = current == ref.current

			if not v7 then
				if ref4.current then
					task.cancel(ref4.current)
					ref4.current = nil
				end

				ref2.current = false

				ref3.current = false
			end

			if v6 and v6.current and p.current then
				updateHighlight(v6, v7)
			else
				v4(false)
			end

			ref.current = current
		else
			v4(false)
			ref.current = nil
		end
	end, { current, p2, updateHighlight, p3, p4 })

	React.useEffect(function()
		if current then
			local v6 = p2[current]

			if v6 and v6.current and p.current then
				local v7 = Signal.Connect(instance.GetPropertyChangedSignal(v6.current, "AbsoluteSize"), current2)

				local v8 = Signal.Connect(instance.GetPropertyChangedSignal(v6.current, "AbsolutePosition"), current2)

				local v9 = Signal.Connect(instance.GetPropertyChangedSignal(p.current, "AbsoluteSize"), current2)

				local v10 = Signal.Connect(instance.GetPropertyChangedSignal(p.current, "AbsolutePosition"), current2)

				return function()
					Connection.Disconnect(v7)
					Connection.Disconnect(v8)
					Connection.Disconnect(v9)
					Connection.Disconnect(v10)
				end
			end
		end

		return function() end
	end, { current, p2, current2 })

	React.useEffect(function()
		ref5.current = current2
	end, { current2 })

	React.useEffect(function()
		return function()
			if ref4.current then
				task.cancel(ref4.current)
				ref4.current = nil
			end
		end
	end, {})

	return {
		activeItemHeight = activeItemHeight,
		highlightPosition = highlightPosition,
		highlightWidth = highlightWidth,
		isVisible = isVisible,
		updateHighlight = updateHighlight
	}
end

return usePaginationAnimatedHighlight
