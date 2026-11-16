local parent = script:FindFirstAncestor("Utils").Parent

require(parent.Types)

local NodeTypeConfig = require(script.Parent.NodeTypeConfig)

local function getNodeTypeConfig(data)
	local v = NodeTypeConfig[data.type]

	if v then
		return v
	end

	warn(`No node type config found for node: {data.name} {data.text} of type: {data.type}`)
	return nil
end

return getNodeTypeConfig
