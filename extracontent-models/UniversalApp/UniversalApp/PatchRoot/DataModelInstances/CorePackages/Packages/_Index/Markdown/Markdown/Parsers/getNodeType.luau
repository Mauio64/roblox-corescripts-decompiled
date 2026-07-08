local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local NodeType = require(Markdown.Enums.NodeType)

local function getNodeType(s1: string, p1) -- line: 8
	-- upvalues: NodeType (copy)
	local v6 = p1.nodeConfiguration[s1]

	if v6 then
		return v6.type
	end

	warn(`No node configuration found for { s1 }`)

	return NodeType.Block
end

return getNodeType
