local CommonMark = script:FindFirstAncestor("CommonMark")
local CaseFolding = require(CommonMark.internal.data.CaseFolding)
local Html5Entities = require(CommonMark.internal.util.Html5Entities)
local Utf8 = require(CommonMark.internal.port.Utf8)

local byte = string.byte
local find = string.find
local gsub = string.gsub
local sub = string.sub

local Escaping = {}
Escaping.ESCAPABLE = "[!\"#$%%&'()*+,./:;<=>?@%[\\%]^_`{|}~%-]"
local v = "^\\" .. Escaping.ESCAPABLE

local function findPattern(value: string, p: string, p2: number) -- 5 equivalent calls inferred from this helper
	local v2 = find(value, p, p2 + 1)

	if v2 then
		return v2 - 1
	end

	return -1
end

local function matchEntity(value: string, p: number)
	local v2 = p + 1
	local _, v3 = find(value, "^#[Xx][0-9A-Fa-f]*;", v2 + 1)

	if v3 == nil then
		local _, v4 = find(value, "^#[0-9]*;", v2 + 1)

		if v4 == nil then
			local _, v5 = find(value, "^[A-Za-z][A-Za-z0-9]*;", v2 + 1)

			if v5 == nil then
				return nil
			end

			local v6 = v5 - v2 - 2
			return if v6 >= 1 and v6 <= 31 then v5 else nil
		else
			local v5 = v4 - v2 - 2
			return if v5 >= 1 and v5 <= 7 then v4 else nil
		end
	else
		local v4 = v3 - v2 - 3
		return if v4 >= 1 and v4 <= 6 then v3 else nil
	end
end

local function findEntityOrEscapedChar(value: string, p: number)
	local pattern = findPattern(value, "[\\&]", p) -- inferred equivalent call

	while pattern ~= -1 do
		local selected

		if byte(value, pattern + 1) == 92 then
			local _
			_, selected = find(value, v, pattern + 1)
		else
			selected = matchEntity(value, pattern)
		end

		if selected ~= nil then
			return pattern, selected
		end

		pattern = findPattern(value, "[\\&]", pattern + 1) -- inferred equivalent call
	end

	return -1, -1
end

local function encodedLength(p: number): number -- 2 equivalent calls inferred from this helper
	if p < 128 then
		return 1
	end

	if p < 2048 then
		return 2
	end

	return if p < 65536 then 3 else 4
end

local function findEscapeInUri(value: string, p: number)
	local pattern = findPattern(value, "[^:/?#@!$&'()*+,;=A-Za-z0-9%-._~]", p) -- inferred equivalent call

	if pattern == -1 then
		return -1, -1
	end

	if byte(value, pattern + 1) == 37 then
		local _, v2 = find(value, "^[0-9A-Fa-f]?[0-9A-Fa-f]?", pattern + 2)
		return pattern, v2
	end

	return pattern, pattern + encodedLength(Utf8.codePointAt(value, pattern)) -- inferred equivalent call
end

local v2 = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F"
}

local function fn(value)
	if byte(value, 1) == 92 then
		return (sub(value, 2, #value))
	end

	return Html5Entities.entityToString(value)
end

local function fn2(value)
	if byte(value, 1) == 37 then
		if #value == 3 then
			return value
		end

		return "%25" .. sub(value, 2, #value)
	else
		local v3 = {}

		for i = 1, #value do
			local v4 = byte(value, i)
			v3[i] = "%" .. v2[v4 // 16 + 1] .. v2[v4 % 16 + 1]
		end

		return table.concat(v3)
	end
end

local v3 = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;" }

function Escaping.escapeHtml(value: string)
	if find(value, "[&<>\"]") == nil then
		return value
	end

	return (gsub(value, "[&<>\"]", v3))
end

local function replaceAll(callback, value: string, fn3)
	local v4, v5 = callback(value, 0)

	if v4 == -1 then
		return value
	end

	local count = 0
	local v6 = 0
	local v7 = {}

	while true do
		count += 1
		v7[count] = sub(value, v6 + 1, v4)
		count += 1
		v7[count] = fn3((sub(value, v4 + 1, v5)))
		local v8
		v4, v8 = callback(value, v5)

		if v4 == -1 then
			break
		end

		v6 = v5
		v5 = v8
	end

	if v5 ~= #value then
		v7[count + 1] = sub(value, v5 + 1, #value)
	end

	return table.concat(v7)
end

function Escaping.unescapeString(value: string)
	if find(value, "[\\&]") == nil then
		return value
	end

	return replaceAll(findEntityOrEscapedChar, value, fn)
end

function Escaping.percentEncodeUrl(p: string)
	return replaceAll(findEscapeInUri, p, fn2)
end

local function trim(value: string)
	local count = #value
	local count2 = 0

	while count2 < count and byte(value, count2 + 1) <= 32 do
		count2 += 1
	end

	while count2 < count and byte(value, count - 1 + 1) <= 32 do
		count -= 1
	end

	return (sub(value, count2 + 1, count))
end

local function caseFold(value: string)
	local pattern = findPattern(value, "[A-Z\128-\255]", 0) -- inferred equivalent call

	if pattern == -1 then
		return value
	end

	local v4 = 0
	local v5 = 0
	local v6 = {}

	while pattern ~= -1 do
		local codePointAt = Utf8.codePointAt(value, pattern)
		local v7 = encodedLength(codePointAt) -- inferred equivalent call
		local v8 = CaseFolding[codePointAt]

		if v8 ~= nil then
			local v9 = v4 + 1
			v6[v9] = sub(value, v5 + 1, pattern)
			v4 = v9 + 1
			v6[v4] = v8
			v5 = pattern + v7
		end

		pattern = findPattern(value, "[A-Z\128-\255]", pattern + v7) -- inferred equivalent call
	end

	v6[v4 + 1] = sub(value, v5 + 1, #value)
	return table.concat(v6)
end

function Escaping.normalizeLabelContent(p: string)
	return (gsub(caseFold(trim(p)), "[ \t\r\n]+", " "))
end

Escaping._findEntityOrEscapedChar = findEntityOrEscapedChar
Escaping._findEscapeInUri = findEscapeInUri

return Escaping
