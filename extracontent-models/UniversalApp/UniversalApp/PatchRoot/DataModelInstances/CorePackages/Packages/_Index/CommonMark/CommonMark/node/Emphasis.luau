local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Delimited)
local Node = require(CommonMark.node.Node)

local function Emphasis(p: string?)
	local emphasis = Node.new("Emphasis", false)
	emphasis.openingDelimiter = p
	emphasis.closingDelimiter = p
	return emphasis
end

return Emphasis
