local MergeDeep = {}

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Set = LuauPolyfill.Set

local none = newproxy(true)
getmetatable(none).__tostring = function(): string
	return "Value.None"
end

local objects = require(script.Parent.objects)
local isNonNullObject = objects.isNonNullObject
local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)
local objectKeysForEach = require(parent.luaUtils.objectKeysForEach)

local mergeDeepArray

function MergeDeep.mergeDeep(...)
	return mergeDeepArray({ ... })
end

local class = {}

mergeDeepArray = function(list)
	local v = list[1] or {}

	local count = #list

	if count > 1 then
		local v2 = class.new()

		for i = 2, count do
			v = v2:merge(v, list[i])
		end
	end

	return v
end

MergeDeep.mergeDeepArray = mergeDeepArray

class.__index = class

function class.new(callback)
	local self = setmetatable({}, class)

	self.reconciler = callback == nil and function(object, p, p2, p3)
		return object:merge(p[p3], p2[p3])
	end or callback

	self.isObject = isNonNullObject
	self.pastCopies = Set.new()

	return self
end

function class:merge(p, p2, ...)
	local v = table.pack(...)

	if isNonNullObject(p2) and isNonNullObject(p) then
		objectKeysForEach(p2, function(p3)
			if hasOwnProperty(p, p3) then
				local v2 = p[p3]

				if p2[p3] ~= v2 then
					local reconciler = self:reconciler(p, p2, p3, table.unpack(v))

					if reconciler ~= v2 then
						p = self:shallowCopyForMerge(p)
						p[p3] = reconciler
					end
				end
			else
				p = self:shallowCopyForMerge(p)
				p[p3] = p2[p3]
			end

			if p[p3] == none then
				p[p3] = nil
			end
		end)

		return p
	end

	return p2
end

function class:shallowCopyForMerge(p)
	if isNonNullObject(p) and not self.pastCopies:has(p) then
		p = table.clone(p)

		self.pastCopies:add(p)
	end

	return p
end

class.None = none

MergeDeep.DeepMerger = class

return MergeDeep
