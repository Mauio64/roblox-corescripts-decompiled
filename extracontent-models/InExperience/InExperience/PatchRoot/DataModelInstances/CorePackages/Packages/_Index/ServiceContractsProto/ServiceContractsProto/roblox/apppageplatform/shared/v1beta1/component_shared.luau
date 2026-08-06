local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local ui_component_type = require(script.Parent.ui_component_type)
local analytics_data = require(script.Parent.analytics_data)
local prop_types = require(script.Parent.prop_types)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 106
	-- upvalues: t2 (copy)
	return (setmetatable({
		hidden = if t3 ~= nil and t3.hidden ~= nil then t3.hidden else nil,
		label = if t3 ~= nil and t3.label ~= nil then t3.label else nil
	}, t2))
end
function t2.encode(p1) -- line: 113
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.hidden ~= nil then
		local v15 = p1.hidden:encode()
		local v16, v17 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v16, v17, v15, buffer.len(v15))
	end

	if p1.label ~= nil then
		local v18 = p1.label:encode()
		local v19, v20 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v19, v20, v18, buffer.len(v18))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 134
	-- upvalues: t2 (copy), proto (copy), prop_types (copy)
	local v23 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v25, v26

		v25, v26, n2 = proto.readTag(p2, n2)

		if v26 == proto.wireTypes.varint then
			local v27

			v27, n2 = proto.readVarInt(p2, n2)
		elseif v26 == proto.wireTypes.lengthDelimited then
			if v25 == 1 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v23.hidden = prop_types.BoolProp.decode(v28)
			elseif v25 == 2 then
				local v29

				v29, n2 = proto.readBuffer(p2, n2)
				v23.label = prop_types.StringProp.decode(v29)
			else
				local v30, v31 = proto.readVarInt(p2, n2)

				n2 = v31 + v30
			end
		elseif v26 == proto.wireTypes.i32 then
			local v32

			v32, n2 = proto.readFixed32(p2, n2)
		elseif v26 == proto.wireTypes.i64 then
			local v33

			v33, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v26)
		end
	end

	return v23
end
function t2.jsonEncode(p3) -- line: 182
	local t4 = {}

	if p3.hidden ~= nil then
		t4.hidden = p3.hidden:jsonEncode()
	end

	if p3.label ~= nil then
		t4.label = p3.label:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 196
	-- upvalues: t2 (copy), prop_types (copy)
	local v37 = t2.new()

	if t5.hidden ~= nil then
		v37.hidden = prop_types.BoolProp.jsonDecode(t5.hidden)
	end

	if t5.label ~= nil then
		v37.label = prop_types.StringProp.jsonDecode(t5.label)
	end

	return v37
end

t2.descriptor = {
	name = "AccessibilityProps",
	fullName = "roblox.apppageplatform.shared.v1beta1.AccessibilityProps"
}
t1.AccessibilityProps = t2
typeRegistry.default:register(t1.AccessibilityProps)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 224
	-- upvalues: ui_component_type (copy), t6 (copy)
	return (setmetatable({
		component_type = if t7 ~= nil and t7.component_type ~= nil then t7.component_type else assert(ui_component_type.UiComponentType.fromNumber(0), "Enum has no 0 default"),
		data = if t7 ~= nil and t7.data ~= nil then t7.data else {},
		analytics_data = if t7 ~= nil and t7.analytics_data ~= nil then t7.analytics_data else {},
		is_component_filtered = if t7 ~= nil and t7.is_component_filtered ~= nil then t7.is_component_filtered else nil,
		accessibility = if t7 ~= nil and t7.accessibility ~= nil then t7.accessibility else nil
	}, t6))
