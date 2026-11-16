local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractVisitor = require(CommonMark.node.AbstractVisitor)
require(CommonMark.renderer.html.HtmlNodeRendererContext)
require(CommonMark.renderer.html.HtmlWriter)
local LinkedHashMap = require(CommonMark.internal.port.LinkedHashMap)
require(CommonMark.node.Nodes)

local find = string.find
local sub = string.sub

local object = setmetatable({}, { __index = AbstractVisitor })
object.__index = object

function object.new()
	return (setmetatable({ _sb = {}, _n = 0 }, object))
end

function object:getAltText()
	return table.concat(self._sb)
end

local function orNull(literal: string?) -- 2 equivalent calls inferred from this helper
	return if literal == nil then "null" else literal
end

function object:visitText(p)
	self._n += 1
	local sb = self._sb
	local _n = self._n
	sb[_n] = orNull(p.literal) -- inferred equivalent call
end

function object:visitCode(p)
	self._n += 1
	local sb = self._sb
	local _n = self._n
	sb[_n] = orNull(p.literal) -- inferred equivalent call
end

function object:visitSoftLineBreak(_)
	self._n += 1
	self._sb[self._n] = "\n"
end

function object:visitHardLineBreak(_)
	self._n += 1
	self._sb[self._n] = "\n"
end

local object2 = setmetatable({}, { __index = AbstractVisitor })
object2.__index = object2

function object2.new(object3)
	return (setmetatable({ context = object3, _html = object3:getWriter() }, object2))
end

local frozen = table.freeze({
	"Document",
	"Heading",
	"Paragraph",
	"BlockQuote",
	"BulletList",
	"FencedCodeBlock",
	"HtmlBlock",
	"ThematicBreak",
	"IndentedCodeBlock",
	"Link",
	"ListItem",
	"OrderedList",
	"Image",
	"Emphasis",
	"StrongEmphasis",
	"Text",
	"Code",
	"HtmlInline",
	"SoftLineBreak",
	"HardLineBreak"
})

function object2.getNodeTypes(_)
	return frozen
end

function object2:render(object3)
	object3:accept(self)
end

function object2:visitDocument(p)
	self:visitChildren(p)
end

function object2:visitHeading(p)
	local formatted = `h{p.level}`
	self._html:line()
	self._html:tag(formatted, self:getAttrs(p, formatted))
	self:visitChildren(p)
	self._html:tag("/" .. formatted)
	self._html:line()
end

function object2:visitParagraph(object3)
	local parent = object3:getParent()
	local v = self:isInTightList(object3)

	if not v then
		v = self.context:shouldOmitSingleParagraphP()

		if v then
			if parent == nil or parent.kind ~= "Document" or object3:getPrevious() ~= nil then
				v = false
			else
				v = object3:getNext() == nil
			end
		end
	end

	if not v then
		self._html:line()
		self._html:tag("p", self:getAttrs(object3, "p"))
	end

	self:visitChildren(object3)

	if not v then
		self._html:tag("/p")
		self._html:line()
	end
end

function object2:visitBlockQuote(p)
	self._html:line()
	self._html:tag("blockquote", self:getAttrs(p, "blockquote"))
	self._html:line()
	self:visitChildren(p)
	self._html:line()
	self._html:tag("/blockquote")
	self._html:line()
end

function object2:visitBulletList(p)
	self:renderListBlock(p, "ul", self:getAttrs(p, "ul"))
end

function object2:visitFencedCodeBlock(p)
	local literal = p.literal
	local v = LinkedHashMap.new()
	local info = p.info

	if info ~= nil and info ~= "" then
		local v2 = (find(info, " ", 1, true) or 0) - 1

		if v2 ~= -1 then
			info = sub(info, 1, v2)
		end

		v:put("class", "language-" .. info)
	end

	self:renderCodeBlock(literal, p, v)
end

function object2:visitHtmlBlock(p)
	self._html:line()

	if self.context:shouldEscapeHtml() then
		self._html:tag("p", self:getAttrs(p, "p"))
		self._html:text(p.literal)
		self._html:tag("/p")
	else
		self._html:raw(p.literal)
	end

	self._html:line()
end

