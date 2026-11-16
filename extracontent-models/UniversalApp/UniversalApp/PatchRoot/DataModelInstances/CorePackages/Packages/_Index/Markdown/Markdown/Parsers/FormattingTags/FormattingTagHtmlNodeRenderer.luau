local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
require(script.Parent.FormattingTag)

local LinkedHashMap = CommonMark.Renderer.Html.LinkedHashMap

local frozen = table.freeze({ b = "strong", i = "em", u = "u", s = "del" })

local FormattingTagHtmlNodeRenderer = {}
FormattingTagHtmlNodeRenderer.__index = FormattingTagHtmlNodeRenderer

function FormattingTagHtmlNodeRenderer.new(context)
	return (setmetatable({ _context = context, _html = context:getWriter() }, FormattingTagHtmlNodeRenderer))
end

function FormattingTagHtmlNodeRenderer.getNodeTypes(_)
	return { "FormattingTag", "FormattingTagText" }
end

function FormattingTagHtmlNodeRenderer:render(data)
	if data.kind == "FormattingTagText" then
		self._html:text(data.literal)
		return
	end

	local v = frozen[data.tagName]
	local extendAttributes = self._context:extendAttributes(data, v, LinkedHashMap.of())
	self._html:tag(v, extendAttributes)
	self:renderChildren(data)
	self._html:tag("/" .. v)
end

function FormattingTagHtmlNodeRenderer:renderChildren(object)
	local v = object:getFirstChild()

	while v ~= nil do
		local nextNode = v:getNext()
		self._context:render(v)
		v = nextNode
	end
end

return FormattingTagHtmlNodeRenderer
