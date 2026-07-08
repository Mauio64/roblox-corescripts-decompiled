local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local String = LuauPolyfill.String
local Number = LuauPolyfill.Number
local RegExp = require(ParentParent.RegExp)

local function TypeError(p1) -- line: 28
	return p1
end
local function encodeURIComponent(p2) -- line: 32
	-- upvalues: HttpService (copy)
	return HttpService:UrlEncode(p2)
end
local function strictUriEncode(s1: string) -- line: 36
	-- upvalues: HttpService (copy)
	return HttpService:UrlEncode(s1):gsub("[!'%(%)%*]", function(p3) -- line: 37
		return ("%%%x"):format(p3:byte()):upper()
	end)
end

local decodeURIComponent = require(scriptParent.decodeURIComponent)
local splitOnFirst = require(scriptParent.splitOnFirst)
local encode = nil
local decode = nil
local t1 = {}

local function newNumber(p4) -- line: 51
	return tonumber(p4) or (0/0)
end
local function encoderForArrayFormat(p5) -- line: 55
	-- upvalues: Array (copy), encode (ref)
	local arrayFormat = p5.arrayFormat

	if arrayFormat == "index" then
		return function(p6) -- line: 58
			-- upvalues: p5 (copy), Array (copy), encode (ref)
			return function(p7, p8) -- line: 59
				-- upvalues: p5 (copy), Array (copy), encode (ref), p6 (copy)
				local v127 = #p7

				if p5.skipNull and p8 == nil then
					return p7
				end

				if p8 == nil then
					return Array.concat(p7, { table.concat({
						encode(p6, p5),
						"[",
						v127,
						"]"
					}, "") })
				end

				return Array.concat(p7, { table.concat({
					encode(p6, p5),
					"[",
					encode(v127, p5),
					"]=",
					encode(p8, p5)
				}, "") })
			end
		end
	end

	if arrayFormat == "bracket" then
		return function(p9) -- line: 88
			-- upvalues: p5 (copy), Array (copy), encode (ref)
			return function(p10, p11) -- line: 89
				-- upvalues: p5 (copy), Array (copy), encode (ref), p9 (copy)
				if p5.skipNull and p11 == nil then
					return p10
				end

				if p11 == nil then
					return Array.concat(p10, { table.concat({
						encode(p9, p5),
						"[]"
					}, "") })
				end

				return Array.concat(p10, { table.concat({
					encode(p9, p5),
					"[]=",
					encode(p11, p5)
				}, "") })
			end
		end
	end

	if arrayFormat == "comma" or arrayFormat == "separator" then
		return function(p12) -- line: 106
			-- upvalues: encode (ref), p5 (copy)
			return function(p13, p14) -- line: 107
				-- upvalues: encode (ref), p12 (copy), p5 (copy)
				if p14 == nil or #p14 == 0 then
					return p13
				end

				if #p13 == 0 then
					return { table.concat({
						encode(p12, p5),
						"=",
						encode(p12, p5)
					}, "") }
				end

				return { table.concat({
					p13,
					encode(p12, p5)
				}, p5.arrayFormatSeparator) }
			end
		end
	end

	return function(p15) -- line: 124
		-- upvalues: p5 (copy), Array (copy), encode (ref)
		return function(p16, p17) -- line: 125
			-- upvalues: p5 (copy), Array (copy), encode (ref), p15 (copy)
			if p5.skipNull and p17 == nil then
				return p16
			end

			if p17 == nil then
				return Array.concat(p16, { encode(p15, p5) })
			end

			return Array.concat(p16, { table.concat({
				encode(p15, p5),
				"=",
				encode(p17, p5)
			}, "") })
		end
	end
