local function getWidth(n1: number) -- line: 6
	return n1 * 0.6596491228070176
end

return {
	getSize = function(vector2: Vector2, b1: boolean) -- line: 10
		local v5 = math.min(math.round(vector2.Y * 0.7), 285)
		local v6 = v5 * 0.6596491228070176

		if not b1 then
			v5 *= 0.45614035087719296
		end

		return Vector2.new(v6, v5)
	end
}
