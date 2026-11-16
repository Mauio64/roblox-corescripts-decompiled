local Typeof = typeof or type

local function primitive(p) -- 36 equivalent calls inferred from this helper
	return function(p2)
		local Typeof2 = Typeof(p2)

		if Typeof2 == p then
			return true
		end

		return false, string.format("%s expected, got %s", p, Typeof2)
	end
end

local T = {}

function T.any(p)
	if p == nil then
		return false, "any expected, got nil"
	end

	return true
end

T.boolean = primitive("boolean") -- inferred equivalent call
T.thread = primitive("thread") -- inferred equivalent call
T.callback = primitive("function") -- inferred equivalent call
T.none = primitive("nil") -- inferred equivalent call
T.string = primitive("string") -- inferred equivalent call
T.table = primitive("table") -- inferred equivalent call
T.userdata = primitive("userdata") -- inferred equivalent call

function T.number(p)
	local Typeof2 = Typeof(p)

	if Typeof2 ~= "number" then
		return false, string.format("number expected, got %s", Typeof2)
	end

	if p == p then
		return true
	end

	return false, "unexpected NaN value"
end

function T.nan(p)
	if p == p then
		return false, "unexpected non-NaN value"
	end

	return true
end

T.Axes = primitive("Axes") -- inferred equivalent call
T.BrickColor = primitive("BrickColor") -- inferred equivalent call
T.CFrame = primitive("CFrame") -- inferred equivalent call
T.Color3 = primitive("Color3") -- inferred equivalent call
T.ColorSequence = primitive("ColorSequence") -- inferred equivalent call
T.ColorSequenceKeypoint = primitive("ColorSequenceKeypoint") -- inferred equivalent call
T.DockWidgetPluginGuiInfo = primitive("DockWidgetPluginGuiInfo") -- inferred equivalent call
T.Faces = primitive("Faces") -- inferred equivalent call
T.Instance = primitive("Instance") -- inferred equivalent call
T.NumberRange = primitive("NumberRange") -- inferred equivalent call
T.NumberSequence = primitive("NumberSequence") -- inferred equivalent call
T.NumberSequenceKeypoint = primitive("NumberSequenceKeypoint") -- inferred equivalent call
T.PathWaypoint = primitive("PathWaypoint") -- inferred equivalent call
T.PhysicalProperties = primitive("PhysicalProperties") -- inferred equivalent call
T.Random = primitive("Random") -- inferred equivalent call
T.Ray = primitive("Ray") -- inferred equivalent call
T.Rect = primitive("Rect") -- inferred equivalent call
T.Region3 = primitive("Region3") -- inferred equivalent call
T.Region3int16 = primitive("Region3int16") -- inferred equivalent call
T.TweenInfo = primitive("TweenInfo") -- inferred equivalent call
T.UDim = primitive("UDim") -- inferred equivalent call
T.UDim2 = primitive("UDim2") -- inferred equivalent call
T.Vector2 = primitive("Vector2") -- inferred equivalent call
T.Vector3 = primitive("Vector3") -- inferred equivalent call
T.Vector3int16 = primitive("Vector3int16") -- inferred equivalent call
T.Enum = primitive("Enum") -- inferred equivalent call
T.EnumItem = primitive("EnumItem") -- inferred equivalent call
T.RBXScriptSignal = primitive("RBXScriptSignal") -- inferred equivalent call
T.RBXScriptConnection = primitive("RBXScriptConnection") -- inferred equivalent call

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

	return T.union(unpack(v2))
end

T.exactly = T.literal

function T.keyOf(items)
	local v = {}

	for k in pairs(items) do
		v[#v + 1] = k
	end

	return T.literal(unpack(v))
end

function T.valueOf(items)
	local v = {}

	for _, item in pairs(items) do
		v[#v + 1] = item
	end

	return T.literal(unpack(v))
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
	assert(T.number(p) and T.number(p2))
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
	assert(T.number(p) and T.number(p2))
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
			return false, string.format("\"%s\" failed to match pattern \"%s\"", value, p)
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

		for i = 1, #v do
			local v3, v4 = v[i](v2[i])

			if v3 == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, v4 or "")
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
	assert(T.callback(p), T.callback(p2))
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

		for _, _ in ipairs(list) do
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

local array = T.array(T.callback)

function T.union(...)
	local v = { ... }
	assert(array(v))
	return function(p)
		for _, v2 in pairs(v) do
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
		for _, v2 in pairs(v) do
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
				return false, string.format("[interface] unexpected field '%s'", (tostring(k)))
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

		for _, child in pairs(instance:GetChildren()) do
			local name = child.Name

			if not items[name] then
				continue
			end

			if childrenByName[name] then
				return false, string.format("Cannot process multiple children with the same name \"%s\"", name)
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
