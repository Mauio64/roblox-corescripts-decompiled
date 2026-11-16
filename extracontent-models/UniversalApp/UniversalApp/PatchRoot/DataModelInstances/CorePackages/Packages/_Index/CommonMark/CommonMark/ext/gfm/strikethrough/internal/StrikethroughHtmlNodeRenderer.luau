local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.renderer.html.HtmlNodeRendererContext)
require(CommonMark.renderer.html.HtmlWriter)
local LinkedHashMap = require(CommonMark.internal.port.LinkedHashMap)
require(CommonMark.node.Node)
local StrikethroughNodeRenderer = require(CommonMark.ext.gfm.strikethrough.internal.StrikethroughNodeRenderer)

local object = setmetatable({}, { __index = StrikethroughNodeRenderer })
object.__index = object

function object.new(object2)
	return (setmetatable({ _context = object2, _html = object2:getWriter() }, object))
end

function object:render(p)
	local extendAttributes = self._context:extendAttributes(p, "del", LinkedHashMap.of())
	self._html:tag("del", extendAttributes)
	self:renderChildren(p)
	self._html:tag("/del")
end

function object:renderChildren(object2)
	local v = object2:getFirstChild()

	while v ~= nil do
		local nextNode = v:getNext()
		self._context:render(v)
		v = nextNode
	end
end

return object
