return {
	getCenterOffsetX = function(t1: {[any]: any}) -- line: 42
		local v2 = t1.containerPosition + t1.ratio * t1.containerWidth
		local v3 = t1.insetLeft + t1.margin
		local v4 = t1.screenWidth - t1.insetRight - t1.margin
		local v5 = v4 - v3

		if v5 <= 0 or t1.popoverWidth <= 0 then
			return v2 - t1.containerPosition
		end

		local v6 = v3 + t1.popoverWidth / 2
		local v7 = v4 - t1.popoverWidth / 2

		return ((if not (v7 < v6) then math.clamp(v2, v6, v7) else v3 + v5 / 2)) - t1.containerPosition
	end
}
