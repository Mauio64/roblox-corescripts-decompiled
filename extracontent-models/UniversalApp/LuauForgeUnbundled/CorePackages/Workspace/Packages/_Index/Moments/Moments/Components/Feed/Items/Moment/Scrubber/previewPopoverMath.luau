return {
	getCenterOffsetX = function(data)
		local v5 = data.containerPosition + data.ratio * data.containerWidth

		local v6 = data.insetLeft + data.margin
		local v7 = data.screenWidth - data.insetRight - data.margin
		local v8 = v7 - v6

		if v8 <= 0 or data.popoverWidth <= 0 then
			return v5 - data.containerPosition
		end

		local v9 = v6 + data.popoverWidth / 2
		local v10 = v7 - data.popoverWidth / 2

		return (if v10 < v9 then v6 + v8 / 2 else math.clamp(v5, v9, v10)) - data.containerPosition
	end
}
