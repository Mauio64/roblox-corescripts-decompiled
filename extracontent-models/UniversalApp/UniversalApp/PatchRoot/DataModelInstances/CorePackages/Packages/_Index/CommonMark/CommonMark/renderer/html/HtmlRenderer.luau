local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.renderer.html.AttributeProvider)
require(CommonMark.renderer.html.AttributeProviderContext)
require(CommonMark.renderer.html.AttributeProviderFactory)
local CoreHtmlNodeRenderer = require(CommonMark.renderer.html.CoreHtmlNodeRenderer)
local DefaultUrlSanitizer = require(CommonMark.renderer.html.DefaultUrlSanitizer)
local Escaping = require(CommonMark.internal.util.Escaping)
require(CommonMark.Extension)
require(CommonMark.renderer.html.HtmlNodeRendererContext)
require(CommonMark.renderer.html.HtmlNodeRendererFactory)
local HtmlWriter = require(CommonMark.renderer.html.HtmlWriter)
local LinkedHashMap = require(CommonMark.internal.port.LinkedHashMap)
require(CommonMark.node.Node)
require(CommonMark.renderer.NodeRenderer)
local NodeRendererMap = require(CommonMark.internal.renderer.NodeRendererMap)
require(CommonMark.renderer.html.UrlSanitizer)

local HtmlRenderer = {}
HtmlRenderer.__index = HtmlRenderer

local class = {}
class.__index = class

function class:new(htmlWriter)
	local object = setmetatable(
		{
			_renderer = self,
			_htmlWriter = htmlWriter,
			_attributeProviders = {},
			_nodeRendererMap = NodeRendererMap.new()
		},
		class
	)

	for _, attributeProviderFactory in ipairs(self._attributeProviderFactories) do
		table.insert(object._attributeProviders, attributeProviderFactory:create(object))
	end

	for _, nodeRendererFactory in ipairs(self._nodeRendererFactories) do
		local v = nodeRendererFactory:create(object)
		object._nodeRendererMap:add(v)
	end

	return object
end

function class:shouldEscapeHtml()
	return self._renderer._escapeHtml
end

function class:shouldOmitSingleParagraphP()
	return self._renderer._omitSingleParagraphP
end

function class:shouldSanitizeUrls()
	return self._renderer._sanitizeUrls
end

function class:urlSanitizer()
	return self._renderer._urlSanitizer
end

function class:encodeUrl(p: string)
	if self._renderer._percentEncodeUrls then
		return Escaping.percentEncodeUrl(p)
	end

	return p
end

function class:extendAttributes(p, p2: string, p3)
	local map = LinkedHashMap.newMap(p3)
	self:setCustomAttributes(p, p2, map)
	return map
end

function class:getWriter()
	return self._htmlWriter
end

function class:getSoftbreak()
	return self._renderer._softbreak
end

function class:render(p)
	self._nodeRendererMap:render(p)
end

function class:beforeRoot(p)
	self._nodeRendererMap:beforeRoot(p)
end

function class:afterRoot(p)
	self._nodeRendererMap:afterRoot(p)
end

function class:setCustomAttributes(p, p2: string, p3)
	for _, attributeProvider in ipairs(self._attributeProviders) do
		attributeProvider:setAttributes(p, p2, p3)
	end
end

local v = {
	create = function(self, p)
		return (CoreHtmlNodeRenderer.new(p))
	end
}

function HtmlRenderer:new()
	local clone = table.clone(self._nodeRendererFactories)

	table.insert(clone, v)

	return (setmetatable({
		_softbreak = self._softbreak,
		_escapeHtml = self._escapeHtml,
		_percentEncodeUrls = self._percentEncodeUrls,
		_omitSingleParagraphP = self._omitSingleParagraphP,
		_sanitizeUrls = self._sanitizeUrls,
		_urlSanitizer = self._urlSanitizer,
		_attributeProviderFactories = table.clone(self._attributeProviderFactories),
		_nodeRendererFactories = clone
	}, HtmlRenderer))
end

local class2 = {}
class2.__index = class2

function HtmlRenderer.builder()
	return class2.new()
end

function HtmlRenderer:renderAppendable(p, p2)
	local v2 = class.new(self, HtmlWriter.new(p2))
	v2:beforeRoot(p)
	v2:render(p)
	v2:afterRoot(p)
end

function HtmlRenderer:render(p)
	local v2 = {}
	self:renderAppendable(p, v2)
	return table.concat(v2)
end

function class2.new()
	return (setmetatable({
		_softbreak = "\n",
		_escapeHtml = false,
		_sanitizeUrls = false,
		_urlSanitizer = DefaultUrlSanitizer.new(),
		_percentEncodeUrls = false,
		_omitSingleParagraphP = false,
		_attributeProviderFactories = {},
		_nodeRendererFactories = {}
	}, class2))
end

function class2.build(p)
	return HtmlRenderer.new(p)
end

function class2:softbreak(softbreak: string)
	self._softbreak = softbreak
	return self
end

function class2:escapeHtml(escapeHtml: boolean)
	self._escapeHtml = escapeHtml
	return self
end

function class2:sanitizeUrls(sanitizeUrls: boolean)
	self._sanitizeUrls = sanitizeUrls
	return self
end

function class2:urlSanitizer(urlSanitizer)
	self._urlSanitizer = urlSanitizer
	return self
end

function class2:percentEncodeUrls(percentEncodeUrls: boolean)
	self._percentEncodeUrls = percentEncodeUrls
	return self
end

function class2:omitSingleParagraphP(omitSingleParagraphP: boolean)
	self._omitSingleParagraphP = omitSingleParagraphP
	return self
end

function class2:attributeProviderFactory(p)
	table.insert(self._attributeProviderFactories, p)
	return self
end

function class2:nodeRendererFactory(p)
	table.insert(self._nodeRendererFactories, p)
	return self
end

function class2.extensions(p, list)
	for _, item in ipairs(list) do
		local extendHtmlRenderer = item.extendHtmlRenderer

		if extendHtmlRenderer ~= nil then
			extendHtmlRenderer(p)
		end
	end

	return p
end

HtmlRenderer.Builder = class2

return HtmlRenderer
