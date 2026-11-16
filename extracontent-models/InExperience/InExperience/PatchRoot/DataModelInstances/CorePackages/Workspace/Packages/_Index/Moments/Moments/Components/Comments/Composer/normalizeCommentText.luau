local v = {
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[133] = true,
	[8232] = true,
	[8233] = true
}

local v2 = {
	[9] = true,
	[32] = true,
	[160] = true,
	[5760] = true,
	[8192] = true,
	[8193] = true,
	[8194] = true,
	[8195] = true,
	[8196] = true,
	[8197] = true,
	[8198] = true,
	[8199] = true,
	[8200] = true,
	[8201] = true,
	[8202] = true,
	[8239] = true,
	[8287] = true,
	[12288] = true
}

local v3 = { [6158] = true, [8203] = true, [8288] = true, [65279] = true }

local function normalizeAsciiWhitespace(value: string)
	local v4 = string.gsub(value, "%s+", function(value2: string): string
		if string.find(value2, "[\n\11\f\r]") then
			return "\n"
		end

		return " "
	end)

	return (string.gsub(string.gsub(v4, "^[ \n]", ""), "[ \n]$", ""))
end

local function normalizeCommentText(value: string)
	if utf8.len(value) == nil then
		return normalizeAsciiWhitespace(value)
	end

	local v4 = nil
	local v5 = nil
	local v6 = {}

	for k, v7 in utf8.codes(value) do
		local v8 = v[v7] == true
		local v9 = v2[v7] == true

		if v8 or v9 or v3[v7] == true then
			if v4 ~= nil then
				table.insert(v6, (string.sub(value, v4, k - 1)))
				v4 = nil
			end

			if v8 then
				v5 = "\n"
			elseif v9 and v5 ~= "\n" then
				v5 = " "
			elseif v5 == nil then
				v5 = ""
			end
		elseif v4 == nil then
			if v5 ~= nil and #v6 > 0 then
				table.insert(v6, v5)
			end

			v4 = k
			v5 = nil
		end
	end

	if v4 ~= nil then
		table.insert(v6, (string.sub(value, v4)))
	end

	return table.concat(v6)
end

return normalizeCommentText
