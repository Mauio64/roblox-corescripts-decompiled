local Inspect = {
	_VERSION = "inspect.lua 3.1.0",
	_URL = "http://github.com/kikito/inspect.lua",
	_DESCRIPTION = "human-readable representations of tables",
	_LICENSE = [[
	  MIT LICENSE

	  Copyright (c) 2013 Enrique García Cota

	  Permission is hereby granted, free of charge, to any person obtaining a
	  copy of this software and associated documentation files (the
	  "Software"), to deal in the Software without restriction, including
	  without limitation the rights to use, copy, modify, merge, publish,
	  distribute, sublicense, and/or sell copies of the Software, and to
	  permit persons to whom the Software is furnished to do so, subject to
	  the following conditions:

	  The above copyright notice and this permission notice shall be included
	  in all copies or substantial portions of the Software.

	  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]]
}

local tostring = tostring

Inspect.KEY = setmetatable({}, {
	__tostring = function(): string
		return "inspect.KEY"
	end
})

Inspect.METATABLE = setmetatable({}, {
	__tostring = function(): string
		return "inspect.METATABLE"
	end
})

local function rawpairs(p)
	return next, p, nil
end

local function smartQuote(value) -- 1 equivalent call inferred from this helper
	if value:match("\"") and not value:match("'") then
		return "'" .. value .. "'"
	end

	return "\"" .. value:gsub("\"", "\\\"") .. "\""
end

local v = {
	["\7"] = "\\a",
	["\8"] = "\\b",
	["\f"] = "\\f",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\t"] = "\\t",
	["\11"] = "\\v"
}

local v2 = {}

for i = 0, 31 do
	local v3 = string.char(i)

	if v[v3] then
		continue
	end

	v[v3] = "\\" .. i
	v2[v3] = string.format("\\%03d", i)
end

local function escape(value) -- 1 equivalent call inferred from this helper
	return (value:gsub("\\", "\\\\"):gsub("(%c)%f[0-9]", v2):gsub("%c", v))
end

local function isIdentifier(value) -- 1 equivalent call inferred from this helper
	return type(value) == "string" and value:match("^[_%a][_%a%d]*$")
end

local function isSequenceKey(value, p): boolean -- 1 equivalent call inferred from this helper
	return type(value) == "number" and value >= 1 and value <= p and math.floor(value) == value
end

local v3 = {
	number = 1,
	boolean = 2,
	string = 3,
	table = 4,
	["function"] = 5,
	userdata = 6,
	thread = 7
}

local function sortKeys(p, p2): boolean
	local typeName = type(p)
	local typeName2 = type(p2)

	if typeName == typeName2 and (typeName == "string" or typeName == "number") then
		return p < p2
	end

	local v4 = v3[typeName]
	local v5 = v3[typeName2]

	if v4 and v5 then
		return v3[typeName] < v3[typeName2]
	end

	if v4 then
		return true
	end

	return not v5 and typeName < typeName2
end

local function getSequenceLength(p)
	local v4 = 1
	local v5 = rawget(p, v4)

	while v5 ~= nil do
		v4 += 1
		v5 = rawget(p, v4)
	end

	return v4 - 1
end

local function getNonSequentialKeys(items)
	local v4 = 1
	local v5 = rawget(items, v4)
	local count = 0
	local result = {}

	while v5 ~= nil do
		v4 += 1
		v5 = rawget(items, v4)
	end

	local v6 = v4 - 1

	for k, _ in next, items do
		if isSequenceKey(k, v6) then -- inferred equivalent call
			continue
		end

		count += 1
		result[count] = k
	end

	table.sort(result, sortKeys)
	return result, count, v6
end

local function countTableAppearances(items, options)
	local v4 = options or {}

	if type(items) ~= "table" then
		return v4
	end

	if v4[items] then
		v4[items] += 1

		return v4
	end

	v4[items] = 1

	for k, item in next, items do
		countTableAppearances(k, v4)
		countTableAppearances(item, v4)
	end

	countTableAppearances(getmetatable(items), v4)
	return v4
end

local function makePath(list, ...)
	local count = #list
	local path = {}

	local v4 = { ... }

	for i = 1, count do
		path[i] = list[i]
	end

	for i = 1, #v4 do
		path[count + i] = v4[i]
	end

	return path
end

