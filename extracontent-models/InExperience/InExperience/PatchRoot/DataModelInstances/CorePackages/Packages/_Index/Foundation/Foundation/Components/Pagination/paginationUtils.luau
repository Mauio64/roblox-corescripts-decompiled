local Foundation = script:FindFirstAncestor("Foundation")

local PaginationSize = require(Foundation.Enums.PaginationSize)

require(Foundation.Providers.Style.Tokens)

local v = {
	[PaginationSize.Small] = "row align-x-center align-y-center radius-circle size-600-600",
	[PaginationSize.Medium] = "row align-x-center align-y-center radius-circle size-800-800"
}

local v2 = {
	[PaginationSize.Small] = "text-label-small",
	[PaginationSize.Medium] = "text-label-medium"
}
local PaginationUtils = {}

function PaginationUtils.getCircularSlotTag(p)
	return v[p]
end

function PaginationUtils.getPageLabelTag(p)
	return `auto-xy {v2[p]} content-default text-align-x-center text-align-y-center`
end

function PaginationUtils.getPageLabelTextTag(p)
	return `auto-xy {v2[p]} text-align-x-center text-align-y-center`
end

function PaginationUtils.getSlotCursor(data)
	local thicker = math.floor(data.Stroke.Thicker)
	return {
		radius = UDim.new(0, data.Radius.Circle),
		offset = data.Size.Size_150,
		borderWidth = thicker
	}
end

function PaginationUtils.needsWidePageSlot(p: number): boolean
	return p > 999
end

return PaginationUtils
