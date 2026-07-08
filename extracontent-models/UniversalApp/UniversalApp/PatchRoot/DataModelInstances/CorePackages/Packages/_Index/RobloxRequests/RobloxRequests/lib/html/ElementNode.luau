local t1 = {}

t1.mt = {
	__index = t1
}

function t1.new(_, p2) -- line: 5
	-- upvalues: t1 (copy)
	local t2 = {}
	local v9 = nil

	if getmetatable(p2) == t1.mt then
		v9 = true
	end

	if type(p2) == "table" then
		if not v9 and #p2 > 0 then
			for _, v in ipairs(p2) do
				t2[v] = true
			end
		else
			for k in pairs(p2) do
				t2[k] = true
			end
		end
	elseif p2 ~= nil then
		t2 = {
			[p2] = true
		}
	end

	return (setmetatable(t2, t1.mt))
end
function t1.add(p3, p4) -- line: 22
	if p4 ~= nil then
		p3[p4] = true
	end

	return p3
end
function t1.remove(p5, p6) -- line: 28
	if p6 ~= nil then
		p5[p6] = nil
	end

	return p5
end
function t1.tolist(p7) -- line: 34
	local t3 = {}

	for k in pairs(p7) do
		table.insert(t3, k)
	end

	return t3
end

t1.to_list = t1.tolist

function t1.mt.__add(p8, p9) -- line: 42
	-- upvalues: t1 (copy)
	local v22 = t1:new()
	local v23 = t1:new(p8)
	local v24 = t1:new(p9)

	for k in pairs(v23) do
		v22[k] = true
	end

	for k in pairs(v24) do
		v22[k] = true
	end

	return v22
end
function t1.mt.__sub(p10, p11) -- line: 50
	-- upvalues: t1 (copy)
	local v29 = t1:new()
	local v30 = t1:new(p10)
	local v31 = t1:new(p11)

	for k in pairs(v30) do
		v29[k] = true
	end

	for k in pairs(v31) do
		v29[k] = nil
	end

	return v29
end
function t1.mt.__mul(p12, p13) -- line: 58
	-- upvalues: t1 (copy)
	local v36 = t1:new()
	local v37 = t1:new(p12)
	local v38 = t1:new(p13)

	for k in pairs(v37) do
		v36[k] = v38[k]
	end

	return v36
end
function t1.mt.__tostring(p14) -- line: 65
	local s1 = "{"
	local s2 = ""

	for k in pairs(p14) do
		s1 ..= s2 .. tostring(k)
		s2 = ", "
	end

	return s1 .. "}"
end

local t4 = {}

t4.mt = {
	__index = t4
}

function t4.new(_, p16, p17, p18, p19, p20, p21) -- line: 77
	-- upvalues: t1 (copy), t4 (copy)
	local t5 = {
		level = 0,
		parent = nil,
		root = nil,
		id = nil,
		index = p16,
		name = p17,
		nodes = {},
		_openstart = p20,
		_openend = p21,
		_closestart = p20,
		_closeend = p21,
		attributes = {},
		classes = {},
		deepernodes = t1:new(),
		deeperelements = {},
		deeperattributes = {},
		deeperids = {},
		deeperclasses = {}
	}

	t5.attrs = t5.attributes
	t5.children = t5.nodes
	t5.descendants = t5.deepernodes
	t5.descendant_elements = t5.deeperelements
	t5.descendant_attrs = t5.deeperattributes
	t5.descendent_ids = t5.deeperids
	t5.descendant_classes = t5.deeperclasses

	if not p18 then
		t5.name = "root"
		t5.root = t5
		t5._text = p17

		local v52 = string.len(p17)

		t5._openstart = 1
		t5._openend = v52
		t5._closestart = 1
		t5._closeend = v52
	elseif p19 then
		t5.root = p18.root
		t5.parent = p18
		t5.level = p18.level + 1
		table.insert(p18.nodes, t5)
	else
		t5.root = p18.root
		t5.parent = p18.parent or p18
		t5.level = p18.level
		table.insert(p18.parent and p18.parent.nodes or p18.nodes, t5)
	end

	return (setmetatable(t5, t4.mt))
end
function t4.text(p22) -- line: 128
	return (string.sub(p22.root._text, p22._openstart, p22._closeend))
end

t4.gettext = t4.text

function t4.settext(p23, p24) -- line: 133
	p23.root._text = p24
end
function t4.textonly(p25) -- line: 135
	return (p25:text():gsub("<[^>]*>", ""))
end
function t4.content(p26) -- line: 137
	return (string.sub(p26.root._text, p26._openend + 1, p26._closestart - 1))
end

t4.getcontent = t4.content

function t4.addattribute(p27, p28, p29) -- line: 142
	p27.attributes[p28] = p29

	if string.lower(p28) == "id" then
		p27.id = p29

		return
	end

	if string.lower(p28) == "class" then
		for match in string.gmatch(p29, "%S+") do
			table.insert(p27.classes, match)
		end
	end
end
function t4.links(p30) -- line: 154
	local t6 = {}

	for _, v in ipairs(p30:select("a[href]")) do
		if #v.attributes.href > 0 then
			table.insert(t6, v.attributes.href)
		end
	end

	return t6
