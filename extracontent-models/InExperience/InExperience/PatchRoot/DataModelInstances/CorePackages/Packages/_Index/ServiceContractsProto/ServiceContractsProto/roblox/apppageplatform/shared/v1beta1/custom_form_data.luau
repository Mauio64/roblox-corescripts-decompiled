local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local form_definition

	if not (data == nil or data.form_definition == nil) then
		form_definition = data.form_definition
	end

	local viewer_response

	if not (data == nil or data.viewer_response == nil) then
		viewer_response = data.viewer_response
	end

	local results

	if not (data == nil or data.results == nil) then
		results = data.results
	end

	local is_editable

	if not (data == nil or data.is_editable == nil) then
		is_editable = data.is_editable
	end

	local disabled_message

	if not (data == nil or data.disabled_message == nil) then
		disabled_message = data.disabled_message
	end

	return (setmetatable({
		form_definition = form_definition,
		viewer_response = viewer_response,
		results = results,
		is_editable = is_editable,
		disabled_message = disabled_message
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.form_definition ~= nil then
		local encoded = self.form_definition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.viewer_response ~= nil then
		local encoded = self.viewer_response:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.results ~= nil then
		local encoded = self.results:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.is_editable ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_editable and 1 or 0)
	end

	if self.disabled_message ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.disabled_message)
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
			if v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_editable = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.form_definition = v.CustomFormDefinitionData.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.viewer_response = v.CustomFormResponseData.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.results = v.CustomFormResultsData.decode(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.disabled_message = buffer.tostring(v5)
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

	if self.form_definition ~= nil then
		v2.formDefinition = self.form_definition:jsonEncode()
	end

	if self.viewer_response ~= nil then
		v2.viewerResponse = self.viewer_response:jsonEncode()
	end

	if self.results ~= nil then
		v2.results = self.results:jsonEncode()
	end

	if self.is_editable ~= nil then
		v2.isEditable = self.is_editable
	end

	if self.disabled_message ~= nil then
		v2.disabledMessage = self.disabled_message
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.form_definition ~= nil then
		v2.form_definition = v.CustomFormDefinitionData.jsonDecode(data.form_definition)
	end

	if data.formDefinition ~= nil then
		v2.form_definition = v.CustomFormDefinitionData.jsonDecode(data.formDefinition)
	end

	if data.viewer_response ~= nil then
		v2.viewer_response = v.CustomFormResponseData.jsonDecode(data.viewer_response)
	end

	if data.viewerResponse ~= nil then
		v2.viewer_response = v.CustomFormResponseData.jsonDecode(data.viewerResponse)
	end

	if data.results ~= nil then
		v2.results = v.CustomFormResultsData.jsonDecode(data.results)
	end

	if data.is_editable ~= nil then
		v2.is_editable = data.is_editable
	end

	if data.isEditable ~= nil then
		v2.is_editable = data.isEditable
	end

	if data.disabled_message ~= nil then
		v2.disabled_message = data.disabled_message
	end

	if data.disabledMessage ~= nil then
		v2.disabled_message = data.disabledMessage
	end

	return v2
end

class.descriptor = {
	name = "CustomFormData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormData"
}

v.CustomFormData = class

typeRegistry.default:register(v.CustomFormData)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		form_id = (data == nil or data.form_id == nil) and "" or data.form_id,
		title = 0,
		description = 0,
		sections = 0
	}
	local title

	if not (data == nil or data.title == nil) then
		title = data.title
	end

	v2.title = title
	local description

	if not (data == nil or data.description == nil) then
		description = data.description
	end

	v2.description = description
	v2.sections = (data == nil or data.sections == nil) and {} or data.sections
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.form_id ~= nil and self.form_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.form_id)
	end

	if self.title ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.title)
	end

	if self.description ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.description)
	end

	if self.sections ~= nil and #self.sections > 0 then
		for _, section in self.sections do
			local encoded = section:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.form_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.sections, v.CustomFormSectionData.decode(v5))
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

	if self.form_id ~= nil and self.form_id ~= "" then
		v2.formId = self.form_id
	end

	if self.title ~= nil then
		v2.title = self.title
	end

	if self.description ~= nil then
		v2.description = self.description
	end

	if self.sections == nil or not (#self.sections > 0) then
		return v2
	end

	local sections = {}

	for _, section in self.sections do
		table.insert(sections, section:jsonEncode())
	end

	v2.sections = sections

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.form_id ~= nil then
		v2.form_id = data.form_id
	end

	if data.formId ~= nil then
		v2.form_id = data.formId
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.sections == nil then
		return v2
	end

	local sections = {}

	for _, section in data.sections do
		table.insert(sections, v.CustomFormSectionData.jsonDecode(section))
	end

	v2.sections = sections

	return v2
end

class2.descriptor = {
	name = "CustomFormDefinitionData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormDefinitionData"
}

v.CustomFormDefinitionData = class2

typeRegistry.default:register(v.CustomFormDefinitionData)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		header = 0,
		fields = 0
	}
	local header

	if not (data == nil or data.header == nil) then
		header = data.header
	end

	v2.header = header
	v2.fields = (data == nil or data.fields == nil) and {} or data.fields
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.header ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.header)
	end

	if self.fields ~= nil and #self.fields > 0 then
		for _, field in self.fields do
			local encoded = field:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.header = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.fields, v.CustomFormFieldData.decode(v5))
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

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.header ~= nil then
		v2.header = self.header
	end

	if self.fields == nil or not (#self.fields > 0) then
		return v2
	end

	local fields = {}

	for _, field in self.fields do
		table.insert(fields, field:jsonEncode())
	end

	v2.fields = fields

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.header ~= nil then
		v2.header = data.header
	end

	if data.fields == nil then
		return v2
	end

	local fields = {}

	for _, field in data.fields do
		table.insert(fields, v.CustomFormFieldData.jsonDecode(field))
	end

	v2.fields = fields

	return v2
end

class3.descriptor = {
	name = "CustomFormSectionData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormSectionData"
}

v.CustomFormSectionData = class3

typeRegistry.default:register(v.CustomFormSectionData)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		field_id = (data == nil or data.field_id == nil) and "" or data.field_id,
		field_type = 0,
		label = 0,
		options = 0
	}
	local field_type

	if data == nil or data.field_type == nil then
		field_type = assert(v.CustomFormFieldType.fromNumber(0), "Enum has no 0 default")
	else
		field_type = data.field_type
	end

	v2.field_type = field_type
	local label

	if not (data == nil or data.label == nil) then
		label = data.label
	end

	v2.label = label
	v2.options = (data == nil or data.options == nil) and {} or data.options
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field_id ~= nil and self.field_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field_id)
	end

	if
		self.field_type ~= nil
		and (self.field_type ~= nil and self.field_type ~= 0 or self.field_type ~= v.CustomFormFieldType.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

		v2, v3 = proto.writeVarInt(v4, v5, v.CustomFormFieldType.toNumber(self.field_type))
	end

	if self.label ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.label)
	end

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.field_type = v.CustomFormFieldType.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.label = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.options, v.CustomFormOptionData.decode(v5))
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

