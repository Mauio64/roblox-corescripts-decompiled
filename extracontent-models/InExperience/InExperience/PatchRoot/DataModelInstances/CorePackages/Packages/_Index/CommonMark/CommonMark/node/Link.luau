local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Link(destination: string?, title: string?)
	local link = Node.new("Link", false)
	link.destination = destination
	link.title = title
	return link
end

function Node.toStringAttributesByKind.Link(p)
	return "destination=" .. (p.destination == nil and "null" or p.destination) .. ", title=" .. (p.title == nil and "null" or p.title)
end

return Link
