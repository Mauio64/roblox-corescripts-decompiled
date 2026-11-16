local function getBorderlessBubbleChatAnimation(p: number)
	if p < 0.5 then
		local v = math.max(p, 0) / 0.5
		local scale

		if v < 0.6 then
			scale = v * 1.2 / 0.6
		else
			scale = 1.2 - (v - 0.6) * 0.19999999999999996 / 0.4
		end

		return { scale = scale, yOffset = 0, transparency = 0, isComplete = false }
	else
		if p < 2.9 then
			return {
				scale = 1,
				yOffset = math.sin((p - 0.5) * 2 * 3.141592653589793 * 1.25) * -6,
				transparency = 0,
				isComplete = false
			}
		end

		local v = math.min((p - 2.9) / 0.5, 1)
		local transparency = v * v
		return {
			scale = 1,
			yOffset = transparency * -24,
			transparency = transparency,
			isComplete = p >= 3.4
		}
	end
end

return getBorderlessBubbleChatAnimation
