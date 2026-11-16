local CommonMark = script:FindFirstAncestor("CommonMark")
local UnicodeLetters = require(CommonMark.internal.data.UnicodeLetters)
local UnicodePunctuation = require(CommonMark.internal.data.UnicodePunctuation)
local UnicodeSpaceSeparators = require(CommonMark.internal.data.UnicodeSpaceSeparators)
local Utf8 = require(CommonMark.internal.port.Utf8)

local byte = string.byte
local char = string.char
local find = string.find

local Characters = {}

function Characters.find(p: number, value: string, p2: number)
	local v = find(value, char(p), p2 + 1, true)

	if v then
		return v - 1
	end

	return -1
end

function Characters.findLineBreak(value: string, p: number)
	local v = find(value, "[\n\r]", p + 1)

	if v then
		return v - 1
	end

	return -1
end

function Characters.isBlank(list: string): boolean
	return Characters.skipSpaceTab(list, 0, #list) == #list
end

function Characters.hasNonSpace(list: string): boolean
	local count = #list
	return Characters.skip(32, list, 0, count) ~= count
end

local function isInRanges(list, p: number): boolean
	local v = #list // 2
	local v2 = 1

	while v2 <= v do
		local v3 = (v2 + v) // 2

		if p < list[v3 * 2 - 1] then
			v = v3 - 1
		elseif list[v3 * 2] < p then
			v2 = v3 + 1
		else
			return true
		end
	end

	return false
end

function Characters.isLetter(p: string, p2: number)
	return isInRanges(UnicodeLetters, Utf8.codePointAt(p, p2))
end

function Characters.isSpaceOrTab(value: string, p: number): boolean
	if p < #value then
		local v = byte(value, p + 1)

		if v == 32 or v == 9 then
			return true
		end
	end

	return false
end

function Characters.isPunctuationCodePoint(p: number): boolean
	if isInRanges(UnicodePunctuation, p) then
		return true
	end

	return p == 36 or p == 43 or p == 60 or p == 61 or p == 62 or p == 94 or p == 96 or p == 124 or p == 126
end

function Characters.isWhitespaceCodePoint(p: number): boolean
	return p == 32 or p == 9 or p == 10 or p == 12 or p == 13 or UnicodeSpaceSeparators[p] == true
end

function Characters.skip(p: number, value: string, p2: number, p3: number)
	for i = p2, p3 - 1 do
		if byte(value, i + 1) ~= p then
			return i
		end
	end

	return p3
end

function Characters.skipBackwards(p: number, value: string, p2: number, p3: number)
	for i = p2, p3, -1 do
		if byte(value, i + 1) ~= p then
			return i
		end
	end

	return p3 - 1
end

function Characters.skipSpaceTab(value: string, p: number, p2: number)
	for i = p, p2 - 1 do
		local v = byte(value, i + 1)

		if v ~= 32 and v ~= 9 then
			return i
		end
	end

	return p2
end

function Characters.skipSpaceTabBackwards(value: string, p: number, p2: number)
	for i = p, p2, -1 do
		local v = byte(value, i + 1)

		if v ~= 32 and v ~= 9 then
			return i
		end
	end

	return p2 - 1
end

return Characters
