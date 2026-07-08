local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Set = require(ParentParentParent.LuauPolyfill).Set
local v5 = newproxy(true)

getmetatable(v5).__tostring = function() -- line: 23
	return "Value.None"
end

local isNonNullObject = require(script.Parent.objects).isNonNullObject
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)
local objectKeysForEach = require(ParentParent.luaUtils.objectKeysForEach)
local mergeDeepArray = nil

function t1.mergeDeep(...) -- line: 59
	-- upvalues: mergeDeepArray (ref)
	return mergeDeepArray({ ... })
end

local t2 = {}

function mergeDeepArray(p1) -- line: 73
	-- upvalues: t2 (copy)
	local v12 = p1[1] or {}
	local v13 = #p1

	if v13 > 1 then
		local v14 = t2.new()

		for i = 2, v13 do
			v12 = v14:merge(v12, p1[i])
		end
	end

	return v12
end

t1.mergeDeepArray = mergeDeepArray
t2.__index = t2

function t2.new(p2: ((...any) -> ...any)?) -- line: 107
	-- upvalues: t2 (copy), isNonNullObject (copy), Set (copy)
	local self = setmetatable({}, t2)

	if p2 == nil then
		function p2(p3, p4, p5, p6) -- line: 110
			return p3:merge(p4[p6], p5[p6])
		end
	end

	self.reconciler = p2
	self.isObject = isNonNullObject
	self.pastCopies = Set.new()

	return self
end
function t2.merge(t3: {[any]: any}, p7, p8, ...) -- line: 124
	-- upvalues: isNonNullObject (copy), objectKeysForEach (copy), hasOwnProperty (copy), v5 (copy)
	local v22 = table.pack(...)

	if isNonNullObject(p8) and isNonNullObject(p7) then
		objectKeysForEach(p8, function(p9) -- line: 130
			-- upvalues: hasOwnProperty (copy), p7 (ref), p8 (copy), t3 (copy), v22 (copy), v5 (copy)
			if hasOwnProperty(p7, p9) then
				local v30 = p7[p9]

				if v30 ~= p8[p9] then
					local v31 = t3:reconciler(p7, p8, p9, table.unpack(v22))

					if v31 ~= v30 then
						p7 = t3:shallowCopyForMerge(p7)
						p7[p9] = v31
					end
				end
			else
				p7 = t3:shallowCopyForMerge(p7)
				p7[p9] = p8[p9]
			end

			if p7[p9] == v5 then
				p7[p9] = nil
			end
		end)

		return p7
	end

	return p8
end
function t2.shallowCopyForMerge(p10, p11) -- line: 163
	-- upvalues: isNonNullObject (copy)
	if isNonNullObject(p11) and not p10.pastCopies:has(p11) then
		p11 = table.clone(p11)
		p10.pastCopies:add(p11)
	end

	return p11
end

t2.None = v5
t1.DeepMerger = t2

return t1
