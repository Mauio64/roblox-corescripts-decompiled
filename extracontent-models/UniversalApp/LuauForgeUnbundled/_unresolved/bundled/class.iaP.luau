local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/iaQ")

local module3 = require("@luauforge/bundled/iaR")

local function matchPath(p2, value)
	local v5 = { string.find(value, p2) }

	if #v5 > 0 then
		table.remove(v5, 1)
		table.remove(v5, 1)
		return v5
	end

	return nil
end

local function findMatch(p2, options)
	for i, list in ipairs(options or {}) do
		local v5, v6 = unpack(list)
		local v7 = matchPath(v5, p2)

		if v7 then
			return v6, v7
		end
	end

	return nil
end

local function defaultListKeyMapper(p2)
	return p2 .. "[]"
end

local function resolveUrl(p2, mappings, keymapper, value)
	module.isType(value, "string", "url")
	local v5, v6 = unpack(string.split(value, "?"))
	local match, v7 = findMatch(v5, mappings)

	if type(match) ~= "function" then
		warn("DeepLinkParser: URL not supported: " .. v5)
		return {}
	end

	table.insert(v7, (module2(v6, keymapper)))
	table.insert(v7, p2)
	return match(unpack(v7))
end

function LUAUFORGE_MODULE_GLOBALS_iaP_preserveCase(value): boolean
	local v5, v6 = unpack(string.split(value, "?"))

	for k, v7 in pairs(module3) do
		if v5 == v7 then
			return true
		end
	end

	return false
end

local class = {}
class.__index = class

function class.new(options, p2)
	local v5 = {
		mappings = options or {},
		keymapper = p2 or defaultListKeyMapper
	}

	setmetatable(v5, class)
	return v5
end

function class.resolve(p2, value, p3)
	if not LUAUFORGE_MODULE_GLOBALS_iaP_preserveCase(value) then
		value = string.lower(value)
	end

	return resolveUrl(p3, p2.mappings, p2.keymapper, value)
end

function class.matches(p2, value): boolean
	local v5 = string.lower(value)
	local v6 = unpack(string.split(v5, "?"))
	return type((findMatch(v6, p2.mappings))) == "function"
end

return class
