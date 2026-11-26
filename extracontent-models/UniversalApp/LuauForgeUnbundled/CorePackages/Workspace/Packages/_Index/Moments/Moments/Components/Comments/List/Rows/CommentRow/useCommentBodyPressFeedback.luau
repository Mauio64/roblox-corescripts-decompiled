local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local FFlagMomentsCommentRowRedesign = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentRowRedesign")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")

local controlState = Foundation.Enums.ControlState
local useTokens = Foundation.Hooks.useTokens

local v5 = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local v6 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function isFadingState(p2): boolean
	return p2 == controlState.Hover or p2 == controlState.Pressed
end

local function useCommentBodyPressFeedback(p2, current)
	local v7 = useTokens()
	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	local ref = React.useRef(controlState.Default)
	local ref2 = React.useRef(current)

	React.useLayoutEffect(function()
		ref2.current = current

		local v10 = current

		if v10 then
			local current2 = ref.current
			v10 = current2 == controlState.Hover or current2 == controlState.Pressed
		end

		v9(ReactOtter.instant(v10 and 1 or 0))
	end, { p2, current })

	local v10 = React.useCallback(function(current2)
		ref.current = current2

		if ref2.current then
			local v11 = current2 == controlState.Hover or current2 == controlState.Pressed

			v9(ReactOtter.ease(v11 and 1 or 0, if v11 then v5 else v6))
		end
	end, { v9 })

	local v11 = if FFlagMomentsCommentRowRedesign then v7.Color.Content.Default else v7.Color.Content.Emphasis
	return {
		onStateChanged = v10,
		textStyle = React.useMemo(function()
			return v8:map(function(p3)
				return getColorStyleWithTransparency(v11, p3 * 0.4)
			end)
		end, { v8, v11 })
	}
end

return useCommentBodyPressFeedback
