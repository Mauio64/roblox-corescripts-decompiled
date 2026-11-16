local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local capabilities

	if not (data == nil or data.capabilities == nil) then
		capabilities = data.capabilities
	end

	local v2 = {
		capabilities = capabilities,
		categories = (data == nil or data.categories == nil) and {} or data.categories,
		comment = 0,
		metadata = 0
	}
	local comment

	if not (data == nil or data.comment == nil) then
		comment = data.comment
	end

	v2.comment = comment
	local metadata

	if not (data == nil or data.metadata == nil) then
		metadata = data.metadata
	end

	v2.metadata = metadata
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.capabilities ~= nil then
		local encoded = self.capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.categories ~= nil and #self.categories > 0 then
		for _, category in self.categories do
			local encoded = category:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.comment ~= nil then
		local encoded = self.comment:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.metadata ~= nil then
		local encoded = self.metadata:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
				result.capabilities = v.UniverseUserVoteFeedbackMetadataData_Capabilities.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.categories, v.UniverseUserVoteFeedbackMetadataData_Category.decode(v5))
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.comment = v.UniverseUserVoteFeedbackMetadataData_Comment.decode(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.metadata = v.UniverseUserVoteFeedbackMetadataData_Metadata.decode(v5)
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

	if self.capabilities ~= nil then
		v2.capabilities = self.capabilities:jsonEncode()
	end

	if self.categories ~= nil and #self.categories > 0 then
		local categories = {}

		for _, category in self.categories do
			table.insert(categories, category:jsonEncode())
		end

		v2.categories = categories
	end

	if self.comment ~= nil then
		v2.comment = self.comment:jsonEncode()
	end

	if self.metadata ~= nil then
		v2.metadata = self.metadata:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.capabilities ~= nil then
		v2.capabilities = v.UniverseUserVoteFeedbackMetadataData_Capabilities.jsonDecode(data.capabilities)
	end

	if data.categories ~= nil then
		local categories = {}

		for _, category in data.categories do
			table.insert(categories, v.UniverseUserVoteFeedbackMetadataData_Category.jsonDecode(category))
		end

		v2.categories = categories
	end

	if data.comment ~= nil then
		v2.comment = v.UniverseUserVoteFeedbackMetadataData_Comment.jsonDecode(data.comment)
	end

	if data.metadata ~= nil then
		v2.metadata = v.UniverseUserVoteFeedbackMetadataData_Metadata.jsonDecode(data.metadata)
	end

	return v2
end

class.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteFeedbackMetadataData"
}

v.UniverseUserVoteFeedbackMetadataData = class

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		can_submit_review = data ~= nil and data.can_submit_review ~= nil and data.can_submit_review,
		can_submit_comment = data ~= nil and data.can_submit_comment ~= nil and data.can_submit_comment,
		can_submit_category_options = 0
	}
	local can_submit_category_options

	if not (data == nil or data.can_submit_category_options == nil) then
		can_submit_category_options = data.can_submit_category_options
	end

	v2.can_submit_category_options = can_submit_category_options
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.can_submit_review then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.can_submit_review and 1 or 0)
	end

	if self.can_submit_comment then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.can_submit_comment and 1 or 0)
	end

	if self.can_submit_category_options ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.can_submit_category_options and 1 or 0)
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
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_submit_review = v5 ~= 0
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_submit_comment = v5 ~= 0
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_submit_category_options = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

	if self.can_submit_review then
		v2.canSubmitReview = self.can_submit_review
	end

	if self.can_submit_comment then
		v2.canSubmitComment = self.can_submit_comment
	end

	if self.can_submit_category_options ~= nil then
		v2.canSubmitCategoryOptions = self.can_submit_category_options
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.can_submit_review ~= nil then
		v2.can_submit_review = data.can_submit_review
	end

	if data.canSubmitReview ~= nil then
		v2.can_submit_review = data.canSubmitReview
	end

	if data.can_submit_comment ~= nil then
		v2.can_submit_comment = data.can_submit_comment
	end

	if data.canSubmitComment ~= nil then
		v2.can_submit_comment = data.canSubmitComment
	end

	if data.can_submit_category_options ~= nil then
		v2.can_submit_category_options = data.can_submit_category_options
	end

	if data.canSubmitCategoryOptions ~= nil then
		v2.can_submit_category_options = data.canSubmitCategoryOptions
	end

	return v2
