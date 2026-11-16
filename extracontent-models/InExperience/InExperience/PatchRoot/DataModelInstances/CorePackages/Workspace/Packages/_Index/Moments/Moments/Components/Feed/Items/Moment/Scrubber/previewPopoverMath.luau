return {
	getCenterOffsetX = function(data)
		local v = data.containerPosition + data.ratio * data.containerWidth

		local v2 = data.insetLeft + data.margin
		local v3 = data.screenWidth - data.insetRight - data.margin
		local v4 = v3 - v2

		if v4 <= 0 or data.popoverWidth <= 0 then
			return v - data.containerPosition
		end

		local v5 = v2 + data.popoverWidth / 2
		local v6 = v3 - data.popoverWidth / 2
		local v7

		if v6 < v5 then
			v7 = v2 + v4 / 2
		else
			v7 = math.clamp(v, v5, v6)
		end

		return v7 - data.containerPosition
	end
}
