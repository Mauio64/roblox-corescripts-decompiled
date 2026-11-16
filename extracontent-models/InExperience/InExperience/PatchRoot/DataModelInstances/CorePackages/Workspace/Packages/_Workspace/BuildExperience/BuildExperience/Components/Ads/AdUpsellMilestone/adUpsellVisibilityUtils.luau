return {
	isCardVisibleInScrollViewport = function(data, data2): boolean
		local absoluteWindowSize = data.AbsoluteWindowSize
		local absoluteSize = data2.AbsoluteSize

		if not data.Visible or not data2.Visible or absoluteWindowSize.X <= 0 or absoluteWindowSize.Y <= 0 then
			return false
		end

		if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
			return false
		end

		local absolutePosition = data.AbsolutePosition
		local v = absolutePosition + absoluteWindowSize
		local absolutePosition2 = data2.AbsolutePosition
		local v2 = absolutePosition2 + absoluteSize
		return v2.X > absolutePosition.X
			and absolutePosition2.X < v.X
			and v2.Y > absolutePosition.Y
			and absolutePosition2.Y < v.Y
	end
}
