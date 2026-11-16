function enc(value)
	return (value:gsub(".", function(value2)
		local v = value2:byte()
		local v2 = ""

		for i = 8, 1, -1 do
			v2 ..= v % 2 ^ i - v % 2 ^ (i - 1) > 0 and "1" or "0"
		end

		return v2
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(value2)
		if #value2 < 6 then
			return ""
		end

		local total = 0

		for i = 1, 6 do
			total += value2:sub(i, i) == "1" and 2 ^ (6 - i) or 0
		end

		return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(total + 1, total + 1)
	end) .. ({ "", "==", "=" })[#value % 3 + 1]
end

function dec(value)
	return (string.gsub(value, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(
		".",
		function(p)
			if p == "=" then
				return ""
			end

			local v = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p) - 1
			local v2 = ""

			for i = 6, 1, -1 do
				v2 ..= v % 2 ^ i - v % 2 ^ (i - 1) > 0 and "1" or "0"
			end

			return v2
		end
	):gsub(
		"%d%d%d?%d?%d?%d?%d?%d?",
		function(value2)
			if #value2 ~= 8 then
				return ""
			end

			local total = 0

			for i = 1, 8 do
				total += value2:sub(i, i) == "1" and 2 ^ (7 - i) or 0
			end

			return (string.char(total))
		end
	))
end

function safe_enc(value, p)
	local v = p == nil or p

	local v2 = {}
	local v3 = ""

	while #value > 0 do
		table.insert(v2, value:sub(1, 204798))
		value = value:sub(204799)
	end

	for i, v4 in ipairs(v2) do
		if v then
			print(("[http] Encoding B64 chunk %s/%s"):format(i, #v2))
		end

		v3 ..= enc(v4)

		wait()
	end

	return v3
end

return { encode = safe_enc, decode = dec }
