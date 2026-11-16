local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function BlockQuote()
	return Node.new("BlockQuote", true)
end

return BlockQuote
