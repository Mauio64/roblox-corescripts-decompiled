local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.renderer.html.UrlSanitizer)

local byte = string.byte
local gsub = string.gsub
local lower = string.lower
local sub = string.sub

local DefaultUrlSanitizer = {}
DefaultUrlSanitizer.__index = DefaultUrlSanitizer

function DefaultUrlSanitizer.new()
	return DefaultUrlSanitizer.newCollection({ "http", "https", "mailto", "data" })
end

function DefaultUrlSanitizer.newCollection(list)
	local set = {}

	for _, item in ipairs(list) do
		set[item] = true
	end

	return (setmetatable({ _protocols = set }, DefaultUrlSanitizer))
end

function DefaultUrlSanitizer:sanitizeLinkUrl(p: string)
	local stripHtmlSpaces = self:stripHtmlSpaces(p)

	for i = 0, #stripHtmlSpaces - 1 do
		local v = byte(stripHtmlSpaces, i + 1)

		if v == 47 or v == 35 then
			break
		end

		if v == 63 then
			return stripHtmlSpaces
		end

		if v ~= 58 then
			continue
		end

		local v2 = gsub(lower((sub(stripHtmlSpaces, 1, i))), "K", "k")

		if self._protocols[v2] then
			break
		end

		return ""
	end

	return stripHtmlSpaces
end

function DefaultUrlSanitizer:sanitizeImageUrl(p: string)
	return self:sanitizeLinkUrl(p)
end

function DefaultUrlSanitizer:stripHtmlSpaces(value: string)
	local count = #value
	local count2 = 0

	while count2 < count and self:isHtmlSpace(byte(value, count - 1 + 1)) do
		count -= 1
	end

	while count2 < count and self:isHtmlSpace(byte(value, count2 + 1)) do
		count2 += 1
	end

	if count2 == 0 and count == #value then
		return value
	end

	return (sub(value, count2 + 1, count))
end

function DefaultUrlSanitizer.isHtmlSpace(_, p: number): boolean
	return p == 32 or p == 9 or p == 10 or p == 12 or p == 13
end

return DefaultUrlSanitizer
