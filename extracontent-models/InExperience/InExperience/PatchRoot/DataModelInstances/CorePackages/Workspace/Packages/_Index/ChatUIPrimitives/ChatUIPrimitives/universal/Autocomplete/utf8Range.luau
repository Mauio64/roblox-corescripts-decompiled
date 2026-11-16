local function slice(value: string, p: number, p2: number)
	local v = utf8.len(value)

	if v == nil then
		return nil
	end

	if p2 < p then
		return ""
	end

	if p < 1 or v < p2 then
		return nil
	end

	local v2 = utf8.offset(value, p)

	if v2 == nil then
		return nil
	end

	local v3 = utf8.offset(value, p2 + 1)

	if v3 == nil then
		return (string.sub(value, v2))
	end

	return (string.sub(value, v2, v3 - 1))
end

local Utf8Range = {}

function Utf8Range.splice(value: string, p: number, p2: number, p3: string)
	local v = utf8.len(value)
	local v2 = utf8.len(p3)

	if v == nil or v2 == nil then
		return nil, nil
	end

	if p < 1 or p2 < p or v < p2 then
		return nil, nil
	end

	local v3 = utf8.offset(value, p)

	if v3 == nil then
		return nil, nil
	end

	local v4 = utf8.offset(value, p2 + 1)
	return string.sub(value, 1, v3 - 1) .. p3 .. (v4 == nil and "" or string.sub(value, v4)), p + v2
end

Utf8Range.slice = slice

function Utf8Range.charAt(p: string, p2: number)
	return slice(p, p2, p2)
end

return Utf8Range
