local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function ThematicBreak()
	local thematicBreak = Node.new("ThematicBreak", true)
	thematicBreak.literal = nil
	return thematicBreak
end

return ThematicBreak
