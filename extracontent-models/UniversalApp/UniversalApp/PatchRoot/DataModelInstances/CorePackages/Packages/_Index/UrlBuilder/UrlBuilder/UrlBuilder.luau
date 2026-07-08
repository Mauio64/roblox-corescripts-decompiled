local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local StringUtilities = require(ParentParent.StringUtilities)
local StringTrim = StringUtilities.StringTrim
local StringSplit = StringUtilities.StringSplit
local encodeURIComponent = require(script.Parent.encodeURIComponent)
local UrlBase = require(script.Parent.UrlBase)
local GameUrlPatterns = require(script.Parent.UrlPatterns.GameUrlPatterns)
local UserUrlPatterns = require(script.Parent.UrlPatterns.UserUrlPatterns)
local StaticUrlPatterns = require(script.Parent.UrlPatterns.StaticUrlPatterns)
local CatalogUrlPatterns = require(script.Parent.UrlPatterns.CatalogUrlPatterns)
local EconomyUrlPatterns = require(script.Parent.UrlPatterns.EconomyUrlPatterns)
local ShareLinksUrlPatterns = require(script.Parent.UrlPatterns.ShareLinksUrlPatterns)
local UserModerationPatterns = require(script.Parent.UrlPatterns.UserModerationPatterns)
local AccountInformationPatterns = require(script.Parent.UrlPatterns.AccountInformationPatterns)
local VirtualEventsUrlPatterns = require(script.Parent.UrlPatterns.VirtualEventsUrlPatterns)
local PlatformAuthPatterns = require(script.Parent.UrlPatterns.PlatformAuthPatterns)
local t1 = {}

local function splitAndTrim(p1, p2, p3) -- line: 28
	-- upvalues: StringSplit (copy), Cryo (copy), StringTrim (copy)
	local v33 = StringSplit(p1, p2, p3)
	local v34 = Cryo.List.map(v33, function(p4) -- line: 30
		-- upvalues: StringTrim (copy)
		return StringTrim(p4)
	end)

	return (Cryo.List.filter(v34, function(p5) -- line: 33
		return #p5 > 0
	end))
end
local function validateValueType(p6) -- line: 44
	local v36 = type(p6)

	if v36 == "string" then
		return true
	end

	if v36 == "number" then
		return true
	end

	if v36 == "table" then
		for _, v in ipairs(p6) do
			local v39 = type(v)

			if v39 ~= "string" and v39 ~= "number" then
				return false
			end
		end

		return true
	end

	return false
end
local function assertPlaceholder(p7) -- line: 64
	if string.sub(p7, 1, 1) == "{" then
		assert(string.sub(p7, -1, -1) == "}", "invalid pattern: placeholder items should end with `}`")
	end
