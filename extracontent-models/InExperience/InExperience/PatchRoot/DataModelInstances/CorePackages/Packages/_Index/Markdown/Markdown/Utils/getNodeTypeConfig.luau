local Parent = script:FindFirstAncestor("Utils").Parent

require(Parent.Types)

local NodeTypeConfig = require(script.Parent.NodeTypeConfig)

local function getNodeTypeConfig(p1) -- line: 7
	-- upvalues: NodeTypeConfig (copy)
	local v5 = NodeTypeConfig[p1.type]

	if not v5 then
		warn(`No node type config found for node: { p1.name } { p1.text } of type: { p1.type }`)

		return nil
	end

	return v5
end

return getNodeTypeConfig
