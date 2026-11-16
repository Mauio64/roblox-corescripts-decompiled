local T = {}

function T.type(p)
	return function(p2)
		local typeName = type(p2)

		if typeName == p then
			return true
		end

		return false, string.format("%s expected, got %s", p, typeName)
	end
end

function T.typeof(p)
	return function(p2)
		local typeName = typeof(p2)

		if typeName == p then
			return true
		end

		return false, string.format("%s expected, got %s", p, typeName)
	end
end

function T.any(p)
	if p == nil then
		return false, "any expected, got nil"
	end

	return true
end

T.boolean = T.typeof("boolean")

T.thread = T.typeof("thread")

T.callback = T.typeof("function")
T["function"] = T.callback

T.none = T.typeof("nil")
T["nil"] = T.none

T.string = T.typeof("string")

T.table = T.typeof("table")

T.userdata = T.type("userdata")

function T.number(p)
	local typeName = typeof(p)

	if typeName ~= "number" then
		return false, string.format("number expected, got %s", typeName)
	end

	if p == p then
		return true
	end

	return false, "unexpected NaN value"
end

function T.nan(p)
	local typeName = typeof(p)

	if typeName ~= "number" then
		return false, string.format("number expected, got %s", typeName)
	end

	if p == p then
		return false, "unexpected non-NaN value"
	end

	return true
end

T.Axes = T.typeof("Axes")

T.BrickColor = T.typeof("BrickColor")

T.CatalogSearchParams = T.typeof("CatalogSearchParams")

T.CFrame = T.typeof("CFrame")

T.Color3 = T.typeof("Color3")

T.ColorSequence = T.typeof("ColorSequence")

T.ColorSequenceKeypoint = T.typeof("ColorSequenceKeypoint")

T.DateTime = T.typeof("DateTime")

T.DockWidgetPluginGuiInfo = T.typeof("DockWidgetPluginGuiInfo")

T.Enum = T.typeof("Enum")

T.EnumItem = T.typeof("EnumItem")

T.Enums = T.typeof("Enums")

T.Faces = T.typeof("Faces")

T.Instance = T.typeof("Instance")

T.NumberRange = T.typeof("NumberRange")

T.NumberSequence = T.typeof("NumberSequence")

T.NumberSequenceKeypoint = T.typeof("NumberSequenceKeypoint")

T.PathWaypoint = T.typeof("PathWaypoint")

T.PhysicalProperties = T.typeof("PhysicalProperties")

T.Random = T.typeof("Random")

T.Ray = T.typeof("Ray")

T.RaycastParams = T.typeof("RaycastParams")

T.RaycastResult = T.typeof("RaycastResult")

T.RBXScriptConnection = T.typeof("RBXScriptConnection")

T.RBXScriptSignal = T.typeof("RBXScriptSignal")

T.Rect = T.typeof("Rect")

T.Region3 = T.typeof("Region3")

T.Region3int16 = T.typeof("Region3int16")

T.TweenInfo = T.typeof("TweenInfo")

T.UDim = T.typeof("UDim")

T.UDim2 = T.typeof("UDim2")

T.Vector2 = T.typeof("Vector2")

T.Vector2int16 = T.typeof("Vector2int16")

T.Vector3 = T.typeof("Vector3")

T.Vector3int16 = T.typeof("Vector3int16")

function T.literal(...)
	local v = select("#", ...)

	if v == 1 then
		local v2 = ...
		return function(p)
			if p == v2 then
				return true
			end

			return false, string.format("expected %s, got %s", tostring(v2), (tostring(p)))
		end
	end

	local v2 = {}

	for i = 1, v do
		local v3 = select(i, ...)
		v2[i] = T.literal(v3)
	end

	return T.union(table.unpack(v2, 1, v))
end

T.exactly = T.literal

function T.keyOf(items)
	local count = 0
	local v = {}

	for k in pairs(items) do
		count += 1
		v[count] = k
	end

	return T.literal(table.unpack(v, 1, count))
end

function T.valueOf(items)
	local count = 0
	local v = {}

	for _, item in pairs(items) do
		count += 1
		v[count] = item
	end

	return T.literal(table.unpack(v, 1, count))
end

function T.integer(p)
	local number, v = T.number(p)

	if not number then
		return false, v or ""
	end

	if p % 1 == 0 then
		return true
	end

	return false, string.format("integer expected, got %s", p)
end