function object2:visitThematicBreak(p)
	self._html:line()
	self._html:tag("hr", self:getAttrs(p, "hr"), true)
	self._html:line()
end

function object2:visitIndentedCodeBlock(p)
	self:renderCodeBlock(p.literal, p, LinkedHashMap.of())
end

function object2:visitLink(p)
	local v = LinkedHashMap.new()
	local destination = p.destination

	if self.context:shouldSanitizeUrls() then
		destination = self.context:urlSanitizer():sanitizeLinkUrl(destination)
		v:put("rel", "nofollow")
	end

	v:put("href", (self.context:encodeUrl(destination)))

	if p.title ~= nil then
		v:put("title", p.title)
	end

	self._html:tag("a", self:getAttrs(p, "a", v))
	self:visitChildren(p)
	self._html:tag("/a")
end

function object2:visitListItem(p)
	self._html:tag("li", self:getAttrs(p, "li"))
	self:visitChildren(p)
	self._html:tag("/li")
	self._html:line()
end

function object2:visitOrderedList(p)
	local v = p.markerStartNumber == nil and 1 or p.markerStartNumber
	local v2 = LinkedHashMap.new()

	if v ~= 1 then
		v2:put("start", (tostring(v)))
	end

	self:renderListBlock(p, "ol", self:getAttrs(p, "ol", v2))
end

function object2:visitImage(object3)
	local destination = object3.destination

	local v = object.new()
	object3:accept(v)
	local altText = v:getAltText()

	local v2 = LinkedHashMap.new()

	if self.context:shouldSanitizeUrls() then
		destination = self.context:urlSanitizer():sanitizeImageUrl(destination)
	end

	v2:put("src", self.context:encodeUrl(destination))
	v2:put("alt", altText)

	if object3.title ~= nil then
		v2:put("title", object3.title)
	end

	self._html:tag("img", self:getAttrs(object3, "img", v2), true)
end

function object2:visitEmphasis(p)
	self._html:tag("em", self:getAttrs(p, "em"))
	self:visitChildren(p)
	self._html:tag("/em")
end

function object2:visitStrongEmphasis(p)
	self._html:tag("strong", self:getAttrs(p, "strong"))
	self:visitChildren(p)
	self._html:tag("/strong")
end

function object2:visitText(p)
	self._html:text(p.literal)
end

function object2:visitCode(p)
	self._html:tag("code", self:getAttrs(p, "code"))
	self._html:text(p.literal)
	self._html:tag("/code")
end

function object2:visitHtmlInline(p)
	if self.context:shouldEscapeHtml() then
		self._html:text(p.literal)
	else
		self._html:raw(p.literal)
	end
end

function object2:visitSoftLineBreak(_)
	self._html:raw(self.context:getSoftbreak())
end

function object2:visitHardLineBreak(p)
	self._html:tag("br", self:getAttrs(p, "br"), true)
	self._html:line()
end

function object2:visitChildren(object3)
	local v = object3:getFirstChild()

	while v ~= nil do
		local nextNode = v:getNext()
		self.context:render(v)
		v = nextNode
	end
end

function object2:renderCodeBlock(p: string, p2, p3)
	self._html:line()
	self._html:tag("pre", self:getAttrs(p2, "pre"))
	self._html:tag("code", self:getAttrs(p2, "code", p3))
	self._html:text(p)
	self._html:tag("/code")
	self._html:tag("/pre")
	self._html:line()
end

function object2:renderListBlock(p, p2: string, p3)
	self._html:line()
	self._html:tag(p2, p3)
	self._html:line()
	self:visitChildren(p)
	self._html:line()
	self._html:tag("/" .. p2)
	self._html:line()
end

function object2:isInTightList(object3)
	local parent = object3:getParent()

	if parent ~= nil then
		local parent2 = parent:getParent()

		if parent2 ~= nil and (parent2.kind == "BulletList" or parent2.kind == "OrderedList") then
			return parent2.tight
		end
	end

	return false
end

function object2:getAttrs(p, p2: string, p3)
	local context = self.context

	if p3 == nil then
		p3 = LinkedHashMap.of()
	end

	return context:extendAttributes(p, p2, p3)
end

return object2