end

class2.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Capabilities",
	fullName = "roblox.apppageplatform.shared.v1beta1.Capabilities"
}

v.UniverseUserVoteFeedbackMetadataData_Capabilities = class2

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData_Capabilities)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		type = (data == nil or data.type == nil) and "" or data.type,
		label = (data == nil or data.label == nil) and "" or data.label,
		allows_multiple_selections = data ~= nil and data.allows_multiple_selections ~= nil and data.allows_multiple_selections,
		options = (data == nil or data.options == nil) and {} or data.options
	}
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.type ~= nil and self.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type)
	end

	if self.label ~= nil and self.label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.label)
	end

	if self.allows_multiple_selections then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.allows_multiple_selections and 1 or 0)
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

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.allows_multiple_selections = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.label = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.options, v.UniverseUserVoteFeedbackMetadataData_Category_Option.decode(v5))
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

	if self.type ~= nil and self.type ~= "" then
		v2.type = self.type
	end

	if self.label ~= nil and self.label ~= "" then
		v2.label = self.label
	end

	if self.allows_multiple_selections then
		v2.allowsMultipleSelections = self.allows_multiple_selections
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

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.label ~= nil then
		v2.label = data.label
	end

	if data.allows_multiple_selections ~= nil then
		v2.allows_multiple_selections = data.allows_multiple_selections
	end

	if data.allowsMultipleSelections ~= nil then
		v2.allows_multiple_selections = data.allowsMultipleSelections
	end

	if data.options == nil then
		return v2
	end

	local options = {}

	for _, option in data.options do
		table.insert(options, v.UniverseUserVoteFeedbackMetadataData_Category_Option.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class3.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Category",
	fullName = "roblox.apppageplatform.shared.v1beta1.Category"
}

v.UniverseUserVoteFeedbackMetadataData_Category = class3

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData_Category)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		id = (p == nil or p.id == nil) and "" or p.id,
		label = (p == nil or p.label == nil) and "" or p.label
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.label ~= nil and self.label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.label)
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

function class4:jsonEncode()
	local v2 = {}

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.label ~= nil and self.label ~= "" then
		v2.label = self.label
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.id ~= nil then
		v2.id = p.id
	end

	if p.label ~= nil then
		v2.label = p.label
	end

	return v2
end

class4.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Category_Option",
	fullName = "roblox.apppageplatform.shared.v1beta1.Option"
}

v.UniverseUserVoteFeedbackMetadataData_Category_Option = class4

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData_Category_Option)

local class5 = {}
class5.__index = class5

function class5.new(data)
	return (setmetatable({
		label = (data == nil or data.label == nil) and "" or data.label,
		placeholder_text = (data == nil or data.placeholder_text == nil) and "" or data.placeholder_text,
		minimum_length = (data == nil or data.minimum_length == nil) and 0 or data.minimum_length,
		maximum_length = (data == nil or data.maximum_length == nil) and 0 or data.maximum_length
	}, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.label ~= nil and self.label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.label)
	end

	if self.placeholder_text ~= nil and self.placeholder_text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.placeholder_text)
	end

	if self.minimum_length ~= nil and self.minimum_length ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.minimum_length)
	end

	if self.maximum_length ~= nil and self.maximum_length ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.maximum_length)
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
			if v3 == 3 then
				local minimum_length
				minimum_length, v2 = proto.readVarIntI32(buf, v2)
				result.minimum_length = minimum_length
			elseif v3 == 4 then
				local maximum_length
				maximum_length, v2 = proto.readVarIntI32(buf, v2)
				result.maximum_length = maximum_length
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.label = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.placeholder_text = buffer.tostring(v5)
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

	if self.label ~= nil and self.label ~= "" then
		v2.label = self.label
	end

	if self.placeholder_text ~= nil and self.placeholder_text ~= "" then
		v2.placeholderText = self.placeholder_text
	end

	if self.minimum_length ~= nil and self.minimum_length ~= 0 then
		v2.minimumLength = self.minimum_length
	end

	if self.maximum_length ~= nil and self.maximum_length ~= 0 then
		v2.maximumLength = self.maximum_length
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.label ~= nil then
		v2.label = data.label
	end

	if data.placeholder_text ~= nil then
		v2.placeholder_text = data.placeholder_text
	end

	if data.placeholderText ~= nil then
		v2.placeholder_text = data.placeholderText
	end

	if data.minimum_length ~= nil then
		v2.minimum_length = data.minimum_length
	end

	if data.minimumLength ~= nil then
		v2.minimum_length = data.minimumLength
	end

	if data.maximum_length ~= nil then
		v2.maximum_length = data.maximum_length
	end

	if data.maximumLength ~= nil then
		v2.maximum_length = data.maximumLength
	end

	return v2
