local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Document()
	return Node.new("Document", true)
end

return Document
