local class = {}
class.mt = { __index = class }

function class:new(list)
	local v = {}

	local v2 = getmetatable(list) == class.mt or nil

	if type(list) == "table" then
		if v2 or not (#list > 0) then
			for k in pairs(list) do
				v[k] = true
			end
		else
			for _, item in ipairs(list) do
				v[item] = true
			end
		end
	else
		v = list ~= nil and { [list] = true } or v
	end

	return (setmetatable(v, class.mt))
end

function class:add(p)
	if p ~= nil then
		self[p] = true
	end

	return self
end

function class:remove(p)
	if p ~= nil then
		self[p] = nil
	end

	return self
end

function class:tolist()
	local result = {}

	for k in pairs(self) do
		table.insert(result, k)
	end

	return result
end

class.to_list = class.tolist

function class.mt.__add(p, p2)
	local result = class:new()
	local v = class:new(p)
	local v2 = class:new(p2)

	for k in pairs(v) do
		result[k] = true
	end

	for k in pairs(v2) do
		result[k] = true
	end

	return result
end

function class.mt.__sub(p, p2)
	local result = class:new()
	local v = class:new(p)
	local v2 = class:new(p2)

	for k in pairs(v) do
		result[k] = true
	end

	for k in pairs(v2) do
		result[k] = nil
	end

	return result
end

function class.mt.__mul(p, p2)
	local result = class:new()
	local v = class:new(p)
	local v2 = class:new(p2)

	for k in pairs(v) do
		result[k] = v2[k]
	end

	return result
end

function class.mt.__tostring(items)
	local v = "{"
	local v2 = ""

	for k in pairs(items) do
		v ..= v2 .. tostring(k)
		v2 = ", "
	end

	return v .. "}"
end

local ElementNode = {}
ElementNode.mt = { __index = ElementNode }
function ElementNode:new(p, text, parent, p2, p3, p4)
	local root = {
		index = p,
		name = text,
		level = 0,
		parent = nil,
		root = nil,
		nodes = {},
		_openstart = p3,
		_openend = p4,
		_closestart = p3,
		_closeend = p4,
		attributes = {},
		id = nil,
		classes = {},
		deepernodes = class:new(),
		deeperelements = {},
		deeperattributes = {},
		deeperids = {},
		deeperclasses = {}
	}

	root.attrs = root.attributes
	root.children = root.nodes
	root.descendants = root.deepernodes
	root.descendant_elements = root.deeperelements
	root.descendant_attrs = root.deeperattributes
	root.descendent_ids = root.deeperids
	root.descendant_classes = root.deeperclasses

	if parent then
		if p2 then
			root.root = parent.root
			root.parent = parent
			root.level = parent.level + 1
			table.insert(parent.nodes, root)
		else
			root.root = parent.root
			root.parent = parent.parent or parent
			root.level = parent.level
			table.insert(parent.parent and parent.parent.nodes or parent.nodes, root)
		end
	else
		root.name = "root"
		root.root = root
		root._text = text
		local v = string.len(text)
		root._openstart = 1
		root._openend = v
		root._closestart = 1
		root._closeend = v
	end

	return (setmetatable(root, ElementNode.mt))
end

function ElementNode:text()
	return (string.sub(self.root._text, self._openstart, self._closeend))
end

ElementNode.gettext = ElementNode.text

function ElementNode.settext(p, text)
	p.root._text = text
end

function ElementNode:textonly()
	return (self:text():gsub("<[^>]*>", ""))
end

function ElementNode:content()
	return (string.sub(self.root._text, self._openend + 1, self._closestart - 1))
end

ElementNode.getcontent = ElementNode.content

function ElementNode:addattribute(value, id)
	self.attributes[value] = id

	if string.lower(value) == "id" then
		self.id = id
	elseif string.lower(value) == "class" then
		for k in string.gmatch(id, "%S+") do
			table.insert(self.classes, k)
		end
	end
end

function ElementNode:links()
	local hrefs = {}

	for _, v in ipairs(self:select("a[href]")) do
		if #v.attributes.href > 0 then
			table.insert(hrefs, v.attributes.href)
		end
	end

	return hrefs
end

function ElementNode:absolutelinks(p)
	local v = (p or self.page_url or ""):split("?")[1]:split("#")[1]

	local parts = v:split("://")
	local v2 = parts[#parts]:split("/")[1]
	local v3

	if v:find("://") then
		v3 = v:split("://")[1] or "http"
	else
		v3 = "http"
	end

	while v:sub(-1, -1) == "/" do
		v = v:sub(1, -2)
	end

	local result = {}

	for _, v4 in ipairs(self:select("a[href]")) do
		if not (#v4.attributes.href > 0) then
			continue
		end

		local v5 = v4.attributes.href

		if not v5:find("://") then
			if v5:sub(1, 2) == "//" then
				v5 = v3 .. ":" .. v5
			elseif v5:sub(1, 1) == "/" then
				v5 = v3 .. "://" .. v2 .. v5
			else
				v5 = v .. "/" .. v5
			end
		end

		table.insert(result, v5)
	end

	return result
end

ElementNode.absolute_links = ElementNode.absolutelinks

local function insert(p, p2, state) -- 4 equivalent calls inferred from this helper
	p[p2] = p[p2] or class:new()
	p[p2]:add(state)
end

function ElementNode:close(closestart, closeend)
	if closestart and closeend then
		self._closestart = closestart
		self._closeend = closeend
	end

	local v = self

	while true do
		v = v.parent

		if not v then
			break
		end

		v.deepernodes:add(self)
		insert(v.deeperelements, self.name, self) -- inferred equivalent call

		for k in pairs(self.attributes) do
			insert(v.deeperattributes, k, self) -- inferred equivalent call
		end

		if self.id then
			insert(v.deeperids, self.id, self) -- inferred equivalent call
		end

		for _, class2 in ipairs(self.classes) do
			insert(v.deeperclasses, class2, self) -- inferred equivalent call
		end
	end
end

local function escape(value) -- 2 equivalent calls inferred from this helper
	return string.gsub(value, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function select(data, value)
	if not value or type(value) ~= "string" or value == "" then
		return class:new()
	end

	local v = {
		[""] = data.deeperelements,
		["["] = data.deeperattributes,
		["#"] = data.deeperids,
		["."] = data.deeperclasses
	}

	local function match(p, value2)
		local v2, v3, v4

		if p == "[" then
			value2, v2, v3, v4 = string.match(value2, "([^=|%*~%$!%^]+)([|%*~%$!%^]?)(=?)(.*)")
		end

		local v5 = class:new(v[p][value2])

		if v3 ~= "=" then
			return v5
		end

		if #v4 < 2 then
			v4 = "'" .. v4 .. "'"
		end

		local v6 = string.sub(v4, 2, #v4 - 1)

		if v2 == "!" then
			v5 = class:new(data.deepernodes)
		end

		for k in pairs(v5) do
			local attribute = k.attributes[value2]

			if v2 == "" and attribute ~= v6 then
				v5:remove(k)
			elseif v2 == "!" and attribute == v6 then
				v5:remove(k)
			elseif v2 == "|" and string.match(attribute, "^[^-]*") ~= v6 then
				v5:remove(k)
			elseif v2 == "*" and string.match(attribute, escape(v6)) ~= v6 then
				v5:remove(k)
			elseif v2 == "~" then
				v5:remove(k)

				for k2 in string.gmatch(attribute, "%S+") do
					if k2 == v6 then
						v5:add(k)
						break
					end
				end
			elseif v2 == "^" and string.match(attribute, "^" .. escape(v6)) ~= v6 then -- inferred equivalent call
				v5:remove(k)
			elseif v2 == "$" and string.match(attribute, escape(v6) .. "$") ~= v6 then -- inferred equivalent call
				v5:remove(k)
			end
		end

		return v5
	end

	local v2, v3, v4 = class:new({ data })

	for k in string.gmatch(value, "%S+") do
		if k == ">" then
			v4 = true
		else
			v3 = class:new()

			for k2 in pairs(v2) do
				local v5 = k2.deepernodes

				if v4 then
					v5 = class:new(k2.nodes)
				end

				v3 += v5
			end

			v4 = false

			if k ~= "*" then
				local v5, v6 = class:new()
				local v7 = 0

				while true do
					local _, v8, v9, v10, v11, v12
					_, v7, v8, v9, v10, v11, v12 = string.find(
						k,
						"(%(?%)?)([:%[#.]?)([%w-_\\]+)([|%*~%$!%^]?=?)(['\"]?)",
						v7 + 1
					)

					if not v10 then
						break
					end

					if v9 == ":" then
						v6 = v10
					else
						if v8 == ")" then
							v6 = nil
						end

						if v9 == "[" and v12 ~= "" then
							local v13, v14
							v13, v7, v14 = string.find(k, "(%b" .. v12 .. v12 .. ")]", v7)

							v10 ..= v11 .. v14
						end

						local v13 = match(v9, v10)

						if v6 == "not" then
							v5 += v13
						else
							v3 *= v13
						end
					end
				end

				v3 -= v5
				v2 = class:new(v3)
			end
		end
	end

	local tolist = v3:tolist()
	table.sort(tolist, function(a, b): boolean
		return a.index < b.index
	end)

	return tolist
end

function ElementNode:select(p)
	return select(self, p)
end

ElementNode.mt.__call = select

return ElementNode
