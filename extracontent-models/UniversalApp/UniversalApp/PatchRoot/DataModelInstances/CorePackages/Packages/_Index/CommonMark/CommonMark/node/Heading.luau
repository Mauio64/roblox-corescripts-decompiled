local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Heading()
	local heading = Node.new("Heading", true)
	heading.level = 0
	return heading
end

return Heading
