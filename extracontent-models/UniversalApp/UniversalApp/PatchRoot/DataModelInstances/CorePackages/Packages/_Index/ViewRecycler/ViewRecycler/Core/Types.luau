local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Enums.DataSourceChangeType)
local Types = {}
Types.EMPTY_INDEX_RANGE = table.freeze({ firstIndex = 1, lastIndex = 0 })
Types.INDEX_RANGE_KEYS = table.freeze({ "firstIndex", "lastIndex" })
Types.ITEM_LAYOUT_KEYS = table.freeze({ "startOffset", "length" })

Types.SCROLL_STATE_KEYS = table.freeze({
	"scrollOffset",
	"viewportLength",
	"contentLength",
	"distanceFromEnd",
	"atStart",
	"atEnd"
})

function Types.isIndexRangeEmpty(p): boolean
	return p.lastIndex < p.firstIndex
end

function Types.getIndexRangeLength(p)
	return (math.max(0, p.lastIndex - p.firstIndex + 1))
end

return Types
