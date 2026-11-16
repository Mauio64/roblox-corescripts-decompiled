return {
	getRevealOnlyCanvasY = function(p: number, p2: number, vector2: Vector2, p3: number, p4: number)
		local v = p3 + p4

		if p3 <= p and p + p2 <= v then
			return nil
		end

		local v2 = vector2.Y + (p - p3) - (p4 - p2) / 2
		return if not (math.abs(v2 - vector2.Y) < 1) then v2 else nil
	end
}
