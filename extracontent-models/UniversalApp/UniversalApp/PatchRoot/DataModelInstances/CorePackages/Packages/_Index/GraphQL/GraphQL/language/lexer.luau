local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Number = LuauPolyfill.Number
local String = LuauPolyfill.String
local isNaN = Number.isNaN
local HttpService = game:GetService("HttpService")

local syntaxError = require(parent2.error.syntaxError)
local syntaxError2 = syntaxError.syntaxError
require(script.Parent.source)

local tokenKind = require(parent.tokenKind)

local ast = require(parent.ast)
local token = ast.Token
local tokenKind2 = tokenKind.TokenKind

local toUnicodeString = require(parent2.luaUtils.toUnicodeString)
local blockString = require(parent.blockString)
local dedentBlockStringValue = blockString.dedentBlockStringValue

local readBlockString
local readString

local char2hex

local function uniCharCode(p, p2, p3, p4)
	local v = char2hex(p)
	local v2 = char2hex(p2)
	local v3 = char2hex(p3)
	local v4 = char2hex(p4)

	if v < 0 or v2 < 0 or v3 < 0 or v4 < 0 then
		return -1
	end

	return (bit32.bor(bit32.lshift(v, 12), bit32.lshift(v2, 8), bit32.lshift(v3, 4), v4))
end

char2hex = function(p)
	if p >= 48 and p <= 57 then
		return p - 48
	end

	if p >= 65 and p <= 70 then
		return p - 55
	end

	if p >= 97 and p <= 102 then
		return p - 87
	end

	return -1
end

local function readName(source, p: number, line: number, p2: number, p3)
	local body = source.body
	local v = string.len(body)
	local v2 = p + 1
	local v3 = 0

	local function fn(): boolean -- 1 equivalent call inferred from this helper
		return v2 ~= v + 1
	end

	while fn() do -- inferred equivalent call
		v3 = String.charCodeAt(body, v2)

		if isNaN(v3) then
			break
		end

		local v4 = v3 == 95

		if not v4 then
			if v3 >= 48 then
				v4 = v3 <= 57
			else
				v4 = false
			end

			if not v4 then
				if v3 >= 65 then
					v4 = v3 <= 90
				else
					v4 = false
				end

				if not v4 then
					if v3 >= 97 then
						v4 = v3 <= 122
					else
						v4 = false
					end
				end
			end
		end

		if not v4 then
			break
		end

		v2 += 1
	end

	local new = token.new
	local name = tokenKind2.NAME

	local v4 = v2
	return new(name, p, v4, line, p2, p3, String.slice(body, p, v2))
end

local function readComment(source, p: number, line: number, p2: number, p3)
	local body = source.body
	local v = p

	repeat
		v += 1
		local charCodeAt = String.charCodeAt(body, v)
	until isNaN(charCodeAt) or not (charCodeAt > 31) and charCodeAt ~= 9

	return token.new(tokenKind2.COMMENT, p, v, line, p2, p3, String.slice(body, p + 1, v))
end

function printCharCode(p: number)
	if isNaN(p) then
		return tokenKind2.EOF
	end

	if p < 127 then
		return HttpService:JSONEncode((string.char(p)))
	end

	return toUnicodeString(p)
end

function readDigits(p, count: number, p2: number)
	local body = p.body

	if not (p2 >= 48 and p2 <= 57) then
		error(syntaxError2(p, count, "Invalid number, expected digit but got: " .. printCharCode(p2) .. "."))

		return
	end

	repeat
		count += 1
		local charCodeAt = String.charCodeAt(body, count)
	until not (charCodeAt >= 48 and charCodeAt <= 57)

	return count
end

function unexpectedCharacterMessage(p: number)
	if p < 32 and p ~= 9 and p ~= 10 and p ~= 13 then
		return "Cannot contain the invalid character " .. printCharCode(p) .. "."
	end

	if p == 39 then
		return "Unexpected single quote character ('), did you mean to use a double quote (\")?"
	end

	return "Cannot parse the unexpected character " .. printCharCode(p) .. "."
end

