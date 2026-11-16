local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function HtmlBlock()
	local htmlBlock = Node.new("HtmlBlock", true)
	htmlBlock.literal = nil
	return htmlBlock
end

return HtmlBlock
