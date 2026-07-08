local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array
local RegExp = require(ParentParent.RegExp)

local function stringMatch(p1, p2) -- line: 11
	local v17 = p2:exec(p1)
	local t1 = {}

	while v17 do
		local v19 = v17[1]

		table.insert(t1, v19)
		v17 = p2:exec((v17.input:sub(v17.index + v19:len())))
	end

	return t1
end
local function TypeError(p3) -- line: 25
	return p3
end

local v6 = RegExp("(%[a-fA-F0-9]{2})+", "i")

local function decodeURIComponent(p4) -- line: 33
	-- upvalues: v6 (copy)
	local v22 = v6:exec(p4)

	if v22 then
		local t2 = {}

		for match in v22[1]:gmatch("%%(%x%x)") do
			local num = tonumber(match, 16)

			if num >= 128 then
				error("malformed URI sequence")
			end

			table.insert(t2, num)
		end

		p4 = utf8.char(unpack(t2))
	end

	return p4
end

local v8 = RegExp("%[a-fA-F0-9]{2}", "i")
local v9 = RegExp("(%[a-fA-F0-9]{2})+", "i")

local function decodeComponents(p5, p6) -- line: 61
	-- upvalues: decodeURIComponent (copy), Array (copy), decodeComponents (copy)
	local ok, result = pcall(decodeURIComponent, table.concat(p5, ""))

	if ok then
		return result
	end

	if #p5 == 1 then
		return p5
	end

	local v30 = p6 or 1
	local v31 = Array.slice(p5, 1, v30 + 1)
	local v32 = Array.slice(p5, v30 + 1)

	return Array.concat(decodeComponents(v31), decodeComponents(v32))
end
local function decode(p7) -- line: 83
	-- upvalues: decodeURIComponent (copy), stringMatch (copy), v8 (copy), decodeComponents (copy)
	local ok, result = pcall(decodeURIComponent, p7)

	if ok then
		return result
	end

	local v36 = stringMatch(p7, v8)
	local n1 = 2

	while v36[n1] do
		p7 = table.concat(decodeComponents(v36, n1), "")
		v36 = stringMatch(p7, v8)
		n1 += 1
	end

	return p7
end
local function escapePercent(p8) -- line: 107
	return (p8:gsub("%%", "%%%%"))
end
local function customDecodeURIComponent(p9) -- line: 112
	-- upvalues: v9 (copy), decodeURIComponent (copy), decode (copy)
	local v40 = utf8.char(65533)
	local t3 = {
		["%FE%FF"] = v40 .. v40,
		["%FF%FE"] = v40 .. v40
	}
	local t4 = {
		"%FE%FF",
		"%FF%FE"
	}
	local v43 = v9:exec(p9)

	while v43 do
		local v44 = v43[1]
		local ok, result = xpcall(decodeURIComponent, function(_) -- line: 130
			-- upvalues: decode (copy), v44 (copy), t3 (copy), t4 (copy)
			local v53 = decode(v44)

			if v53 ~= v44 then
				if t3[v44] == nil then
					table.insert(t4, v44)
				end

				t3[v44] = v53
			end
		end, v44)

		if ok then
			if t3[v44] == nil then
				table.insert(t4, v44)
			end

			t3[v44] = result
		end

		local v47 = v43.input:sub(v43.index + v44:len())

		v43 = v9:exec(v47)
	end

	t3["%C2"] = v40
	table.insert(t4, "%C2")

	for _, v49 in t4 do
		p9 = string.gsub(p9, v49:gsub("%%", "%%%%"), (t3[v49]:gsub("%%", "%%%%")))
	end

	return p9
end
local function decodeComponent(p11) -- line: 172
	-- upvalues: customDecodeURIComponent (copy)
	if type(p11) ~= "string" then
		error("Expected `encodedURI` to be of type `string`, got `" .. typeof(p11) .. "`")
	end

	local v51 = p11:gsub("%+", " ")

	return (customDecodeURIComponent(v51))
end

return decodeComponent
