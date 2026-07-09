local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ParseQuery = require(Modules.Common.StringUtilities.ParseQuery)
local PreserveCasePaths = require(script.Parent.PreserveCasePaths)

local function matchPath(p1, p2) -- line: 11
	local t1 = { string.find(p2, p1) }

	if #t1 > 0 then
		table.remove(t1, 1)
		table.remove(t1, 1)

		return t1
	end

	return nil
end
local function findMatch(p3, p4) -- line: 23
	-- upvalues: matchPath (copy)
	for _, v in ipairs(p4 or {}) do
		local v18, v19 = unpack(v)
		local v20 = matchPath(v18, p3)

		if v20 then
			return v19, v20
		end
	end

	return nil
end
local function defaultListKeyMapper(p5) -- line: 35
	return p5 .. "[]"
end
local function resolveUrl(p6, p7, p8, p9) -- line: 39
	-- upvalues: ArgCheck (copy), findMatch (copy), ParseQuery (copy)
	ArgCheck.isType(p9, "string", "url")

	local v26, v27 = unpack(string.split(p9, "?"))
	local v28, v29 = findMatch(v26, p7)

	if type(v28) == "function" then
		table.insert(v29, (ParseQuery(v27, p8)))
		table.insert(v29, p6)

		return v28(unpack(v29))
	end

	warn("DeepLinkParser: URL not supported: " .. v26)

	return {}
end

function preserveCase(p10) -- line: 54
	-- upvalues: PreserveCasePaths (copy)
	local v31, _ = unpack(string.split(p10, "?"))

	for _, v in pairs(PreserveCasePaths) do
		if v31 == v then
			return true
		end
	end

	return false
end

local t2 = {}

t2.__index = t2

function t2.new(p11, p12) -- line: 67
	-- upvalues: defaultListKeyMapper (copy), t2 (copy)
	local t3 = {
		mappings = p11 or {},
		keymapper = p12 or defaultListKeyMapper
	}

	setmetatable(t3, t2)

	return t3
end
function t2.resolve(p13, p14, p15) -- line: 76
	-- upvalues: resolveUrl (copy)
	if not preserveCase(p14) then
		p14 = string.lower(p14)
	end

	return resolveUrl(p15, p13.mappings, p13.keymapper, p14)
end
function t2.matches(p16, p17) -- line: 83
	-- upvalues: findMatch (copy)
	local v43 = string.lower(p17)
	local v44 = unpack(string.split(v43, "?"))

	return type((findMatch(v44, p16.mappings))) == "function"
end

return t2
