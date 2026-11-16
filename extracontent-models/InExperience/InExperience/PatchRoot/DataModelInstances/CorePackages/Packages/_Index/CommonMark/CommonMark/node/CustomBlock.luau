local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

return {
	new = function(p: string)
		return Node.new(p, true)
	end
}