end
local function assertElementIsValid(p8, p9) -- line: 71
	-- upvalues: validateValueType (copy)
	assert(type(p8) == "table", "invalid pattern: elements should all be tables")

	if p9 then
		assert(type(p8.name) == "string", "invalid pattern: element name should be a string")
		assert(#p8.name > 0, "invalid pattern: element name should not be empty")
	end

	assert(type(p8.value) == "string" or type(p8.value) == "number", "invalid pattern: element value should be a string or number")

	if type(p8.value) == "string" then
		local value = p8.value

		if string.sub(value, 1, 1) == "{" then
			assert(string.sub(value, -1, -1) == "}", "invalid pattern: placeholder items should end with `}`")
		end
	end

	if p8.optional ~= nil then
		assert(type(p8.optional) == "boolean", "invalid pattern: element optional should be a boolean")
	end

	if p8.default ~= nil then
		assert(validateValueType(p8.default), "invalid pattern: element default should be a string, number, or a table of strings and numbers only")
	end

	if p8.collect ~= nil then
		assert(p8.collect == "multi" or p8.collect == "csv", "invalid pattern: element optional should be one of `multi`, `csv`")
	end
end
local function assertPatternIsValid(p10) -- line: 102
	-- upvalues: assertElementIsValid (copy)
	assert(type(p10.base) == "string", "invalid pattern: base should be a string")
	assert(#p10.base > 0, "invalid pattern: base should not be empty")
	assert(type(p10.path) == "table", "invalid pattern: path should be a table")

	for _, v in ipairs(p10.path) do
		assertElementIsValid(v, false)
	end

	if p10.query ~= nil then
		assert(type(p10.query) == "table", "invalid pattern: query should be a table")
	end

	if type(p10.query) == "table" then
		for _, v in ipairs(p10.query) do
			assertElementIsValid(v, true)
		end
	end

	if p10.hash ~= nil then
		assert(type(p10.hash) == "table", "invalid pattern: hash should be a table")
	end
end
local function buildElementsFromString(p11, p12) -- line: 127
	-- upvalues: splitAndTrim (copy), Cryo (copy), StringTrim (copy), StringSplit (copy)
	local v51 = not p12 and "/" or "&"
	local v52 = splitAndTrim(p11, v51)

	return (Cryo.List.map(v52, function(p13) -- line: 130
		-- upvalues: StringTrim (copy), p12 (copy), StringSplit (copy)
		local v102 = nil
		local v103 = StringTrim(p13)
		local v104 = nil
		local v105 = nil
		local s1 = nil

		if p12 then
			local v107 = StringSplit(v103, "=", 2)

			v102 = StringTrim(v107[1])
			v103 = v107[2]

			if string.sub(v102, 1, 1) == "{" then
				local v108 = StringTrim(v102, "{}")
				local v109 = StringSplit(v108, "|", 2)[1]

				if v103 == nil then
					v103 = v107[1]
				end

				v102 = StringTrim(v109)
			end

			s1 = "multi"
		end

		if v103 ~= nil and string.find(v103, "^{.*}$") then
			local v110 = StringTrim(v103, "{}")
			local v111 = StringSplit(v110, "|", 2)
			local v112 = StringTrim(v111[1])

			if #v111 > 1 then
				v104 = true

				if #v111[2] > 1 then
					v105 = v111[2]
				end
			end

			v103 = "{" .. v112 .. "}"
		end

		return {
			name = v102,
			value = v103,
			optional = v104,
			default = v105,
			collect = s1
		}
	end))
end
local function buildQueryStringFromTable(p14) -- line: 173
	local t2 = {}

	for k, v in pairs(p14) do
		table.insert(t2, k .. "=" .. v)
	end

	return table.concat(t2, "&")
end
local function simplifyPattern(p15) -- line: 182
	-- upvalues: UrlBase (copy), splitAndTrim (copy), Cryo (copy), StringTrim (copy), StringSplit (copy), buildQueryStringFromTable (copy)
	local base = p15.base
	local path = p15.path
	local query = p15.query
	local hash = p15.hash

	if base ~= nil and UrlBase[string.upper(base)] ~= nil then
		base = UrlBase[string.upper(base)]
	end

	if type(path) == "string" then
		local v62 = splitAndTrim(path, "/")
		local v63 = false

		path = Cryo.List.map(v62, function(p16) -- line: 130
			-- upvalues: StringTrim (copy), v63 (copy), StringSplit (copy)
			local v114 = nil
			local v115 = StringTrim(p16)
			local v116 = nil
			local v117 = nil
			local s2 = nil

			if v63 then
				local v119 = StringSplit(v115, "=", 2)

				v114 = StringTrim(v119[1])
				v115 = v119[2]

				if string.sub(v114, 1, 1) == "{" then
					local v120 = StringTrim(v114, "{}")
					local v121 = StringSplit(v120, "|", 2)[1]

					if v115 == nil then
						v115 = v119[1]
					end

					v114 = StringTrim(v121)
				end

				s2 = "multi"
			end

			if v115 ~= nil and string.find(v115, "^{.*}$") then
				local v122 = StringTrim(v115, "{}")
				local v123 = StringSplit(v122, "|", 2)
				local v124 = StringTrim(v123[1])

				if #v123 > 1 then
					v116 = true

					if #v123[2] > 1 then
						v117 = v123[2]
					end
				end

				v115 = "{" .. v124 .. "}"
			end

			return {
				name = v114,
				value = v115,
				optional = v116,
				default = v117,
				collect = s2
			}
		end)
	end

	if type(query) == "table" and query[1] == nil then
		query = buildQueryStringFromTable(query)
	end

	if type(query) == "string" then
		local v64 = splitAndTrim(query, "&")
		local v65 = true

		query = Cryo.List.map(v64, function(p17) -- line: 130
			-- upvalues: StringTrim (copy), v65 (copy), StringSplit (copy)
			local v126 = nil
			local v127 = StringTrim(p17)
			local v128 = nil
			local v129 = nil
			local s3 = nil

			if v65 then
				local v131 = StringSplit(v127, "=", 2)

				v126 = StringTrim(v131[1])
				v127 = v131[2]

				if string.sub(v126, 1, 1) == "{" then
					local v132 = StringTrim(v126, "{}")
					local v133 = StringSplit(v132, "|", 2)[1]

					if v127 == nil then
						v127 = v131[1]
					end

					v126 = StringTrim(v133)
				end

				s3 = "multi"
			end

			if v127 ~= nil and string.find(v127, "^{.*}$") then
				local v134 = StringTrim(v127, "{}")
				local v135 = StringSplit(v134, "|", 2)
				local v136 = StringTrim(v135[1])

				if #v135 > 1 then
					v128 = true

					if #v135[2] > 1 then
						v129 = v135[2]
					end
				end

				v127 = "{" .. v136 .. "}"
			end

			return {
				name = v126,
				value = v127,
				optional = v128,
				default = v129,
				collect = s3
			}
		end)
	end

	if type(hash) == "string" then
		local v66 = splitAndTrim(hash, "/")
		local v67 = false

		hash = Cryo.List.map(v66, function(p18) -- line: 130
			-- upvalues: StringTrim (copy), v67 (copy), StringSplit (copy)
			local v138 = nil
			local v139 = StringTrim(p18)
			local v140 = nil
			local v141 = nil
			local s4 = nil

			if v67 then
				local v143 = StringSplit(v139, "=", 2)

				v138 = StringTrim(v143[1])
				v139 = v143[2]

				if string.sub(v138, 1, 1) == "{" then
					local v144 = StringTrim(v138, "{}")
					local v145 = StringSplit(v144, "|", 2)[1]

					if v139 == nil then
						v139 = v143[1]
					end

					v138 = StringTrim(v145)
				end

				s4 = "multi"
			end

			if v139 ~= nil and string.find(v139, "^{.*}$") then
				local v146 = StringTrim(v139, "{}")
				local v147 = StringSplit(v146, "|", 2)
				local v148 = StringTrim(v147[1])

				if #v147 > 1 then
					v140 = true

					if #v147[2] > 1 then
						v141 = v147[2]
					end
				end

				v139 = "{" .. v148 .. "}"
			end

			return {
				name = v138,
				value = v139,
				optional = v140,
				default = v141,
				collect = s4
			}
		end)
	end

	return {
		base = base,
		path = path,
		query = query,
		hash = hash
	}
end
local function concatValues(p19, p20) -- line: 214
	-- upvalues: Cryo (copy), splitAndTrim (copy)
	local v70 = Cryo.List.filter(p19, function(p21) -- line: 216
		-- upvalues: p20 (copy), splitAndTrim (copy)
		if p20 then
			return #splitAndTrim(p21, "=") > 1
		end

		return #p21 > 0
	end)
	local v71 = not p20 and "/" or "&"

	return table.concat(v70, v71)
end
local function resolveElement(p22, p23, p24) -- line: 227
	-- upvalues: validateValueType (copy), Cryo (copy), encodeURIComponent (copy), concatValues (copy)
	if p23 == nil then
		p23 = {}
	end

	local v75

	if type(p22.value) == "string" and string.sub(p22.value, 1, 1) == "{" then
		v75 = p23[string.sub(p22.value, 2, -2)]

		if v75 == nil then
			v75 = p22.default
		end

		if not p22.optional then
			assert(v75 ~= nil, "UrlBuilder: missing parameter: `" .. p22.value .. "`")
		end

		if v75 == nil then
			v75 = {}
		end

		assert(validateValueType(v75), "UrlBuilder: invalid parameter: `" .. p22.value .. "`, " .. "should be a string, number, or a table of strings and numbers only")
	else
		v75 = p22.value
	end

	if type(v75) ~= "table" then
		v75 = { v75 }
	end

	local v76 = Cryo.List.map(v75, function(p25) -- line: 257
		-- upvalues: encodeURIComponent (copy)
		return encodeURIComponent((tostring(p25)))
	end)

	if p24 then
		if p22.collect == "csv" then
			v76 = { table.concat(v76, "%2C") }
		end

		v76 = Cryo.List.map(v76, function(p26) -- line: 265
			-- upvalues: encodeURIComponent (copy), p22 (copy)
			return encodeURIComponent(p22.name) .. "=" .. p26
		end)
	end

	return concatValues(v76, p24)
end
local function resolveElementList(p27, p28, p29) -- line: 272
	-- upvalues: Cryo (copy), resolveElement (copy), concatValues (copy)
	local v80 = Cryo.List.map(p27 or {}, function(p30) -- line: 273
		-- upvalues: resolveElement (copy), p28 (copy), p29 (copy)
		return resolveElement(p30, p28, p29)
	end)

	return concatValues(v80, p29)
end

function t1.new(p31) -- line: 308
	-- upvalues: simplifyPattern (copy), assertPatternIsValid (copy), StringTrim (copy), resolveElementList (copy)
	local u82 = simplifyPattern(p31)

	assertPatternIsValid(u82)

	return function(p32, p33) -- line: 311
		-- upvalues: StringTrim (copy), u82 (ref), resolveElementList (copy)
		local v155 = StringTrim(u82.base, "/", {
			right = true
		})
		local v156 = resolveElementList(u82.path, p32, false)

		if #v156 > 0 then
			v155 ..= "/" .. v156
		end

		if string.match(v155, "[^/]/[^/]") == nil then
			v155 ..= "/"
		end

		local v157 = resolveElementList(u82.query, p32, true)

		if #v157 > 0 then
			v155 ..= "?" .. v157
		end

		local v158 = resolveElementList(u82.hash, p32, false)

		if #v158 > 0 then
			v155 ..= "#" .. v158
		end

		if p33 then
			if v155 ~= p33 then
				warn("UrlBuilder: unexpected output for pattern:")
				warn("UrlBuilder: expected `" .. p33 .. "`")
				warn("UrlBuilder: actual `" .. v155 .. "`")
			end

			return p33
		end

		return v155
	end
end
function t1.fromString(p34) -- line: 347
	-- upvalues: StringSplit (copy), t1 (copy), StringTrim (copy)
	local v84 = StringSplit(p34, ":", 2)

	if #v84 < 2 then
		v84 = {
			"",
			v84[1]
		}
	end

	local v85 = v84[1]
	local v86 = StringSplit(v84[2], "%#", 2)
	local v87 = v86[2] or ""
	local v88 = StringSplit(v86[1], "%?", 2)
	local v89 = v88[1] or ""
	local v90 = v88[2] or ""

	if string.sub(v89, 1, 2) == "//" then
		local v91 = StringSplit(string.sub(v89, 3), "/", 2)

		v85 ..= "://" .. v91[1]
		v89 = v91[2] or "/"
	end

	return t1.new({
		base = StringTrim(v85),
		path = StringTrim(v89),
		query = StringTrim(v90),
		hash = StringTrim(v87)
	})
end
function t1.addQueryString(p35, p36) -- line: 376
	-- upvalues: StringTrim (copy), Cryo (copy), t1 (copy)
	local v94 = StringTrim(p35)
	local v95 = string.find(v94, "%?")

	if v95 == nil then
		v94 ..= "?"
	elseif v95 < #v94 then
		v94 ..= "&"
	end

	local v96 = Cryo.Dictionary.keys(p36)
	local v97 = Cryo.List.map(v96, function(p37) -- line: 385
		return "{" .. p37 .. "}"
	end)
	local v98 = v94 .. table.concat(v97, "&")

	return t1.fromString(v98)(p36)
end

t1.game = GameUrlPatterns(t1)
t1.user = UserUrlPatterns(t1)
t1.catalog = CatalogUrlPatterns(t1)
t1.static = StaticUrlPatterns(t1)
t1.usermoderation = UserModerationPatterns(t1)
t1.accountinformation = AccountInformationPatterns(t1)
t1.sharelinks = ShareLinksUrlPatterns(t1)
t1.economy = EconomyUrlPatterns(t1)
t1.virtualevents = VirtualEventsUrlPatterns(t1)
t1.PlatformAuth = PlatformAuthPatterns(t1)

return t1
