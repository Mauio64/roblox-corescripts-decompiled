local Foundation = script:FindFirstAncestor("Foundation")
local PaginationSize = require(Foundation.Enums.PaginationSize)

require(Foundation.Providers.Style.Tokens)

local t1 = {
	[PaginationSize.Small] = "row align-x-center align-y-center radius-circle size-600-600",
	[PaginationSize.Medium] = "row align-x-center align-y-center radius-circle size-800-800"
}
local t2 = {
	[PaginationSize.Small] = "text-label-small",
	[PaginationSize.Medium] = "text-label-medium"
}

return {
	getCircularSlotTag = function(p1) -- line: 21
		-- upvalues: t1 (copy)
		return t1[p1]
	end,
	getPageLabelTag = function(p2) -- line: 25
		-- upvalues: t2 (copy)
		return `auto-xy { t2[p2] } content-default text-align-x-center text-align-y-center`
	end,
	getPageLabelTextTag = function(p3) -- line: 29
		-- upvalues: t2 (copy)
		return `auto-xy { t2[p3] } text-align-x-center text-align-y-center`
	end,
	getSlotCursor = function(p4) -- line: 37
		local v10 = math.floor(p4.Stroke.Thicker)

		return {
			radius = UDim.new(0, p4.Radius.Circle),
			offset = p4.Size.Size_150,
			borderWidth = v10
		}
	end,
	needsWidePageSlot = function(n1: number) -- line: 33
		return n1 > 999
	end
}
