local Markdown = script:FindFirstAncestor("Markdown")
local Constants = require(Markdown.Parsers.Constants)

require(Markdown.Types)

local t1 = {
	BOLD = {
		char = "*",
		length = 1
	},
	BOLD_2 = {
		char = "*",
		length = 2
	},
	ITALIC = {
		char = "_",
		length = 1
	},
	ITALIC_2 = {
		char = "_",
		length = 2
	},
	STRIKE = {
		char = "~",
		length = 1
	},
	INLINE_CODE = {
		char = "`",
		length = 1
	}
}
local t2 = {
	getDelimiterInfo = function(s1: string) -- line: 63
		-- upvalues: t1 (copy)
		return t1[s1]
	end,
	causesLineBreak = function(p1) -- line: 67
		return p1.name ~= "TEXT" or string.find(p1.text, "\n", 0, true) ~= nil
	end,
	getTokenNameFromCharAndLength = function(p2, n1: number) -- line: 71
		if p2 == "`" then
			return "INLINE_CODE"
		end

		if n1 == 2 then
			if p2 == "*" then
				return "BOLD_2"
			end

			return "ITALIC_2"
		end

		if p2 == "*" then
			return "BOLD"
		end

		if p2 == "~" then
			return "STRIKE"
		end

		return "ITALIC"
	end,
	canDelimitersMatch = function(p3, p4) -- line: 81
		if p3.runLength == 0 or p4.runLength == 0 then
			return false
		end

		if (not p3.canOpen or not p3.canClose) and (not p4.canOpen or not p4.canClose) then
			return true
		end

		if p3.runLength % 3 == 0 and p4.runLength % 3 == 0 then
			return true
		end

		if (p3.runLength + p4.runLength) % 3 == 0 then
			return false
		end

		return true
	end,
	addDelimiterMatch = function(p5, p6) -- line: 108
		local v13 = p5.matches or {}

		p5.matches = v13

		local n2 = 1
		local v15 = #v13
		local v16 = v15 + 1
		local startIdx = p6.with.startIdx

		while n2 <= v15 do
			local v18 = math.floor((n2 + v15) / 2)

			if startIdx < v13[v18].with.startIdx then
				v16 = v18
				v15 = v18 - 1
			else
				n2 = v18 + 1
			end
		end

		table.insert(v13, v16, p6)
	end,
	isWhitespace = function(s2: string?) -- line: 134
		-- upvalues: Constants (copy)
		if not s2 or #s2 == 0 then
			return true
		end

		if s2:match(Constants.ASCII.WHITESPACE_PATTERN) ~= nil then
			return true
		end

		if Constants.UNICODE.WHITESPACE[utf8.codepoint(s2)] then
			return true
		end

		return false
	end,
	isPunctuation = function(s3: string?) -- line: 156
		-- upvalues: Constants (copy)
		if not s3 or #s3 == 0 then
			return false
		end

		if s3:match(Constants.ASCII.PUNCTUATION_PATTERN) then
			return true
		end

		local v21 = utf8.codepoint(s3)

		if Constants.UNICODE.PUNCTUATION[v21] then
			return true
		end

		return false
	end
}

function t2.isLeftFlanking(s4: string?, s5: string?) -- line: 177
	-- upvalues: t2 (copy)
	if t2.isWhitespace(s5) then
		return false
	end

	if not t2.isPunctuation(s5) then
		return true
	end

	return t2.isWhitespace(s4) or t2.isPunctuation(s4)
end
function t2.isRightFlanking(s6: string?, s7: string?) -- line: 199
	-- upvalues: t2 (copy)
	if t2.isWhitespace(s6) then
		return false
	end

	if not t2.isPunctuation(s6) then
		return true
	end

	return t2.isWhitespace(s7) or t2.isPunctuation(s7)
end
function t2.canOpenEmphasis(p7) -- line: 221
	-- upvalues: t2 (copy)
	if p7.char == "`" then
		return true
	end

	if not t2.isLeftFlanking(p7.prevChar, p7.nextChar) then
		return false
	end

	if p7.char ~= "_" then
		return true
	end

	return not t2.isRightFlanking(p7.prevChar, p7.nextChar) or t2.isPunctuation(p7.prevChar)
end
function t2.canCloseEmphasis(p8) -- line: 246
	-- upvalues: t2 (copy)
	if p8.char == "`" then
		return true
	end

	if not t2.isRightFlanking(p8.prevChar, p8.nextChar) then
		return false
	end

	if p8.char ~= "_" then
		return true
	end

	return not t2.isLeftFlanking(p8.prevChar, p8.nextChar) or t2.isPunctuation(p8.nextChar)
end
function t2.getCharacterContext(s8: string, n3: number, n4: number) -- line: 269
	if #s8 == 0 then
		return {}
	end

	local v31 = nil
	local v32 = nil

	if n3 > 1 then
		local v33 = utf8.offset(s8, -1, n3)

		if v33 then
			v31 = utf8.char(utf8.codepoint(s8, v33))
		end
	end

	local v34 = n3 + n4

	if v34 <= #s8 then
		local v35 = utf8.offset(s8, 1, v34)

		if v35 then
			v32 = utf8.char(utf8.codepoint(s8, v35))
		end
	end

	return {
		prevChar = v31,
		nextChar = v32
	}
end
function t2.isInsideInlineCode(t3: {[any]: any}, n5: number, n6: number?) -- line: 303
	local t4 = {}
	local t5 = nil

	for i = n6 or #t3, 1, -1 do
		local v42 = t3[i]

		if n5 >= v42.offset then
			break
		end

		if v42.name == "INLINE_CODE" then
			if t5 and t5.offset - 1 == v42.offset then
				t5.length = t5.length + 1
				t5.offset = t5.offset - 1
			else
				t5 = {
					offset = v42.offset,
					length = #v42.text
				}
				table.insert(t4, 1, t5)
			end
		end
	end

	local n7 = 1

	while n7 <= #t4 do
		local length = t4[n7].length
		local v45 = nil

		for i = n7 + 1, #t4 do
			if length == t4[i].length then
				v45 = i

				break
			end
		end

		if not v45 then
			return true
		end

		n7 = v45 + 1
	end

	return false
end

return t2
