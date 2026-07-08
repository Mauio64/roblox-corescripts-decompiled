function enc(p1) -- line: 6
	return (p1:gsub(".", function(p2) -- line: 7
		local s1 = ""
		local v11 = p2:byte()

		for i = 8, 1, -1 do
			s1 ..= not (v11 % 2 ^ i - v11 % 2 ^ (i - 1) > 0) and "0" or "1"
		end

		return s1
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p3) -- line: 11
		if #p3 < 6 then
			return ""
		end

		local n1 = 0

		for i = 1, 6 do
			n1 += p3:sub(i, i) == "1" and 2 ^ (6 - i) or 0
		end

		return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(n1 + 1, n1 + 1)
	end) .. ({
		"",
		"==",
		"="
	})[#p1 % 3 + 1]
end
function dec(p4) -- line: 20
	return (string.gsub(p4, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(p5) -- line: 22
		if p5 == "=" then
			return ""
		end

		local s2 = ""
		local v18 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p5) - 1

		for i = 6, 1, -1 do
			s2 ..= not (v18 % 2 ^ i - v18 % 2 ^ (i - 1) > 0) and "0" or "1"
		end

		return s2
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p6) -- line: 27
		if #p6 ~= 8 then
			return ""
		end

		local n2 = 0

		for i = 1, 8 do
			n2 += p6:sub(i, i) == "1" and 2 ^ (7 - i) or 0
		end

		return (string.char(n2))
	end))
end
function safe_enc(p7, p8) -- line: 35
	if p8 == nil then
		p8 = true
	end

	local s3 = ""
	local t1 = {}

	while #p7 > 0 do
		table.insert(t1, p7:sub(1, 204798))
		p7 = p7:sub(204799)
	end

	for i, v in ipairs(t1) do
		if p8 then
			print(("[http] Encoding B64 chunk %s/%s"):format(i, #t1))
		end

		s3 ..= enc(v)
		wait()
	end

	return s3
end

return {
	encode = safe_enc,
	decode = dec
}
