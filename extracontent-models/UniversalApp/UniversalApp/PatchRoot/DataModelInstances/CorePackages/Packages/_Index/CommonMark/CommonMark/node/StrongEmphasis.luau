local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Delimited)
local Node = require(CommonMark.node.Node)

local function StrongEmphasis(p: string?)
	local strongEmphasis = Node.new("StrongEmphasis", false)
	strongEmphasis.openingDelimiter = p
	strongEmphasis.closingDelimiter = p
	return strongEmphasis
end

return StrongEmphasis
