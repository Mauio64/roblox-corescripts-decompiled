local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function HtmlInline()
	local htmlInline = Node.new("HtmlInline", false)
	htmlInline.literal = nil
	return htmlInline
end

return HtmlInline
