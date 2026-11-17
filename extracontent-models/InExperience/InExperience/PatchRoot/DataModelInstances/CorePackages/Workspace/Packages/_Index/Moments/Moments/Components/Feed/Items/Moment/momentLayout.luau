local parent = script:FindFirstAncestor("Moments").Parent

require(parent.Foundation)

return {
	BOTTOM_UI_MAX_SIZE = Vector2.new(600, 1e999),
	AVATAR_SIZE = 30,
	USERNAME_SHIMMER = Vector2.new(160, 16),
	getInfoBottomGap = function(p, p2: number, p3: number)
		if p2 > 0 then
			return p.Padding.Medium
		end

		return (math.max(p.Padding.XLarge, p3))
	end
}