end
local function parserForArrayFormat(p18) -- line: 142
	-- upvalues: RegExp (copy), Array (copy), decode (ref)
	local u35 = nil
	local arrayFormat = p18.arrayFormat

	if arrayFormat == "index" then
		return function(p19, p20, p21) -- line: 146
			-- upvalues: u35 (ref), RegExp (copy)
			u35 = RegExp("\\[(\\d*)\\]$"):exec(p19)

			local v104 = p19:gsub("%[%d*%]$", "")

			if not u35 then
				p21[v104] = p20

				return
			end

			if p21[v104] == nil then
				p21[v104] = {}
			end

			p21[v104][u35[2]] = p20
		end
	end

	if arrayFormat == "bracket" then
		return function(p22, p23, p24) -- line: 163
			-- upvalues: u35 (ref), RegExp (copy), Array (copy)
			u35 = RegExp("(\\[\\])$"):exec(p22)

			local v108 = p22:gsub("%[%]$", "")

			if not u35 then
				p24[v108] = p23

				return
			end

			if p24[v108] == nil then
				p24[v108] = { p23 }

				return
			end

			p24[v108] = Array.concat({}, p24[v108], p23)
		end
	end

	if arrayFormat == "comma" or arrayFormat == "separator" then
		return function(p25, p26, p27) -- line: 180
			-- upvalues: p18 (copy), Array (copy), decode (ref)
			local v112 = nil

			if type(p26) == "string" and string.find(p26, p18.arrayFormatSeparator, 1, true) ~= nil then
				v112 = Array.map(p26:split(p18.arrayFormatSeparator), function(p28) -- line: 185
					-- upvalues: decode (ref), p18 (copy)
					return decode(p28, p18)
				end)
			elseif p26 ~= nil then
				v112 = decode(p26, p18)
			end

			p27[p25] = v112
		end
	end

	return function(p29, p30, p31) -- line: 196
		-- upvalues: Array (copy)
		if p31[p29] == nil then
			p31[p29] = p30

			return
		end

		p31[p29] = Array.concat({}, p31[p29], p30)
	end
end
local function validateArrayFormatSeparator(p32) -- line: 207
	if type(p32) ~= "string" or #p32 ~= 1 then
		error("arrayFormatSeparator must be single character string")
	end
end

function encode(p33, p34) -- line: 213
	-- upvalues: strictUriEncode (copy), encodeURIComponent (copy)
	if p34.encode then
		if p34.strict then
			return strictUriEncode(p33)
		end

		return encodeURIComponent(p33)
	end

	return p33
end
function decode(p35, p36) -- line: 225
	-- upvalues: decodeURIComponent (copy)
	if p36.decode then
		return decodeURIComponent(p35)
	end

	return p35
end

local function keysSorter(p37) -- line: 233
	-- upvalues: Array (copy), keysSorter (copy), Object (copy)
	if Array.isArray(p37) then
		return Array.sort(p37)
	end

	if type(p37) == "table" then
		return Array.map(Array.sort(keysSorter(Object.keys(p37)), function(p38, p39) -- line: 239
			return (tonumber(p38) or (0/0)) - (tonumber(p39) or (0/0))
		end), function(p40) -- line: 242
			-- upvalues: p37 (copy)
			return p37[p40]
		end)
	end

	return p37
end
local function removeHash(p41) -- line: 251
	local v44 = p41:find("#")

	if v44 ~= nil then
		p41 = p41:sub(1, v44 - 1)
	end

	return p41
end
local function getHash(p42) -- line: 260
	local s2 = ""
	local v47 = p42:find("#")

	if v47 ~= nil then
		s2 = p42:sub(v47)
	end

	return s2
end
local function parseValue(p43, p44) -- line: 280
	-- upvalues: Number (copy), String (copy)
	if p44.parseNumbers and (not Number.isNaN(tonumber(p43) or (0/0)) and type(p43) == "string" and String.trim(p43) ~= "") then
		return tonumber(p43) or (0/0)
	end

	if p44.parseBooleans and p43 ~= nil and (string.lower(p43) == "true" or string.lower(p43) == "false") then
		p43 = string.lower(p43) == "true"
	end

	return p43
