local scriptParent = script.Parent
local Cryo = require(scriptParent.Cryo)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 7
	-- upvalues: t1 (copy)
	return (setmetatable({
		ids = t1.makeArray(p2),
		delimiter = p3
	}, p1))
end
function t1.setIds(p4, p5) -- line: 14
	-- upvalues: t1 (copy)
	p4.ids = t1.makeArray(p5)
end
function t1.makeArray(p6) -- line: 18
	if type(p6) == "table" then
		return p6
	end

	return { p6 }
end
function t1.__tostring(p7) -- line: 25
	return table.concat(p7.ids, p7.delimiter)
end

local t2 = {}

t2.__index = t2

function t2.new(s1: string, p8) -- line: 54
	-- upvalues: t2 (copy)
	local v15 = s1:gsub("/*$", "")
	local t3 = {
		configurableIds = nil,
		idsDelimiter = ",",
		statusIds = nil,
		baseUrl = v15,
		args = {},
		pathElements = {},
		namedIds = {},
		options = {
			queryArgs = nil,
			postBody = nil,
			headers = nil
		},
		useExpandedForm = {},
		additionalData = p8 or {}
	}

	setmetatable(t3, t2)

	return t3
end
function t2.path(p9, s2: string) -- line: 80
	local v19 = s2:gsub("^/", ""):gsub("/$", "")

	table.insert(p9.pathElements, v19)

	return p9
end
function t2.id(p10, p11, p12) -- line: 87
	-- upvalues: t1 (copy)
	if not p12 and #p10.pathElements < 1 then
		warn("Cannot name id or ids because there is no leading path segment and no name is provided")
	end

	local v23 = p12 or p10.pathElements[#p10.pathElements]

	p10.namedIds[v23] = p11
	p10.configurableIds = t1:new(p11, p10.idsDelimiter)
	table.insert(p10.pathElements, p10.configurableIds)

	return p10
end
function t2.queryArgWithIds(p13, p14, p15) -- line: 99
	-- upvalues: Cryo (copy), t1 (copy)
	local v27 = Cryo.List.join(p15, p13.namedIds[p14] or {})

	p13.namedIds[p14] = v27
	p13.configurableIds = t1:new(v27, p13.idsDelimiter)
	p13.args = Cryo.Dictionary.join(p13.args, {
		[p14] = p13.configurableIds
	})

	return p13
end
function t2.expandedQueryArgsWithIds(p16, p17, p18) -- line: 109
	p16.useExpandedForm[p17] = true
	p16:queryArgWithIds(p17, p18)

	return p16
end
function t2.queryArgs(p19, p20) -- line: 115
	-- upvalues: Cryo (copy)
	p19.args = Cryo.Dictionary.join(p19.args, p20)
	p19.options.queryArgs = Cryo.Dictionary.join(p20, p19.options.queryArgs or {})

	return p19
end
function t2.body(p21, p22) -- line: 121
	p21.options.postBody = p22

	return p21
end
function t2.headers(p23, t4: {[any]: any}) -- line: 126
	p23.options.headers = t4

	return p23
end
function t2.makeKeyMapper(p24) -- line: 131
	return function(p25) -- line: 132
		-- upvalues: p24 (copy)
		return p24:getStatusIds() and p24:makeStatusUrl(p25) or p24:makeNamedIdsUrl(p25)
	end
end
function t2._normalize(_, p27) -- line: 139
	return p27:gsub("/+", "/")
end
function t2.makeUri(p28) -- line: 143
	local s3 = ""

	for _, v in ipairs(p28.pathElements) do
		s3 ..= "/" .. tostring(v)
	end

	return p28:_normalize(s3)
end

local function concatArguments(s4: string, s5: string, p29, b1: boolean?) -- line: 151
	-- upvalues: concatArguments (copy)
	if b1 then
		for _, v in pairs(p29.ids) do
			s4 = concatArguments(s4, s5, v)
		end

		return s4
	end

	local v50 = tostring(s5) .. "=" .. tostring(p29)

	if s4:len() > 1 then
		return s4 .. "&" .. v50
	end

	return v50
end

function t2.makeQueryArgs(p30, p31, b2: boolean?) -- line: 168
	-- upvalues: concatArguments (copy)
	p30:_plugInConfigurableIds(p31)

	local s6 = ""

	for k, v in pairs(p30.args) do
		if b2 and p30.namedIds[k] or not b2 then
			s6 = concatArguments(s6, k, v, p30.useExpandedForm[k])
		end
	end

	if s6:len() > 1 then
		return "?" .. s6
	end

	return ""
end
function t2.makeUrl(p32, p33, b3: boolean?) -- line: 184
	p32:_plugInConfigurableIds(p33)

	return p32.baseUrl .. p32:makeUri() .. p32:makeQueryArgs(p33, b3)
end
function t2.makeStatusUrl(p34, p35) -- line: 190
	local v62 = p34.baseUrl .. p34:makeUri()

	if not p35 then
		return v62
	end

	local v63 = type(p35) == "table" and p35 or { p35 }
	local s7 = ""

	for k, v in pairs(v63) do
		s7 = k > 1 and s7 .. "&" .. v or v
	end

	return v62 .. "?" .. s7
end
function t2.makeNamedIdsUrl(p36, p37) -- line: 205
	return p36:makeUrl(p37, true)
end
function t2.makeOptions(p38) -- line: 209
	return p38.options
end
function t2._plugInConfigurableIds(p39, p40) -- line: 213
	if p40 ~= nil and p39.configurableIds then
		p39.configurableIds:setIds(p40)
	end
end
function t2.getIds(p41) -- line: 219
	if p41.configurableIds and p41.configurableIds.ids then
		return p41.configurableIds.ids
	end

	if p41.statusIds then
		return p41.statusIds
	end

	return {}
end
function t2.getNamedIds(p42) -- line: 229
	return p42.namedIds
end
function t2.setStatusIds(p43, p44) -- line: 233
	-- upvalues: Cryo (copy)
	if p43.configurableIds then
		warn("Cannot set statusIds because ids already provided in URl")

		return p43
	end

	p43.statusIds = Cryo.List.join(p43.statusIds or {}, p44)

	return p43
end
function t2.getStatusIds(p45) -- line: 242
	if p45.configurableIds then
		return nil
	end

	return p45.statusIds
end
function t2.getAdditionalData(p46) -- line: 250
	return p46.additionalData or {}
end

return t2
