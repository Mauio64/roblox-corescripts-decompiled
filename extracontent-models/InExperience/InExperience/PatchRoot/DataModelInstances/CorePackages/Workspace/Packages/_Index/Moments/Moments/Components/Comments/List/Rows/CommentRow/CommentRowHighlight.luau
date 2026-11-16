local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local CommentLongPressTiming = require(script.Parent.CommentLongPressTiming)

local useTokens = Foundation.Hooks.useTokens

local v = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local v2 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function CommentRowHighlight(p)
	local v3 = useTokens()
	local v4, v5 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function()
		if p.phase == "Charging" then
			local thread = task.delay(CommentLongPressTiming.CHARGE_DELAY_SECONDS, function()
				v5(ReactOtter.ease(1, {
					duration = CommentLongPressTiming.HOLD_SECONDS - CommentLongPressTiming.CHARGE_DELAY_SECONDS,
					easingStyle = Enum.EasingStyle.Sine
				}))
			end)
			return function()
				task.cancel(thread)
			end
		end

		local ease = ReactOtter.ease
		local v6 = p.phase == "Active" and 1 or 0
		local v7 = if p.phase == "Active" then v else v2
		v5(ease(v6, v7))

		return nil
	end, { p.phase })

	local shift_200 = v3.Color.Shift.Shift_200
	local mapped = v4:map(function(p2: number)
		return {
			Color3 = shift_200.Color3,
			Transparency = math.lerp(1, shift_200.Transparency, p2)
		}
	end)

	return React.createElement(Foundation.View, {
		tag = {
			["size-full radius-medium"] = true,
			["shadow-raised-100"] = p.phase == "Active"
		},
		backgroundStyle = mapped,
		ZIndex = 0,
		testId = `moments-comment-highlight-{p.commentId}`
	})
end

return React.memo(CommentRowHighlight)