end
function t6.encode(p4) -- line: 241
	-- upvalues: ui_component_type (copy), proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.component_type ~= nil and (p4.component_type ~= nil and p4.component_type ~= 0 or p4.component_type ~= ui_component_type.UiComponentType.fromNumber(0)) then
		local v42, v43 = proto.writeTag(buf, n3, 1, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v42, v43, ui_component_type.UiComponentType.toNumber(p4.component_type))
	end

	if p4.data ~= nil and #p4.data > 0 then
		for _, v45 in p4.data do
			local v46 = v45:encode()
			local v47, v48 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v47, v48, v46, buffer.len(v46))
		end
	end

	if p4.analytics_data ~= nil and next(p4.analytics_data) ~= nil then
		for v49, v50 in p4.analytics_data do
			local buf3 = buffer.create(0)
			local v52, v53 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v54, v55 = proto.writeString(v52, v53, v49)
			local v56 = v50:encode()
			local v57, v58 = proto.writeTag(v54, v55, 2, proto.wireTypes.lengthDelimited)
			local v59, v60 = proto.writeBuffer(v57, v58, v56, buffer.len(v56))
			local v61, v62 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v61, v62, v59, v60)
		end
	end

	if p4.is_component_filtered ~= nil then
		local v63 = p4.is_component_filtered:encode()
		local v64, v65 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v64, v65, v63, buffer.len(v63))
	end

	if p4.accessibility ~= nil then
		local v66 = p4.accessibility:encode()
		local v67, v68 = proto.writeTag(buf, n3, 5, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v67, v68, v66, buffer.len(v66))
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t6.decode(p5: buffer) -- line: 302
	-- upvalues: t6 (copy), proto (copy), ui_component_type (copy), hydration_data_spec (copy), t1 (copy), analytics_data (copy), prop_types (copy)
	local v71 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v73, v74

		v73, v74, n4 = proto.readTag(p5, n4)

		if v74 == proto.wireTypes.varint then
			if v73 == 1 then
				local v75

				v75, n4 = proto.readVarIntI32(p5, n4)
				v71.component_type = ui_component_type.UiComponentType.fromNumber(v75) or v75
			else
				local v76

				v76, n4 = proto.readVarInt(p5, n4)
			end
		elseif v74 == proto.wireTypes.lengthDelimited then
			if v73 == 2 then
				local v77

				v77, n4 = proto.readBuffer(p5, n4)
				table.insert(v71.data, hydration_data_spec.HydrationDataSpec.decode(v77))
			elseif v73 == 3 then
				local v78

				v78, n4 = proto.readBuffer(p5, n4)

				local v79 = t1.ComponentShared_AnalyticsDataEntry.decode(v78)
				local v80 = analytics_data.AnalyticsDataField.new()

				v71.analytics_data[v79.key or ""] = v79.value or v80
			elseif v73 == 4 then
				local v81

				v81, n4 = proto.readBuffer(p5, n4)
				v71.is_component_filtered = prop_types.BoolProp.decode(v81)
			elseif v73 == 5 then
				local v82

				v82, n4 = proto.readBuffer(p5, n4)
				v71.accessibility = t1.AccessibilityProps.decode(v82)
			else
				local v83, v84 = proto.readVarInt(p5, n4)

				n4 = v84 + v83
			end
		elseif v74 == proto.wireTypes.i32 then
			local v85

			v85, n4 = proto.readFixed32(p5, n4)
		elseif v74 == proto.wireTypes.i64 then
			local v86

			v86, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v74)
		end
	end

	return v71
end
function t6.jsonEncode(p6) -- line: 379
	-- upvalues: ui_component_type (copy)
	local t8 = {}

	if p6.component_type ~= nil and (p6.component_type ~= nil and p6.component_type ~= 0 or p6.component_type ~= ui_component_type.UiComponentType.fromNumber(0)) then
		t8.componentType = if typeof(p6.component_type) ~= "number" then ui_component_type.UiComponentType.toNumber(p6.component_type) else p6.component_type
	end

	if p6.data ~= nil and #p6.data > 0 then
		local t9 = {}

		for _, v91 in p6.data do
			table.insert(t9, v91:jsonEncode())
		end

		t8.data = t9
	end

	if p6.analytics_data ~= nil and next(p6.analytics_data) ~= nil then
		local t10 = {}

		for v93, v94 in p6.analytics_data do
			t10[v93] = v94:jsonEncode()
		end

		t8.analyticsData = t10
	end

	if p6.is_component_filtered ~= nil then
		t8.isComponentFiltered = p6.is_component_filtered:jsonEncode()
	end

	if p6.accessibility ~= nil then
		t8.accessibility = p6.accessibility:jsonEncode()
	end

	return t8
