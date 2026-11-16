local CommonMark = script:FindFirstAncestor("CommonMark")
local ListBlock = require(CommonMark.node.ListBlock)

local function OrderedList()
	local orderedList = ListBlock.new("OrderedList")
	orderedList.markerDelimiter = nil
	orderedList.markerStartNumber = nil
	return orderedList
end

return OrderedList