end

class5.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Comment",
	fullName = "roblox.apppageplatform.shared.v1beta1.Comment"
}

v.UniverseUserVoteFeedbackMetadataData_Comment = class5

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData_Comment)

local class6 = {}
class6.__index = class6

function class6.new(data)
	return (setmetatable({
		disclaimer_label = (data == nil or data.disclaimer_label == nil) and "" or data.disclaimer_label,
		submit_button_label = (data == nil or data.submit_button_label == nil) and "" or data.submit_button_label,
		form_title_label = (data == nil or data.form_title_label == nil) and "" or data.form_title_label
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.disclaimer_label ~= nil and self.disclaimer_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.disclaimer_label)
	end

	if self.submit_button_label ~= nil and self.submit_button_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.submit_button_label)
	end

	if self.form_title_label ~= nil and self.form_title_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.form_title_label)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
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
				result.disclaimer_label = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.submit_button_label = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.form_title_label = buffer.tostring(v5)
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

function class6:jsonEncode()
	local v2 = {}

	if self.disclaimer_label ~= nil and self.disclaimer_label ~= "" then
		v2.disclaimerLabel = self.disclaimer_label
	end

	if self.submit_button_label ~= nil and self.submit_button_label ~= "" then
		v2.submitButtonLabel = self.submit_button_label
	end

	if self.form_title_label ~= nil and self.form_title_label ~= "" then
		v2.formTitleLabel = self.form_title_label
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.disclaimer_label ~= nil then
		v2.disclaimer_label = data.disclaimer_label
	end

	if data.disclaimerLabel ~= nil then
		v2.disclaimer_label = data.disclaimerLabel
	end

	if data.submit_button_label ~= nil then
		v2.submit_button_label = data.submit_button_label
	end

	if data.submitButtonLabel ~= nil then
		v2.submit_button_label = data.submitButtonLabel
	end

	if data.form_title_label ~= nil then
		v2.form_title_label = data.form_title_label
	end

	if data.formTitleLabel ~= nil then
		v2.form_title_label = data.formTitleLabel
	end

	return v2
end

class6.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Metadata",
	fullName = "roblox.apppageplatform.shared.v1beta1.Metadata"
}

v.UniverseUserVoteFeedbackMetadataData_Metadata = class6

typeRegistry.default:register(v.UniverseUserVoteFeedbackMetadataData_Metadata)

return {
	UniverseUserVoteFeedbackMetadataData = v.UniverseUserVoteFeedbackMetadataData,
	UniverseUserVoteFeedbackMetadataData_Capabilities = v.UniverseUserVoteFeedbackMetadataData_Capabilities,
	UniverseUserVoteFeedbackMetadataData_Category = v.UniverseUserVoteFeedbackMetadataData_Category,
	UniverseUserVoteFeedbackMetadataData_Category_Option = v.UniverseUserVoteFeedbackMetadataData_Category_Option,
	UniverseUserVoteFeedbackMetadataData_Comment = v.UniverseUserVoteFeedbackMetadataData_Comment,
	UniverseUserVoteFeedbackMetadataData_Metadata = v.UniverseUserVoteFeedbackMetadataData_Metadata
}
