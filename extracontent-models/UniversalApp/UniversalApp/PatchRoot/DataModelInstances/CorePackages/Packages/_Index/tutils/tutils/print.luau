return function(p1) -- line: 1
	local function makeKeyString(p2) -- line: 2
		if type(p2) == "string" then
			return string.format("%s", p2)
		end

		return string.format("[%s]", (tostring(p2)))
	end
	local function makeValueString(p3) -- line: 10
		local v7 = type(p3)

		if v7 == "string" then
			return string.format("%q", p3)
		end

		if v7 == "function" or v7 == "table" then
			return string.format("<%s>", (tostring(p3)))
		end

		return string.format("%s", (tostring(p3)))
	end
	local function printKeypair(p4, p5, p6, p7) -- line: 21
		-- upvalues: makeValueString (copy), p1 (copy)
		local v12 = if type(p4) ~= "string" then string.format("[%s]", (tostring(p4))) else string.format("%s", p4)
		local v13 = makeValueString(p5)
		local v14 = p7 and string.format(" -- %s", p7) or ""

		p1(string.format("%s%s = %s,%s", p6, v12, v13, v14))
	end

	return function(p8, p9) -- line: 33
		-- upvalues: p1 (copy), makeValueString (copy), printKeypair (copy)
		local u17 = p9 or "  "

		if type(p8) ~= "table" then
			error("tutils.Print must be passed a table", 2)
		end

		local t1 = {}

		local function recurse(p10, p11, p12) -- line: 43
			-- upvalues: t1 (copy), u17 (ref), p1 (copy), makeValueString (copy), printKeypair (copy), recurse (copy)
			t1[p10] = true

			local v23 = string.rep(u17, p12)
			local v24 = string.rep(u17, p12 + 1)

			if p11 then
				p1(string.format("%s%s = %s {", v23, if type(p11) ~= "string" then string.format("[%s]", (tostring(p11))) else string.format("%s", p11), makeValueString(p10)))
			else
				p1(string.format("%s%s {", v23, makeValueString(p10)))
			end

			for k, v in pairs(p10) do
				if type(v) == "table" then
					if t1[v] then
						printKeypair(k, v, v24, "Possible cycle")
					else
						recurse(v, k, p12 + 1)
					end
				else
					local v27 = if type(k) ~= "string" then string.format("[%s]", (tostring(k))) else string.format("%s", k)
					local v28 = makeValueString(v)

					p1(string.format("%s%s = %s,%s", v24, v27, v28, ""))
				end
			end

			p1(string.format("%s}%s", v23, not (p12 > 0) and "" or ","))
		end

		recurse(p8, nil, 0)
	end
end
