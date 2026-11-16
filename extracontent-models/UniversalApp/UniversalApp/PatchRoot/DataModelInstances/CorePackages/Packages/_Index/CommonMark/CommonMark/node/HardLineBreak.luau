local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function HardLineBreak()
	return Node.new("HardLineBreak", false)
end

return HardLineBreak
