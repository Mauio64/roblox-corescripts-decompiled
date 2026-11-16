local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
require(script.Parent.Mention)

local LinkedHashMap = CommonMark.Renderer.Html.LinkedHashMap

local MentionHtmlNodeRenderer = {}
MentionHtmlNodeRenderer.__index = MentionHtmlNodeRenderer

function MentionHtmlNodeRenderer.new(context)
	return (setmetatable({ _context = context, _html = context:getWriter() }, MentionHtmlNodeRenderer))
end

function MentionHtmlNodeRenderer.getNodeTypes(_)
	return { "Mention" }
end

function MentionHtmlNodeRenderer:render(p)
	local v = LinkedHashMap.new()
	v:put("id", p.id)

	if p.name ~= nil then
		v:put("name", p.name)
	end

	self._html:tag("mention", self._context:extendAttributes(p, "mention", v))
	self._html:tag("/mention")
end

return MentionHtmlNodeRenderer
