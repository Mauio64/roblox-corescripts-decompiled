local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local LuauPolyfill = require(scriptParentParentParent.LuauPolyfill)
local Number = LuauPolyfill.Number
local String = LuauPolyfill.String
local isNaN = Number.isNaN
local HttpService = game:GetService("HttpService")
local syntaxError = require(scriptParentParent.error.syntaxError).syntaxError

require(script.Parent.source)

local tokenKind = require(scriptParent.tokenKind)
local Token = require(scriptParent.ast).Token
local TokenKind = tokenKind.TokenKind
local toUnicodeString = require(scriptParentParent.luaUtils.toUnicodeString)
local dedentBlockStringValue = require(scriptParent.blockString).dedentBlockStringValue
local readBlockString = nil
local readString = nil
local char2hex = nil

local function uniCharCode(p1, p2, p3, p4) -- line: 88
	-- upvalues: char2hex (ref)
	local v27 = char2hex(p1)
	local v28 = char2hex(p2)
	local v29 = char2hex(p3)
	local v30 = char2hex(p4)

	if v27 < 0 or (v28 < 0 or v29 < 0 or v30 < 0) then
		return -1
	end

	return (bit32.bor(bit32.lshift(v27, 12), bit32.lshift(v28, 8), bit32.lshift(v29, 4), v30))
end

function char2hex(p5) -- line: 108
	if p5 >= 48 and p5 <= 57 then
		return p5 - 48
	end

	if p5 >= 65 and p5 <= 70 then
		return p5 - 55
	end

	if p5 >= 97 and p5 <= 102 then
		return p5 - 87
	end

	return -1
end

local function readName(p6, n1: number, n2: number, n3: number, p7) -- line: 126
	-- upvalues: String (copy), isNaN (copy), Token (copy), TokenKind (copy)
	local body = p6.body
	local v38 = string.len(body)
	local u39 = n1 + 1
	local n4 = 0

	while u39 ~= v38 + 1 do
		n4 = String.charCodeAt(body, u39)

		if not not isNaN(n4) or not (n4 == 95 or (n4 >= 48 and n4 <= 57 or (n4 >= 65 and n4 <= 90 or n4 >= 97 and n4 <= 122))) then
			break
		end

		u39 += 1
	end

	return Token.new(TokenKind.NAME, n1, u39, n2, n3, p7, String.slice(body, n1, u39))
end
local function readComment(p8, n5: number, n6: number, n7: number, p9) -- line: 179
	-- upvalues: String (copy), isNaN (copy), Token (copy), TokenKind (copy)
	local body = p8.body
	local v47 = n5

	repeat
		v47 += 1

		local v48 = String.charCodeAt(body, v47)
	until isNaN(v48) or not (v48 > 31) and v48 ~= 9

	return Token.new(TokenKind.COMMENT, n5, v47, n6, n7, p9, String.slice(body, n5 + 1, v47))
end

function printCharCode(n8: number) -- line: 201
	-- upvalues: isNaN (copy), TokenKind (copy), HttpService (copy), toUnicodeString (copy)
	if isNaN(n8) then
		return TokenKind.EOF
	end

	if n8 < 127 then
		return HttpService:JSONEncode((string.char(n8)))
	end

	return toUnicodeString(n8)
end
function readDigits(p10, n9: number, n10: number) -- line: 220
	-- upvalues: String (copy), syntaxError (copy)
	local body = p10.body

	if n10 >= 48 and n10 <= 57 then
		repeat
			n9 += 1

			local v54 = String.charCodeAt(body, n9)
		until not (v54 >= 48) or not (v54 <= 57)

		return n9
	end

	error(syntaxError(p10, n9, "Invalid number, expected digit but got: " .. printCharCode(n10) .. "."))
end
function unexpectedCharacterMessage(n11: number) -- line: 245
	if n11 < 32 and (n11 ~= 9 and n11 ~= 10 and n11 ~= 13) then
		return "Cannot contain the invalid character " .. printCharCode(n11) .. "."
	end

	if n11 == 39 then
		return "Unexpected single quote character ('), did you mean to use a double quote (\")?"
	end

	return "Cannot parse the unexpected character " .. printCharCode(n11) .. "."
