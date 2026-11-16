local Markdown = script:FindFirstAncestor("Markdown")
local NodeType = require(Markdown.Enums.NodeType)
require(Markdown.Types)

local function isNodeBlock(p): boolean
	return p.name ~= "TAG" and (p.type == NodeType.Block or p.type == NodeType.TextBlock)
end

return isNodeBlock
