local CommonMark = script:FindFirstAncestor("CommonMark")
local DocumentParser = require(CommonMark.internal.DocumentParser)
require(CommonMark.Extension)
require(CommonMark.parser.IncludeSourceSpans)
local Parser = require(CommonMark.parser.Parser)

local ApiOptions = {}

function ApiOptions.inCanonicalOrder(list)
	local v = {}

	for _, item in ipairs(list) do
		v[item] = true
	end

	local result = {}

	for _, v2 in ipairs(DocumentParser.getDefaultBlockParserTypes()) do
		if not v[v2] then
			continue
		end

		table.insert(result, v2)
		v[v2] = nil
	end

	for _, item in ipairs(list) do
		if not v[item] then
			continue
		end

		table.insert(result, item)
		v[item] = nil
	end

	return result
end

local function buildParser(data)
	local builder = Parser.builder()

	if data.extensions ~= nil then
		builder:extensions(data.extensions)
	end

	if data.enabledBlockTypes ~= nil then
		builder:enabledBlockTypes(ApiOptions.inCanonicalOrder(data.enabledBlockTypes))
	end

	if data.enabledInlineTypes ~= nil then
		builder:enabledInlineTypes(data.enabledInlineTypes)
	end

	if data.linkReferenceDefinitions ~= nil then
		builder:linkReferenceDefinitions(data.linkReferenceDefinitions)
	end

	if data.includeSourceSpans ~= nil then
		builder:includeSourceSpans(data.includeSourceSpans)
	end

	if data.maxOpenBlockParsers ~= nil then
		builder:maxOpenBlockParsers(data.maxOpenBlockParsers)
	end

	if data.maxInlineNesting ~= nil then
		builder:maxInlineNesting(data.maxInlineNesting)
	end

	return builder:build()
end

local function buildHtmlRenderer(data)
	local HtmlRenderer = require(CommonMark.renderer.html.HtmlRenderer)
	local builder = HtmlRenderer.builder()

	if data.extensions ~= nil then
		builder:extensions(data.extensions)
	end

	if data.softbreak ~= nil then
		builder:softbreak(data.softbreak)
	end

	if data.escapeHtml ~= nil then
		builder:escapeHtml(data.escapeHtml)
	end

	if data.sanitizeUrls ~= nil then
		builder:sanitizeUrls(data.sanitizeUrls)
	end

	if data.percentEncodeUrls ~= nil then
		builder:percentEncodeUrls(data.percentEncodeUrls)
	end

	return builder:build()
end

local frozen = table.freeze({ __mode = "k" })
local frozen2 = table.freeze({})

local object = setmetatable({}, frozen)
local object2 = setmetatable({}, frozen)

function ApiOptions.getParser(p)
	if p == nil then
		p = frozen2
	end

	local parser = object[p]

	if parser == nil then
		parser = buildParser(p)
		object[p] = parser
	end

	return parser
end

function ApiOptions.getHtmlRenderer(p)
	if p == nil then
		p = frozen2
	end

	local htmlRenderer = object2[p]

	if htmlRenderer == nil then
		htmlRenderer = buildHtmlRenderer(p)
		object2[p] = htmlRenderer
	end

	return htmlRenderer
end

return ApiOptions
