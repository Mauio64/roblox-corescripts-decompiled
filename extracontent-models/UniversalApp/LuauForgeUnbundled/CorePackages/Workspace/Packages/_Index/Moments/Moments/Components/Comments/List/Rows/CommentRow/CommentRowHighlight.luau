local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local CommentLongPressTiming = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentLongPressTiming")

local useTokens = Foundation.Hooks.useTokens

local v5 = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local v6 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function CommentRowHighlight(p2)
	local v7 = useTokens()
	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		if p2.phase == "Charging" then
			local thread = task.delay(CommentLongPressTiming.CHARGE_DELAY_SECONDS, function()
				v9(ReactOtter.ease(1, {
					duration = CommentLongPressTiming.HOLD_SECONDS - CommentLongPressTiming.CHARGE_DELAY_SECONDS,
					easingStyle = Enum.EasingStyle.Sine
				}))
			end)
			return function()
				task.cancel(thread)
			end
		end

		local ease = ReactOtter.ease
		local v11 = p2.phase == "Active" and 1 or 0
		local v12 = if p2.phase == "Active" then v5 else v6
		v9(ease(v11, v12))

		return nil
	end, { p2.phase })

	local shift_200 = v7.Color.Shift.Shift_200
	local mapped = v8:map(function(p3)
		return {
			Color3 = shift_200.Color3,
			Transparency = math.lerp(1, shift_200.Transparency, p3)
		}
	end)

	return React.createElement(Foundation.View, {
		tag = {
			["size-full radius-medium"] = true,
			["shadow-raised-100"] = p2.phase == "Active"
		},
		backgroundStyle = mapped,
		ZIndex = 0,
		testId = `moments-comment-highlight-{p2.commentId}`
	})
end

return React.memo(CommentRowHighlight)
