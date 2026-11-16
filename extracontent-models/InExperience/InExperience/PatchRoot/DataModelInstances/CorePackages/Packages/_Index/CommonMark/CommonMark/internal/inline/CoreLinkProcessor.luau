local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.InlineParserContext)
require(CommonMark.parser.beta.LinkInfo)
require(CommonMark.parser.beta.LinkProcessor)
local LinkResult = require(CommonMark.parser.beta.LinkResult)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.beta.Scanner)

local CoreLinkProcessor = {}
CoreLinkProcessor.__index = CoreLinkProcessor

function CoreLinkProcessor.new(flag: boolean?, flag2: boolean?)
	return (setmetatable({
		_linkEnabled = flag ~= false,
		_imageEnabled = flag2 ~= false
	}, CoreLinkProcessor))
end

local function process(p, object, object2, p2: string?, p3: string?)
	local marker = object:marker()

	if marker ~= nil and marker.literal == "!" and p._imageEnabled then
		return LinkResult.wrapTextIn(Nodes.Image(p2, p3), object2:position()):includeMarker()
	end

	if p._linkEnabled then
		return LinkResult.wrapTextIn(Nodes.Link(p2, p3), object2:position())
	end

	return LinkResult.none()
end

function CoreLinkProcessor.process(p, object, p2, object2)
	if object:destination() ~= nil then
		return process(p, object, p2, object:destination(), object:title())
	end

	local v = object:label()

	if v == nil or v == "" then
		v = object:text()
	end

	local definition = object2:getDefinition("LinkReferenceDefinition", v)

	if definition == nil then
		return LinkResult.none()
	end

	return process(p, object, p2, definition.destination, definition.title)
end

return CoreLinkProcessor
