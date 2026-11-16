local v5 = {
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[133] = true,
	[8232] = true,
	[8233] = true
}

local v6 = {
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

local v7 = { [6158] = true, [8203] = true, [8288] = true, [65279] = true }

local function normalizeAsciiWhitespace(value)
	local v8 = string.gsub(value, "%s+", function(value2): string
		if string.find(value2, "[\n\11\f\r]") then
			return "\n"
		end

		return " "
	end)

	return (string.gsub(string.gsub(v8, "^[ \n]", ""), "[ \n]$", ""))
end

local function normalizeCommentText(value)
	if utf8.len(value) == nil then
		return normalizeAsciiWhitespace(value)
	end

	local v8 = nil
	local v9 = nil
	local v10 = {}

	for k, v11 in utf8.codes(value) do
		local v12 = v5[v11] == true
		local v13 = v6[v11] == true

		if v12 or v13 or v7[v11] == true then
			if v8 ~= nil then
				table.insert(v10, (string.sub(value, v8, k - 1)))
				v8 = nil
			end

			if v12 then
				v9 = "\n"
			elseif v13 and v9 ~= "\n" then
				v9 = " "
			elseif v9 == nil then
				v9 = ""
			end
		elseif v8 == nil then
			if v9 ~= nil and #v10 > 0 then
				table.insert(v10, v9)
			end

			v8 = k
			v9 = nil
		end
	end

	if v8 ~= nil then
		table.insert(v10, (string.sub(value, v8)))
	end

	return table.concat(v10)
end

return normalizeCommentText