end
function t6.jsonDecode(t11: {[any]: any}) -- line: 424
	-- upvalues: t6 (copy), ui_component_type (copy), hydration_data_spec (copy), analytics_data (copy), prop_types (copy), t1 (copy)
	local v96 = t6.new()

	if t11.component_type ~= nil then
		v96.component_type = if typeof(t11.component_type) ~= "number" then ui_component_type.UiComponentType.fromName(t11.component_type) or t11.component_type else ui_component_type.UiComponentType.fromNumber(t11.component_type) or t11.component_type
	end

	if t11.componentType ~= nil then
		v96.component_type = if typeof(t11.componentType) ~= "number" then ui_component_type.UiComponentType.fromName(t11.componentType) or t11.componentType else ui_component_type.UiComponentType.fromNumber(t11.componentType) or t11.componentType
	end

	if t11.data ~= nil then
		local t12 = {}

		for _, v99 in t11.data do
			table.insert(t12, hydration_data_spec.HydrationDataSpec.jsonDecode(v99))
		end

		v96.data = t12
	end

	if t11.analytics_data ~= nil then
		local t13 = {}

		for v101, v102 in t11.analytics_data do
			t13[v101] = analytics_data.AnalyticsDataField.jsonDecode(v102)
		end

		v96.analytics_data = t13
	end

	if t11.analyticsData ~= nil then
		local t14 = {}

		for v104, v105 in t11.analyticsData do
			t14[v104] = analytics_data.AnalyticsDataField.jsonDecode(v105)
		end

		v96.analytics_data = t14
	end

	if t11.is_component_filtered ~= nil then
		v96.is_component_filtered = prop_types.BoolProp.jsonDecode(t11.is_component_filtered)
	end

	if t11.isComponentFiltered ~= nil then
		v96.is_component_filtered = prop_types.BoolProp.jsonDecode(t11.isComponentFiltered)
	end

	if t11.accessibility ~= nil then
		v96.accessibility = t1.AccessibilityProps.jsonDecode(t11.accessibility)
	end

	return v96
end

t6.descriptor = {
	name = "ComponentShared",
	fullName = "roblox.apppageplatform.shared.v1beta1.ComponentShared"
}
t1.ComponentShared = t6
typeRegistry.default:register(t1.ComponentShared)

local t15 = {}

t15.__index = t15

function t15.new(t16: {[any]: any}?) -- line: 510
	-- upvalues: t15 (copy)
	return (setmetatable({
		key = if t16 ~= nil and t16.key ~= nil then t16.key else "",
		value = if t16 ~= nil and t16.value ~= nil then t16.value else nil
	}, t15))
end
function t15.encode(p7) -- line: 519
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v110, v111 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v110, v111, p7.key)
	end

	if p7.value ~= nil then
		local v112 = p7.value:encode()
		local v113, v114 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v113, v114, v112, buffer.len(v112))
	end

	local buf5 = buffer.create(n5)

	buffer.copy(buf5, 0, buf, 0, n5)

	return buf5
end
function t15.decode(p8: buffer) -- line: 539
	-- upvalues: t15 (copy), proto (copy), analytics_data (copy)
	local v117 = t15.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v119, v120

		v119, v120, n6 = proto.readTag(p8, n6)

		if v120 == proto.wireTypes.varint then
			local v121

			v121, n6 = proto.readVarInt(p8, n6)
		elseif v120 == proto.wireTypes.lengthDelimited then
			if v119 == 1 then
				local v122

				v122, n6 = proto.readBuffer(p8, n6)
				v117.key = buffer.tostring(v122)
			elseif v119 == 2 then
				local v123

				v123, n6 = proto.readBuffer(p8, n6)
				v117.value = analytics_data.AnalyticsDataField.decode(v123)
			else
				local v124, v125 = proto.readVarInt(p8, n6)

				n6 = v125 + v124
			end
		elseif v120 == proto.wireTypes.i32 then
			local v126

			v126, n6 = proto.readFixed32(p8, n6)
		elseif v120 == proto.wireTypes.i64 then
			local v127

			v127, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v120)
		end
	end

	return v117
end
function t15.jsonEncode(p9) -- line: 587
	local t17 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t17.key = p9.key
	end

	if p9.value ~= nil then
		t17.value = p9.value:jsonEncode()
	end

	return t17
end
function t15.jsonDecode(t18: {[any]: any}) -- line: 601
	-- upvalues: t15 (copy), analytics_data (copy)
	local v131 = t15.new()

	if t18.key ~= nil then
		v131.key = t18.key
	end

	if t18.value ~= nil then
		v131.value = analytics_data.AnalyticsDataField.jsonDecode(t18.value)
	end

	return v131
end

t15.descriptor = {
	name = "ComponentShared_AnalyticsDataEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsDataEntry"
}
t1.ComponentShared_AnalyticsDataEntry = t15
typeRegistry.default:register(t1.ComponentShared_AnalyticsDataEntry)

return {
	AccessibilityProps = t1.AccessibilityProps,
	ComponentShared = t1.ComponentShared
}
