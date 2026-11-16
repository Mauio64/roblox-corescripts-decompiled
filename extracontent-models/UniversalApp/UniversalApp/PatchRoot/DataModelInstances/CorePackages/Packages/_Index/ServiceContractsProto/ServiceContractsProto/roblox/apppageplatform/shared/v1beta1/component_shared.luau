local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local hydration_data_spec = require(script.Parent.hydration_data_spec)
local ui_component_type = require(script.Parent.ui_component_type)
local analytics_data = require(script.Parent.analytics_data)
local prop_types = require(script.Parent.prop_types)

local class = {}
class.__index = class

function class.new(p)
	local hidden

	if not (p == nil or p.hidden == nil) then
		hidden = p.hidden
	end

	local label

	if not (p == nil or p.label == nil) then
		label = p.label
	end

	return (setmetatable({ hidden = hidden, label = label }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.hidden ~= nil then
		local encoded = self.hidden:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.label ~= nil then
		local encoded = self.label:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local result = class.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hidden = prop_types.BoolProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.label = prop_types.StringProp.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class:jsonEncode()
	local v2 = {}

	if self.hidden ~= nil then
		v2.hidden = self.hidden:jsonEncode()
	end

	if self.label ~= nil then
		v2.label = self.label:jsonEncode()
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.hidden ~= nil then
		v2.hidden = prop_types.BoolProp.jsonDecode(p.hidden)
	end

	if p.label ~= nil then
		v2.label = prop_types.StringProp.jsonDecode(p.label)
	end

	return v2
end

class.descriptor = {
	name = "AccessibilityProps",
	fullName = "roblox.apppageplatform.shared.v1beta1.AccessibilityProps"
}

v.AccessibilityProps = class

typeRegistry.default:register(v.AccessibilityProps)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local component_type

	if data == nil or data.component_type == nil then
		component_type = assert(ui_component_type.UiComponentType.fromNumber(0), "Enum has no 0 default")
	else
		component_type = data.component_type
	end

	local v2 = {
		component_type = component_type,
		data = (data == nil or data.data == nil) and {} or data.data,
		analytics_data = (data == nil or data.analytics_data == nil) and {} or data.analytics_data,
		is_component_filtered = 0,
		accessibility = 0
	}
	local is_component_filtered

	if not (data == nil or data.is_component_filtered == nil) then
		is_component_filtered = data.is_component_filtered
	end

	v2.is_component_filtered = is_component_filtered
	local accessibility

	if not (data == nil or data.accessibility == nil) then
		accessibility = data.accessibility
	end

	v2.accessibility = accessibility
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if
		self.component_type ~= nil
		and (self.component_type ~= nil and self.component_type ~= 0 or self.component_type ~= ui_component_type.UiComponentType.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, ui_component_type.UiComponentType.toNumber(self.component_type))
	end

	if self.data ~= nil and #self.data > 0 then
		for _, v4 in self.data do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	if self.analytics_data ~= nil and next(self.analytics_data) ~= nil then
		for k, v4 in self.analytics_data do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.is_component_filtered ~= nil then
		local encoded = self.is_component_filtered:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.accessibility ~= nil then
		local encoded = self.accessibility:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.component_type = ui_component_type.UiComponentType.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.data, hydration_data_spec.HydrationDataSpec.decode(v5))
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.ComponentShared_AnalyticsDataEntry.decode(v5)

				local analyticsDataField = analytics_data.AnalyticsDataField.new()

				result.analytics_data[decoded.key or ""] = decoded.value or analyticsDataField
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.is_component_filtered = prop_types.BoolProp.decode(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.accessibility = v.AccessibilityProps.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class2:jsonEncode()
	local v2 = {}

	if
		self.component_type ~= nil
		and (self.component_type ~= nil and self.component_type ~= 0 or self.component_type ~= ui_component_type.UiComponentType.fromNumber(0))
	then
		local componentType

		if typeof(self.component_type) == "number" then
			componentType = self.component_type
		else
			componentType = ui_component_type.UiComponentType.toNumber(self.component_type)
		end

		v2.componentType = componentType
	end

	if self.data ~= nil and #self.data > 0 then
		local v3 = {}

		for _, v4 in self.data do
			table.insert(v3, v4:jsonEncode())
		end

		v2.data = v3
	end

	if self.analytics_data ~= nil and next(self.analytics_data) ~= nil then
		local analyticsData = {}

		for k, v3 in self.analytics_data do
			analyticsData[k] = v3:jsonEncode()
		end

		v2.analyticsData = analyticsData
	end

	if self.is_component_filtered ~= nil then
		v2.isComponentFiltered = self.is_component_filtered:jsonEncode()
	end

	if self.accessibility ~= nil then
		v2.accessibility = self.accessibility:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.component_type ~= nil then
		local component_type

		if typeof(data.component_type) == "number" then
			component_type = ui_component_type.UiComponentType.fromNumber(data.component_type) or data.component_type
		else
			component_type = ui_component_type.UiComponentType.fromName(data.component_type) or data.component_type
		end

		v2.component_type = component_type
	end

	if data.componentType ~= nil then
		local component_type

		if typeof(data.componentType) == "number" then
			component_type = ui_component_type.UiComponentType.fromNumber(data.componentType) or data.componentType
		else
			component_type = ui_component_type.UiComponentType.fromName(data.componentType) or data.componentType
		end

		v2.component_type = component_type
	end

	if data.data ~= nil then
		local v3 = {}

		for _, v4 in data.data do
			table.insert(v3, hydration_data_spec.HydrationDataSpec.jsonDecode(v4))
		end

		v2.data = v3
	end

	if data.analytics_data ~= nil then
		local analytics_data2 = {}

		for k, v3 in data.analytics_data do
			analytics_data2[k] = analytics_data.AnalyticsDataField.jsonDecode(v3)
		end

		v2.analytics_data = analytics_data2
	end

	if data.analyticsData ~= nil then
		local analytics_data2 = {}

		for k, v3 in data.analyticsData do
			analytics_data2[k] = analytics_data.AnalyticsDataField.jsonDecode(v3)
		end

		v2.analytics_data = analytics_data2
	end

	if data.is_component_filtered ~= nil then
		v2.is_component_filtered = prop_types.BoolProp.jsonDecode(data.is_component_filtered)
	end

	if data.isComponentFiltered ~= nil then
		v2.is_component_filtered = prop_types.BoolProp.jsonDecode(data.isComponentFiltered)
	end

	if data.accessibility ~= nil then
		v2.accessibility = v.AccessibilityProps.jsonDecode(data.accessibility)
	end

	return v2
end

class2.descriptor = {
	name = "ComponentShared",
	fullName = "roblox.apppageplatform.shared.v1beta1.ComponentShared"
}

v.ComponentShared = class2

typeRegistry.default:register(v.ComponentShared)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = analytics_data.AnalyticsDataField.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class3:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = analytics_data.AnalyticsDataField.jsonDecode(p.value)
	end

	return v2
end

class3.descriptor = {
	name = "ComponentShared_AnalyticsDataEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsDataEntry"
}

v.ComponentShared_AnalyticsDataEntry = class3

typeRegistry.default:register(v.ComponentShared_AnalyticsDataEntry)

return { AccessibilityProps = v.AccessibilityProps, ComponentShared = v.ComponentShared }
