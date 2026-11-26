local array = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill").Array

local class = {}
class.__index = class

function class.new(options)
	local v5 = {}
	local v6

	if array.isArray(options) then
		v6 = {}

		for k, option in options do
			v6[option[1]] = option[2]
		end
	else
		v6 = options or {}
	end

	v5.headerList = v6
	v5.guard = "none"

	setmetatable(v5, class)
	return v5
end

function class.append(p2, p3, p4)
	if p2.guard == "immutable" then
		error("TypeError: tried to append header to immutable Headers object")
	end

	p2.headerList[p3] = p4
end

function class:delete(p2)
	if self.guard == "immutable" then
		error("TypeError: tried to delete key on immutable Headers object")
	end

	if not self:has(p2) then
		return
	end

	self.headerList[p2] = nil
end

function class.get(p2, p3)
	return p2.headerList[p3]
end

function class.has(p2, p3): boolean
	return p2.headerList[p3] ~= nil
end

function class.set(p2, p3, p4)
	if p2.guard == "immutable" then
		error("TypeError: tried to set key on immutable Headers object")
	end

	p2.headerList[p3] = p4
end

function class.__iter(p2)
	return next, p2.headerList
end

return { Headers = class }
