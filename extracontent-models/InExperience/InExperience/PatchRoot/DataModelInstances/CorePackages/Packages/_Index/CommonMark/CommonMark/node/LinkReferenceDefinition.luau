local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function LinkReferenceDefinition(label: string?, destination: string?, title: string?)
	local linkReferenceDefinition = Node.new("LinkReferenceDefinition", true)
	linkReferenceDefinition.label = label
	linkReferenceDefinition.destination = destination
	linkReferenceDefinition.title = title
	return linkReferenceDefinition
end

return LinkReferenceDefinition
