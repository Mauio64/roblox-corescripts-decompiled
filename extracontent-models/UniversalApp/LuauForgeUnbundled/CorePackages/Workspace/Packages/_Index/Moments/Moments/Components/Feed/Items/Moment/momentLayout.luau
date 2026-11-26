require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")

return {
	BOTTOM_UI_MAX_SIZE = Vector2.new(600, 1e999),
	AVATAR_SIZE = 30,
	USERNAME_SHIMMER = Vector2.new(160, 16),
	getInfoBottomGap = function(p2, p3, p4)
		if p3 > 0 then
			return p2.Padding.Medium
		end

		return (math.max(p2.Padding.XLarge, p4))
	end
}
