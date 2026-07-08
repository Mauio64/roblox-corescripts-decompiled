local Markdown = script:FindFirstAncestor("Markdown")
local NodeType = require(Markdown.Enums.NodeType)

require(Markdown.Types)

local function isNodeBlock(p1) -- line: 5
	-- upvalues: NodeType (copy)
	return p1.name ~= "TAG" and (p1.type == NodeType.Block or p1.type == NodeType.TextBlock)
end

return isNodeBlock
