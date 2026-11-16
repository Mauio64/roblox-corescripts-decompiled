local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Image(destination: string?, title: string?)
	local image = Node.new("Image", false)
	image.destination = destination
	image.title = title
	return image
end

function Node.toStringAttributesByKind.Image(p)
	return "destination=" .. (p.destination == nil and "null" or p.destination) .. ", title=" .. (p.title == nil and "null" or p.title)
end

return Image
