local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.beta.Scanner)

local byte = string.byte

local set = {}

for i = 1, 32 do
	set[byte("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", i)] = true
end

local function isEscapable(p: number): boolean -- 4 equivalent calls inferred from this helper
	return set[p] == true
end

local LinkScanner = {}

function LinkScanner.scanLinkLabelContent(object): boolean
	while object:hasNext() do
		local v = object:peek()

		if v == 92 then
			object:next()

			if isEscapable(object:peek()) then -- inferred equivalent call
				object:next()
			end
		else
			if v == 93 then
				return true
			end

			if v == 91 then
				return false
			end

			object:next()
		end
	end

	return true
end

local function scanLinkDestinationWithBalancedParens(object): boolean
	local v = true
	local v2 = 0

	while object:hasNext() do
		local v3 = object:peek()

		if v3 == 32 then
			return not v
		end

		if v3 == 92 then
			object:next()

			if isEscapable(object:peek()) then -- inferred equivalent call
				object:next()
			end
		elseif v3 == 40 then
			v2 += 1

			if v2 > 32 then
				return false
			end

			object:next()
		elseif v3 == 41 then
			if v2 == 0 then
				return true
			end

			v2 -= 1

			object:next()
		elseif v3 < 32 or v3 == 127 then
			return not v
		else
			object:next()
		end

		v = false
	end

	return true
end

function LinkScanner.scanLinkDestination(object)
	if not object:hasNext() then
		return false
	end

	if not object:nextChar(60) then
		return scanLinkDestinationWithBalancedParens(object)
	end

	while object:hasNext() do
		local v = object:peek()

		if v == 92 then
			object:next()

			if isEscapable(object:peek()) then -- inferred equivalent call
				object:next()
			end
		else
			if v == 10 or v == 60 then
				return false
			end

			if v == 62 then
				object:next()
				return true
			end

			object:next()
		end
	end

	return false
end

function LinkScanner.scanLinkTitle(object): boolean
	if not object:hasNext() then
		return false
	end

	local v = object:peek()
	local v2

	if v == 34 then
		v2 = 34
	elseif v == 39 then
		v2 = 39
	elseif v == 40 then
		v2 = 41
	else
		return false
	end

	object:next()

	if not (LinkScanner.scanLinkTitleContent(object, v2) and object:hasNext()) then
		return false
	end

	object:next()
	return true
end

function LinkScanner.scanLinkTitleContent(object, p: number): boolean
	while object:hasNext() do
		local v = object:peek()

		if v == 92 then
			object:next()

			if isEscapable(object:peek()) then -- inferred equivalent call
				object:next()
			end
		else
			if v == p then
				return true
			end

			if p == 41 and v == 40 then
				return false
			end

			object:next()
		end
	end

	return true
end

return LinkScanner
