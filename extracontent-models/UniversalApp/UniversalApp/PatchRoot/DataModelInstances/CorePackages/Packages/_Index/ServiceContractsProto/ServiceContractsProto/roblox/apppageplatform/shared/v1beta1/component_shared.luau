local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local ui_component_type = require(script.Parent.ui_component_type)
local analytics_data = require(script.Parent.analytics_data)
local prop_types = require(script.Parent.prop_types)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 104
	-- upvalues: t2 (copy)
	return (setmetatable({
		hidden = if t3 ~= nil and t3.hidden ~= nil then t3.hidden else nil
	}, t2))
end
function t2.encode(p1) -- line: 110
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.hidden ~= nil then
		local v15 = p1.hidden:encode()
		local v16, v17 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v16, v17, v15, buffer.len(v15))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 125
	-- upvalues: t2 (copy), proto (copy), prop_types (copy)
	local v20 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v22, v23

		v22, v23, n2 = proto.readTag(p2, n2)

		if v23 == proto.wireTypes.varint then
			local v24

			v24, n2 = proto.readVarInt(p2, n2)
		elseif v23 == proto.wireTypes.lengthDelimited then
			if v22 == 1 then
				local v25

				v25, n2 = proto.readBuffer(p2, n2)
				v20.hidden = prop_types.BoolProp.decode(v25)
			else
				local v26, v27 = proto.readVarInt(p2, n2)

				n2 = v27 + v26
			end
		elseif v23 == proto.wireTypes.i32 then
			local v28

			v28, n2 = proto.readFixed32(p2, n2)
		elseif v23 == proto.wireTypes.i64 then
			local v29

			v29, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v23)
		end
	end

	return v20
end
function t2.jsonEncode(p3) -- line: 168
	local t4 = {}

	if p3.hidden ~= nil then
		t4.hidden = p3.hidden:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 178
	-- upvalues: t2 (copy), prop_types (copy)
	local v33 = t2.new()

	if t5.hidden ~= nil then
		v33.hidden = prop_types.BoolProp.jsonDecode(t5.hidden)
	end

	return v33
end

t2.descriptor = {
	name = "AccessibilityProps",
	fullName = "roblox.apppageplatform.shared.v1beta1.AccessibilityProps"
}
t1.AccessibilityProps = t2
typeRegistry.default:register(t1.AccessibilityProps)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 202
	-- upvalues: ui_component_type (copy), t6 (copy)
	return (setmetatable({
		component_type = if t7 ~= nil and t7.component_type ~= nil then t7.component_type else assert(ui_component_type.UiComponentType.fromNumber(0), "Enum has no 0 default"),
		data = if t7 ~= nil and t7.data ~= nil then t7.data else {},
		analytics_data = if t7 ~= nil and t7.analytics_data ~= nil then t7.analytics_data else {},
		is_component_filtered = if t7 ~= nil and t7.is_component_filtered ~= nil then t7.is_component_filtered else nil,
		accessibility = if t7 ~= nil and t7.accessibility ~= nil then t7.accessibility else nil
	}, t6))