function T.numberMin(p)
	return function(p2)
		local number, v = T.number(p2)

		if not number then
			return false, v or ""
		end

		if p <= p2 then
			return true
		end

		return false, string.format("number >= %s expected, got %s", p, p2)
	end
end

function T.numberMax(p)
	return function(p2)
		local number, v = T.number(p2)

		if not number then
			return false, v
		end

		if p2 <= p then
			return true
		end

		return false, string.format("number <= %s expected, got %s", p, p2)
	end
end

function T.numberMinExclusive(p)
	return function(p2)
		local number, v = T.number(p2)

		if not number then
			return false, v or ""
		end

		if p < p2 then
			return true
		end

		return false, string.format("number > %s expected, got %s", p, p2)
	end
end

function T.numberMaxExclusive(p)
	return function(p2)
		local number, v = T.number(p2)

		if not number then
			return false, v or ""
		end

		if p2 < p then
			return true
		end

		return false, string.format("number < %s expected, got %s", p, p2)
	end
end

T.numberPositive = T.numberMinExclusive(0)

T.numberNegative = T.numberMaxExclusive(0)

function T.numberConstrained(p, p2)
	assert(T.number(p))
	assert(T.number(p2))
	local numberMin = T.numberMin(p)
	local numberMax = T.numberMax(p2)

	return function(p3)
		local v, v2 = numberMin(p3)

		if not v then
			return false, v2 or ""
		end

		local v3, v4 = numberMax(p3)

		if v3 then
			return true
		end

		return false, v4 or ""
	end
end

function T.numberConstrainedExclusive(p, p2)
	assert(T.number(p))
	assert(T.number(p2))
	local numberMinExclusive = T.numberMinExclusive(p)
	local numberMaxExclusive = T.numberMaxExclusive(p2)

	return function(p3)
		local v, v2 = numberMinExclusive(p3)

		if not v then
			return false, v2 or ""
		end

		local v3, v4 = numberMaxExclusive(p3)

		if v3 then
			return true
		end

		return false, v4 or ""
	end
end

function T.match(p)
	assert(T.string(p))
	return function(value)
		local str, v = T.string(value)

		if not str then
			return false, v
		end

		if string.match(value, p) == nil then
			return false, string.format("%q failed to match pattern %q", value, p)
		end

		return true
	end
end

function T.optional(callback)
	assert(T.callback(callback))
	return function(p)
		if p == nil then
			return true
		end

		local v, v2 = callback(p)

		if v then
			return true
		end

		return false, string.format("(optional) %s", v2 or "")
	end
end

function T.tuple(...)
	local v = { ... }
	return function(...)
		local v2 = { ... }

		for i, v3 in ipairs(v) do
			local v4, v5 = v3(v2[i])

			if v4 == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, v5 or "")
			end
		end

		return true
	end
end

function T.keys(callback)
	assert(T.callback(callback))
	return function(items)
		local tbl, v = T.table(items)

		if tbl == false then
			return false, v or ""
		end

		for k in pairs(items) do
			local v2, v3 = callback(k)

			if v2 == false then
				return false, string.format("bad key %s:\n\t%s", tostring(k), v3 or "")
			end
		end

		return true
	end
end

function T.values(callback)
	assert(T.callback(callback))
	return function(items)
		local tbl, v = T.table(items)

		if tbl == false then
			return false, v or ""
		end

		for k, item in pairs(items) do
			local v2, v3 = callback(item)

			if v2 == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(k), v3 or "")
			end
		end

		return true
	end
end

function T.map(p, p2)
	assert(T.callback(p))
	assert(T.callback(p2))
	local keys = T.keys(p)
	local values = T.values(p2)

	return function(p3)
		local v, v2 = keys(p3)

		if not v then
			return false, v2 or ""
		end

		local v3, v4 = values(p3)

		if v3 then
			return true
		end

		return false, v4 or ""
	end
end

function T.set(p)
	return T.map(p, T.literal(true))
end

local keys = T.keys(T.integer)

function T.array(p)
	assert(T.callback(p))
	local values = T.values(p)

	return function(list)
		local v, v2 = keys(list)

		if v == false then
			return false, string.format("[array] %s", v2 or "")
		end

		local count = 0

		for _ in ipairs(list) do
			count += 1
		end

		for k in pairs(list) do
			if k < 1 or count < k then
				return false, string.format("[array] key %s must be sequential", (tostring(k)))
			end
		end

		local v3, v4 = values(list)

		if v3 then
			return true
		end

		return false, string.format("[array] %s", v4 or "")
	end
