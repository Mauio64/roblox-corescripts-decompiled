local parent = script.Parent.Parent.Parent.Parent.Parent
local t = require(parent.t)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local function hasValue(items, p): boolean
	for _, item in items do
		if item == p then
			return true
		end
	end

	return false
end

local function matches(p, items): boolean -- 4 equivalent calls inferred from this helper
	if not (p and items) then
		return true
	end

	if typeof(items) ~= "table" then
		return items == p
	end

	for _, item in items do
		if item == p then
			return true
		end
	end

	return false
end

local function readValue(p, breakpoint, kind, p2, p3: number)
	local v = p[p2]
	local v2 = v == nil and -1 or p3
	Array.forEach(p, function(p4)
		if matches(breakpoint, p4.breakpoint) and matches(kind, p4.kind) then -- inferred equivalent call
			local v3, v4 = readValue(p4, breakpoint, kind, p2, p3 + 1)

			if v2 < v4 then
				v = v3
				v2 = v4
			end
		end
	end)
	return v, v2
end

local v = { name = "_default", min = 1e999, max = 0 }

local v2 = {}
v2[t.strictInterface({ Scale = t.number, Offset = t.number })] = function(p)
	return UDim.new(p.Scale, p.Offset)
end

local ResponsiveLayoutConfigReader = {}

function ResponsiveLayoutConfigReader.getValue(data, p)
	local config = data.config
	local breakpoint = data.breakpoint
	local kind = data.kind
	local v3 = config[p]
	local v4 = v3 == nil and -1 or 0
	local v5 = 0
	Array.forEach(config, function(p2)
		if matches(breakpoint, p2.breakpoint) and matches(kind, p2.kind) then -- inferred equivalent call
			local v6, v7 = readValue(p2, breakpoint, kind, p, v5 + 1)

			if v4 < v7 then
				v3 = v6
				v4 = v7
			end
		end
	end)
	local v6 = v3

	for k, v7 in v2 do
		if k(v6) then
			return v7(v6)
		end
	end

	return v6
end

function ResponsiveLayoutConfigReader.findBreakpoint(p, p2)
	local v3 = Array.find(p, function(data): boolean
		return type(data) == "table"
			and type(data.breakpoint) == "string"
			and p2 <= (data.max or 1e999)
			and p2 >= (data.min or 0)
	end)

	if v3 then
		return {
			name = v3.breakpoint,
			min = v3.min or 0,
			max = v3.max or 1e999
		}
	end

	return v
end

return ResponsiveLayoutConfigReader
