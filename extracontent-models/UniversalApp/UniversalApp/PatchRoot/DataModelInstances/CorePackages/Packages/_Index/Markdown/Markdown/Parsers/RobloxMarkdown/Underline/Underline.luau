local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)

local function Underline(p: string)
	local underline = CommonMark.Node.CustomNode.new("Underline")
	underline.openingDelimiter = p
	underline.closingDelimiter = p
	return underline
end

return Underline
