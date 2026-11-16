local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local RegExp = require(parent.RegExp)

local function TypeError(p)
	return p
end

local PathToRegexp = {}

local escapeString
local flags

local function lexer(value: string)
	local result = {}
	local v = 1

	local function preIncrement_i(p)
		v += 1
		return p
	end

	local function getChar(p) -- 14 equivalent calls inferred from this helper
		return (string.sub(value, p, p))
	end

	local v2 = string.len(value)

	while v <= v2 do
		local v3 = string.sub(value, v, v)

		if v3 == "*" or v3 == "+" or v3 == "?" then
			local v4 = { type = "MODIFIER", index = v, value = 0 }

			local v5 = v
			v += 1

			v4.value = getChar(v5) -- inferred equivalent call
			table.insert(result, v4)
		elseif v3 == "\\" then
			local v5 = v
			v += 1

			local v6 = v
			v += 1

			local v4 = { type = "ESCAPED_CHAR", index = v5, value = getChar(v6) } -- inferred equivalent call
			table.insert(result, v4)
		elseif v3 == "{" then
			local v4 = { type = "OPEN", index = v, value = 0 }

			local v5 = v
			v += 1

			v4.value = getChar(v5) -- inferred equivalent call
			table.insert(result, v4)
		elseif v3 == "}" then
			local v4 = { type = "CLOSE", index = v, value = 0 }

			local v5 = v
			v += 1

			v4.value = getChar(v5) -- inferred equivalent call
			table.insert(result, v4)
		elseif v3 == ":" then
			local v4 = ""
			local v5 = v + 1

			local function preIncrement_j(p)
				v5 += 1
				return p
			end

			while v5 <= v2 do
				local v6 = string.byte(value, v5)

				if
					not (v6 >= 48 and v6 <= 57)
					and not (v6 >= 65 and v6 <= 90)
					and not (v6 >= 97 and v6 <= 122)
					and v6 ~= 95
				then
					break
				end

				local v7 = v5
				v5 += 1
				v4 ..= getChar(v7) -- inferred equivalent call
			end

			if v4 == "" then
				error((("Missing parameter name at %d"):format(v)))
			end

			table.insert(result, { type = "NAME", index = v, value = v4 })

			v = v5
		elseif v3 == "(" then
			local v4 = 1
			local v5 = ""
			local v6 = v + 1

			if getChar(v6) == "?" then -- inferred equivalent call
				error((("Pattern cannot start with \"?\" at %d"):format(v6)))
			end

			local function preIncrement_j(p)
				v6 += 1
				return p
			end

			while v6 <= v2 do
				if getChar(v6) == "\\" then -- inferred equivalent call
					local v7 = v6
					v6 += 1
					local char = getChar(v7) -- inferred equivalent call
					local v8 = v6
					v6 += 1
					v5 ..= char .. getChar(v8) -- inferred equivalent call
				end

				if getChar(v6) == ")" then -- inferred equivalent call
					v4 -= 1

					if v4 == 0 then
						v6 += 1
						break
					end
				elseif getChar(v6) == "(" then -- inferred equivalent call
					v4 += 1

					if getChar(v6 + 1) ~= "?" then -- inferred equivalent call
						error((("Capturing groups are not allowed at %d"):format(v6)))
					end
				end

				local v7 = v6
				v6 += 1
				v5 ..= getChar(v7) -- inferred equivalent call
			end

			if v4 ~= 0 then
				error((("Unbalanced pattern at %d"):format(v)))
			end

			if v5 == "" then
				error((("Missing pattern at %d"):format(v)))
			end

			table.insert(result, { type = "PATTERN", index = v, value = v5 })

			v = v6
		else
			local v4 = { type = "CHAR", index = v, value = 0 }

			local v5 = v
			v += 1

			v4.value = getChar(v5) -- inferred equivalent call
			table.insert(result, v4)
		end
	end

	table.insert(result, { type = "END", index = v, value = "" })

	return result
end

