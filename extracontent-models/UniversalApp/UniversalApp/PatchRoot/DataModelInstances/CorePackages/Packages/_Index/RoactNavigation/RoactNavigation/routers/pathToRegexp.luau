local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array
local RegExp = require(ParentParent.RegExp)

local function TypeError(p1) -- line: 35
	return p1
end

local t1 = {}
local escapeString = nil
local flags = nil

local function lexer(s1: string) -- line: 65
	local t2 = {}
	local n1 = 1

	local function preIncrement_i(p2) -- line: 72
		-- upvalues: n1 (ref)
		n1 += 1

		return p2
	end
	local function getChar(p3) -- line: 77
		-- upvalues: s1 (copy)
		return (string.sub(s1, p3, p3))
	end

	local v17 = string.len(s1)

	while v17 >= n1 do
		local v18 = string.sub(s1, n1, n1)

		if v18 == "*" or v18 == "+" or v18 == "?" then
			local t3 = {
				type = "MODIFIER",
				index = n1
			}
			local v20 = n1

			n1 += 1
			t3.value = string.sub(s1, v20, v20)
			table.insert(t2, t3)
		elseif v18 == "\\" then
			local t4 = {
				type = "ESCAPED_CHAR"
			}
			local v22 = n1

			n1 += 1
			t4.index = v22

			local v23 = n1

			n1 += 1
			t4.value = string.sub(s1, v23, v23)
			table.insert(t2, t4)
		elseif v18 == "{" then
			local t5 = {
				type = "OPEN",
				index = n1
			}
			local v25 = n1

			n1 += 1
			t5.value = string.sub(s1, v25, v25)
			table.insert(t2, t5)
		elseif v18 == "}" then
			local t6 = {
				type = "CLOSE",
				index = n1
			}
			local v27 = n1

			n1 += 1
			t6.value = string.sub(s1, v27, v27)
			table.insert(t2, t6)
		elseif v18 == ":" then
			local s2 = ""
			local u29 = n1 + 1

			local function preIncrement_j(p4) -- line: 129
				-- upvalues: u29 (ref)
				u29 += 1

				return p4
			end

			while v17 >= u29 do
				local byte = string.byte(s1, u29)

				if (not (byte >= 48) or not (byte <= 57)) and (not (byte >= 65) or not (byte <= 90)) and ((not (byte >= 97) or not (byte <= 122)) and byte ~= 95) then
					break
				end

				local v32 = u29

				u29 += 1
				s2 ..= string.sub(s1, v32, v32)
			end

			if s2 == "" then
				error((("Missing parameter name at %d"):format(n1)))
			end

			table.insert(t2, {
				type = "NAME",
				index = n1,
				value = s2
			})
			n1 = u29
		elseif v18 == "(" then
			local n2 = 1
			local s3 = ""
			local u35 = n1 + 1
			local v36 = u35

			if string.sub(s1, v36, v36) == "?" then
				error((("Pattern cannot start with \"?\" at %d"):format(u35)))
			end

			local function preIncrement_j(p5) -- line: 179
				-- upvalues: u35 (ref)
				u35 += 1

				return p5
			end

			while v17 >= u35 do
				local v38 = u35

				if string.sub(s1, v38, v38) == "\\" then
					local v39 = u35

					u35 += 1

					local v40 = string.sub(s1, v39, v39)
					local v41 = u35

					u35 += 1
					s3 ..= v40 .. string.sub(s1, v41, v41)
				end

				local v42 = u35

				if string.sub(s1, v42, v42) == ")" then
					n2 -= 1

					if n2 == 0 then
						u35 += 1

						break
					end
				else
					local v43 = u35

					if string.sub(s1, v43, v43) == "(" then
						n2 += 1

						local v44 = u35 + 1

						if string.sub(s1, v44, v44) ~= "?" then
							error((("Capturing groups are not allowed at %d"):format(u35)))
						end
					end
				end

				local v45 = u35

				u35 += 1
				s3 ..= string.sub(s1, v45, v45)
			end

			if n2 ~= 0 then
				error((("Unbalanced pattern at %d"):format(n1)))
			end

			if s3 == "" then
				error((("Missing pattern at %d"):format(n1)))
			end

			table.insert(t2, {
				type = "PATTERN",
				index = n1,
				value = s3
			})
			n1 = u35
		else
			local t7 = {
				type = "CHAR",
				index = n1
			}
			local v47 = n1

			n1 += 1
			t7.value = string.sub(s1, v47, v47)
			table.insert(t2, t7)
		end
	end

	table.insert(t2, {
		type = "END",
		value = "",
		index = n1
	})

	return t2
end

