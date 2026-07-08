local ParentParent = script.Parent.Parent
local language = ParentParent.language
local ParentParentParent = ParentParent.Parent
local String = require(ParentParentParent.LuauPolyfill).String
local source = require(language.source)
local sourceSource = source.Source
local isSource = source.isSource
local TokenKind = require(language.tokenKind).TokenKind
local lexer = require(language.lexer)
local Lexer = lexer.Lexer
local isPunctuatorTokenKind = lexer.isPunctuatorTokenKind
local blockString = require(language.blockString)
local dedentBlockStringValue = blockString.dedentBlockStringValue
local getBlockStringIndentation = blockString.getBlockStringIndentation

local function dedentBlockString(s1: string) -- line: 118
	-- upvalues: String (copy), dedentBlockStringValue (copy), getBlockStringIndentation (copy)
	local v27 = String.slice(s1, 4, -3)
	local v28 = dedentBlockStringValue(v27)

	if getBlockStringIndentation(v28) > 0 then
		v28 = "\n" .. v28
	end

	local v29 = utf8.len(v28)

	assert(v29 ~= nil, "invalid utf8 detected: " .. v28)

	local v30 = String.slice(v28, v29)

	if v30 == "\"" and String.slice(v28, -4) ~= "\\\"\"\"" or v30 == "\\" then
		v28 ..= "\n"
	end

	return "\"\"\"" .. v28 .. "\"\"\""
end

return {
	stripIgnoredCharacters = function(p1) -- line: 81
		-- upvalues: isSource (copy), sourceSource (copy), Lexer (copy), TokenKind (copy), isPunctuatorTokenKind (copy), String (copy), dedentBlockString (ref)
		local v17 = if not isSource(p1) then sourceSource.new(p1) else p1
		local body = v17.body
		local v19 = Lexer.new(v17)
		local s2 = ""
		local v21 = false

		while v19:advance().kind ~= TokenKind.EOF do
			local token = v19.token
			local kind = token.kind
			local v24 = not isPunctuatorTokenKind(token.kind)

			if v21 and (v24 or token.kind == TokenKind.SPREAD) then
				s2 ..= " "
			end

			local v25 = String.slice(body, token.start, token._end)

			s2 = if kind ~= TokenKind.BLOCK_STRING then s2 .. v25 else s2 .. dedentBlockString(v25)
			v21 = v24
		end

		return s2
	end
}
