local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)

local LinkedHashMap = CommonMark.Renderer.Html.LinkedHashMap

local UnderlineHtmlNodeRenderer = {}
UnderlineHtmlNodeRenderer.__index = UnderlineHtmlNodeRenderer

function UnderlineHtmlNodeRenderer.new(context)
	return (setmetatable({ _context = context, _html = context:getWriter() }, UnderlineHtmlNodeRenderer))
end

function UnderlineHtmlNodeRenderer.getNodeTypes(_)
	return { "Underline" }
end

function UnderlineHtmlNodeRenderer:render(p)
	local extendAttributes = self._context:extendAttributes(p, "u", LinkedHashMap.of())
	self._html:tag("u", extendAttributes)
	self:renderChildren(p)
	self._html:tag("/u")
end

function UnderlineHtmlNodeRenderer:renderChildren(object)
	local v = object:getFirstChild()

	while v ~= nil do
		local nextNode = v:getNext()
		self._context:render(v)
		v = nextNode
	end
end

return UnderlineHtmlNodeRenderer