end
function t6.encode(p4) -- line: 219
	-- upvalues: ui_component_type (copy), proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.component_type ~= nil and (p4.component_type ~= nil and p4.component_type ~= 0 or p4.component_type ~= ui_component_type.UiComponentType.fromNumber(0)) then
		local v38, v39 = proto.writeTag(buf, n3, 1, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v38, v39, ui_component_type.UiComponentType.toNumber(p4.component_type))
	end

	if p4.data ~= nil and #p4.data > 0 then
		for _, v41 in p4.data do
			local v42 = v41:encode()
			local v43, v44 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v43, v44, v42, buffer.len(v42))
		end
	end

	if p4.analytics_data ~= nil and next(p4.analytics_data) ~= nil then
		for v45, v46 in p4.analytics_data do
			local buf3 = buffer.create(0)
			local v48, v49 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v50, v51 = proto.writeString(v48, v49, v45)
			local v52 = v46:encode()
			local v53, v54 = proto.writeTag(v50, v51, 2, proto.wireTypes.lengthDelimited)
			local v55, v56 = proto.writeBuffer(v53, v54, v52, buffer.len(v52))
			local v57, v58 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v57, v58, v55, v56)
		end
	end

	if p4.is_component_filtered ~= nil then
		local v59 = p4.is_component_filtered:encode()
		local v60, v61 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v60, v61, v59, buffer.len(v59))
	end

	if p4.accessibility ~= nil then
		local v62 = p4.accessibility:encode()
		local v63, v64 = proto.writeTag(buf, n3, 5, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v63, v64, v62, buffer.len(v62))
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t6.decode(p5: buffer) -- line: 280
	-- upvalues: t6 (copy), proto (copy), ui_component_type (copy), hydration_data_spec (copy), t1 (copy), analytics_data (copy), prop_types (copy)
	local v67 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v69, v70

		v69, v70, n4 = proto.readTag(p5, n4)

		if v70 == proto.wireTypes.varint then
			if v69 == 1 then
				local v71

				v71, n4 = proto.readVarIntI32(p5, n4)
				v67.component_type = ui_component_type.UiComponentType.fromNumber(v71) or v71
			else
				local v72

				v72, n4 = proto.readVarInt(p5, n4)
			end
		elseif v70 == proto.wireTypes.lengthDelimited then
			if v69 == 2 then
				local v73

				v73, n4 = proto.readBuffer(p5, n4)
				table.insert(v67.data, hydration_data_spec.HydrationDataSpec.decode(v73))
			elseif v69 == 3 then
				local v74

				v74, n4 = proto.readBuffer(p5, n4)

				local v75 = t1.ComponentShared_AnalyticsDataEntry.decode(v74)
				local v76 = analytics_data.AnalyticsDataField.new()

				v67.analytics_data[v75.key or ""] = v75.value or v76
			elseif v69 == 4 then
				local v77

				v77, n4 = proto.readBuffer(p5, n4)
				v67.is_component_filtered = prop_types.BoolProp.decode(v77)
			elseif v69 == 5 then
				local v78

				v78, n4 = proto.readBuffer(p5, n4)
				v67.accessibility = t1.AccessibilityProps.decode(v78)
			else
				local v79, v80 = proto.readVarInt(p5, n4)

				n4 = v80 + v79
			end
		elseif v70 == proto.wireTypes.i32 then
			local v81

			v81, n4 = proto.readFixed32(p5, n4)
		elseif v70 == proto.wireTypes.i64 then
			local v82

			v82, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v70)
		end
	end

	return v67
end
function t6.jsonEncode(p6) -- line: 357
	-- upvalues: ui_component_type (copy)
	local t8 = {}

	if p6.component_type ~= nil and (p6.component_type ~= nil and p6.component_type ~= 0 or p6.component_type ~= ui_component_type.UiComponentType.fromNumber(0)) then
		t8.componentType = if typeof(p6.component_type) ~= "number" then ui_component_type.UiComponentType.toNumber(p6.component_type) else p6.component_type
	end

	if p6.data ~= nil and #p6.data > 0 then
		local t9 = {}

		for _, v87 in p6.data do
			table.insert(t9, v87:jsonEncode())
		end

		t8.data = t9
	end

	if p6.analytics_data ~= nil and next(p6.analytics_data) ~= nil then
		local t10 = {}

		for v89, v90 in p6.analytics_data do
			t10[v89] = v90:jsonEncode()
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
function t6.jsonDecode(t11: {[any]: any}) -- line: 402
	-- upvalues: t6 (copy), ui_component_type (copy), hydration_data_spec (copy), analytics_data (copy), prop_types (copy), t1 (copy)
	local v92 = t6.new()

	if t11.component_type ~= nil then
		v92.component_type = if typeof(t11.component_type) ~= "number" then ui_component_type.UiComponentType.fromName(t11.component_type) or t11.component_type else ui_component_type.UiComponentType.fromNumber(t11.component_type) or t11.component_type
	end

	if t11.componentType ~= nil then
		v92.component_type = if typeof(t11.componentType) ~= "number" then ui_component_type.UiComponentType.fromName(t11.componentType) or t11.componentType else ui_component_type.UiComponentType.fromNumber(t11.componentType) or t11.componentType
	end

	if t11.data ~= nil then
		local t12 = {}

		for _, v95 in t11.data do
			table.insert(t12, hydration_data_spec.HydrationDataSpec.jsonDecode(v95))
		end

		v92.data = t12
	end

	if t11.analytics_data ~= nil then
		local t13 = {}

		for v97, v98 in t11.analytics_data do
			t13[v97] = analytics_data.AnalyticsDataField.jsonDecode(v98)
		end

		v92.analytics_data = t13
	end

	if t11.analyticsData ~= nil then
		local t14 = {}

		for v100, v101 in t11.analyticsData do
			t14[v100] = analytics_data.AnalyticsDataField.jsonDecode(v101)
		end

		v92.analytics_data = t14
	end

	if t11.is_component_filtered ~= nil then
		v92.is_component_filtered = prop_types.BoolProp.jsonDecode(t11.is_component_filtered)
	end

	if t11.isComponentFiltered ~= nil then
		v92.is_component_filtered = prop_types.BoolProp.jsonDecode(t11.isComponentFiltered)
	end

	if t11.accessibility ~= nil then
		v92.accessibility = t1.AccessibilityProps.jsonDecode(t11.accessibility)
	end

	return v92
