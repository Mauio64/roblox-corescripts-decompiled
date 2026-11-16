local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Paragraph()
	return Node.new("Paragraph", true)
end

return Paragraph