function class4:jsonEncode()
	local v2 = {}

	if self.field_id ~= nil and self.field_id ~= "" then
		v2.fieldId = self.field_id
	end

	if
		self.field_type ~= nil
		and (self.field_type ~= nil and self.field_type ~= 0 or self.field_type ~= v.CustomFormFieldType.fromNumber(0))
	then
		local fieldType

		if typeof(self.field_type) == "number" then
			fieldType = self.field_type
		else
			fieldType = v.CustomFormFieldType.toNumber(self.field_type)
		end

		v2.fieldType = fieldType
	end

	if self.label ~= nil then
		v2.label = self.label
	end

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.field_id ~= nil then
		v2.field_id = data.field_id
	end

	if data.fieldId ~= nil then
		v2.field_id = data.fieldId
	end

	if data.field_type ~= nil then
		local field_type

		if typeof(data.field_type) == "number" then
			field_type = v.CustomFormFieldType.fromNumber(data.field_type) or data.field_type
		else
			field_type = v.CustomFormFieldType.fromName(data.field_type) or data.field_type
		end

		v2.field_type = field_type
	end

	if data.fieldType ~= nil then
		local field_type

		if typeof(data.fieldType) == "number" then
			field_type = v.CustomFormFieldType.fromNumber(data.fieldType) or data.fieldType
		else
			field_type = v.CustomFormFieldType.fromName(data.fieldType) or data.fieldType
		end

		v2.field_type = field_type
	end

	if data.label ~= nil then
		v2.label = data.label
	end

	if data.options == nil then
		return v2
	end

	local options = {}

	for _, option in data.options do
		table.insert(options, v.CustomFormOptionData.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class4.descriptor = {
	name = "CustomFormFieldData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormFieldData"
}

v.CustomFormFieldData = class4

typeRegistry.default:register(v.CustomFormFieldData)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		option_id = (p == nil or p.option_id == nil) and "" or p.option_id,
		label = (p == nil or p.label == nil) and "" or p.label
	}, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.option_id ~= nil and self.option_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.option_id)
	end

	if self.label ~= nil and self.label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.label)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
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
				result.option_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.label = buffer.tostring(v5)
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