function t1.parse(s4: string, t8: {[any]: any}?) -- line: 252
	-- upvalues: lexer (copy), escapeString (ref)
	local v50 = t8 or {}
	local v51 = lexer(s4)
	local s5 = "./"

	if v50.prefixes ~= nil and v50.prefixes ~= "" then
		s5 = v50.prefixes
	end

	local v53 = string.format("[^%s]+?", escapeString(v50.delimiter or "/#?"))
	local t9 = {}
	local n3 = 0
	local n4 = 1
	local s6 = ""

	local function preIncrement_i(p6) -- line: 269
		-- upvalues: n4 (ref)
		n4 += 1

		return p6
	end
	local function preIncrement_key(p7) -- line: 277
		-- upvalues: n3 (ref)
		n3 += 1

		return p7
	end
	local function tryConsume(p8) -- line: 282
		-- upvalues: n4 (ref), v51 (copy)
		if n4 <= #v51 and p8 == v51[n4].type then
			local v140 = v51
			local v141 = n4

			n4 += 1

			return v140[v141].value
		end

		return nil
	end
	local function mustConsume(p9) -- line: 290
		-- upvalues: n4 (ref), v51 (copy)
		local value

		if n4 <= #v51 and p9 == v51[n4].type then
			local v143 = v51
			local v144 = n4

			n4 += 1
			value = v143[v144].value
		else
			value = nil
		end

		if value ~= nil then
			return value
		end

		local v146 = v51[n4]

		if v146 == nil then
			error((("Expected token %s, got nil"):format(p9)))
		end

		local type2 = v146.type
		local index = v146.index

		error((("Unexpected %s at %d, expected %s"):format(type2, index, p9)))
	end
	local function consumeText() -- line: 304
		-- upvalues: n4 (ref), v51 (copy)
		local s7 = ""
		local value

		if n4 <= #v51 and v51[n4].type == "CHAR" then
			local v150 = v51
			local v151 = n4

			n4 += 1
			value = v150[v151].value
		else
			value = nil
		end

		if not value then
			if n4 <= #v51 and v51[n4].type == "ESCAPED_CHAR" then
				local v153 = v51
				local v154 = n4

				n4 += 1
				value = v153[v154].value
			else
				value = nil
			end
		end

		while value and value ~= "" do
			s7 ..= value

			if n4 <= #v51 and v51[n4].type == "CHAR" then
				local v155 = v51
				local v156 = n4

				n4 += 1
				value = v155[v156].value
			else
				value = nil
			end

			if not value then
				if n4 <= #v51 and v51[n4].type == "ESCAPED_CHAR" then
					local v157 = v51
					local v158 = n4

					n4 += 1
					value = v157[v158].value
				else
					value = nil
				end
			end
		end

		return s7
	end

	while n4 <= #v51 do
		local value

		if n4 <= #v51 and v51[n4].type == "CHAR" then
			local v63 = n4

			n4 += 1
			value = v51[v63].value
		else
			value = nil
		end

		local value2

		if n4 <= #v51 and v51[n4].type == "NAME" then
			local v65 = n4

			n4 += 1
			value2 = v51[v65].value
		else
			value2 = nil
		end

		local value3

		if n4 <= #v51 and v51[n4].type == "PATTERN" then
			local v67 = n4

			n4 += 1
			value3 = v51[v67].value
		else
			value3 = nil
		end

		if value2 and value2 ~= "" or value3 and value3 ~= "" then
			local v69 = value or ""

			if string.find(s5, v69) == nil then
				s6 ..= v69
				v69 = ""
			end

			if s6 ~= nil and s6 ~= "" then
				table.insert(t9, s6)
				s6 = ""
			end

			if value2 == nil or value2 == "" then
				value2 = n3
				n3 += 1
			end

			if value3 == nil or value3 == "" then
				value3 = v53
			end

			local t10 = {
				suffix = "",
				name = value2,
				prefix = v69,
				pattern = value3
			}
			local value4

			if n4 <= #v51 and v51[n4].type == "MODIFIER" then
				local v71 = n4

				n4 += 1
				value4 = v51[v71].value
			else
				value4 = nil
			end

			t10.modifier = value4 or ""
			table.insert(t9, t10)
		else
			if not value then
				if n4 <= #v51 and v51[n4].type == "ESCAPED_CHAR" then
					local v73 = n4

					n4 += 1
					value = v51[v73].value
				else
					value = nil
				end
			end

			if value and value ~= "" then
				s6 ..= value
			else
				if s6 and s6 ~= "" then
					table.insert(t9, s6)
					s6 = ""
				end

				local value5

				if n4 <= #v51 and v51[n4].type == "OPEN" then
					local v74 = n4

					n4 += 1
					value5 = v51[v74].value
				else
					value5 = nil
				end

				if value5 and value5 ~= "" then
					local v76 = consumeText()
					local value6

					if n4 <= #v51 and v51[n4].type == "NAME" then
						local v77 = n4

						n4 += 1
						value6 = v51[v77].value
					else
						value6 = nil
					end

					local v79 = value6 or ""
					local value7

					if n4 <= #v51 and v51[n4].type == "PATTERN" then
						local v80 = n4

						n4 += 1
						value7 = v51[v80].value
					else
						value7 = nil
					end

					local v82 = value7 or ""
					local v83 = consumeText()

					mustConsume("CLOSE")

					if v79 == "" and v82 ~= "" then
						v79 = n3
						n3 += 1
					end

					if v79 ~= "" and v79 ~= 0 and (v82 == nil or v82 == "") then
						v82 = v53
					end

					local t11 = {
						name = v79,
						pattern = v82,
						prefix = v76,
						suffix = v83
					}
					local value8

					if n4 <= #v51 and v51[n4].type == "MODIFIER" then
						local v85 = n4

						n4 += 1
						value8 = v51[v85].value
					else
						value8 = nil
					end

					t11.modifier = value8 or ""
					table.insert(t9, t11)
				else
					mustConsume("END")
				end
			end
		end
	end

	return t9
