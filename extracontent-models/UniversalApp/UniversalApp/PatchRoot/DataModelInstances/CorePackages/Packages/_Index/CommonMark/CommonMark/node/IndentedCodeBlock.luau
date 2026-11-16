local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function IndentedCodeBlock()
	local indentedCodeBlock = Node.new("IndentedCodeBlock", true)
	indentedCodeBlock.literal = nil
	return indentedCodeBlock
end

return IndentedCodeBlock