end
function isNameStart(n12: number) -- line: 259
	local v57 = n12 == 95
	local v58 = n12 >= 65 and n12 <= 90
	local v59 = n12 >= 97 and n12 <= 122

	return v57 or (v58 or v59)
end
function readNumber(p11, n13: number, n14: number, n15: number, n16: number, p12) -- line: 274
	-- upvalues: String (copy), syntaxError (copy), Token (copy), TokenKind (copy)
	local body = p11.body
	local v67 = n13
	local v68 = false

	if n14 == 45 then
		v67 += 1
		n14 = String.charCodeAt(body, v67)
	end

	local v69, v70

	if n14 == 48 then
		v69 = v67 + 1
		v70 = String.charCodeAt(body, v69)

		if v70 >= 48 and v70 <= 57 then
			error(syntaxError(p11, v69, "Invalid number, unexpected digit after 0: " .. printCharCode(v70) .. "."))
		end
	else
		v69 = readDigits(p11, v67, n14)
		v70 = String.charCodeAt(body, v69)
	end

	if v70 == 46 then
		v68 = true

		local v71 = v69 + 1
		local v72 = String.charCodeAt(body, v71)

		v69 = readDigits(p11, v71, v72)
		v70 = String.charCodeAt(body, v69)
	end

	if v70 == 69 or v70 == 101 then
		v68 = true

		local v73 = v69 + 1
		local v74 = String.charCodeAt(body, v73)

		if v74 == 43 or v74 == 45 then
			v73 += 1
			v74 = String.charCodeAt(body, v73)
		end

		v69 = readDigits(p11, v73, v74)
		v70 = String.charCodeAt(body, v69)
	end

	if v70 == 46 or isNameStart(v70) then
		error(syntaxError(p11, v69, "Invalid number, expected digit but got: " .. printCharCode(v70) .. "."))
	end

	return Token.new(v68 and TokenKind.FLOAT or TokenKind.INT, n13, v69, n15, n16, p12, String.slice(body, n13, v69))
end

