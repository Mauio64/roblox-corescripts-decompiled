local Markdown = script:FindFirstAncestor("Markdown")
local Constants = require(Markdown.Parsers.Constants)
require(Markdown.Types)

local v = {
	BOLD = { char = "*", length = 1 },
	BOLD_2 = { char = "*", length = 2 },
	ITALIC = { char = "_", length = 1 },
	ITALIC_2 = { char = "_", length = 2 },
	STRIKE = { char = "~", length = 1 },
	INLINE_CODE = { char = "`", length = 1 }
}

local Utils = {}

function Utils.getDelimiterInfo(p: string)
	return v[p]
end

function Utils.causesLineBreak(p): boolean
	return p.name ~= "TEXT" or string.find(p.text, "\n", 0, true) ~= nil
end

function Utils.getTokenNameFromCharAndLength(p, p2: number): string
	if p == "`" then
		return "INLINE_CODE"
	elseif p == "~" then
		return "STRIKE"
	end

	if p2 == 2 then
		return if p == "*" then "BOLD_2" else "ITALIC_2"
	else
		return if p == "*" then "BOLD" else "ITALIC"
	end
end

function Utils.canDelimitersMatch(data, data2): boolean
	if data.runLength == 0 or data2.runLength == 0 then
		return false
	end

	if data.canOpen and data.canClose or data2.canOpen and data2.canClose then
		if data.runLength % 3 == 0 and data2.runLength % 3 == 0 then
			return true
		end

		return (data.runLength + data2.runLength) % 3 ~= 0
	end

	return true
end

function Utils:addDelimiterMatch(p)
	local matches = self.matches or {}
	self.matches = matches

	local v2 = #matches
	local v3 = v2 + 1

	local startIdx = p.with.startIdx
	local v4 = 1

	while v4 <= v2 do
		local v5 = math.floor((v4 + v2) / 2)

		if startIdx < matches[v5].with.startIdx then
			v2 = v5 - 1
			v3 = v5
		else
			v4 = v5 + 1
		end
	end

	table.insert(matches, v3, p)
end

function Utils.isWhitespace(value: string?): boolean
	if
		not value
		or #value == 0
		or value:match(Constants.ASCII.WHITESPACE_PATTERN) ~= nil
		or Constants.UNICODE.WHITESPACE[utf8.codepoint(value)]
	then
		return true
	end

	return false
end

function Utils.isPunctuation(value: string?): boolean
	if not value or #value == 0 then
		return false
	end

	if value:match(Constants.ASCII.PUNCTUATION_PATTERN) then
		return true
	end

	local v2 = utf8.codepoint(value)
	return if Constants.UNICODE.PUNCTUATION[v2] then true else false
end

function Utils.isLeftFlanking(p: string?, p2: string?)
	if Utils.isWhitespace(p2) then
		return false
	end

	return not Utils.isPunctuation(p2) or Utils.isWhitespace(p) or Utils.isPunctuation(p)
end

function Utils.isRightFlanking(p: string?, p2: string?)
	if Utils.isWhitespace(p) then
		return false
	end

	return not Utils.isPunctuation(p) or Utils.isWhitespace(p2) or Utils.isPunctuation(p2)
end

function Utils.canOpenEmphasis(data)
	if data.char == "`" then
		return true
	end

	if not Utils.isLeftFlanking(data.prevChar, data.nextChar) then
		return false
	end

	if data.char == "_" then
		return not Utils.isRightFlanking(data.prevChar, data.nextChar) or Utils.isPunctuation(data.prevChar)
	end

	return true
end

function Utils.canCloseEmphasis(data)
	if data.char == "`" then
		return true
	end

	if not Utils.isRightFlanking(data.prevChar, data.nextChar) then
		return false
	end

	if data.char == "_" then
		return not Utils.isLeftFlanking(data.prevChar, data.nextChar) or Utils.isPunctuation(data.nextChar)
	end

	return true
end

function Utils.getCharacterContext(list: string, p: number, p2: number)
	if #list == 0 then
		return {}
	end

	local prevChar = nil
	local nextChar = nil

	if p > 1 then
		local v2 = utf8.offset(list, -1, p)

		if v2 then
			prevChar = utf8.char(utf8.codepoint(list, v2))
		end
	end

	local v2 = p + p2

	if v2 <= #list then
		local v3 = utf8.offset(list, 1, v2)

		if v3 then
			nextChar = utf8.char(utf8.codepoint(list, v3))
		end
	end

	return { prevChar = prevChar, nextChar = nextChar }
end

function Utils.isInsideInlineCode(list, p: number, p2: number?): boolean
	local v2 = {}
	local v3 = nil

	for i = p2 or #list, 1, -1 do
		local item = list[i]

		if item.offset <= p then
			break
		end

		if item.name ~= "INLINE_CODE" then
			continue
		end

		if v3 and v3.offset - 1 == item.offset then
			v3.length += 1
			v3.offset -= 1
		else
			v3 = {
				offset = item.offset,
				length = #item.text
			}

			table.insert(v2, 1, v3)
		end
	end

	local v4 = 1

	while v4 <= #v2 do
		local length = v2[v4].length
		local v5 = nil

		for i = v4 + 1, #v2 do
			if v2[i].length == length then
				v5 = i
				break
			end
		end

		if not v5 then
			return true
		end

		v4 = v5 + 1
	end

	return false
end

return Utils
