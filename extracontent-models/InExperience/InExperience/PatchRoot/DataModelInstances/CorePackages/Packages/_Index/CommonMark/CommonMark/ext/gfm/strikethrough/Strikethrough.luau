local CommonMark = script:FindFirstAncestor("CommonMark")
local CustomNode = require(CommonMark.node.CustomNode)
require(CommonMark.node.Delimited)

local function Strikethrough(p: string)
	local strikethrough = CustomNode.new("Strikethrough")
	strikethrough.openingDelimiter = p
	strikethrough.closingDelimiter = p
	return strikethrough
end

return Strikethrough
