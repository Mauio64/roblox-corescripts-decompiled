local parent = script.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local class = {}
class.__index = class

function class.new(options)
	local v = {}
	local headerList

	if Array.isArray(options) then
		headerList = {}

		for _, option in options do
			headerList[option[1]] = option[2]
		end
	else
		headerList = options or {}
	end

	v.headerList = headerList
	v.guard = "none"

	setmetatable(v, class)
	return v
end

function class.append(p, p2: string, p3: string)
	if p.guard == "immutable" then
		error("TypeError: tried to append header to immutable Headers object")
	end

	p.headerList[p2] = p3
end

function class:delete(p: string)
	if self.guard == "immutable" then
		error("TypeError: tried to delete key on immutable Headers object")
	end

	if not self:has(p) then
		return
	end

	self.headerList[p] = nil
end

function class.get(p, p2: string)
	return p.headerList[p2]
end

function class:has(p: string): boolean
	return self.headerList[p] ~= nil
end

function class.set(p, p2: string, p3: string)
	if p.guard == "immutable" then
		error("TypeError: tried to set key on immutable Headers object")
	end

	p.headerList[p2] = p3
end

function class.__iter(p)
	return next, p.headerList
end

return { Headers = class }