end
local function parse(p45, p46) -- line: 299
	-- upvalues: Object (copy), parserForArrayFormat (copy), String (copy), splitOnFirst (copy), decode (ref), parseValue (copy), Array (copy), Boolean (copy), keysSorter (copy)
	local v55 = Object.assign({
		decode = true,
		sort = true,
		arrayFormat = "none",
		arrayFormatSeparator = ",",
		parseNumbers = false,
		parseBooleans = false
	}, p46)
	local arrayFormatSeparator = v55.arrayFormatSeparator

	if type(arrayFormatSeparator) ~= "string" or #arrayFormatSeparator ~= 1 then
		error("arrayFormatSeparator must be single character string")
	end

	local v57 = parserForArrayFormat(v55)
	local t2 = {}

	if type(p45) ~= "string" then
		return t2
	end

	local v59 = string.gsub(String.trim(p45), "^[%?#&]", "")

	if v59 == "" then
		return t2
	end

	for _, v61 in v59:split("&") do
		local v62 = splitOnFirst(if not v55.decode then v61 else string.gsub(v61, "%+", " "), "=")
		local v63 = v62[1]
		local v64 = v62[2]

		if v64 ~= nil and v55.arrayFormat ~= "comma" then
			v64 = decode(v64, v55)
		end

		v57(decode(v63, v55), v64, t2)
	end

	for v65 in t2 do
		local v66 = t2[v65]

		if type(v66) == "table" then
			for v67 in v66 do
				v66[v67] = parseValue(v66[v67], v55)
			end
		else
			t2[v65] = parseValue(v66, v55)
		end
	end

	if v55.sort == false then
		return t2
	end

	local v68 = if v55.sort ~= true then Array.sort(Object.keys(t2), v55.sort) else Array.sort(Object.keys(t2))

	return Array.reduce(v68, function(p47, p48) -- line: 363
		-- upvalues: t2 (copy), Boolean (copy), Array (copy), keysSorter (copy)
		local v121 = t2[p48]

		if Boolean.toJSBoolean(v121) and type(v121) == "table" and not Array.isArray(v121) then
			p47[p48] = keysSorter(v121)

			return p47
		end

		p47[p48] = v121

		return p47
	end, {})
end

function t1.extract(p49) -- line: 270
	local v49 = p49:find("#")

	if v49 ~= nil then
		p49 = p49:sub(1, v49 - 1)
	end

	local v50 = p49:find("?", 1, true)

	if v50 == nil then
		return ""
	end

	return p49:sub(v50 + 1)
end

t1.parse = parse

function t1.stringify(p50, p51) -- line: 380
	-- upvalues: Object (copy), encoderForArrayFormat (copy), Array (copy), encode (ref)
	if not p50 then
		return ""
	end

	local u71 = Object.assign({
		encode = true,
		strict = true,
		arrayFormat = "none",
		arrayFormatSeparator = ","
	}, p51)
	local arrayFormatSeparator = u71.arrayFormatSeparator

	if type(arrayFormatSeparator) ~= "string" or #arrayFormatSeparator ~= 1 then
		error("arrayFormatSeparator must be single character string")
	end

	local v73 = encoderForArrayFormat(u71)
	local v74 = table.clone(p50)
	local v75 = Object.keys(v74)

	if u71.sort ~= false then
		Array.sort(v75, u71.sort)
	end

	return table.concat(Array.filter(Array.map(v75, function(p52) -- line: 414
		-- upvalues: p50 (copy), encode (ref), u71 (ref), Array (copy), v73 (copy)
		local v123 = p50[p52]

		if v123 == nil then
			return encode(p52, u71)
		end

		if Array.isArray(v123) then
			return table.concat(Array.reduce(v123, v73(p52), {}), "&")
		end

		return encode(p52, u71) + "=" + encode(v123, u71)
	end), function(p53) -- line: 430
		return p53.length > 0
	end), "&")
end
function t1.parseUrl(p54, p55) -- line: 438
	-- upvalues: parse (copy)
	local t3 = {}
	local v79 = p54
	local v80 = v79:find("#")

	if v80 ~= nil then
		v79 = v79:sub(1, v80 - 1)
	end

	t3.url = v79:split("?")[1] or ""

	local v81 = parse
	local v82 = p54:find("#")

	if v82 ~= nil then
		p54 = p54:sub(1, v82 - 1)
	end

	local v83 = p54:find("?", 1, true)

	t3.query = v81(if v83 ~= nil then p54:sub(v83 + 1) else "", p55)

	return t3
end
function t1.stringifyUrl(p56, p57) -- line: 445
	-- upvalues: t1 (copy), Object (copy)
	local url = p56.url
	local v87 = url:find("#")

	if v87 ~= nil then
		url = url:sub(1, v87 - 1)
	end

	local v88 = url:split("?")[1] or ""
	local v89 = t1.extract(p56.url)
	local v90 = t1.parse(v89)
	local url2 = p56.url
	local s3 = ""
	local v93 = url2:find("#")

	if v93 ~= nil then
		s3 = url2:sub(v93)
	end

	local v94 = Object.assign(v90, p56.query)
	local v95 = t1.stringify(v94, p57)

	if v95 then
		v95 = ("?%s"):format(v95)
	end

	return ("%s%s%s"):format(v88, v95, s3)
end

return t1