end
function t1.compile(s8: string, p10) -- line: 416
	-- upvalues: t1 (copy)
	return t1.tokensToFunction(t1.parse(s8, p10), p10)
end
function t1.tokensToFunction(t12: {[any]: any}, t13: {[any]: any}?) -- line: 425
	-- upvalues: flags (ref), Array (copy), RegExp (copy)
	if t13 == nil then
		t13 = {}
	end

	local v91 = flags(t13)
	local v92 = t13.encode or function(s9: string) -- line: 431
		return s9
	end
	local validate = t13.validate

	if validate == nil then
		validate = true
	end

	local v94 = Array.map(t12, function(p11) -- line: 440
		-- upvalues: RegExp (copy), v91 (copy)
		if type(p11) == "table" then
			return RegExp(("^(?:%s)$"):format(p11.pattern), v91)
		end

		return nil
	end)

	return function(t14: {[any]: any}?) -- line: 447
		-- upvalues: t12 (copy), Array (copy), v92 (copy), validate (ref), v94 (copy)
		local s10 = ""

		for v163, v164 in t12 do
			if type(v164) ~= "string" then
				local v165 = if not t14 then nil else t14[tostring(v164.name)]
				local v166 = v164.modifier == "?" or v164.modifier == "*"
				local v167 = v164.modifier == "*" or v164.modifier == "+"

				if Array.isArray(v165) then
					if not v167 then
						error((("Expected \"%s\" to not repeat, but got an array"):format(v164.name)))
					end

					if #v165 == 0 then
						if v166 then
							continue
						end

						error((("Expected \"%s\" to not be empty"):format(v164.name)))
					end

					for _, v169 in v165 do
						local v170 = v92(v169, v164)

						if validate and not v94[v163]:test(v170) then
							error((("Expected all \"%s\" to match \"%s\", but got \"%s\""):format(v164.name, v164.pattern, v170)))
						end

						s10 ..= v164.prefix .. v170 .. v164.suffix
					end

					continue
				end

				local v171 = type(v165)

				if v171 == "string" or v171 == "number" then
					local v172 = v92(tostring(v165), v164)

					if validate and not v94[v163]:test(v172) then
						error((("Expected \"%s\" to match \"%s\", but got \"%s\""):format(v164.name, v164.pattern, v172)))
					end

					s10 ..= v164.prefix .. v172 .. v164.suffix
				elseif not v166 then
					local v173 = not v167 and "a string" or "an array"

					error((("Expected \"%s\" to be %s"):format(tostring(v164.name), v173)))
				end

				continue
			end

			s10 ..= v164
		end

		return s10
	end
end
function t1.match(p12, p13) -- line: 554
	-- upvalues: t1 (copy)
	local t15 = {}
	local v98 = t1.pathToRegexp(p12, t15, p13)

	return t1.regexpToFunction(v98, t15, p13)
