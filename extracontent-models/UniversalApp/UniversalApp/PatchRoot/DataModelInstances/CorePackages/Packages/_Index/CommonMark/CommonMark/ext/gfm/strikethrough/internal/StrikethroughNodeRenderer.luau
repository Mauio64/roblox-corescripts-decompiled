local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.renderer.NodeRenderer)

local StrikethroughNodeRenderer = {}
StrikethroughNodeRenderer.__index = StrikethroughNodeRenderer

function StrikethroughNodeRenderer.getNodeTypes(_)
	return { "Strikethrough" }
end

return StrikethroughNodeRenderer
