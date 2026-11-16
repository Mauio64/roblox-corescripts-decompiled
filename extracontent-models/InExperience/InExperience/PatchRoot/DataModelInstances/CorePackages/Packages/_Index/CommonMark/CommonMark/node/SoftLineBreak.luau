local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function SoftLineBreak()
	return Node.new("SoftLineBreak", false)
end

return SoftLineBreak
