local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local NodeType = require(Markdown.Enums.NodeType)

local function getNodeType(p: string, p2)
	local v = p2.nodeConfiguration[p]

	if v then
		return v.type
	end

	warn(`No node configuration found for {p}`)
	return NodeType.Block
end

return getNodeType
