local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local FFlagMomentsCommentRowRedesign = require(Moments.Flags.FFlagMomentsCommentRowRedesign)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local ControlState = Foundation.Enums.ControlState
local useTokens = Foundation.Hooks.useTokens

local v = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local v2 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function isFadingState(current): boolean -- 2 equivalent calls inferred from this helper
	return current == ControlState.Hover or current == ControlState.Pressed
end

local function useCommentBodyPressFeedback(p: string, current: boolean)
	local v3 = useTokens()
	local v4, v5 = ReactOtter.useAnimatedBinding(0)
	local ref = React.useRef(ControlState.Default)
	local ref2 = React.useRef(current)

	React.useLayoutEffect(function()
		ref2.current = current

		local v6 = current and isFadingState(ref.current) -- inferred equivalent call
		v5((ReactOtter.instant(v6 and 1 or 0)))
	end, { p, current })

	local onStateChanged = React.useCallback(function(current2)
		ref.current = current2

		if ref2.current then
			local fadingState = isFadingState(current2) -- inferred equivalent call
			local ease = ReactOtter.ease
			local v6 = if fadingState then v else v2
			v5(ease(fadingState and 1 or 0, v6))
		end
	end, { v5 })
	local v6

	if FFlagMomentsCommentRowRedesign then
		v6 = v3.Color.Content.Default
	else
		v6 = v3.Color.Content.Emphasis
	end

	return {
		onStateChanged = onStateChanged,
		textStyle = React.useMemo(function()
			return v4:map(function(p2: number)
				return getColorStyleWithTransparency(v6, p2 * 0.4)
			end)
		end, { v4, v6 })
	}
end

return useCommentBodyPressFeedback