local function readToken(t1: {[any]: any}, p13) -- line: 359
	-- upvalues: String (copy), Token (copy), TokenKind (copy), readComment (copy), readBlockString (ref), readString (ref), readName (copy), syntaxError (copy)
	local source = t1.source
	local body = source.body
	local v79 = utf8.len(body)

	assert(v79 ~= nil, "invalid utf8 supplied for token")

	local _end = p13._end

	while _end <= v79 do
		local v81 = String.charCodeAt(body, _end)
		local line = t1.line
		local v83 = _end - t1.lineStart

		if v81 == 65279 or v81 == 9 or v81 == 32 or v81 == 44 then
			_end += 1

			continue
		end

		if v81 == 10 then
			_end += 1
			t1.line = t1.line + 1
			t1.lineStart = _end - 1

			continue
		end

		if v81 == 13 then
			_end = if String.charCodeAt(body, _end + 1) ~= 10 then _end + 1 else _end + 2
			t1.line = t1.line + 1
			t1.lineStart = _end - 1

			continue
		end

		if v81 == 33 then
			return Token.new(TokenKind.BANG, _end, _end + 1, line, v83, p13)
		end

		if v81 == 35 then
			return readComment(source, _end, line, v83, p13)
		end

		if v81 == 36 then
			return Token.new(TokenKind.DOLLAR, _end, _end + 1, line, v83, p13)
		end

		if v81 == 38 then
			return Token.new(TokenKind.AMP, _end, _end + 1, line, v83, p13)
		end

		if v81 == 40 then
			return Token.new(TokenKind.PAREN_L, _end, _end + 1, line, v83, p13)
		end

		if v81 == 41 then
			return Token.new(TokenKind.PAREN_R, _end, _end + 1, line, v83, p13)
		end

		if v81 == 46 then
			if String.charCodeAt(body, _end + 1) == 46 and String.charCodeAt(body, _end + 2) == 46 then
				return Token.new(TokenKind.SPREAD, _end, _end + 3, line, v83, p13)
			end
		else
			if v81 == 58 then
				return Token.new(TokenKind.COLON, _end, _end + 1, line, v83, p13)
			end

			if v81 == 61 then
				return Token.new(TokenKind.EQUALS, _end, _end + 1, line, v83, p13)
			end

			if v81 == 64 then
				return Token.new(TokenKind.AT, _end, _end + 1, line, v83, p13)
			end

			if v81 == 91 then
				return Token.new(TokenKind.BRACKET_L, _end, _end + 1, line, v83, p13)
			end

			if v81 == 93 then
				return Token.new(TokenKind.BRACKET_R, _end, _end + 1, line, v83, p13)
			end

			if v81 == 123 then
				return Token.new(TokenKind.BRACE_L, _end, _end + 1, line, v83, p13)
			end

			if v81 == 124 then
				return Token.new(TokenKind.PIPE, _end, _end + 1, line, v83, p13)
			end

			if v81 == 125 then
				return Token.new(TokenKind.BRACE_R, _end, _end + 1, line, v83, p13)
			end

			if v81 == 34 then
				if String.charCodeAt(body, _end + 1) == 34 and String.charCodeAt(body, _end + 2) == 34 then
					return readBlockString(source, _end, line, v83, p13, t1)
				end

				return readString(source, _end, line, v83, p13)
			end

			if v81 == 45 or v81 == 48 or v81 == 49 or v81 == 50 or v81 == 51 or v81 == 52 or v81 == 53 or v81 == 54 or v81 == 55 or v81 == 56 or v81 == 57 then
				return readNumber(source, _end, v81, line, v83, p13)
			end

			if v81 == 65 or v81 == 66 or v81 == 67 or v81 == 68 or v81 == 69 or v81 == 70 or v81 == 71 or v81 == 72 or v81 == 73 or v81 == 74 or v81 == 75 or v81 == 76 or v81 == 77 or v81 == 78 or v81 == 79 or v81 == 80 or v81 == 81 or v81 == 82 or v81 == 83 or v81 == 84 or v81 == 85 or v81 == 86 or v81 == 87 or v81 == 88 or v81 == 89 or v81 == 90 or v81 == 95 or v81 == 97 or v81 == 98 or v81 == 99 or v81 == 100 or v81 == 101 or v81 == 102 or v81 == 103 or v81 == 104 or v81 == 105 or v81 == 106 or v81 == 107 or v81 == 108 or v81 == 109 or v81 == 110 or v81 == 111 or v81 == 112 or v81 == 113 or v81 == 114 or v81 == 115 or v81 == 116 or v81 == 117 or v81 == 118 or v81 == 119 or v81 == 120 or v81 == 121 or v81 == 122 then
				return readName(source, _end, line, v83, p13)
			end
		end

		error(syntaxError(source, _end, unexpectedCharacterMessage(v81)))
	end

	local line = t1.line
	local v85 = _end - t1.lineStart

	return Token.new(TokenKind.EOF, v79 + 1, v79 + 1, line, v85, p13)
end

local t2 = {}

t2.__index = t2

function t2.new(p14) -- line: 558
	-- upvalues: Token (copy), TokenKind (copy), t2 (copy)
	local v87 = Token.new(TokenKind.SOF, 1, 1, 0, 0, nil)

	return (setmetatable({
		source = p14,
		lastToken = v87,
		token = v87,
		line = 1,
		lineStart = 0
	}, t2))
end
function t2.advance(p15) -- line: 571
	p15.lastToken = p15.token
	p15.token = p15:lookahead()

	return p15.token
end
function t2.lookahead(p16) -- line: 577
	-- upvalues: TokenKind (copy), readToken (copy)
	local token = p16.token

	if token.kind ~= TokenKind.EOF then
		repeat
			if token.next then
				token = token.next
			else
				local v91 = readToken(p16, token)

				token.next = v91
				v91.prev = token
				token = v91
			end
		until token.kind ~= TokenKind.COMMENT
	end

	return token