function PathToRegexp.parse(p: string, options)
	local v = options or {}
	local v2 = lexer(p)

	local v3 = (v.prefixes == nil or v.prefixes == "") and "./" or v.prefixes

	local v4 = string.format("[^%s]+?", escapeString(v.delimiter or "/#?"))
	local result = {}
	local count = 0
	local v5 = 1

	local function preIncrement_i(p2)
		v5 += 1
		return p2
	end

	local function preIncrement_key(p2)
		count += 1
		return p2
	end

	local function tryConsume(p2) -- 14 equivalent calls inferred from this helper
		if not (v5 <= #v2) or v2[v5].type ~= p2 then
			return nil
		end

		local v6 = v5
		v5 += 1
		return v2[v6].value
	end

	local function mustConsume(p2)
		local v6 = tryConsume(p2) -- inferred equivalent call

		if v6 ~= nil then
			return v6
		end

		local v7 = v2[v5]

		if v7 == nil then
			error((("Expected token %s, got nil"):format(p2)))
		end

		local kind = v7.type
		local index = v7.index
		error((("Unexpected %s at %d, expected %s"):format(kind, index, p2)))
	end

	local function consumeText()
		local v6 = ""
		local v7 = tryConsume("CHAR") or tryConsume("ESCAPED_CHAR") -- inferred equivalent call

		while v7 and v7 ~= "" do
			v6 ..= v7
			v7 = tryConsume("CHAR") or tryConsume("ESCAPED_CHAR") -- inferred equivalent call
		end

		return v6
	end

	local v6 = ""

	while v5 <= #v2 do
		local v7 = tryConsume("CHAR") -- inferred equivalent call
		local name = tryConsume("NAME") -- inferred equivalent call
		local pattern = tryConsume("PATTERN") -- inferred equivalent call

		if name and name ~= "" or pattern and pattern ~= "" then
			local prefix = v7 or ""

			if string.find(v3, prefix) == nil then
				v6 ..= prefix
				prefix = ""
			end

			if v6 ~= nil and v6 ~= "" then
				table.insert(result, v6)
				v6 = ""
			end

			if name == nil or name == "" then
				name = count
				count += 1
			end

			if pattern == nil or pattern == "" then
				pattern = v4
			end

			local v8 = {
				name = name,
				prefix = prefix,
				suffix = "",
				pattern = pattern,
				modifier = tryConsume("MODIFIER") or "" -- inferred equivalent call
			}
			table.insert(result, v8)
		else
			if not v7 then
				v7 = tryConsume("ESCAPED_CHAR") -- inferred equivalent call
			end

			if v7 and v7 ~= "" then
				v6 ..= v7
			else
				if v6 and v6 ~= "" then
					table.insert(result, v6)
					v6 = ""
				end

				local v8 = tryConsume("OPEN") -- inferred equivalent call

				if v8 and v8 ~= "" then
					local prefix = consumeText()
					local name2 = tryConsume("NAME") or "" -- inferred equivalent call
					local pattern2 = tryConsume("PATTERN") or "" -- inferred equivalent call

					local suffix = consumeText()

					mustConsume("CLOSE")

					if name2 == "" and pattern2 ~= "" then
						name2 = count
						count += 1
					end

					if name2 ~= "" and name2 ~= 0 and (pattern2 == nil or pattern2 == "") then
						pattern2 = v4
					end

					local v9 = {
						name = name2,
						pattern = pattern2,
						prefix = prefix,
						suffix = suffix,
						modifier = tryConsume("MODIFIER") or "" -- inferred equivalent call
					}
					table.insert(result, v9)
				else
					mustConsume("END")
				end
			end
		end
	end

	return result
end

function PathToRegexp.compile(p: string, p2)
	return PathToRegexp.tokensToFunction(PathToRegexp.parse(p, p2), p2)
end

function PathToRegexp.tokensToFunction(items, p)
	local v = p == nil and {} or p

	local v2 = flags(v)
	local encode = v.encode or function(p2: string)
		return p2
	end

	local validate = v.validate
	local v3 = validate == nil or validate

	local mapped = Array.map(items, function(p2)
		if type(p2) == "table" then
			return RegExp(("^(?:%s)$"):format(p2.pattern), v2)
		end

		return nil
	end)

	return function(p2)
		local v4 = ""

		for k, item in items do
			if type(item) == "string" then
				v4 ..= item
			else
				local v5

				if p2 then
					v5 = p2[tostring(item.name)]
				end

				local v6 = item.modifier == "?" or item.modifier == "*"
				local v7 = item.modifier == "*" or item.modifier == "+"

				if Array.isArray(v5) then
					if not v7 then
						error((("Expected \"%s\" to not repeat, but got an array"):format(item.name)))
					end

					if #v5 == 0 then
						if v6 then
							continue
						end

						error((("Expected \"%s\" to not be empty"):format(item.name)))
					end

					for _, v8 in v5 do
						local v9 = encode(v8, item)

						if v3 and not mapped[k]:test(v9) then
							error((("Expected all \"%s\" to match \"%s\", but got \"%s\""):format(
								item.name,
								item.pattern,
								v9
							)))
						end

						v4 ..= item.prefix .. v9 .. item.suffix
					end
				else
					local typeName = type(v5)

					if typeName == "string" or typeName == "number" then
						local v8 = encode(tostring(v5), item)

						if v3 and not mapped[k]:test(v8) then
							error((("Expected \"%s\" to match \"%s\", but got \"%s\""):format(
								item.name,
								item.pattern,
								v8
							)))
						end

						v4 ..= item.prefix .. v8 .. item.suffix
					elseif not v6 then
						error((("Expected \"%s\" to be %s"):format(tostring(item.name), v7 and "an array" or "a string")))
					end
				end
			end
		end

		return v4
	end
end

function PathToRegexp.match(p, p2)
	local v = {}
	local pathToRegexp = PathToRegexp.pathToRegexp(p, v, p2)
	return PathToRegexp.regexpToFunction(pathToRegexp, v, p2)
end

function PathToRegexp.regexpToFunction(object, p, p2)
	local decode = (p2 == nil and {} or p2).decode or function(p3: string)
		return p3
	end

	return function(p3: string)
		local v = object:exec(p3)

		if not v then
			return false
		end

		local path = v[1]
		local index = v.index or 0
		local params = {}

		for i = 2, v.n do
			if v[i] == nil then
				continue
			end

			local v2 = p[i - 1]

			if v2.modifier == "*" or v2.modifier == "+" then
				params[v2.name] = Array.map(string.split(v[i], v2.prefix .. v2.suffix), function(p4)
					return decode(p4, v2)
				end)
			else
				params[v2.name] = decode(v[i], v2)
			end
		end

		return { path = path, index = index, params = params }
	end
end

escapeString = function(value: string)
	return string.gsub(value, "[%.%+%*%?=%^!:${}%(%)%[%]|/\\]", function(p)
		return "\\" .. p
	end)
end

flags = function(p): string
	return if p and p.sensitive then "" else "i"
end

local function arrayToRegexp(p, p2, p3)
	local mapped = Array.map(p, function(p4)
		return PathToRegexp.pathToRegexp(p4, p2, p3).source
	end)

	return RegExp(("(?:%s)"):format(table.concat(mapped, "|")), flags(p3))
end

local function stringToRegexp(p, p2, p3)
	return PathToRegexp.tokensToRegexp(PathToRegexp.parse(p, p3), p2, p3)
end

function PathToRegexp.tokensToRegexp(list, list2, p)
	local v = p == nil and {} or p

	local v2 = v.strict

	if v2 == nil then
		v2 = false
	end

	local start = v.start
	local v3 = start == nil or start

	local end_ = v.end_
	local v4 = end_ == nil or end_

	local encode = v.encode or function(p2: string)
		return p2
	end

	local v5 = not v.endsWith and "$" or ("[%s]|$"):format(escapeString(v.endsWith or ""))
	local formatted = ("[%s]"):format(escapeString(v.delimiter or "/#?"))
	local v6 = v3 and "^" or ""

	for _, item in list do
		if type(item) == "string" then
			v6 ..= escapeString(encode(item))
		else
			local v7 = escapeString(encode(item.prefix))
			local v8 = escapeString(encode(item.suffix))

			if item.pattern and item.pattern ~= "" then
				if list2 then
					table.insert(list2, item)
				end

				if v7 and v7 ~= "" or v8 and v8 ~= "" then
					if item.modifier == "+" or item.modifier == "*" then
						local v9 = item.modifier == "*" and "?" or ""
						v6 ..= ("(?:%s((?:%s)(?:%s%s(?:%s))*)%s)%s"):format(
							v7,
							item.pattern,
							v8,
							v7,
							item.pattern,
							v8,
							v9
						)
					else
						v6 ..= ("(?:%s(%s)%s)%s"):format(v7, item.pattern, v8, item.modifier)
					end
				else
					v6 ..= ("(%s)%s"):format(item.pattern, item.modifier)
				end
			else
				v6 ..= ("(?:%s%s)%s"):format(v7, v8, item.modifier)
			end
		end
	end

	if v4 then
		if not v2 then
			v6 ..= ("%s?"):format(formatted)
		end

		if v.endsWith and v.endsWith ~= "" then
			v6 ..= ("(?=%s)"):format(v5)
		else
			v6 ..= "$"
		end
	else
		local item = list[#list]
		local v7 = item == nil

		if type(item) == "string" then
			v7 = string.find(formatted, item:sub(-1)) ~= nil
		end

		if not v2 then
			v6 ..= string.format("(?:%s(?=%s))?", formatted, v5)
		end

		if not v7 then
			v6 ..= string.format("(?=%s|%s)", formatted, v5)
		end
	end

	return RegExp(v6, flags(v))
end

function PathToRegexp.pathToRegexp(p, p2, p3)
	if Array.isArray(p) then
		return arrayToRegexp(p, p2, p3)
	end

	return stringToRegexp(p, p2, p3)
end

return PathToRegexp
