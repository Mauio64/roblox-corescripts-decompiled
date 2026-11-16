local function getWidth(p: number) -- 1 equivalent call inferred from this helper
	return p * (188 / 285)
end

return {
	getSize = function(vector2: Vector2, flag: boolean)
		local v = math.min(math.round(vector2.Y * 0.7), 285)
		local width = getWidth(v) -- inferred equivalent call

		if not flag then
			v *= 26 / 57
		end

		return Vector2.new(width, v)
	end
}
