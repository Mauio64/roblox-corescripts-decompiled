local CommonMark = script:FindFirstAncestor("CommonMark")
local HtmlEntities = require(CommonMark.internal.data.HtmlEntities)

local byte = string.byte
local find = string.find
local sub = string.sub

local function parseInt(value: string, p: number)
	local v = byte(value, 1)
	local v2 = v == 45

	if v2 or v == 43 then
		value = sub(value, 2)
	end

	if find(value, p == 16 and "^[0-9A-Fa-f]+$" or "^[0-9]+$") == nil then
		return nil
	end

	local v3 = find(value, "[^0]")
	local v4 = not v3 and "" or sub(value, v3)

	if #v4 > 10 then
		return nil
	end

	local selected = tonumber(v4, p) or 0

	if v2 then
		selected = -selected
	end

	if selected < -2147483648 or selected > 2147483647 then
		return nil
	end

	return selected
end

return {
	entityToString = function(value: string)
		if byte(value, 1) ~= 38 or byte(value, #value) ~= 59 then
			return value
		end

		local v = sub(value, 2, #value - 1)

		if byte(v, 1) == 35 then
			local v2 = sub(v, 2)

			local v3 = byte(v2, 1)
			local v4

			if v3 == 120 or v3 == 88 then
				v2 = sub(v2, 2)
				v4 = 16
			else
				v4 = 10
			end

			local v5 = parseInt(v2, v4)

			if v5 == 0 then
				return "�"
			end

			if v5 == nil or v5 < 0 or v5 > 1114111 or v5 >= 55296 and v5 <= 57343 then
				return "�"
			end

			return utf8.char(v5)
		else
			local htmlEntity = HtmlEntities[v]
			return if htmlEntity == nil then value else htmlEntity
		end
	end
}
