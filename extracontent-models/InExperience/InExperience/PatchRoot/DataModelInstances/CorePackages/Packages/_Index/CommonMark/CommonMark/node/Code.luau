local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Code(literal: string?)
	local code = Node.new("Code", false)
	code.literal = literal
	return code
end

return Code