end
function t1.regexpToFunction(p14, t16: {[any]: any}, t17: {[any]: any}) -- line: 563
	-- upvalues: Array (copy)
	if t17 == nil then
		t17 = {}
	end

	local v102 = t17.decode or function(s11: string) -- line: 567
		return s11
	end

	return function(s12: string) -- line: 571
		-- upvalues: p14 (copy), t16 (copy), Array (copy), v102 (copy)
		local v176 = p14:exec(s12)

		if not v176 then
			return false
		end

		local v177 = v176[1]
		local v178 = v176.index or 0
		local t18 = {}

		for i = 2, v176.n do
			if v176[i] ~= nil then
				local v181 = t16[i - 1]

				if v181.modifier == "*" or v181.modifier == "+" then
					t18[v181.name] = Array.map(string.split(v176[i], v181.prefix .. v181.suffix), function(p15) -- line: 592
						-- upvalues: v102 (copy), v181 (copy)
						return v102(p15, v181)
					end)
				else
					t18[v181.name] = v102(v176[i], v181)
				end
			end
		end

		return {
			path = v177,
			index = v178,
			params = t18
		}
	end
end
function escapeString(s13: string) -- line: 611
	return string.gsub(s13, "[%.%+%*%?=%^!:${}%(%)%[%]|/\\]", function(p16) -- line: 612
		return "\\" .. p16
	end)
end
function flags(t19: {[any]: any}?) -- line: 620
	if t19 and t19.sensitive then
		return ""
	end

	return "i"
end

local function arrayToRegexp(t20: {[any]: any}, t21: {[any]: any}?, p17) -- line: 686
	-- upvalues: Array (copy), t1 (copy), RegExp (copy), flags (ref)
	local v108 = Array.map(t20, function(p18) -- line: 691
		-- upvalues: t1 (copy), t21 (copy), p17 (copy)
		return t1.pathToRegexp(p18, t21, p17).source
	end)

	return RegExp(("(?:%s)"):format(table.concat(v108, "|")), flags(p17))
end
local function stringToRegexp(p19, p20, p21) -- line: 701
	-- upvalues: t1 (copy)
	return t1.tokensToRegexp(t1.parse(p19, p21), p20, p21)
end

function t1.tokensToRegexp(t22: {[any]: any}, t23: {[any]: any}?, t24: {[any]: any}?) -- line: 739
	-- upvalues: escapeString (ref), RegExp (copy), flags (ref)
	local t25 = {}

	if t24 ~= nil then
		t25 = t24
	end

	local strict = t25.strict

	if strict == nil then
		strict = false
	end

	local start = t25.start

	if start == nil then
		start = true
	end

	local end_ = t25.end_

	if end_ == nil then
		end_ = true
	end

	local v119 = t25.encode or function(s14: string) -- line: 756
		return s14
	end
	local v120 = not t25.endsWith and "$" or ("[%s]|$"):format(escapeString(t25.endsWith or ""))
	local v121 = ("[%s]"):format(escapeString(t25.delimiter or "/#?"))
	local v122 = not start and "" or "^"

	for _, v124 in t22 do
		if type(v124) == "string" then
			v122 ..= escapeString(v119(v124))
		else
			local v125 = escapeString(v119(v124.prefix))
			local v126 = escapeString(v119(v124.suffix))

			if v124.pattern and v124.pattern ~= "" then
				if t23 then
					table.insert(t23, v124)
				end

				if v125 and v125 ~= "" or v126 and v126 ~= "" then
					if v124.modifier == "+" or v124.modifier == "*" then
						local v127 = v124.modifier ~= "*" and "" or "?"

						v122 ..= ("(?:%s((?:%s)(?:%s%s(?:%s))*)%s)%s"):format(v125, v124.pattern, v126, v125, v124.pattern, v126, v127)
					else
						v122 ..= ("(?:%s(%s)%s)%s"):format(v125, v124.pattern, v126, v124.modifier)
					end
				else
					v122 ..= ("(%s)%s"):format(v124.pattern, v124.modifier)
				end
			else
				v122 ..= ("(?:%s%s)%s"):format(v125, v126, v124.modifier)
			end
		end
	end

	if end_ then
		if not strict then
			v122 ..= ("%s?"):format(v121)
		end

		v122 = if not t25.endsWith or t25.endsWith == "" then v122 .. "$" else v122 .. ("(?=%s)"):format(v120)
	else
		local v128 = t22[#t22]
		local v129 = v128 == nil

		if type(v128) == "string" then
			v129 = string.find(v121, v128:sub(-1)) ~= nil
		end

		if not strict then
			v122 ..= string.format("(?:%s(?=%s))?", v121, v120)
		end

		if not v129 then
			v122 ..= string.format("(?=%s|%s)", v121, v120)
		end
	end

	return RegExp(v122, flags(t25))
end
function t1.pathToRegexp(p22, t26: {[any]: any}?, p23) -- line: 841
	-- upvalues: Array (copy), arrayToRegexp (copy), stringToRegexp (copy)
	if Array.isArray(p22) then
		return arrayToRegexp(p22, t26, p23)
	end

	return stringToRegexp(p22, t26, p23)
end

return t1