function isNameStart(p: number)
	local v = p == 95
	local v2

	if p >= 65 then
		v2 = p <= 90
	else
		v2 = false
	end

	local v3 = p >= 97 and p <= 122
	return v or v2 or v3
end

function readNumber(p, p2: number, p3: number, p4: number, p5: number, p6)
	local body = p.body

	local v = false
	local v2

	if p3 == 45 then
		v2 = p2 + 1
		p3 = String.charCodeAt(body, v2)
	else
		v2 = p2
	end

	local v3

	if p3 == 48 then
		v2 += 1
		v3 = String.charCodeAt(body, v2)

		if v3 >= 48 and v3 <= 57 then
			error(syntaxError2(p, v2, "Invalid number, unexpected digit after 0: " .. printCharCode(v3) .. "."))
		end
	else
		v2 = readDigits(p, v2, p3)
		v3 = String.charCodeAt(body, v2)
	end

	if v3 == 46 then
		local v4 = v2 + 1
		local charCodeAt = String.charCodeAt(body, v4)
		v2 = readDigits(p, v4, charCodeAt)

		v3 = String.charCodeAt(body, v2)
		v = true
	end

	if v3 == 69 or v3 == 101 then
		v = true

		local v4 = v2 + 1
		local v5 = String.charCodeAt(body, v4)

		if v5 == 43 or v5 == 45 then
			v4 += 1
			v5 = String.charCodeAt(body, v4)
		end

		v2 = readDigits(p, v4, v5)
		v3 = String.charCodeAt(body, v2)
	end

	if v3 == 46 or isNameStart(v3) then
		error(syntaxError2(p, v2, "Invalid number, expected digit but got: " .. printCharCode(v3) .. "."))
	end

	return token.new(v and tokenKind2.FLOAT or tokenKind2.INT, p2, v2, p4, p5, p6, String.slice(body, p2, v2))
end

