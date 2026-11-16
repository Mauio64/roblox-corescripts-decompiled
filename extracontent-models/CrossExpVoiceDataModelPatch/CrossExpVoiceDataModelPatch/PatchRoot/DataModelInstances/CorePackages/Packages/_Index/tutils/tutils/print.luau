return function(callback)
	local function makeKeyString(value) -- 2 equivalent calls inferred from this helper
		if type(value) == "string" then
			return string.format("%s", value)
		end

		return string.format("[%s]", (tostring(value)))
	end

	local function makeValueString(p)
		local typeName = type(p)

		if typeName == "string" then
			return string.format("%q", p)
		end

		if typeName == "function" or typeName == "table" then
			return string.format("<%s>", (tostring(p)))
		end

		return string.format("%s", (tostring(p)))
	end

	local function printKeypair(value, item, p, p2) -- 1 equivalent call inferred from this helper
		local keyString = makeKeyString(value) -- inferred equivalent call
		local valueString = makeValueString(item)

		local v = p2 and string.format(" -- %s", p2) or ""
		callback(string.format("%s%s = %s,%s", p, keyString, valueString, v))
	end

	return function(p, value)
		local v = value or "  "

		if type(p) ~= "table" then
			error("tutils.Print must be passed a table", 2)
		end

		local itemsSet = {}
		local function recurse(items, value2, p2)
			itemsSet[items] = true

			local v2 = string.rep(v, p2)
			local v3 = string.rep(v, p2 + 1)

			if value2 then
				callback(string.format("%s%s = %s {", v2, makeKeyString(value2), makeValueString(items))) -- inferred equivalent call
			else
				callback(string.format("%s%s {", v2, makeValueString(items)))
			end

			for k, item in pairs(items) do
				if type(item) == "table" then
					if itemsSet[item] then
						printKeypair(k, item, v3, "Possible cycle")
					else
						recurse(item, k, p2 + 1)
					end
				else
					printKeypair(k, item, v3) -- inferred equivalent call
				end
			end

			callback(string.format("%s}%s", v2, p2 > 0 and "," or ""))
		end

		recurse(p, nil, 0)
	end
end
