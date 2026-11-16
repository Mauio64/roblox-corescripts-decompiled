local parent = script.Parent.Parent
local language = parent.language
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local String = LuauPolyfill.String

local source = require(language.source)
local source2 = source.Source

local isSource = source.isSource
local tokenKind = require(language.tokenKind)
local tokenKind2 = tokenKind.TokenKind
local lexer = require(language.lexer)
local lexer2 = lexer.Lexer
local isPunctuatorTokenKind = lexer.isPunctuatorTokenKind
local blockString = require(language.blockString)
local dedentBlockStringValue = blockString.dedentBlockStringValue
local getBlockStringIndentation = blockString.getBlockStringIndentation

local dedentBlockString

local function stripIgnoredCharacters(p)
	if not isSource(p) then
		p = source2.new(p)
	end

	local body = p.body
	local v = lexer2.new(p)
	local v2 = ""
	local v3 = false

	while v:advance().kind ~= tokenKind2.EOF do
		local token = v.token
		local kind = token.kind

		local v4 = not isPunctuatorTokenKind(token.kind)

		if v3 and (v4 or token.kind == tokenKind2.SPREAD) then
			v2 ..= " "
		end

		local slice = String.slice(body, token.start, token._end)

		if kind == tokenKind2.BLOCK_STRING then
			v2 ..= dedentBlockString(slice)
		else
			v2 ..= slice
		end

		v3 = v4
	end

	return v2
end

dedentBlockString = function(slice: string)
	local v = dedentBlockStringValue((String.slice(slice, 4, -3)))

	if getBlockStringIndentation(v) > 0 then
		v = "\n" .. v
	end

	local v2 = utf8.len(v)
	assert(v2 ~= nil, "invalid utf8 detected: " .. v)
	local slice2 = String.slice(v, v2)
	local v3

	if slice2 == "\"" then
		v3 = String.slice(v, -4) ~= "\\\"\"\""
	else
		v3 = false
	end

	if v3 or slice2 == "\\" then
		v ..= "\n"
	end

	return "\"\"\"" .. v .. "\"\"\""
end

return { stripIgnoredCharacters = stripIgnoredCharacters }