end

function T.strictArray(...)
	local v = { ... }
	assert(T.array(T.callback)(v))

	return function(list)
		local v2, v3 = keys(list)

		if v2 == false then
			return false, string.format("[strictArray] %s", v3 or "")
		end

		if #v < #list then
			return false, string.format("[strictArray] Array size exceeds limit of %d", #v)
		end

		for k, v4 in pairs(v) do
			local v5, v6 = v4(list[k])

			if not v5 then
				return false, string.format("[strictArray] Array index #%d - %s", k, v6)
			end
		end

		return true
	end
end

local array = T.array(T.callback)

function T.union(...)
	local v = { ... }
	assert(array(v))

	return function(p)
		for _, v2 in ipairs(v) do
			if v2(p) then
				return true
			end
		end

		return false, "bad type for union"
	end
end

T.some = T.union

function T.intersection(...)
	local v = { ... }
	assert(array(v))

	return function(p)
		for _, v2 in ipairs(v) do
			local v3, v4 = v2(p)

			if not v3 then
				return false, v4 or ""
			end
		end

		return true
	end
end

T.every = T.intersection

local mapped = T.map(T.any, T.callback)

function T.interface(items)
	assert(mapped(items))
	return function(p)
		local tbl, v = T.table(p)

		if tbl == false then
			return false, v or ""
		end

		for k, item in pairs(items) do
			local v2, v3 = item(p[k])

			if v2 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v3 or "")
			end
		end

		return true
	end
end

function T.strictInterface(items)
	assert(mapped(items))
	return function(items2)
		local tbl, v = T.table(items2)

		if tbl == false then
			return false, v or ""
		end

		for k, item in pairs(items) do
			local v2, v3 = item(items2[k])

			if v2 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v3 or "")
			end
		end

		for k in pairs(items2) do
			if not items[k] then
				return false, string.format("[interface] unexpected field %q", (tostring(k)))
			end
		end

		return true
	end
end

function T.instanceOf(p, p2)
	assert(T.string(p))
	local v

	if p2 == nil then
		v = nil
	else
		v = T.children(p2)
	end

	return function(instance)
		local instance2, v2 = T.Instance(instance)

		if not instance2 then
			return false, v2 or ""
		end

		if instance.ClassName ~= p then
			return false, string.format("%s expected, got %s", p, instance.ClassName)
		end

		if v then
			local v3, v4 = v(instance)

			if not v3 then
				return false, v4
			end
		end

		return true
	end
end

T.instance = T.instanceOf

function T.instanceIsA(className, p)
	assert(T.string(className))
	local v

	if p == nil then
		v = nil
	else
		v = T.children(p)
	end

	return function(instance)
		local instance2, v2 = T.Instance(instance)

		if not instance2 then
			return false, v2 or ""
		end

		if not instance:IsA(className) then
			return false, string.format("%s expected, got %s", className, instance.ClassName)
		end

		if v then
			local v3, v4 = v(instance)

			if not v3 then
				return false, v4
			end
		end

		return true
	end
end

function T.enum(p)
	assert(T.Enum(p))
	return function(p2)
		local enumItem, v = T.EnumItem(p2)

		if not enumItem then
			return false, v
		end

		if p2.EnumType == p then
			return true
		end

		return false, string.format("enum of %s expected, got enum of %s", tostring(p), (tostring(p2.EnumType)))
	end
end

local tuple = T.tuple(T.callback, T.callback)

function T.wrap(callback, callback2)
	assert(tuple(callback, callback2))
	return function(...)
		assert(callback2(...))
		return callback(...)
	end
end

function T.strict(callback)
	return function(...)
		assert(callback(...))
	end
end

local mapped2 = T.map(T.string, T.callback)

function T.children(items)
	assert(mapped2(items))

	return function(instance)
		local instance2, v = T.Instance(instance)

		if not instance2 then
			return false, v or ""
		end

		local childrenByName = {}

		for _, child in ipairs(instance:GetChildren()) do
			local name = child.Name

			if not items[name] then
				continue
			end

			if childrenByName[name] then
				return false, string.format("Cannot process multiple children with the same name %q", name)
			end

			childrenByName[name] = child
		end

		for k, item in pairs(items) do
			local v2, v3 = item(childrenByName[k])

			if not v2 then
				return false, string.format("[%s.%s] %s", instance:GetFullName(), k, v3 or "")
			end
		end

		return true
	end
end

return T
