return {
	isCardVisibleInScrollViewport = function(data, data2): boolean
		local absoluteWindowSize = data.AbsoluteWindowSize
		local absoluteSize = data2.AbsoluteSize

		if
			not data.Visible
			or not data2.Visible
			or absoluteWindowSize.X <= 0
			or absoluteWindowSize.Y <= 0
		then
			return false
		end

		if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
			return false
		end

		local absolutePosition = data.AbsolutePosition
		local v5 = absolutePosition + absoluteWindowSize
		local absolutePosition2 = data2.AbsolutePosition
		local v6 = absolutePosition2 + absoluteSize
		return v6.X > absolutePosition.X
			and absolutePosition2.X < v5.X
			and v6.Y > absolutePosition.Y
			and absolutePosition2.Y < v5.Y
	end
}