end
function t4.absolutelinks(p31, p32) -- line: 166
	local v68 = (p32 or (p31.page_url or "")):split("?")[1]:split("#")[1]
	local parts = v68:split("://")
	local v70 = parts[#parts]:split("/")[1]
	local v71 = v68:find("://") and v68:split("://")[1] or "http"

	while v68:sub(-1, -1) == "/" do
		v68 = v68:sub(1, -2)
	end

	local t7 = {}

	for _, v in ipairs(p31:select("a[href]")) do
		if #v.attributes.href > 0 then
			local href = v.attributes.href

			if not href:find("://") then
				href = if href:sub(1, 2) ~= "//" then if href:sub(1, 1) ~= "/" then v68 .. "/" .. href else v71 .. "://" .. v70 .. href else v71 .. ":" .. href
			end

			table.insert(t7, href)
		end
	end

	return t7
end

t4.absolute_links = t4.absolutelinks

local function insert(p33, p34, p35) -- line: 208
	-- upvalues: t1 (copy)
	p33[p34] = p33[p34] or t1:new()
	p33[p34]:add(p35)
end

function t4.close(p36, p37, p38) -- line: 213
	-- upvalues: t1 (copy)
	if p37 and p38 then
		p36._closestart = p37
		p36._closeend = p38
	end

	local v82 = p36

	while true do
		v82 = v82.parent

		if not v82 then
			break
		end

		v82.deepernodes:add(p36)

		local deeperelements = v82.deeperelements
		local name = p36.name

		deeperelements[name] = deeperelements[name] or t1:new()
		deeperelements[name]:add(p36)

		for k in pairs(p36.attributes) do
			local deeperattributes = v82.deeperattributes

			deeperattributes[k] = deeperattributes[k] or t1:new()
			deeperattributes[k]:add(p36)
		end

		if p36.id then
			local deeperids = v82.deeperids
			local id = p36.id

			deeperids[id] = deeperids[id] or t1:new()
			deeperids[id]:add(p36)
		end

		for _, v in ipairs(p36.classes) do
			local deeperclasses = v82.deeperclasses

			deeperclasses[v] = deeperclasses[v] or t1:new()
			deeperclasses[v]:add(p36)
		end
	end
end

local function escape(p39) -- line: 234
	return string.gsub(p39, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end
local function select(p40, p41) -- line: 239
	-- upvalues: t1 (copy), escape (copy)
	if not p41 or (type(p41) ~= "string" or p41 == "") then
		return t1:new()
	end

	local t8 = {
		[""] = p40.deeperelements,
		["["] = p40.deeperattributes,
		["#"] = p40.deeperids,
		["."] = p40.deeperclasses
	}

	local function match(p42, p43) -- line: 247
		-- upvalues: t1 (copy), t8 (copy), p40 (copy), escape (copy)
		local v120 = nil
		local v121 = nil
		local v122 = nil

		if p42 == "[" then
			p43, v120, v121, v122 = string.match(p43, "([^=|%*~%$!%^]+)([|%*~%$!%^]?)(=?)(.*)")
		end

		local v123 = t1:new(t8[p42][p43])

		if v121 == "=" then
			if #v122 < 2 then
				v122 = "'" .. v122 .. "'"
			end

			local v124 = string.sub(v122, 2, #v122 - 1)

			if v120 == "!" then
				v123 = t1:new(p40.deepernodes)
			end

			for k in pairs(v123) do
				local v126 = k.attributes[p43]

				if v120 == "" and v126 ~= v124 then
					v123:remove(k)
				elseif v120 == "!" and v126 == v124 then
					v123:remove(k)
				elseif v120 == "|" and v124 ~= string.match(v126, "^[^-]*") then
					v123:remove(k)
				elseif v120 == "*" and v124 ~= string.match(v126, escape(v124)) then
					v123:remove(k)
				elseif v120 == "~" then
					v123:remove(k)

					for match2 in string.gmatch(v126, "%S+") do
						if match2 == v124 then
							v123:add(k)

							break
						end
					end
				elseif v120 == "^" and v124 ~= string.match(v126, "^" .. string.gsub(v124, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")) then
					v123:remove(k)
				elseif v120 == "$" and v124 ~= string.match(v126, string.gsub(v124, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. "$") then
					v123:remove(k)
				end
			end
		end

		return v123
	end

	local v97, v98, v99 = t1:new({ p40 })

	for match3 in string.gmatch(p41, "%S+") do
		if match3 == ">" then
			v99 = true
		else
			v98 = t1:new()

			for k in pairs(v97) do
				local deepernodes = k.deepernodes

				if v99 then
					deepernodes = t1:new(k.nodes)
				end

				v98 += deepernodes
			end

			v99 = false

			if match3 ~= "*" then
				local v103, v104 = t1:new()
				local n1 = 0

				while true do
					local start, v107, v108, v109, v110, v111

					start, n1, v107, v108, v109, v110, v111 = string.find(match3, "(%(?%)?)([:%[#.]?)([%w-_\\]+)([|%*~%$!%^]?=?)(['\"]?)", n1 + 1)

					if not v109 then
						break
					end

					if v108 == ":" then
						v104 = v109
					else
						if v107 == ")" then
							v104 = nil
						end

						if v108 == "[" and v111 ~= "" then
							local start2, v113

							start2, n1, v113 = string.find(match3, "(%b" .. v111 .. v111 .. ")]", n1)
							v109 ..= v110 .. v113
						end

						local v114 = match(v108, v109)

						if v104 == "not" then
							v103 += v114
						else
							v98 *= v114
						end
					end
				end

				v98 -= v103
				v97 = t1:new(v98)
			end
		end
	end

	local v115 = v98:tolist()

	table.sort(v115, function(p44, p45) -- line: 365
		return p44.index < p45.index
	end)

	return v115
end

function t4.select(p46, p47) -- line: 371
	-- upvalues: select (copy)
	return select(p46, p47)
end

t4.mt.__call = select

return t4
