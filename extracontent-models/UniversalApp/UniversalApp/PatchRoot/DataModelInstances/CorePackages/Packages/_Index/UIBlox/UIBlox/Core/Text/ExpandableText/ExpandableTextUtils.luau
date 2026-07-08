local GetTextHeight = require(script.Parent.Parent.GetTextHeight)

return {
	getExpandableTextHeights = function(p1, p2, p3, p4) -- line: 4
		-- upvalues: GetTextHeight (copy)
		local v6 = p1.BaseSize * p1.Body.RelativeSize

		return GetTextHeight(p3, p1.Body.Font, v6, p2), p4 * v6
	end,
	getCanExpand = function(p5, p6, p7, p8) -- line: 14
		-- upvalues: GetTextHeight (copy)
		local v11 = p5.BaseSize * p5.Body.RelativeSize

		return GetTextHeight(p7, p5.Body.Font, v11, p6) > p8 * v11
	end
}