end

t6.descriptor = {
	name = "ComponentShared",
	fullName = "roblox.apppageplatform.shared.v1beta1.ComponentShared"
}
t1.ComponentShared = t6
typeRegistry.default:register(t1.ComponentShared)

local t15 = {}

t15.__index = t15

function t15.new(t16: {[any]: any}?) -- line: 488
	-- upvalues: t15 (copy)
	return (setmetatable({
		key = if t16 ~= nil and t16.key ~= nil then t16.key else "",
		value = if t16 ~= nil and t16.value ~= nil then t16.value else nil
	}, t15))
end
function t15.encode(p7) -- line: 497
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v106, v107 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v106, v107, p7.key)
	end

	if p7.value ~= nil then
		local v108 = p7.value:encode()
		local v109, v110 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v109, v110, v108, buffer.len(v108))
	end

	local buf5 = buffer.create(n5)

	buffer.copy(buf5, 0, buf, 0, n5)

	return buf5
end
function t15.decode(p8: buffer) -- line: 517
	-- upvalues: t15 (copy), proto (copy), analytics_data (copy)
	local v113 = t15.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v115, v116

		v115, v116, n6 = proto.readTag(p8, n6)

		if v116 == proto.wireTypes.varint then
			local v117

			v117, n6 = proto.readVarInt(p8, n6)
		elseif v116 == proto.wireTypes.lengthDelimited then
			if v115 == 1 then
				local v118

				v118, n6 = proto.readBuffer(p8, n6)
				v113.key = buffer.tostring(v118)
			elseif v115 == 2 then
				local v119

				v119, n6 = proto.readBuffer(p8, n6)
				v113.value = analytics_data.AnalyticsDataField.decode(v119)
			else
				local v120, v121 = proto.readVarInt(p8, n6)

				n6 = v121 + v120
			end
		elseif v116 == proto.wireTypes.i32 then
			local v122

			v122, n6 = proto.readFixed32(p8, n6)
		elseif v116 == proto.wireTypes.i64 then
			local v123

			v123, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v116)
		end
	end

	return v113
end
function t15.jsonEncode(p9) -- line: 565
	local t17 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t17.key = p9.key
	end

	if p9.value ~= nil then
		t17.value = p9.value:jsonEncode()
	end

	return t17
end
function t15.jsonDecode(t18: {[any]: any}) -- line: 579
	-- upvalues: t15 (copy), analytics_data (copy)
	local v127 = t15.new()

	if t18.key ~= nil then
		v127.key = t18.key
	end

	if t18.value ~= nil then
		v127.value = analytics_data.AnalyticsDataField.jsonDecode(t18.value)
	end

	return v127
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