end
function readBlockString(p17, p18, p19, p20, p21, p22) -- line: 623
	-- upvalues: isNaN (copy), String (copy), Token (copy), TokenKind (copy), dedentBlockStringValue (copy), syntaxError (copy)
	local body = p17.body
	local v100 = p18 + 3
	local v101 = v100
	local s1 = ""

	while v100 <= string.len(body) and not isNaN(String.charCodeAt(body, v100)) do
		local v103 = String.charCodeAt(body, v100)

		if v103 == 34 and String.charCodeAt(body, v100 + 1) == 34 and String.charCodeAt(body, v100 + 2) == 34 then
			local v104 = s1 .. String.slice(body, v101, v100)

			return Token.new(TokenKind.BLOCK_STRING, p18, v100 + 3, p19, p20, p21, dedentBlockStringValue(v104))
		end

		if v103 < 32 and v103 ~= 9 and v103 ~= 10 and v103 ~= 13 then
			error(syntaxError(p17, v100, "Invalid character within String: " .. printCharCode(v103) .. "."))
		end

		if v103 == 10 then
			v100 += 1
			p22.line = p22.line + 1
			p22.lineStart = v100 - 1
		elseif v103 == 13 then
			v100 = if String.charCodeAt(body, v100 + 1) ~= 10 then v100 + 1 else v100 + 2
			p22.line = p22.line + 1
			p22.lineStart = v100 - 1
		elseif v103 == 92 and String.charCodeAt(body, v100 + 1) == 34 and String.charCodeAt(body, v100 + 2) == 34 and String.charCodeAt(body, v100 + 3) == 34 then
			s1 ..= String.slice(body, v101, v100) .. "\"\"\""
			v100 += 4
			v101 = v100
		else
			v100 += 1
		end
	end

	error(syntaxError(p17, v100, "Unterminated string."))
end
function readString(p23, p24, p25, p26, p27) -- line: 697
	-- upvalues: String (copy), isNaN (copy), Token (copy), TokenKind (copy), syntaxError (copy), uniCharCode (ref)
	local body = p23.body
	local v111 = utf8.len(body)

	assert(v111 ~= nil, "invalid utf8 sequence detected")

	local v112 = p24 + 1
	local v113 = v112
	local s2 = ""

	while v112 <= v111 do
		local v115 = String.charCodeAt(body, v112)

		if isNaN(v115) then
			break
		end

		if v115 == 34 then
			local v116 = s2 .. String.slice(body, v113, v112)

			return Token.new(TokenKind.STRING, p24, v112 + 1, p25, p26, p27, v116)
		end

		if v115 == 10 or v115 == 13 then
			break
		end

		if v115 < 32 and v115 ~= 9 then
			error(syntaxError(p23, v112, "Invalid character within String: " .. printCharCode(v115) .. "."))
		end

		v112 += 1

		if v115 == 92 then
			s2 ..= String.slice(body, v113, v112 - 1)

			local v117 = String.charCodeAt(body, v112)

			if v117 == 34 then
				s2 ..= "\""
			elseif v117 == 47 then
				s2 ..= "/"
			elseif v117 == 92 then
				s2 ..= "\\"
			elseif v117 == 98 then
				s2 ..= "\b"
			elseif v117 == 102 then
				s2 ..= "\f"
			elseif v117 == 110 then
				s2 ..= "\n"
			elseif v117 == 114 then
				s2 ..= "\r"
			elseif v117 == 116 then
				s2 ..= "\t"
			elseif v117 == 117 then
				local v118 = uniCharCode(String.charCodeAt(body, v112 + 1), String.charCodeAt(body, v112 + 2), String.charCodeAt(body, v112 + 3), String.charCodeAt(body, v112 + 4))

				if v118 < 0 then
					local v119 = String.slice(body, v112 + 1, v112 + 5)

					error(syntaxError(p23, v112, "Invalid character escape sequence: \\u" .. v119 .. "."))
				end

				s2 ..= utf8.char(v118)
				v112 += 4
			else
				error(syntaxError(p23, v112, "Invalid character escape sequence: \\" .. utf8.char(v117) .. "."))
			end

			v112 += 1
			v113 = v112
		end
	end

	error(syntaxError(p23, v112, "Unterminated string."))
end

return {
	Lexer = t2,
	isPunctuatorTokenKind = function(p28) -- line: 600
		-- upvalues: TokenKind (copy)
		return p28 == TokenKind.BANG or (p28 == TokenKind.DOLLAR or (p28 == TokenKind.AMP or (p28 == TokenKind.PAREN_L or (p28 == TokenKind.PAREN_R or (p28 == TokenKind.SPREAD or (p28 == TokenKind.COLON or (p28 == TokenKind.EQUALS or (p28 == TokenKind.AT or (p28 == TokenKind.BRACKET_L or (p28 == TokenKind.BRACKET_R or (p28 == TokenKind.BRACE_L or (p28 == TokenKind.PIPE or p28 == TokenKind.BRACE_R))))))))))))
	end
}
