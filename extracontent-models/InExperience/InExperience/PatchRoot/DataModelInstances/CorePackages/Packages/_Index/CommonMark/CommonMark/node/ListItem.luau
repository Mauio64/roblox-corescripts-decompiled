local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function ListItem()
	local listItem = Node.new("ListItem", true)
	listItem.markerIndent = nil
	listItem.contentIndent = nil
	return listItem
end

return ListItem
