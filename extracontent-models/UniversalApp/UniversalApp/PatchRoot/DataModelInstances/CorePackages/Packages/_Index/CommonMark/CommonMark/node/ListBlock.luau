local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

return {
	new = function(p: string)
		local v = Node.new(p, true)
		v.tight = false
		return v
	end
}
