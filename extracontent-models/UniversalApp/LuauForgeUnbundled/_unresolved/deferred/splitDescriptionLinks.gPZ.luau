require("@luauforge/deferred/gQa")
local module = require("@luauforge/deferred/gQf")

local v5 = {
	".",
	",",
	"!",
	"?",
	";",
	":",
	")",
	"]",
	"}",
	"\"",
	"'",
	">",
	"】",
	"」",
	"』",
	"）",
	"。"
}

local function isWhitespaceByte(p2)
	local v6 = p2 == 32 or p2 >= 9 and p2 <= 13
	return v6
end

local function isHostByte(p2): boolean
	return p2 >= 97 and p2 <= 122 or (p2 >= 48 and p2 <= 57 or (p2 == 46 or p2 == 45))
end

local function normalizeLineBreaks(value)
	local v6 = string.gsub(value, "\r\n", "\n")
	return (string.gsub(v6, "\r", "\n"))
end

local function findWordAround(value, p2, p3)
	local v6 = p2

	while p3 < v6 do
		local v7 = string.byte(value, v6 - 1)
		local v8 = v7 == 32 or v7 >= 9 and v7 <= 13

		if v8 then
			break
		end

		v6 -= 1
	end

	local v7 = string.find(value, "%s", p2)
	local v8 = if v7 then v7 - 1 else #value
	return v6, v8
end

local function trimTrailingPunctuation(value, wordAround, p2)
	local v6 = true

	while v6 and wordAround <= p2 do
		v6 = false

		for k, v8 in v5 do
			if string.sub(value, p2 - #v8 + 1, p2) == v8 then
				p2 -= #v8
				v6 = true
				break
			end
		end
	end

	return p2
end

local function findHostAround(value, p2, wordAround, p3)
	local v6 = p2

	while wordAround < v6 do
		local v7 = string.byte(value, v6 - 1)

		if not (v7 >= 97 and v7 <= 122) and not (v7 >= 48 and v7 <= 57) and v7 ~= 46 and v7 ~= 45 then
			break
		end

		v6 -= 1
	end

	local v7 = p2 + 10 - 1

	while v7 < p3 do
		local v8 = string.byte(value, v7 + 1)

		if not (v8 >= 97 and v8 <= 122) and not (v8 >= 48 and v8 <= 57) and v8 ~= 46 and v8 ~= 45 then
			break
		end

		v7 += 1
	end

	return v6, v7
end

local function isRobloxHost(value): boolean
	return value == "roblox.com" or string.sub(value, -11) == ".roblox.com"
end

local function isRobloxUrl(value, value2, p2)
	if
		value ~= "roblox.com" and string.sub(value, -11) ~= ".roblox.com"
		or string.find(value2, "://", 1, true) ~= nil
	then
		return false
	end

	local v6 = string.match(value2, "[_@]$") ~= nil
	return p2 or not v6
end

local function trimWhitespaceAfterLink(value)
	local v6 = string.gsub(value, "^[ \t]+", "")
	return (string.gsub(v6, "^\n", ""))
end

local function trimWhitespaceBeforeLink(value)
	local v6 = string.gsub(value, "[ \t]+$", "")
	local v7 = string.gsub(v6, "\n$", "")
	return (string.gsub(v7, "[ \t]+$", ""))
end

local function splitDescriptionLinks(value)
	local v6 = string.gsub(value, "\r\n", "\n")
	local v7 = string.gsub(v6, "\r", "\n")

	local v8 = string.lower(v7)
	local result = {}
	local flag = false

	local function emitText(value2, p2)
		if flag then
			local v9 = string.gsub(value2, "^[ \t]+", "")
			value2 = string.gsub(v9, "^\n", "")
		end

		if p2 then
			local v9 = string.gsub(value2, "[ \t]+$", "")
			local v10 = string.gsub(v9, "\n$", "")
			value2 = string.gsub(v10, "[ \t]+$", "")
		end

		if string.find(value2, "%S") then
			table.insert(result, { kind = "text", text = value2 })
		end
	end

	local v9 = 1
	local v10 = 1

	while true do
		local v11 = string.find(v8, "roblox.com", v9, true)

		if v11 == nil then
			break
		end

		local wordAround, v12 = findWordAround(v7, v11, v10)
		v9 = v12 + 1

		local v13 = trimTrailingPunctuation(v7, wordAround, v12)
		local hostAround, v14 = findHostAround(v8, v11, wordAround, v13)

		local v15 = string.match(string.sub(v8, wordAround, hostAround - 1), "https?://$")
		local v16 = if v15 then hostAround - #v15 else hostAround
		local v17 = string.sub(v8, hostAround, v14)
		local v18 = string.sub(v8, wordAround, v16 - 1)

		if not (v14 <= v13) then
			continue
		end

		local v19 = v15 ~= nil
		local v20

		if
			(v17 == "roblox.com" or string.sub(v17, -11) == ".roblox.com")
			and string.find(v18, "://", 1, true) == nil
		then
			local v21 = string.match(v18, "[_@]$") ~= nil
			v20 = v19 or not v21
		else
			v20 = false
		end

		if not v20 then
			continue
		end

		if v10 < v16 then
			emitText(string.sub(v7, v10, v16 - 1), true)
		end

		table.insert(result, {
			kind = "link",
			url = module((string.sub(v7, v16, v13)))
		})
		flag = true
		v10 = v13 + 1
	end

	if v10 <= #v7 then
		local v11 = string.sub(v7, v10)

		if flag then
			local v12 = string.gsub(v11, "^[ \t]+", "")
			v11 = string.gsub(v12, "^\n", "")
		end

		if string.find(v11, "%S") then
			table.insert(result, { kind = "text", text = v11 })
		end
	end

	return result
end

return splitDescriptionLinks
