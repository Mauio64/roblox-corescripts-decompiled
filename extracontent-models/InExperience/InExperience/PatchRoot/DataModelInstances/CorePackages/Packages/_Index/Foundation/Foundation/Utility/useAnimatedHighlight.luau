local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local Flags = require(Foundation.Utility.Flags)
local useTokens = require(Foundation.Providers.Style.useTokens)

local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local instance = Wrappers.Instance
local Signal = Wrappers.Signal

local function useAnimatedHighlight(current, p, p2, ...)
	local v = useTokens()
	local v2 = React.useMemo(function()
		return { easingStyle = v.Ease.StandardOut, duration = v.Time.Time_200 }
	end, { v })

	local ref = React.useRef(current)
	local ref2

	if Flags.FoundationAnimatedHighlightSettling then
		ref2 = React.useRef(current)
	else
		ref2 = nil
	end

	local v3

	if Flags.FoundationAnimatedHighlightSettling then
		v3 = React.useCallback(function()
			ref2.current = ref.current
		end, {})
	end

	local useAnimatedBinding = ReactOtter.useAnimatedBinding

	if not Flags.FoundationAnimatedHighlightSettling then
		v3 = nil
	end

	local highlightPosition, v4 = useAnimatedBinding(0, v3)
	local highlightWidth, v5 = ReactOtter.useAnimatedBinding(0)
	local activeItemHeight, v6 = React.useBinding(0)

	local v7 = React.useCallback(function(p3, flag: boolean?)
		if p3.current and p.current then
			local v7 = p3.current.AbsolutePosition.X - p.current.AbsolutePosition.X
			local x = p3.current.AbsoluteSize.X

			if Flags.FoundationAnimatedHighlightSettling then
				flag = current == ref2.current
			end

			if flag then
				v5((ReactOtter.instant(x)))
				v4((ReactOtter.instant(v7)))
			else
				v4(ReactOtter.ease(v7, v2))
				v5(ReactOtter.ease(x, v2))
			end

			v6(p3.current.AbsoluteSize.Y)
		end
	end, { v2, current })

	React.useEffect(function()
		if current then
			local v8 = p2[current]
			local v9 = current == ref.current
			local function animateHighlight()
				if v8 then
					v7(v8, v9)
				end
			end

			if v8 and v8.current and p.current then
				local v10 = Signal.Connect(
					instance.GetPropertyChangedSignal(v8.current, "AbsoluteSize"),
					animateHighlight
				)

				local v11 = Signal.Connect(
					instance.GetPropertyChangedSignal(v8.current, "AbsolutePosition"),
					animateHighlight
				)

				local v12 = Signal.Connect(
					instance.GetPropertyChangedSignal(p.current, "AbsoluteSize"),
					animateHighlight
				)

				return function()
					Connection.Disconnect(v10)
					Connection.Disconnect(v11)
					Connection.Disconnect(v12)
				end
			end
		end

		return function() end
	end, { current })

	React.useEffect(function()
		if current then
			local v8 = p2[current]

			if v8 and v8.current and p.current then
				v7(v8, current == ref.current)
			end

			ref.current = current
		end
	end, { current, ... })

	return {
		activeItemHeight = activeItemHeight,
		highlightPosition = highlightPosition,
		highlightWidth = highlightWidth
	}
end

return useAnimatedHighlight