local function processRecursive(process, p, p2, p3)
	if p == nil then
		return nil
	end

	if p3[p] then
		return p3[p]
	end

	local v4 = process(p, p2)

	if type(v4) ~= "table" then
		return v4
	end

	local v5 = {}
	p3[p] = v5

	for k, v6 in next, v4 do
		local v7 = processRecursive(process, k, makePath(p2, k, Inspect.KEY), p3)

		if v7 ~= nil then
			v5[v7] = processRecursive(process, v6, makePath(p2, v7), p3)
		end
	end

	local v6 = processRecursive(process, getmetatable(v4), makePath(p2, Inspect.METATABLE), p3)

	if type(v6) ~= "table" then
		v6 = nil
	end

	setmetatable(v5, v6)

	return v5
end

local v4 = {}
local v5 = { __index = v4 }

function v4:puts(...)
	local v6 = { ... }
	local buf = self.buffer
	local count = #buf

	for i = 1, #v6 do
		count += 1
		buf[count] = v6[i]
	end
end

function v4:down(callback)
	self.level += 1
	callback()
	self.level -= 1
end

function v4:tabify()
	self:puts(self.newline, string.rep(self.indent, self.level))
end

function v4:alreadyVisited(p): boolean
	return self.ids[p] ~= nil
end

function v4:getId(p)
	local v6 = self.ids[p]

	if not v6 then
		local typeName = type(p)
		v6 = (self.maxIds[typeName] or 0) + 1
		self.maxIds[typeName] = v6
		self.ids[p] = v6
	end

	return (tostring(v6))
end

function v4:putKey(value)
	if isIdentifier(value) then -- inferred equivalent call
		return self:puts(value)
	end

	self:puts("[")
	self:putValue(value)
	self:puts("]")
end

function v4:putTable(list)
	if list == Inspect.KEY or list == Inspect.METATABLE then
		self:puts((tostring(list)))
		return
	end

	if self:alreadyVisited(list) then
		self:puts("<table ", self:getId(list), ">")
		return
	end

	if self.level >= self.depth then
		self:puts("{...}")
		return
	end

	if self.tableAppearances[list] > 1 then
		self:puts("<", self:getId(list), ">")
	end

	local nonSequentialKeys, v6, v7 = getNonSequentialKeys(list)
	local metatable = getmetatable(list)

	self:puts("{")
	self:down(function()
		local count = 0

		for i = 1, v7 do
			if count > 0 then
				self:puts(",")
			end

			self:puts(" ")
			self:putValue(list[i])
			count += 1
		end

		for i = 1, v6 do
			local nonSequentialKey = nonSequentialKeys[i]

			if count > 0 then
				self:puts(",")
			end

			self:tabify()
			self:putKey(nonSequentialKey)
			self:puts(" = ")
			self:putValue(list[nonSequentialKey])
			count += 1
		end

		if type(metatable) == "table" then
			if count > 0 then
				self:puts(",")
			end

			self:tabify()
			self:puts("<metatable> = ")
			self:putValue(metatable)
		end
	end)

	if v6 > 0 or type(metatable) == "table" then
		self:tabify()
	elseif v7 > 0 then
		self:puts(" ")
	end

	self:puts("}")
end

function v4:putValue(value)
	local typeName = type(value)

	if typeName == "string" then
		self:puts(smartQuote(escape(value))) -- inferred equivalent call
	elseif
		typeName == "number"
		or typeName == "boolean"
		or typeName == "nil"
		or typeName == "cdata"
		or typeName == "ctype"
	then
		self:puts((tostring(value)))
	elseif typeName == "table" then
		self:putTable(value)
	else
		self:puts("<", typeName, " ", self:getId(value), ">")
	end
end

function Inspect.inspect(p, options)
	local v6 = options or {}

	local depth = v6.depth or 1e999
	local newline = v6.newline or "\n"
	local indent = v6.indent or "  "
	local process = v6.process

	if process then
		p = processRecursive(process, p, {}, {})
	end

	local object = setmetatable({
		depth = depth,
		level = 0,
		buffer = {},
		ids = {},
		maxIds = {},
		newline = newline,
		indent = indent,
		tableAppearances = countTableAppearances(p)
	}, v5)

	object:putValue(p)

	return table.concat(object.buffer)
end

setmetatable(Inspect, {
	__call = function(_, ...)
		return Inspect.inspect(...)
	end
})

return Inspect