local function readToken(state, result)
	local source = state.source
	local body = source.body
	local v = utf8.len(body)

	assert(v ~= nil, "invalid utf8 supplied for token")

	local v2 = result._end

	while v2 <= v do
		local charCodeAt = String.charCodeAt(body, v2)

		local line = state.line
		local v3 = v2 - state.lineStart

		if charCodeAt == 65279 or charCodeAt == 9 or charCodeAt == 32 or charCodeAt == 44 then
			v2 += 1
		elseif charCodeAt == 10 then
			v2 += 1
			state.line += 1
			state.lineStart = v2 - 1
		elseif charCodeAt == 13 then
			if String.charCodeAt(body, v2 + 1) == 10 then
				v2 += 2
			else
				v2 += 1
			end

			state.line += 1
			state.lineStart = v2 - 1
		else
			if charCodeAt == 33 then
				return token.new(tokenKind2.BANG, v2, v2 + 1, line, v3, result)
			elseif charCodeAt == 35 then
				return readComment(source, v2, line, v3, result)
			elseif charCodeAt == 36 then
				return token.new(tokenKind2.DOLLAR, v2, v2 + 1, line, v3, result)
			elseif charCodeAt == 38 then
				return token.new(tokenKind2.AMP, v2, v2 + 1, line, v3, result)
			elseif charCodeAt == 40 then
				return token.new(tokenKind2.PAREN_L, v2, v2 + 1, line, v3, result)
			elseif charCodeAt == 41 then
				return token.new(tokenKind2.PAREN_R, v2, v2 + 1, line, v3, result)
			end

			if charCodeAt == 46 then
				if String.charCodeAt(body, v2 + 1) == 46 and String.charCodeAt(body, v2 + 2) == 46 then
					return token.new(tokenKind2.SPREAD, v2, v2 + 3, line, v3, result)
				end
			else
				if charCodeAt == 58 then
					return token.new(tokenKind2.COLON, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 61 then
					return token.new(tokenKind2.EQUALS, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 64 then
					return token.new(tokenKind2.AT, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 91 then
					return token.new(tokenKind2.BRACKET_L, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 93 then
					return token.new(tokenKind2.BRACKET_R, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 123 then
					return token.new(tokenKind2.BRACE_L, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 124 then
					return token.new(tokenKind2.PIPE, v2, v2 + 1, line, v3, result)
				elseif charCodeAt == 125 then
					return token.new(tokenKind2.BRACE_R, v2, v2 + 1, line, v3, result)
				end

				if charCodeAt == 34 then
					if String.charCodeAt(body, v2 + 1) == 34 and String.charCodeAt(body, v2 + 2) == 34 then
						return readBlockString(source, v2, line, v3, result, state)
					end

					return readString(source, v2, line, v3, result)
				end

				if
					charCodeAt == 45
					or charCodeAt == 48
					or charCodeAt == 49
					or charCodeAt == 50
					or charCodeAt == 51
					or charCodeAt == 52
					or charCodeAt == 53
					or charCodeAt == 54
					or charCodeAt == 55
					or charCodeAt == 56
					or charCodeAt == 57
				then
					return readNumber(source, v2, charCodeAt, line, v3, result)
				end

				if
					charCodeAt == 65
					or charCodeAt == 66
					or charCodeAt == 67
					or charCodeAt == 68
					or charCodeAt == 69
					or charCodeAt == 70
					or charCodeAt == 71
					or charCodeAt == 72
					or charCodeAt == 73
					or charCodeAt == 74
					or charCodeAt == 75
					or charCodeAt == 76
					or charCodeAt == 77
					or charCodeAt == 78
					or charCodeAt == 79
					or charCodeAt == 80
					or charCodeAt == 81
					or charCodeAt == 82
					or charCodeAt == 83
					or charCodeAt == 84
					or charCodeAt == 85
					or charCodeAt == 86
					or charCodeAt == 87
					or charCodeAt == 88
					or charCodeAt == 89
					or charCodeAt == 90
					or charCodeAt == 95
					or charCodeAt == 97
					or charCodeAt == 98
					or charCodeAt == 99
					or charCodeAt == 100
					or charCodeAt == 101
					or charCodeAt == 102
					or charCodeAt == 103
					or charCodeAt == 104
					or charCodeAt == 105
					or charCodeAt == 106
					or charCodeAt == 107
					or charCodeAt == 108
					or charCodeAt == 109
					or charCodeAt == 110
					or charCodeAt == 111
					or charCodeAt == 112
					or charCodeAt == 113
					or charCodeAt == 114
					or charCodeAt == 115
					or charCodeAt == 116
					or charCodeAt == 117
					or charCodeAt == 118
					or charCodeAt == 119
					or charCodeAt == 120
					or charCodeAt == 121
					or charCodeAt == 122
				then
					return readName(source, v2, line, v3, result)
				end
			end

			error(syntaxError2(source, v2, unexpectedCharacterMessage(charCodeAt)))
		end
	end

	local line = state.line
	local v3 = v2 - state.lineStart
	return token.new(tokenKind2.EOF, v + 1, v + 1, line, v3, result)
end

local class = {}
class.__index = class

function class.new(source)
	local v = token.new(tokenKind2.SOF, 1, 1, 0, 0, nil)

	return (setmetatable({
		["source"] = source,
		lastToken = v,
		token = v,
		line = 1,
		lineStart = 0
	}, class))
end

function class:advance()
	self.lastToken = self.token
	self.token = self:lookahead()
	return self.token
end

function class:lookahead()
	local result = self.token

	if result.kind == tokenKind2.EOF then
		return result
	end

	repeat
		if result.next then
			result = result.next
		else
			local nextNode = readToken(self, result)
			result.next = nextNode
			nextNode.prev = result
			result = nextNode
		end
	until result.kind ~= tokenKind2.COMMENT

	return result
end

readBlockString = function(source, p, line, p2, p3, state)
	local body = source.body
	local v = p + 3
	local v2 = v
	local v3 = ""

	while v <= string.len(body) and not isNaN(String.charCodeAt(body, v)) do
		local charCodeAt = String.charCodeAt(body, v)

		if charCodeAt == 34 and String.charCodeAt(body, v + 1) == 34 and String.charCodeAt(body, v + 2) == 34 then
			local v4 = v3 .. String.slice(body, v2, v)
			return token.new(tokenKind2.BLOCK_STRING, p, v + 3, line, p2, p3, dedentBlockStringValue(v4))
		end

		if charCodeAt < 32 and charCodeAt ~= 9 and charCodeAt ~= 10 and charCodeAt ~= 13 then
			error(syntaxError2(source, v, "Invalid character within String: " .. printCharCode(charCodeAt) .. "."))
		end

		if charCodeAt == 10 then
			v += 1
			state.line += 1
			state.lineStart = v - 1
		elseif charCodeAt == 13 then
			if String.charCodeAt(body, v + 1) == 10 then
				v += 2
			else
				v += 1
			end

			state.line += 1
			state.lineStart = v - 1
		elseif
			charCodeAt == 92
			and String.charCodeAt(body, v + 1) == 34
			and String.charCodeAt(body, v + 2) == 34
			and String.charCodeAt(body, v + 3) == 34
		then
			v3 ..= String.slice(body, v2, v) .. "\"\"\""
			v += 4
			v2 = v
		else
			v += 1
		end
	end

	error(syntaxError2(source, v, "Unterminated string."))
end

readString = function(source, p, line, p2, p3)
	local body = source.body
	local v = utf8.len(body)
	assert(v ~= nil, "invalid utf8 sequence detected")
	local v2 = p + 1
	local v3 = v2
	local v4 = ""

	while v2 <= v do
		local charCodeAt = String.charCodeAt(body, v2)

		if isNaN(charCodeAt) then
			break
		end

		if charCodeAt == 34 then
			local v5 = v4 .. String.slice(body, v3, v2)
			return token.new(tokenKind2.STRING, p, v2 + 1, line, p2, p3, v5)
		end

		if charCodeAt == 10 or charCodeAt == 13 then
			break
		end

		if charCodeAt < 32 and charCodeAt ~= 9 then
			error(syntaxError2(source, v2, "Invalid character within String: " .. printCharCode(charCodeAt) .. "."))
		end

		v2 += 1

		if charCodeAt ~= 92 then
			continue
		end

		v4 ..= String.slice(body, v3, v2 - 1)
		local charCodeAt2 = String.charCodeAt(body, v2)

		if charCodeAt2 == 34 then
			v4 ..= "\""
		elseif charCodeAt2 == 47 then
			v4 ..= "/"
		elseif charCodeAt2 == 92 then
			v4 ..= "\\"
		elseif charCodeAt2 == 98 then
			v4 ..= "\8"
		elseif charCodeAt2 == 102 then
			v4 ..= "\f"
		elseif charCodeAt2 == 110 then
			v4 ..= "\n"
		elseif charCodeAt2 == 114 then
			v4 ..= "\r"
		elseif charCodeAt2 == 116 then
			v4 ..= "\t"
		elseif charCodeAt2 == 117 then
			local v5 = uniCharCode(
				String.charCodeAt(body, v2 + 1),
				String.charCodeAt(body, v2 + 2),
				String.charCodeAt(body, v2 + 3),
				String.charCodeAt(body, v2 + 4)
			)

			if v5 < 0 then
				local slice = String.slice(body, v2 + 1, v2 + 5)
				error(syntaxError2(source, v2, "Invalid character escape sequence: \\u" .. slice .. "."))
			end

			v4 ..= utf8.char(v5)
			v2 += 4
		else
			error(syntaxError2(source, v2, "Invalid character escape sequence: \\" .. utf8.char(charCodeAt2) .. "."))
		end

		v2 += 1
		v3 = v2
	end

	error(syntaxError2(source, v2, "Unterminated string."))
end

return {
	Lexer = class,
	isPunctuatorTokenKind = function(p): boolean
		return p == tokenKind2.BANG
			or p == tokenKind2.DOLLAR
			or p == tokenKind2.AMP
			or p == tokenKind2.PAREN_L
			or p == tokenKind2.PAREN_R
			or p == tokenKind2.SPREAD
			or p == tokenKind2.COLON
			or p == tokenKind2.EQUALS
			or p == tokenKind2.AT
			or p == tokenKind2.BRACKET_L
			or p == tokenKind2.BRACKET_R
			or p == tokenKind2.BRACE_L
			or p == tokenKind2.PIPE
			or p == tokenKind2.BRACE_R
	end
}