function class5:jsonEncode()
	local v2 = {}

	if self.option_id ~= nil and self.option_id ~= "" then
		v2.optionId = self.option_id
	end

	if self.label ~= nil and self.label ~= "" then
		v2.label = self.label
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.option_id ~= nil then
		v2.option_id = data.option_id
	end

	if data.optionId ~= nil then
		v2.option_id = data.optionId
	end

	if data.label ~= nil then
		v2.label = data.label
	end

	return v2
end

class5.descriptor = {
	name = "CustomFormOptionData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormOptionData"
}

v.CustomFormOptionData = class5

typeRegistry.default:register(v.CustomFormOptionData)

local class6 = {}
class6.__index = class6

function class6.new(p)
	return (setmetatable({
		answers = (p == nil or p.answers == nil) and {} or p.answers
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.answers ~= nil and #self.answers > 0 then
		for _, answer in self.answers do
			local encoded = answer:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local v2 = class6.new()
	local v3 = 0

	while v3 < buffer.len(buf) do
		local v4, v5
		v4, v5, v3 = proto.readTag(buf, v3)

		if v5 == proto.wireTypes.varint then
			local _
			_, v3 = proto.readVarInt(buf, v3)
		elseif v5 == proto.wireTypes.lengthDelimited then
			if v4 == 1 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)
				table.insert(v2.answers, v.CustomFormAnswerData.decode(v6))
			else
				local varInt, v6 = proto.readVarInt(buf, v3)

				v3 = v6 + varInt
			end
		elseif v5 == proto.wireTypes.i32 then
			local _
			_, v3 = proto.readFixed32(buf, v3)
		elseif v5 == proto.wireTypes.i64 then
			local _
			_, v3 = proto.readFixed64(buf, v3)
		else
			error("Unsupported wire type: " .. v5)
		end
	end

	return v2
end

function class6:jsonEncode()
	local v2 = {}

	if self.answers == nil or not (#self.answers > 0) then
		return v2
	end

	local answers = {}

	for _, answer in self.answers do
		table.insert(answers, answer:jsonEncode())
	end

	v2.answers = answers

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.answers == nil then
		return v2
	end

	local answers = {}

	for _, answer in p.answers do
		table.insert(answers, v.CustomFormAnswerData.jsonDecode(answer))
	end

	v2.answers = answers

	return v2
end

class6.descriptor = {
	name = "CustomFormResponseData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormResponseData"
}

v.CustomFormResponseData = class6

typeRegistry.default:register(v.CustomFormResponseData)

local class7 = {}
class7.__index = class7

function class7.new(p)
	return (setmetatable({
		field_id = (p == nil or p.field_id == nil) and "" or p.field_id,
		option_ids = (p == nil or p.option_ids == nil) and {} or p.option_ids
	}, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field_id ~= nil and self.field_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field_id)
	end

	if self.option_ids ~= nil and #self.option_ids > 0 then
		for _, option_id in self.option_ids do
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, option_id)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local result = class7.new()
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
				result.field_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.option_ids, buffer.tostring(v5))
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

function class7:jsonEncode()
	local v2 = {}

	if self.field_id ~= nil and self.field_id ~= "" then
		v2.fieldId = self.field_id
	end

	if self.option_ids == nil or not (#self.option_ids > 0) then
		return v2
	end

	local option_ids = {}

	for _, option_id in self.option_ids do
		table.insert(option_ids, option_id)
	end

	v2.optionIds = option_ids

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.field_id ~= nil then
		v2.field_id = data.field_id
	end

	if data.fieldId ~= nil then
		v2.field_id = data.fieldId
	end

	if data.option_ids ~= nil then
		local option_ids = {}

		for _, option_id in data.option_ids do
			table.insert(option_ids, option_id)
		end

		v2.option_ids = option_ids
	end

	if data.optionIds == nil then
		return v2
	end

	local optionIds = {}

	for _, optionId in data.optionIds do
		table.insert(optionIds, optionId)
	end

	v2.option_ids = optionIds

	return v2
end

class7.descriptor = {
	name = "CustomFormAnswerData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormAnswerData"
}

v.CustomFormAnswerData = class7

typeRegistry.default:register(v.CustomFormAnswerData)

local class8 = {}
class8.__index = class8

function class8.new(p)
	return (setmetatable({
		total_responses = (p == nil or p.total_responses == nil) and 0 or p.total_responses,
		field_results = (p == nil or p.field_results == nil) and {} or p.field_results
	}, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.total_responses ~= nil and self.total_responses ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total_responses)
	end

	if self.field_results ~= nil and #self.field_results > 0 then
		for _, field_result in self.field_results do
			local encoded = field_result:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local result = class8.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local total_responses
				total_responses, v2 = proto.readVarIntI64(buf, v2)
				result.total_responses = total_responses
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.field_results, v.CustomFormFieldResultData.decode(v5))
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

function class8:jsonEncode()
	local v2 = {}

	if self.total_responses ~= nil and self.total_responses ~= 0 then
		v2.totalResponses = self.total_responses
	end

	if self.field_results == nil or not (#self.field_results > 0) then
		return v2
	end

	local fieldResults = {}

	for _, field_result in self.field_results do
		table.insert(fieldResults, field_result:jsonEncode())
	end

	v2.fieldResults = fieldResults

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.total_responses ~= nil then
		v2.total_responses = data.total_responses
	end

	if data.totalResponses ~= nil then
		v2.total_responses = data.totalResponses
	end

	if data.field_results ~= nil then
		local field_results = {}

		for _, field_result in data.field_results do
			table.insert(field_results, v.CustomFormFieldResultData.jsonDecode(field_result))
		end

		v2.field_results = field_results
	end

	if data.fieldResults == nil then
		return v2
	end

	local field_results = {}

	for _, fieldResult in data.fieldResults do
		table.insert(field_results, v.CustomFormFieldResultData.jsonDecode(fieldResult))
	end

	v2.field_results = field_results

	return v2
end

class8.descriptor = {
	name = "CustomFormResultsData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormResultsData"
}

v.CustomFormResultsData = class8

typeRegistry.default:register(v.CustomFormResultsData)

local class9 = {}
class9.__index = class9

function class9.new(p)
	return (setmetatable({
		field_id = (p == nil or p.field_id == nil) and "" or p.field_id,
		option_results = (p == nil or p.option_results == nil) and {} or p.option_results
	}, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field_id ~= nil and self.field_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field_id)
	end

	if self.option_results ~= nil and #self.option_results > 0 then
		for _, option_result in self.option_results do
			local encoded = option_result:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class9.decode(buf: buffer)
	local result = class9.new()
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
				result.field_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.option_results, v.CustomFormOptionResultData.decode(v5))
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

function class9:jsonEncode()
	local v2 = {}

	if self.field_id ~= nil and self.field_id ~= "" then
		v2.fieldId = self.field_id
	end

	if self.option_results == nil or not (#self.option_results > 0) then
		return v2
	end

	local optionResults = {}

	for _, option_result in self.option_results do
		table.insert(optionResults, option_result:jsonEncode())
	end

	v2.optionResults = optionResults

	return v2
end

function class9.jsonDecode(data)
	local v2 = class9.new()

	if data.field_id ~= nil then
		v2.field_id = data.field_id
	end

	if data.fieldId ~= nil then
		v2.field_id = data.fieldId
	end

	if data.option_results ~= nil then
		local option_results = {}

		for _, option_result in data.option_results do
			table.insert(option_results, v.CustomFormOptionResultData.jsonDecode(option_result))
		end

		v2.option_results = option_results
	end

	if data.optionResults == nil then
		return v2
	end

	local option_results = {}

	for _, optionResult in data.optionResults do
		table.insert(option_results, v.CustomFormOptionResultData.jsonDecode(optionResult))
	end

	v2.option_results = option_results

	return v2
end

class9.descriptor = {
	name = "CustomFormFieldResultData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormFieldResultData"
}

v.CustomFormFieldResultData = class9

typeRegistry.default:register(v.CustomFormFieldResultData)

local class10 = {}
class10.__index = class10

function class10.new(data)
	return (setmetatable({
		option_id = (data == nil or data.option_id == nil) and "" or data.option_id,
		vote_count = (data == nil or data.vote_count == nil) and 0 or data.vote_count,
		percentage = (data == nil or data.percentage == nil) and 0 or data.percentage
	}, class10))
end

function class10:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.option_id ~= nil and self.option_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.option_id)
	end

	if self.vote_count ~= nil and self.vote_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.vote_count)
	end

	if self.percentage ~= nil and self.percentage ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.percentage)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class10.decode(buf: buffer)
	local result = class10.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local vote_count
				vote_count, v2 = proto.readVarIntI64(buf, v2)
				result.vote_count = vote_count
			elseif v3 == 3 then
				local percentage
				percentage, v2 = proto.readVarIntI32(buf, v2)
				result.percentage = percentage
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.option_id = buffer.tostring(v5)
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

function class10:jsonEncode()
	local v2 = {}

	if self.option_id ~= nil and self.option_id ~= "" then
		v2.optionId = self.option_id
	end

	if self.vote_count ~= nil and self.vote_count ~= 0 then
		v2.voteCount = self.vote_count
	end

	if self.percentage ~= nil and self.percentage ~= 0 then
		v2.percentage = self.percentage
	end

	return v2
end

function class10.jsonDecode(data)
	local v2 = class10.new()

	if data.option_id ~= nil then
		v2.option_id = data.option_id
	end

	if data.optionId ~= nil then
		v2.option_id = data.optionId
	end

	if data.vote_count ~= nil then
		v2.vote_count = data.vote_count
	end

	if data.voteCount ~= nil then
		v2.vote_count = data.voteCount
	end

	if data.percentage ~= nil then
		v2.percentage = data.percentage
	end

	return v2
end

class10.descriptor = {
	name = "CustomFormOptionResultData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomFormOptionResultData"
}

v.CustomFormOptionResultData = class10

typeRegistry.default:register(v.CustomFormOptionResultData)

v.CustomFormFieldType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "CUSTOM_FORM_FIELD_TYPE_INVALID"
		elseif p == 1 then
			return "CUSTOM_FORM_FIELD_TYPE_RADIO"
		elseif p == 2 then
			return "CUSTOM_FORM_FIELD_TYPE_CHECKBOX"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "CUSTOM_FORM_FIELD_TYPE_INVALID" then
			return 0
		elseif p == "CUSTOM_FORM_FIELD_TYPE_RADIO" then
			return 1
		elseif p == "CUSTOM_FORM_FIELD_TYPE_CHECKBOX" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "CUSTOM_FORM_FIELD_TYPE_INVALID" then
			return "CUSTOM_FORM_FIELD_TYPE_INVALID"
		elseif p == "CUSTOM_FORM_FIELD_TYPE_RADIO" then
			return "CUSTOM_FORM_FIELD_TYPE_RADIO"
		elseif p == "CUSTOM_FORM_FIELD_TYPE_CHECKBOX" then
			return "CUSTOM_FORM_FIELD_TYPE_CHECKBOX"
		end

		return nil
	end
}

return {
	CustomFormData = v.CustomFormData,
	CustomFormDefinitionData = v.CustomFormDefinitionData,
	CustomFormSectionData = v.CustomFormSectionData,
	CustomFormFieldData = v.CustomFormFieldData,
	CustomFormOptionData = v.CustomFormOptionData,
	CustomFormResponseData = v.CustomFormResponseData,
	CustomFormAnswerData = v.CustomFormAnswerData,
	CustomFormResultsData = v.CustomFormResultsData,
	CustomFormFieldResultData = v.CustomFormFieldResultData,
	CustomFormOptionResultData = v.CustomFormOptionResultData,
	CustomFormFieldType = v.CustomFormFieldType
}
